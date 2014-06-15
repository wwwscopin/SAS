proc template;
  define statgraph surface;
  begingraph;
	    layout overlay3d;
      surfaceplotparm x=height y=weight z=density;
	    endlayout;
  	endgraph;
  end;
run;
 	
proc sgrender data=sashelp.gridded template=surface;
run;

proc template;
  define statgraph distribution;
    dynamic VAR VARLABEL TITLE NORMAL _BYLINE_;
     begingraph;
       entrytitle TITLE;
       entrytitle _BYLINE_;
       layout lattice / columns=1 rows=2  rowgutter=2px
                        rowweights=(.9 .1) columndatarange=union;
       columnaxes;
         columnaxis / label=VARLABEL;
       endcolumnaxes;
       layout overlay / yaxisopts=(offsetmin=.035);
  	    layout gridded / columns=2 border=true autoalign=(topleft topright);
          entry halign=left "Nobs";
 	        entry halign=left eval(strip(put(n(VAR),8.)));	
          entry halign=left "Mean";
 	        entry halign=left eval(strip(put(mean(VAR),8.2)));
  	       entry halign=left "StdDev";
  	       entry halign=left eval(strip(put(stddev(VAR),8.3)));
      		endlayout;
      histogram VAR / scale=percent; 		
      if (exists(NORMAL))
        densityplot VAR / normal( );
      		endif;
      fringeplot VAR / datatransparency=.7;
      endlayout;
      boxplot y=VAR / orient=horizontal;
    endlayout;
 endgraph;
end;
run;
 	
proc sgrender data=sashelp.heart template=distribution;
  dynamic var="cholesterol" varlabel="Cholesterol (LDL)" normal="yes"
          title="Framingham Heart Study";
run;

proc sort data=sashelp.cars out=cars; 
  by origin; 
run;
 	
proc sgrender data=cars template=distribution;
  by origin;
  dynamic var="weight" varlabel="Weight in LBS"  
          title="Distribution of Vehicle Weight";
run;
