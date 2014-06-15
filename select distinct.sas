data employees;
  input name $ dep $ base_salary;
  datalines;
Charles Sales 70000
James HR 80000
Cindy HR 75000
Steven Sales 80000
;

data bonus;
  input year dep $ bonus;
  datalines;
2012 Sales 10000
2012 Marketing 12000
2012 HR 8000
2013 Sales 18000
2013 Marketing 20000
2013 HR 16000
;


proc sql;
  create table wbh as
  select distinct e.*, max(base_salary+(year=2012)*bonus) as salary2012, max(base_salary+(year=2013)*bonus) as salary2013
from employees e,bonus b
where e.dep=b.dep
group by e.dep;
quit;


proc sql;
  create table wbh as
  select distinct e.*, year,bonus, base_salary+(year=2012)*bonus as salary2012, base_salary+(year=2013)*bonus as salary2013
from employees e,bonus b
where e.dep=b.dep;
quit;


proc print;run;
