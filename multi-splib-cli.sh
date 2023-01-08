i=1
length=$(($#/2))
while [ $i -le $length ]
do
    echo '========================'
    user=$1
    pw=$2
    sh splib-cli.sh $1 $2
    shift 2
    i=$((i+1))
done
