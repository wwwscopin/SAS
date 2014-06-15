proc sql noprint;
 select count(sex) into :male_cnt 
 from sashelp.class
 where sex = 'M';
quit;
%put 'Number of Males = ' &male_cnt;

proc options;run;
options  VALIDVARNAME=v7;

data test;
	_2_abcderghfixxxxxxx="wbh";
run;
proc print;run;

proc template;
     list styles;
run;
