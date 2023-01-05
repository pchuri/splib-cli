BEGIN {}
{
    if (NR % 2 == 0) {
        b[$1]++; 
    }
}
END {
    if (length(b) == 0) {
        print;
    } else {
        for (k in b) {
            print "-"k": "b[k];
        }
    }
}
