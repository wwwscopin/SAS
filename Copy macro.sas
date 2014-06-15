options mstored sasmstore=macro; 
libname macro 'H:\SASTest\SelfLearn'; 

%macro test / store des='This is my program';
         %let x=1;
%mend;

%copy test/source;

proc catalog cat=macro.sasmacr;
        contents;
run;
