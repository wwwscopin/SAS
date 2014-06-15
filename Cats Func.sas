************(1) Cluster the dataset*******;
proc fastclus data = sashelp.class maxclusters = 2 out = class;
   var height weight;
run;

proc print data=class;run;

proc sgplot data = class;
   scatter x = height y = weight /group = cluster;
   yaxis grid;
run;

************(2) Transform to JSON*********;
data toJSON;
   set class;
   length line $200.;
   array a[5] _numeric_; 
   array _a[5] $20.;
   do i = 1 to 5;
      _a[i] = cat('"',vname(a[i]),'":', a[i], ',');
   end;
   array b[2] name sex;
   array _b[2] $20.;
   do j = 1 to 2;
      _b[j] =cat('"',vname(b[j]),'":"', b[j], '",');
   end;
   line = cats('{', cats(of _:), '},');
   substr(line, length(line)-2, 1) = ' ';
   keep line;
run;

proc print;run;
