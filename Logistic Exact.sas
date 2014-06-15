data Data1;
     do ID=1 to 63;
       do Outcome = 1 to 0 by -1;
         input Gall Hyper @@;
         output;
       end;
     end;
     datalines; 
   0 0  0 0    0 0  0 0    0 1  0 1    0 0  1 0    1 0  0 1    
   0 1  0 0    1 0  0 0    1 1  0 1    0 0  0 0    0 0  0 0    
   1 0  0 0    0 0  0 1    1 0  0 1    1 0  1 0    1 0  0 1    
   0 1  0 0    0 0  1 1    0 0  1 1    0 0  0 1    0 1  0 0   
   0 0  1 1    0 1  0 1    0 1  0 0    0 0  0 0    0 0  0 0    
   0 0  0 1    1 0  0 1    0 0  0 1    1 0  0 0    0 1  0 0    
   0 1  0 0    0 1  0 0    0 1  0 0    0 0  0 0    1 1  1 1    
   0 0  0 1    0 1  0 0    0 1  0 1    0 1  0 1    0 1  0 0   
   0 0  0 0    0 1  1 0    0 0  0 1    0 0  0 0    1 0  0 0    
   0 0  0 0    1 1  0 0    0 1  0 0    0 0  0 0    0 1  0 1    
   0 0  0 0    0 1  0 1    0 1  0 0    0 1  0 0    1 0  0 0    
   0 0  0 0    1 1  1 0    0 0  0 0    0 0  0 0    1 1  0 0   
   1 0  1 0    0 1  0 0    1 0  0 0    
   ;

   proc logistic data=Data1;
      strata ID;
      model outcome(event='1')=Gall;
   run;

   proc logistic data=Data1 exactonly;
      strata ID;
      model outcome(event='1')=Gall;
      exact Gall / estimate=both;
   run;

   data Data2;
      set Data1;
      *drop id1 gall1 hyper1;
      retain id1 gall1 hyper1 0;
      if (ID = id1) then do;
         Gall=gall1-Gall; Hyper=hyper1-Hyper;
         output;
      end;
      else do;
         id1=ID; gall1=Gall; hyper1=Hyper;
      end;
   run;

   proc print;run;

   proc logistic data=Data2;
      model outcome=Gall / noint clodds=PL;
   run;

   proc logistic data=Data2 exactonly;
      model outcome=Gall / noint;
      exact Gall / estimate=both;
   run;
