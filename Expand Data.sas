options mprint;

data test;
	input var $ n freq;
	cards;
	a1    2    .5
	a2    6    .3333
	;
run;



%macro test;
data out; if 1=1 then delete;run;
	%do i=1 %to 2;
	data _null_;
		set test(firstobs=&i obs=&i);
		m=round(n*freq);
		call symput("n", compress(put(n,2.0)));
		call symput("m", compress(put(m,2.0)));
	run;
	data temp;
		do i=1 to &n;
			if i<=&m  then var=1; else var=0;
			output;
		end;
		drop i;
	run;
	data out;
		set out temp;
	run;
	%end;
%mend test;
%test;

proc print;run;
