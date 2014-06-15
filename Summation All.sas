data a;
input x1-x10;
cards;
1 2 3 4 . 6 7 8 9 .
. 3 4 5 6 7 8 9 . .
3 6 5 7 . . . . . .
;
run;

data aaa;
	set a;
	y=sum(of x:);
run;
proc print;run;

data aa;
set a;
array num _numeric_;
do over num;
if num="." then num=0;
end;
y=sum(of x1-x10);
run;
