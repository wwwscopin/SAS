options nodate pageno=1 linesize=64 pagesize=60    fmtsearch=(proclib); 

data grocery;
   input Sector $ Manager $ Department $ Sales @@;
   datalines;
se 1 np1 50    se 1 p1 100   se 1 np2 120   se 1 p2 80
se 2 np1 40    se 2 p1 300   se 2 np2 220   se 2 p2 70
nw 3 np1 60    nw 3 p1 600   nw 3 np2 420   nw 3 p2 30
nw 4 np1 45    nw 4 p1 250   nw 4 np2 230   nw 4 p2 73
nw 9 np1 45    nw 9 p1 205   nw 9 np2 420   nw 9 p2 76
sw 5 np1 53    sw 5 p1 130   sw 5 np2 120   sw 5 p2 50
sw 6 np1 40    sw 6 p1 350   sw 6 np2 225   sw 6 p2 80
ne 7 np1 90    ne 7 p1 190   ne 7 np2 420   ne 7 p2 86
ne 8 np1 200   ne 8 p1 300   ne 8 np2 420   ne 8 p2 125
;

ods html3 /*style=styles.sas2excel*/ style=journal body="test.xls";
ods rtf file="test.rtf";
proc report data=grocery nowd headline headskip; 
   column sector manager sales; 
   define sector / group format=$sctrfmt.  'Sector';
   define manager / group  format=$mgrfmt.  'Manager';
   define sales / analysis sum  format=comma10.2 'Sales'; 
 
   break after sector /ol summarize suppress  ol; 
 
   compute after;
      line 'Combined sales for the northern sectors were '
            sales.sum dollar9.2 '.';
   endcomp; 
 
   compute sales;
      if _break_ ne ' ' then
      call define(_col_,"format","dollar11.2");
   endcomp; 

   where sector contains 'n'; 
   title 'Sales Figures for Northern Sectors';
run; 
ODS ESCAPECHAR="^";
ODS rtf TEXT="^S={LEFTMARGIN=0.9in RIGHTMARGIN=0.9in font_size=11pt}
Thrombocytopenia was defined by Lindern et al. as a platelet count  below 150 x 10^{super 9}/L : BMC Pediatrics 2011,11:16.";
ods rtf close;
ODS html3 TEXT="^S={LEFTMARGIN=0.9in RIGHTMARGIN=0.9in font_size=11pt}
Thrombocytopenia was defined by Lindern et al. as a platelet count  below 150 x 10^{super 9}/L : BMC Pediatrics 2011,11:16.";
ods html3 close;
