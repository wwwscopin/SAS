/***********************************************************/
/* Example of creating a correlation heatmap               */
/* featured on http://blogs.sas.com/sasdummy               */
/* Copyright (c) SAS Institute Inc.                        */
/*                                                         */
/***********************************************************/
/* Create a Heatmap implementation of a correlation matrix */
ods path work.mystore(update) sashelp.tmplmst(read);

proc template;
	define statgraph corrHeatmap;
   dynamic _Title;
		begingraph;
         entrytitle _Title;
			rangeattrmap name='map';
			/* select a series of colors that represent a "diverging"  */
			/* range of values: stronger on the ends, weaker in middle */
			/* Get ideas from http://colorbrewer.org                   */
			range -1 - 1 / rangecolormodel=(cxD8B365 cxF5F5F5 cx5AB4AC);
			endrangeattrmap;
			rangeattrvar var=r attrvar=r attrmap='map';
			layout overlay / 
				xaxisopts=(display=(line ticks tickvalues)) 
				yaxisopts=(display=(line ticks tickvalues));
				heatmapparm x = x y = y colorresponse = r / xbinaxis=false ybinaxis=false
					colormodel=THREECOLORRAMP name = "heatmap" display=all;
				continuouslegend "heatmap" / 
					orient = vertical location = outside title="Pearson Correlation";
			endlayout;
		endgraph;
	end;
run;

/* Prepare the correlations coeff matrix: Pearson's r method */
%macro prepCorrData(in=,out=);
	/* Run corr matrix for input data, all numeric vars */
	proc corr data=&in. noprint
		pearson
		outp=work._tmpCorr
		vardef=df
	;
	run;
proc print;run;
	/* prep data for heatmap */
data &out.;
	keep x y r;
	set work._tmpCorr(where=(_TYPE_="CORR"));
	array v{*} _numeric_;
	x = _NAME_;
	do i = dim(v) to 1 by -1;
		y = vname(v(i));
		r = v(i);
		/* creates a diagonally sparse matrix */
		if (i<_n_) then
			r=.;
		output;
	end;
run;

proc print;run;

proc datasets lib=work nolist nowarn;
	delete _tmpcorr;
quit;
%mend;

/* Build the graphs */
ods graphics /height=600 width=800 imagemap;

%prepCorrData(in=sashelp.cars,out=cars_r);
proc sgrender data=cars_r template=corrHeatmap;
   dynamic _title="Corr matrix for SASHELP.cars";
run;

%prepCorrData(in=sashelp.iris,out=iris_r);
proc sgrender data=iris_r template=corrHeatmap;
   dynamic _title= "Corr matrix for SASHELP.iris";
run;

/* example of dropping categorical numerics */
%prepCorrData(
  in=sashelp.pricedata(drop=region date product line),
  out=pricedata_r);
proc sgrender data=pricedata_r template=corrHeatmap;
  dynamic _title="Corr matrix for SASHELP.pricedata";
run;


