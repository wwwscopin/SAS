data a;
	input x y$;
	cards;
    1  one     
    2  two     
    2  two     
    3  three
	;
run;

data b;
	input x z$;
	cards;
    1  one     
    2  two     
    4  four 
	;
run;

proc sql;
	create table test as 
	select a.*
	from a as a 
	except 
	select b.x
	from b as b
	;
quit;
 

proc print data=test;run;
