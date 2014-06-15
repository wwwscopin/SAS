*Create a temporary dataset... DSN;
data dsn;
a=1;
b=2;
c=3;
d=4;
e=5;
f=6;
run;

%macro test(lib,DSN);

*/1)*/;
data _null_;
      set sashelp.vtable(where=(libname="&LIB" and memname="&DSN"));
      call symput('nvars',nvar);
run;

*/2); 
data _null_;
      set sashelp.vcolumn(where=(libname="&LIB" and memname="&DSN"));
      call symput(cats("var",_n_),name);
run;

*/3)*/ ;
proc datasets library=&LIB;
      modify &DSN;
      rename
      %do i = 1 %to &nvars;
            &&var&i=Rename_&&var&i
      %end;
      ;
run;
%mend;

%test(WORK,DSN);quit;

proc print data=dsn;run;
