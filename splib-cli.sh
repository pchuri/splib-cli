curl -c c.txt https://splib.or.kr >/dev/null 2>&1
curl -b c.txt https://splib.or.kr/intro/program/memberLogout.do >/dev/null 2>&1
curl -b c.txt -d "userId=$1&password=$2" \
-H "Content-Type: application/x-www-form-urlencoded" \
-X POST "https://splib.or.kr/intro/program/memberLoginProc.do"
