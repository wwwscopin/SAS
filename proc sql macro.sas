data test;
	input idx A $;
	cards;
1         A
2         B
3         N
4         Q
5         K
6         K
7         K
;
run;

proc sql noprint;
   select distinct(A) into : AM separated by " "
   from test;
run;

%put &am;
quit;
