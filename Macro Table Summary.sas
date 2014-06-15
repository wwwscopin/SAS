%macro summarytable(data=, row=, rtype=, col=, test=, pct=, rtfile=, title=, page=, pgs=);
%let j=1;
%let rowj=%upcase(%scan(&row,&j);
%do %while(%length(&rowj)>0);
	%let rtypej=%upcase(%scan(&rtype, &j));
	%let testj=%upcase(%scan(&test, &j));
	%var1(data=&data, row=&rowj, col=&col, rtype=&rtypej, test=&testj, table=&table);
	%let j=%eval(&j+1);
	%let rowj=%upcase(%scan(&row, &j));
%end;

%macro var1(data=, row=, rtype=, col=, test=, table=_store);
	%if &rtype=cont %then %do;
		%cont_file(data=&data, row=&row, col=&col);
		%end;
	%else %if &rtype=cate %then %do;
		%cate_file(data=&data, row=&row, col=&col);
		%end;
%mend;

%if &freqtest=CHISQ %then %do;
	ods output "CHI-SQUARE TESTS"=chisq;
		proc freq data=data0;
			tables &row*&col/norow nocol nopercent &freqtest;
		run;
	ods output close;
%end;

%if %upcase(&test)=CHISQ %then %do;
	Data _pvalue(keep=pvalue test);
		set chisq;
		if statistic="CHI-SQUARE" then do;
			pvalue=prob;
			test='P';
			output;
			stop;
		end;
	run;
%end;
%mend;

proc report data=&dat nowd headline headskip split="*" box missing;
	cols ("^S={}\brdrb\brdrs"
				HED
				TEM
				FOT
				RLABEL
				PRTTOTAL
				("\B\FS16 &labelc" %namels2(&clab, &ncol))
				pvalue_);
Define HED /Group noprint order=data;
Define TEM /Group noprint order=data;
Define FOT /Group noprint order=data;
Define RLABEL /display "VARIABLES" style=[just=L Font_weight=light];
Define PRTTOTAL /display "Total#(N=&T_Num)" center style(column)=[just=C];
%do i=1 %to &ncol;
	define &&clab&i/ display "&&clab&i.#%str((N=&&ccnt&i))" style(column)=[just=R];
%end;

define pvalue_ /display "P-VALUE" style(column)=[just=R];

break before HED/;
compute before _page_/style=[just=c font_size=8];
	line "^S={}\N";
	line "\R\B\FS18\CF13 &Title";
endcomp;

break after fot/;
compute after fot/style=[just=L Font_szie=8pt];
	line "^S={}\bedrt\brdrs";
endcomp;

break after TEM/;
compute after TEM/style=[just=L font_size=8pt];
	HDR=compbl("PAGE"!!Put(tem, 2.))!!"OF %SYNFUNC (compress(&maxpage.))");
	line "PROGRAM: (%sysget(SAS_EXECFILENAME)) DATE:(&sysdate.)" HDR$15.;
	Line " ";
	%if %mrfoot^=0 %then %do;
		%do; j=1 %to &myfoot;
			Line "&&Footchar&j";
		%end;
	%end;
endcomp;
Break After HED/supress page;
compute after _page_;
endcomp;
run;

proc format;	
	value lungfmt 1="NO" 2="YES";
	value SEX 1="FEMALE" 2="MALE";
run;

DATA TEST;
INPUT GENDER LUNGCANCER AGE HEIGHT GRADE$ @@;
DATALINES;
1 1 15 165 L
1 1 24 140 L
2 2 30 200 S
. 2 20 175 L
2 2 24 153 S
1 1 10 215 L
1 2 15 121 S
;
DATA TEST;
SET TEST;
FORMAT GENDER SEX. LUNGCANCER LUNGFMT.;
LABEL AGE='AGE (YR.)'
SEX='GENDER'
LUNGCANCER='LUNG CANCER';
RUN;



Page

%INCLUDE "USERS\MACROS\PROGRAMS\INCLUDE.TABLE.TXT";
%SUMMARYTABLE( DATA=TEST,
COL=LUNGCANCER,
ROW= GENDER GRADE AGE HEIGHT,
RTYPE=CATE CATE CONT CONT,
TEST=CHISQ EXACT TTEST ANOVA,
PCT=COL,
RTFFILE=USERS\MACROS\PROGRAMS\SUMMARYTEST.RTF,
TITLE=THE SUMMARY STATISTICS AND COMPARISONS BETWEEN GROUPS,
PAGE=PORTRAIT,
PGS=20
);

		 
