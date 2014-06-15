libname wbh "H:\SASTest\SelfLearn";

proc print data=wbh.discrim;run;

proc candisc data=wbh.discrim out=discrim_out ; 
  class job; 
  var outdoor social conservative; 
run;

data fakedata;
  do outdoor = 0 to 30 by 1;
    do social = 5 to 40 by 1;
      do conservative = 0 to 25 by 1;
      	output;
      end;
    end;
  end;
run;

proc discrim data=mylib.discrim testdata=fakedata testout=fake_out out=discrim_out canonical;
  class job;
  var outdoor social conservative;
run;


data plotclass;
  merge fake_out discrim_out;
run;


proc template;
  define statgraph classify;
    begingraph;
      layout overlay;
        contourplotparm x=Can1 y=Can2 z=_into_ / contourtype=fill  
						 nhint = 30 gridded = false;
        scatterplot x=Can1 y=Can2 / group=job includemissinggroup=false
	                 	    markercharactergroup = job;
      endlayout;
    endgraph;
  end;
run;

proc sgrender data = plotclass template = classify;
run;
