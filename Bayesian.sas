data x;
  run;  
ods graphics on;
proc mcmc data=x outpost=simout seed=23 nmc=10000 maxtune=0
          nbi=0 statistics=(summary interval) diagnostics=none;
   parm alpha 0;
   prior alpha ~ normal(0, sd=1);
   model general(0);
run;
ods graphics off;

/*
SAS/STAT software provides Bayesian capabilities in four procedures: GENMOD, LIFEREG, MCMC, and PHREG. The GENMOD, LIFEREG, 
and PHREG procedures provide Bayesian analysis in addition to the standard frequentist analyses they have always performed. 
Thus, these procedures provide convenient access to Bayesian modeling and inference for generalized linear models, accelerated 
life failure models, Cox regression models, and piecewise constant baseline hazard models (also known as piecewise exponential models). 
The MCMC procedure is a general procedure that fits Bayesian models with arbitrary priors and likelihood functions.
*/
