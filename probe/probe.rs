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
    os::raw::{c_char, c_int},
    collections::HashMap,
    fmt,
};

static mut _PROBE_FP:Option<Arc<Mutex<File>>> = None;
static mut _PROBE_THRD_SEM:Option<Arc<_ProbeSemaphore>> = None;
static mut _PROBE_PARENT_ID:Option<thread::ThreadId> = None;
static mut _PROBE_THRD_MAP:Option<Arc<Mutex<HashMap<thread::ThreadId, i32>>>> = None;
static mut _PROBE_THRD_CUSTOM_ID:Option<Arc<Mutex<i32>>> = None;
static mut _PROBE_THRD_EXE:Option<Arc<Mutex<Vec<Vec<_ProbeNode>>>>> = None;

extern{
    fn atexit(callback: fn()) -> c_int;
}

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
            write!(file_stream, "---------------------From _init_---------------------\n").expect("write failed\n");
            // calling thread::current().id() returns None... lead to assertion fail
            write!(file_stream, "ThreadId(1) :     main\n").expect("write failed\n"); 
        }
        atexit(_final_);
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

pub fn _probe_mutex_(line:i32, func_num:i32, func_name:*const c_char, lock_var_addr:*mut u64){
    let func_name_str:&str;
    let tid = _probe_get_custom_tid(thread::current().id());
    unsafe{
        func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
    }
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            //tid = _probe_get_custom_tid(thread::current().id());
            write!(file_stream, "tid: {} | func_name: {:>8} | line: {:>4} | func_num: {} | lock_var_addr: {:?}\n", 
                            tid, func_name_str, line, func_num, lock_var_addr).expect("write failed\n");
        }
    }
    _append_exe_node(tid, -1, line, func_num, func_name_str, Some(lock_var_addr));
}

pub fn _probe_func_(line:i32, func_num:i32, func_name:*const c_char){
    let func_name_str:&str;
    let tid = _probe_get_custom_tid(thread::current().id());
    unsafe{
        func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
    }
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            //tid = _probe_get_custom_tid(thread::current().id());
            write!(file_stream, "tid: {} | func_name: {:>8} | line: {:>4} | func_num: {} |\n", 
                            tid, func_name_str, line, func_num).expect("write failed\n");
        }
    }
    _append_exe_node(tid, -1, line, func_num, func_name_str, None);
}

pub fn _probe_spawning_(line:i32, func_num:i32){
    let tid = _probe_get_custom_tid(thread::current().id());
    unsafe{
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.dec();
        }
        _PROBE_PARENT_ID = Some(thread::current().id());
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            //tid = _probe_get_custom_tid(thread::current().id());
            write!(file_stream, "tid: {} | func_name: spawning | line: {:>4} | func_num: {} |\n", 
                            tid, line, func_num).expect("write failed\n");
        }
    }
    _append_exe_node(tid, -1, line, func_num, "spawning", None);
}

pub fn _probe_spawned_(line:i32, func_num:i32){
    let tid = _probe_get_custom_tid(thread::current().id());
    let parent_tid:i32;
    unsafe{
        parent_tid = _probe_get_custom_tid(_PROBE_PARENT_ID.unwrap());
        if let Some(fp_arc) = &_PROBE_FP{
            let mut file_stream = fp_arc.lock().unwrap();
            //tid = _probe_get_custom_tid(thread::current().id());
            write!(file_stream, "tid: {} | func_name:  spawned | line: {:>4} | func_num: {} | ", 
                            tid, line, func_num).expect("write failed\n");
            write!(file_stream, "{} spawned {}\n", parent_tid, tid).expect("write failed\n");
        }
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.inc();
        }
    }
    _append_exe_node(tid, parent_tid, line, func_num, "spawned", None);
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

fn _append_exe_node(tid:i32, parent_tid:i32, line_num:i32, func_num:i32, func_name:&'static str, var_addr:Option<*const u64>){
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