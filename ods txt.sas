data sup_sub;
length myvar $200;
myvar = "Pythagorean Theorem: a^{super 2} + b^{super 2} = c^{super 2}";
output;
myvar = "This is something that needs a footnote. ^{super 1}";
output;
myvar = "Macbeth: 'Is this a dagger I see before me?' ^{dagger}";
output;
myvar = "The Caffeine molecule is an alkaloid of the methylxanthine family: " ||
"C^{sub 8}H^{sub 10}N^{sub 4}O^{sub 2}";
output;
run;
ods html file='inline2.html' style=sasweb;
ods html3 file='inline2.xls' style=sasweb;
ods rtf file='inline2.rtf' notoc_data;
ods pdf file='inline2.pdf';
ods escapechar='^';
footnote1 j=l "Note. Data include persons with a diagnosis of HIV infection regardless of stage of disease at diagnosis.";
																	
footnote2 j=l "^{super a}Estimated numbers resulted from statistical adjustment that accounted for reporting delays and
		  missing risk-factor information, but not for incomplete reporting. Rates are per 100,000 population. 
          Rates are not calculated by transmission category because of the lack of denominator data.";

footnote3 j=l "^{super b}Hispanics/Latinos can be of any race.";

footnote4 j=l "^{super c}Heterosexual contact with a person known to have, or to be at high risk for, HIV infection.  ";
footnote5 j=l "^{super d}Includes hemophilia, blood transfusion, perinatal exposure, and risk factor not reported or not identified. ";
footnote6 j=l "^{super e}Includes hemophilia, blood transfusion, and risk factor not reported or not identified. ";


footnote7 j=l "^{super f}Because column totals for estimated numbers were calculated independently of the values for the
          subpopulations, the values in each column may not sum to the column total.";

proc print data=sup_sub;
title j=r 'PDF & RTF: Page ^{thispage} of ^{lastpage}';
title2 j=c 'RTF only: ^{pageof}';
/*
footnote '^{super 1}If this were a real footnote, there would be something very
academic here.';
footnote2 '^{dagger} Macbeth talked to himself a lot. This quote is from Macbeth:
Act 2, Scene 1, Lines 33-39.';
*/
run;

ods _all_ close;
