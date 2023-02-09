LOGIN_URL="https://splib.or.kr/intro/program/memberLoginProc.do"
INDEX_URL="https://splib.or.kr/intro/index.do"
LOAN_URL="https://splib.or.kr/intro/program/mypage/loanStatusList.do"
CT="Content-Type: application/x-www-form-urlencoded"
D="userId=$1&password=$2"

cookies=$(curl -s -c - -d "$D" -H "$CT" -X POST $LOGIN_URL)
echo "$cookies" | curl -s -b @- $INDEX_URL | awk -f loan1.awk
 
loan=$(echo "$cookies" | curl -s -b @- $LOAN_URL | awk -f loan2.awk)
echo "$loan" | awk -f sum.awk
