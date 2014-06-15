options nocenter nonumber nodate mprint mlogic symbolgen
        orientation = landscape ls = 125 formchar = "|----|+|---+=|-/\<>*";
 
%macro get_pdo(data = , score = , y = , wt = NONE, ref_score = , target_odds = , target_pdo = );
**********************************************************************;
* THIS MACRO IS TO CALCULATE OBSERVED ODDS AND PDO FOR ANY SCORECARD *;
* AND COMPUTE ALIGNMENT BETAS TO REACH TARGET ODDS AND PDO           *;
* ------------------------------------------------------------------ *;
* PARAMETERS:                                                        *;
*  DATA       : INPUT DATASET                                        *;
*  SCORE      : SCORECARD VARIABLE                                   *;
*  Y          : RESPONSE VARIABLE IN (0, 1)                          *;
*  WT         : WEIGHT VARIABLE IN POSITIVE INTEGER                  *;
*  REF_SCORE  : REFERENCE SCORE POINT FOR TARGET ODDS AND PDO        *;
*  TARGET_ODDS: TARGET ODDS AT REFERENCE SCORE OF SCORECARD          *;
*  TARGET_PDO : TARGET POINTS TO DOUBLE ODDS OF SCARECARD            *; 
* ------------------------------------------------------------------ *;
* OUTPUTS:                                                           *;
*  REPORT : PDO REPORT WITH THE CALIBRATION FORMULA IN HTML FORMAT   *;
* ------------------------------------------------------------------ *;
* AUTHOR: WENSUI.LIU@53.COM                                          *;
**********************************************************************;
 
options nonumber nodate orientation = landscape nocenter;  
 
*** CHECK IF THERE IS WEIGHT VARIABLE ***;
%if %upcase(&wt) = NONE %then %do;
  data _tmp1 (keep = &y &score _wt);
    set &data;
    where &y in (1, 0)  and
          &score ~= .;
    _wt = 1;
    &score = round(&score., 1);
  run;
%end;
%else %do;
  data _tmp1 (keep = &y &score _wt);
    set &data;
    where &y in (1, 0)        and
          &score ~= .         and
          round(&wt., 1) > 0;
    _wt = round(&wt., 1);
    &score = round(&score., 1);
  run;
%end;
 
proc logistic data = _tmp1 desc outest = _est1 noprint;
  model &y = &score;
  freq _wt;
run;
 
proc sql noprint;
  select round(min(&score), 0.01) into :min_score from _tmp1;
 
  select round(max(&score), 0.01) into :max_score from _tmp1;
quit;
 
data _est2;
  set _est1 (keep = intercept &score rename = (&score = slope));
 
  adjust_beta0 = &ref_score - (&target_pdo * log(&target_odds) / log(2)) - intercept * &target_pdo / log(2);
  adjust_beta1 = -1 * (&target_pdo * slope / log(2));
 
  do i = -5 to 5;
    old_pdo = round(-log(2) / slope, 0.01);
    old_ref = &ref_score + (i) * old_pdo;
    old_odd = exp(-(slope * old_ref + intercept)); 
    if old_ref >= &min_score and old_ref <= &max_score then output; 
  end;
run;
 
data _tmp2;
  set _tmp1;
   
  if _n_ = 1 then do;
    set _est2(obs = 1);
  end;
 
  adjusted = adjust_beta0 + adjust_beta1 * &score;
run;
 
proc logistic data = _tmp2 desc noprint outest = _est3;
  model &y = adjusted;
  freq _wt;
run;
 
data _est4;
  set _est3 (keep = intercept adjusted rename = (adjusted = slope));
 
  adjust_beta0 = &ref_score - (&target_pdo * log(&target_odds) / log(2)) - intercept * &target_pdo / log(2);
  adjust_beta1 = -1 * (&target_pdo * slope / log(2));
 
  do i = -5 to 5;
    new_pdo = round(-log(2) / slope, 0.01);
    new_ref = &ref_score + (i) * new_pdo;
    new_odd = exp(-(slope * new_ref + intercept)); 
    if new_ref >= &min_score and new_ref <= &max_score then output;
  end;
run;
  
proc sql noprint;
create table
  _final as
select
  &target_pdo            as target_pdo,
  &target_odds           as target_odds, 
  a.old_pdo              as pdo1,
  a.old_ref              as ref1,
  a.old_odd              as odd1,
  log(a.old_odd)         as ln_odd1,
  a.adjust_beta0         as adjust_beta0, 
  a.adjust_beta1         as adjust_beta1,
  b.new_pdo              as pdo2,
  b.new_ref              as ref2,
  b.new_odd              as odd2,
  log(b.new_odd)         as ln_odd2
from
  _est2 as a inner join _est4 as b
on
  a.i = b.i;
 
select round(pdo1, 1) into :pdo1 from _final;
 
select put(max(pdo1 / pdo2 - 1, 0), percent10.2) into :compare from _final;
 
select case when pdo1 > pdo2 then 1 else 0 end into :flag from _final;
 
select put(adjust_beta0, 12.8) into :beta0 from _final;
 
select put(adjust_beta1, 12.8) into :beta1 from _final;
quit;
 
%put &compare;
ods html file = "%upcase(%trim(&score))_PDO_SUMMARY.html" style = sasweb;
title;
proc report data  = _final box spacing = 1 split = "/" 
  style(header) = [font_face = "courier new"] style(column) = [font_face = "courier new"]
  style(lines) = [font_face = "courier new" font_size = 2] style(report) = [font_face = "courier new"];
 
  column("/SUMMARY OF POINTS TO DOUBLE ODDS FOR %upcase(&score) WEIGHTED BY %upcase(&wt) IN DATA %upcase(&data)
          /( TARGET PDO = &target_pdo, TARGET ODDS = &target_odds AT REFERENCE SCORE &ref_score ) / "
         pdo1 ref1 odd1 ln_odd1 pdo2 ref2 odd2 ln_odd2);
 
  define pdo1    / "OBSERVED/SCORE PDO"   width = 10 format = 4.   center;
  define ref1    / "OBSERVED/REF. SCORE"  width = 15 format = 5.   center order order = data;
  define odd1    / "OBSERVED/ODDS"        width = 15 format = 14.4 center;
  define ln_odd1 / "OBSERVED/LOG ODDS"    width = 15 format = 8.2  center;
  define pdo2    / "ADJUSTED/SCORE PDO"   width = 10 format = 4.   center;
  define ref2    / "ADJUSTED/REF. SCORE"  width = 15 format = 5.   center;
  define odd2    / "ADJUSTED/ODDS"        width = 15 format = 14.4 center;  
  define ln_odd2 / "ADJUSTED/LOG ODDS"    width = 15 format = 8.2  center;
 
  compute after;
  %if &flag = 1 %then %do;
    line @15 "THE SCORE ODDS IS DETERIORATED BY %trim(&compare).";
    line @15 "CALIBRATION FORMULA: ADJUSTED SCORE = %trim(&beta0) + %trim(&beta1) * %trim(%upcase(&score)).";
  %end;
  %else %do;
    line @25 "THERE IS NO DETERIORATION IN THE SCORE ODDS."; 
  %end;
  endcomp;
run;;
ods html close;
 
*************************************************;
*              END OF THE MACRO                 *;
*************************************************; 
%mend get_pdo;

data tmp1;
  set data.accepts;
  where bureau_score ~= .;
run;
 
%get_pdo(data = tmp1, score = bureau_score, y = bad, wt = weight, ref_score = 680, target_odds = 20, target_pdo = 45);
 
/*

data tmp2;
  set tmp1;
  adjust_score = 20.92914838 + 0.97156812 * bureau_score;
run;
 
%get_pdo(data = tmp2, score = adjust_score, y = bad, wt = weight, ref_score = 680, target_odds = 20, target_pdo = 45);
 
/*
