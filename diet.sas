data diet;
input id visit   outcome $;
cards;
1  0   chicken
1  0   turkey
1  0   ham
1  6   turky
1  6   turky    
1  6   ham
1  6   chicken
1  12  turky
1  12  fish
1  12  ham
1  12  chicken
;run;

proc freq;
	tables visit*outcome/cmh;
run;
