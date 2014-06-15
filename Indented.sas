data try;
	patchar=catt('mean', '&#10;', 'std');
	output;
	patchar=catt('A0A0A0A0'x, '|indented|');
	output;
run;

proc print;run;
