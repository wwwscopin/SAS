data test;
	length A B $10;
	A='19950606';
	B="1995....";

	if compress(A,'.')>:compress(B,'.') then put "A>B";
	else put "A<=B";
run;

proc print;run;


%let vs=GT;
%put &vs;
%let vs1=&vs.:;
%put &vs1;
