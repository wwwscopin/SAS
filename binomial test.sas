data Color;
   input Region Eyes $ Hair $ Count @@;
   label Eyes  ='Eye Color'
         Hair  ='Hair Color'
         Region='Geographic Region';
   datalines;
1 blue  fair   23  1 blue  red     7  1 blue  medium 24
1 blue  dark   11  1 green fair   19  1 green red     7
1 green medium 18  1 green dark   14  1 brown fair   34
1 brown red     5  1 brown medium 41  1 brown dark   40 
1 brown black   3  0 blue  fair   46  0 blue  red    21
0 blue  medium 44  0 blue  dark   40  0 blue  black   6
0 green fair   50  0 green red    31  0 green medium 37
0 green dark   23  0 brown fair   56  0 brown red    42
0 brown medium 53  0 brown dark   54  0 brown black  13
;
run;

proc freq data=Color order=freq;
   tables region / binomial(ac wilson exact level=1) alpha=.1 ;
   *tables Hair / binomial(equiv p=.28 margin=.1);
   exact binomial;
   weight Count;
   title 'Hair and Eye Color of European Children';
run;


proc freq data=Color order=freq;
   tables region / binomial(ac wilson exact level=2) alpha=.1 ;
   *tables Hair / binomial(equiv p=.28 margin=.1);
   exact binomial;
   weight Count;
   title 'Hair and Eye Color of European Children';
run;

proc freq data=Color order=freq;
   tables region / binomial;
run;
