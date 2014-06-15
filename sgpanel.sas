proc iml;
varNames = {"Gamma" "Normal" "Uniform"};
use Wide;  read all var varNames into x;  close Wide;
 
/* assume nonmissing values */
x = x - mean(x);          /* 1. Center the variables */
N = nrow(x);
F = j(nrow(x), ncol(x));
do i = 1 to ncol(x);      /* 2. Compute quantile of each variable */
   F[,i] = (rank(X[,i])-0.375)/(N+0.25); /* Blom (1958) fractional rank */
end;
ID = repeat(varNames, N); /* 3. ID variables */
create Spread var {ID x F};  append;  close Spread;
quit;
 
title "Comparative Spread Plot";
proc sgpanel data=Spread;
   panelby ID / rows=1 novarname;
   scatter x=f y=x;
   refline 0 / axis=y;
   colaxis label="Proportion of Data";
   rowaxis display=(nolabel);
run;
