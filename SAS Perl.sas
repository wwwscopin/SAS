data _null_;
id=prxparse('/Hello world!/');
put id=;

pos=prxmatch('/world/','Hello world!');
put pos=;

txt=prxchange('s/world/planet/',-1, 'Hello world!');
put txt=;
run;

data phone_numbers;
length first last phone $ 16;
input first last phone & $16.;
datalines;
Thomas Archer (919)319-1677
Lucy Barr 800-899-2164
Tom Joad (508) 852-2146
Laurie Gil (252)152-7583
;
data invalid;
set phone_numbers;
where not
prxmatch("/\([2-9]\d\d\) ?" ||
"[2-9]\d\d-\d\d\d\d/",phone);
run;

proc print;run;


proc sql; /* Same as prior data step */
create table invalid as
select * from phone_numbers
where not
prxmatch("/\([2-9]\d\d\) ?" ||
"[2-9]\d\d-\d\d\d\d/",phone);
quit;

data _null_;
   x = 'MCLAUREN';
   x = prxchange("s/(MC)/\u\L$1/i", -1, x);
   put x=;
run;

