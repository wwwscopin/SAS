


proc glm data = 'H:\SASTest\SelfLearn\rb4wide';
  model y1 y2 y3 y4 = ;
  repeated a ;
run;
quit;

proc sort data = "H:\SASTest\SelfLearn\hsb2" out=hsbsort;
  by id;
run;

 proc print;run;

proc glm data=hsbsort;
	class female prog;
	model read=female prog/solution;
run;

proc genmod data=hsbsort;
	class female(param=ref ref="1") prog(param=ref ref="3");
	model read=female prog;
run;


proc transpose data=hsbsort out=hsblong name=rwm;
  by id;
  var read write math;
run;
proc print;run;

proc freq data=hsblong;
  tables id*rwm*col1 / cmh2 scores=rank noprint;
run;
