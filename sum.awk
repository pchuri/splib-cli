BEGIN {}
{
 if (NR % 2 == 0) {
  b[$1]++; 
 }
}
END {
 for (k in b) {
  print "-"k": "b[k];
 }
}