use std::{
    sync::{
        Arc,
        Condvar,
        Mutex,
    },
    fs::{OpenOptions, File},
    io::prelude::*,
    thread,
    ffi::CStr,
    os::raw::c_char,
    collections::HashMap,
};

static mut _PROBE_FP:Option<Arc<Mutex<File>>> = None;
static mut _PROBE_THRD_SEM:Option<Arc<_ProbeSemaphore>> = None;
static mut _PROBE_PARENT_ID:Option<thread::ThreadId> = None;
static mut _PROBE_THRD_MAP:Option<Arc<Mutex<HashMap<thread::ThreadId, i32>>>> = None;
static mut _PROBE_THRD_CUSTOM_ID:Option<Arc<Mutex<i32>>> = None;
static mut _PROBE_THRD_EXE:Option<Arc<Mutex<Vec<Vec<_ProbeNode>>>>> = None;

pub fn _init_(){
    unsafe{
        _PROBE_THRD_SEM = Some(Arc::new(_ProbeSemaphore::new(1))); // allow only 1 thread
        _PROBE_THRD_MAP = Some(Arc::new(Mutex::new(HashMap::new())));
        _PROBE_THRD_CUSTOM_ID = Some(Arc::new(Mutex::new(1)));
        _PROBE_THRD_EXE = Some(Arc::new(Mutex::new(Vec::new())));
        _PROBE_FP = Some(Arc::new(Mutex::new(OpenOptions::new()
                                            .write(true)
                                            .create(true)
                                            .append(true)
                                            .open("log")
                                            .unwrap())));
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "---------------------From _init_---------------------\n");
            // calling thread::current().id() returns None... lead to assertion fail
            write!(file_stream, "ThreadId(1) :     main\n"); 
        }
    }
}

pub fn _probe_mutex_(line:i32, func_num:i32, func_name:*const c_char, lock_var_addr:*mut u64){
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            let tid = _probe_get_custom_tid(thread::current().id());
            write!(file_stream, "tid: {} | func_name: {:>8} | line: {:>4} | func_num: {} | lock_var_addr: {:?}\n", 
                            tid, CStr::from_ptr(func_name).to_str().unwrap(), 
                            line, func_num, lock_var_addr);
        }
    }
}

pub fn _probe_func_(line:i32, func_num:i32, func_name:*const c_char){
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            let tid = _probe_get_custom_tid(thread::current().id());
            write!(file_stream, "tid: {} | func_name: {:>8} | line: {:>4} | func_num: {} |\n", 
                            tid, CStr::from_ptr(func_name).to_str().unwrap(), line, func_num);
        }
    }
}

pub fn _probe_spawning_(line:i32, func_num:i32){
    unsafe{
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.dec();
        }
        _PROBE_PARENT_ID = Some(thread::current().id());
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            let tid = _probe_get_custom_tid(thread::current().id());
            write!(file_stream, "tid: {} | func_name: spawning | line: {:>4} | func_num: {} |\n", 
                            tid, line, func_num);
        }
    }
}

pub fn _probe_spawned_(line:i32, func_num:i32){
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            let tid = _probe_get_custom_tid(thread::current().id());
            write!(file_stream, "tid: {} | func_name:  spawned | line: {:>4} | func_num: {} | ", 
                            tid, line, func_num);
            write!(file_stream, "{} spawned {}\n", _probe_get_custom_tid(_PROBE_PARENT_ID.unwrap()), tid);
        }
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.inc();
        }
    }
}

fn _probe_get_custom_tid(target_tid:thread::ThreadId) -> i32{
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

fn _append_exe_node(tid:i32, line_num:i32, func_num:i32, func_name:&str, var_addr:Option<*const u64>){
    unsafe{
        if let Some(thrd_vec) = &_PROBE_THRD_EXE{
            let mut thrd_vec = thrd_vec.lock().unwrap();
            if tid > thrd_vec.len() as i32 {
                thrd_vec.push(Vec::new());
            }
            let tid_vec = thrd_vec[tid-1 as usize];
            tid_vec.push(_ProbeNode{
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
    line_num:i32,
    func_num:i32,
    func_name:&'a str,
    var_addr:Option<*const u64>,
}