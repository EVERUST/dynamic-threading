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

        /*
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.inc();
        }
        */
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
        shuffled_order.wait_for_green_light(tid.clone(), func_num);
        __write_log(tid, func_num, func_name, line, var_addr, file_path);
        shuffled_order.cvar.notify_all();
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
    order:Mutex<VecDeque<String>>,
    next_exe:RwLock<String>,
    cvar:Condvar,
    m:Mutex<()>,
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
        let next_exe_init = order.pop_front().unwrap();

        _ShuffledOrder{
            order:Mutex::new(order),
            next_exe:RwLock::new(next_exe_init),
            cvar: Condvar::new(),
            m: Mutex::new(()),
        }
    }

    /*
        waits for the "green light", if the light is set, the function changes the next-should-be-run
        function name, and exit the function. the caller must notify other threads to check undated order.
    */
    fn wait_for_green_light(&self, tid:String, func_num:i32) {
        let my_order = format!("{}-{}", tid, func_num).to_owned();

        let mut guard = self.m.lock().unwrap();
        let mut next_exe_guard = self.next_exe.read().unwrap();

        while *next_exe_guard != my_order {
            drop(next_exe_guard);
            guard = self.cvar.wait(guard).unwrap();
            next_exe_guard = self.next_exe.read().unwrap();
        }
        // to avoid read -> write deadlock
        drop(next_exe_guard);

        // trying to prevent the race between previous thread and current thread
        thread::sleep(Duration::from_millis(20));

		let mut order_queue = self.order.lock().unwrap();
		match order_queue.pop_front(){
			Some(next_exe_num) => {
				let mut w = self.next_exe.write().unwrap();
				*w = next_exe_num;
			},
			None => { /* it was the last of the vecdeque */ },
		}
    }
}
