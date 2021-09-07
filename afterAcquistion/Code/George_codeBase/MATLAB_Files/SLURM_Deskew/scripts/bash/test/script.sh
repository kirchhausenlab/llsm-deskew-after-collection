
#!/bin/bash

FAIL=0

echo "starting"

./sleeper.pl 2 0 &
./sleeper.pl 3 0 &
./sleeper.pl 2 0 &
./sleeper.pl 2 1 &


for job in `jobs -p`
do
echo $job
    wait $job || let "FAIL+=1"
done

echo $FAIL


if [ "$FAIL" == "0" ];
then
    echo "YAY!"
else
    echo "FAIL! ($FAIL)"
fi