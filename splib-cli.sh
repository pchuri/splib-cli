tmp=`mktemp -d`
curl -c "$tmp/c.txt" -d "userId=$1&password=$2" \
-H "Content-Type: application/x-www-form-urlencoded" \
-X POST "https://splib.or.kr/intro/program/memberLoginProc.do" \
> /dev/null 2>&1
curl -s -b "$tmp/c.txt" https://splib.or.kr/intro/index.do | awk -f awk.script
rm -rf "$tmp"
