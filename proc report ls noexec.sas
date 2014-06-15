proc report data=sashelp.class list noexec;  run;

proc sql noprint;

create table km as select *

, ifn((survival=. &day^=0),min(survival) ,survival) as Surv

, 1-calculated Surv as prob

from KMplot

group by drug

order by drug ,day;

quit;

proc gplot data=km;

plot prob*day=drug;

run;
