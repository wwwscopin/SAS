data a;
      input name $ per a_objective;
cards;
Alabama     62.4  145077
Alaska      134.5 2000
Arizona     61.1  20000
Arkansas    88.7  55500
Baltimore   92.5  16788
California  189.7 20000
Chicago     156.4 11350
Colorado    72.4  13334
Connecticut 101   15000
Delaware    90.5  12000
Total 90.1  2165965
;
run;
proc print data=a; run;

data b;
	set a;
	call symput(name, strip(a_objective));
run;

*%let obj_a=a_objective;
%macro a (juri);
ods pdf file="&juri..pdf" ;
proc report data=b nowd;
      where name="&juri";
      title "Figure 1: Percent of grantee''s annual HIV testing objective         
            (Objective=&&&juri)";
*     by &juri;
run;
ods pdf close;
%mend;
%a (Alabama);

*********************************************************************************************;
