proc sgplot data=sashelp.class;
  scatter x=height y=weight / group=sex;
run;

proc sgplot data=sashelp.class(where=(age<16));
  dot age / response=height stat=mean
            limitstat=stddev numstd=1;
run;
