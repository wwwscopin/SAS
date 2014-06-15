
data test;
infile "C:\Users\XGG8\Desktop\test.txt" dlm=",";
input x1$ / x2 x3 x4 ;
run;


data test2;
set test;
var1=substr(x1, 1,1);
var2=substr(x1, 2);
run;

proc sql;
create table test3 as
select var1, var2, x2, x3, x4
from test2;
quit;

proc print;run;
