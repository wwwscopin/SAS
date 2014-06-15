*** Use sas to perform Unix command: find all xpt files under the known directory, sort by the directries, output in a txt file ***;

%macro find ;

X 'find /home/xxx -name "*.xpt" -exec ls -i1 {} \; | sort > /home/xxx/zzz.txt';

%if &sysrc ne 0 %then %do ;
endsas;
%end ;

%mend find ;

%find ;
