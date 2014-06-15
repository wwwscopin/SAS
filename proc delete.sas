PROC Delete data = Libref.DataName;
 
PROC SQL; drop table Libref.DataName;
          quit;
 
PROC Datasets library = Libref;
              delete    DataName;
run;
 
DATA _Null_;
length dd $8;
rc = filename(dd,cats(pathname('Libref'),'\DataName.sas7bdat'));
rc = fdelete(dd);
put _all_;
run;


data test;
	infile cards;
	input x y;
	cards;
	1 .
	. 4
	5 6
	;
run;
proc sort; by x y; run;

proc print;run;

***launch MS Word;
X '"C:\Program Files (x86)\Microsoft Office\Office14\Excel.exe"';
