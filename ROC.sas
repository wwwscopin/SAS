libname wbh "H:\SASTest\SelfLearn";

proc contents data=wbh.hsb2;run;

data hsb;
	set wbh.hsb2;
	 hon=(write>60);
run;

ods graphics on;
proc logistic data=hsb plots=roc(id=prob);
   model hon = female math read;
   roc 'female' female;
   roc 'maths score' math;
   roc 'read' read;	
   *roccontrast reference('female') / estimate e;
run;
ods graphics off;
