libname test "H:\SASTest\SelfLearn";

proc print data=test.hsb2;run;

data hsb2;
  set test.hsb2;
run;

proc surveyselect data=hsb2  method = urs sampsize = 100
   rep=5 seed=12345 out=hsbs;
   id _all_;
run;

data hsbsf;
  set hsbs;
  do i = 1 to numberhits;
    output;
  end;
  drop i;
run;


ods output CumulativeModelTest=cum;
ods trace on/label listing;
proc logistic data=hsbsf descending;
  class female (ref='0');
  model prog = female read female*read / link=logit;
  by replicate;
run;
ods trace off;

/*
proc surveylogistic data=hsbsf;
  class female (ref='0');
  model schtyp (event='2') = female read female*read / link=logit;
  by replicate;
run;
*/
ods output close;

proc print;run;
