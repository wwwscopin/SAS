/* Make macro variables from all environment variables */
filename set_list pipe "set";
data work.envvars;
   length name $255;
   length value $32512;
   infile set_list DLM='=' MISSOVER lrecl=32767;
   input name $ value $;
   if name ^= "'" then do;
                call symputx(name,value);
   end;
run;

proc print;run;
