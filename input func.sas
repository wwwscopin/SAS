 proc format;
      value readdate 1='date7.'
                     2='mmddyy8.';
   run;

   options yearcutoff=1920;

   data fixdates /*(drop=start dateinformat)*/;
      length jobdesc $12;
      input source id lname $ jobdesc $ start $;
      dateinformat=put(source, readdate.);
      newdate = inputn(start, dateinformat);
      datalines;
   1 1604 Ziminski writer 09aug90
   1 2010 Clavell editor 26jan95
   2 1833 Rivera writer 10/25/92
   2 2222 Barnes proofreader 3/26/98
   ;

   proc print;run;

      proc format;
      value typefmt 1='$groupx' 
                    2='$groupy'
                    3='$groupz';
      invalue $groupx 'positive'='agree'
                      'negative'='disagree'
                      'neutral'='notsure';
      invalue $groupy 'positive'='accept'
                      'negative'='reject'
                      'neutral'='possible';

      invalue $groupz 'positive'='pass'
                      'negative'='fail'
                      'neutral'='retest';
   run;

   data answers;
      input type response $;
      respinformat = put(type, typefmt.);
      word = inputc(response, respinformat);
      datalines;
   1 positive
   1 negative
   1 neutral
   2 positive
   2 negative
   2 neutral
   3 positive
   3 negative
   3 neutral
   ;
