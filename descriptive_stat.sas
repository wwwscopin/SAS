/* descriptive_stat.sas */

/** STILL LEFT TO DO:
 
  1. support switching of headers to continuous (most of code is here) or starting as continuous!
  2. make 2-level stratification and by-visit/day more generic
	DO NEXT - make DOL into CLASS
  3. integrate graphs into TOC scheme

 
	  TEST:
	stratification
	continuous variables - both param and non-param

then done!
***/

ods escapechar = "^";
*options mlogic symbolgen ;

* types = cont, cat, bin; 
* for yes/no binary variables, you can choose cat or bin, depending on whether you want to see the yes and no choices;

* all variables in the table must have a row. if you are using categorical variables, they must have formats;

* one macro to process binary variables and continuous variables using proc means - specify with parameter "type= ";
%macro descriptive_stat (	data_in=, where=, data_out=, var= , type=, non_param= , first_var= , last_var=, by_cohort= , by_DOL = , 
				spaces= , dec_places= , custom_label=, print_rtf= , file=, title=, footnote=  );
		
	* set default values;
	data _NULL_;
		if compress("&non_param") = "" then call symput("non_param", "1");
		if compress("&first_var") = "" then call symput("first_var", "0");
		if compress("&last_var") = "" then call symput("last_var", "0");
		if compress("&by_cohort") = "" then call symput("by_cohort", "0");
		if compress("&by_DOL") = "" then call symput("by_DOL", "0");
		if compress("&spaces") = "" then call symput("spaces", "0");
		if compress("&dec_places") = "" then call symput("dec_places", "1");
		if compress("&print_rtf") = "" then call symput("print_rtf", "0");
	run;
	
	*** TABLE-MAKING MODE (NON-PRINTING MODE) ***;
	%if ("&print_rtf" = "0") %then %do;

	%let x = 1;

	* Decide if we run the loop once or three times (just overall, or overall and by cohorts );
	%if (&by_cohort = 0) %then %do; %let stop_num = 1; %end;
	%else %do; %let stop_num = 3;; %end; 

	%do %while (&x <= &stop_num);

		* subset data according to where input;
		data x;	
			set &data_in;
			where &where;
		run;

		* for CONTINUOUS or BINARY types;
		%if ("&type" = "bin") | ("&type" = "cont") %then %do;

			** calculate summary statistics;
			proc means data = x fw=5 maxdec=1 nonobs n mean stddev median min max ;
					%if (&x > 1) %then %do; * this is valid since we are inside of a loop already;
						where (cohort = &x - 1);
					%end;


				%if (&by_DOL = 1) %then %do; class DOL; %end;

				var &var;
				output out = &var sum(&var) = &var._sum n(&var) = &var._n median(&var) = &var._median q1(&var) = &var._q1 q3(&var) = &var._q3
						 mean(&var) = &var._mean  stddev(&var) = &var._stddev min(&var) = &var._min max(&var) = &var._max nmiss(&var) = &var._nmiss;
			run;

			**** to save on space if we have many variables and big datasets, we can overwrite the same output dataset. the mode i choose is to keep the results around for later viewing/verification;
			** clean up for display;
			data &var;
				set &var;
				
				* if by DOL, then exclude overall results ;
				%if (&by_DOL = 1) %then %do; where _TYPE_ = 1; %end;

			        length disp $ 65;
			        length row $ 120;
				length variable $ 120;
			        
				* fix variable names;
					n = &var._n;			sum = &var._sum;
					median = &var._median;		q1 = &var._q1;
					q3 = &var._q3;			mean = &var._mean;
					stddev = &var._stddev;		min = &var._min;
					max = &var._max;		nmiss = &var._nmiss;

				* assign descriptive label to each row:;

				if compress(symget('custom_label')) = "" then do; 		* SAS isnt liking my feeding the raw macro variable to the compress function. i must use symget;
					* add variable/row headers to rows, using assigned SAS labels;
					variable = varlabel(open("&data_in", "i"), varnum(open("&data_in"), "&var"));
					
						* There are prefixes such as 2a. and 2.b. before the labels for easy reference in DataFax QC reports. Remove them!;
						* searches first 10 characters only in case there is a period later, like at the end of a sentence ;
						do while (0 < find(variable, ".") < 10);
							variable = trim(substr(variable,find(variable, ".") + 1));
						end;
				end;
				else  variable = substr(trim(symget('custom_label')), 2, length(trim(symget('custom_label'))) - 2); * trim quote marks;

				row  = /*"^S={font_weight = bold}" ||*/ compress(substr(variable,1,2)) || substr(variable,3);; 
					* this is necessary since, for categorical variables, we need an extra column for sorting;
					* i use compress on the first part since sometimes trim doesnt work!!!;
					* when we get SAS 9.2, we can use ^S={textdecoration = underline} ;

				* syntax is identical for varfmt - USE FOR CATEGORICAL VARIABLES!!! ;

				%if (&by_DOL = 1) %then %do; disp_visit = compress(put(visit, visit.)); %end;* make a text field of visit so that it can be made blank;

				* set up columns for display ;
				* if binary ;
					if ("&type" = "bin") then do;
						disp = compress(put(sum, 12.0)) || "/" || compress(put(n, 12.0)) || " (" || compress(put((sum/n) * 100, 12.&dec_places)) || "%)";
					end;
				* if continuous ;
					else if ("&type" = "cont") & ("&non_param" = "1") then do;
						disp = compress(put(median, 12.&dec_places)) || " (" || compress(put(q1, 12.&dec_places)) || ", " || compress(put(q3, 12.&dec_places)) || ") [" || 
									compress(put(min, 12.&dec_places)) || "-" || compress(put(max, 12.&dec_places)) || "], " || compress(put(n, 12.0))
						;
					end;
					else if ("&type" = "cont") then do;
						disp = 	compress(put(mean, 12.&dec_places)) || " (" || compress(put(stddev, 12.&dec_places)) || ") [" || 
									compress(put(min, 12.&dec_places)) || "-" || compress(put(max, 12.&dec_places)) || "], " || compress(put(n, 12.0))
						;
					end;
				drop &var._sum &var._n &var._median &var._q1 &var._q3 &var._mean &var._stddev &var._min &var._max &var._nmiss;
			run;

		%end;

		* for CATEGORICAL types;
		%if ("&type" = "cat") %then %do;

			* calculate summary statistics;
		        proc freq data= x compress noprint;
					%if (&x > 1) %then %do; * this is valid since we are inside of a loop already;
						where (cohort = &x - 1);
					%end;
		            tables &var /nocum out = &var;
		        run;

		        proc sort data = &var; by descending &var ; run;
	
			* clean up for display;
		        data &var; set &var;
		                length variable $ 120;
		                length disp $ 65;
		                length row $ 120;
		            n = round((count/(percent/100)), 1); * add n to each record ;

			 
		            if (&var ~= .) then do;
		                disp = compress(put(count, 12.0)) || "/" || compress(put(n, 12.0)) || " (" ||  compress(put(percent, 12.&dec_places)) || "%)";
			
		                row = "	- " || putn(&var , varfmt(open("&data_in"), varnum(open("&data_in"), "&var"))); 
											* use assigned format - MUST USE PUTN rather than PUT, since computed at runtime! ;

		            end;
		            else do;
		                disp = compress(put(count, 3.0));
		                row = "	(missing)";
		            end;

				variable = varlabel(open("&data_in", "i"), varnum(open("&data_in"), "&var"));
			
				* There are prefixes such as 2a. and 2.b. before the labels for easy reference in DataFax QC reports. Remove them!;
				* searches first 10 characters only in case there is a period later, like at the end of a sentence ;
				do while (0 < find(variable, ".") < 10);
					variable = trim(substr(variable,find(variable, ".") + 1));
				end;
			run;


		    	* add a header with the variable name in bold;
		        data first_line;

			        length disp $ 65;
			        length row $ 120;
				length variable $ 120;

				* assign descriptive label to each row:;
				if compress(symget('custom_label')) = "" then do; 		* SAS isnt liking my feeding the raw macro variable to the compress function. i must use symget;
					variable = varlabel(open("&data_in", "i"), varnum(open("&data_in"), "&var"));
				
					* There are prefixes such as 2a. and 2.b. before the labels for easy reference in DataFax QC reports. Remove them!;
					* searches first 10 characters only in case there is a period later, like at the end of a sentence ;
					do while (0 < find(variable, ".") < 10);
						variable = trim(substr(variable,find(variable, ".") + 1));
					end;
				end;
				else  variable = substr(trim(symget('custom_label')), 2, length(trim(symget('custom_label'))) - 2); * trim quote marks;

				row = /*"^S={font_weight = bold}" ||*/ compress(substr(variable,1,2)) || substr(variable,3);
				disp = " ";	
		        run;

		        data &var; 
				set first_line &var;
			        
			run;

			/************************ STRATIFYING ON DOL NOT IMPLEMENTED FOR CATEGORICAL VARS (since unclear how table should be organized). CODE IS BELOW- need to complete!
			proc freq data = &data_in;
				tables DOL * &var / out = &var outpct;
			run;

			data &var;
				set &var;
				keep &var DOL count pct_row;
			run;

				proc transpose data = &var out = &var_count;
					var &var;
					id &var;
					by DOL;
				run;
				proc transpose data = &var out = &var_trans;
					var count;
					id &var;
					by DOL;
				run;
				proc transpose data = &var out = &var_trans;
					var pct_row;
					id &var;
					by DOL;
				run;
			* merge the 3 datasets horizontally;
			**********************************************************/
		%end;

	  		* stack results - if first variable, then start our growing results table;
			data table;
				%if (&first_var = 1) %then %do;
					set &var;
				%end;
				%else %do;
					set table
					&var;
				%end;
			run;



		* if its the last variable, process the table for printing! ;
		%if (&last_var = 1) %then %do;
			%if 				(&x = 1) %then %let label = Overall;
			%else %if 	(&x = 2) %then %let label = CMV_pos;
			%else %if 	(&x = 3) %then %let label = CMV_neg;
		

			* process for printing ;
			data table_&label;
					set table;

				by variable row notsorted;
				
				* add line with title at beginning of category;
				*** see "outcome_summary_ab.sas" for details on having categories of outcomes ;
				output;

				* add blank line at end of category;
				%if (&spaces = 1) %then %do;
					if last.variable then do;
						variable = variable;
						row = row;
						%if (&by_DOL = 1) %then %do; disp_visit = '00'x; %end;
						disp = '00'x;
						output;
						
						/******** IMPLEMENT ********
						* add headers for continuous variables on last row of categorical ;
						if row = "ACR-70" then do;
							row = row;
							%if (&by_DOL = 1) %then %do; disp_visit = '00'x; %end;
							disp = "^S={fontstyle= slant font_weight = bold}median (Q1, Q3), n"; * ^S={textdecoration = underline}; 
							output;
						end;
						****************************/
					end;
				%end;

				label 		variable= '00'x
						row ='00'x
						/*disp_visit = '00'x*/
						%if &x = 1 %then %do; disp = "Overall*^S={font_weight = bolrow  =  || d}total (%)" %end;					
						%if &x = 2 %then %do; disp = "CMV+ cohort*^S={font_weight = bold}total (%)" %end;
						%if &x = 3 %then %do; disp = "CMV- cohort*^S={font_weight = bold}total (%)" %end;
						;
			run;			
	
		** Post-process - MERGE all 3 tables if doing by cohort ** ;
		%if (&by_cohort = 0) %then %do;
			data &data_out;
				set table_Overall (rename = (disp = disp_overall));

				label disp_overall = '00'x;
			run;
		%end;

		%else %if (&by_cohort = 1) %then %do;
			* remember the sorting order for the overall table;
			data table_overall;
		        set table_overall;

				order = _N_;
			run;

			* sort each table then merge!;
			proc sort data = table_Overall; %if (&by_DOL = 1) %then %do; by variable row disp_visit; %end;	%else %if (&by_DOL = 0) %then %do; by variable row; %end; run;	
			proc sort data = table_CMV_pos; %if (&by_DOL = 1) %then %do; by variable row disp_visit; %end;	%else %if (&by_DOL = 0) %then %do; by variable row; %end; run;	
			proc sort data = table_CMV_neg; %if (&by_DOL = 1) %then %do; by variable row disp_visit; %end;	%else %if (&by_DOL = 0) %then %do; by variable row; %end; run;

			data &data_out;
				 %if (&by_DOL = 1) %then %do;
				merge 
					table_Overall (keep = order variable row disp_visit disp rename = (disp = disp_overall))
					table_CMV_pos (keep = variable row disp_visit disp rename = (disp = disp_CMV_pos ))
					table_CMV_neg (keep = variable row disp_visit disp rename = (disp = disp_CMV_neg))
					;
				%end;

				%else %if (&by_DOL = 0) %then %do;
				merge 
					table_Overall (keep = order variable row disp rename = (disp = disp_overall))
					table_CMV_pos (keep = variable row disp rename = (disp = disp_CMV_pos ))
					table_CMV_neg (keep = variable row disp rename = (disp = disp_CMV_neg))
					;
				%end;

				%if (&by_DOL = 1) %then %do; by variable row disp_visit; %end;	
				%else %if (&by_DOL = 0) %then %do; by variable row; %end;

			run;

			* get everything back into the correct sorting order; 
			proc sort data = table;	by order;	run;
		%end;
		%end; 

		%let x = &x + 1;
	%end;	* end loop;

	%end; * end table-making mode;

	*** PRINTING MODE! ***; 

	options nodate orientation = portrait;

	%if ("&print_rtf" = "1") %then %do;
		%if (&by_cohort = 0) %then %do;
			ods rtf file = &file  style=journal toc_data startpage = no bodytitle;
			ods escapechar='^';
				ods noproctitle proclabel &title;
				title1 &title; 
				footnote1 height=1.8 &footnote;				
				proc print data = &data_out label noobs split = "*" style(header) = {just=center} contents = "";
					id  row /style(data) = [font_size=1.8 font_style=Roman];
					by  row notsorted;
					var disp_overall /style(data) = [just=center font_size=1.8];
				run;
				ods rtf text = "{\sectd \pard \par \sect}"; * insert section and page breaks ;
			ods rtf close;
		%end;



		%else %if (&by_cohort = 1) %then %do;			ods rtf file = &file  style=journal toc_data startpage = yes bodytitle;
				ods noproctitle proclabel &title;
				title1 &title; 
				proc print data = &data_out label noobs split = "*" style(header) = [just=center] contents = "";
					id  row;
					by  row notsorted;

					var disp_CMV_pos disp_CMV_neg disp_overall /style(data) = [just=center];
				run;
				ods rtf text = "{\sectd \pard \par \sect}"; * insert section and page breaks ;
			ods rtf close;
		%end;

	%end;
    %mend descriptive_stat;




