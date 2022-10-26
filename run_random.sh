export RUST_BACKTRACE=full
RCNT=0
ARR_IND=0
myArray=("1" "1.1" "1.2" "1.3" "1.4" "1.5" "1.6" "1.7" "1.8" "1.9" "1.10" "1.11" "1.12" "1.13" "1.14" "1.15" "1.16" "1.17" "none")


echo -e -n "\r\e[kNOW TESTING   "
export PRIVILEGED_THREAD=${myArray[$ARR_IND]}
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
			RCNT=0
			ARR_IND=$((ARR_IND+1))
			if [ $ARR_IND -eq 19 ]
			then
				ARR_IND=0
			fi
			export PRIVILEGED_THREAD=${myArray[$ARR_IND]}
			echo $PRIVILEGED_THREAD
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
