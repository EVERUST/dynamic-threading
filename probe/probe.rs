use std::{
    sync::{
        Arc,
        Mutex,
    },
    fs::File,
    io::prelude::*,
};

//static fp:Arc<Mutex<File>>;
static mut fp:Option<Arc<Mutex<File>>> = None;//Arc::new(Mutex::new(File::create("log").unwrap()));

fn _init_(){
    unsafe{
        fp = Some(Arc::new(Mutex::new(File::create("log").unwrap())));
        if let Some(fp_arc) = &fp{
            fp_arc.lock().unwrap().write_all(b"-------------init-------------\n");
        }
    }
}