use std::{
    sync::{ Arc, Condvar, Mutex, RwLock, },
    fs::{OpenOptions, File},
    io::prelude::*,
    thread,
    ffi::CStr,
    os::raw::{c_char, c_int},
    collections::VecDeque,
    time::Duration,
    cell::RefCell,
    panic,
    process,
};

// file stream to log
static mut _PROBE_FP:Option<Arc<Mutex<File>>> = None;
// semaphore for allowing only one spawning thread at a time
static mut _PROBE_THRD_SEM:Option<Arc<_ProbeSemaphore>> = None;
// for keeping track of parent thread id
static mut _PROBE_NEW_THREAD_ID:Option<String> = None;
// the input order file
static mut _SHUFFLED_ORDER:Option<Arc<_ShuffledOrder>> = None;

extern {
    fn atexit(callback: fn()) -> c_int;
}

thread_local! {
    static TID:RefCell<String> = RefCell::new(String::from("none"));
    static CHILD_ID:RefCell<i32> = RefCell::new(1);
}

pub fn _init_(){
    unsafe{
        _PROBE_THRD_SEM = Some(Arc::new(_ProbeSemaphore::new(1))); // allow only 1 thread
        _PROBE_FP = Some(Arc::new(Mutex::new(OpenOptions::new()
                                            .write(true)
                                            .create(true)
                                            //.append(true)
                                            .open("log")
                                            .unwrap())));
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "---------------------From _init_---------------------\n").expect("write failed\n");
            write!(file_stream, "tid: 1        | func_name: main\n").expect("write failed\n"); 
        }
        atexit(_final_);
    }
    match OpenOptions::new().read(true).open("scenario") {
        Ok(mut shuffle_stream) => {
            let mut shuffle_order_str = String::new();
            shuffle_stream.read_to_string(&mut shuffle_order_str).expect("fail to read from file\n");
            unsafe{
                _SHUFFLED_ORDER = Some(Arc::new(_ShuffledOrder::new(shuffle_order_str)));
            }
        }
        Err(_) => {
            println!("MSG FROM TLE: FAIL TO READ SCENARIO, EXITING...");
            std::process::exit(1);
        }
    }

    TID.with(|tid|{
        tid.replace(String::from("1"));
    });

    //this panic hook might change the semantics of the panic hanlder of the target code  
    let ori_hook = panic::take_hook();
    panic::set_hook(Box::new(move |panic_info| {
        ori_hook(panic_info);
        process::exit(1);
    }));
}

pub fn _final_(){
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "---------------------From _final---------------------\n").expect("write failed\n");
        }
    }
}

pub fn _probe_mutex_(line:i32, func_num:i32, func_name:*const c_char, lock_var_addr:*mut u64, file_path:*const c_char){
    unsafe{
        TID.with(|tid| {
            let func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
            let file_path_str = CStr::from_ptr(file_path).to_str().unwrap();
            __traffic_light(tid.borrow().to_string(), func_name_str, line, func_num, Some(lock_var_addr), Some(file_path_str));
        });
    }
}

pub fn _probe_func_(line:i32, func_num:i32, func_name:*const c_char, file_path:*const c_char){
    unsafe{
        TID.with(|tid| {
            let func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
            let file_path_str = CStr::from_ptr(file_path).to_str().unwrap();
            __traffic_light(tid.borrow().to_string(), func_name_str, line, func_num, None, Some(file_path_str));
        });
    }
}

pub fn _probe_spawning_(line:i32, func_num:i32, file_path:*const c_char){
    unsafe{
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.dec();
        }
        TID.with(|tid| {
            CHILD_ID.with(|child_id| {
                let mut child_id = child_id.borrow_mut();
                _PROBE_NEW_THREAD_ID= Some(format!("{}.{}", &tid.borrow(), child_id));
                *child_id += 1;
            });

            let file_path_str = CStr::from_ptr(file_path).to_str().unwrap();
            __traffic_light(tid.borrow().to_string(), "spawning", line, func_num, None, Some(file_path_str));
        });
    }
}

pub fn _probe_spawned_(line:i32, func_num:i32){
    unsafe{
        TID.with(|tid| {
            if let Some(new_thread_id) = &_PROBE_NEW_THREAD_ID {
                tid.replace(new_thread_id.to_owned());
            }
            if let Some(sema) = &_PROBE_THRD_SEM{
                sema.inc();
            }

            __traffic_light(tid.borrow().to_string(), "spawned", line, func_num, None, None);

        });
    }
}

unsafe fn __write_log(tid:String, func_num:i32, func_name:&str, line:i32, var_addr:Option<*const u64>, file_path:Option<&str>){
    if let Some(fp_arc) = &_PROBE_FP{
        let mut file_stream = fp_arc.lock().unwrap();
        let file_path:String = match file_path {
            Some(path) => {
                let mut str_vec:Vec<&str> = path.split("/").collect();
                let mut i = 0;
                while i < str_vec.len() {
                    if str_vec[i] == ".." {
                        str_vec.remove(i);
                        str_vec.remove(i-1);
                        i -= 2;
                    }
                    i += 1;
                }
                str_vec.join("/")
            },
            None => String::from("None"),
        };
        match var_addr {
            Some(var_addr) => {
                write!(file_stream, "tid: {:<8} | func_num {:<3} | func_name: {:<8} | lock_var_addr: {:<10?} | {} : {}\n", 
                            tid, func_num, func_name, var_addr, file_path, line).expect("write failed\n");
            },
            None => {
                write!(file_stream, "tid: {:<8} | func_num {:<3} | func_name: {:<8} | lock_var_addr: {:<10} | {} : {}\n", 
                            tid, func_num, func_name, "None", file_path, line).expect("write failed\n");
            },
        }
    }
}

unsafe fn __traffic_light(tid:String, func_name:&str, line:i32, func_num:i32, var_addr:Option<*const u64>, file_path:Option<&str>){
    if let Some(shuffled_order) = &_SHUFFLED_ORDER {
        let my_order = format!("{}-{}", tid, func_num);
        let mut next_exe_guard = shuffled_order.order_queue.lock().unwrap();

        println!("\tentered : {}", my_order);
        while *next_exe_guard.front().unwrap() != my_order {
			println!("\t{} sleeping", my_order);
            next_exe_guard = shuffled_order.cvar.wait(next_exe_guard).unwrap();
            println!("\twaiting : {}, next : {}", my_order, *next_exe_guard.front().unwrap());
        }

        _ = next_exe_guard.pop_front();

        __write_log(tid, func_num, func_name, line, var_addr, file_path);
        shuffled_order.cvar.notify_one();
        println!("curr : {}, next : {}, addr : {:p}, cvar : {:p}", my_order, *next_exe_guard.front().unwrap(), &_SHUFFLED_ORDER, &shuffled_order.cvar);
        drop(next_exe_guard);
    }
}

/*
    Semaphore needed for syncing spawning.
    If there is race between spawnings, it is really difficult to find out the parent of a spawned thread.
*/

struct _ProbeSemaphore {
    mutex: Mutex<i32>,
    cvar: Condvar,
}
impl _ProbeSemaphore {
    fn new(count: i32) -> Self {
        _ProbeSemaphore {
            mutex: Mutex::new(count),
            cvar: Condvar::new(),
        }
    }
    fn dec(&self) {
        let mut lock = self.mutex.lock().unwrap();
        *lock -= 1;
        while *lock < 0 {
            lock = self.cvar.wait(lock).unwrap();
        }
    }
    fn inc(&self) {
        let mut lock = self.mutex.lock().unwrap();
        *lock += 1;
        if *lock <= 0 {
            self.cvar.notify_one();
        }
    }
}
unsafe impl Send for _ProbeSemaphore {}
unsafe impl Sync for _ProbeSemaphore {}

struct _ShuffledOrder {
    cvar:Condvar,
    order_queue:Mutex<VecDeque<String>>,
}

impl _ShuffledOrder {
    fn new(shuffle_order_str:String) -> Self {
        let mut order = VecDeque::new();
        let str_vec:Vec<&str> = shuffle_order_str.split("+").collect();
        for str_order in str_vec {
            if str_order == "\n" {
                continue;
            }
            order.push_back(String::from(str_order));
        }

        _ShuffledOrder{
            cvar: Condvar::new(),
            order_queue:Mutex::new(order),
        }
    }
}
