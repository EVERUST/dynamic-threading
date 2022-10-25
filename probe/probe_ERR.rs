#![allow(unused)]
use std::{
    sync::{ Arc, Condvar, Mutex, },
    fs::{OpenOptions, File},
    io::prelude::*,
    ffi::CStr,
    ffi::CString,
    os::raw::{c_char, c_int},
    collections::VecDeque,
    cell::RefCell,
    time::Duration,
    thread,
    panic,
    process,
};

// semaphore used to keep track of parent-child thread relationship
static mut _THREAD__SPAWN_SEM:Option<Arc<(Mutex<_ProbeSpawnSema>, Condvar)>> = None;
// mutex and scenario to sequentially execute threads
static mut _REPLAY__SCENARIO:Option<Arc<(Mutex<_ReplayDirector>, Condvar)>> = None;
extern { fn atexit(callback: fn()) -> c_int; }

thread_local! {
    static _TID:RefCell<String> = RefCell::new(String::from("none"));
    static _CHILD_ID:RefCell<i32> = RefCell::new(1);
    static _SPAWN_SEM:RefCell<Option<Arc<(Mutex<_ProbeSpawnSema>, Condvar)>>> = RefCell::new(None);
    static _SCENARIO:RefCell<Option<Arc<(Mutex<_ReplayDirector>, Condvar)>>> = RefCell::new(None);
}

pub fn _init_(){
    match OpenOptions::new().read(true).open("scenario") {
        Ok(scenario_fp) => {
            unsafe { _REPLAY__SCENARIO = Some(Arc::new((Mutex::new(_ReplayDirector::new(scenario_fp)), Condvar::new()))) };
        }
        Err(_) => {
            eprintln!("MSG FROM TLE : FAIL TO READ _SCENARIO, EXITING...");
            std::process::exit(0);
        }
    }

    unsafe { _THREAD__SPAWN_SEM = Some(Arc::new((Mutex::new(_ProbeSpawnSema::new(1)), Condvar::new()))); }

    unsafe { atexit(_final_); }

    let ori_hook = panic::take_hook();
    panic::set_hook(Box::new(move |panic_info| {
        ori_hook(panic_info);
        process::exit(1);
    }));

    _probe_thread_init_();

    _TID.with(|tid| {
        tid.replace(String::from("1"));
    });
}

fn _probe_thread_init_(){
    _SPAWN_SEM.with(|spawn_sema|{
        unsafe {
            if let Some(global_thrd_sem) = & _THREAD__SPAWN_SEM {
                spawn_sema.replace(Some(Arc::clone(&global_thrd_sem)));
            }
        }
    });

    _SCENARIO.with(|exe_order|{
        unsafe {
            if let Some(global_scenario) = & _REPLAY__SCENARIO {
                exe_order.replace(Some(Arc::clone(&global_scenario)));
            }
        }
    });
}

pub fn _final_(){ }

pub fn _probe_mutex_(line:i32, func_num:i32, func_name:*const c_char, lock_var_addr:*mut u64, file_path:*const c_char){
    unsafe {
        let func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
        let file_path_str = CStr::from_ptr(file_path).to_str().unwrap();

        _TID.with(|tid| {
            __traffic_light(tid.borrow().as_str(), func_num, func_name_str, Some(lock_var_addr), Some(file_path_str), line);
        });
    }
}

pub fn _probe_func_(line:i32, func_num:i32, func_name:*const c_char, file_path:*const c_char){   
    unsafe {
        let func_name_str = CStr::from_ptr(func_name).to_str().unwrap();
        let file_path_str = CStr::from_ptr(file_path).to_str().unwrap();

        _TID.with(|tid| {
            __traffic_light(tid.borrow().as_str(), func_num, func_name_str, None, Some(file_path_str), line);
        });
    }
}

pub fn _probe_spawning_(line:i32, func_num:i32, file_path:*const c_char){
    _SPAWN_SEM.with(|spawn_sema| {
        if let Some(sema_unwrapped) = &*spawn_sema.borrow() {
            _TID.with(|tid| {
                _CHILD_ID.with(|child_id|{
                    let mut child_id = child_id.borrow_mut();
                    let (sema_guard, cvar) = &**sema_unwrapped;
                    let mut sema_guard = sema_guard.lock().unwrap();
                    sema_guard.dec_count();
                    while sema_guard.get_count() < 0 {
                        sema_guard = cvar.wait(sema_guard).unwrap();
                    }
                    sema_guard.set_tid(format!("{}.{}", &tid.borrow(), child_id));
                    *child_id += 1;
                    drop(sema_guard);
                });
            });
        }
    });

    unsafe {
        let file_path_str = CStr::from_ptr(file_path).to_str().unwrap();

        _TID.with(|tid| {
            __traffic_light(tid.borrow().as_str(), func_num, "spawning", None, Some(file_path_str), line);
        });
    }
}

pub fn _probe_spawned_(line:i32, func_num:i32){
    _probe_thread_init_();
    _SPAWN_SEM.with(|spawn_sema| {
        if let Some(sema_unwrapped) = &*spawn_sema.borrow() {
            let (sema_guard, cvar) = &**sema_unwrapped;
            let mut sema_guard = sema_guard.lock().unwrap();

            _TID.with(|tid|{
                tid.replace(sema_guard.get_tid());
            });

            sema_guard.inc_count();

            if sema_guard.get_count() <= 0 {
                cvar.notify_one();
            }
            drop(sema_guard);
        }
    });

    unsafe {
        _TID.with(|tid| {
            __traffic_light(tid.borrow().as_str(), func_num, "spawned", None, None, -1);
        });
    }
}

fn __traffic_light(
    tid:&str, 
    func_num:i32, 
    func_name:&str, 
    var_addr:Option<*const u64>, 
    file_path:Option<&str>, 
    line_num:i32
) {
    let my_order = format!("{}-{}", tid, func_num);
    _SCENARIO.with(|exe_wrapped|{
        if let Some(exe_unwrapped) = &*exe_wrapped.borrow() {
            let (exe_guarded, cvar) = &**exe_unwrapped;
            let mut exe_order = exe_guarded.lock().unwrap();
            eprintln!("\t++ {:?} {} is in, next is {}", thread::current().id(), my_order, exe_order.get_next_act());
            while !my_order.eq(&exe_order.get_next_act()) {
                eprintln!("\t++ {:?} {} sleeps", thread::current().id(), my_order);
                // exe_order = cvar.wait(exe_order).unwrap();
				thread::sleep(Duration::from_millis(500));
                eprintln!("\t++ {:?} {} is awake, next is {}", thread::current().id(), my_order, exe_order.get_next_act());
            }
            eprintln!("\t++ {:?} {} passed", thread::current().id(), my_order);
            exe_order.write_log(tid, func_num, func_name, var_addr, file_path, line_num);
            exe_order.update_next_act();
            cvar.notify_all();
            drop(exe_order);
        }
    });
    if my_order.eq("1.1-19") {
        thread::sleep(Duration::from_millis(1000));
    }
}


/*
* the lock should be held before calling any of the methods except for new.
*/
struct _ProbeSpawnSema {
    count: i32,
    child_thread_id: String,
}

impl _ProbeSpawnSema {
    fn new(count: i32) -> Self {
        _ProbeSpawnSema {
            count:count,
            child_thread_id:String::from("none"),
        }
    }

    fn get_tid(&self) -> String { self.child_thread_id.clone() }

    fn set_tid(&mut self, new_tid: String) { self.child_thread_id = new_tid; }

    fn get_count(&self) -> i32 { self.count }

    fn dec_count(&mut self) { self.count -= 1; }

    fn inc_count(&mut self) { self.count += 1; }
}


/*
* the lock should be held before calling any of the methods except for new.
*/
struct _ReplayDirector {
    scenario_queue:VecDeque<String>,
    log_fp:File,
}

impl _ReplayDirector {
    fn new(mut scenario_fp:File) -> Self {
        let mut scenario_queue = VecDeque::new();
        let mut scenario_str = String::new();

        scenario_fp.read_to_string(&mut scenario_str).expect("fail to read from scenario");
        let scenario_vec:Vec<&str> = scenario_str.split("+").collect();

        for curr_act in scenario_vec {
            if curr_act == "\n" { continue; }
            scenario_queue.push_back(String::from(curr_act));
        }

        let mut log_fp = OpenOptions::new().write(true).create(true).open("log").unwrap();
        write!(log_fp, "---------------------From _init_---------------------\n").expect("write failed\n");
        write!(log_fp, "tid: 1        | func_name: main\n").expect("write failed\n"); 

        _ReplayDirector{
            scenario_queue:scenario_queue,
            log_fp:log_fp,
        }
    }

    fn get_next_act(&self) -> String { self.scenario_queue.front().unwrap().to_string() }

    fn update_next_act(&mut self){ self.scenario_queue.pop_front(); }

    fn write_log(&mut self, tid:&str, func_num:i32, func_name:&str, var_addr:Option<*const u64>, file_path:Option<&str>, line_num:i32){
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
                write!(self.log_fp, "tid: {:<8} | func_num {:<3} | func_name: {:<8} | lock_var_addr: {:<10?} | {} : {}\n", 
                            tid, func_num, func_name, var_addr, file_path, line_num).expect("write failed\n");
            },
            None => {
                write!(self.log_fp, "tid: {:<8} | func_num {:<3} | func_name: {:<8} | lock_var_addr: {:<10} | {} : {}\n", 
                            tid, func_num, func_name, "None", file_path, line_num).expect("write failed\n");
            },
        }
    }
}
