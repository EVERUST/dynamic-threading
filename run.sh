export LLVM=/usr/lib/llvm-13
export TARGET_PROGRAM=../toy_bugs/read_none.rs

CNT=0
RCNT=0
rm -rf TLE
mkdir TLE

#while true;
while [ $RCNT -le 0 ] ;
do
	# build.sh
	rm -rf build
	mkdir build
	cd build

	rustc --crate-type=lib --emit=obj -o probe.o ../probe/probe_RSE.rs
	cmake -DLT_LLVM_INSTALL_DIR=$LLVM ../pass
	make

	rustc --emit=llvm-ir -g -C opt-level=0 $TARGET_PROGRAM -o target.ll

	$LLVM/bin/opt -o out.ll -load-pass-plugin ./libpass.so -passes=Custom_pass target.ll
	$LLVM/bin/clang -L /usr/lib/rustlib/x86_64-unknown-linux-gnu/lib/ -lstd-100ac2470628c6dd -lpthread -lrt out.ll probe.o

	../build/a.out
	exit_status=$?
	
	if [ $RCNT -eq 0 ];
	then
		cp struct ../TLE/STRUCT
	fi

	if [ $exit_status -eq 0 ];
	then
		echo exit_status is $exit_status
	else
		cp log ../TLE/SC$CNT
		CNT=$((CNT+1))
	fi
	RCNT=$((RCNT+1))
	cd ..
done
