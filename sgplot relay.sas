/* Change the value of the following macro   */
/* variable if you want to write the output  */
/* from the sample code to a directory other */
/* than C:\TEMP.                             */

%let outdir=H:\temp;  

options orientation=landscape nodate nonumber;  

goptions reset=all;  

/* This step uses multiple PROC SGPLOT procedures  */
/* to write multiple PNG files to disk.  Note that */
/* this step uses the IMAGENAME= option on the ODS */
/* GRAPHICS ON statement to name each PNG file     */
/* that is written to disk.                        */

ods results off;
ods listing close; 
ods html path="&outdir" (url=none) file='sastest.html'
      image_dpi=300;   

ods graphics on / reset=index imagename='sgplot1' 
      width=4in height=3in;

title1 'First SGPLOT Output';
proc sgplot data=sashelp.class;
   scatter x=height y=weight / group=sex;
   discretelegend;
run;

ods graphics on / imagename='sgplot2' 
      width=4in height=3in;

title1 'Second SGPLOT Output';
proc sgplot data=sashelp.class;
   scatter x=height y=weight / group=sex;
   discretelegend;
run;

ods graphics on / imagename='sgplot3' 
      width=4in height=3in;

title1 'Third SGPLOT Output';
proc sgplot data=sashelp.class;
   scatter x=height y=weight / group=sex;
   discretelegend;
run;

ods graphics on / imagename='sgplot4' 
      width=4in height=3in;

title1 'Fourth SGPLOT Output';
proc sgplot data=sashelp.class;
   scatter x=height y=weight / group=sex;
   discretelegend;
run;

ods html close;   
ods listing; 
ods results on; 

/* This step uses PROC GSLIDE with the IBACK= and */
/* IMAGESTYLE= graphics options to read the PNG   */
/* files created in step 1 back into SAS.         */  

goptions reset=all device=png300 nodisplay
         xmax=4in ymax=3in;

goptions iback="&outdir.\sgplot1.png" imagestyle=fit; 

proc gslide; 
run;
quit; 

goptions iback="&outdir.\sgplot2.png" imagestyle=fit; 

proc gslide; 
run;
quit; 

goptions iback="&outdir.\sgplot3.png" imagestyle=fit; 

proc gslide; 
run;
quit;

goptions iback="&outdir.\sgplot4.png" imagestyle=fit; 

proc gslide; 
run;
quit;

/* This final step uses PROC GREPLAY to put four  */
/* SGPLOT outputs on the same PDF page.           */ 

goptions reset=all device=sasprtc; 

ods listing close; 
ods pdf file="&outdir.\greplay_sgplot.pdf" notoc dpi=300;

proc greplay igout=work.gseg nofs tc=sashelp.templt
             template=L2R2;
   treplay 1:1 2:2 3:3 4:4;
run;
quit;

ods pdf close; 
ods listing; 
