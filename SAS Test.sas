data WORK.TEST;
  input Name $ Age;
datalines;
John +35
;
run;

proc print;run;

data input;
input var1 $ var2 $;
cards;
A        one
A        two
B        three
C        four
A        five
;
run;

data WORK.ONE WORK.TWO;
  set WORK.INPUT;
  if Var1='A' then output WORK.ONE;
  output;
run;

proc print data=one;run;
proc print data=two;run;



data one;
	input num char1 $;
	cards;
	1 A
	2 B
	4 D
	;
run;

data two;
	input num char2 $;
	cards;
	2 X
	3 Y
	5 V
	;
run;

proc sql;
create table three as
   select coalesce(one.num, two.num) as num, char1, char2
      from one full join two
      on one.num = two.num;
quit;

proc print;run;

%let type = RANCH;
proc sql;
  create view houses as
  select * 
  from sasuser.houses
  where style = "&type";
quit;

%let type = CONDO;

proc print data = houses;
run;


 proc format ;
    value dayfmt  1='Sunday'
                  2='Monday'
                  3='Tuesday'
                  4='Wednesday'
                  5='Thursday'
                  6='Friday'
                  7='Saturday' ;
  run ;

  data diary;
	input day var1 $;
	cards;
	5 A
	4 B
	3 C
	3 C
	1 D
	6 E
	7 F
	;
run;

data diary;
	set diary;
	format day dayfmt.;
run;


  proc report data=diary nowindows;
    column day var1;
    define day/order order=formatted "Week Day";
  run ;

  proc report data=diary nowindows;
    column day var1;
    define day/order order=data "Week Day";
  run ;

  proc report data=diary nowindows;
    column day  var1;
    define day/order order=freq "Week Day";
  run ;

  proc report data=diary nowindows;
    column day var1;
    define day/order order=internal "Week Day";
  run ;
