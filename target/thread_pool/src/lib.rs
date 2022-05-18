use std::thread;
use std::sync::mpsc;
use std::sync::Arc;
use std::sync::Mutex;

pub struct ThreadPool {
    workers: Vec<Worker>,
    sender: mpsc::Sender<Message>,
}


trait FnBox {
    fn call_box(self: Box<Self>);
}

impl<F: FnOnce()> FnBox for F {
    fn call_box(self: Box<F>) {
        (*self)()
    }
}

type Job = Box<dyn FnBox + Send + 'static>;

enum Message {
    NewJob(Job),
    Terminate,
}

impl ThreadPool {
    pub fn new(size: u32) -> ThreadPool {
        assert!(size > 0);
        
        let (sender, receiver) = mpsc::channel();
        /*
        let receiver_mutex = Mutex::new(receiver));
        let receiver = Arc::new(receiver_mutex);
        */
        let receiver = Arc::new(Mutex::new(receiver));

        let mut workers = Vec::with_capacity(size.try_into().unwrap());

        for id in 0..size {
            // create some threads and store them in the vector
            workers.push(Worker::new(id.try_into().unwrap(), Arc::clone(&receiver)));
        }

        ThreadPool {
            workers,
            sender,
        }
    }

    pub fn execute<F>(&self, f: F)
        where
            F: FnOnce() + Send + 'static
    {
        let job = Box::new(f);
        self.sender.send(Message::NewJob(job)).unwrap();
    }
}

struct Worker {
    id: usize,
    thread: Option<thread::JoinHandle<()>>,
}

impl Worker {
    fn new(id: usize, receiver: Arc<Mutex<mpsc::Receiver<Message>>>) -> Worker {
        let thread = thread::spawn(move || {
            loop {
                let message = receiver.lock().unwrap().recv().unwrap();
                match message {
                    Message::NewJob(job) => {
                        println!("Worker {} got a job; executing.", id);
                        job.call_box();
                    },
                    Message::Terminate => {
                        println!("Worker {} was told to terminate.", id);
                        break;
                    },
                }
            }
        });

        Worker {
            id,
            thread: Some(thread),
        }
    }
}

impl Drop for ThreadPool {
    fn drop(&mut self){
        println!("Sending terminate message to all workers.");
        for _ in &mut self.workers{
            self.sender.send(Message::Terminate).unwrap();
        }

        println!("Shutting down all workers.");

        for worker in &mut self.workers {
            println!("Shutting down worker {}", worker.id);
            if let Some(thread) = worker.thread.take() {
                thread.join().unwrap();
            }
        }
    }
}
