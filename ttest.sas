data have;

        input value;
diff=value-10;
cards;
12
13
13
12
7
8
9
11
10
11
;
proc ttest data=have h0=10 alpha=0.05;
var value;
run;

proc means t prt;
var diff;
run;

proc univariate data=have mu0=10;
   var value;
run;

proc reg data =have;
        model value=;
        test10: test intercept =10;
run; quit;
