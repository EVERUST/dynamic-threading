export LLVM=/usr/lib/llvm-13
export TARGET_PROGRAM=../toy_bugs/read_none.rs

# build.sh
rm -rf build
mkdir build
cd build

#clang -pthread -c -D STACKTRACE ../probe/probe.c -o probe.o
rustc --crate-type=lib --emit=obj ../probe/probe.rs -o probe.o
#clang -pthread -c ../probe/probe.c -o probe.o
#clang -pthread -c ../probe/probe.cpp -o probe.o

rustc --crate-type=lib --emit=obj -o probe.o ../probe/probe.rs
cmake -DLT_LLVM_INSTALL_DIR=$LLVM ../pass
make

rustc --emit=llvm-ir -g -C opt-level=0 $TARGET_PROGRAM -o target.ll
#rustc --emit=llvm-ir $TARGET_PROGRAM -o target.ll
$LLVM/bin/opt -o out.ll -load-pass-plugin ./libpass.so -passes=Custom_pass target.ll
$LLVM/bin/clang -L /usr/lib/rustlib/x86_64-unknown-linux-gnu/lib/ -lstd-100ac2470628c6dd -lpthread -lrt out.ll probe.o

../build/a.out
