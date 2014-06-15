data test; 
	input x1 x2 x3 x4;
	cards;
		2  1  4  -1
		0  -1 2  3
		;
run;

data test1;
	set test;
	/*
	a=max(x1,x2); if a=x1 then a=.;
	b=max(x1,x3); if b=x1 then b=.;
	c=max(x1,x4); if c=x1 then c=.;
	*/

	a=ifn(max(x1,x2)=x1,.,x2);
	b=ifn(max(x1,x3)=x1,.,x3);
	c=ifn(max(x1,x4)=x1,.,x4);

	x5=smallest(1, a, b, c);
	drop a b c;
run;

proc print;run;

data two(keep=x1-x5);
  set test;
  array old[*] x2-x4;
  array new[*] y1-y3;
  do i=1 to 3;
     new[i]=old[i]-x1;
     if new[i]<=0 then do; new[i]=.; old[i]=.; end;
  end;
  x5=min(of new[*])+x1;
run;


