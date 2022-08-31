export LLVM=/usr/lib/llvm-13
export TARGET_HOME_DIR=/home/uja/capstone/test_target/ripgrep
export TESTING_DIR=$PWD
export RUSTFLAGS=--emit=llvm-ir
export NIGHTLY_LIB=/home/uja/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib

rm -rf out_dir
rm -rf build
mkdir out_dir
mkdir build

cd $TARGET_HOME_DIR
cargo clean
cargo +nightly build

for entry in ./target/debug/deps/*.ll
do
	cp $entry $TESTING_DIR/build/
done

cd $TESTING_DIR/build

cmake -DLT_LLVM_INSTALL_DIR=$LLVM ../opt_pass
make

for entry in *.ll
do
	echo $entry
	$LLVM/bin/opt -o target_rse_$entry -load-pass-plugin ./libpass.so -passes=RSE_pass $entry
	$LLVM/bin/opt -o target_err_$entry -load-pass-plugin ./libpass.so -passes=TLE_pass $entry
done

rustc --crate-type=lib --emit=obj -o probe_rse.o ../probe/probe_RSE.rs
rustc --crate-type=lib --emit=obj -o probe_err.o ../probe/probe_ERR.rs

$LLVM/bin/clang -o ../out_dir/rse $NIGHTLY_LIB/libstd-91db243dd05c003b.so $NIGHTLY_LIB/librustc_driver-01adb97716082640.so -lpthread -pthread -lrt -lm target_rse_*.ll probe_rse.o 
$LLVM/bin/clang -o ../out_dir/err $NIGHTLY_LIB/libstd-91db243dd05c003b.so $NIGHTLY_LIB/librustc_driver-01adb97716082640.so -lpthread -pthread -lrt -lm target_err_*.ll probe_err.o 


#rm *.ll
unset LLVM
unset TARGET_HOME_DIR
unset TESTING_DIR
unset RUSTFLAGS
unset NIGHTLY_LIB

cd ..
#./run_random.sh
