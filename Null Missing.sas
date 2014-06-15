data foo;

 length i 8;

 length x 8;

 length y $ 1;

 alpha="aAzZ09";

 do i=1 to 30;

  x=floor(ranuni(1)*3);

  if ( ranuni(1) < 0.1 )

  then x=.;

  substr(y,1,1)=substr(alpha,floor(ranuni(1)*length(alpha))+1,1);

  if ( ranuni(1) < 0.1 )

  then y="";

  output;

 end;

 drop alpha;

run;

 

proc print data=foo(where=(x < 2));

run;

 

/*

  Define library X, specifying an ACCESS engine...

*/

 

data x.foo;

 set foo;

run;

 

data bar;

 set x.foo(where=(x < 2));

run;

 

proc sort data=bar;

by i;

run;

 

proc print data=bar;

run;
