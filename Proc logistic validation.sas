data alldata train valid;
        input block entry lat lng n r @@;
        do i=1 to r;
          y=1;
          output alldata;
          if block<4 then output train; 
          else output valid;
        end;
        do i=1 to n-r;
          y=0;
          output alldata;
          if block<4 then output train; 
          else output valid;
        end;
        datalines;
        1 14 1 1  8 2    1 16 1 2  9 1
        1  7 1 3 13 9    1  6 1 4  9 9
        1 13 2 1  9 2    1 15 2 2 14 7
        1  8 2 3  8 6    1  5 2 4 11 8
        1 11 3 1 12 7    1 12 3 2 11 8
        1  2 3 3 10 8    1  3 3 4 12 5
        1 10 4 1  9 7    1  9 4 2 15 8
        1  4 4 3 19 6    1  1 4 4  8 7
        2 15 5 1 15 6    2  3 5 2 11 9
        2 10 5 3 12 5    2  2 5 4  9 9
        2 11 6 1 20 10   2  7 6 2 10 8
        2 14 6 3 12 4    2  6 6 4 10 7
        2  5 7 1  8 8    2 13 7 2  6 0
        2 12 7 3  9 2    2 16 7 4  9 0
        2  9 8 1 14 9    2  1 8 2 13 12
        2  8 8 3 12 3    2  4 8 4 14 7
        3  7 1 5  7 7    3 13 1 6  7 0
        3  8 1 7 13 3    3 14 1 8  9 0
        3  4 2 5 15 11   3 10 2 6  9 7
        3  3 2 7 15 11   3  9 2 8 13 5
        3  6 3 5 16 9    3  1 3 6  8 8
        3 15 3 7  7 0    3 12 3 8 12 8
        3 11 4 5  8 1    3 16 4 6 15 1
        3  5 4 7 12 7    3  2 4 8 16 12
        4  9 5 5 15 8    4  4 5 6 10 6
        4 12 5 7 13 5    4  1 5 8 15 9
        4 15 6 5 17 6    4  6 6 6  8 2
        4 14 6 7 12 5    4  7 6 8 15 8
        4 13 7 5 13 2    4  8 7 6 13 9
        4  3 7 7  9 9    4 10 7 8  6 6
        4  2 8 5 12 8    4 11 8 6  9 7
        4  5 8 7 11 10   4 16 8 8 15 7
      ;

ods graphics on;
proc logistic data=train;
	model y(event="1") = entry / outroc=troc;
    score data=valid out=valpred outroc=vroc;
    roc; roccontrast;
run;
proc contents data=valpred;run;

proc print data=preds(obs=100);run;

proc logistic data=valpred;
        model y(event="1")=;
        roc pred=p_1;
        roccontrast;
        run;
proc logistic data=train;
        model y(event="1") = entry;
        score data=valid out=valpred fitstat;
        run;
proc logistic data=alldata;
        model y(event="1") = entry;
        output out=preds predprobs=crossvalidate;
        run;
      proc logistic data=preds;
        model y(event="1") = entry;
        roc pred=xp_1;
        roccontrast;
        run;

