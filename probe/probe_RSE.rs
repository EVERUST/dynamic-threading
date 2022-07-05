use std::{
    sync::{ Arc, Condvar, Mutex, },
    fs::{OpenOptions, File},
    io::prelude::*,
    thread,
    time,
    ffi::{CStr},
    os::raw::{c_char, c_int},
    fmt,
    convert::TryInto,
    cell::RefCell,
    panic,
    process,
    env,
};

// file stream to log
static mut _PROBE_FP:Option<Arc<Mutex<File>>> = None;
// semaphore for allowing only one spawning thread at a time
static mut _PROBE_THRD_SEM:Option<Arc<_ProbeSemaphore>> = None;
// for keeping track of parent thread id
static mut _PROBE_NEW_THREAD_ID:Option<String> = None;
// for keeping structure of the target program
static mut _PROBE_THRD_EXE:Option<Arc<Mutex<Vec<Vec<_ProbeNode>>>>> = None;
// one thread that does not sleep
static mut _PRIVILEGED_THREAD:Option<String> = None;

// max sleep duration, unit: ms
const _MAX_SLEEP: u64 = 10;
const _SLEEP_SWITCH: u64 = 2;

extern{
    fn atexit(callback: fn()) -> c_int;
    fn srand(seed: u32);
    fn time(time: *mut i64) -> i64;
    fn rand() -> c_int;
}

thread_local! {
    static TID:RefCell<String> = RefCell::new(String::from("none"));
    static CHILD_ID:RefCell<i32> = RefCell::new(1);
    static EXE_NODE_ID:RefCell<usize> = RefCell::new(0);
}

pub fn _init_(){
    unsafe{
        if let Ok(val) = env::var("PRIVILEGED_THREAD") {
            _PRIVILEGED_THREAD = Some(val);
        }
        _PROBE_THRD_SEM = Some(Arc::new(_ProbeSemaphore::new(1))); // allow only 1 thread
        _PROBE_FP = Some(Arc::new(Mutex::new(OpenOptions::new()
                                            .write(true)
                                            .create(true)
                                            .open("log")
                                            .unwrap())));
        match OpenOptions::new().read(true).open("struct"){
            Ok(_) => { },
            Err(_) => {
                let mut thrd_vec:Vec<Vec<_ProbeNode>> = Vec::new();
                thrd_vec.push(Vec::new());
                _PROBE_THRD_EXE = Some(Arc::new(Mutex::new(thrd_vec)));
            },
        }
        atexit(_final_);
    }
    EXE_NODE_ID.with(|exe_node_id|{
        exe_node_id.replace(0);
    });
    TID.with(|tid| {
        tid.replace(String::from("1"));
    });

    let ori_hook = panic::take_hook();
    panic::set_hook(Box::new(move |panic_info| {
        ori_hook(panic_info);
        process::exit(1);
    }));
}

pub fn _final_(){
    unsafe{
        if let Some(vec_thrds) = &_PROBE_THRD_EXE{
            let mut struct_stream = OpenOptions::new().write(true).create(true).append(true).open("struct").unwrap();
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

pub fn _probe_mutex_(line:i32, func_num:i32, func_name:*const c_char, _lock_var_addr:*mut u64, file_path:*const c_char){
    __random_sleep();
    
    unsafe{
        let func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
        TID.with(|tid| {
            __record_scenario(tid.borrow().as_str(), func_num);
            EXE_NODE_ID.with(|exe_node_id|{
                let file_path_str = CStr::from_ptr(file_path).to_str().unwrap();
                __record_thread_structure(*exe_node_id.borrow(), (*tid.borrow()).clone(), func_num, line, func_name_str, Some(_lock_var_addr), Some(file_path_str));
            });
        });
    }
}

pub fn _probe_func_(line:i32, func_num:i32, func_name:*const c_char, file_path:*const c_char){
    let func_name_str = unsafe {
        CStr::from_ptr(func_name).to_str().unwrap()
    };
    if func_name_str != "join" {
        __random_sleep();
    }

    unsafe{
        TID.with(|tid| {
            __record_scenario(tid.borrow().as_str(), func_num);
            EXE_NODE_ID.with(|exe_node_id|{
                let file_path_str = CStr::from_ptr(file_path).to_str().unwrap();
                __record_thread_structure(*exe_node_id.borrow(), tid.borrow().to_string(), func_num, line, func_name_str, None, Some(file_path_str));
            });
        });
    }
}

pub fn _probe_spawning_(line:i32, func_num:i32, file_path:*const c_char){
    // spawning + spawned is double sleep without any new permutation added, sleep only at spawned is enough
    //__random_sleep();
    
    unsafe{
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.dec();
        }
        TID.with(|tid| {
            __record_scenario(tid.borrow().as_str(), func_num);
            CHILD_ID.with(|child_id| {
                let mut child_id = child_id.borrow_mut();
                _PROBE_NEW_THREAD_ID = Some(format!("{}.{}", &tid.borrow(), child_id));
                *child_id += 1;

                EXE_NODE_ID.with(|exe_node_id|{
                let file_path_str = CStr::from_ptr(file_path).to_str().unwrap();
                    __record_thread_structure(*exe_node_id.borrow(), tid.borrow().to_string(), func_num, line, "spawning", None, Some(file_path_str));
                });
            })
        });
    }
}
pub fn _probe_spawned_(line:i32, func_num:i32){
    unsafe {
        TID.with(|tid| {
            if let Some(new_thread_id) = &_PROBE_NEW_THREAD_ID {
                tid.replace(new_thread_id.to_owned());
            }
        });
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.inc();
        }
    }
    __random_sleep();

    unsafe{
        TID.with(|tid| {
            __record_scenario(tid.borrow().as_str(), func_num);

            EXE_NODE_ID.with(|exe_node_id| {
                // push new vec for newly spawned thread
                if let Some(thrd_vec) = &_PROBE_THRD_EXE{
                    let mut thrd_vec = thrd_vec.lock().unwrap();
                    exe_node_id.replace(thrd_vec.len() as usize);
                    thrd_vec.push(Vec::new());
                }

                __record_thread_structure(*exe_node_id.borrow(), tid.borrow().to_string(), func_num, line, "spawned", None, None);
            });
        });
    }
}

/*
    For recording execution structure
*/
fn __record_thread_structure(
    tid_ind:usize,
    tid:String,
    func_num:i32,
    line_num:i32, 
    func_name:&'static str, 
    var_addr:Option<*const u64>,
    file_path:Option<&str>,
) {
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
    unsafe{
        if let Some(thrd_vec) = &_PROBE_THRD_EXE{
            let mut thrd_vec = thrd_vec.lock().unwrap();
            thrd_vec[tid_ind as usize].push(_ProbeNode{
                tid:tid,
                func_num:func_num,
                line_num:line_num,
                func_name:func_name,
                var_addr:var_addr,
                file_path:file_path,
            });
        }
    }
}

fn __record_scenario(tid:&str, func_num:i32){
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP {
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "{}-{}+", tid, func_num).expect("write failed\n");
        }
    }
}

fn __random_sleep(){
    unsafe{
        match &_PRIVILEGED_THREAD {
            None => {
                let mut seed: i64 = 0;
                srand(time(&mut seed).try_into().unwrap());
                let r:u64 = rand().try_into().unwrap();
                thread::sleep(time::Duration::from_millis((r % _SLEEP_SWITCH) * _MAX_SLEEP));
                //thread::sleep(time::Duration::from_millis(r % _MAX_SLEEP));
            }
            Some(thread_id) => {
                TID.with(|tid| {
                    if tid.borrow().as_str() == thread_id.as_str() { }
                    else {
                        let mut seed: i64 = 0;
                        srand(time(&mut seed).try_into().unwrap());
                        let r:u64 = rand().try_into().unwrap();
                        //thread::sleep(time::Duration::from_millis((r % _SLEEP_SWITCH) * _MAX_SLEEP));
                        thread::sleep(time::Duration::from_millis(r % _MAX_SLEEP));
                    }
                });
            }
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

/*
    data structure for keeping the execution order
*/
struct _ProbeNode<'a>{
    tid: String,
    func_num:i32,
    line_num:i32,
    func_name:&'a str,
    var_addr:Option<*const u64>,
    file_path:String,
}
impl fmt::Display for _ProbeNode<'_>{
    fn fmt(&self, f: &mut fmt::Formatter<'_>)-> fmt::Result{
        match self.var_addr{
            Some(var_addr) => 
                write!(f, "tid: {:<8} | func_num: {:<3} | func_name: {:<8} | lock_var_addr: {:<10?} | {} : {}", 
                            self.tid, self.func_num, self.func_name, var_addr, self.file_path, self.line_num),
            None => 
                write!(f, "tid: {:<8} | func_num: {:<3} | func_name: {:<8} | lock_var_addr: {:<10} | {} : {}", 
                            self.tid, self.func_num, self.func_name, "None", self.file_path, self.line_num),
        }
    }
}