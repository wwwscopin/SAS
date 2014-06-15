proc freq data=sashelp.cars ORDER=FREQ noprint;
  tables make / out=FreqOut;
run;

%let NumCats = 20;   /* limit number of categories in bar chart */
 
proc sgplot data=FreqOut(OBS=&NumCats);   /* restrict to top companies */
  Title "Vehicle Manufacturers That Produce the Most Models";
  Title2 "Top &NumCats Shown";
  hbar make / freq=Count;      /* bar lengths given by Count */
  yaxis discreteorder=data;    /* order of bars same as data set order */
  xaxis label = "Number of Models";
run;
