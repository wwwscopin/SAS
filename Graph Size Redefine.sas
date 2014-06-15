

Data E002;
	input log_result	Target	round;
cards;
80	89.215	31
76	89.215	31
78	89.215	31
80	89.215	31
83	89.215	31
82	89.215	31
177	199.139	31
180	199.139	31
176	199.139	31
182	199.139	31
179	199.139	31
183	199.139	31
418	437.149	31
420	437.149	31
438	437.149	31
432	437.149	31
420	437.149	31
430	437.149	31
12	12.758	31
10	12.758	31
11	12.758	31
12	12.758	31
10	12.758	31
12	12.758	31
178	184.99	32
180	184.99	32
175	184.99	32
176	184.99	32
180	184.99	32
182	184.99	32
220	242.623	32
225	242.623	32
227	242.623	32
225	242.623	32
228	242.623	32
230	242.623	32
14	12.057	32
15	12.057	32
16	12.057	32
15	12.057	32
14	12.057	32
16	12.057	32
84	88.952	32
82	88.952	32
85	88.952	32
85	88.952	32
85	88.952	32
87	88.952	32
23	34.021	33
21	34.021	33
25	34.021	33
24	34.021	33
22	34.021	33
23	34.021	33
47	64.03	33
45	64.03	33
48	64.03	33
50	64.03	33
48	64.03	33
46	64.03	33
302	358.919	33
306	358.919	33
310	358.919	33
313	358.919	33
304	358.919	33
308	358.919	33
110	136.918	33
113	136.918	33
117	136.918	33
115	136.918	33
112	136.918	33
114	136.918	33
;
run;


 /* Set the graphics environment */
goptions reset=all cback=white border;* htitle=12pt htext=10pt;  

 /* Create an annotate data set that draws a */
 /* reference line at a 45 degree angle.     */
data anno;
   function='move'; 
   xsys='1'; ysys='1'; 
   x=0; y=0; 
   output;

   function='draw'; 
   xsys='1'; ysys='1'; 
   color='black'; 
   size=2;*3;
   x=100; y=100; 
   output;
run;

   


ods _all_ close; 
ods listing;    
options nodate nonumber noxwait noxsync; 
filename output 'H:\temp\E002.png';
goptions reset=goptions device=png gsfname=output gsfmode=replace xmax=11 ymax=11;

legend across=1  
	   position=(bottom right inside) 
	   mode=protect  
	   fwidth=0.2 
 	   shape=symbol(2,2) 
       label=(f=Arial h=14pt position=top justify=center justify=center 'Round:')
 	   value=(f=Arial h=14pt)
	   repeat=1 
	   frame;



symbol1 v=circle h=1.5 w=2  c=red;*"magenta";
symbol2 v=circle h=1.5 w=2  c='vivid blue';*"orange";
symbol3 v=circle h=1.5 w=2 c=green;*"vivid blue";
*NB: for added clarity, might consider symbol values: circle, triangle, and square;

axis1  length=8.5in label=(a=90 f=Arial h=16pt "Lab Urine Iodine (µg/L)")
      value=(h=16pt)  
	  minor=none 
	  order=(0 to 600 by 100);

axis2  length=8.5in label=(f=Arial h=16pt "CDC Target Value (µg/L)")
      value=(h=16pt) 
	  minor=none 
	  order=(0 to 600 by 100);

proc gplot data=E002;
plot log_result*target=round/anno=anno 
							 haxis=axis2 
							 vaxis=axis1 
         					 legend=legend 
							 cframe=CXDEDDED;
run;
quit; 
*ODS RTF close; 

x 'h:\temp\e002.png'; 

data test;
	duration_mon=Intck('month',mdy(10,10,1973),today());
	duration_day=Intck('day',mdy(10,10,1973),today());
	day=duration_day/30.42;
run;
proc print;run;

proc gdevice c=sashelp.devices nofs;
list pscolor;
run;
quit;
