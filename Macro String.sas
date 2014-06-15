%macro revrs(string);
   %local nstring;
   %do i=%length(&string) %to 1 %by -1;
      %let nstring=&nstring%qsubstr(&string,&i,1);
	  &nstring
   %end;
 *&nstring;
%mend revrs;

%macro test;
   Two words
%mend test;

%put %nrstr(%test%test) - %revrs(%test%test);

%let wbh=A;
%let ldh=B;

%put &wbh&ldh;
