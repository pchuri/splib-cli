i=1
length=$(($#/2))
rm -f out.txt
while [ $i -le $length ]
do
 user=$1
 pw=$2
 sh splib-cli.sh $1 $2 >> out.txt
 echo '========================' >> out.txt
 shift 2
 printf "Progress : (%d / %d)\r" $i $length
 i=$((i+1))
done
