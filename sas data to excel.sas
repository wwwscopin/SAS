data test;
	a=5;
	b=6;
run;
libname test excel "\\cdc\project\NCHHSTP_HICSB_STORE02\SURV_DATA\NDP\QTRLY_TESTING\MAR13\XGG8\test.xlsx";

data test.wbh;
	set test;
run;

libname test clear;

