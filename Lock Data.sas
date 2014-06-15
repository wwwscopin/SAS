
data test;
A=compress("") =: "";
B=compress("") = "";
C=compress("") =: " ";
D=compress("") = " ";
run;

proc print;run;




options msglevel=I;
 
libname templib "c:\temp";
 
proc copy in=sashelp out=templib;
	select orsales;
run;
 
lock templib.orsales;
 
proc summary nway data=templib.orsales;
	class Product_Line;
	var quantity profit;
output out=summ1 sum=;
run;
 
lock templib.orsales clear; 
