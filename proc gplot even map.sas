data xx;
tick + 1;
input day value;
cards;
1 23
3 45
17 20
43 15
72 9
;

proc print;run;

data fmt;
 set xx;
 retain fmtname 'daynum';
 start=tick;
 label=day;
 keep fmtname start label;
run;

proc format cntlin=fmt;
run;

symbol i=j v=circle ;

axis1 minor=none offset=(1,1)in;

proc gplot data=xx;
plot value * tick / haxis=axis1;
format tick daynum. ;
label tick = 'Day';
run;


data xx;
input day value;
cards;
1 23
3 45
17 20
43 15
72 9
;

proc format;
value dayfmt
1='1'
3='3'
17='17'
43='43'
72='72'
other=' '
;

symbol i=j v=circle;
*axis1 order=(1,3,17,43,72);
axis1 order=(0 to 75) major=none minor=none;

proc gplot;
plot value*day / haxis=axis1;
format day dayfmt.;
run;
