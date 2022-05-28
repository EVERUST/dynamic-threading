#![allow(unused)]
use std::sync::{
    Arc,
    Mutex,
};
use std::time::Duration;
use std::thread;
use std::panic;
use std::process;

struct Shared{
    data:Option<i32>,
}

fn thrd1(shared:Arc<Mutex<Shared>>){
	//thread::sleep(Duration::from_millis(10));
    let mut shared = shared.lock().unwrap();
    shared.data = Some(1);
}

fn thrd2(shared:Arc<Mutex<Shared>>){
	thread::sleep(Duration::from_millis(5));
    let mut shared = shared.lock().unwrap();
    println!("recved {:?}", shared.data.unwrap());
}

fn main(){
    let ori_hook = panic::take_hook();
    panic::set_hook(Box::new(move |panic_info| {
        ori_hook(panic_info);
        process::exit(1);
    })); 
    let mut children = vec![];

    let shared = Arc::new(Mutex::new(Shared{data:None}));
    let cloned_share1 = Arc::clone(&shared);
    let cloned_share2 = Arc::clone(&shared);

    children.push(thread::spawn(move || {
        thrd1(cloned_share1);
    }));
    children.push(thread::spawn(move || {
        thrd2(cloned_share2);
    }));
    for child in children{
        let _ = child.join();
    }
    //let mut shared = shared.lock().unwrap();
    //println!("main found {:?}", shared.data.unwrap());
}
