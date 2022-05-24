export LLVM=/usr/lib/llvm-13
export TARGET_PROGRAM=../toy_bugs/read_none.rs

rm -rf TLE
mkdir TLE

# build.sh
rm -rf build
mkdir build
cd build

rustc --crate-type=lib --emit=obj -o probe.o ../probe/probe_RSE.rs
cmake -DLT_LLVM_INSTALL_DIR=$LLVM ../pass
make

rustc --emit=llvm-ir -g -C opt-level=0 $TARGET_PROGRAM -o target.ll

$LLVM/bin/opt -o out.ll -load-pass-plugin ./libpass.so -passes=Custom_pass target.ll
$LLVM/bin/clang -o rse -L /usr/lib/rustlib/x86_64-unknown-linux-gnu/lib/ -lstd-100ac2470628c6dd -lpthread -lrt out.ll probe.o

unset LLVM
unset TARGET_PROGRAM

cd ..
./run_random.sh
