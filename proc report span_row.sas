data class30;
set sashelp.class;
do check = 1 to 30;
   output;
   end;
   run;
ods pdf file ='c:\temp\class30.pdf';
proc report data=class30 nowd out=show spanrows;
column age name check sex;
define age /order;
define name / order ;
run;
ods pdf close;

proc print data=show;run;

 data base;
 input age ?? name $;
 datalines;
 15   Fred
 14   Sally
 x    John
 run;

 proc print data=base;run;

 data _null_;
    array arr[*] v1-v5 (1 2 3 4 5);
    put "before:" (v1-v5) (= +0);
    /* reverse the variable list in a new array definition and sort */
    array rev[*] v5-v1;
    call sortn(of rev[*]);
    put "after :" (v1-v5) (= +1);
  run;
  /* on log
  before: v1=1  v2=2  v3=3  v4=4  v5=5
  after : v1=5  v2=4  v3=3  v4=2  v5=1
  */

proc sql;
select count(*) into :howmany
from sashelp.class;
quit;
%put |&howmany|;
