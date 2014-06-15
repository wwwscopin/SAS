%let one_var=1;
%let list=2;

data _null_;
    if "&one_var"=1 then call symput("ss", "&list");
run; 
%put &ss;


%macro test(one_var);
data _null_;
    if &one_var=1 then call symput("sss", "&list"); 
run; 
%put &sss;
%mend;
%test(1);quit;
%put &sss;
