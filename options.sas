proc print data=sashelp.voption;
run;

proc options group=memory;
run;

proc options option=memblksz define value lognumberformat;
run;
