/* Create a macro to add the titles on every page (except the cover page) with */
/* Project number, report descriptions, author, date and page number */
%macro datepage;
/* Leftmargin=3.5in specifies the left margin of the title */
title1 j=l "^S={leftmargin=3.5in}Abbott Nutrition (Project xxxx)";
title2 j=l "^S={leftmargin=3.5in}Statistical Report: Appendix 1";
/* &Sysdate9 displays date in the date9. format */
title3 j=l "^S={leftmargin=3.5in}Created By xxxx xxx on &sysdate9.";
/* Add page number (Page X of Y) (Zender 2007) */
title4 j=l "^S={leftmargin=3.5in}Page ^{thispage} of ^{lastpage}";
title5 " ";
%mend datepage;


/* Orientation= specifies the page orientation */
options nodate nonumber byline orientation=portrait;
/* Add in-line formatting (Zender 2007) */
ods escapechar="^";
ods listing close;
/* The CONTENTS option generates TOC */
ODS rtf file="Demo2.rtf" startpage=yes contents;
/* ODS PROCLABEL '……' generates the first level of the title from TOC */
ods proclabel 'Demo 2: Table 1 - Generate Toc with Informative Table Titles and
Use Default Template - PROC PRINT';
%DatePage;
title6 'Demo 2: Table 1 - Generate Toc with Informative Table Titles and Use
Default Template - PROC PRINT';
/* CONTENTS =”……” generates the second level of the title from TOC. It can be */
/* omitted by specifying CONTENTS=” ”. */
proc print data=sashelp.class noobs label contents ='Subjid - Gender print';
var name /style={font_weight=bold cellwidth=3cm just=l};
var sex/style={cellwidth=3cm just=l};
run;
ods proclabel 'Demo 2: Table 2 - Generate Toc with Informative Table Titles and
Use Default Template - PROC REPORT';
%DatePage;
title6 'Demo 2: Table 2 - Generate Toc with Informative Table Titles and Use
Default Template - PROC REPORT';
PROC REPORT data=sashelp.class nowd headskip missing
contents ='Subjid - Gender Report';
column name sex;
define name /order order=internal style(column)={font_weight=bold
cellwidth=3cm just=left};
define sex /style(column)={cellwidth=3cm just=l};
run;
ods proclabel 'Demo 2: Table 3 - Generate Toc with Informative Table Titles and
Use Default Template - PROC TABULATE';
%DatePage;
title6 'Demo 2: Table 3 - Generate Toc with Informative Table Titles and Use
Default Template - PROC TABULATE';

PROC TABULATE data=sashelp.class missing contents ='Subjid - Evaluable group';
CLASS sex;
/* CONTENTS =”……” generates the third level of the title from TOC. It can */
/* be omitted by specifying CONTENTS =” ”. */
TABLE sex all='Total'/ contents ='Tabulate 3rd label';
run;
ods _all_ close;
ods listing;


proc template;
/* Specify the font type (Arial) and size (10pt) */
%let fnsize=10pt;
%let fntype=arial;
/* Define the name of the customized style template: odsdemo */
define style odsdemo;
/* Modify from SAS pre-defined style: styles.rtf */
parent=styles.rtf;
style contenttitle from indextitle /
/* Add ABBOTT NUTRITION company logo */
preimage="C:\Documents and Settings\All Users\Documents\My Pictures\Sample Pictures\Blue hills.jpg"
/* Specify the text appearing at the beginning of the report below the */
/* company's Logo. Where ^n directs the text to a new line. */
pretext="^nDemo 3: Project # - XXXXXX^n
Statistical Report^n
Appendix 1 - XXXXXX^n
Created by xxxx xxx on &sysdate9.^n ^n
TABLE OF CONTENTS^n ^n "
/* Specify the font type (Arial bold) and size (12pt) of the text above */
font = ("&fntype",12pt) font_weight=bold foreground=black ;
style contents / background=white font = ("&fntype",&fnsize);
/* Control font type (Arial) and size (10 pt) for text specified with ODS */
/* TEXT of the table. */
style usertext / font = ("&fntype",&fnsize) just=c;
style systemtitle / font = ("&fntype",&fnsize) font_weight=bold foreground=black;
style systemfooter / foreground=black font = ("&fntype",&fnsize );
style data / background=white font = ("&fntype",&fnsize );
style cell / background=white font = ("&fntype",&fnsize );
style table / background=white font = ("&fntype",&fnsize )
/* Specify table rules and borders */
rules=all frame= hsides /* for Demo 3 */
/* rules=group frame= hsides */ /* for Demo 4 */
cellspacing=0 cellpadding=3pt borderwidth=1pt;
style byline from titlesandfooters "controls byline text." /
font=("&fntype",&fnsize );
style batch from batch / font = ("&fntype",&fnsize );
style header / background=white foreground=black
font_weight=bold font=("&fntype", &fnsize);
style rowheader / background=white font_weight=bold font=("&fntype",
&fnsize);
style body from document / font = ("&fntype",&fnsize )
/* Specify the margin of the RTF file */
topmargin = 1.0in
bottommargin = 1.0in
leftmargin = 1.0in
rightmargin = 1.0in;
end;
run;
options nodate nonumber byline orientation=portrait;
ods escapechar="^";
ods listing close;
ods rtf file="test2.rtf" startpage=yes contents
style=odsdemo;

/* ODS PROCLABEL '……' generates the first level of the title from TOC */
ods proclabel 'Demo 2: Table 1 - Generate Toc with Informative Table Titles and
Use Default Template - PROC PRINT';
%DatePage;
title6 'Demo 2: Table 1 - Generate Toc with Informative Table Titles and Use
Default Template - PROC PRINT';
/* CONTENTS =”……” generates the second level of the title from TOC. It can be */
/* omitted by specifying CONTENTS=” ”. */
proc print data=sashelp.class noobs label contents ='Subjid - Gender print';
var name /style={font_weight=bold cellwidth=3cm just=l};
var sex/style={cellwidth=3cm just=l};
run;
ods proclabel 'Demo 2: Table 2 - Generate Toc with Informative Table Titles and
Use Default Template - PROC REPORT';
%DatePage;
title6 'Demo 2: Table 2 - Generate Toc with Informative Table Titles and Use
Default Template - PROC REPORT';
PROC REPORT data=sashelp.class nowd headskip missing
contents ='Subjid - Gender Report';
column name sex;
define name /order order=internal style(column)={font_weight=bold
cellwidth=3cm just=left};
define sex /style(column)={cellwidth=3cm just=l};
run;
ods proclabel 'Demo 2: Table 3 - Generate Toc with Informative Table Titles and
Use Default Template - PROC TABULATE';
%DatePage;
title6 'Demo 2: Table 3 - Generate Toc with Informative Table Titles and Use
Default Template - PROC TABULATE';
PROC TABULATE data=sashelp.class missing contents ='Subjid - Evaluable group';
CLASS sex;
/* CONTENTS =”……” generates the third level of the title from TOC. It can */
/* be omitted by specifying CONTENTS =” ”. */
TABLE sex all='Total'/ contents ='Tabulate 3rd label';
run;
ods _all_ close;
ods listing;


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
ods rtf file="demo4.rtf" startpage=yes contents style=journal;
ods proclabel 'Demo 4 – Customized Summary Tables: Gender and Weight';
%datepage;
/* Pretext=’……’ adds the titles in the body of the table. \line\ starts a */
/* new line of the titles */
proc report data=bytrtgrp nowd headskip missing
/*contents="by treatment group"*/
style(report)={font_weight=bold pretext="Demo 4 - Customized Summary Tables: Gender and Weight\line 
\By Treatment Group"};
column sectno fstcolmn trtgrp, value(dummy);
define sectno/noprint group order=data;
define fstcolmn/group ' ' order=data style(header)={asis=on just=left vjust=middle} style(column)={asis=on cellwidth=5cm just=l};
define trtgrp/across order=data;
define value/format=$all. '' style(column)={cellwidth=3cm just=c};
define dummy/noprint;
run;
/* Add footers in the body of the table */
ods rtf text="^S={outputwidth=65% just=l}Footer 1 in the body of the table";
ods rtf text="^S={outputwidth=65% just=l}Footer 2 in the body of the table";
ods _all_ close;
ods listing;
