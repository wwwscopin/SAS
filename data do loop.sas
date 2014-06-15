data b; 
	input id x1 x2 y;
	cards;
	1 12 35 1
	2 22 38 2
	3 25 34 3
	4 12 56 1
	5 21 54 2
	6 20 45 3
	7 25 34 3
	;
run;

data newdata;
	set b;
	do i=1 to 3;
	if y=i then decision=1;
		else decision=0;
		output;
	end;
run;

proc print;run;
