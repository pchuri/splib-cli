BEGIN { FS="<|>";ORS=", "}
/barcodeInfo/ {print $3}
/intro\/program\/mypage\/loanStatusList.do/ {sub(/ /,"",$3);print $3": "$5}  
/\/intro\/program\/mypage\/dooraeLillStatusList.do/ {sub(/ /,"",$3);ORS="\n";print $3": "$5;} 
