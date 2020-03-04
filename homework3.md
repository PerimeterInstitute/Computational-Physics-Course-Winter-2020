# Homework 3

Homework for the module **Hydrodynamics**

The homework is due on **Friday, March 20, 2020**, via email pointing
me to your git repository. The homework was designed by Will East,
please contact him or me if you have questions.

You will use the code to solve Burgers' equation, with the
modifications discussed in class to use a minmod slope limiter, and
Roe's method for calculating fluxes.

- By comparing the solution to the sine wave ID at some "early" time
  (i.e. before shocks form) computed with three different resolutions
  (i.e. number of cells), estimate the pointwise convergence order. Do
  this both for the original linear interpolation without slope
  limiting, and for the minmod slope limiter. Do you get second order
  convergence everywhere for both cases? Why or why not?

- Now compute the convergence order for a "later" time (i.e. after
  shocks form). You only need do this for the case with the slope
  limiter.

- (optional) Now we will try to fix the problem that minmod has at
  extrema by implementing a different slope limiter. Switch out the
  minmod reconstruction for WENO [1], or Extremum Preserving Van Leer
  [2], or some other reconstruction method that has higher order (>=2)
  convergence at extrema. Plot how this reconstructs the sine function
  ID. Again, check the convergence order before and after shock
  formation.

[1] See Jiang and Shu (1996) Journal Of Computational Physics 126,
202–228 (1996) or appendix A2 of https://arxiv.org/pdf/0704.2608.pdf

[2] See Sec 2.1 of https://arxiv.org/pdf/0903.4200.pdf
