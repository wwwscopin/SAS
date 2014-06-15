data temp;
	input  x y $;
	cards;
	1 A
	2 B
	3 C
	4 D
	5 E
	6 F
	7 G
	8 H
	9 I
	10 J
	;
run;
data wbh;
	set temp(keep=x );
	if x>2;
	set temp(in=B);
run;

proc print;run;

data wbh;
	set temp;
	if x>2;
run;

proc print;run;


data test;
	input y$;
	cards;
	A 
	B
	C
;
run;

data out;
	if _n_=1 then set temp;
	set test;
run;
data wbh;
	set temp(keep=x );
	if x>2;
	set temp(in=B);
run;

proc print;run;
