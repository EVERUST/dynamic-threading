export RUST_BACKTRACE=full
RCNT=0


export SLEEP_CHANCE=3
export NOISE_MIN=1
export NOISE_MAX=4

timestamp=$(date +%T)
echo $timestamp : testing starts at
echo execution with $SLEEP_CHANCE chances and noise between $NOISE_MIN , $NOISE_MAX
echo -e -n "\r\e[kNOW TESTING   "
while :
do
	./fd_rse . '../input_dir' >& prog_out # bug case 1 ~ 4
	#./rse_fd -H -I -e ll fd '../input_dir' >& prog_out # bug case 5
	exit_status=$?

	if [ $exit_status -eq 0 ];
	then
		rm static_sleep_record
		if [ $(($RCNT%300)) -eq 0 ];
		then
			echo -e -n "\r\e[kNOW TESTING..."
		elif [ $(($RCNT%200)) -eq 0 ];
		then
			echo -e -n "\r\e[kNOW TESTING.. "
		elif [ $(($RCNT%100)) -eq 0 ];
		then
			echo -e -n "\r\e[kNOW TESTING.  "
		fi
	else
		echo -e '\n\033[0;31mDETECTED FAILURE\033[0m'
		mv log scenario$RCNT
		mv prog_out prog_out$RCNT
		mv struct struct$RCNT
		break
	fi
	RCNT=$((RCNT+1))
done
timestamp=$(date +%T)
echo testing ended at : $timestamp 
echo total $RCNT trials of execution with $SLEEP_CHANCE chances and noise between $NOISE_MIN , $NOISE_MAX
