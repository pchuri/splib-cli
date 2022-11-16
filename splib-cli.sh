curl -c c.txt -d "userId=$1&password=$2" \
-H "Content-Type: application/x-www-form-urlencoded" \
-X POST "https://splib.or.kr/intro/program/memberLoginProc.do" \
> /dev/null 2>&1

curl -s -b c.txt https://splib.or.kr/intro/index.do > out.txt 
# user name
awk -F '<|>' '/barcodeInfo/ {print $3}' out.txt
# loan count
awk -F '<|>' '/intro\/program\/mypage\/loanStatusList.do/ {sub(/ /,"",$3);print $3":"$5}' out.txt 
# doorae count
awk -F '<|>' '/\/intro\/program\/mypage\/dooraeLillStatusList.do/ {sub(/ /,"",$3);print $3":"$5}' out.txt
