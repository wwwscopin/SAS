proc iml;
/* For an explanation of how to construct an iterated function system in SAS, see
   http://blogs.sas.com/content/iml/2012/12/12/iterated-function-systems-and-barnsleys-fern-in-sas/
*/
/* Each row is a 2x2 linear transformation */
/* Christmas tree */
L = {0.03  0     0    0.1,
     0.85  0.00  0.00 0.85,
     0.8   0.00  0.00 0.8,
     0.2  -0.08  0.15 0.22,
    -0.2   0.08  0.15 0.22,
     0.25 -0.1   0.12 0.25,
    -0.2   0.1   0.12 0.2};
/* ... and each row is a translation vector */
B = {0 0,
     0 1.5,
     0 1.5,
     0 0.85,
     0 0.85,
     0 0.3,
     0 0.4 };
prob = { 0.02 0.6 0.1 0.07 0.07 0.07 0.07};
L = L`; B = B`; /* For convenience, transpose the L and B matrices */
 
/* Iterate the discrete stochastic map */
N = 1e5;          /* number of iterations */
x = j(2,N); k = j(N,1);
x[,1] = {0, 2};   /* initial point */
call randgen(k, "Table", prob); /* values 1-7 */
 
do i = 2 to N;
   x[,i] = shape(L[,k[i]], 2)*x[,i-1] + B[,k[i]]; /* iterate */
end;
 
/* Plot the iteration history */
y = x`;
create IFS from y[c={"x" "y"}]; append from y; close IFS;
quit;
 
/* basic IFS Christmas Tree */
ods graphics / width=200px height=400px;
proc sgplot data=IFS;
  title "SAS Christmas Tree";
  scatter x=x y=y / markerattrs=(size=1 color=ForestGreen);
  yaxis display=none;
  xaxis display=none;
run;
