  ods tagsets.excelxp file="spacing.xls" style=statistical
      options( skip_space='3,2,0,0,1' sheet_interval='none'
               suppress_bylines='no');

  proc sort data=sashelp.class out=class;
     by age;
  run;

  proc print data=class;
     by age;
  run;

  ods tagsets.excelxp close;

