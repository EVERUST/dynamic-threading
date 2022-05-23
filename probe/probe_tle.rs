use std::{
    sync::{ Arc, Condvar, Mutex, RwLock, },
    fs::{OpenOptions, File},
    io::prelude::*,
    thread,
    ffi::CStr,
    os::raw::{c_char, c_int},
    collections::VecDeque,
    fmt,
    time::Duration,
    cell::RefCell,
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
                                            .append(true)
                                            .open("log")
                                            .unwrap())));
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "---------------------From _init_---------------------\n").expect("write failed\n");
            // calling thread::current().id() returns None... lead to assertion fail
            write!(file_stream, "ThreadId(1) :     main\n").expect("write failed\n"); 
        }
        atexit(_final_);
    }
    let shuffle_stream_res = OpenOptions::new().read(true).open("scenario");
    if let Ok(mut shuffle_stream) = shuffle_stream_res { 
        println!("DEBUG read scenario success");
        let mut shuffle_order_str = String::new();
        shuffle_stream.read_to_string(&mut shuffle_order_str).expect("fail to read from file\n");
        unsafe{
            _SHUFFLED_ORDER = Some(Arc::new(_ShuffledOrder::new(shuffle_order_str)));
        }
    }

    TID.with(|tid|{
        tid.replace(String::from("1"));
    })
}

pub fn _final_(){
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "---------------------From _final---------------------\n").expect("write failed\n");
        }
    }
}

pub fn _probe_mutex_(line:i32, func_num:i32, func_name:*const c_char, lock_var_addr:*mut u64){
    unsafe{
        TID.with(|tid| {
            let func_name_str = CStr::from_ptr(func_name).to_str().unwrap();

            if let Some(fp_arc) = &_PROBE_FP{
                let mut file_stream = fp_arc.lock().unwrap();
                write!(file_stream, "tid: {} | func_name: {:>8} | line: {:>4} | func_num: {} | lock_var_addr: {:?}\n", 
                                tid.borrow(), func_name_str, line, func_num, lock_var_addr).expect("write failed\n");
            }
        });

        if let Some(shuffled_order) = &_SHUFFLED_ORDER {
            shuffled_order.wait_or_pass(func_num);
        }
    }
}

pub fn _probe_func_(line:i32, func_num:i32, func_name:*const c_char){
    unsafe{
        TID.with(|tid| {
            let func_name_str = CStr::from_ptr(func_name).to_str().unwrap();

            if let Some(fp_arc) = &_PROBE_FP{
                let mut file_stream = fp_arc.lock().unwrap();
                write!(file_stream, "tid: {} | func_name: {:>8} | line: {:>4} | func_num: {} |\n", 
                                tid.borrow(), func_name_str, line, func_num).expect("write failed\n");
            }
        });

        if let Some(shuffled_order) = &_SHUFFLED_ORDER {
            shuffled_order.wait_or_pass(func_num);
        }
    }
}

pub fn _probe_spawning_(line:i32, func_num:i32){
    unsafe{
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.dec();
        }
        TID.with(|tid| {
            CHILD_ID.with(|child_id| {
                let mut child_id = child_id.borrow_mut();
                _PROBE_NEW_THREAD_ID= Some(format!("{}.{}", &tid.borrow(), child_id));
                *child_id += 1;

                if let Some(fp_arc) = &_PROBE_FP{
                    let mut file_stream = fp_arc.lock().unwrap();
                    write!(file_stream, "tid: {} | func_name: spawning | line: {:>4} | func_num: {} |\n", 
                                    tid.borrow(), line, func_num).expect("write failed\n");
                }
            })
        });

        if let Some(shuffled_order) = &_SHUFFLED_ORDER {
            shuffled_order.wait_or_pass(func_num);
        }
    }
}

pub fn _probe_spawned_(line:i32, func_num:i32){
    unsafe{
        TID.with(|tid| {
            if let Some(new_thread_id) = &_PROBE_NEW_THREAD_ID {
                tid.replace(new_thread_id.to_owned());
            }

            if let Some(fp_arc) = &_PROBE_FP{
                let mut file_stream = fp_arc.lock().unwrap();
                write!(file_stream, "tid: {} | func_name:  spawned | line: {:>4} | func_num: {} | \n", 
                                tid.borrow(), line, func_num).expect("write failed\n");
            }
        });

        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.inc();
        }

        if let Some(shuffled_order) = &_SHUFFLED_ORDER {
            shuffled_order.wait_or_pass(func_num);
        }
    }
}



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

struct _ProbeNode<'a>{
    tid:i32,
    parent_tid:i32,
    line_num:i32,
    func_num:i32,
    func_name:&'a str,
    var_addr:Option<*const u64>,
}
impl fmt::Display for _ProbeNode<'_>{
    fn fmt(&self, f: &mut fmt::Formatter<'_>)-> fmt::Result{
        match self.var_addr{
            Some(var_addr) => 
                write!(f, "tid: {:>3}, parent_tid: {:>3}, line: {:>4}, func: {:>8}, func_num: {:>3}, var: {:?}",
                        self.tid, self.parent_tid, self.line_num, self.func_name, self.func_num, var_addr),
            None =>
                write!(f, "tid: {:>3}, parent_tid: {:>3}, line: {:>4}, func: {:>8}, func_num: {:>3}, var: None",
                        self.tid, self.parent_tid, self.line_num, self.func_name, self.func_num),
        }
    }
}

struct _ShuffledOrder{
    order:Mutex<VecDeque<i32>>,
    next_exe:RwLock<i32>,
    cvar:Condvar,
    m:Mutex<()>,
}

impl _ShuffledOrder{
    fn new(shuffle_order_str:String) -> Self {
        let mut order = VecDeque::new();
        let str_vec:Vec<&str> = shuffle_order_str.split_whitespace().collect();
        for str_order in str_vec {
            order.push_back(str_order.parse::<i32>().unwrap());
        }
        let next_exe_init = order.pop_front().unwrap();

        _ShuffledOrder{
            order:Mutex::new(order),
            next_exe:RwLock::new(next_exe_init),
            cvar: Condvar::new(),
            m: Mutex::new(()),
        }
    }

    fn wait_or_pass(&self, exe_num:i32) {
        let mut guard = self.m.lock().unwrap();
        let mut next_exe_guard = self.next_exe.read().unwrap();
        while *next_exe_guard != exe_num {
            drop(next_exe_guard);
            guard = self.cvar.wait(guard).unwrap();
            next_exe_guard = self.next_exe.read().unwrap();
        }
        // to avoid read -> write deadlock
        drop(next_exe_guard);
        thread::sleep(Duration::from_millis(20));
		let mut order_queue = self.order.lock().unwrap();

		match order_queue.pop_front(){
			Some(next_exe_num) => {
				let mut w = self.next_exe.write().unwrap();
				*w = next_exe_num;
			},
			None => { /* it was the last of the vecdeque */ },
		}
		
        self.cvar.notify_all();
    }
}
