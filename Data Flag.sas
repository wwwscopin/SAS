data test;	
	input obs v1 ;
	cards; 
1   1 
2   1 
3   1 
4   2 
5   3 
6   3 
7   4 
8   5
9   6
;
run;

proc means data=test median mean;
	class v1; 
	var obs;
	ods output Summary=test1;
	output out=test2 median(obs)=med mean(obs)=avg;
run;

proc print data=test1; run;
proc print data=test2; run;


proc sql;
   create table wbh as 
   select *, (count(*)=1) as flag
   from test
   group by v1;
quit;

proc print data=wbh;run;

data indsn;
set test;
by v1;
if first.v1=last.v1 and first.v1=1 then flag=1;
else flag=0;
test=first.v1;
run;
proc print;run;

/*
proc freq; 
tables v1;
ods output onewayfreqs=wbh;
run;

data wbh;
	set wbh(keep=v1 frequency where=(frequency=1));
run;

data test; 
	merge test wbh(drop=frequency in=A); by v1;
	if A then flag=1; else flag=0;
run;
*/

proc sort data=test dupout=tmp nodupkey; by v1; run;

data new;
	merge test tmp(keep=v1 in=tmp); by v1;
	if tmp then flag=0; else flag=1;
run;

proc print;run;
