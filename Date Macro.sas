%let Date =%qsysfunc(inputN(01JAN2006,date9), yymmddn8);
%put >&date<;

%let Date =%qsysfunc(putN('01JAN2006'd, yymmddn8));
%put >&date<;


%let Date = 01JAN2006 ;
data _null_;
call symput("date",left(put("&date"d,yymmddn8.)));
run;
%put &date;


ods html ;
%macro normcheck(varlist) /parmbuff ;
%let i = 1;
%let name_p = %scan(&varlist, &i);
%do %while ( &name_p NE );
    proc univariate data = &name_p ;
     var resid;
    qqplot;
    histogram / normal;
    run;
    %let i= %eval(&i+1);
    %let name_p = %scan(&varlist,&i);
%end;
%mend ;

option mlogic mprint; 
%normcheck(a1 a5 a7 a30 a180)
ods html close;
quit;

