/* Set the graphics environment */
goptions reset=all cback=white border htitle=12pt htext=10pt;  

 /* Create a sample data set */
data a;
   input YEAR CNT;
   datalines;
1995 10
1995 40
1995 28
1995 47
1996 13
1996 25
1996 30
1996 20
1997 22
1997 60
1997 55
1997 40
1998 60
1998 43
1998 78
1998 69
1999 50
1999 31
1999 67
1999 24
;
run;

 /* Use the BWIDTHoption to specify the */
 /* width of the boxes                  */
symbol1 i=boxft bwidth=6 cv=beige co=vibg;
symbol1 i=box25 bwidth=6 cv=beige co=vibg;

axis1 minor=none order=(0 to 80 by 10);  
axis2 minor=none offset=(5pct,5pct);

 /* Add a title to the graph */
title1 'Changing the width of the boxes in a Box Plot';

proc gplot data=a;
   plot CNT*YEAR / vaxis=axis1 haxis=axis2 
                   noframe autovref;
run;
quit;

proc sgplot data=a;
	vbox cnt/category=year PERCENTILE=4;
run;
