options pageno=1 nodate ls=80 ps=64;

data u1(keep=x);
      seed = 104;
      do i = 1 to 5;
            call ranuni(seed, x);
            output;
      end;
      call symputx('seed', seed);
run;

data u2(keep=x);
      seed = &seed;
      do i = 1 to 5;
            call ranuni(seed, x);
            output;
      end;
run;

data all;
      set u1 u2;
      z = ranuni(104);
run;

proc print label;
      label x = 'Separate Streams' z = 'Single Stream';
run;
