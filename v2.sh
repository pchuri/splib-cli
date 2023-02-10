LOGIN_URL="https://splib.or.kr/intro/program/memberLoginProc.do"
INDEX_URL="https://splib.or.kr/intro/index.do"
LOAN_URL="https://splib.or.kr/intro/program/mypage/loanStatusList.do"
CT="Content-Type: application/x-www-form-urlencoded"
D="userId=$1&password=$2"

cookies=$(curl -s -c - -d "$D" -H "$CT" -X POST $LOGIN_URL)
echo "$cookies" | curl -s -b @- $INDEX_URL | awk '
BEGIN { FS="<|>";ORS=", "}
/barcodeInfo/ {print $3}
/intro\/program\/mypage\/loanStatusList.do/ {sub(/ /,"",$3);print $3": "$5} 
/\/intro\/program\/mypage\/dooraeLillStatusList.do/ {sub(/ /,"",$3);ORS="\n";print $3": "$5;} 
'

loan=$(echo "$cookies" | curl -s -b @- $LOAN_URL | awk 'BEGIN {FS="[<>]"}
/div class="title"/ {print $3}
/\<span\>\<strong\>/ {print $5}
')

echo "$loan" | awk '
BEGIN {}
{
    if (NR % 2 == 0) {
        b[$1]++; 
    }
}
END {
    if (length(b) == 0) {
        print "No books due";
    } else {
        for (k in b) {
            print "-"k": "b[k];
        }
    }
}
'

