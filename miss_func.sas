data test;
	input A B C$ D$;
	cards;
	1 2 A B
	. . C D
	3 4 . E
	5 6 F .
	. 8 . H
	;
run;

proc print;run;

data out;
	set test; 
	*if nmiss( of A, B) then delete;
	*n1=nmiss(of A,B);
	*n2=cmiss(of C,D);
	n1=nmiss(of _numeric_)-1;
	n2=cmiss(of _char_);
	
	*if missing(coalesce(of _numeric_))  or missing(coalescec(of _char_))  then delete;

	/*if missing(coalescec(of _character_))  then idx=1; else idx=0;*/
run;

proc print;run;
