OPTIONS PAGENO=1 PS=65 ls=120 missing=. mlogic mprint symbolgen source notes;

%let colname=%str("2008"|"2009"|"2010"|"2011"|"Cumulative\{super b}");
/*
%let colname=2008|2009|2010|2011|Cumulative\{super b};
%let col = %scan(&colname, 1, |);
%put &col;
*/


%let delim =%str(|);

%macro ttab( cname=);
%put &cname;
%put &colname;
%let i = 1;
%let col = %qscan(&cname, &i, &delim, mq);
%do %while (%bquote(&col) NE );
	%put &col;

    %let i= %eval(&i+1);
	%let col = %qscan(&cname, &i, &delim, mq);
%end;
%mend ttab;

%ttab(cname=&colname);

data test;
	date="1970....";
	if substr(date,5,2)='..' then substr(date,5,2)='12';	if substr(date,7,2)='..' then substr(date,7,2)='31';
run;
proc print;run;


%macro LT(vs=);
%if %str(&vs)=%str(GT) %then %put &vs=GT;
%if %str(&vs)=%str(LT) %then %put &vs=LT;
%mend LT;

%LT(vs=GT);
%LT(vs=LT);

data wbh.&var1._&vs._&var2;
	set temp(keep=mpv_uid report_state_cd stateno &var1 &var2);
	A=compress(&var1, '.'); B=compress(&var2, '.');
	if length(A)=length(B)=8 then do; if A &vs B; end;
	else if length(A)>=6 and length(B)>=6 %then do; if substr(A,1,6) &vs substr(B,1,6);end;
	else if length(A)>=4 and length(B)>=4 %then do; if substr(A,1,4) &vs substr(B,1,4);end;
	else delete;
run;




%comp(var1=_aids_dxx_dt_num, vs=NE, var2=_aids_dxx_dt);quit;
