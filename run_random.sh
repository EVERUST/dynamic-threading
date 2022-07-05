CNT=0
RCNT=0
ARR_IND=0
myArray=("1" "1.1" "1.2" "1.3" "1.4" "1.5" "1.6" "1.7" "1.8" "1.9" "1.10" "1.11" "1.12" "1.13" "1.14" "1.15" "1.16" "1.17" "none")

cd build
echo testing environment set up - success

echo -e -n "\r\e[kNOW TESTING   "
export PRIVILEGED_THREAD=${myArray[$ARR_IND]}
while :
do
	./rse . '../' >& prog_out
	exit_status=$?

	if [ $exit_status -eq 0 ];
	then
#<<COMMENT
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
#COMMENT

		#echo -e -n '\r\e[k'$RCNT exit success
	else
		#echo -e '\n'$RCNT EXIT FAILURE
		echo -e '\n\033[0;31mDETECTED FAILURE\033[0m'
		mv log ../TLE/SC$CNT
		mv prog_out ../TLE/OUT$CNT
		CNT=$((CNT+1))
		break
	fi
	RCNT=$((RCNT+1))
done

cp struct ../TLE/prog_struct
cd ../TLE
cp SC0 scenario
echo -e '\033[0;36m'TARGET PROGRAM OUTPUT:'\033[0m'
./tle
echo -e '\033[0;36m'TARGET PROGRAM EXECUTION ORDER:'\033[0m'
cat log
echo -e '\033[0;36m'TARGET PROGRAM STRUCTURE:'\033[0m'
cat prog_struct
cd ..

