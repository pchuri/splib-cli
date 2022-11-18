LOGIN_URL="https://splib.or.kr/intro/program/memberLoginProc.do"
INDEX_URL="https://splib.or.kr/intro/index.do"
CT="Content-Type: application/x-www-form-urlencoded"
D="userId=$1&password=$2"
curl -c - -s -o/dev/null -d "$D" -H "$CT" -X POST $LOGIN_URL | curl -s -b @- $INDEX_URL | awk -f awk.script
