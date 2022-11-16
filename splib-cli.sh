curl -c c.txt -d "userId=$1&password=$2" \
-H "Content-Type: application/x-www-form-urlencoded" \
-X POST "https://splib.or.kr/intro/program/memberLoginProc.do" \
> /dev/null 2>&1

curl -s -b c.txt https://splib.or.kr/intro/index.do > out.txt 
# user name
grep "barcodeInfo" out.txt \
| sed 's|<span.*>||' \
| sed 's|<.*\">||' \
| awk '{$1=$1;print}'
# loan count
grep "/intro/program/mypage/loanStatusList.do" out.txt \
| sed 's|<\/span>.*>||' \
| sed 's|<a.*">||' \
| sed 's| <span>|:|' \
| awk '{$1=$1;print}'
# doorae count
grep "/intro/program/mypage/dooraeLillStatusList.do" out.txt \
| sed 's|<\/span>.*>||' \
| sed 's|<a.*">||' \
| sed 's| <span>|:|' \
| awk '{$1=$1;print}'

