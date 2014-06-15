/*Load data from library*/
libname database 'H:\WBH\MyHard2\GSU\2009Fall\SAS\database';
data Initial;
	set database.cohort_part2(rename=( seer_registry=RID regional_node_pos=RNP
	 rx_surg_type=RST vital_status=VS  eod_size=ESize));
run;
proc contents;run;
options nocenter source notes ls=85;
proc format;
	value Age 1='30-49' 2='50-64' 3='65-79';
	value ESize 1='0-1 cm' 2= '1-2 cm' 3='2-3 cm' 4='3-4 cm' 5='4-5 cm';
	value RNP 1='Negative' 2='Positive';
	value Race 1= 'White' 2='Black' 3='Hispanic' 4='Asian' 5='Other'; 
	value RID  1501='San Francisco'1502='Connecticut' 1520='Detroit' 1521='Hawaii' 1522='Iowa'
	1523='New Mexico' 1525='Seattle' 1526='Utah' 1527='Atlanta';
	value Grade 1='I' 2='II' 3='III' 4='IV';
	value BCS 1='BCS' 2='Mastectomy';
	value VS 0='Alive' 1='Dead';
run; 

data Initial;
	set Initial;

	age2=0;
	if 30<=dxage<=49 then age2=1;
	if 50<=dxage<=64 then age2=2;
	if 65<=dxage<=79 then age2=3;

	ESize2=0;
	if 0 <=Esize<=10 then ESize2=1;
	if 10<Esize<=20  then ESize2=2;
	if 20<Esize<=30  then ESize2=3;
	if 30<Esize<=40  then ESize2=4;
	if 40<Esize<=50  then ESize2=5;

	RNP2=0;
	if RNP=00 then RNP2=1;
	if 01<=RNP<=97 then RNP2=2;

	race2=5;
	if race=1 then race2=1;
	if race=2 then race2=2;
	if 1<=Hispanic<=9 then race2=3;
	if race in (4,5,6,7,8,9,10,11,12,13,14,20,21,22,25,26,27,28,30,31,32,96) then race2=4;

	BCS=0;
	if 10<=RST<30 then BCS=1;
	if 30<=RST<80 then BCS=2;

	VS2=0;
	if VS=1 then VS2=0;
	if VS=4 then VS2=1;
	
	format Age2 Age. Esize2 ESize. RNP2 RNP. Race2 Race. RID RID. Grade grade. BCS BCS. VS2 VS.;
run;
data BCS Mastectomy;
	set initial;
	if BCS=1 then output BCS;
	if BCS=2 then output Mastectomy;
run;

%macro Match(indata1,indata2,group1,group2,group3,group4,group5,group6);
ods output   Contents.DataSet.Attributes=temp1;
proc contents data=&indata1;run;
ods output   Contents.DataSet.Attributes=temp2;
proc contents data=&indata2;run;
data _null_;
	set temp1(obs=1 keep=nvalue2);
	call symput('gnumber1',nvalue2) ;
run;
data _null_;
	set temp2(obs=1 keep=nvalue2);
	call symput('gnumber2',nvalue2) ;
run;

data Match;
	if 1=1 then delete;
run;

%do i=1 %to &gnumber1;
	data _null_;
		set &indata1;
		if _n_=&i then do;
		call symput('B1',&group1);
		call symput('B2',&group2);
		call symput('B3',&group3);
		call symput('B4',&group4);
		call symput('B5',&group5);
		call symput('B6',&group6);
		end;
	run;
	%do j=1 %to &gnumber2;
		data _null_;
		set &indata2;
		if _n_=&j then do;
		call symput('M1',&group1);
		call symput('M2',&group2);
		call symput('M3',&group3);
		call symput('M4',&group4);
		call symput('M5',&group5);
		call symput('M6',&group6);
		end;
		run;
		%if &B1=&M1 and &B2=&M2 and &B3=&M3 and &B4=&M4 and &B5=&M5 and &B6=&M6 %then %do;
		data one;
			set &indata1;
			if _n_=&i;
		run; 
		data two;
			set &indata2;
			if _n_=&j;
		run; 
		%end;
	%end;
		data Match;
			set Match one two;
		run;
%end;
%mend;
%match(BCS,Mastectomy,RID,Race2,RNP2,Esize2,Grade,dxage) ;
proc print data=match;run;

data database.match;
	set match;
	survTime=survyear*12+survmonth;
run;

data Match_BCS Match_Mastectomy;
	set database.match;
	if BCS=1 then output Match_BCS;
	if BCS=2 then output Match_Mastectomy;
run; 

goptions reset=global gsfmode=replace gunit=pct border;
title h=4 "Testing the Mortality between Matched BCS and Mastectomy Groups ";
proc lifetest data=Match plots=(s);
	time survTime*VS2(0);
	strata BCS;
run;

ods listing close;
ods trace off;
%macro Table(inData, Term, Label);
	ods output Freq.Table1.OneWayFreqs=&Term.Tab;
	ods output Freq.Table1.OneWayChisq=&Term.X;

	proc freq data=&InData;
		tables &Term/missing chisq;
	run; 
	data summary;
		if 1=1 then delete; 		
		length item $40;
	run;
	data one;
		item=&Label; 
	run;
	data &Term;
		merge &Term.Tab ;
		item='   '||f_&Term;
	run;
	data &indata&term;
		set summary one &Term(keep=item frequency percent);
	run;
	data &indata&term;
		merge &indata&term &Term.X(firstobs=3 keep=nvalue1 rename=(nvalue1=pvalue));
	run;
%mend;
%Table(Mastectomy, age2, 'Age Group'); 
%Table(Mastectomy, Esize2, 'Tumor Size Group');
%Table(Mastectomy, RNP2, 'Lymph Node Status'); 
%Table(Mastectomy, Race2, 'Race');
%Table(Mastectomy, RID, 'SEER Site'); 
%Table(Mastectomy, Grade, 'Grade');

data summary_Mastectomy;
	set Mastectomyage2 MastectomyEsize2 MastectomyRNP2 MastectomyRace2 MastectomyRID MastectomyGrade;
run;

%Table(BCS, age2, 'Age Group'); 
%Table(BCS, Esize2, 'Tumor Size Group');
%Table(BCS, RNP2, 'Lymph Node Status'); 
%Table(BCS, Race2, 'Race');
%Table(BCS, RID, 'SEER Site'); 
%Table(BCS, Grade, 'Grade');

data summary_BCS;
	set BCSage2 BCSEsize2 BCSRNP2 BCSRace2 BCSRID BCSGrade;
run;

%macro Count(inData);
	ods output  Univariate.dxage.Moments=&inData.N;
	ods output  Univariate.dxage.BasicMeasures=&inData.age1 Univariate.dxage.TestsForLocation=&inData.age2;
	ods output  Univariate.ESize.BasicMeasures=&inData.size1 Univariate.ESize.TestsForLocation=&inData.size2;
	proc univariate data=&inData; 
		var dxage Esize;
	run; 
	data DataN;
		length item $40; 
		set &inData.N(obs=1 keep=nvalue1 rename=(nvalue1=&inData));
		item='Count';
	run;
	data Data1;
		length item $40;  percent=.;
		Merge &inData.age1(obs=1 keep=LocValue rename=(LocValue=&inData)) &inData.age2(obs=1 keep= pValue);
		item='Mean Age';
	run;
	data Data2;
		length item $40; 
		Merge &inData.size1(obs=1  keep=LocValue rename=(LocValue=&inData)) &inData.size2(obs=1 keep= pValue);
		item='Mean Tumor Size (mm)';  	
	run;
	data Mean&indata;
		set DataN Data1 Data2;
	run;
%mend;
%Count(Mastectomy);
%Count(BCS);

data count;
	merge MeanMastectomy MeanBCS; 
run;

data Summary_BM;
	merge summary_Mastectomy(rename=(frequency=Mastectomy)) summary_BCS(rename=(frequency=BCS percent=PBCS));
run; 
proc print;run;

data Summary_initial;
	set Count Summary_BM ;
run;  


data Summary_initial;
	merge Summary_initial(drop=pvalue) Summary_initial(keep=pvalue);
run; 


%Table(Match_Mastectomy, age2, 'Age Group'); 
%Table(Match_Mastectomy, Esize2, 'Tumor Size Group');
%Table(Match_Mastectomy, RNP2, 'Lymph Node Status'); 
%Table(Match_Mastectomy, Race2, 'Race');
%Table(Match_Mastectomy, RID, 'SEER Site'); 
%Table(Match_Mastectomy, Grade, 'Grade');

data summary_Match_Mastectomy;
	set Match_Mastectomyage2 Match_MastectomyEsize2 Match_MastectomyRNP2 Match_MastectomyRace2 Match_MastectomyRID Match_MastectomyGrade;
run;

%Table(Match_BCS, age2, 'Age Group'); 
%Table(Match_BCS, Esize2, 'Tumor Size Group');
%Table(Match_BCS, RNP2, 'Lymph Node Status'); 
%Table(Match_BCS, Race2, 'Race');
%Table(Match_BCS, RID, 'SEER Site'); 
%Table(Match_BCS, Grade, 'Grade');

data summary_Match_BCS;
	set Match_BCSage2 Match_BCSEsize2 Match_BCSRNP2 Match_BCSRace2 Match_BCSRID Match_BCSGrade;
run;

data Summary_Match;
	merge summary_Match_Mastectomy(rename=(frequency=Mastectomy)) summary_Match_BCS(rename=(frequency=BCS percent=PBCS));
run; 

%Count(Match_Mastectomy);
%Count(Match_BCS);

data count_Match;
	merge MeanMatch_Mastectomy(rename=(match_Mastectomy=Mastectomy)) MeanMatch_BCS(rename=(match_BCS=BCS)); 
run;


data Summary_Match;
	set Count_Match Summary_Match; 
run;

data Summary_Match;
	merge Summary_Match(drop=pvalue) summary_Match(keep=pvalue);
run; 
proc print;run;

ods listing;
title "Table of Patients' Characteristics for the Initial Cohort";
proc print data=Summary_initial noobs label;
label BCS='BCS';
label Mastectomy='Mastectomy';
label item='Variable';
label PBCS='Percent';
label pvalue='p-value';
format percent 2.0 PBCS 2.0 BCS 5.0 Mastectomy 5.0;
run;
title "Table of Patients' Characteristics for the Matched-Pairs Cohort";
proc print data=summary_Match noobs label;
label BCS='BCS';
label Mastectomy='Mastectomy';
label item='Variable';
label PBCS='Percent';
label pvalue='p-value';
format percent 2.0 PBCS 2.0 BCS 5.0 Mastectomy 5.0;
run;
