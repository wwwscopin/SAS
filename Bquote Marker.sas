%let var1 = " ","b","d";
%let n1 = %scan(%BQUOTE(&var1.), 1, %str(,));
%let n2 = %scan(%BQUOTE(&var1.), 2, %str(,));
%let n3 = %scan(%BQUOTE(&var1.), 3, %str(,));
%put &n1.;
%put &n2.;
%put &n3.;

%let var1 = " ","b","d";
%let n1 = %scan(%BQUOTE(&var1.), 1, ",");
%let n2 = %scan(%BQUOTE(&var1.), 2, ",");
%let n3 = %scan(%BQUOTE(&var1.), 3, ",");
%put &n1.;
%put &n2.;
%put &n3.;
