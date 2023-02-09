LOGIN_URL="https://splib.or.kr/intro/program/memberLoginProc.do"
INDEX_URL="https://splib.or.kr/intro/index.do"
LOAN_URL="https://splib.or.kr/intro/program/mypage/loanStatusList.do"
CT="Content-Type: application/x-www-form-urlencoded"
D="userId=$1&password=$2"

curl -c .c.txt -s -o/dev/null -d "$D" -H "$CT" -X POST $LOGIN_URL
curl -s -b .c.txt $INDEX_URL | awk -f loan1.awk
 
loan=$(curl -s -b .c.txt $LOAN_URL | awk -f loan2.awk)
echo "$loan" | awk -f sum.awk
rm -rf .*.txt
