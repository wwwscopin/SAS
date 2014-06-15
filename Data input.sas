data WORK.COLORS;
  infile 'C:\Users\XGG8\Desktop\test.TXT';
  input @1 Var1 $ @8 Var2 $ @;
  input @1 Var3 $ @8 Var4 $ @;
run;

proc print;run;

data input;
input Var1 $   Var2 $;
cards;
A        one
A        two
B        three
C        four
A        five
;
run;
data one two;
set WORK.INPUT;
  if Var1='A' then output WORK.ONE;
  output;
run;

proc print data=one;run;
proc print data=two;run;

data sales;
	input SalesID $  SalesJan  FebSales  MarchAmt;
cards;
W6790          50       400       350
W7693          25       100       125
W1387           .       300       250
;

data WORK.QTR1;
   set WORK.SALES;
   array month{3} SalesJan FebSales MarchAmt;
   Qtr1 = sum(of month{*}); 
run;
proc print;run;

data one;
	input num char1 $;
	cards;
	1 A
	2 B
	4 D
	;
data two;
	input num char2 $;
	cards;
	2 X
	3 Y
	5 V
	;
proc sql;
create table three as
   select *
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
