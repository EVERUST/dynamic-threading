use std::{
    sync::{Mutex, Arc},
    thread,
};

fn check_shared_not_none(shared:Arc<Mutex<Option<i32>>>) -> bool{
    //let shared = shared.lock().unwrap();
    match *shared.lock().unwrap() {
        Some(_) => true,
        None => false,
    }
}
fn thrd(shared:Arc<Mutex<Option<i32>>>){
    if check_shared_not_none(shared.clone()) {
        let mut shared = shared.lock().unwrap();
        println!("recved {}", shared.unwrap());
        *shared = None;
    }
    else {
        println!("shared is none");
    }
}

fn main(){
    let mut children = vec![];

    let shared = Arc::new(Mutex::new(Some(1)));

    for _ in 0..2 {
        let cloned_share = Arc::clone(&shared);
        children.push(thread::spawn(move || {
            thrd(cloned_share);
        }));
    }

    for child in children{
        let _ = child.join();
    } 
}