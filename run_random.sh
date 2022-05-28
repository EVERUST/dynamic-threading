CNT=0
RCNT=0

cd build
echo testing environment set up - success

echo -e -n "\r\e[kNOW TESTING   "
while :
do
	./rse >& prog_out
	exit_status=$?

	if [ $exit_status -eq 0 ];
	then
#<<COMMENT
		if [ $(($RCNT%300)) -eq 0 ];
		then
			echo -e -n "\r\e[kNOW TESTING..."
			RCNT=0
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

