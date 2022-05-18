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
};

static mut fp:Option<Arc<Mutex<File>>> = None;
static mut pair:Option<Arc<(Mutex<bool>,Condvar)>> = None;
static mut pair2:Option<Arc<(Mutex<bool>,Condvar)>> = None;

pub fn _init_(){
    unsafe{
        fp = Some(Arc::new(Mutex::new(OpenOptions::new()
                                            .read(true)
                                            .write(true)
                                            .open("../metadata.txt")
                                            .unwrap())));
        
        pair = Some(Arc::new((Mutex::new(false), Condvar::new())));
        if let Some(pair_p) = &pair {
            pair2 = Some(Arc::clone(&pair_p));
        }


        if let Some(fp_arc) = &fp{
            let mut line = String::new();
            fp_arc.lock().unwrap().read_to_string(&mut line).expect("with text");
            println!("with text: {}\n", line);
        }
    }
    println!("program termination\n");
}
pub fn _probe_mutex_(line:i32, func_num:i32, func_name:&str, lock_var_addr:*mut u64){
    unsafe {
            if line == 15 {
                if let Some(pair2_p) = &pair2 {
                    let (lock, cvar) = &**pair2_p;
                    let mut started = lock.lock().unwrap();
                    *started = true;
                    cvar.notify_one();
                }
            } else if line == 20 {
               if let Some(pair_p) = &pair {
                    let (lock, cvar) = &**pair_p;
                    let mut started = lock.lock().unwrap();
                    while !*started {
                        started = cvar.wait(started).unwrap();
                    }
                }
            }
    }
}
