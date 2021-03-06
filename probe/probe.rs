use std::{
    sync::{ Arc, Condvar, Mutex, RwLock, },
    fs::{OpenOptions, File},
    io::prelude::*,
    thread,
    time,
    ffi::CStr,
    os::raw::{c_char, c_int, c_void},
    collections::{HashMap, VecDeque},
    fmt,
    time::Duration,
    convert::TryInto,
};

static mut _PROBE_FP:Option<Arc<Mutex<File>>> = None;
static mut _PROBE_THRD_SEM:Option<Arc<_ProbeSemaphore>> = None;
static mut _PROBE_PARENT_ID:Option<thread::ThreadId> = None;
static mut _PROBE_THRD_MAP:Option<Arc<Mutex<HashMap<thread::ThreadId, i32>>>> = None;
static mut _PROBE_THRD_CUSTOM_ID:Option<Arc<Mutex<i32>>> = None;
static mut _PROBE_THRD_EXE:Option<Arc<Mutex<Vec<Vec<_ProbeNode>>>>> = None;
static mut _SHUFFLED_ORDER:Option<Arc<_ShuffledOrder>> = None;

const _MAX_SLEEP: u64 = 10;

extern{
    fn atexit(callback: fn()) -> c_int;
    fn srand(seed: u32);
    fn time(time: *mut i64) -> i64;
    fn rand() -> c_int;
    fn __builtin_return_address(level: u32) -> *mut c_void;
}

pub fn _init_(){
    unsafe{
        _PROBE_THRD_SEM = Some(Arc::new(_ProbeSemaphore::new(1))); // allow only 1 thread
        _PROBE_THRD_MAP = Some(Arc::new(Mutex::new(HashMap::new())));
        _PROBE_THRD_CUSTOM_ID = Some(Arc::new(Mutex::new(1)));
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
    let shuffle_stream_res = OpenOptions::new().read(true).open("shuffle");
    match shuffle_stream_res {
        Ok(mut shuffle_stream) => {
            println!("DEBUG read shuffle success");
            let mut shuffle_order_str = String::new();
            shuffle_stream.read_to_string(&mut shuffle_order_str).expect("fail to read from file\n");
            unsafe{
                _SHUFFLED_ORDER = Some(Arc::new(_ShuffledOrder::new(shuffle_order_str)));
            }
       },
        Err(_) => {
            println!("read shuffle fail");
            unsafe{
                _PROBE_THRD_EXE = Some(Arc::new(Mutex::new(Vec::new())));
            }
        },
    }
}

pub fn _final_(){
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "---------------------From _final---------------------\n").expect("write failed\n");
        }
    }
    let mut struct_stream = OpenOptions::new().write(true).create(true).append(true).open("struct").unwrap();
    unsafe{
        if let Some(vec_thrds) = &_PROBE_THRD_EXE{
            let vec_thrds = vec_thrds.lock().unwrap();
            let mut i = 1;
            for vec_thrd in &*vec_thrds {
                write!(struct_stream, "tid {} --------\n", i).expect("write failed\n");
                i += 1;
                for node in vec_thrd {
                    write!(struct_stream, "\t{}\n", node).expect("write failed\n");
                }
            }
        }
    }
}

pub fn _probe_random_sleep(line:i32, func_num:i32, func_name:*const c_char){
    let func_name_str:&str;
    let tid = __get_custom_tid(thread::current().id());
    unsafe{
        let mut seed: i64 = 0;
        srand(time(&mut seed).try_into().unwrap());
        let r:u64 = rand().try_into().unwrap();
        thread::sleep(time::Duration::from_millis(r % _MAX_SLEEP));

        func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "|RANDOM_SLEEP_WAKE!|tid: {} | func_name: {:>8} | line: {:>4} | func_num: {} |\n", 
                            tid, func_name_str, line, func_num).expect("write failed\n");
        }
    }
    __record_thread_exe_order(tid, -1, line, func_num, func_name_str, None);
}



pub fn _probe_mutex_(line:i32, func_num:i32, func_name:*const c_char, lock_var_addr:*mut u64){
    __sleep_random_for_probe_func();
    let func_name_str:&str;
    let tid = __get_custom_tid(thread::current().id());
    unsafe{
        func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
    }
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "tid: {} | func_name: {:>8} | line: {:>4} | func_num: {} | lock_var_addr: {:?}\n", 
                            tid, func_name_str, line, func_num, lock_var_addr).expect("write failed\n");
            //write!(file_stream, "ret addr: {:?}\n", __builtin_return_address(0));
        }
    }
    __record_thread_exe_order(tid, -1, line, func_num, func_name_str, Some(lock_var_addr));
    unsafe{
        if let Some(shuffled_order) = &_SHUFFLED_ORDER {
            shuffled_order.wait_or_pass(func_num);
        }
    }
}

pub fn _probe_func_(line:i32, func_num:i32, func_name:*const c_char){
    __sleep_random_for_probe_func();
    let func_name_str:&str;
    let tid = __get_custom_tid(thread::current().id());
    unsafe{
        func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
    }
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "tid: {} | func_name: {:>8} | line: {:>4} | func_num: {} |\n", 
                            tid, func_name_str, line, func_num).expect("write failed\n");
        }
    }
    __record_thread_exe_order(tid, -1, line, func_num, func_name_str, None);
    unsafe{
        if let Some(shuffled_order) = &_SHUFFLED_ORDER {
            shuffled_order.wait_or_pass(func_num);
        }
    }
}

pub fn _probe_spawning_(line:i32, func_num:i32){
    __sleep_random_for_probe_func();
    let tid = __get_custom_tid(thread::current().id());
    unsafe{
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.dec();
        }
        _PROBE_PARENT_ID = Some(thread::current().id());
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "tid: {} | func_name: spawning | line: {:>4} | func_num: {} |\n", 
                            tid, line, func_num).expect("write failed\n");
        }
    }
    __record_thread_exe_order(tid, -1, line, func_num, "spawning", None);
    unsafe{
        if let Some(shuffled_order) = &_SHUFFLED_ORDER {
            shuffled_order.wait_or_pass(func_num);
        }
    }
}

pub fn _probe_spawned_(line:i32, func_num:i32){
    __sleep_random_for_probe_func();
    let tid = __get_custom_tid(thread::current().id());
    let parent_tid:i32;
    unsafe{
        parent_tid = __get_custom_tid(_PROBE_PARENT_ID.unwrap());
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "tid: {} | func_name:  spawned | line: {:>4} | func_num: {} | ", 
                            tid, line, func_num).expect("write failed\n");
            write!(file_stream, "{} spawned {}\n", parent_tid, tid).expect("write failed\n");
        }
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.inc();
        }
    }
    __record_thread_exe_order(tid, parent_tid, line, func_num, "spawned", None);
    unsafe{
        if let Some(shuffled_order) = &_SHUFFLED_ORDER {
            shuffled_order.wait_or_pass(func_num);
        }
    }
}

fn __sleep_random_for_probe_func(){
    unsafe{
        let mut seed: i64 = 0;
        srand(time(&mut seed).try_into().unwrap());
        let r:u64 = rand().try_into().unwrap();
        thread::sleep(time::Duration::from_millis(r % _MAX_SLEEP));
    }        
}

fn __get_custom_tid(target_tid:thread::ThreadId) -> i32{
    let mut curr_id = -1;
    unsafe{
        if let Some(hash) = &_PROBE_THRD_MAP{
            let mut hash = hash.lock().unwrap();
            if let Some(custom_id) = &_PROBE_THRD_CUSTOM_ID{
                let mut custom_id = custom_id.lock().unwrap();
                curr_id = *(hash.entry(target_tid).or_insert(*custom_id));
                if curr_id == *custom_id{
                    *custom_id += 1;
                }
            }
        }
    }
    curr_id
}

fn __record_thread_exe_order(
    tid:i32, 
    parent_tid:i32, 
    line_num:i32, 
    func_num:i32, 
    func_name:&'static str, 
    var_addr:Option<*const u64>
) {
    unsafe{
        if let Some(thrd_vec) = &_PROBE_THRD_EXE{
            let mut thrd_vec = thrd_vec.lock().unwrap();
            if tid > thrd_vec.len() as i32 {
                thrd_vec.push(Vec::new());
            }
            thrd_vec[tid as usize - 1].push(_ProbeNode{
                tid:tid,
                parent_tid:parent_tid,
                line_num:line_num,
                func_num:func_num,
                func_name:func_name,
                var_addr:var_addr,
            });
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
