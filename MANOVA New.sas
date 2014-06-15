libname wbh "H:\SASTest\SelfLearn";

proc glm data = wbh.manova;
  class group;
  model useful difficulty importance = group / SS3;
  manova h = group;
run;

proc glm data = wbh.manova;
  *class group;
  model useful difficulty importance =  / SS3;
  repeated a;
run;
quit;
