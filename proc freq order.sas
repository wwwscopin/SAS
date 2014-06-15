data test;
	input A;
	cards;
	5
	4
	2
	3
	1
	3
	3
	;
run;
proc format;
	value idx 1="I" 2="II" 3="III" 4="IV";
run;

data temp;
	set test;
	B=A*A;
	C=A*0.1;
	D=B+C;
	if A<=5 then group=1; else group=2;
	format A idx.;
run;

proc freq order=data;
table A*group;
run;

proc freq order=freq;
table A*group;
run;

proc freq order=FORMATTED;
table A*group;
run;

proc freq order=internal;
table A*group;
run;
