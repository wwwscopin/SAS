title h=1pt bcolor=blue 'A';
footnote h=1pt bcolor=blue 'B';

data test;
	a=10;
run;
proc print;run;

data _null_;
   length txt $32;
   txt = prxchange ('s/(big)(black)(bear)/\U$1\L$2\E$3/', 1, 'bigblackBear');
   put txt=;
run;


data _null_;
   if _N_ = 1 then 
   do;
      retain ExpressionID;

         /* The i option specifies a case insensitive search. */
      pattern = "/ave|avenue|dr|drive|rd|road/i";
      ExpressionID = prxparse(pattern);
	  put ExpressionID;
   end;

   input street $80.;
   call prxsubstr(ExpressionID, street, position, length);
   put length;
   if position ^= 0 then
   do;
      match = substr(street, position, length);
      put match:$QUOTE. "found in " street:$QUOTE.;
   end;
   datalines;
153 First Street
6789 64th Ave
4 Moritz Road
7493 Wilkes Place
;

run;
