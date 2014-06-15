proc format;
value trt 1='Placebo' 2='Test Drug' 99999='Total';
value sex .='Missing' 1='Male' 2='Female' 99999='Male/Female Combined';
value $all " "=" ";
run;
data class_1;
set sashelp.class;
/* Create numeric variable for sex */
if sex='M' then sexnum=1;
else if sex='F' then sexnum=2;
if _n_ in(1 3 5 7 9 11 13 15 17 19) then trtgrp=1;
else trtgrp=2;
run;
proc print;run;

proc freq;
	tables sexnum*trtgrp;
run;

ods listing close;
/* Exclude the table from the ODS destination. */
ods exclude table;
/* Use PROC TABULATE to output summary data set for Gender by Treatment */
proc tabulate data=class_1 out=sex(drop=_page_ _table_) exclusive;
class sexnum /order=data;
class trtgrp/order=data missing;
table (sexnum all='total'), (trtgrp all='total')*(n pctn<sexnum all>='% of column total') all='total'/misstext='0' ;
quit;

data sex;
set sex;
length varcat value $250;
if _type_=00 then do;
sexnum=99999; trtgrp=99999;
end;
else if _type_=10 then do;
trtgrp=99999;
end;
else if _type_=01 then do;
sexnum=99999;
end;
if trtgrp = 99999 then pct=pctn_00;
else pct=pctn_01;
format sexnum sex. trtgrp trt.;
varcat=put(sexnum,sex.);
value=trim(left(put(n,6.0)))||'('||trim(left(put(pct, 6.0)))||')';
sectno = 1;
subsecno=trtgrp;
keep sectno subsecno sexnum trtgrp varcat value;
run;


ods exclude table;
/* Use PROC TABULATE to output summary data set for Weight by Treatment group */
proc tabulate data=class_1 out=weight(drop=_page_ _table_) exclusive;
class trtgrp/missing;
var weight;
tables (trtgrp all), (weight='')*(mean*f=8.0 median*f=8.0 std*f=8.0
stderr*f=8.0 min*f=8.0 max*f=8.0 n*f=10.0 nmiss*f=10.0
sum*f=10.0);
quit;
data weight;
set weight;
length varcat value $250;
if _type_=0 then trtgrp=99999;
format trtgrp trt.;
sectno = 2;
subsecno=1;
subsecno=subsecno+1;
/* The special character ‘±’ is copied from WORD symbol. Parsons (2008) */
/* has discussed how to create special character in the RTF file from SAS. */
varcat = "Mean ± SEM";
if weight_mean ne . then value=trim(left(put(weight_mean,8.0)))||' ± '
||trim(left(put(weight_stderr,8.0)));
output;
subsecno=subsecno+1;
varcat = "Median";
value=trim(left(put(weight_median,8.0)));
output;
subsecno=subsecno+1;
varcat = "Std Dev";
value=trim(left(put(weight_std,8.0)));
output;

subsecno=subsecno+1;
varcat = "Min, Max";
if weight_min ne . or weight_max ne . then
value=trim(left(put(weight_min,8.0)))||', '||trim(left(put(weight_max,8.0)));
output;
subsecno=subsecno+1;
varcat = "n";
value=trim(left(put(weight_n,6.0)));
output;
drop weight_mean weight_median weight_std weight_stderr
weight_min weight_max weight_n weight_nmiss weight_sum _type_;
run;



/* Combine the two data sets */
data bytrtgrp;
set sex weight;
run;
proc sort data=bytrtgrp;
by sectno trtgrp subsecno;
run;


data temp;
set bytrtgrp;
by sectno trtgrp subsecno;
/* Create variable for first column of the summary table */
length fstcolmn $200.; if first.sectno and sectno=1 then
fstcolmn='^S={font_weight=bold}Gender, n(%)^S={}';
else if first.sectno and sectno=2 then
fstcolmn='^S={font_weight=bold}Weight (lb)^S={}';
if first.sectno;
keep sectno trtgrp subsecno fstcolmn;
run;


data bytrtgrp;
set temp bytrtgrp(in=bb);
by sectno trtgrp subsecno;
length fstcolmn $200.;
if bb then fstcolmn='  '||trim(left(varcat));
/* Drop the treatment total if not needed */
if trtgrp=99999 then delete;
drop sexnum;
format trtgrp trt.;
label trtgrp='Treatment Group';
run;
proc print;run;

options nodate nonumber byline orientation=portrait;
ods escapechar="^";
ods listing close;
ods rtf file="demo4.rtf" startpage=yes /*contents*/ style=journal;
ods proclabel 'Demo 4 – Customized Summary Tables: Gender and Weight';
%datepage;
/* Pretext=’……’ adds the titles in the body of the table. \line\ starts a */
/* new line of the titles */
proc report data=bytrtgrp nowd headskip missing
contents="by treatment group"
style(report)={font_weight=bold pretext="Demo 4 - Customized Summary Tables: Gender and Weight\line By Treatment Group\line"};

column sectno fstcolmn trtgrp, value(dummy);
define sectno/noprint group order=data;
define fstcolmn/group ' ' order=data style(header)={asis=on just=left vjust=middle} style(column)={asis=on cellwidth=5cm just=l};
define trtgrp/across order=data;
define value/format=$all. '' style(column)={cellwidth=3cm just=c};
define dummy / noprint;
run;
/* Add footers in the body of the table */
ods rtf text="^S={outputwidth=65% just=l}Footer 1 in the body of the table";
ods rtf text="^S={outputwidth=65% just=l}Footer 2 in the body of the table";
ods _all_ close;
ods listing;
