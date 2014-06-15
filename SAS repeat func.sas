data da;
   do i = 1 to 20;
      %sysfunc(repeat(output;, 2000 - 1));
   end;
run;

proc print;run;
proc freq data=da;
	table i;
run;


