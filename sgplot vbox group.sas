%include "tab_stat.sas";

%let pm=%sysfunc(byte(177));


		data  indiv_pn_tables;
		set glnd_rep.indiv_pn_tables  ;
		by id;

		if last.id then delete; * remove last observation, which contains the details of a patient's hospital data termination;
	run;
	
	
	data  indiv_pn_tables;
		merge 
			indiv_pn_tables (in = from_nut)
			glnd.george (keep = id treatment)
			glnd.plate11 (keep = id bod_weight); * sorted already;
		by id;


		* Give week assignment so that we can summarize by week in PROC MEANS;
		if day < 8 then wk = 1;
		else if day < 15 then wk = 2;
		else if day < 22 then wk = 3;
		else if day < 29 then wk = 4;

		* kcal per gram body weight ;
		overall_kcal_per_kg = tot_kcal / bod_weight;
		pn_kcal_per_kg = tot_parent_kcal / bod_weight;
		en_kcal_per_kg = tot_ent_kcal / bod_weight;

			* look at PN kcal composition individually - we can't look at overall food composition since we don't have this breakdown for EN ;
			pn_aa_kcal_per_kg = pn_aa_kcal / bod_weight;
			pn_cho_per_kg = pn_cho / bod_weight;
			pn_lipid_per_kg = pn_lipid / bod_weight;

		* grams AA per kilogram body weight ;
  		overall_aa_g_per_kg = tot_aa / bod_weight;
		pn_aa_g_per_kg = pn_aa_g / bod_weight;
		en_aa_g_per_kg = tot_ent_prot / bod_weight;


		label 
			overall_kcal_per_kg = "Overall kcal/kg"
			pn_kcal_per_kg = "PN kcal/kg"
			en_kcal_per_kg = "EN kcal/kg"

			pn_aa_kcal_per_kg = "PN kcal/kg, from AA"
			pn_cho_per_kg = "PN kcal/kg, from CHO"
			pn_lipid_per_kg = "PN kcal/kg, from lipid"

			overall_aa_g_per_kg	= "Overall AA g/kg"
			pn_aa_g_per_kg = "PN AA g/kg"
			en_aa_g_per_kg = "EN AA g/kg"
			treatment="Treatment"

			;
	run;

proc means data=indiv_pn_tables median maxdec=2;
    class id wk;
    var overall_kcal_per_kg pn_kcal_per_kg en_kcal_per_kg overall_aa_g_per_kg pn_aa_g_per_kg en_aa_g_per_kg;
    ods output summary=med(keep=id wk overall_kcal_per_kg_median pn_kcal_per_kg_median en_kcal_per_kg_median overall_aa_g_per_kg_median pn_aa_g_per_kg_median en_aa_g_per_kg_median);
run;		

data med;
    merge med glnd.george (keep = id treatment); by id; 
run;

data pn;    
    set indiv_pn_tables;
    where day<15;
    
    if treatment=1 then do; 
        day1= day; 
        overall_kcal_per_kg1=overall_kcal_per_kg; 
        pn_kcal_per_kg1=pn_kcal_per_kg;
        en_kcal_per_kg1=en_kcal_per_kg;
        overall_aa_g_per_kg1=overall_aa_g_per_kg;
        pn_aa_g_per_kg1=pn_aa_g_per_kg;
        en_aa_g_per_kg1=en_aa_g_per_kg;
    end;
    if treatment=2 then do; 
        day2= day+0.25; 
        overall_kcal_per_kg2=overall_kcal_per_kg; 
        pn_kcal_per_kg2=pn_kcal_per_kg;
        en_kcal_per_kg2=en_kcal_per_kg;
        overall_aa_g_per_kg2=overall_aa_g_per_kg;
        pn_aa_g_per_kg2=pn_aa_g_per_kg;
        en_aa_g_per_kg2=en_aa_g_per_kg;
    end;
run;

/*
proc sgplot data=indiv_pn_tables(where=(day<15));
vbar day/group=treatment response=overall_kcal_per_kg limitstat = stddev
limits = upper stat=mean groundisplay=cluster; 
run;
*/

%macro getn(data);
%do j = 0 %to 15;
data _null_;
    set &data;
    where day = &j;
    if treatment=1 then call symput( "m&j",  compress(put(num_obs, 3.0)));
	if treatment=2 then call symput( "n&j",  compress(put(num_obs, 3.0)));
run;
%end;
%mend;

proc means data=indiv_pn_tables(where=(day<15)) noprint;
    class treatment day;
    var overall_kcal_per_kg;
	output out = num n(overall_kcal_per_kg) = num_obs;
run;

%let m1= 0; %let m2= 0; %let m3= 0; %let m4= 0; %let m5= 0; %let m6=0; %let m7= 0;  %let m0=0;
%let m8= 0; %let m9= 0; %let m10= 0; %let m11= 0; %let m12= 0; %let m13= 0; %let m14= 0;   
%let m15= 0; %let m16= 0; %let m17= 0; %let m18= 0; %let m19= 0; %let m20=0; %let m21= 0;  
%let m22= 0; %let m23= 0; %let m24= 0; %let m25= 0; %let m26= 0; %let m27= 0; %let m28= 0;   

%let n1= 0; %let n2= 0; %let n3= 0; %let n4= 0; %let n5= 0; %let n6=0; %let n7= 0;  %let n0=0;
%let n8= 0; %let n9= 0; %let n10= 0; %let n11= 0; %let n12= 0; %let n13= 0; %let n14= 0; 
%let n15= 0; %let n16= 0; %let n17= 0; %let n18= 0; %let n19= 0; %let n20=0; %let n21= 0;  
%let n22= 0; %let n23= 0; %let n24= 0; %let n25= 0; %let n26= 0; %let n27= 0; %let n28= 0; 

%getn(num);

proc format;

value dd 0 = "Day*(#AG-PN)*(#STD-PN)"  1="1*(&m1)*(&n1)"  2 ="2*(&m2)*(&n2)" 3="3*(&m3)*(&n3)" 4 ="4*(&m4)*(&n4)" 5="5*(&m5)*(&n5)" 6 = "6*(&m6)*(&n6)" 
        7="7*(&m7)*(&n7)" 8 = "8*(&m8)*(&n8)" 9="9*(&m9)*(&n9)" 10 = "10*(&m10)*(&n10)" 11="11*(&m11)*(&n11) " 12 = "12*(&m12)*(&n12)" 
        13="13*(&m13)*(&n13)" 	14 = "14*(&m14)*(&n14)" 15="15*(&m15)*(&n15)" 16=" ";
        
value dt 0 = "Day*(#AG-PN)*(#STD-PN)"  1=" "  2 ="2*(&m2)*(&n2)" 3=" " 4 ="4*(&m4)*(&n4)" 5=" " 6 = "6*(&m6)*(&n6)" 
        7=" " 8 = "8*(&m8)*(&n8)" 9=" " 10 = "10*(&m10)*(&n10)" 11=" " 12 = "12*(&m12)*(&n12)" 
        13=" " 	14 = "14*(&m14)*(&n14)" 15=" " 16=" ";        
run;


proc template;
 Define style styles.mystyle;
  Parent=styles.default;
  Style graphdata1 from graphdata1 / Color=pink ;
  Style graphdata2 from graphdata2 / Color=cyan ;
  Style graphdata3 from graphdata3 / Color=magenta Contrastcolor=magenta;
  end;
 run;
 ods listing style=mystyle;


proc sgplot data=indiv_pn_tables(where=(day<15)) ;
vbox overall_kcal_per_kg/group=treatment /*GROUPORDER=descending*/ category=day groupdisplay=cluster 
/*nomean*/ nocaps nooutliers WHISKERATTRS=(color=white) LINEATTRS=(color=black pattern=1)BOXWIDTH=1
/*FILLATTRS=(color=pink)*/; 
yaxis values=(0 to 35 by 5);
format day dd.;
run;
