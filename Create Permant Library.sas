libname fmex "\\cdc\project\NCHHSTP_HICSB_STORE02\SURV_DATA\NDP\QTRLY_TESTING\MAR13\XGG8\Weighted";

proc format library=fmex;
 value gender 1="Male" 2="Female";
run;

data _null_;
   x = 'MCLAUREN';
   y = prxchange("s/(MC)/$2/", -1, x);   put y=;
   z = prxchange("s/(MC)/\u\L$1/i", -1, x);   put z=;
   z1 = prxchange("s/(MC)/\U\L$1/i", -1, x);   put z1=;
   z2 = prxchange("s/(MC)/\U\l$1/i", -1, x);   put z2=;
   z3 = prxchange("s/(MC)/\u\l$1/i", -1, x);   put z3=;
run;


data old;
   input name $60.;
   datalines;
Judith S Reaveley
Ralph F. Morgan
Jess Ennis
Carol Echols
Kelly Hansen Huff
Judith
Nick
Jones
;
data new;
   length first middle last $ 40;
   *keep first middle last;
   re = prxparse('/(\S+)\s+([^\s]+\s+)?(\S+)/o');
   set old;
   if prxmatch(re, name) then
      do;
         first = prxposn(re, 1, name);
         middle = prxposn(re, 2, name);
         last = prxposn(re, 3, name);
         output;
      end;
run;
proc print data = new;
run;
