#Check memory or cpu usage of a process
num=0

ps -C chromium-browse -o %cpu > processCheck.txt
grep -o '[0.0-9.9]*' processCheck.txt > processNumbers.txt
cat processNumbers.txt | awk '{ sum+=$1} END {print sum}' > avg.txt
num=$(<avg.txt)
echo "sum is $num"


if [[ "$num" -gt 25 ]]
then
echo 1>brightness
fi
