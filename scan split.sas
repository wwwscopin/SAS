data test;
	input char $;
	cards;
	1234_v1
1234_v2
582_v1
582_v2
;
run;

data test1;
	set test;
	var1=scan(char, 1, '_');
	var2=scan(char, 2, '_');
run;

proc print;run;
