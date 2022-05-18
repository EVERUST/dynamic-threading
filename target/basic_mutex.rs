use std::sync::Mutex;

fn main() {
    let mutex = Mutex::new(0);
    let mutex2 = Mutex::new(0);
    {    
        let _guard = mutex.lock().unwrap();
        let _guard2 = mutex2.lock().unwrap();
    }
}
