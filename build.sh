export LLVM=/usr/lib/llvm-13
export TARGET_HOME_DIR=/home/uja/capstone/read_none
export TESTING_DIR=$PWD
export RUSTFLAGS=--emit=llvm-ir

#rm -rf TLE
#rm -rf build
mkdir TLE
mkdir build

cd $TARGET_HOME_DIR
cargo clean
cargo build
cnt_entry=0
for entry in ./target/debug/deps/*.ll
do
	cp $entry $TESTING_DIR/build/target$cnt_entry.ll
    ((cnt_entry=cnt_entry+1))
done

cd $TESTING_DIR/build
cmake -DLT_LLVM_INSTALL_DIR=$LLVM ../pass
make

for entry in *.ll
do
	echo $entry
	$LLVM/bin/opt -o target_rse_$entry -load-pass-plugin ./libpass.so -passes=RSE_pass $entry
	$LLVM/bin/opt -o target_tle_$entry -load-pass-plugin ./libpass.so -passes=TLE_pass $entry
done

rustc --crate-type=lib --emit=obj -o probe_rse.o ../probe/probe_RSE.rs
rustc --crate-type=lib --emit=obj -o probe_tle.o ../probe/probe_TLE.rs

$LLVM/bin/clang -o rse -L /usr/lib/rustlib/x86_64-unknown-linux-gnu/lib/ -lstd-100ac2470628c6dd -lpthread -lrt target_rse_*.ll probe_rse.o
$LLVM/bin/clang -o ../TLE/tle -L /usr/lib/rustlib/x86_64-unknown-linux-gnu/lib/ -lstd-100ac2470628c6dd -lpthread -lrt target_tle_*.ll probe_tle.o

unset LLVM

cd ..
./run_random.sh