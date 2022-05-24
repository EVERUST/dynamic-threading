CNT=0
RCNT=0

cd build

while [ $RCNT -le 1000 ] ;
do
	./rse > prog_out

	if [ $? -eq 0 ];
	then
		echo $RCNT exit success
	else
		mv log ../TLE/SC$CNT
		mv prog_out ../TLS/OUT$CNT
		CNT=$((CNT+1))
	fi
	RCNT=$((RCNT+1))
done

cp struct ../TLE/prog_struct
