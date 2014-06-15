/* Goal: specify a list of numbers to the PCTLPTS= option */
proc univariate data=sashelp.cars noprint;
   var MPG_City;
   output out=pctl pctlpre=p pctlpts=2.5 10 50 90 97.5; /* numbers go here */
run;
ods excel file="test.xls";
proc print;run;
ods excel close;

proc iml;  
pctl = {2.5 10 50 90 97.5};               /* these are the values  */
print pctl;
s = rowcat( char(pctl) );
print s;
call symputx("PctList", s);                     /* create macro variable */
quit;
 
proc univariate data=sashelp.cars noprint;
   var MPG_City;
   output out=pctl pctlpre=p pctlpts=&PctList; /* use SAS/IML values here */
run;

ODS HTML FILE='TEMP.XLS' STYLESHEET ;
PROC PRINT DATA=SASHELP.CLASS;
RUN; 
ODS HTML CLOSE;

 ODS PHTML FILE='TEMP.XLS' STYLESHEET="TEMP.CSS";
 PROC PRINT DATA=SASHELP.CLASS;
 RUN;
 ODS PHTML CLOSE;

 ODS HTML FILE='TEMP.XLS' ;
PROC REPORT DATA=SASHELP.CLASS NOWD STYLE(REPORT)={Rules=none } style(column)=
{background=white htmlstyle='border:none'} ;
COL Name Age Sex Height Weight;
Define age / order;
BREAK AFTER AGE / SUMMARIZE STYLE={HTMLSTYLE="border-bottom:5px double red;border-left:none;borderright:
none;BORDER-TOP:5px double red"};
RUN;
ODS HTML CLOSE;
