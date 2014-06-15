data temp1;
	do i=1 to 5; 
		output;
	end;
run;

data test;
	if _n_=1 then i=.;
	output;
	set temp1;
run;
proc print;run;


data temp2;
		do j=1 to 10;
		output;
	    end;
run;

proc sql;
	create table test as 
	select *
	from temp2, temp1;
run;


proc print;run;

*ods listing close;
ods trace on;
proc freq data=temp nlevels;
	*table i*j/missing noprint out=outm(drop=percent rename=(count=m));;
	table i/missing nopercent norow nocol;
	ods output Freq.NLevels=test;
	ods output crosstabfreqs=one(keep=i j _type_ frequency rename=(frequency=m));
run;
proc print data=test;run;

proc sort data=one; by i; run;
proc transpose data=one out=one1; by i; var m;run;

proc print data=one1;run;

*ods listing;
ods trace off;


proc report data=temp nowindows nocenter  headline headskip missing
style(report)=[font=(Arial,10pt) frame=void  cellspacing=2 cellpadding=1] split='*';
column i;
column j;
column m;
define i/ order order=internal style(column) = [just=center font_size=1.75];
define j/ style(column) = [just=center font_size=1.75];
define m/ style(column) = [just=center font_size=1.75];
run;
*ods trace on/label listing;
