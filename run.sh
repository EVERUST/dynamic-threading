export LLVM=/usr/lib/llvm-13
export TARGET_PROGRAM=./target/thread_pool/src/main.rs
export TARGET_HOME_DIR=target/thread_pool
export RUSTFLAGS=--emit=llvm-ir

rm -rf build
mkdir build
cd build

clang -pthread -c ../probe/probe.c -o probe.o
cmake -DLT_LLVM_INSTALL_DIR=$LLVM ../pass
make

cd ../$TARGET_HOME_DIR
cargo clean
cargo build # rust sets default opt-level for dev is 0.
cnt_entry=0
for entry in target/debug/deps/*.ll
do 
	cp $entry ../../build/target$cnt_entry.ll
	((cnt_entry=cnt_entry+1))
done

cd ../../build

for entry in *.ll
do
	echo $entry
	$LLVM/bin/opt -o out_$entry -load-pass-plugin ./libpass.so -passes=Custom_pass $entry
done

$LLVM/bin/clang -L /usr/lib/rustlib/x86_64-unknown-linux-gnu/lib/ -lstd-100ac2470628c6dd out_*.ll probe.o
../build/a.out
