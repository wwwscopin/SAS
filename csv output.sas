data old;
a='abcdefghijklmnopqrstuvwxyz';
b=3; c=9;
run;
data new;
set old;
x=substr(a,23,4);
y=substr(a,b,3);
z=substr(a,9,c);
put a= b= c= x= y= z=;
run;

ODS HTML FILE="H:\TEMP.XLS";
PROC PRINT DATA=SASHELP.CLASS;
RUN;
ODS HTML CLOSE;

ODS csv FILE="H:\TEMP.csv";
PROC PRINT DATA=SASHELP.CLASS;
RUN;
ODS csv CLOSE;
