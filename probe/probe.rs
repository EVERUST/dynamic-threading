use std::{
    sync::{
        Arc,
        Condvar,
        Mutex,
    },
    fs::OpenOptions,
    fs::File,
    io::prelude::*,
    thread,
    ffi::CStr,
    os::raw::c_char,
};

static mut FP:Option<Arc<Mutex<File>>> = None;
static mut THRD_SEM:Option<Arc<Semaphore>> = None;
static mut PARENT_ID:Option<thread::ThreadId> = None;

pub fn _init_(){
    unsafe{
        THRD_SEM = Some(Arc::new(Semaphore::new(1))); // allow only 1 thread
        FP = Some(Arc::new(Mutex::new(OpenOptions::new()
                                            .write(true)
                                            .create(true)
                                            .append(true)
                                            .open("log")
                                            .unwrap())));
        if let Some(fp_arc) = &FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "---------------------From _init_---------------------\n");
            // calling thread::current().id() returns None... lead to assertion fail
            write!(file_stream, "ThreadId(1) :     main\n"); 
        }
    }
}

pub fn _probe_mutex_(line:i32, func_num:i32, func_name:*const c_char, lock_var_addr:*mut u64){
    unsafe{
        if let Some(fp_arc) = &FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "{:?} : {:>8} -> line {:>4} | func_num: {} | lock_var_addr: {:?}\n", 
                            thread::current().id(), CStr::from_ptr(func_name).to_str().unwrap(), 
                            line, func_num, lock_var_addr);
        }
    }
}

pub fn _probe_func_(line:i32, func_num:i32, func_name:*const c_char){
    unsafe{
        if let Some(fp_arc) = &FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "{:?} : {:>8} -> line {:>4} | func_num: {} |\n", 
                            thread::current().id(), CStr::from_ptr(func_name).to_str().unwrap(), line, func_num);
        }
    }
}

pub fn _probe_spawning(line:i32, func_num:i32){
    unsafe{
        if let Some(sema) = &THRD_SEM{
            sema.dec();
        }
        PARENT_ID = Some(thread::current().id());
        if let Some(fp_arc) = &FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "{:?} : spawning -> line {:>4} | func_num: {} |\n", 
                            thread::current().id(), line, func_num);
        }
    }
}

pub fn _probe_spawned(line:i32, func_num:i32){
    unsafe{
        if let Some(fp_arc) = &FP{
            let mut file_stream = fp_arc.lock().unwrap();
            write!(file_stream, "{:?} :  spawned -> line {:>4} | func_num: {} | ", 
                            thread::current().id(), line, func_num);
            write!(file_stream, "{:?} -> {:?}\n", PARENT_ID.unwrap(), thread::current().id());
        }
        if let Some(sema) = &THRD_SEM{
            sema.inc();
        }
    }
}


struct Semaphore {
    mutex: Mutex<i32>,
    cvar: Condvar,
}

impl Semaphore {
    pub fn new(count: i32) -> Self {
        Semaphore {
            mutex: Mutex::new(count),
            cvar: Condvar::new(),
        }
    }

    pub fn dec(&self) {
        let mut lock = self.mutex.lock().unwrap();
        *lock -= 1;
        while *lock < 0 {
            lock = self.cvar.wait(lock).unwrap();
        }
    }

    pub fn inc(&self) {
        let mut lock = self.mutex.lock().unwrap();
        *lock += 1;
        if *lock <= 0 {
            self.cvar.notify_one();
        }
    }
}

unsafe impl Send for Semaphore {}
unsafe impl Sync for Semaphore {}