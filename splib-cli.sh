curl -c c.txt -d "userId=$1&password=$2" \
-H "Content-Type: application/x-www-form-urlencoded" \
-X POST "https://splib.or.kr/intro/program/memberLoginProc.do" > /dev/null 2>&1

curl -s -b c.txt https://splib.or.kr/intro/index.do > out.txt 
cat out.txt | grep /intro/program/mypage/loanStatusList.do