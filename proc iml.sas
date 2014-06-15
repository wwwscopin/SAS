proc iml;
call randseed(1234);           /* set random number seed             */
x = j(1000, 1);                /* allocate space for 1,000 draws     */
p = {0.5 0.2 0.3};             /* probabilities of each category     */
call randgen(x, "Table", p);   /* fill vector with values 1, 2, or 3 */
/* compute and print empirical distribution of values */
call tabulate(category, freq, x);
print (freq/sum(freq ))[c={"Black" "Red" "White"}];
quit;
