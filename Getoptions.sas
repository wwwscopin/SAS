%let saveOptions = 
       %sysfunc(getoption(CENTER)) %sysfunc(getoption(NUMBER)) %sysfunc(getoption(DATE));
options nocenter nonumber nodate;
 
/* your code that depends on these options */
 
options &saveOptions; /* reset options to original values */
