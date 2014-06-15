/*
Author: Skumar 
 Date: 25/11/2009
  Overview:
 
This program creates two datasets city_table, state_table with city_table having cities and abbreviated states as two fields and states_table having abbreviated states and full state fields.
 
These two datasets are merged using four merging techiques: 

1. General Merge Statement 2. SQL Join 3. Hash Merge 4. Proc Format 

SAS Code
 */

/*********************/
/* Datasets creation */
/*********************/
data city_table1;
length city $12. state $4.; 
 input city $ state $;
   datalines;
fresno ca
stockton ca
oakland	ca
fremont	ca
sacramento ca
irvine ca
Jacksonville fl
miami fl
tampa fl
orlando	fl
hialeah	fl
atlanta	ga
augusta	ga
columbus ga
savannah ga
macon ga
dallas tx
houston tx
austin tx
franklin tx
chicago il
;
run;


data city_table;
		set city_table1;
sales = int(ranuni(3)*1000000);
format sales dollar10.;
run;


data state_table;
length state $4. full_state $10.; 
 input state $ full_state $;
   datalines;
ca california
fl florida
ga georgia
tx texas
co colorado
;
run;


/***************************/
/* General merge statement */
/***************************/

proc sort data = city_table;
by state;
run;

proc sort data = state_table;
by state;
run;


data general_merge1;
merge city_table(in=a) state_table(in=b);
by state;
if a;
run;



data general_merge;
set general_merge1;
if full_state = '' then full_state = 'unknown';
run;


/************/
/* Sql Join */
/************/

proc sql;
  create table sql_join1 as
  select city_table.city, city_table.state, state_table.full_state, city_table.sales
  from city_table left join state_table
  on city_table.state = state_table.state
  order by city_table.state;
quit;

data sql_join;
set sql_join1;
if full_state = '' then full_state = 'unknown';
run;


/**************/
/* Hash merge */
/**************/

data hash_merge(drop = rc);
length full_state $10;
if _N_ = 1 then do;
		    declare hash h_state(dataset:'state_table');
		    h_state.definekey('state');
			h_state.DefineData ('full_state');
		    h_state.definedone();
end;
set city_table;

rc = h_state.find();

if rc ne 0 then full_state = 'unknown';

run;

proc print;run;

/*********************/
/* proc format merge */
/*********************/

data key; set state_table (keep = state full_state);
/* These variables translate to the FORMAT values in the metadata */
fmtname = '$key';
label = full_state;
rename state = start;
run;

proc sort data=key;
by start;
run;
proc print;run;

proc format cntlin=key;
run;

data format_merge;
set city_table;
length full_state $15.;
full_state=put(state,$key.);
if put(state,$key.) = state then full_state = 'unknown';
run;
