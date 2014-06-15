%let varlabel= Flu vaccine,Tetanus-diptheria,Hepatitis B vaccine,Hepatitis A vaccine,PPD,Pneumovax;

*%let bbb= %scan(%BQUOTE(&varlabel),1,',');
%let bbb= %scan("&varlabel",1,',');
quit;
%put the 1st is &bbb;
