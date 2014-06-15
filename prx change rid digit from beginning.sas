data a;
  input name $;
  cards;
123ABC34
ABC35
12ABC43
;
run;

data b;
   set a;
   name = prxchange('s/^(\d*)/ /', -1, name);
run;

proc print;run;
