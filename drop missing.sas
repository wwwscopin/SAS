data test;
	input A B C$ D$;
	cards;
	1 2 A B
	. . C D
	3 4 . E
	5 6 F .
	. 8 . H
	9 . . . 
	;
run;


data temp;
	set test;
	if nmiss(of _numeric_) then delete;
run;

proc print noobs;
var _numeric_;
run;


data out;
	set test; 
	
	n1=nmiss(of _numeric_)-1; /*this is to count the number of any numeric variables, here need to minus -1, idea?*/
	n2=cmiss(of _char_); /*this is to count the number of any char variables*/
	n3=cmiss(of _character_);/*same function as the line above*/
	
	test1=coalesce(of _numeric_);/*return the first nonmissing value of any numeric variabales*/
	test2=coalescec(of _char_);/*return the first nonmissing values of any char variables*/

	/* This is to delete the obs when all the variables are missing!*/
	if missing(coalesce(of _numeric_)) then delete;/*For numeric variables*/
	if missing(coalescec(of _char_))  then delete;/*For characteristic variables, here _char_ = _character_ */
	
	
run;

proc print;run;
