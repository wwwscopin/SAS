

filename wbh "C:\Users\XGG8\WBH\ReadPaper\wbh.txt";
data _null_;
	file wbh;
	put @1 "test";
run;
	
data test;
	wbh="test";
run;
proc print;run;
