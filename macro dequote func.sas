%macro testit(path=); 
data _null_; 
put "%sysfunc(dequote(&path))"; 
run; 
%mend testit; 

%testit(path=D:\Projects\); 
%testit(path='D:\Projects\'); 
%testit(path="D:\Projects\"); 
