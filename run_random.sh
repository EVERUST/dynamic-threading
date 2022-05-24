CNT=0
RCNT=0

cd build

while [ $RCNT -le 3000 ] ;
do
	./rse 

	exit_status=$?

	if [ $exit_status -eq 0 ];
	then
		echo $RCNT exit success
	else
		echo $RCNT EXIT FAILURE
		mv log ../TLE/SC$CNT
		mv prog_out ../TLS/OUT$CNT
		CNT=$((CNT+1))
	fi
	RCNT=$((RCNT+1))
done

cp struct ../TLE/prog_struct
