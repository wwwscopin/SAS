DATA wide;
  INPUT sub group dv1 dv2 dv3 dv4;
CARDS;
1 1  3  4  7  3
2 1  6  8 12  9
3 1  7 13 11 11
4 1  0  3  6  6
5 2  5  6 11  7
6 2 10 12 18 15
7 2 10 15 15 14
8 2  5  7 11  9
;
RUN;

proc glm data = wide;
  model dv1 dv2 dv3 dv4 = ;
  repeated s ;
run;
/*
proc glm data = wide;
  model dv1 dv2 dv3 dv4 =sub ;
  manova h=sub  ;
run;
*/
quit;
 
PROC PRINT DATA=wide ;
RUN; 


symbol i=stepjr;
legend across = 3 position=(top left inside) mode =share shape = symbol(3,3) label=(position=(top left) "Temperature" j=l "(Celsius)") 
value =("wbh")  noframe Cblock=white;

proc gplot data=wide;
	plot dv1*dv2/legend=legend;
run;
