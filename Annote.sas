/* Set graphics options */
goptions reset=all cback=white border;

/* Set system options */
data a;
input TEST $  BREAKS ;
cards;
Cold 5
Cold 12
Cold 14
Cold 22
Cold 52
Heat 20
Heat 25
Heat 10
Heat 22
Heat 47
Gases 12
Gases 25
Gases 33
Gases 48
Gases 24
Pressure 10
Pressure 12
Pressure 14
Pressure 22
Pressure 60
Xrays 20
Xrays 25
Xrays 14
Xrays 22
Xrays 29
Humidity 20
Humidity 25
Humidity 33
Humidity 40
Humidity 24
;
run;

/* Sort data by variable TEST */
proc sort; by TEST; run;

/**************************************************/
/* Create an output data set, B using PROC MEANS */
/* that contain new variables, MEAN, STD, STDERR, */
/* MIN, and MAX. */
/**************************************************/

proc means mean std stderr min max data=a; 
by TEST; 
output out=b mean=mean min=min max=max; 
run;

/****************************************************************/
/* Create an annotate data set, ANNO to draw the bars at +/- 1, */
/* 2, or 3 Standard Deviation or Standard Error of the mean. */
/****************************************************************/

data anno;
retain xsys ysys '2' when 'a';
length color function $8 ;
set b;

/* Draw the horizontal line from min to max */ 
function='move'; xsys='2'; ysys='2'; yc=TEST; x=min; color='blue'; output; 
function='draw'; x=max; color='blue'; size=2; output;

/* Draw the MEAN horizontal line making the SIZE bigger */ 
function='move'; xsys='2';ysys='2';yc=TEST;x=mean; color='red'; output; 
function='draw'; x=mean; ysys='9'; y=+2; size=4; output; 
function='draw'; x=mean; y=-4; size=4; output;

/* Draw the line for the MIN value */
function='move';xsys='2';ysys='2';yc=TEST;x=min;color='red';output;
function='draw';x=min;ysys='9';y=+2;size=2;output;
function='draw';x=min;y=-4;size=2;output;

/* Draw the line for the MAX value */
function='move';xsys='2';ysys='2';yc=TEST;x=max;color='red';output;
function='draw';x=max;ysys='9';y=+2;size=2;output;
function='draw';x=max;y=-4;size=2;output;

axis1 order=(0 to 100 by 10);
symbol1 i=none v=none c=black;

proc gplot data=b ;
plot test*mean / anno=anno haxis=axis1 href=30 60 90; /* The HREF= option draws reference lines */ 
run; 
quit;
