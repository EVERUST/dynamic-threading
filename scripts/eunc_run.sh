export LLVM=/usr/lib/llvm-13
export TARGET_HOME=/home/uja/hijack
export RUNNER_HOME=/home/uja/capstone/dynamic-threading
export RUSTFLAGS=--emit=llvm-ir

rm -rf build
mkdir build

<<COMMENT
cd $TARGET_HOME
#cargo clean
cargo build
#cargo build --example ****
#cp ./build/debug/examples/*.ll $RUNNER_HOME/build/target.ll
cp ./build/debug/deps/*.ll $RUNNER_HOME/build/target.ll

cd $RUNNER_HOME/build
COMMENT

cp target.ll ./build/
cd ./build

clang -pthread -c ../probe/probe.c -o probe.o

cmake -DLT_LLVM_INSTALL_DIR=$LLVM ../pass
make

#rustc --emit=llvm-ir -g -C opt-level=0 $TARGET_PROGRAM -o target.ll
#cargo rustc -- --emit=llvm-ir -g -C opt-level=0 $TARGET_PROGRAM -o target.ll
#rustc --emit=llvm-ir $TARGET_PROGRAM -o target.ll

$LLVM/bin/opt -o out.ll -load-pass-plugin ./libpass.so -passes=Custom_pass target.ll
$LLVM/bin/clang -o run_me -L /usr/lib/rustlib/x86_64-unknown-linux-gnu/lib/ -lstd-100ac2470628c6dd out.ll probe.o

./run_me

unset LLVM
unset TARGET_HOME
unset RUNNER_HOME
unset RUSTFLAGS
