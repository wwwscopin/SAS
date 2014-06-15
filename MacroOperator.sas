data test;
	input A;
	cards;
	2
	4
	5
;
run;


data testb;
	text="Hello World!";
run;
proc print;run;


%macro test/minoperator; 
%let dsn=ds;
%if &dsn # ae ds co cm %then %do; 
proc print data=test;run;
%end;
%mend; 
%test; 
