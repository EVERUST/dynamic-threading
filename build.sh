export LLVM=/usr/lib/llvm-13
export TARGET_PROGRAM=../toy_bugs/read_none.rs

rm -rf TLE
mkdir TLE

# build.sh
rm -rf build
mkdir build
cd build

rustc --crate-type=lib --emit=obj -o probe_rse.o ../probe/probe_RSE.rs
rustc --crate-type=lib --emit=obj -o probe_tle.o ../probe/probe_TLE.rs

cmake -DLT_LLVM_INSTALL_DIR=$LLVM ../pass
make

rustc --emit=llvm-ir -g -C opt-level=0 $TARGET_PROGRAM -o target.ll

$LLVM/bin/opt -o out_rse.ll -load-pass-plugin ./libpass.so -passes=RSE_pass target.ll
$LLVM/bin/opt -o out_tle.ll -load-pass-plugin ./libpass.so -passes=TLE_pass target.ll

$LLVM/bin/clang -o rssh  -L /usr/lib/rustlib/x86_64-unknown-linux-gnu/lib/ -lstd-100ac2470628c6dd -lpthread -lrt out_rse.ll probe_rse.o
$LLVM/bin/clang -o ../TLE/tle -L /usr/lib/rustlib/x86_64-unknown-linux-gnu/lib/ -lstd-100ac2470628c6dd -lpthread -lrt out_tle.ll probe_tle.o

unset LLVM
unset TARGET_PROGRAM

cd ..
./run_random.sh
