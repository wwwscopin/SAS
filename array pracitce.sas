data wbh;
	do age=1 to 10; 
		do race=1 to 8;
			n=age*race;
			output;
		end;
	 end;
run;

proc print;run;
data test; set wbh; by age race;
	array a(8) m1-m8;
	retain m1-m8;
	do i=1 to 8;
     if first.age then do;
        a(i)=.;
     end;
   end;

   a(race)=n;
   totn=sum(of m1-m8);
run;
proc print;run;
