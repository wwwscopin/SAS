data t1;
	input x y;
	cards;
	1   5
2   6
3   6
7   9
8   10
11  12
;
run;

proc sort data=t1; by x; run;

data t2;
  set t1 end=b;
  z=lag(y);
  /*if x>z or b;
  proc sort; by decending x;
  */
run;

proc print;run;

data t3;
  set t2;
  if x<z  then z=y;
  y=max(y,lag(z));
 *if y^=z;
run;
