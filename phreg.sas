options yearcutoff=1900;
   data Heart;
		do i=1 to 100;
		time=i;
		if i>50 then status=1; else status=0;
		age=round(UNIFORM(1)*100);
		age1=round(UNIFORM(-1)*10);
		output;
		end;
	run;
  proc sort; by descending age; run;

   proc phreg data= Heart;
      model Time*Status(0)= age age1/selection=none;
   run;
