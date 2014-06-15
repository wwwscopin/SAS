options spool;
data test;
  input var1 $ var2 $;
  datalines;
  3.4 5 
  4.55 5.3 
  4 3.444 
  ;
run;


proc sql noprint;
   select strip(name)||"_n=input("||strip(name)||",best12.)"  into :convert 
separated by ";"
   from sashelp.vcolumn
   where libname="WORK" and upcase(memname)="TEST";
quit;
%put &convert; quit;

data test1;
   set test;
   &convert;
run;

proc print;run;
