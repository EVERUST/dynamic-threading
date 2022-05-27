use std::sync::{Arc, Mutex};
use std::thread;
use std::sync::mpsc::channel;

const N: usize = 10;

fn main() {
    let (tx, rx) = channel();
    let mutex = Mutex::new(0);
    let data = Arc::new(mutex);

    for _ in 0..N {
        let (data, tx) = (Arc::clone(&data), tx.clone());
        thread::spawn(move || {
            let mut data = data.lock().unwrap();
            *data += 1;
            if *data == N {
                tx.send(()).unwrap();
            }
        });
    }
    rx.recv().unwrap();
}
