data test;
input var1 $ var2 $;
datalines;
A  no
A  no
B  yes
B  no
B missing
C  yes
C  yes
C no
C  missing
;

proc sql;
  create table test1 as
  select a.*, sum(var2="yes")>0 as flag
  from test as a
  group by var1;
quit;

proc print data=test1;run;

data a;
input x$ y$;
cards;
A  no
A  no
B  yes
B  no
B missing
C  yes
C  yes
C no
C  missing
;
proc sort data=a;by x descending y;run;
data aa;
set a;
by x descending y;
retain flag 1;
if first.x and y='yes' then flag=1;
if first.x and y='no' then flag=0;
run;

proc print;run;
