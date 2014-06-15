
data t;
	input cid $ 1-2 income educ;
cards;
c1 5 5
c2 6 6
c3 15 14
c4 16 15
c5 25 20
c6 30 19
run;

proc cluster simple noeigen method=centroid rmsstd rsquare nonorm out=tree;
id cid;
var income educ;
run;

proc print;run;

proc tree data=tree out=clus3 nclusters=3;
id cid;
copy income educ;
proc sort; by cluster;


proc print; by cluster;
var cid income educ;
title2 '3-cluster solution';
run;
