%macro chk_dir(dir=) ; 
   options noxwait; 
   %local rc fileref ; 
   %let rc = %sysfunc(filename(fileref,&dir)) ; 
   %if %sysfunc(fexist(&fileref))  %then 
      %put NOTE: The directory "&dir" exists ; 
   %else 
     %do ; 
         %sysexec md   &dir ; 
         %put %sysfunc(sysmsg()) The directory has been created. ; 
   %end ; 
   %let rc=%sysfunc(filename(fileref)) ; 
%mend chk_dir ; 

%chk_dir(dir=c:\temp);   %*<==  your directory specification goes here ; 
%chk_dir(dir=c:\temp\sascode) 
