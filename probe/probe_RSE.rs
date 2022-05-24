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
};

// file stream to log
static mut _PROBE_FP:Option<Arc<Mutex<File>>> = None;
// semaphore for allowing only one spawning thread at a time
static mut _PROBE_THRD_SEM:Option<Arc<_ProbeSemaphore>> = None;
// for keeping track of parent thread id
static mut _PROBE_NEW_THREAD_ID:Option<String> = None;
// for keeping structure of the target program
static mut _PROBE_THRD_EXE:Option<Arc<Mutex<Vec<Vec<_ProbeNode>>>>> = None;

// max sleep duration, unit: ms
const _MAX_SLEEP: u64 = 10;

extern{
    fn atexit(callback: fn()) -> c_int;
    fn srand(seed: u32);
    fn time(time: *mut i64) -> i64;
    fn rand() -> c_int;
}

thread_local! {
    static TID:RefCell<String> = RefCell::new(String::from("none"));
    static CHILD_ID:RefCell<i32> = RefCell::new(1);
    static EXE_NODE_ID:RefCell<i32> = RefCell::new(-1);
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

    //this panic hook might change the semantics of the panic hanlder of the target code  
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

pub fn _probe_mutex_(line:i32, func_num:i32, func_name:*const c_char, _lock_var_addr:*mut u64){
    __random_sleep();
    
    unsafe{
        let func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
        TID.with(|tid| {
            __write_log(tid.borrow().as_str(), func_num);
            EXE_NODE_ID.with(|exe_node_id|{
                __record_thread_structure(*exe_node_id.borrow(), (*tid.borrow()).clone(), line, func_num, func_name_str, Some(_lock_var_addr));
            });
        });
    }
}

pub fn _probe_func_(line:i32, func_num:i32, func_name:*const c_char){
    __random_sleep();

    unsafe{
        let func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
        TID.with(|tid| {
            __write_log(tid.borrow().as_str(), func_num);
            EXE_NODE_ID.with(|exe_node_id|{
                __record_thread_structure(*exe_node_id.borrow(), tid.borrow().to_string(), line, func_num, func_name_str, None);
            });
        });
    }
}

pub fn _probe_spawning_(line:i32, func_num:i32){
    __random_sleep();
    
    unsafe{
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.dec();
        }
        TID.with(|tid| {
            __write_log(tid.borrow().as_str(), func_num);
            CHILD_ID.with(|child_id| {
                let mut child_id = child_id.borrow_mut();
                _PROBE_NEW_THREAD_ID = Some(format!("{}.{}", &tid.borrow(), child_id));
                *child_id += 1;

                EXE_NODE_ID.with(|exe_node_id|{
                    __record_thread_structure(*exe_node_id.borrow(), tid.borrow().to_string(), line, func_num, "spawning", None);
                });
            })
        });
    }
}

pub fn _probe_spawned_(line:i32, func_num:i32){
    __random_sleep();

    unsafe{
        TID.with(|tid| {
            if let Some(new_thread_id) = &_PROBE_NEW_THREAD_ID {
                tid.replace(new_thread_id.to_owned());
            }
            __write_log(tid.borrow().as_str(), func_num);

            EXE_NODE_ID.with(|exe_node_id| {
                // push new vec for newly spawned thread
                if let Some(thrd_vec) = &_PROBE_THRD_EXE{
                    let mut thrd_vec = thrd_vec.lock().unwrap();
                    exe_node_id.replace(thrd_vec.len() as i32);
                    thrd_vec.push(Vec::new());
                }

                __record_thread_structure(*exe_node_id.borrow(), tid.borrow().to_string(), line, func_num, "spawned", None);
            });
        });

        //atexit(_thread_term);
        
        if let Some(sema) = &_PROBE_THRD_SEM{
            sema.inc();
        }
    }
}

/*
fn _thread_term(){
    println!("the child thread has termianted successfully");
}
*/

/*
    For recording execution structure
*/
fn __record_thread_structure(
    tid_ind:i32,
    tid:String,
    line_num:i32, 
    func_num:i32, 
    func_name:&'static str, 
    var_addr:Option<*const u64>
) {
    unsafe{
        if let Some(thrd_vec) = &_PROBE_THRD_EXE{
            let mut thrd_vec = thrd_vec.lock().unwrap();
            thrd_vec[tid_ind as usize].push(_ProbeNode{
                tid:tid,
                line_num:line_num,
                func_num:func_num,
                func_name:func_name,
                var_addr:var_addr,
            });
        }
    }
}

fn __write_log(tid:&str, func_num:i32){
    unsafe{
        if let Some(fp_arc) = &_PROBE_FP {
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "{}-{}+", tid, func_num).expect("write failed\n");
        }
    }
}

fn __random_sleep(){
    unsafe{
        let mut seed: i64 = 0;
        srand(time(&mut seed).try_into().unwrap());
        let r:u64 = rand().try_into().unwrap();
        thread::sleep(time::Duration::from_millis(r % _MAX_SLEEP));
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
    line_num:i32,
    func_num:i32,
    func_name:&'a str,
    var_addr:Option<*const u64>,
}
impl fmt::Display for _ProbeNode<'_>{
    fn fmt(&self, f: &mut fmt::Formatter<'_>)-> fmt::Result{
        match self.var_addr{
            Some(var_addr) => 
                write!(f, "tid: {}, line: {:>4}, func: {:>8}, func_num: {:>3}, var: {:?}",
                        self.tid, self.line_num, self.func_name, self.func_num, var_addr),
            None =>
                write!(f, "tid: {}, line: {:>4}, func: {:>8}, func_num: {:>3}, var: None",
                        self.tid, self.line_num, self.func_name, self.func_num),
        }
    }
}