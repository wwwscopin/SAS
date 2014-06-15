data a;   

/* Does fileref "curdirfl" exist?  No = 0 */   

rc=fexist ("curdirfl");   
put;
put "Fileref curdirfl exist? rc should be 0 (no); " rc=;    

/* assign fileref */   

rc=filename("curdirfl", "c:\tmp333");   

/* RC=0 indicates success in assigning fileref */  
 
put "Fileref assigned - rc should be 0; " rc=;    
rc=fexist ("curdirfl");   

/* Does file which "curdirfl" points to exist?  No = 0 */   
/* Assigning a fileref doesn't create the file. */  
 
put "File still doesn't exist - rc should be 0; " rc=;    
rc=fileref ("curdirfl");   

/* Does fileref "curdirfl" exist?  */   
/* Negative means fileref exists, but file does not */   
/* Positive means fileref does not exist            */   
/* Zero means both fileref and file exist           */   

put "Fileref now exists - rc should be negative; " rc=;     
put;

/* Does the file that the fileref points to exist?  Should be no. */ 
  
if ( fileexist ("./tmp333") ) then       
    /* if it does, open it for input */      
      do;
        put "Open file for input"; 
        fid=fopen ("curdirfl", "i") ;  
      end; 
   else       /* most likely scenario */       
      do;
        put "Open file for output";
        fid=fopen ("curdirfl", "o");   
      end;

/* fid should be non-zero.  0 indicates failure. */   
put "File id is: " fid=;   
numopts = foptnum(fid);   
put "Number of information items should be 6; " numopts=;   
do i = 1 to numopts;      
optname = foptname (fid,i);      
put i= optname=;      
optval  = finfo (fid, optname);      
put optval= ;   
end;   
rc=fclose (fid);    
rc=fdelete ("curdirfl");   
put "Closing the file, rc should be 0; " 
rc=; run;
