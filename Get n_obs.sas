data test;
	input wbh;
	cards;
	1
	2
	3
	4
	5
	;
run;

data _null_;
call SYMPUT('n_obs', put(n_obs, 5.));
stop;
set test nobs = n_obs;
run;

%put &n_obs;
