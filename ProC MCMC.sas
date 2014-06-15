   data x;
   run;
    
   ods graphics on;
   proc mcmc data=x outpost=simout seed=23 nmc=10000 maxtune=0
             nbi=0 statistics=(summary interval) diagnostics=none;
      ods exclude nobs parameters samplinghistory;
      parm alpha 0;
      prior alpha ~ normal(0, sd=1);
      model general(0);
   run;
   ods graphics off;
