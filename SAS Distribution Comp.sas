/* simulate three variables with different distributions */
data Wide;
call streaminit(123);
do i = 1 to 100;
   Uniform = rand("Uniform");
   Normal = rand("Normal");
   Gamma = rand("Gamma", 4);
   output;
end;
run;

proc print;run;
 
/* transpose from wide to long data format to create a CLASS variable */
proc transpose data=Wide name=ID out=Long(drop=i);  by i;  run;

data Long; 
   set Long(rename=(Col1=x)); 
   label ID=;
run;
 
/* create comparative histograms and CDF plots */
ods select Histogram CDFPlot;
proc univariate data=Long;
   class ID;
   histogram x / nrows=3;
   cdfplot x / nrows=3;
run;
