long int a;
int temp = a - 4;

if (temp == 0) goto L1;
if (temp != 0) goto L2;

L1:
a += 4;

goto end;

L2:
a += 2;

end: