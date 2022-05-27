CNT=0
RCNT=0

cd build

while :
do
	./rse > prog_out

	exit_status=$?

	if [ $exit_status -eq 0 ];
	then
		echo $RCNT exit success
	else
		echo $RCNT EXIT FAILURE
		mv log ../TLE/SC$CNT
		mv prog_out ../TLE/OUT$CNT
		CNT=$((CNT+1))
		break
	fi
	RCNT=$((RCNT+1))
done

cp struct ../TLE/prog_struct
