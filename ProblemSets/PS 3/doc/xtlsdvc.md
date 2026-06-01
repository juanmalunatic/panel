# Estimation and inference in dynamic unbalanced panel-data models with a small number of individuals


The Stata Journal
Editor                                                    Editor
H. Joseph Newton                                          Nicholas J. Cox
Department of Statistics                                  Geography Department
Texas A & M University                                    Durham University
College Station, Texas 77843                              South Road
979-845-3142; FAX 979-845-3144                            Durham City DH1 3LE UK
jnewton@stata-journal.com                                 n.j.cox@stata-journal.com

Associate Editors
Christopher Baum                                          Stanley Lemeshow
Boston College                                             Ohio State University
Rino Bellocco                                             J. Scott Long
Karolinska Institutet                                      Indiana University
David Clayton                                             Thomas Lumley
Cambridge Inst. for Medical Research                       University of Washington, Seattle
Mario A. Cleves                                           Roger Newson
Univ. of Arkansas for Medical Sciences                     King’s College, London
William D. Dupont                                         Marcello Pagano
Vanderbilt University                                      Harvard School of Public Health
Charles Franklin                                          Sophia Rabe-Hesketh
University of Wisconsin, Madison                           University of California, Berkeley
Joanne M. Garrett                                         J. Patrick Royston
University of North Carolina                               MRC Clinical Trials Unit, London
Allan Gregory                                             Philip Ryan
Queen’s University                                         University of Adelaide
James Hardin                                              Mark E. Schaffer
University of South Carolina                               Heriot-Watt University, Edinburgh
Ben Jann                                                  Jeroen Weesie
ETH Zurich, Switzerland                                    Utrecht University
Stephen Jenkins                                           Nicholas J. G. Winter
University of Essex                                        Cornell University
Ulrich Kohler                                             Jeffrey Wooldridge
WZB, Berlin                                                Michigan State University
Jens Lauritsen
Odense University Hospital

Stata Press Production Manager                            Lisa Gilmore
Stata Press Copy Editors                                  Gabe Waggoner, John Williams

Copyright Statement: The Stata Journal and the contents of the supporting files (programs, datasets, and
help files) are copyright c by StataCorp LP. The contents of the supporting files (programs, datasets, and
help files) may be copied or reproduced by any means whatsoever, in whole or in part, as long as any copy
or reproduction includes attribution to both (1) the author and (2) the Stata Journal.

The articles appearing in the Stata Journal may be copied or reproduced as printed copies, in whole or in part,
as long as any copy or reproduction includes attribution to both (1) the author and (2) the Stata Journal.

Written permission must be obtained from StataCorp if you wish to make electronic copies of the insertions.
This precludes placing electronic copies of the Stata Journal, in whole or in part, on publicly accessible web
sites, fileservers, or other locations where the copy may be accessed by anyone other than the subscriber.

Users of any of the software, ideas, data, or other materials published in the Stata Journal or the supporting
files understand that such use is made without warranty of any kind, by either the Stata Journal, the author,
or StataCorp. In particular, there is no warranty of fitness of purpose or merchantability, nor for special,
incidental, or consequential damages such as loss of profits. The purpose of the Stata Journal is to promote
free communication among Stata users.

The Stata Journal, electronic version (ISSN 1536-8734) is a publication of Stata Press, and Stata is a registered
trademark of StataCorp LP.

The Stata Journal (2005) 5, Number 4, pp. 473-500

Estimation and inference in dynamic
unbalanced panel-data models with a small
              number of individuals
                                Giovanni S. F. Bruno
               Istituto di Economia Politica, Bocconi University, Milan

## Abstract


**Abstract.** This article describes a new Stata routine, xtlsdvc, that computes bias-corrected least-squares dummy variable (LSDV) estimators and their boot- strap variance-covariance matrix for dynamic (possibly) unbalanced panel-data models with strictly exogenous regressors. A Monte Carlo analysis is carried out to evaluate the finite-sample performance of the bias-corrected LSDV estimators in comparison to the original LSDV estimator and three popular N -consistent estima- tors: Arellano-Bond, Anderson-Hsiao and Blundell-Bond. Results strongly sup- port the bias-corrected LSDV estimators according to bias and root mean squared error criteria when the number of individuals is small. Keywords: st0091, xtlsdvc, bias approximation, unbalanced panels, dynamic panel data, LSDV estimator, Monte Carlo experiment, bootstrap variance-covariance

1    Introduction
Situations in which past decisions have an impact on current behavior are ubiquitous
in economics. To mention just one of the most familiar cases, in the presence of em-
ployment adjustment costs, the short-run labor demand of the firm will depend on
past employment levels. Another crucial issue in empirical economics, strictly related
to the modeling of dynamic relationships, is the presence of unobserved heterogeneity
in individual behavior and characteristics. Panel datasets, where the behavior of N
cross-sectional units is observed over T time periods, provide a solution to accommo-
dating the joint occurrence of dynamics and unobserved individual heterogeneity in the
phenomena of interest.
Since the seminal paper by Nickell (1981), where it is shown that the least-squares
dummy variable (LSDV) estimator is not consistent for finite T in autoregressive panel-
data models, a number of consistent instrumental variable (IV) and generalized method
of moments (GMM) estimators have been proposed in the econometric literature as an
alternative to LSDV. Anderson and Hsiao (1982) (AH) suggest two simple IV estima-
tors that, upon transforming the model in first differences to eliminate the unobserved
individual heterogeneity, use the second lags of the dependent variable, either differ-
enced or in levels, as an instrument for the differenced one-time lagged dependent vari-
able. Arellano and Bond (1991) (AB) propose a GMM estimator for the first-differenced
model, which, relying on a greater number of internal instruments, is more efficient
than AH. Blundell and Bond (1998) (BB) observe that with highly persistent data, first-

c 2005 StataCorp LP                                                                   st0091

differenced IV or GMM estimators may suffer of a severe small-sample bias due to weak
instruments. As a solution, they suggest a system GMM estimator with first-differenced
instruments for the equation in levels and instrument in levels for the first-differenced
equation.
A weakness of IV and GMM estimators is that their properties hold when N is
large, so they can be severely biased and imprecise in panel data with a small num-
ber of cross-sectional units. This is often the case in most macro panels, but also in
micro panels where heterogeneity concerns force the researcher not to use all informa-
tion available, but rather to select a subsample of individuals from the original panel
to estimate the parameters of interest. On the other hand, earlier Monte Carlo stud-
ies (Arellano and Bond 1991; Kiviet 1995; Judson and Owen 1999) demonstrate that
LSDV, although inconsistent, has a relatively small variance compared to IV and GMM
estimators.
Moving from the foregoing considerations, an alternative approach based upon the
bias-correction of LSDV in dynamic panel-data models with strictly exogenous regressors
has recently become popular in the econometric literature. Nickell (1981) derives an
expression for the inconsistency of LSDV for N → +∞, which is bounded on the order
T -1 . Kiviet (1995) uses higher-order asymptotic expansion techniques to approximate
the small sample bias of the LSDV estimator to include terms of at most order N -1 T -1 .
The approximations terms, however, all evaluated at the unobserved true parameter
values, are of no direct use for estimation, so to make them operational, he suggests re-
placing the true parameters with the estimates from some consistent estimators. Monte
Carlo evidence therein shows that the resulting bias-corrected LSDV estimator (LSDVC)
often outperforms the IV - GMM estimators in terms of bias and root mean squared error
(RMSE). Another piece of Monte Carlo evidence by Judson and Owen (1999) strongly
supports LSDVC when N is small as in most macro panels. In Kiviet (1999), the bias
expression is more accurate to include terms of at most order N -1 T -2 . Bun and Kiviet
(2003), upon simplifying the approximations in Kiviet (1999), carry out Monte Carlo
experiments showing that the first-order term of the approximation evaluated at the
true parameter values is already capable to account for more than 90% of the actual
bias.
None of the foregoing procedures to correct the LSDV estimator is feasible for unbal-
anced panels. This gap is partly filled in Bruno (2005), where the bias approximations in
Bun and Kiviet (2003) are extended to accommodate unbalanced panels with a strictly
exogenous selection rule. Monte Carlo evidence therein parallels that in Bun and Kiviet
(2003).
This paper presents a new Stata program, xtlsdvc, which implements LSDVC build-
ing upon the theoretical approximation formulas in Bruno (2005) and estimates a boot-
strap variance covariance matrix for the corrected estimator. Moreover, the relative
performance of LSDVC is evaluated in comparison to LSDV, AB, AH, and BB for unbal-
anced panels with a small N (10 and 20 units) through various Monte Carlo experiments,
thus extending the analysis by Judson and Owen (1999).

Monte Carlo results in this paper show that the three versions of LSDVC computed
by xtlsdvc outperform all other estimators tried in terms of bias and RMSE. From
this scenario, LSDVC clearly emerges as the preferred estimator for dynamic panel-
data models with small N and strictly exogenous regressors. That said, practitioners
should not forget an important limitation of the procedure: as opposed to IV - GMM
estimators, in fact, no version of LSDVC is applicable in the presence of endogenous, or
even only weakly exogenous, regressors. The results by Bun and Kiviet (2005) on the
finite sample properties of LSDV and GMM estimators with weakly exogenous regressors,
however, seem promising in the view of a general bias-correction procedure.
The paper is laid out as follows. The next section briefly reviews the theoretical
results for corrected LSDV estimators. Section 3 describes the xtlsdvc routine. Section 4
contains the Monte Carlo analysis, and section 5 concludes the article. A demonstration
of the code in the context of labor demand estimation is offered into an appendix.

## 2     Bias-corrected LSDV estimators I consider the standard dynamic panel-data model

$$
yit = \gammayi,t-1 + x0it \beta + \etai + it ; |\gamma| < 1; i = 1, . . . , N and t = 1, . . . , T         (1)
$$

```text
where yit is the dependent variable, xit is the {(k - 1) × 1} vector of strictly exogenous
explanatory variables, ηi is an unobserved individual effect, and it is an unobserved
white-noise disturbance with constant variance σ2 .1 Collecting observations over time
and across individuals gives
                                   y = Dη + W δ + 
                         .
where y and W = (y-1 ..X) are the (N T × 1) and (N T × k) matrices of stacked ob-
servations; D = IN ⊗ ιT is the (N T × N ) matrix of individual dummies (ιT is the
(T × 1) vector of all unity elements); η is the (N × 1) vector of individual effects;  is
                                                  .
the (N T × 1) vector of disturbances; and δ = (γ ..β 0 )0 is the (k × 1) vector of coefficients.
    It has been long recognized that the LSDV estimator for (1) is not consistent for
finite T . Nickell
                  (1981) derives an expression for the inconsistency for N → +∞, which
is O T -1 . Kiviet (1995) obtains a bias approximation that contains terms of higher
order than T -1 . In Kiviet (1999), a more accurate bias approximation is derived.
Bun and Kiviet (2003) reformulate the approximation in Kiviet (1999) with simpler
formulas for each term.
    Bruno (2005) extends Bun and Kiviet’s (2003) formulas to unbalanced panels with
a strictly exogenous selection rule. A more general version of (1) is considered, which
allows missing observations in the interval [0, T ] for some individuals. Below I briefly
present the approximation formulas for (possibly) unbalanced data as derived in Bruno
(2005) and show their use to obtain LSDVC.
 1. The bias-correction procedures of this paper can be applied to heteroskedastic cases after successful
weighting of variables, although this may be admittedly difficult in practice.
```

Define a selection indicator rit such that rit = 1 if (yit , xit ) is observed and rit = 0
otherwise. From this, define the dynamic selection rule s (rit , ri,t-1 ), selecting only
the observations that are usable for the dynamic model, namely, those for which both
current values and one-time lagged values are observable:
                 
                    1 if (ri,t , ri,t-1 ) = (1, 1)
           sit =                                   i = 1, . . . , N and t = 1, . . . , T
                    0         otherwise
                                                                        PT
Thus for any i, the number of usable observations is given by Ti =         t=1 sit . The
                                                      PN
total number of usable observations is given by n = i=1 Ti ; and T = n/N denotes
                                                                                     0
the average group size. For each i, define the (T × 1)-vector si = [si1 . . . , siT ] and
the (T × T ) diagonal matrix Si having the vector si on its diagonal. Define also the
(N T × N T ) block-diagonal matrix S = diag (Si ). The (possibly) unbalanced dynamic
model can then be written as

$$
Sy = SD\eta + SW \delta + S                                  (2)
$$

$$
The LSDV estimator is given by
                                                     -1
                               \deltaLSDV = (W 0 Ms W )        W 0 Ms y
$$

$$
where                              n                 o
                                                  -1
                             Ms = S I - D (D 0 SD) D0 S
$$

is the symmetric and idempotent (N T × N T ) matrix, wiping out individual means and
selecting usable observations.
Bias-approximation terms for unbalanced panels are the following:
                                     -1 
                                 c1 T      = σ2 tr (Π) q1                               (3)

$$
       -1
                                  n  0
                                                   0
                                                          
            c2 N -1 T        = -\sigma2 QW \PiMs W + tr QW \PiMs W Ik+1 +
                                   2\sigma2 q11 tr (\Pi0 \Pi\Pi) Ik+1 q1
$$

       -2
                                      h       0
                                                          n    0
                                                                         
          c3 N -1 T        = σ4 tr (Π) 2q11 QW ΠΠ0 W q1 + q10 W ΠΠ0 W q1 +
                                         0
                                                                 o i
                                                                2
                             q11 tr QW ΠΠ0 W + 2tr (Π0 ΠΠ0 Π) q11  q1
                                       n 0                            o-1
                              -1
where Q = {E (W 0 Ms W )}          =    W Ms W + σ2 tr (Π0 Π) e1 e01     ; W = E (W ); e1 =
             0
(1, 0, . . . , 0) is a (k × 1) vector; q1 = Qe1 ; q11 = e01 q1 ; LT is the (T × T ) matrix
with unit first lower subdiagonal and all other elements equal to zero; L = I N ⊗ LT ;
                      -1
ΓT = (IT - γLT ) ; Γ = IN ⊗ ΓT ; and Π = Ms LΓ. Clearly, in any balanced design S ≡
                               -1
IN T , so Ms = I -D (D 0 D) D0 , and the above terms reduce to those in Bun and Kiviet
(2003).

```text
   With an increasing level of accuracy, the following three possible bias approximations
emerge:
                 -1                            -1
                                                                           -2
                                                                                
        B1 = c 1 T      ; B2 = B1 + c2 N -1 T          ; B3 = B2 + c3 N -1 T          (4)
```

In principle, bias-corrected LSDV estimators could be obtained by subtracting any of the
above terms from LSDV. In practice, however, depending upon the unknown parameters
σ2 and γ, approximations (4) are not feasible for bias correction. Nevertheless, consis-
tent bias-corrected estimators can be obtained by finding consistent estimators for σ 2
and γ, plugging them into the bias-approximations formulas, and then subtracting the
resulting bias approximation estimates, Bbi , from LSDV as follows:
                                         bi , i = 1, 2, and 3
                         LSDVCi = LSDV - B                                             (5)
Possible consistent estimators for γ are AH, AB, or BB, for example. Depending on the
estimator of choice for γ, say h, a consistent estimator for σ2 is then given by
                                             e0h Ms eh
                                   bh2 =
                                   σ                                                   (6)
                                           (N - k - T )
where eh = y - W δh , and h = AH, AB, and BB.

3     The xtlsdvc program
3.1    Syntax
The Stata program xtlsdvc written by the author calculates LSDVC for (1) using esti-
mates for the bias approximations in (4). The basic syntax of xtlsdvc is the following:

xtlsdvc depvar indepvars       if , initial(estimator) level(#) bias(#)

vcov(#) first lsdv

The routine automatically includes the lagged dependent variable as an explanatory
variable and can fit the simple autoregressive model with no covariates.

3.2    Options
initial(estimator) is required and specifies the consistent estimator chosen to initialize
the bias correction.
estimator   description
ah          AH estimator, with the dependent variable lagged two times,
                  used as an instrument for the first-differenced model with no
                  intercept ([R] ivreg)
ab          standard one-step AB estimator with no intercept ([XT] xtabond)
bb          standard BB estimator with no intercept, as implemented by the
                  user-written Stata routine xtabond2 by Roodman (2003)
my          a row vector of initial values supplied directly by the user

To implement the last instance of this option, the user must create a {1 × (k + 1)}
matrix to be named my, the ith element of which serves as an initial value for the
coefficient on the ith variable in varlist and the last, (k +1)th, element as an estimate
for the error variance. This may be useful in Monte Carlo simulations or if the user
wishes to try initial estimators other than ah, ab, or bb.
level(#) specifies the confidence level, as a percentage, for confidence intervals of
the coefficients. The default is level(95) or as set by set level; see [U] 20.6
Specifying the width of confidence intervals.
bias(#) determines the accuracy of the approximation: # = 1 (default) forces an
approximation up to O(1/T ); # = 2 forces an approximation up to O(1/N T );
# = 3 forces an approximation up to O(N -1 T -2 ).
vcov(#) calculates a bootstrap variance-covariance matrix for LSDVC using # repeti-
tions (# may not equal 1). The default is no bootstrap estimation of the variance-
covariance matrix and standard errors. Notice that the bootstrap continues to work
in the presence of gaps in the exogenous variables, although in this case, bootstrap
samples for each unit are truncated to the first missing value encountered. Gaps
in the dependent variable, instead, bear no consequence to the bootstrap sample
size. This is explained in more detail in section 3.5. Also consider that bootstrap
standard errors are downward biased when values for the unknown parameters are
supplied through matrix my since the procedure in this case (keeping the values in
my fixed over replications) neglects a source of variability for LSDVC.
first requests that the first-stage regression results be displayed.
lsdv requests that the original LSDV regression results be displayed.

To work out the approximations, xtlsdvc invokes the subroutine xtlsdvc 1 that
accomplishes the following tasks. First, xtlsdvc 1 obtains the uncorrected LSDV esti-
mates via a call to xtreg . . . , fe ([XT] xtreg).
Second, xtlsdvc 1 obtains initial estimates for γ and β through one of the following
instructions, depending on which estimator is specified in initial:

$$
if "‘initial’"=="ah" ivreg D.y D.x (LD.y=L2.y), noconstant
      if "‘initial’"=="ab" xtabond y x, noconstant
      if "‘initial’"=="bb" xtabond2 y L.y x, gmm(L.y) iv(x) noconstant
$$

bh2 , h = AH, AB, and BB, is computed as in (6).
Then σ
Finally, xtlsdvc 1 computes the bias approximations via the Stata matrix com-
mands ([P] matrix) and corrects the LSDV estimates as indicated in (5).

3.3     Saved results
xtlsdvc saves in e():
Scalars
e(N)                 number of observations                  e(sigma)          estimates of σ from the
e(Tbar)              average number of time                                      first-stage regression
                           periods                               e(N g)            number of groups
Macros
e(cmd)                xtlsdvc                                 e(depvar)         name of dependent variable
e(ivar)               panel variable                          e(predict)        program used to implement
                                                                                     predict
Matrices
e(b)                  xtlsdvc estimates                       e(V)              variance-covariance matrix of
e(b lsdv)             xtreg, fe estimates                                         the xtlsdvc estimator
e(V lsdv)             variance-covariance matrix
                           of the xtreg, fe estimator
Functions
e(sample)             marks estimation sample

It is worth noting that the square root of the error variance estimate (6), saved in
e(sigma), uses residuals in levels computed via the first-stage coefficient estimates. As
such, it need not coincide with the RMSE reported by Stata in the first-stage regression
output, when AH is the chosen initialization, which is instead computed through first-
differenced residuals. For the same reason, the squared value of e(sigma) does not
coincide with the value of e(sig2) saved by xtabond when AB initializes xtlsdvc.

3.4     Syntax for predict
As with all Stata estimation commands, xtlsdvc supports the postestimation command
predict ([R] predict) to compute fitted values and residuals. The syntax for predict
following xtlsdvc is

predict           type       newvarname        if         in         , statistic

where
statistic          description
xb                 byi,t-1 + x0it β,
                         γ                b fitted values; the default
ue                 ηbi + bit , the combined residuals
∗
        xbu              byi,t-1 + x0it βb + ηbi , prediction, including fixed effect
                         γ
∗
        u                ηbi , the fixed effect
∗
        e                b
                         it , the observation-specific error component

Unstarred statistics are available both in and out of sample; type predict . . . if
e(sample) . . . if wanted only for the estimation sample. Starred statistics are cal-
culated only for the estimation sample, even when if e(sample) is not specified.

3.5    The bootstrap variance-covariance matrix
Kiviet and Bun (2001) show that LSDVC, however initialized, is asymptotically nor-
mal and derive the analytical expression for the asymptotic variance-covariance matrix
of LSDVC in the version initialized by AH. Monte Carlo simulations therein, however,
demonstrate that the analytical variance estimator performs poorly for a large γ, per-
haps because of the unstable behavior of AH (documented also by the Monte Carlo
analysis of this paper, see section 4). Alternatively, Kiviet and Bun (2001) suggest a
parametric bootstrap procedure to estimate the asymptotic variance-covariance matrix
of LSDVC, which seems superior to the analytical expression for at least three reasons:
(1) it is simpler; (2) it always turns out to be relatively accurate; and (3) it can be ap-
plied to any version of LSDVC. Thus xtlsdvc adapts Kiviet and Bun’s (2001) bootstrap
procedure for use with unbalanced panels, as described below.
A first difficulty here is brought about by the dependency in the data implied by
the autoregressive data generation process (DGP), which does not permit us to adopt
any of the official Stata bootstrap instructions, bootstrap and bsample. A parametric
bootstrap is instead followed, which upon maintaining a normal distribution for the
disturbances takes full account of the dependency in the DGP.
The subroutine xtlsdvc b is called in xtlsdvc by the option vcov(). It is designed
to yield a bootstrap sample and bootstrap LSDVC estimates and is iterated for vcov(#)
times by xtlsdvc.
Let us focus on the generic iteration (*) of xtlsdvc b. It basically goes through the
steps below.

1. Upon obtaining LSDVC estimates γ    b and βb and σ b2 from xtlsdvc 1, it calculates
                                                       b · y -1 - βb · x, where y, y -1 , and x
the N -vector of fixed-effect estimates ηb = y - γ
indicate N -vectors of group means.
                                                                  
2. It obtains bootstrap errors (∗) as a draw from N 0, σ    b2 .
                                                                              (∗)               (∗)
3. Given x, S and y0 , it obtains a bootstrap sample from sit yit                = sit (b
                                                                                           γ · yi,t-1
                         (∗)
+βb · xit + ηbi +  ), i = 1, . . . , N and t = 1, . . . , T .
                        it
                                      
                                                b(∗) and βb(∗) .
4. It applies LSDVC to y (∗) , S, x to yield γ

While computational aspects of steps 1 and 2 are straightforward and step 4 only
requires a call to xtlsdvc 1 to calculate the corrected estimates from the generated
bootstrap sample, step 3 is instructive and deserves some explanation. One possible way
to implement step 3 would be to “manually” generate y (∗) by recursion as a function of
(∗) , y0 and x. But this is both computationally cumbersome and unnecessary in Stata.
In fact, one can exploit the ability of replace ([D] generate) to work sequentially 2 to
obtain y (∗) in an effortless way:
2. I learned this by reading the messages by N. J. Cox and D. Kantor to Statalist on May 25, 2004,
in response to a question of D. V. Masterov.

```text
      . by ivar: gen obs= n
      . replace y= GAMMA*L.y + BETA*x +THETA +EPSILON if obs>1.
```

Unbalancedness without gaps does not cause any trouble here, since different start-
up dates can be dealt with very easily by the time-series operators in Stata. The
presence of gaps, instead, may cause specific difficulty if they are found in any of the
independent variables x’s, regardless of the way step 3 is implemented. In fact, since the
recursion process generates y (∗) from (y0 , S, x) , it must stop at the first missing value
encountered in the x’s so that eventually a shorter sample is created at each replication.
This decreases the accuracy of the estimates or even breaks down the identification of
some coefficients in the shorter bootstrap sample and, consequently, of their standard
errors. For example, if for all individuals there is a gap for a given time period, the
coefficients on the time dummies corresponding and subsequent to the missing period
would not be identified in each bootstrap sample so that their bootstrap standard errors
could not be computed, too. To the opposite, gaps in the dependent variable are clearly
immaterial for the size of the bootstrap samples since only the start-up values of y are
used in the recursion process.
A simulate call ([R] simulate) in xtlsdvc replicates xtlsdvc b for vcov(#) times,
yielding a dataset of bootstrap LSDVC estimates δb∗ , of dimension (vcov × k). Hence,
xtlsdvc gets the bootstrap variance-covariance matrix V

δb∗0 δb∗
                                     V =
                                           (vcov - 1)
via matrix accum ([P] matrix).
The bootstrap variance-covariance matrix V is then used to construct asymptotic
t-ratio tests of parameter significance, as described in Kiviet and Bun (2001).
Attention should be paid when supplying the initial values through the matrix my.
In this case, in fact, the bootstrap procedure would not be reliable since keeping the
values in my fixed over replications neglects a source of variability for LSDVC so that the
resulting bootstrap standard errors may be severely downward biased.
Finally, users should be warned that the bootstrap procedure may require a consid-
erable amount of time. This tends to increase linearly with the number of replications.
Also the procedure seems slightly faster if LSDVC is initialized by AH. Examples are
given in the appendix.

4    Monte Carlo experiments
The Monte Carlo analyses in Kiviet (1995), Kiviet and Bun (2001), and especially,
Judson and Owen (1999) provide support for LSDVC in balanced panels, compared to the
traditional IV and GMM estimators. Moreover, Monte Carlo results in Bun and Kiviet
(2003) for balanced panels and in Bruno (2005) for unbalanced panels demonstrate that
the bias approximations (4), evaluated at the true γ and σ2 , account for a significant

portion of the bias, never less than 90% and often virtually 100%. The relative merit
of LSDVC in unbalanced panels is still to be explored, though. This is exactly what
is accomplished here, where I evaluate the three versions of LSDVC as implemented
by my code in a Monte Carlo study that extends Judson and Owen’s (1999) under
four respects. First, I evaluate LSDVC in the presence of various unbalanced designs;
second, the performance of LSDVC is examined for the three different levels of accuracy;
third, initial observations for the simulated data are generated following the procedure
in McLeod and Hipel (1978), also adopted in Kiviet (1995) and Bruno (2005), which
avoids wasting random numbers and small-sample nonstationary problems; finally, the
comparison is extended to BB.
Data for yit are generated by (1) with k = 2 and for xit by
                                                
            xit = ρxi,t-1 + ξit , ξit ∼ N 0, σξ2 , i = 1, . . . , N and t = 1, . . . , T.

Initial observations yi0 and xi0 generated through the McLeod and Hipel (1978) pro-
cedure are kept fixed across replications. The long-run coefficient β/ (1 - γ) is kept
fixed to unity, so β = 1 - γ; σ2 is normalized to unity; γ and ρ alternate between
                                                                                  0.2
and 0.8. The individual effects ηi are generated by assuming that ηi ∼ N 0, ση2 and
ση = σ (1 - γ).
                                                                           
Two different sample sizes are considered: N, T = (20, 20) and N, T = (10, 40).
Then following Baltagi and Chang (1995), I control for nthe extent of unbalancedness
                                                                         o
                                                             PN
as measured by the Ahrens and Pincus index: ω = N/ T i=1 (1/Ti ) (0 < ω ≤ 1,
ω = 1 when the panel is balanced). For each sample size, I analyze a case of mild
unbalancedness (ω = 0.96) and a case of severe unbalancedness (ω = 0.36). Individuals
are partitioned into two sets of equal dimension: one set contains the first N/2 individ-
uals, each with the last h observations discarded, so Ti = T - h; the other contains the
remaining N/2 individuals, each with Ti = T . I set T and h so that T and ω take on
the desired values (the four panel designs are summarized in table 1).

Table 1: Unbalanced designs

```text
                       N     T     T     Ti                            ω
                       20    20    24    16 (i ≤ 10), 24 (i > 10)      0.96
                                   36    4 (i ≤ 10), 36 (i > 10)       0.36
                       10    40    48    32 (i ≤ 5), 48 (i > 5)        0.96
                                   72    8 (i ≤ 5), 72 (i > 5)         0.36
```

The simple AH estimator is the one chosen to initialize the correction procedure,
based on the finding by Kiviet and Bun (2001) that differences in the initial estimators
have only a marginal impact on the LSDVC performance. Then the LSDVC estimator is
calculated for each of the three levels of accuracy in the estimated bias approximations.

4.1    Results
Results for γ are presented in figures 1 to 4, while results for β are presented in figures
5 to 8. In each figure, the first graph is for T = 20 and the second for T = 40. The
bias and the RMSE are measured on the vertical axis, while the points on the horizontal
axis always correspond to the eight possible combinations for γ, ρ, and ω. Since BB is
specifically designed for highly persistent series, comparisons involving this estimator
are restricted to γ = 0.8.
As a first general comment on the Monte Carlo results, I observe that according
to a bias criterion, the three versions of LSDVC and, interestingly, AH have the best
performances for both γ and β, with virtually zero bias in several cases. Turning to a
RMSE criterion, the LSDVC estimators maintain the best performance, while AH shows
the worst RMSE levels, also in comparison to LSDV, AB and, for highly persistent series,
BB. This evidence highlights LSDVC as the preferred estimator for dynamic panel-data
models with small N and strictly exogenous regressors, in line with that obtained by
Kiviet (1995), Judson and Owen (1999), and Kiviet and Bun (2001) in similar Monte
Carlo analyses.
That said, some interesting patterns seem to emerge when the behavior of each
estimator is examined in more depth.

Estimating γ: bias

LSDVC3 tends to perform slightly better than the other two LSDVC versions, especially
when T and γ increases. When γ = 0.8 and ρ = 0.8, however, all LSDVC estimators are
slightly worse than AH (see figure 1).
After noting that the bias of LSDV and AB is always negative, confirming the findings
by earlier studies (Kiviet and Bun 2001; Bond 2002; Bun and Kiviet 2003; Bruno 2005),
I observe that LSDVC, LSDV, and AB estimators show similar patterns with respect to
the degree of unbalancedness and average group size. As already shown in Bruno (2005)
for LSDV, the biases of such estimators are decreasing in ω. This, always for AB and
LSDV and often for LSDVC, brings with it an increase in the bias magnitude. When
T = 20, the AB estimator performs better than the LSDV estimator if ω is low but
worse than the LSDV estimator when ω is high. When T increases, however, besides
observing an expected general tendency towards a smaller bias magnitude, I also notice
an attenuation of the ω effect for all foregoing estimators. The bias of AH, instead, is
always positive and increasing in ω, implying each time a worsening of the bias when
unbalancedness reduces. The bias of BB is always positive and expected to be the
largest in magnitude with lowly persistent series, but it dramatically improves when
the persistence in y and x increases, reaching lower magnitudes than AB and LSDV
when T = 20 and comparable to AB and LSDV when T = 40 (see figure 2).

Estimating γ: RMSE

The RMSE of the LSDVC estimators are almost coincident and always the smallest.
On the other hand, AH almost always presents the highest RMSE, which hinders the
attractiveness of such estimator in empirical work, despite its simplicity and good bias
performance (see figure 3).
Except for BB, the RMSE for all estimators is increasing in γ and ρ, with the increase
being especially large for AH. There is no apparent trend in the RMSE for BB. Similar to
the previously discussed bias results, the RMSEs of the LSDVC, AB, and LSDV estimators
are all increasing as the panel becomes closer to balanced. Again this effect is partic-
ularly strong for AB and when T = 20. BB has a satisfactory RMSE in the presence of
highly persistent series, performing generally better than AB and LSDV. In particular,
when T = 40 and ω = 0.96, its RMSE gets very close to that of the LSDVC estimators
(see figure 4).
The RMSE results for γ are summarized in table 2 (γ = 0.2) and table 3 (γ = 0.8),
indicating for each case, the preferred estimator and its second best alternative.

Table 2: RMSE performance when γ = 0.2

```text
                 ω\T      20                            40
                 0.36     1. LSDVC                      1. LSDVC
                          2. AB (and LSDV if ρ = 0.2)   2. AB and LSDV
                 0.96     1. LSDVC                      1. LSDVC
                          2. LSDV                       2. AB and LSDV
```

Table 3: RMSE performance when γ = 0.8

```text
                        ω\T    20         40
                        0.36   1. LSDVC   1. LSDVC
                               2. BB      2. AB (and BB if ρ = 0.8)
                        0.96   1. LSDVC   1. LSDVC and BB
                               2. BB      2. LSDV
```

Estimating β: bias

LSDVC estimators and AH continue to show the best bias performance. While for ρ = 0.2
AB and LSDV also exhibit a negligible bias magnitude, for ρ = 0.8 their bias magnitude
dramatically increases. With small T , I notice a relatively bad performance of BB. When
T = 40 and ω = 0.36, however, the bias attains acceptable levels and worsens when the
degree of unbalancedness decreases (see figures 5 and 6).

Estimating β: RMSE

Results here parallel that evidenced for γ, with two differences: 1) There seems to be
no clear role for the degree of unbalancedness. For example, when T = 20, the RMSE
of the LSDVC estimators benefits from a decreased unbalancedness, but when T = 40
exactly the opposite occurs. 2) The RMSE for BB is now markedly increasing in ρ (see
figures 7 and 8).
The documented evidence for a favorable impact of unbalancedness on bias and
RMSE values in the estimation of γ, which is apparently surprising, can be explained by
the fact that under investigation here is a notion of pure unbalancedness, not involving
either gaps or any loss in degrees of freedom and average group size. Although more
theoretical work, accompanied by broader Monte Carlo experiments, is needed to reach
conclusive results on this issue, there is still a simple lesson to be learned from my Monte
Carlo analysis; that is, smoothing unbalancedness at the cost of fewer time observations
for the largest groups may be detrimental for estimation performance in dynamic panel-
data models, especially if the average group size is small.

5    Conclusion
This paper has presented the new Stata code xtlsdvc implementing LSDVC estimators
for dynamic (possibly) unbalanced panel-data models with a small N and strictly ex-
ogenous covariates. The procedure is based upon the bias approximations derived in
Bruno (2005), who extends the result by Kiviet (1999) and Bun and Kiviet (2003) to
unbalanced panels. The code also computes the bootstrap variance-covariance matrix
of the estimators.
Monte Carlo experiments highlight the LSDVC estimators as the preferred ones in
comparison to the original LSDV and widely used IV and GMM consistent estimators.
Future improvements of the code will enlarge the class of initial estimators, allowing
more flexibility in defining the instrument set for the IV and GMM estimators.

6    Acknowledgments
I am grateful to an anonymous referee of this journal for helpful suggestions improving
the presentation of the paper. I also benefited from useful discussions with Orietta Dessy
and participants at the 10th UK Stata Users Group meeting, London 2004, and the 1st
Italian Stata Users Group meeting, Rome 2004. Last but not least, I am grateful to all
the Stata users who tested the xtlsdvc routine. In particular, Carl-Oskar Lindgren,
Ivan Marinovic, and Clive Nicholas found bugs and provided helpful comments and
suggestions. All remaining errors are my own. Financial support from Bocconi Ricerca
di Base “Labor Demand, Production and Globalization” is gratefully acknowledged.

7     References
Anderson, T. W. and C. Hsiao. 1982. Formulation and estimation of dynamic models
using panel data. Journal of Econometrics 18: 570-606.
Arellano, M. and S. Bond. 1991. Some tests of specification for panel data: Monte Carlo
evidence and an application to employment equations. Review of Economic Studies
58: 277-297.
Baltagi, B. H. and Y. J. Chang. 1995. Incomplete panels. Journal of Econometrics 62:
67-89.
Blundell, R. and S. Bond. 1998. Initial conditions and moment restrictions in dynamic
panel data models. Journal of Econometrics 87: 115-143.
Bond, S. 2002. Dynamic panel data models: A guide to micro data methods and
practice. Cemmap Working Paper CWP09/02.
Bruno, G. S. F. 2005. Approximating the bias of the LSDV estimator for dynamic
unbalanced panel data models. Economics Letters 87: 361-366.
Bun, M. J. G. and J. F. Kiviet. 2003. On the diminishing returns of higher order terms
in asymptotic expansions of bias. Economics Letters 79: 145-152.
---. 2005. The effects of dynamic feedbacks on LS and MM estimator accuracy in
panel data models. Journal of Econometrics. Forthcoming.
Judson, R. A. and A. L. Owen. 1999. Estimating dynamic panel data models: a guide
for macroeconomists. Economics Letters 65: 9-15.
Kiviet, J. F. 1995. On bias, inconsistency, and efficiency of various estimators in dynamic
panel data models. Journal of Econometrics 68: 53-78.
---. 1999. Expectation of expansions for estimators in a dynamic panel data model;
some results for weakly exogenous regressors. In Analysis of Panels and Limited
Dependent Variable Models, ed. C. Hsiao, K. Lahiri, L.-F. Lee, and M. H. Pesaran,
199-225. Cambridge: Cambridge University Press.
Kiviet, J. F. and M. J. G. Bun. 2001. The accuracy of inference in small samples of
dynamic panel data models. Tinbergen Institute Discussion Paper TI 2001-006/4.
McLeod, A. I. and K. W. Hipel. 1978. Simulation procedures for Box-Jenkins models.
Water Resources Research 14: 969-975.
Nickell, S. J. 1981. Biases in dynamic models with fixed effects. Econometrica 49:
1417-1426.
Roodman, D. M. 2003. XTABOND2: Stata module to extend xtabond dynamic panel-
data estimator. Statistical Software Components S435901, Boston College Depart-
ment of Economics.

8    Appendix: Demonstrating xtlsdvc
I demonstrate the use of xtlsdvc in the context of labor demand estimation using the
dataset abdata.dta (Arellano and Bond 1991), a typical micro panel of firm data with
a moderately large N (140 firms). The labor demand of the firm is modeled according
to specification (1), with the natural log of firm employment, n, as the dependent
variable; the natural log of the real product wage, w; the natural log of the gross capital
stock, k; and a set of time dummies as explanatory variables. The log of employment
lagged one time is also included as a right-hand-side variable to allow costly employment
adjustments.
Unlike in the customary approach, I do not use all information available to estimate
the regression parameters. Instead, I follow a strategy that, exploiting the industry
partition of the cross-sectional dimension as defined by the categorical variable ind, lets
the slopes be industry-specific. This is easily accomplished by restricting the usable
data to the panel of firms belonging to a given industry. While such a strategy leads
to a less restrictive specification for the firm labor demand, it causes a reduced number
of cross-sectional units for use in estimation so that the researcher must be prepared
to deal with a potentially severe small-sample bias in any of the industry regressions.
Clearly, xtlsdvc is the appropriate solution in this case.
The demonstration is kept as simple as possible by considering regressions for only
one industry panel (ind=4).
Comparing two different initializations, AH and AB, I am able to confirm the feature
found by Kiviet and Bun (2001) that differences in the initial estimators have only a
marginal impact on the LSDVC estimates. Indeed, in this example, the evidence for
the AB initialization is mixed. On the one hand, the one-step Sargan statistic suggests
that the overidentifying restrictions used by AB are not satisfied. On the other hand,
the second-order autocorrelation test does not reject the required lack of second-order
autocorrelation in the differenced residuals. Be that as it may, the AB initialization
has only negligible consequences on the resulting LSDVC estimates, as it clearly emerges
upon comparing the latter with the LSDVC estimates initialized by AH.
The routine is reasonably fast when the bootstrap procedure is not invoked. Oth-
erwise, the waiting time may be considerable, linearly increasing in the number of
repetitions. To give you an idea of this, a message at the end of each execution displays
the amount of time consumed by the code.

```text
      . use abdata, clear
      . * Data description for industry 4
      . xtdes if ind==4
            id:  16, 18, ..., 133                                   n =         29
          year:  1976, 1977, ..., 1984                              T =          9
                 Delta(year) = 1; (1984-1976)+1 = 9
                 (id*year uniquely identifies each observation)
      Distribution of T_i:   min       5%    25%       50%        75%     95%     max
                               7        7      7         7          7       8       9
```

Freq.     Percent      Cum.      Pattern

```text
             18         62.07    62.07      1111111..
              8         27.59    89.66      .1111111.
              1          3.45    93.10      ..1111111
              1          3.45    96.55      .11111111
              1          3.45   100.00      111111111
```

```text
             29     100.00           XXXXXXXXX
      . set rmsg on
      r; t=0.00 11:03:17
      . * LSDVC initialized by AH.
      . * Level 1 of accuracy.
      . * AH and (uncorrected) LSDV estimates are also displayed.
      . xtlsdvc n w k yr1977-yr1984 if ind==4, initial(ah) lsdv first
      Note: Bias correction initialized by Anderson and Hsiao estimator
      Instrumental variables (2SLS) regression
            Source              SS         df         MS                Number of obs =        148
                                                                        F( 10,    138) =         .
             Model       1.35967485       10    .135967485              Prob > F       =         .
          Residual       .933924166      138    .006767566              R-squared      =         .
                                                                        Adj R-squared =          .
             Total       2.29359902      148    .015497291              Root MSE       =    .08227
```

D.n           Coef.    Std. Err.         t    P>|t|      [95% Conf. Interval]

n
               LD.         .2204939      .4445225        0.50   0.621      -.658462        1.09945
                 w
               D1.        -.3771841       .134876       -2.80   0.006      -.643875   -.1104933
                 k
               D1.         .2204505      .0979079        2.25   0.026      .0268569    .4140442
            yr1977
               D1.          .147631       .149344        0.99   0.325     -.1476674    .4429295
            yr1978
               D1.         .1207165      .1386943        0.87   0.386     -.1535242    .3949572
            yr1979
               D1.         .0977037      .1471064        0.66   0.508     -.1931704    .3885778
            yr1980
               D1.         .0410339      .1448524        0.28   0.777     -.2453833    .3274512
            yr1981
               D1.        -.0683895       .128972       -0.53   0.597     -.3234063    .1866273
            yr1982
               D1.        -.1163022      .0788384       -1.48   0.142     -.2721896    .0395852
            yr1983
               D1.        -.0512528      .0581115       -0.88   0.379     -.1661569    .0636513
            yr1984
               D1.        (dropped)

```text
      Instrumented:     LD.n
      Instruments:      D.w D.k D.yr1977 D.yr1978 D.yr1979 D.yr1980 D.yr1981
                        D.yr1982 D.yr1983 D.yr1984 L2.n
```

```text
      note: yr1984 dropped due to collinearity
            in the LSDV regression
      LSDV dynamic regression
```

n       Coef.   Std. Err.         z       P>|z|    [95% Conf. Interval]

```text
                n
              L1.     .4056509   .0731424        5.55      0.000    .2622945    .5490074
                w    -.3541811   .1315442       -2.69      0.007    -.612003   -.0963593
                k     .2541555   .0525718        4.83      0.000    .1511167    .3571944
           yr1977     .0571224   .0614743        0.93      0.353    -.063365    .1776098
           yr1978     .0460914   .0619696        0.74      0.457   -.0753668    .1675497
           yr1979     .0147851   .0631942        0.23      0.815   -.1090733    .1386434
           yr1980    -.0403662   .0633203       -0.64      0.524   -.1644718    .0837394
           yr1981    -.1352945   .0620761       -2.18      0.029   -.2569615   -.0136275
           yr1982    -.1547943   .0570565       -2.71      0.007    -.266623   -.0429656
           yr1983    -.1019097   .0592481       -1.72      0.085   -.2180339    .0142145
```

```text
     note: Bias correction up to order O(1/T)
     LSDVC dynamic regression
     (SE not computed)
```

n       Coef.   Std. Err.         z       P>|z|    [95% Conf. Interval]

```text
                n
              L1.     .5389829          .              .       .           .           .
                w    -.3375203          .              .       .           .           .
                k     .2218794          .              .       .           .           .
           yr1977      .030273          .              .       .           .           .
           yr1978     .0263007          .              .       .           .           .
           yr1979     -.005644          .              .       .           .           .
           yr1980    -.0604044          .              .       .           .           .
           yr1981    -.1508947          .              .       .           .           .
           yr1982    -.1562805          .              .       .           .           .
           yr1983    -.0928311          .              .       .           .           .
```

```text
     r; t=0.41 11:03:18
     . * Level 2 of accuracy.
     . xtlsdvc n w k yr1977-yr1984 if ind==4, initial(ah) bias(2)
     Bias correction initialized by Anderson and Hsiao estimator
     note: yr1984 dropped due to collinearity
           in the LSDV regression
     note: Bias correction up to order O(1/NT)
     LSDVC dynamic regression
     (SE not computed)
```

n       Coef.   Std. Err.         z       P>|z|    [95% Conf. Interval]

```text
                n
              L1.     .5354691          .              .       .           .           .
                w    -.3380943          .              .       .           .           .
                k     .2226967          .              .       .           .           .
           yr1977     .0310655          .              .       .           .           .
           yr1978     .0269198          .              .       .           .           .
           yr1979    -.0050068          .              .       .           .           .
           yr1980    -.0597784          .              .       .           .           .
           yr1981    -.1503907          .              .       .           .           .
           yr1982    -.1561434          .              .       .           .           .
           yr1983     -.092829          .              .       .           .           .
```

```text
      r; t=0.39 11:03:18
      . * Level 3 of accuracy
      . xtlsdvc n w k yr1977-yr1984 if ind==4, initial(ah) bias(3)
      Bias correction initialized by Anderson and Hsiao estimator
      note: yr1984 dropped due to collinearity
            in the LSDV regression
      note: Bias correction up to order O(1/NT^2)
      LSDVC dynamic regression
      (SE not computed)
```

n         Coef.   Std. Err.        z       P>|z|    [95% Conf. Interval]

```text
                 n
               L1.     .6338054           .             .       .           .           .
                 w    -.3258186           .             .       .           .           .
                 k     .1988694           .             .       .           .           .
            yr1977     .0112892           .             .       .           .           .
            yr1978     .0123501           .             .       .           .           .
            yr1979    -.0200475           .             .       .           .           .
            yr1980    -.0745312           .             .       .           .           .
            yr1981    -.1618727           .             .       .           .           .
            yr1982    -.1572177           .             .       .           .           .
            yr1983    -.0861093           .             .       .           .           .
```

```text
      r; t=0.39 11:03:18
      . * LSDVC (level 3 of accuracy) initialized by AH, plus bootstrap SE
      . * 100 replications
      . xtlsdvc n w k yr1977-yr1984 if ind==4, initial(ah) bias(3) vcov(100)
      Bias correction initialized by Anderson and Hsiao estimator
      note: yr1984 dropped due to collinearity
            in the LSDV regression
      note: Bias correction up to order O(1/NT^2)
      LSDVC dynamic regression
      (bootstrapped SE)
```

n         Coef.   Std. Err.        z       P>|z|    [95% Conf. Interval]

```text
                 n
               L1.     .6338054    .2384333      2.66       0.008    .1664848    1.101126
                 w    -.3258186    .1624866     -2.01       0.045   -.6442865   -.0073507
                 k     .1988694    .0652599      3.05       0.002    .0709623    .3267765
            yr1977     .0112892    .0908366      0.12       0.901   -.1667472    .1893257
            yr1978     .0123501    .0928353      0.13       0.894   -.1696038     .194304
            yr1979    -.0200475    .0956793     -0.21       0.834   -.2075756    .1674805
            yr1980    -.0745312    .0988459     -0.75       0.451   -.2682655    .1192032
            yr1981    -.1618727    .0885033     -1.83       0.067    -.335336    .0115906
            yr1982    -.1572177    .0651537     -2.41       0.016   -.2849166   -.0295188
            yr1983    -.0861093    .0703664     -1.22       0.221    -.224025    .0518064
```

```text
      r; t=38.47 11:03:57
      . * 200 replications
      . xtlsdvc n w k yr1977-yr1984 if ind==4, initial(ah) bias(3) vcov(200)
      Bias correction initialized by Anderson and Hsiao estimator
      note: yr1984 dropped due to collinearity
            in the LSDV regression
      note: Bias correction up to order O(1/NT^2)
      LSDVC dynamic regression
```

(bootstrapped SE)

n          Coef.   Std. Err.       z    P>|z|    [95% Conf. Interval]

```text
                n
              L1.        .6338054   .2366395     2.68    0.007    .1700005        1.09761
                w       -.3258186   .1740695    -1.87    0.061   -.6669885       .0153514
                k        .1988694    .082856     2.40    0.016    .0364747       .3612641
           yr1977        .0112892    .091363     0.12    0.902   -.1677789       .1903574
           yr1978        .0123501   .0935808     0.13    0.895   -.1710649       .1957652
           yr1979       -.0200475     .09732    -0.21    0.837   -.2107912       .1706962
           yr1980       -.0745312   .0977652    -0.76    0.446   -.2661475       .1170852
           yr1981       -.1618727    .088817    -1.82    0.068    -.335951       .0122055
           yr1982       -.1572177   .0666269    -2.36    0.018   -.2878041      -.0266313
           yr1983       -.0861093   .0714245    -1.21    0.228   -.2260987         .05388
```

```text
     r; t=76.44 11:05:13
     . * LSDVC (level 3 of accuracy) initialized by AB,
     . * plus bootstrap SE (100 replications).
     . * AB estimates are also displayed.
     . xtlsdvc n w k yr1977-yr1984 if ind==4, initial(ab) first bias(3) vcov(100)
     Note: Bias correction initialized by Arellano and Bond estimator
     note: yr1977 dropped due to collinearity
     Arellano-Bond dynamic panel-data estimation     Number of obs      =       148
     Group variable (i): id                          Number of groups   =         29
                                                         Wald chi2(.)       =           .
     Time variable (t): year                             Obs per group: min =           5
                                                                        avg =    5.103448
                                                                        max =           7
     One-step results
```

D.n           Coef.   Std. Err.       z    P>|z|    [95% Conf. Interval]

```text
                n
              LD.        .2721012   .0875276      3.11   0.002    .1005503       .4436521
                w
              D1.       -.4926766   .1138765     -4.33   0.000   -.7158704      -.2694828
                k
              D1.        .2026031   .0527761      3.84   0.000    .0991637       .3060424
           yr1978
              D1.       -.0219591   .0198588     -1.11   0.269   -.0608816       .0169633
           yr1979
              D1.       -.0509516   .0202053     -2.52   0.012   -.0905533        -.01135
           yr1980
              D1.       -.1080377   .0204241     -5.29   0.000   -.1480682      -.0680073
           yr1981
              D1.       -.2176279   .0214474    -10.15   0.000   -.2596641      -.1755918
           yr1982
              D1.       -.2527341   .0260614     -9.70   0.000   -.3038136      -.2016546
           yr1983
              D1.       -.1992322   .0387691     -5.14   0.000   -.2752182      -.1232462
           yr1984
              D1.       -.0629971   .0509664     -1.24   0.216   -.1628893       .0368952
```

```text
     Sargan test of over-identifying restrictions:
              chi2(27) =    81.60      Prob > chi2 = 0.0000
     Arellano-Bond test that average autocovariance in residuals of order 1 is 0:
              H0: no autocorrelation   z = -1.09    Pr > z = 0.2748
```

$$
Arellano-Bond test that average autocovariance in residuals of order 2 is 0:
               H0: no autocorrelation   z = -1.25    Pr > z = 0.2129
$$

```text
      note: yr1984 dropped due to collinearity
            in the LSDV regression
      note: Bias correction up to order O(1/NT^2)
      LSDVC dynamic regression
      (bootstrapped SE)
```

n          Coef.     Std. Err.       z    P>|z|    [95% Conf. Interval]

```text
                 n
               L1.     .6360273       .0912651      6.97   0.000    .4571509    .8149037
                 w    -.3256377        .143472     -2.27   0.023   -.6068377   -.0444377
                 k     .1988754       .0537594      3.70   0.000    .0935089     .304242
            yr1977     .0080108       .0625058      0.13   0.898   -.1144982    .1305199
            yr1978     .0097372       .0659415      0.15   0.883   -.1195059    .1389802
            yr1979    -.0238944       .0678355     -0.35   0.725   -.1568495    .1090607
            yr1980    -.0778375       .0684853     -1.14   0.256   -.2120662    .0563912
            yr1981    -.1649284       .0675663     -2.44   0.015   -.2973559    -.032501
            yr1982    -.1599435       .0592059     -2.70   0.007   -.2759848   -.0439021
            yr1983     -.088907       .0644108     -1.38   0.167   -.2151498    .0373357
```

```text
      r; t=43.81 11:05:57
      . set rmsg off
```

```text
                                                                                             (0
                                                                                                .2,
                                                                                                                                                                                                   (0
                                                                                                                                                                                                     .2
                                                                                                                                                                                                                                                                   9
                                                                                                      0.                                          bias                                                  ,0                            bias
                                                                                                        2,                                                                                                .2
                                                                                                           0.          -.015               -.01   -.005   0   .005                                           ,0
                                                                                                                                                                                                               .3      -.015   -.01   -.005   0   .005
                                                                                                                36
                                                                                                                   )                                                                                              6)
                                                                                                                                                                                                                                                                                       G. S. F. Bruno
```

```text
                                                                                             (0                                                                                                    (0
                                                                                                .2,                                                                                                  .2
                                                                                                      0.                                                                                                ,0
                                                                                                        2,                                                                                                .2
                                                                                                           0.                                                                                                ,0
                                                                                                                96                                                                                             .9
                                                                                                                   )                                                                                              6)
                                                                                             (0                                                                                                    (0
                                                                                                .2,                                                                                                  .2
```

lsdvc_3
                                                                                                                                 lsdvc_1
                                                                                                      0.                                                                                                ,0
                                                                                                        8,                                                                                                .8
                                                                                                           0.                                                                                                ,0
                                                                                                                36                                                                                             .3
                                                                                                                   )                                                                                              6)
                                                                                                                                                                                                                                                                   Appendix: Figures

```text
                                                                                             (0                                                                                                    (0
                                                                                                .2,                                                                                                  .2
                                                                                                      0.                                                                                                ,0
                                                                                                        8,                                                                                                .8
                                                                                                           0.                                                                                                ,0
                                                                                                                96                                                                                             .9
```

```text
                                                                                                                       ah
                                                                                                                   )                                                                                              6)
                                                                                             (0                                                                                                    (0
                                                                                                .                                                                                                    .8
```

lsdvc_2
                                                                                                 8,                                                                                                     ,0
                                                                                                      0.                                                                                                  .2
                                                                                                        2,                                                                                                   ,0
                                                                                                           0.                                                                                                  .3

Tbar=40
                                                                                                                                                                                                                                                         Tbar=20

36
                                                                                                                   )                                                                                              6)
                                                                                             (0                                                                                                    (0

```text
                                                                         Parameter designs
                                                                                                                                                                               Parameter designs
                                                                                                .8,                                                                                                  .8
                                                                                                      0.                                                                                                ,0
                                                                                                        2,                                                                                                .2
                                                                                                           0.                                                                                                ,0
                                                                                                                96                                                                                             .9
                                                                                                                   )                                                                                              6)
                                                                                             (0                                                                                                    (0
                                                                                                .8,                                                                                                  .8
                                                                                                      0.                                                                                                ,0
                                                                                                        8,                                                                                                .8
                                                                                                           0.                                                                                                ,0
                                                                                                                36                                                                                             .3
                                                                                                                   )                                                                                              6)
                                                                                             (0                                                                                                    (0
                                                                                                .8,                                                                                                  .8
                                                                                                      0.                                                                                                ,0
                                                                                                        8,                                                                                                .8
                                                                                                                                                                                                             ,0
```

Figure 1: Biases of LSDVC1 , LSDVC2 , LSDVC3 , and AH for γ (γ, ρ, ω).
                                                                                                           0.                                                                                                  .9
                                                                                                                96
                                                                                                                   )                                                                                              6)
                                                                                                                                                                                                                                                                                       493

**Descripción de la figura.** La figura compara el sesgo de $LSDVC_1$, $LSDVC_2$, $LSDVC_3$ y Anderson-Hsiao para el parámetro $\gamma$ bajo ocho diseños de parámetros $(\gamma,\rho,\omega)$. Muestra dos paneles, $\bar T=20$ y $\bar T=40$. Su función es ilustrar visualmente que las versiones corregidas de LSDV mantienen sesgos pequeños, mientras que AH puede moverse de forma distinta según persistencia y grado de desbalance.

494

```text
                                                                          (0                                                                                                      (0
                                                                             .   2,                                                                                                 .2
                                                                                   0.                                              bias                                                ,0                          bias
                                                                                      2,                                                                                                 .2
                                                                                           0. -.15                -.1              -.05   0   .05                                           ,0
                                                                                                                                                                                              .3      -.15   -.1   -.05   0   .05
                                                                                             36
                                                                                                )                                                                                                6)
                                                                          (0                                                                                                      (0
                                                                             .   2,                                                                                                 .2
                                                                                   0.                                                                                                  ,0
                                                                                      2,                                                                                                 .2
                                                                                           0.                                                                                               ,0
                                                                                              96                                                                                              .9
                                                                                                 )                                                                                               6)
```

```text
                                                                                                     bb
                                                                                                          ab
                                                                          (0                                                                                                      (0
                                                                             .   2,                                                                                                 .2
```

```text
                                                                                                               lsdvc_3
                                                                                                                         lsdvc_1
                                                                                   0.                                                                                                  ,0
                                                                                      8,                                                                                                 .8
                                                                                           0.                                                                                               ,0
                                                                                              36                                                                                              .3
                                                                                                 )                                                                                               6)
                                                                          (0                                                                                                      (0
                                                                             .   2,                                                                                                 .2
                                                                                   0.                                                                                                  ,0
                                                                                      8,                                                                                                 .8
                                                                                           0.                                                                                               ,0
                                                                                              96                                                                                              .9
```

ah
                                                                                                 )                                                                                               6)

```text
                                                                                                               lsdv
                                                                          (0                                                                                                      (0
                                                                             .                                                                                                      .8
```

lsdvc_2
                                                                                 8,                                                                                                    ,0
                                                                                   0.                                                                                                    .2
                                                                                      2,                                                                                                    ,0
                                                                                           0.                                                                                                 .3

Tbar=40
                                                                                                                                                                                                                                    Tbar=20

36
                                                                                                 )                                                                                               6)
                                                                          (0                                                                                                      (0

```text
                                                      Parameter designs
                                                                                                                                                              Parameter designs
                                                                             .   8,                                                                                                 .8
                                                                                   0.                                                                                                  ,0
                                                                                      2,                                                                                                 .2
                                                                                           0.                                                                                               ,0
                                                                                              96                                                                                              .9
                                                                                                 )                                                                                               6)
                                                                          (0                                                                                                      (0
                                                                             .   8,                                                                                                 .8
                                                                                   0.                                                                                                  ,0
                                                                                                                                                                                         .8
```

```text
Figure 2: Biases of all estimators for γ (γ, ρ, ω).
                                                                                      8,                                                                                                    ,0
                                                                                           0.                                                                                                 .3
                                                                                              36
                                                                                                 )                                                                                               6)
                                                                          (0                                                                                                      (0
                                                                             .   8,                                                                                                 .8
                                                                                   0.                                                                                                  ,0
                                                                                      8,                                                                                                 .8
                                                                                           0.                                                                                               ,0
                                                                                              96                                                                                              .9
                                                                                                 )                                                                                               6)
                                                                                                                                                                                                                                              Dynamic unbalanced panel-data models
```

```text
                                                                                            (0                                                                                            (0
                                                                                              .2                                                                                            .2
                                                                                                ,0                         rmse                                                                ,0                         rmse
                                                                                                  .2                                                                                             .2
                                                                                                     ,0
                                                                                                       .3      .03   .04          .05                .06                                            ,0
                                                                                                                                                                                                      .3      .03   .04          .05   .06
                                                                                                          6)                                                                                             6)
                                                                                                                                                                                                                                                       G. S. F. Bruno
```

```text
                                                                                            (0                                                                                            (0
                                                                                              .2                                                                                            .2
                                                                                                ,0                                                                                             ,0
                                                                                                  .2                                                                                             .2
                                                                                                     ,0                                                                                             ,0
                                                                                                       .9                                                                                             .9
                                                                                                          6)                                                                                             6)
                                                                                            (0                                                                                            (0
                                                                                              .2                                                                                            .2
```

```text
                                                                                                                                        lsdvc_3
                                                                                                                                                  lsdvc_1
                                                                                                ,0                                                                                             ,0
                                                                                                  .8                                                                                             .8
                                                                                                     ,0                                                                                             ,0
                                                                                                       .3                                                                                             .3
                                                                                                          6)                                                                                             6)
                                                                                            (0                                                                                            (0
                                                                                              .2                                                                                            .2
                                                                                                ,0                                                                                             ,0
                                                                                                  .8                                                                                             .8
                                                                                                     ,0                                                                                             ,0
                                                                                                       .9                                                                                             .9
```

```text
                                                                                                                                        bb
                                                                                                          6)                                                                                             6)
                                                                                            (0                                                                                            (0
                                                                                              .8                                                                                            .8
```

```text
                                                                                                                                                  lsdvc_2
                                                                                                ,0                                                                                             ,0
                                                                                                  .2                                                                                             .2
                                                                                                     ,0                                                                                             ,0
                                                                                                       .3                                                                                             .3
```

Tbar=40
                                                                                                                                                                                                                                             Tbar=20

6)                                                                                             6)
                                                                                            (0                                                                                            (0

```text
                                                                        Parameter designs
                                                                                                                                                                      Parameter designs
                                                                                              .8                                                                                            .8
                                                                                                ,0                                                                                             ,0
                                                                                                  .2                                                                                             .2
                                                                                                     ,0                                                                                             ,0
                                                                                                       .9                                                                                             .9
                                                                                                          6)                                                                                             6)
                                                                                            (0                                                                                            (0
                                                                                              .8                                                                                            .8
                                                                                                ,0                                                                                             ,0
                                                                                                  .8                                                                                             .8
                                                                                                     ,0                                                                                             ,0
                                                                                                       .3                                                                                             .3
                                                                                                          6)                                                                                             6)
                                                                                            (0                                                                                            (0
                                                                                              .8                                                                                            .8
                                                                                                ,0                                                                                             ,0
                                                                                                  .8                                                                                             .8
                                                                                                     ,0                                                                                             ,0
```

```text
Figure 3: RMSEs of LSDVC1 , LSDVC2 , LSDVC3 , and BB for γ (γ, ρ, ω).
                                                                                                       .9                                                                                             .9
                                                                                                          6)                                                                                             6)
                                                                                                                                                                                                                                                       495
```

496

```text
                                                                         (0                                                                                         (0
                                                                           .2                                                                                         .2
                                                                             ,0                       rmse                                                               ,0                       rmse
                                                                               .2                                                                                          .2
                                                                                  ,0
                                                                                    .3      0   .05          .1                .15                                            ,0
                                                                                                                                                                                .3      0   .05          .1   .15
                                                                                       6)                                                                                          6)
                                                                         (0                                                                                         (0
                                                                           .2                                                                                         .2
                                                                             ,0                                                                                          ,0
                                                                               .2                                                                                          .2
                                                                                  ,0                                                                                          ,0
                                                                                    .9                                                                                          .9
                                                                                       6)                                                                                          6)
```

```text
                                                                                                                  bb
                                                                                                                       ab
                                                                         (0                                                                                         (0
                                                                           .2                                                                                         .2
```

```text
                                                                                                                            lsdvc_3
                                                                             ,0                                                                                          ,0
                                                                               .8                                                                                          .8
                                                                                  ,0                                                                                          ,0
                                                                                    .3                                                                                          .3
                                                                                       6)                                                                                          6)
                                                                         (0                                                                                         (0
                                                                           .2                                                                                         .2
                                                                             ,0                                                                                          ,0
                                                                               .8                                                                                          .8
                                                                                  ,0                                                                                          ,0
                                                                                    .9                                                                                          .9
```

ah
                                                                                       6)                                                                                          6)

```text
                                                                                                                            lsdv
                                                                         (0                                                                                         (0
                                                                           .8                                                                                         .8
                                                                             ,0                                                                                          ,0
                                                                               .2                                                                                          .2
                                                                                  ,0                                                                                          ,0
                                                                                    .3                                                                                          .3
```

Tbar=40
                                                                                                                                                                                                                    Tbar=20

6)                                                                                          6)
                                                                         (0                                                                                         (0

```text
                                                     Parameter designs
                                                                                                                                                Parameter designs
                                                                           .8                                                                                         .8
                                                                             ,0                                                                                          ,0
                                                                               .2                                                                                          .2
                                                                                  ,0                                                                                          ,0
                                                                                    .9                                                                                          .9
                                                                                       6)                                                                                          6)
                                                                         (0                                                                                         (0
                                                                           .8                                                                                         .8
                                                                             ,0                                                                                          ,0
                                                                               .8                                                                                          .8
```

```text
Figure 4: RMSEs of all estimators for γ (γ, ρ, ω).
                                                                                  ,0                                                                                          ,0
                                                                                    .3                                                                                          .3
                                                                                       6)                                                                                          6)
                                                                         (0                                                                                         (0
                                                                           .8                                                                                         .8
                                                                             ,0                                                                                          ,0
                                                                               .8                                                                                          .8
                                                                                  ,0                                                                                          ,0
                                                                                    .9                                                                                          .9
                                                                                       6)                                                                                          6)
                                                                                                                                                                                                                              Dynamic unbalanced panel-data models
```

```text
                                                                                             (0                                                                                             (0
                                                                                               .2                                                                                             .2
                                                                                                 ,0                                       bias                                                   ,0                    bias
                                                                                                   .2                                                                                              .2
                                                                                                      ,0
                                                                                                        .3      -.005                 0          .005   .01                                           ,0
                                                                                                                                                                                                        .3 -.005   0          .005   .01
                                                                                                           6)                                                                                             6)
                                                                                                                                                                                                                                                     G. S. F. Bruno
```

```text
                                                                                             (0                                                                                             (0
                                                                                               .2                                                                                             .2
                                                                                                 ,0                                                                                              ,0
                                                                                                   .2                                                                                              .2
                                                                                                      ,0                                                                                              ,0
                                                                                                        .9                                                                                              .9
                                                                                                           6)                                                                                              6)
                                                                                             (0                                                                                             (0
                                                                                               .2                                                                                             .2
```

```text
                                                                                                                  lsdvc_3
                                                                                                                            lsdvc_1
                                                                                                 ,0                                                                                              ,0
                                                                                                   .8                                                                                              .8
                                                                                                      ,0                                                                                              ,0
                                                                                                        .3                                                                                              .3
                                                                                                           6)                                                                                              6)
                                                                                             (0                                                                                             (0
                                                                                               .2                                                                                             .2
                                                                                                 ,0                                                                                              ,0
                                                                                                   .8                                                                                              .8
                                                                                                      ,0                                                                                              ,0
                                                                                                        .9                                                                                              .9
```

```text
                                                                                                                  ah
                                                                                                           6)                                                                                              6)
                                                                                             (0                                                                                             (0
                                                                                               .8                                                                                             .8
```

```text
                                                                                                                            lsdvc_2
                                                                                                 ,0                                                                                              ,0
                                                                                                   .2                                                                                              .2
                                                                                                      ,0                                                                                              ,0
                                                                                                        .3                                                                                              .3
```

Tbar=40
                                                                                                                                                                                                                                           Tbar=20

6)                                                                                              6)
                                                                                             (0                                                                                             (0

```text
                                                                         Parameter designs
                                                                                                                                                                        Parameter designs
                                                                                               .8                                                                                             .8
                                                                                                 ,0                                                                                              ,0
                                                                                                   .2                                                                                              .2
                                                                                                      ,0                                                                                              ,0
                                                                                                        .9                                                                                              .9
                                                                                                           6)                                                                                              6)
                                                                                             (0                                                                                             (0
                                                                                               .8                                                                                             .8
                                                                                                 ,0                                                                                              ,0
                                                                                                   .8                                                                                              .8
                                                                                                      ,0                                                                                              ,0
                                                                                                        .3                                                                                              .3
                                                                                                           6)                                                                                              6)
                                                                                             (0                                                                                             (0
                                                                                               .8                                                                                             .8
                                                                                                 ,0                                                                                              ,0
                                                                                                   .8                                                                                              .8
                                                                                                      ,0                                                                                              ,0
```

```text
Figure 5: Biases of LSDVC1 , LSDVC2 , LSDVC3 , and AH for β (γ, ρ, ω).
                                                                                                        .9                                                                                              .9
                                                                                                           6)                                                                                              6)
                                                                                                                                                                                                                                                     497
```

498

```text
                                                                          (0                                                                                               (0
                                                                            .2                                                                                               .2
                                                                              ,0                                            bias                                                ,0                          bias
                                                                                .2                                                                                                .2
                                                                                   ,0
                                                                                     .3      -.1                   -.05            0   .05                                           ,0
                                                                                                                                                                                       .3      -.1   -.05          0   .05
                                                                                        6)                                                                                                6)
                                                                          (0                                                                                               (0
                                                                            .2                                                                                               .2
                                                                              ,0                                                                                                ,0
                                                                                .2                                                                                                .2
                                                                                   ,0                                                                                                ,0
                                                                                     .9                                                                                                .9
                                                                                        6)                                                                                                6)
```

```text
                                                                                              bb
                                                                                                   ab
                                                                          (0                                                                                               (0
                                                                            .2                                                                                               .2
```

```text
                                                                                                        lsdvc_3
                                                                                                                  lsdvc_1
                                                                              ,0                                                                                                ,0
                                                                                .8                                                                                                .8
                                                                                   ,0                                                                                                ,0
                                                                                     .3                                                                                                .3
                                                                                        6)                                                                                                6)
                                                                          (0                                                                                               (0
                                                                            .2                                                                                               .2
                                                                              ,0                                                                                                ,0
                                                                                .8                                                                                                .8
                                                                                   ,0                                                                                                ,0
                                                                                     .9                                                                                                .9
```

ah
                                                                                        6)                                                                                                6)

```text
                                                                                                        lsdv
                                                                          (0                                                                                               (0
                                                                            .8                                                                                               .8
```

```text
                                                                                                                  lsdvc_2
                                                                              ,0                                                                                                ,0
                                                                                .2                                                                                                .2
                                                                                   ,0                                                                                                ,0
                                                                                     .3                                                                                                .3
```

Tbar=40
                                                                                                                                                                                                                             Tbar=20

6)                                                                                                6)
                                                                          (0                                                                                               (0

```text
                                                      Parameter designs
                                                                                                                                                       Parameter designs
                                                                            .8                                                                                               .8
                                                                              ,0                                                                                                ,0
                                                                                .2                                                                                                .2
                                                                                   ,0                                                                                                ,0
                                                                                     .9                                                                                                .9
                                                                                        6)                                                                                                6)
                                                                          (0                                                                                               (0
                                                                            .8                                                                                               .8
                                                                              ,0                                                                                                ,0
                                                                                .8                                                                                                .8
```

```text
Figure 6: Biases of all estimators for β (γ, ρ, ω).
                                                                                   ,0                                                                                                ,0
                                                                                     .3                                                                                                .3
                                                                                        6)                                                                                                6)
                                                                          (0                                                                                               (0
                                                                            .8                                                                                               .8
                                                                              ,0                                                                                                ,0
                                                                                .8                                                                                                .8
                                                                                   ,0                                                                                                ,0
                                                                                     .9                                                                                                .9
                                                                                        6)                                                                                                6)
                                                                                                                                                                                                                                       Dynamic unbalanced panel-data models
```

```text
                                                                                            (0                                                                                              (0
                                                                                              .2                                                                                              .2
                                                                                                ,0                          rmse                                                                 ,0                          rmse
                                                                                                  .2                                                                                               .2
                                                                                                     ,0
                                                                                                       .3      .02   .04   .06     .08             .1                                                 ,0
                                                                                                                                                                                                        .3      .02   .04   .06     .08   .1
                                                                                                          6)                                                                                               6)
                                                                                                                                                                                                                                                         G. S. F. Bruno
```

```text
                                                                                            (0                                                                                              (0
                                                                                              .2                                                                                              .2
                                                                                                ,0                                                                                               ,0
                                                                                                  .2                                                                                               .2
                                                                                                     ,0                                                                                               ,0
                                                                                                       .9                                                                                               .9
                                                                                                          6)                                                                                               6)
                                                                                            (0                                                                                              (0
                                                                                              .2                                                                                              .2
```

```text
                                                                                                                                         lsdvc_3
                                                                                                                                                    lsdvc_1
                                                                                                ,0                                                                                               ,0
                                                                                                  .8                                                                                               .8
                                                                                                     ,0                                                                                               ,0
                                                                                                       .3                                                                                               .3
                                                                                                          6)                                                                                               6)
                                                                                            (0                                                                                              (0
                                                                                              .2                                                                                              .2
                                                                                                ,0                                                                                               ,0
                                                                                                  .8                                                                                               .8
                                                                                                     ,0                                                                                               ,0
                                                                                                       .9                                                                                               .9
```

```text
                                                                                                                                         bb
                                                                                                          6)                                                                                               6)
                                                                                            (0                                                                                              (0
                                                                                              .8                                                                                              .8
```

```text
                                                                                                                                                    lsdvc_2
                                                                                                ,0                                                                                               ,0
                                                                                                  .2                                                                                               .2
                                                                                                     ,0                                                                                               ,0
                                                                                                       .3                                                                                               .3
```

Tbar=40
                                                                                                                                                                                                                                               Tbar=20

6)                                                                                               6)
                                                                                            (0                                                                                              (0

```text
                                                                        Parameter designs
                                                                                                                                                                        Parameter designs
                                                                                              .8                                                                                              .8
                                                                                                ,0                                                                                               ,0
                                                                                                  .2                                                                                               .2
                                                                                                     ,0                                                                                               ,0
                                                                                                       .9                                                                                               .9
                                                                                                          6)                                                                                               6)
                                                                                            (0                                                                                              (0
                                                                                              .8                                                                                              .8
                                                                                                ,0                                                                                               ,0
                                                                                                  .8                                                                                               .8
                                                                                                     ,0                                                                                               ,0
                                                                                                       .3                                                                                               .3
                                                                                                          6)                                                                                               6)
                                                                                            (0                                                                                              (0
                                                                                              .8                                                                                              .8
                                                                                                ,0                                                                                               ,0
                                                                                                  .8                                                                                               .8
                                                                                                     ,0                                                                                               ,0
```

```text
Figure 7: RMSEs of LSDVC1 , LSDVC2 , LSDVC3 , and BB for β (γ, ρ, ω).
                                                                                                       .9                                                                                               .9
                                                                                                          6)                                                                                               6)
                                                                                                                                                                                                                                                         499
```

500

```text
                                                                         (0                                                                                     (0
                                                                           .2                                                                                     .2
                                                                             ,0                       rmse                                                           ,0                       rmse
                                                                               .2                                                                                      .2
                                                                                  ,0
                                                                                    .3      0   .05    .1    .15             .2                                           ,0
                                                                                                                                                                            .3      0   .05    .1    .15   .2
                                                                                       6)                                                                                      6)
                                                                         (0                                                                                     (0
                                                                           .2                                                                                     .2
                                                                             ,0                                                                                      ,0
                                                                               .2                                                                                      .2
                                                                                  ,0                                                                                      ,0
                                                                                    .9                                                                                      .9
                                                                                       6)                                                                                      6)
```

```text
                                                                                                              bb
                                                                                                                   ab
                                                                         (0                                                                                     (0
                                                                           .2                                                                                     .2
```

```text
                                                                                                                        lsdvc_3
                                                                             ,0                                                                                      ,0
                                                                               .8                                                                                      .8
                                                                                  ,0                                                                                      ,0
                                                                                    .3                                                                                      .3
                                                                                       6)                                                                                      6)
                                                                         (0                                                                                     (0
                                                                           .2                                                                                     .2
                                                                             ,0                                                                                      ,0
                                                                               .8                                                                                      .8
                                                                                  ,0                                                                                      ,0
                                                                                    .9                                                                                      .9
```

ah
                                                                                       6)                                                                                      6)

```text
                                                                                                                        lsdv
                                                                         (0                                                                                     (0
                                                                           .8                                                                                     .8
                                                                             ,0                                                                                      ,0
                                                                               .2                                                                                      .2
                                                                                  ,0                                                                                      ,0
                                                                                    .3                                                                                      .3
```

Tbar=40
                                                                                                                                                                                                                Tbar=20

6)                                                                                      6)
                                                                         (0                                                                                     (0

```text
                                                     Parameter designs
                                                                                                                                            Parameter designs
                                                                           .8                                                                                     .8
                                                                             ,0                                                                                      ,0
                                                                               .2                                                                                      .2
                                                                                  ,0                                                                                      ,0
                                                                                    .9                                                                                      .9
                                                                                       6)                                                                                      6)
                                                                         (0                                                                                     (0
                                                                           .8                                                                                     .8
                                                                             ,0                                                                                      ,0
                                                                               .8                                                                                      .8
```

```text
Figure 8: RMSEs of all estimators for β (γ, ρ, ω).
                                                                                  ,0                                                                                      ,0
                                                                                    .3                                                                                      .3
                                                                                       6)                                                                                      6)
                                                                         (0                                                                                     (0
                                                                           .8                                                                                     .8
                                                                             ,0                                                                                      ,0
                                                                               .8                                                                                      .8
                                                                                  ,0                                                                                      ,0
                                                                                    .9                                                                                      .9
                                                                                       6)                                                                                      6)
                                                                                                                                                                                                                          Dynamic unbalanced panel-data models
```
