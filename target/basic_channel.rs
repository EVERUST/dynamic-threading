use std::sync::mpsc::channel;
use std::thread;

fn main(){
    let (sender, receiver) = channel();
    thread::spawn(move|| {
        sender.send(1).unwrap();
    });
    println!("{:?}", receiver.recv().unwrap());
}
