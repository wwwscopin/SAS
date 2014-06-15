libname wbh "C:\Users\XGG8\WBH\SASTest\SelfLearn";

proc ttest data=wbh.hsb2 h0=50;
var write;
run;

proc univariate data=wbh.hsb2 loccount mu0=50;
var write;
run;

proc freq data=wbh.hsb2;
table female/binomial(p=0.5);
exact binomial;
run;

proc freq data=wbh.hsb2;
tables race/chisq testp=(10 10 10 70);
run;

proc ttest data=wbh.hsb2;
class female;
var write;
run;

proc npar1way data=wbh.hsb2 wilcoxon;
class female;
var write;
run;

proc freq data=wbh.hsb2;
table schtyp*female/chisq;
run;

proc freq data=wbh.hsb2;
tables schtyp*race/fisher;
run;

proc glm data=wbh.hsb2;
	class prog;
	model write=prog;
	means prog;
run;

proc npar1way data=wbh.hsb2;
class prog;
var write;
run;

proc ttest data=wbh.hsb2;
paired write*read;
run;

data hsb2;
	set wbh.hsb2;
	diff=write-read;
run;

proc univariate data=hsb2;
	var diff;
run;

data set1;
  input Q1correct Q2correct students;
  datalines;
  1 1 172
  0 1 6
  1 0 7
  0 0 15
run;


proc freq data=set1;
	tables Q1correct*Q2correct;
	exact mcnem;
	weight students;
run;

proc glm data=wbh.hsb2;
model y1 y2 y3 y4=;
repeated a;
run;

proc genmode data='c:\mydata\exercise' descending;
	class id diet;
	model highpulse=diet/dist=binomial link=logit;
	repeated subject=id/type=exch;
run;

proc glm data=wbh.hsb2;
	class female ses;
	model write=female ses female*ses;
run;

data hsb2_ordered;
  set wbh.hsb2;
  if 30 <= write <=48 then write3 = 1;
  if 49 <= write <=57 then write3 = 2;
  if 58 <= write <=70 then write3 = 3;
run;

proc logistic data = hsb2_ordered desc;
  model write3 = female read socst / expb;
run;

proc logistic data =wbh.hsb2 descending;
  class prog schtyp;
  model female = prog schtyp prog*schtyp / expb;
run;


proc corr data=wbh.hsb2;
var write read;
run;

proc corr data=wbh.hsb2;
var female read;
run;

proc reg data=wbh.hsb2;
model write=read/stb;
run;

proc corr data=wbh.hsb2 spearman ;
var write read;
run;

proc logistic data=wbh.hsb2;
model write=read/expb;
run;

proc reg data=wbh.hsb2;
model write=female read math science socst/stb;
run;

proc glm data=wbh.hsb2;
class prog;
model write=prog read;
run;

proc logistic data=wbh.hsb2;
model female=read write;
run;
