options nodate nonumber;
  ods listing close;

  ods escapechar="^";

  ods rtf file="rtffuncs.rtf";
  title "Examples of Functions";
  title2 'Example of ^{nbspace 3} Non-Breaking Spaces Function';
  title3 'Example of ^{newline 2} Newline Function';
  title4 'Example of ^{raw \cf12 RAW} RAW function';
  title5 'Example of ^{unicode 03B1} UNICODE function';
  title6 "Example ^{style [foreground=red] of ^{super ^{unicode ALPHA}
         ^{style [foreground=green] Nested}} Formatting} and Scoping";
  title7 "Example of ^{super
         ^{style [foreground=red] red
         ^{style [foreground=green] green } and
         ^{style [foreground=blue] blue}}} formatting";

  proc print data=sashelp.class(obs=4); run;

  ods _all_ close;
  ods listing;
