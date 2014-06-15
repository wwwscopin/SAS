data Sim;
	do i=1 to 100;
		x=i; y=i*2+ranuni(1234); z=-x+ranuni(4321);
		s=x+z;
		output;
	end;
run;

proc print;run;

proc reg data=sim;	
	model y=x;
run;
proc reg data=sim;	
	model y=z;
run;

proc reg data=sim;	
	model y=x z;
run;

proc sgplot data=sim;
	reg x=s y=y / CLM CLI;
run;
