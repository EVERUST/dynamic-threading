use std::{
    sync::{
        Arc,
        Mutex,
        Condvar,
    },
    fs::OpenOptions,
    fs::File,
    io::prelude::*,
    thread,
    time
};

static mut fp:Option<Arc<Mutex<File>>> = None;
static mut PROBE_SEM:Option<Arc<_ProbeSemaphore>> = None;

pub fn _init_(){
    unsafe{
        fp = Some(Arc::new(Mutex::new(OpenOptions::new()
                                        .read(true)
                                        .write(true)
                                        .open("../metadata.txt")
                                        .unwrap())));
    
        PROBE_SEM = Some(Arc::new(_ProbeSemaphore::new(1)));
        /*
        if let Some(fp_arc) = &fp{
            let mut line = String::new();
            fp_arc.lock().unwrap().read_to_string(&mut line).expect("with text");
            println!("with text: {}\n", line);
        }*/
    }
}

pub fn _probe_mutex_(line:i32, func_num:i32, func_name:&str, lock_var_addr:*mut u64){
    unsafe {
        if line == 20 {
            if let Some(probe_sem) = &PROBE_SEM{
                probe_sem.inc();
            }
        } else if line == 15 {
            if let Some(probe_sem) = &PROBE_SEM{
                probe_sem.dec();
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
