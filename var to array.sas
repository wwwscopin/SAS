data test;
input ID year;
cards;
1 1
2 4
3 2
4 7
5 9
6 6
7 10
;
run;


data wbh;
	set test;
	array n{10} n1-n10;
	do i=1 to vvalue(year);
		n(i)=0;
	end;
	drop i;
run;

proc print;run;
