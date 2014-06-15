proc iml;
x = {1 2 2 2 2 3 3 3 3 3 4 4 5 5 5 5 5 5};
x = {1 [4]2 [5]3 [2]4 [6]5};
gender = {[42]"Female" [58]"Male"};
data A;
array x(18) (1 4*2 5*3 2*4 6*5);
run;

 x={ 1 2 ,
     3 4} ;
 y=repeat(x,2,3);


data Orig;
input x $ Freq;
datalines;
A 2
B 1
C 3
D 0
E 4
F .
;
run;
 
/* expand original data by frequency variable */
data Expand;
keep x;
set Orig;
if Freq<1 then delete;
do i = 1 to int(Freq);
   output;
end;
run;
proc print data=Expand; run;

start expandFreq(_x, _freq);
   /* Optional: handle nonpositive and fractional frequencies */
   idx = loc(_freq > 0); /* trick: in SAS this also handles missing values */
   if ncol(idx)=0 then return (.);
   x = _x[idx];
   freq = round( _freq[idx] );
 
   /* all frequencies are now positive integers */
   cumfreq = cusum(freq);
 
   /* Initialize result with x[1] to get correct char/num type */
   N = nrow(x);
   expand = j(cumfreq[N], 1, x[1]); /* useful trick */
 
   do i = 2 to N;
      bIdx = 1 + cumFreq[i-1]; /* begin index */
      eIdx = cumFreq[i];       /* end index */
      expand[bIdx:eIdx] = x[i];/* you could use the REPEAT function here */
   end;
   return ( expand );
finish;
 
/* test the module */
values={A,B,C,D,E,F};
freq = {2,1,3,0,4,.}; /* include nonpositive and missing frequencies */
y = expandFreq(values, freq);
print values freq y;


proc iml;
values={A,B,C,E};
freq = {2,1,3,4};
cumfreq = cusum(freq);
print values freq cumfreq;

values = {2.2 3.3};
freq   = {2   3};
load module=(expandFreq); /* define or load ExpandFreg module here */
y = expandFreq(values, freq);
