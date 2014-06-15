proc sort data = "H:\SASTest\SelfLearn\hsb2" out=hsbsort;
  by id;
run;
proc print;run;
proc transpose data=hsbsort out=hsblong name=rwm;
  by id;
  var read write math;
run;
proc print;run;

proc freq data=hsblong;
  tables id*rwm*col1 / cmh2 scores=rank noprint;
run;
