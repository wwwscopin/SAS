data tst; 
    input type $ grp value $3.; 
datalines; 
A 1 a 
A 2 aa 
A 3 aaa 
B 1 b 
B 2 bb 
B 3 bbb 
C 1 c 
C 2 cc 
C 3 ccc 
;

data art(keep=type grp1-grp3); 
   set tst; 
   by type; 
   retain grp1-grp3 ; 
   array grps {3} $ grp1-grp3; 
   if first.type then do i = 1 to 3; 
      grps{i} = " "; 
   end;

   grps{grp} = value; 
   if last.type then output art ; 
run;
proc print;run;

*And such logic can be best demonstrated by a DoW Loop:;

data dow(keep=type grp1-grp3); 
     array grps[3] $ grp1-grp3; 
     do _n_ = 1 by 1 until(last.type); 
        set tst; 
        by type; 
        grps[grp]=value; 
     end; 
run;
proc print;run;
