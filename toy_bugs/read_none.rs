#![allow(unused)]
use std::sync::{
    Arc,
    Mutex,
};
use std::time::Duration;
use std::thread;

struct Shared{
    data:Option<i32>,
}

fn thrd1(shared:Arc<Mutex<Shared>>){
    println!("in thred 1");
    //thread::sleep(Duration::from_millis(1000));
    let mut shared = shared.lock().unwrap();
    shared.data = Some(1);
}

fn thrd2(shared:Arc<Mutex<Shared>>){
    let mut shared = shared.lock().unwrap();
    println!("recved {:?}", shared.data.unwrap());
}

fn main(){
    let mut children = vec![];

    let shared = Arc::new(Mutex::new(Shared{data:None}));
    let cloned_share1 = Arc::clone(&shared);
    let cloned_share2 = Arc::clone(&shared);

    children.push(thread::spawn(move || {
		println!("here and now!");
		let i:u32 = 0;
        thrd1(cloned_share1);
    }));
    children.push(thread::spawn(move || {
        thrd2(cloned_share2);
    }));
    for child in children{
        let _ = child.join();
    }
    let mut shared = shared.lock().unwrap();
    println!("main found {:?}", shared.data.unwrap());
}
