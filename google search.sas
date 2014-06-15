data one;
    input @1 title $25.;
cards;
This is the End
World War Z
Man of Steel
Monsters University
The Internship 
;run;

data two(where=(missing(word)=0));
    set one nobs = nobs;
    if _n_ ne nobs then
    title1 = cat(title, "%2C");
    else title1 = title;
    do i = 1 to 10;
        word = scan(title1, i, " ");
        output;
    end;
    keep word;
run;

proc sql noprint;
    select word into: string separated by "%20"
    from two
;quit;
%put &string;

data three;
    length fullstring $500.;
    fullstring = cats("http://www.google.com/trends/explore?q=", "&string", '&geo=US&date=today%203-m&cmpt=q');
run;

proc print;
run;
