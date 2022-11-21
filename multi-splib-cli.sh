i=1
length=$(($#/2))
rm -f out.txt
while [ $i -le $length ]
do
 user=$1
 pw=$2
 source splib-cli.sh $1 $2 >> out.txt
 echo '========================' >> out.txt
 shift 2
 echo $i
 i=$((i+1))
done
