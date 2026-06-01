# How to do xtabond2: An introduction to difference and system GMM in Stata


The Stata Journal (2009) 9, Number 1, pp. 86-136

How to do xtabond2: An introduction to
difference and system GMM in Stata
                                    David Roodman
                             Center for Global Development
                                    Washington, DC
                                 droodman@cgdev.org

## Abstract


**Abstract.**     The difference and system generalized method-of-moments estima- tors, developed by Holtz-Eakin, Newey, and Rosen (1988, Econometrica 56: 1371- 1395); Arellano and Bond (1991, Review of Economic Studies 58: 277-297); Arel- lano and Bover (1995, Journal of Econometrics 68: 29-51); and Blundell and Bond (1998, Journal of Econometrics 87: 115-143), are increasingly popular. Both are general estimators designed for situations with “small T , large N ” panels, meaning few time periods and many individuals; independent variables that are not strictly exogenous, meaning they are correlated with past and possibly current realiza- tions of the error; fixed effects; and heteroskedasticity and autocorrelation within individuals. This pedagogic article first introduces linear generalized method of moments. Then it describes how limited time span and potential for fixed effects and endogenous regressors drive the design of the estimators of interest, offering Stata-based examples along the way. Next it describes how to apply these estima- tors with xtabond2. It also explains how to perform the Arellano-Bond test for autocorrelation in a panel after other Stata commands, using abar. The article concludes with some tips for proper use. Keywords: st0159, xtabond2, generalized method of moments, GMM, Arellano- Bond test, abar

1    Introduction
Arellano-Bond (Arellano and Bond 1991) and Arellano-Bover/Blundell-Bond (Arel-
lano and Bover 1995; Blundell and Bond 1998) dynamic panel estimators are increas-
ingly popular. Both are general estimators designed for situations with 1) “small T ,
large N ” panels, meaning few time periods and many individuals; 2) a linear functional
relationship; 3) one left-hand-side variable that is dynamic, depending on its own past
realizations; 4) independent variables that are not strictly exogenous, meaning they
are correlated with past and possibly current realizations of the error; 5) fixed indi-
vidual effects; and 6) heteroskedasticity and autocorrelation within individuals but not
across them. Arellano-Bond estimation starts by transforming all regressors, usually
by differencing, and uses the generalized method of moments (GMM) (Hansen 1982),
and is called difference GMM. The Arellano-Bover/Blundell-Bond estimator augments
Arellano-Bond by making an additional assumption that first differences of instru-
ment variables are uncorrelated with the fixed effects. This allows the introduction of
more instruments and can dramatically improve efficiency. It builds a system of two

c 2009 StataCorp LP                                                                     st0159

equations-the original equation and the transformed one-and is known as system
GMM.

The xtabond2 command implements these estimators. When introduced in late
2003, it brought several novel capabilities to Stata users. Going beyond the built-
in xtabond command, xtabond2 implemented system GMM. It made the Windmeijer
(2005) finite-sample correction to the reported standard errors in two-step estimation,
without which those standard errors tend to be severely downward biased. It introduced
finer control over the instrument matrix. And in later versions, it offered automatic
difference-in-Sargan/Hansen testing for the validity of instrument subsets; support for
observation weights; and the forward orthogonal deviations transform, an alternative
to differencing proposed by Arellano and Bover (1995) that preserves sample size in
panels with gaps. Stata 10 absorbed many of these features. xtabond now performs the
Windmeijer correction. The new xtdpd and xtdpdsys commands jointly offer most of
xtabond2’s features, while moving somewhat toward its syntax and running significantly
faster. On the other hand, xtabond2 runs in older versions of Stata and still offers unique
features including observation weights, automatic difference-in-Sargan/Hansen testing,
and the ability to “collapse” instruments to limit instrument proliferation.
Interestingly, though the Arellano and Bond article (1991) is now seen as the source
of an estimator, it is entitled Some tests of specification for panel data. The instrument
sets and use of GMM that largely define difference GMM originated with Holtz-Eakin,
Newey, and Rosen (1988). One of Arellano and Bond’s contributions is a test for
autocorrelation appropriate for linear GMM regressions on panels, which is especially
important when lags are used as instruments. xtabond2 automatically reports this test.
But because ordinary least squares (OLS) and two-stage least squares (2SLS) are special
cases of linear GMM, the Arellano-Bond test has wider applicability. The postestimation
command abar, also described in this article, makes the test available after regress,
ivregress, ivreg2, newey, and newey2.
One disadvantage of difference and system GMM is that they are complicated and so
can easily generate invalid estimates. Implementing them with a Stata command stuffs
them into a black box, creating the risk that users not understanding the estimators’
purpose, design, and limitations will unwittingly misuse the estimators. This article
aims to prevent that misuse. Its approach is therefore pedagogic. Section 2 introduces
linear GMM. Section 3 describes how certain panel econometric problems drive the de-
sign of the difference and system estimators. Some of the derivations are incomplete
because their purpose is to build intuition; the reader must refer to the original article
or to textbooks for details. Section 4 describes the xtabond2 and abar syntaxes, with
examples. Section 5 concludes the article with tips for proper use.

2     Linear GMM1
2.1    The GMM estimator
The classical linear estimators OLS and 2SLS can be thought of in several ways, the
most intuitive being suggested by the estimators’ names. OLS minimizes the sum of the
squared errors. 2SLS can be implemented via OLS regressions in two stages. But there is
another, more unified, way to view these estimators. In OLS, identification can be said
to flow from the assumption that the regressors are orthogonal to the errors; the inner
products, or moments, of the regressors with the errors are set to 0. Likewise, in the
more general 2SLS framework, which distinguishes between regressors and instruments
while allowing the two categories to overlap (variables in both categories are included,
exogenous regressors), the estimation problem is to choose coefficients on the regressors
so that the moments of the errors with the instruments are 0.
However, an ambiguity arises in conceiving of 2SLS as a matter of satisfying such
moment conditions. What if there are more instruments than regressors? If we view the
moment conditions as a system of equations, one for each instrument, then the unknowns
in these equations are the coefficients, of which there is one for each regressor. If
instruments outnumber regressors, then equations outnumber unknowns and the system
usually cannot be solved. Thus the moment conditions cannot be expected to hold
perfectly in finite samples even when they are true asymptotically. This is the sort of
problem we are interested in. To be precise, we want to fit the model

$$
y = x \beta + \varepsilon
                                         E(\varepsilon | z) = 0
$$

$$
where \beta is a column vector of coefficients, y and \varepsilon are random variables, x = (x1 , . . . , xk )
$$

is a column vector of k regressors, z = (z1 , . . . , zj ) is column vector of j instruments,
x and z can share elements, and j ≥ k. We use X, Y, and Z to represent matrices of
N observations for x, y, and z, and we define E = Y - Xβ. Given an estimate, β,          the

empirical residuals are E = (

e1 , . . . , eN ) = Y - Xβ. We make no assumption at this
point about E (EE | Z) = Ω except that it exists.
The challenge in estimating this model is that while all the instruments are theo-
retically orthogonal to the error term, E(zε) = 0, trying to force the corresponding
                                                  to zero creates a system with more
vector of empirical moments, EN (zε) ≡ (1/N )Z E,
equations than variables if j > k. The specification is then overidentified. Because we
cannot expect to satisfy all the moment conditions at once, the problem is to satisfy
them all as well as possible in some sense, that is, to minimize the magnitude of the
vector EN (zε).

1. For another introduction to GMM, see Baum, Schaffer, and Stillman (2003). For fuller accounts,
see Ruud (2000, chap. 21-22) and Hayashi (2000, chap. 3).

In the GMM, one defines that magnitude through a generalized metric, based on a
positive-semidefinite quadratic form. Let A be the matrix for such a quadratic form.
Then the metric is
                                                        
                         1              1        1         1
         EN (zε) A =       ZE A≡N          ZE A         ZE = E        ZAZ E     (1)
                         N               N           N           N

To derive the implied GMM estimate, call it βA , we solve the minimization prob-
lem βA = argminβb Z E A , whose solution is determined by 0 = d/(dβ)  Z E  A.
Expanding this derivative with the chain rule gives
                                                                            
                                                                 d Y - Xβ
          d               d           d E     d     1        
0=          A=
              Z E                A
                              Z E        =             ZAZ E
                                                      E
         dβ
                         dE           dβ      N
                                             dE                        dβ
            2
        =     E ZAZ (-X)
            N
The last step uses the matrix identities dAb/db = A and d (b Ab) /db = 2b A, where
b is a column vector and A is a symmetric matrix. Dropping the factor of -2/N and
transposing,
                                  
                ZAZ X = Y - XβA ZAZ X = Y ZAZ X - β X ZAZ X
            0=E                                            A

$$
\Rightarrow X ZAZ X\betaA = X ZAZ Y
                               -1
            \Rightarrow \betaA = (X ZAZ X) X ZAZ Y                                                (2)
$$

This is the GMM estimator defined by A. It is linear in Y.
While A weights moments, one can also incorporate weights for observations. If W
is a diagonal N × N observation weighting matrix, then the GMM criterion function can
be recast as (1/N )Z WE  A . The appendix derives the more general weighted GMM
estimator.
The GMM estimator is consistent, meaning that under appropriate conditions, it
converges in probability to β as sample size goes to infinity (Hansen 1982). But like 2SLS,
it is, in general, biased, as section 2.6 discusses, because in finite samples the instruments
are almost always at least slightly correlated with the endogenous components of the
instrumented regressors. Correlation coefficients between finite samples of uncorrelated
variables are usually not exactly 0.
For future reference, the bias of the estimator is the corresponding projection of the
true model errors:
                              -1
         βA - β = (X ZAZ X) X ZAZ (Xβ + E) - β
                                 -1                              -1
                 = (X ZAZ X)        X ZAZ Xβ + (X ZAZ X)        X ZAZ E - β
                                 -1
                 = (X ZAZ X)        X ZAZ E                                          (3)

2.2    Efficiency
It can be seen from (2) that multiplying A by a nonzero scalar would not change
βA . But up to a factor of proportionality, each choice of A implies a different linear,
consistent estimator of β. Which A should the researcher choose? Making A scalar is
intuitive, generally inefficient, and instructive. By (1), it would yield an equal-weighted
Euclidian metric on the moment vector. To see the inefficiency, consider what happens
if there are two instruments of zero means, one drawn from a variable with a variance
of 1, the other from a variable with a variance of 1,000. Moments based on the second
instrument would easily dominate the minimization problem under equal weighting,
wasting the information in the first. Or imagine a cross-country growth regression
instrumenting with two highly correlated proxies for the poverty level. The marginal
information content in the second would be minimal, yet including it in the moment
vector would double the weight of poverty at the expense of other instruments. In both
examples, the inefficiency is signaled by high variance or covariance among moments.
This suggests that making A scalar is inefficient unless the moments zε have equal
variance and are uncorrelated-that is, if Var (zε) is itself scalar. This suggestion is
correct, as will be seen.2
But that negative conclusion hints at the general solution. For efficiency, A must
in effect weight moments in inverse proportion to their variances and covariances. In
the first example above, such reweighting would appropriately deemphasize the high-
variance instrument. In the second example, it would efficiently down-weight one or
both of the poverty proxies. In general, for efficiency, we weight by the inverse of the
variance of the population moments, which, under suitable conditions, is the asymptotic
variance of the sample moments.
Because efficiency is an asymptotic notion, to speak rigorously of it we view matrices
such as Z and E as elements of infinite sequences indexed by N . For economy of space,
however, we suppress subscripts that would indicate this dependence. So we write the
efficient GMM moment weighting matrix as
                                         -1                         -1
                       -1           1                           1
AEGMM ≡ Var (zε) = Avar           ZE       ≡ plim N Var         ZE              (4)
                                    N              N →∞          N

$$
Substituting into (1), the efficient GMM (EGMM) estimator minimizes
                                             
                          A             1              -1 1
                      Z E   EGMM
                                   = N     Z E   Var (z\varepsilon)      ZE
                                         N                   N
$$

Substituting this choice of A into (2) gives the direct formula for EGMM:
                                               -1
                βEGMM = X ZVar (zε) Z X
                                         -1                      -1
                                                     X ZVar (zε) Z Y                              (5)

EGMM is not feasible, however, unless Var (zε) is known.

2. This argument is analogous to that for the design of generalized least squares (GLS); GLS is derived
with reference to the errors E, where GMM is derived with reference to the moments Z E.

$$
Before we move to making the estimator feasible, we demonstrate its efficiency.
Define SZY = EN (zy) = (1/N )Z Y and SZX = EN (zx ) = (1/N )Z X. We can then
rewrite the general GMM estimator in (2) as \betaA = (SZX ASZX ) SZX ASZY . We
                                                                 -1
$$

assume that conditions suitable for a Law of Large Numbers hold, so that
           ΣZX ≡ E (zx ) = plim SZX                                                                 (6)
                                 N →∞
                                                                                           
                                                              1                          1
           plim N Var (SZY ) ≡ Avar (SZY ) = Avar               ZY           = Avar         ZE       (7)
           N →∞                                               N                           N
                   = Var (zε) = A-1
                                 EGMM

For each sample size N > 0, let BN be the vector space of scalar-valued functions
of the random vector Y. This space contains all the coefficient estimates defined by
linear estimators based on Y. For example, if c = (1 0 0 . . .), then cβA ∈ BN is the
estimated coefficient for x1 according to the GMM estimator implied by some A. We
define an inner product on BN by b1 , b2 = Cov (b1 , b2 ); the corresponding metric is
b 2 = Var (b). The assertion that (5) is efficient is equivalent to saying that for any
row vector c and any N -indexed sequence of GMM weighting matrices A1 , A2 , . . . (which
could be constant over N ), the asymptotic variance plim N cβAN is smallest when
                                                           N →∞
plim AN = AEGMM .
N →∞
                           

We first show that plim N cβAN , cβAEGMM is invariant to the choice of sequence
                          N →∞
(AN ). We start with the definition of covariance and then use (6) and (7):
plim N cβAN , cβAEGMM
N →∞
                         
                                       -1
          = plim N Cov c (SZX AN SZX ) SZX AN SZY ,
               N →∞
                                                                             
                                                -1
                          c (SZX AEGMM SZX )        SZX AEGMM SZY

                                                   
                                          -1
           =       plim c (ΣZX AN ΣZX )       ΣZX AN N Var (SZY )
                   N →∞
                                                                   -1
                          × AEGMM ΣZX (ΣZX AEGMM ΣZX )                 c
                                                                                                     (8)
                                                                  
                                          -1
           =       plim c (ΣZX AN ΣZX )       ΣZX AN A-1
                                                        EGMM
                   N →∞
                                                                   -1
                          × AEGMM ΣZX (ΣZX AEGMM ΣZX )                 c

                                             
                                      -1                                                   -1
           =c      plim (ΣZX AN ΣZX ) ΣZX AN ΣZX                (ΣZX AEGMM ΣZX )             c
                   N →∞

$$
-1
           = c (\SigmaZX AEGMM \SigmaZX )          c
$$

This does not depend on the sequence (AN ). As a result, for any (AN ),
                                     

plim N cβAEGMM , c βAEGMM - βAN
N →∞
                     
            

$$
= plim N c\betaA       , c\betaAEGMM
                                           - plim N c\betaA
                                                 EGMM
                                                                 , c\betaA   =0    EGMM          N
                  N \to\infty                                        N \to\infty
$$

That is, the difference between any linear GMM estimator and the EGMM estimator is
asymptotically orthogonal to the latter. So by the Pythagorean theorem,

$$
plim N c\betaAN         2
                              = plim N c\betaAN - c\betaAEGMM                2
                                                                           + plim N c\betaAEGMM      2
     N \to\infty                       N \to\infty                                         N \to\infty
$$

Thus plim N        cβAN        ≥ plim N cβAEGMM . This suffices to prove the assertion
N →∞                          N →∞
that EGMM is, in fact, efficient. The result is akin to the fact that if there is a ball
in midair, then the point on the ground closest to the ball (analogous to the efficient
estimator) is such that the vector from the point to the ball is perpendicular to all
vectors from the point to other spots on the ground, which are all inferior estimators of
the ball’s position.
Perhaps greater insight comes from a visualization based on another derivation of
EGMM. Under the assumptions in our model, a direct OLS estimate of Y = Xβ + E is
biased. However, taking Z-moments of both sides gives

$$
Z Y = Z X\beta + Z E                                          (9)
$$

which is at least asymptotically amenable to OLS (Holtz-Eakin, Newey, and Rosen 1988).
Still, OLS is not, in general, efficient on the transformed equation, because the error term,
Z E, is probably not independent and identically distributed (i.i.d.):
Avar {(1/N )Z E} = Var (zε), which cannot be assumed scalar. To solve this problem,
we transform the equation again:
                              -1/2                     -1/2                         -1/2
                  Var (zε)           Z Y = Var (zε)          Z Xβ + Var (zε)             Z E
                               -1/2                             -1/2                              -1/2
Defining X∗ = Var (zε)                 Z X, Y∗ = Var (zε)              Z Y, and E∗ = Var (zε)           Z E,
the equation becomes
                                              Y∗ = X∗ β + E∗                                             (10)
By design now,
                                                                             
                         1 ∗                             -1/2              1            -1/2
              Avar         E       = plim N Var (zε)            Var          Z E Var (zε)
                         N            N →∞                                 N
                                               -1/2                          -1/2
                                   = Var (zε)         Var (zε) Var (zε)             =I

Because (10) has spherical errors, the Gauss-Markov theorem guarantees the efficiency
of OLS applied to it, which is, by definition, generalized least squares (GLS) on (9):
  -1
βGLS = X∗ X∗       X∗ Y∗ . Unwinding with the definitions of X∗ and Y∗ yields EGMM,
just as in (5).

Efficient GMM, then, is GLS on Z-moments. Where GLS projects Y into the col-
umn space of X, GMM estimators (efficient or otherwise) project Z Y into the column
space of Z X. These projections also map the variance ellipsoid of Z Y, represented
by Avar {(1/N )Z Y} = Var (zε), into the column space of Z X. If Var (zε) happens to
be spherical, then the efficient projection is orthogonal, by Gauss-Markov, just as the
shadow of a soccer ball is smallest when the sun is directly overhead. No reweighting
of moments is needed for efficiency. But if the variance ellipsoid of the moments is an
American football pointing at an odd angle, as in the examples at the beginning of this
section-that is, if Var (zε) is not scalar-then the efficient projection, the one casting
the smallest shadow, is angled. To make that optimal projection, the mathematics in
this second derivation stretch and shear space with a linear transformation to make the
football spherical, perform an orthogonal projection, and then reverse the distortion.

2.3    Feasibility
Making EGMM practical requires a feasible estimator for the optimal weighting matrix,
        -1
Var (zε) . The usual route to this goal starts by observing that this matrix is the limit
of an expression built around Ω:
                                                                        
                                        1                      1
           Var (zε) = plim N Var          Z E = plim N E          Z  EE   Z
                          N →∞         N           N →∞        N2
                               1
                      = plim E {E (Z EE Z | Z)}
                          N →∞ N
                               1                               1
                      = plim E {Z E (EE | Z) Z} = plim E (Z ΩZ)
                          N →∞ N                        N →∞  N

The simplest case is when the errors are believed to be homoskedastic, with Ω of the
form σ 2 I. Then, according to the last expression, the EGMM weighting matrix is the
inverse of σ 2 plim (1/N )E (Z Z), a consistent estimate of which is (σ 2 /N )Z Z. Plugging
              N →∞
this choice for A into (2) and simplifying yields 2SLS:
                                              -1
                                         -1                   -1
                     β2SLS = X Z (Z Z) Z X     X Z (Z Z) Z Y

So when errors are i.i.d., 2SLS is EGMM.3 When more-complex patterns of variance in the
errors are suspected, the researcher can use a kernel-based estimator for the standard er-
rors, such as the “sandwich” one ordinarily requested from Stata estimation commands
with the robust and cluster options. A matrix, Ω,    is constructed based on a formula
                                                                               is a con-
that itself does not converge to Ω, but which has the property that (1/N )Z ΩZ
                                                                                    -1
sistent estimator of plim (1/N )E (Z ΩZ) under given assumptions. (1/N )Z ΩZ
                       N →∞

3. However, even when the two are asymptotically identical, in finite samples, the feasible EGMM
algorithm we develop produces different results from 2SLS because it will, in practice, be based on
a different moment weighting matrix.

        -1
or, equivalently,
                        Z ΩZ    is then used as the weighting matrix. The result is the
feasible EGMM (FEGMM) estimator:
                                       -1      -1          -1
               βFEGMM =
                               X Z Z ΩZ    Z X
                                                      X Z Z ΩZ    Z Y                (11)

For example, if we believe that the only deviation from sphericity is heteroskedasticity,
                                           of the residuals, we define
then given consistent initial estimates, E,
                                    ⎛ 2                   ⎞
                                       e1
                                    ⎜       e22          ⎟
                                =⎜
                               Ω    ⎜            .
                                                          ⎟
                                                          ⎟
                                    ⎝              ..     ⎠
                                                      eN
                                                        2

Similarly, in a wide panel context, we can handle arbitrary patterns of covariance within
individuals with a “clustered” Ω,  a block-diagonal matrix with blocks
                                    ⎛                                      ⎞
                                          e2i1  ei1 ei2 · · · ei1 eiT
                                    ⎜ ei2 ei1     e22   · · · ei2 eiT ⎟
                                ⎜                                      ⎟
                     Ωi = Ei Ei = ⎜         ..        ..   ..         ..   ⎟         (12)
                                    ⎝        .         .       .       .   ⎠
                                       eiT ei1    ···    ···     e2iT

i is the vector of residuals for individual i, the elements e are double indexed for
Here E
a panel, and T is the number of observations per individual.
A problem remains: where do the e come from? They must be derived from an initial
estimate of β. Fortunately, as long as the initial estimate is consistent, a GMM estimator
fashioned from them is efficient: whatever valid algorithm is chosen to build the GMM
weighting matrix will converge to the optimal matrix as N increases. Theoretically,
any full-rank choice of A for the initial GMM estimate will suffice. Usual practice is to
                    -1
choose A = (Z HZ) , where H is an “estimate” of Ω based on a minimally arbitrary
assumption about the errors, such as homoskedasticity.
Finally, we arrive at a practical recipe for linear GMM: perform an initial GMM regres-
sion, replacing Ω in (11) with some reasonable but arbitrary H, yielding β1 (one-step
GMM); obtain the residuals from this estimation; use the residuals to construct a sand-
                                                                                     -1
wich proxy for Ω, calling it Ω  b ; rerun the GMM estimation setting A = Z Ω    b Z    .
                                  β1                                               β1
This two-step estimator, β2 , is efficient and robust to whatever patterns of heteroskedas-
ticity and cross correlation the sandwich covariance estimator models. In sum,
                                  -1
                             -1                    -1
        β1   =  X Z (Z HZ) Z X     X Z (Z HZ) Z Y
                                      -1       -1            -1
        β2
              = βFEGMM = X Z Z Ωβb1 Z         ZX             b Z
                                                      X Z Z Ωβ1     Z Y              (13)

Historically, researchers often reported one-step results in addition to two-step results
because of downward bias in the computed standard errors in two-step results. But as
the next section explains, Windmeijer (2005) greatly reduces this problem.

$$
2.4    Estimating standard errors
A derivation similar to that in (8) shows that the asymptotic variance of a linear GMM
estimator is
              
                                   -1                                     -1
       Avar \betaA = (\SigmaZX A\SigmaZX ) \SigmaZX A Var (z\varepsilon) A\SigmaZX (\SigmaZX A\SigmaZX )                    (14)
$$

But for both one- and two-step estimation, there are complications in developing feasible
approximations for this formula.
                                                                   -1
In one-step estimation, although the choice of A = (Z HZ) as a moment weight-
ing matrix (discussed above) does not render the parameter estimates inconsistent even
when H is based on incorrect assumptions about the variance of the errors, using Z HZ
to proxy for Var (zε) in (14) would make the variance estimate for the parameters
inconsistent. Z HZ is not a consistent estimate of Var (zε). The standard error esti-
mates would not be “robust” to heteroskedasticity or serial correlation in the errors.
Fortunately, they can be made so in the usual way, replacing Var (zε) in (14) with a
sandwich-type proxy based on the one-step residuals. This yields the feasible, robust
estimator for the one-step standard errors:
                                     -1
r β1 = X Z (Z HZ)-1 Z X
Avar
                                                         -1
                                            X Z (Z HZ) Z Ω  b Z (Z HZ)-1 Z X
                                                                β1
                                                     -1
                                              -1
                               × X Z (Z HZ) Z X                                 (15)

The complication with the two-step variance estimate is less straightforward. The
thrust of the exposition to this point has been that, because of its sophisticated reweight-
ing based on second moments, GMM is, in general, more efficient than 2SLS. But such as-
sertions are asymptotic. Whether GMM is superior in finite samples-or whether the so-
phistication even backfires-is an empirical question. The case in point: for (infeasible)
                                                                                       -1
                                           -1                                   -1
EGMM, in which A = AEGMM = Var (zε) , (14) simplifies to X Z (Z HZ)               ZX       ,
                                                                             -1      -1
a feasible, consistent estimate of which will typically be X Z Z Ω     b Z      Z X     .
                                                                           β1
This is the standard formula for the variance of linear GMM estimates. But it can
produce standard errors that are downward biased when the number of instruments is
large-severely enough to make two-step GMM useless for inference (Arellano and Bond
1991).
The trouble may be that in small samples, reweighting empirical moments based
on their own estimated variances and covariances can end up mining data, indirectly
overweighting observations that fit the model and underweighting ones that contradict
it. The need to estimate the j(j + 1)/2 distinct elements of the symmetric Var (zε)

can easily outstrip the statistical power of a small sample. These elements, as second
moments of second moments, are fourth moments of the underlying data. When sta-
tistical power is that low, it becomes hard to distinguish moment means from moment
variances-i.e., to distinguish third and fourth moments of the underlying data. For
example, if the poorly estimated variance of some moment, Var (zi ), is large, this could
be because it truly has higher variance and deserves deemphasis; or it could be because
the moment happens to put more weight on observations that do not fit the model well,
in which case deemphasizing them overfits the model.
This phenomenon does not make coefficient estimates inconsistent because identifi-
cation still flows from instruments believed to be exogenous. However, it can produce
spurious precision in the form of implausibly small standard errors.
Windmeijer (2005) devised a small-sample correction for the two-step standard er-
rors. The starting observation is that despite appearances in (13), β2 is not simply
linear in the random vector Y. It is also a function of Ω  b , which depends on β1 ,
                                                            β1
which depends on Y too. And the variance in Y is the ultimate source of the variance
in the parameter estimates, through projection by the estimator. To express the full
dependence of β2 on Y, let
                                   -1      -1            -1
              g Y, Ω = X Z Z ΩZ        Z X
                                                    X Z Z ΩZ      Z E         (16)
                                                                                -1
By (3), this is the bias of the GMM estimator associated with A = Z ΩZ             . g
is infeasible because the true
                             disturbances,
                                            E, are unobserved. In the second step of
FEGMM, where Ω    =Ω b , g Y, Ω b = β2 - β, so g has the same variance as β2 , which
                       β1          β1
is what we are interested in, but zero expectation.
Both of g’s arguments are random. Yet the usual derivation of the variance estimate
for β2 treats Ω
                b as infinitely precise. That is appropriate for one-step GMM, where
                 β1
= H is constant. But it is wrong in two-step GMM, where Z Ω
Ω                                                                 b Z is imprecise. To
                                                                   β1
compensate, Windmeijer (2005) develops a formula for the dependence of g on the data
via both of its arguments, and then calculates its variance. The expanded formula is
infeasible, but a feasible approximation performs well in Windmeijer’s simulations.
Windmeijer starts with a first-order Taylor expansion of g, viewed as a function of
β1 , around the true (and unobserved) β:
                                                                    
                 g Y, Ω b ≈ g Y, Ω       β + ∂ g Y, Ω  b |b      1 - β
                                                                    β
                                                ∂ β
                         β1                               β   β=β

$$
        
Defining D = ∂g Y, \Omega      b /∂ \beta | b and noting that \beta1 - \beta = g (Y, H), this is
                          \beta         \beta=\beta
                                                   
                           g Y, \Omega  b \approx g Y, \Omega      \beta + Dg (Y, H)                  (17)
                                    \beta1
$$

Windmeijer expands the derivative in the definition of D using matrix calculus on
                                                             β , β, and E, with feasible
(16), and then replaces infeasible terms within it, such as Ω

is the k × k matrix whose pth column
approximations. It works out that the result, D,
is
           -1      -1            -1 ∂ Ωb                   -1
            b Z
- X Z Z Ω       Z
                       X             b Z
                             X Z Z Ω      Z
                                                  β
                                                    | β=
                                                      b β

b1 Z Z Ωβb1 Z
                                                                             2
                                                                          Z E
             β1                       β1
                                               ∂ βp

where βp is the pth element of β. The formula for the ∂ Ω  b/∂ βp within this expression
                                                              β
depends on that for Ω b. For clustered errors on a panel, Ω
                                                            b has blocks E
                                                                           1,i E
                                                                                  , so by the
                        β                                        β                    1,i
product rule ∂ Ω b/∂ βp , has blocks ∂ E
                                          1,i /∂ βp E
                                                       + E     /∂ βp = -xp,i E
                                                            i∂E                   - E   1,i x ,
                  β                                    1,i       1,i               1,i           p,i
where E 1,i contains the one-step errors for individual i and xp,i holds the observations
of regressor xp for individual i. The feasible variance estimate of (17), i.e., the corrected
estimate of the variance of β2 , works out to
                                                                        
c β2 = Avar
Avar             β2 + D         β2 + Avar
                                     Avar               β2 D    + D    r β1 D
                                                                         Avar                (18)

The first term is the uncorrected variance estimate, and the last contains the robust one-
step estimate. (The appendix provides a fuller derivation of the Windmeijer correction
in the more general context of observation-weighted GMM.)
In difference GMM regressions on simulated panels, Windmeijer (2005) found that
two-step EGMM performs somewhat better than one-step GMM in estimating coefficients,
with lower bias and standard errors. And the reported two-step standard errors, with
his correction, are quite accurate, so that two-step estimation with corrected errors
seems modestly superior to cluster-robust one-step estimation.4

2.5    The Sargan/Hansen test of overidentifying restrictions
A crucial assumption for the validity of GMM is that the instruments are exogenous. If
the model is exactly identified, detection of invalid instruments is impossible because
even when E(zε) = 0, the estimator will choose β so that Z E  = 0 exactly. But if the
model is overidentified, a test statistic for the joint validity of the moment conditions
(identifying restrictions) falls naturally out of the GMM framework. Under the null
of joint validity, the vector of empirical moments, (1/N )Z E, is randomly distributed
around 0. A Wald test can check this hypothesis. If it holds, then the statistic
                         
                     1             -1 1        1    
                      Z E Var (zε)         ZE=        Z E AEGMM Z E
                    N                    N        N

is χ2 with degrees of freedom equal to the degree of overidentification, j - k. The
Hansen (1982) J test statistic for overidentifying restrictions is this expression made
feasible by substituting a consistent estimate of AEGMM . It is just the minimized value
of the criterion expression in (1) for a feasible EGMM estimator. If Ω is scalar, then
                  -1
AEGMM = (Z Z) . Here the Hansen test coincides with the Sargan (1958) test. But if
4. xtabond2 offers both.

      is suspected in the errors, as in robust one-step GMM, the Sargan statistic
nonsphericity
                   -1    is inconsistent. Then a theoretically superior overidentifi-
(1/N ) Z E (Z Z) Z E
cation test for the one-step estimator is that based on the Hansen statistic from a
two-step estimate. When the user requests the Sargan test for “robust” one-step GMM
regressions, some software packages, including ivreg2 and xtabond2, therefore quietly
perform the second GMM step to obtain and report a consistent Hansen statistic.
Sargan/Hansen statistics can also be used to test the validity of subsets of instru-
ments, via a “difference-in-Sargan/Hansen” test, also known as a C statistic. If one
performs an estimation with and without a subset of suspect instruments, under the
null of joint validity of the full instrument set, the difference in the two reported Sar-
gan/Hansen test statistics is itself asymptotically χ2 , with degrees of freedom equal to
the number of suspect instruments. The regression without the suspect instruments is
called the “unrestricted” regression because it imposes fewer moment conditions. The
difference-in-Sargan/Hansen test is, of course, only feasible if this unrestricted regression
has enough instruments to be identified.
The Sargan/Hansen test should not be relied upon too faithfully, because it is prone
to weakness. Intuitively speaking, when we apply it after GMM, we are first trying to
                close to 0, then testing whether it is close to 0. Counterintuitively,
drive (1/N )Z E
however, the test actually grows weaker the more moment conditions there are and,
seemingly, the harder it should be to come close to satisfying them all.

2.6    The problem of too many instruments5
The difference and system GMM estimators described in the next section can generate
moment conditions prolifically, with the instrument count quadratic in the time dimen-
sion of the panel, T . This can cause several problems in finite samples. First, because
the number of elements in the estimated variance matrix of the moments is quadratic in
the instrument count, it is quartic in T . A finite sample may lack adequate information
to estimate such a large matrix well. It is not uncommon for the matrix to become sin-
gular, forcing the use of a generalized inverse.6 This does not compromise consistency
(again, any choice of A will give a consistent estimator), but does dramatize the distance
of FEGMM from the asymptotic ideal. And it can weaken the Hansen test to the point
where it generates implausibly good p-values of 1.000 (Anderson and Sørenson 1996;
Bowsher 2002). Indeed, Sargan (1958) determined without the aid of modern comput-
ers that the error in his test is “proportional to the number of instrumental variables,
so that, if the asymptotic approximations are to be used, this number must be small”.

5. Roodman (2009) delves into the issues in this section.
6. xtabond2 issues a warning when this happens.

A large instrument collection can overfit endogenous variables. For intuition, con-
sider that in 2SLS, if the number of instruments equals the number of observations,
the R2 s of the first-stage regressions are 1, and the second-stage results match those
of (biased) OLS. This bias is present in all instrumental-variables (IV) regressions and
becomes more pronounced as the instrument count rises.
Unfortunately, there appears to be little guidance from the literature on how many
instruments is “too many” (Ruud 2000, 515), in part because the bias is present to
some extent even when instruments are few. In one simulation of difference GMM on
an 8 × 100 panel, Windmeijer (2005) reports that cutting the instrument count from 28
to 13 reduced the average bias in the two-step estimate of the parameter of interest by
40%. Simulations of panels of various dimensions in Roodman (2009) produce similar
results. For instance, raising the instrument count from 5 to just 10 in a system GMM
regression on a 5 × 100 panel raises the estimate of a parameter whose true value is 0.80
from 0.80 to 0.86. xtabond2 warns when instruments outnumber individual units in the
panel, as a minimally arbitrary rule of thumb; the simulations arguably indicate that
that limit (equal to 100 here) is generous. At any rate, in using GMM estimators that
can generate many instruments, it is good practice to report the instrument count and
test the robustness of results to reducing it. The next sections describe the instrument
sets typical of difference and system GMM, and ways to contain them with xtabond2.

3     The difference and system GMM estimators
The difference and system GMM estimators can be seen as part of a broader historical
trend in econometric practice toward estimators that make fewer assumptions about the
underlying data-generating process and use more complex techniques to isolate useful
information. The plummeting costs of computation and software distribution no doubt
have abetted the trend.
The difference and system GMM estimators are designed for panel analysis and em-
body the following assumptions about the data-generating process:

• The process may be dynamic, with current realizations of the dependent variable
influenced by past ones.

• There may be arbitrarily distributed fixed individual effects. This argues against
cross-section regressions, which must essentially assume fixed effects away, and in
favor of a panel setup, where variation over time can be used to identify parame-
ters.

• Some regressors may be endogenous.

• The idiosyncratic disturbances (those apart from the fixed effects) may have
individual-specific patterns of heteroskedasticity and serial correlation.

• The idiosyncratic disturbances are uncorrelated across individuals.

Also, some secondary concerns shape the design:

• Some regressors can be predetermined but not strictly exogenous; that is, inde-
        pendent of current disturbances, some regressors can be influenced by past ones.
        The lagged dependent variable is an example.
• The number of time periods of available data, T , may be small. (The panel is
        “small T , large N ”.)

Finally, because the estimators are designed for general use, they do not assume that
good instruments are available outside the immediate dataset. In effect, it is assumed
that

• The only available instruments are “internal”-based on lags of the instrumented
        variables.

However, the estimators do allow inclusion of external instruments.
The general model of the data-generating process is much like that in section 2:

$$
yit = \alphayi,t-1 + xit \beta + \varepsilonit                          (19)
                               \varepsilonit = \mui + vit
                            E (\mui ) = E (vit ) = E (\mui vit ) = 0
$$

Here the disturbance term has two orthogonal components: the fixed effects, μi , and
the idiosyncratic shocks, vit . We can rewrite (19) as

$$
\Deltayit   =   (\alpha - 1)yi,t-1 + xit \beta + \varepsilonit                  (20)
$$

So the model equally can be thought of as being for the level or increase of y.
In this section, we start with the classical OLS estimator applied to (19) and then
modify it step by step to address all the concerns listed above, ending with the esti-
mators of interest. For a continuing example, we will copy the application to firm-level
employment in Arellano and Bond (1991). Their panel dataset is based on a sample of
140 UK firms surveyed annually from 1976 to 1984. The panel is unbalanced, with some
firms having more observations than others. Because hiring and firing workers is costly,
we expect employment to adjust with delay to changes in factors such as firms’ capital
stock, wages, and demand for the firms’ output. The process of adjustment to changes
in these factors may depend both on the passage of time, which indicates lagged versions
of these factors as regressors, and on the difference between equilibrium employment
level and the previous year’s actual level, which argues for a dynamic model, in which
lags of the dependent variable are also regressors.
The Arellano-Bond dataset can be downloaded with the Stata command webuse
abdata.7 The dataset indexes observations by the firm identifier, id, and year. The
7. In Stata 7, type use http://www.stata-press.com/data/r7/abdata.dta.

```text
variable n is firm employment, w is the firm’s wage level, k is the firm’s gross capital,
and ys is the aggregate output in the firm’s sector, as a proxy for demand; all variables
are in logarithms. Variable names ending in L1 or L2 indicate lagged copies. In their
model, Arellano and Bond include the current and first lags of wages, the first two lags
of employment, the current and first two lags of capital and sector-level output, and a
set of time dummies.
   A naı̈ve attempt to estimate the model in Stata would look like this:
      . webuse abdata
      . regress n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*
            Source         SS        df          MS               Number of obs =      751
                                                                  F( 16,    734) = 8136.58
             Model    1343.31797     16   83.9573732              Prob > F       = 0.0000
          Residual    7.57378164    734   .010318504              R-squared      = 0.9944
                                                                  Adj R-squared = 0.9943
             Total    1350.89175    750       1.801189            Root MSE       = .10158
```

n        Coef.    Std. Err.          t   P>|t|      [95% Conf. Interval]

nL1     1.044643    .0336647       31.03   0.000      .9785523    1.110734
               nL2    -.0765426    .0328437       -2.33   0.020     -.1410214   -.0120639
                 w    -.5236727    .0487799      -10.74   0.000     -.6194374    -.427908
               wL1     .4767538    .0486954        9.79   0.000       .381155    .5723527
                 k     .3433951    .0255185       13.46   0.000      .2932972    .3934931
               kL1    -.2018991    .0400683       -5.04   0.000     -.2805613    -.123237
               kL2    -.1156467    .0284922       -4.06   0.000     -.1715826   -.0597107
                ys     .4328752    .1226806        3.53   0.000      .1920285     .673722
              ysL1    -.7679125    .1658165       -4.63   0.000     -1.093444   -.4423813
              ysL2     .3124721     .111457        2.80   0.005      .0936596    .5312846
            yr1976    (dropped)
            yr1977    (dropped)
            yr1978    (dropped)
            yr1979     .0158888    .0143976        1.10   0.270     -.0123765    .0441541
            yr1980     .0219933    .0166632        1.32   0.187       -.01072    .0547065
            yr1981    -.0221532    .0204143       -1.09   0.278     -.0622306    .0179243
            yr1982    -.0150344    .0206845       -0.73   0.468     -.0556422    .0255735
            yr1983     .0073931    .0204243        0.36   0.717     -.0327038    .0474901
            yr1984     .0153956    .0230101        0.67   0.504     -.0297779     .060569
             _cons     .2747256    .3505305        0.78   0.433     -.4134363    .9628875

3.1    Purging fixed effects
One immediate problem in applying OLS to this empirical problem, and to (19) in gen-
eral, is that yi,t-1 is correlated with the fixed effects in the error term, which gives rise
to “dynamic panel bias” (Nickell 1981). For example, consider the possibility that a
firm experiences a large, negative employment shock for some reason not modeled, say,
in 1980, so that the shock appears in the error term. All else equal, the apparent fixed
effect for that firm for the entire 1976-1984 period-the deviation of its average unex-
plained employment from the sample average-will appear to be lower. In 1981, lagged
employment and the fixed effect will both be lower. This positive correlation between
a regressor and the error violates an assumption necessary for the consistency of OLS.

In particular, it inflates the coefficient estimate for lagged employment by attributing
predictive power to it that actually belongs to the firm’s fixed effect. Here T = 9. If
T were large, the impact of one year’s shock on the firm’s apparent fixed effect would
dwindle and so would the endogeneity problem.
There are two ways to work around this endogeneity. One, at the heart of difference
GMM, is to transform the data to remove the fixed effects. The other is to instrument
yi,t-1 and any other similarly endogenous variables with variables thought uncorrelated
with the fixed effects. System GMM incorporates that strategy and we will return to it.
An intuitive first attack on the fixed effects is to draw them out of the error term
by entering dummies for each individual-the so-called least-squares dummy-variables
(LSDV) estimator:

```text
        . xi: regress n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr* i.id
        i.id              _Iid_1-140          (naturally coded; _Iid_1 omitted)
               Source        SS       df       MS              Number of obs =     751
                                                               F(155,    595) = 983.39
                Model   1345.63898   155 8.68154179            Prob > F       = 0.0000
             Residual   5.25277539   595 .008828194            R-squared      = 0.9961
                                                               Adj R-squared = 0.9951
                Total   1350.89175   750    1.801189           Root MSE       = .09396
```

n        Coef.    Std. Err.      t    P>|t|    [95% Conf. Interval]

nL1      .7329476    .039304    18.65   0.000    .6557563     .810139
                 nL2    -.1394773     .040026    -3.48   0.001   -.2180867   -.0608678
                   w    -.5597445     .057033    -9.81   0.000   -.6717551   -.4477339
                 wL1      .3149987   .0609756     5.17   0.000    .1952451    .4347522
                   k      .3884188   .0309544    12.55   0.000    .3276256    .4492119
                 kL1    -.0805185    .0384648    -2.09   0.037   -.1560618   -.0049751
                 kL2    -.0278013    .0328257    -0.85   0.397   -.0922695     .036667
                  ys       .468666   .1231278     3.81   0.000    .2268481    .7104839
                ysL1    -.6285587      .15796    -3.98   0.000   -.9387856   -.3183318
                ysL2      .0579764   .1345353     0.43   0.667   -.2062454    .3221982
              yr1976    (dropped)
              yr1977    (dropped)
              yr1978    (dropped)
              yr1979      .0046562   .0137521     0.34   0.735   -.0223523    .0316647
              yr1980      .0112327   .0164917     0.68   0.496   -.0211564    .0436218
              yr1981    -.0253693    .0217036    -1.17   0.243   -.0679942    .0172557
              yr1982    -.0343973    .0223548    -1.54   0.124   -.0783012    .0095066
              yr1983    -.0280344    .0240741    -1.16   0.245   -.0753149    .0192461
              yr1984    -.0119152    .0261724    -0.46   0.649   -.0633167    .0394862
              _Iid_2      .2809286   .1197976     2.35   0.019    .0456511    .5162061
              _Iid_3      .1147461   .0984317     1.17   0.244   -.0785697     .308062
              (output omitted )
               _cons      1.821028    .495499     3.68   0.000    .8478883    2.794168

Or we could take advantage of another Stata command to do the same thing more
succinctly:

```text
        . xtreg n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*, fe
```

A third way to get nearly the same result is to partition the regression into two steps,
first “partialling” the firm dummies out of the other variables with the Stata command
xtdata, then running the final regression with those residuals. This partialling out
applies a mean-deviations transform to each variable, where the mean is computed at
the level of the firm. OLS on the data transformed is the within-groups estimator.
It generates the same coefficient estimates, but it generates standard errors that are
biased because they do not take into account the loss of N degrees of freedom in the
pretransformation:8

```text
      . xtdata n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*, fe
      . regress n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*
        (output omitted )
```

But within-groups does not eliminate dynamic panel bias (Nickell 1981; Bond 2002).
                                                                                     ∗
Under the within-groups transformation, the lagged dependent variable becomes yi,t-1       =
                                                                    ∗
yi,t-1 - {1/(T - 1)} (yi2 + · · · + yiT ), while the error becomes vit = vit - {1/(T - 1)}
(vi2 + · · · + viT ). (The use of the lagged dependent variable as a regressor restricts the
                                                                      ∗
sample to t = 2, . . ., T .) The problem is that the yi,t-1 term in yi,t-1 correlates nega-
                                             ∗
tively with the - {1/(T - 1)} vi,t-1 in vit , while, symmetrically, the - {1/(T - 1)} yit
and vit terms also move together.9 So regressor and error are still correlated after
transformation.
                                                                            ∗
Worse, one cannot attack the continuing endogeneity by instrumenting yi,t-1  with
lags of yi,t-1 (a strategy we will turn to soon) because they too are embedded in
                         ∗
the transformed error, vit . Again if T were large, then the - {1/(T - 1)} vi,t-1 and
- {1/(T - 1)} yit terms above would be insignificant, and the problem would disap-
pear. But in simulations, Judson and Owen (1999) find a bias equal to 20% of the
coefficient of interest even when T = 30.
Interestingly, where in our initial naı̈ve OLS regression the lagged dependent variable
was positively correlated with the error, biasing its coefficient estimate upward, the
opposite is the case now. In the Stata examples, the estimate for the coefficient on
lagged employment fell from 1.045 to 0.733. Good estimates of the true parameter
should therefore lie in or near the range between these values. (In fact, a credible
estimate should probably be below 1.00 because values above 1.00 imply an unstable
dynamic, with accelerating divergence away from equilibrium values.) As Bond (2002)
points out, these bounds provide a useful check on results from theoretically superior
estimators.
Kiviet (1995) argues that the best way to handle dynamic panel bias is to perform
LSDV, and then correct the results for the bias, which he finds can be predicted with
surprising precision. However, the approach he advances works only for balanced panels
and does not address the potential endogeneity of other regressors.

8. Because xtdata modifies the dataset, the dataset needs to be reloaded to copy later examples.
9. In fact, there are many other correlating term pairs, but their impact is second order because both
terms in those pairs contain a {1/(T - 1)} factor.

As a result, the more practical strategy has been to develop estimators that theo-
retically need no correction. What is needed to directly remove dynamic panel bias is a
different transformation of the data, one that expunges fixed effects while avoiding the
propensity of the within-groups transformation to make every observation of y ∗ endoge-
nous to every other for a given individual. There are many potential candidates. In fact,
if the observations are sorted by individual within the data matrices X and Y, then
fixed effects can be purged by left-multiplying them by any block-diagonal matrix whose
blocks each have width T and whose rows sum to zero. Such matrices map individual
dummies to 0, thus purging fixed effects. How to choose? The transformation should
have full row rank so that no further information is lost. It should make the transformed
variables minimally dependent on lagged observations of the original variables so that
they remain available as instruments. In other words, the blocks of the matrix should
be upper triangular, or nearly so. A subtle, third criterion is that the transformation
should be resilient to missing data-an idea we will clarify momentarily.
Two transformations are commonly used. One is the first-difference transform, which
gives its name to “difference GMM”. It is effected by IN ⊗ MΔ , where IN is the identity
matrix of order N and MΔ consists of a diagonal of -1s with a subdiagonal of 1s just
to the right. Applying the transform to (19) gives

$$
\Deltayit = \alpha\Deltayi,t-1 + \Deltaxit \beta + \Deltavit
$$

Though the fixed effects are gone, the lagged dependent variable is still potentially
endogenous, because the yi,t-1 term in Δyi,t-1 = yi,t-1 - yi,t-2 is correlated with the
vi,t-1 in Δvit = vit - vi,t-1 . Likewise, any predetermined variables in x that are not
strictly exogenous become potentially endogenous because they too may be related to
vi,t-1 . But unlike with the mean-deviations transform, longer lags of the regressors
remain orthogonal to the error and available as instruments.
The first-difference transform has a weakness. It magnifies gaps in unbalanced pan-
els. If some yit is missing, for example, then both Δyit and Δyi,t+1 are missing in
the transformed data. One can construct datasets that completely disappear in first
differences. This motivates the second common transformation, called “forward or-
thogonal deviations” or “orthogonal deviations” (Arellano and Bover 1995). Instead of
subtracting the previous observation from the contemporaneous one, it subtracts the
average of all future available observations of a variable. No matter how many gaps, it
is computable for all observations except the last for each individual, so it minimizes
data loss. And because lagged observations do not enter the formula, they are valid as
instruments. To be precise, if w is a variable, then the transform is
                                                            
                               ⊥                  1
                             wi,t+1 ≡ cit wit -          wis                       (21)
                                                 Tit s>t

```text
where the sum is taken over available future observations, Tit is the number of such
observations, and the scale factor, cit , is Tit / (Tit + 1). In a balanced panel, the
transformation can be written cleanly as IN ⊗ M⊥ , where
                      ⎧ #                                               ⎫
                      ⎪
                      ⎪     T -1
                                   - √    1
                                                   - √     1
                                                                  . . . ⎪
                                                                        ⎪
                      ⎪
                      ⎪      T                                          ⎪
                                                                        ⎪
                      ⎪
                      ⎪              #T (T -1)          T (T -1)        ⎪
                                                                        ⎪
                      ⎪
                      ⎨                                                 ⎪
                                         T -2
                                         T -1   -  √       1
                                                                  ... ⎬
                                                        -1)(T -2)
                M⊥ =                                 #
                                                     (T
                      ⎪
                      ⎪                                                 ⎪
                      ⎪
                      ⎪
                                                         T -3
                                                         T -2     ... ⎪ ⎪
                                                                        ⎪
                      ⎪
                      ⎪                                                 ⎪
                                                                        ⎪
                      ⎪
                      ⎩                                           . .. ⎪⎭
```

One nice property of this transformation is that if the wit are independently distributed
before transformation, they remain so after. (The rows of M⊥ are orthogonal to each
other.) The choice of cit further assures that if the wit are not only independent but also
identically distributed, this property persists too; that is, M⊥ M⊥ = I.10 This is not
the case with differencing, which tends to make successive errors correlated even if they
are uncorrelated before transformation: Δvit = vit - vi,t-1 is mathematically related to
Δvi,t-1 = vi,t-1 - vi,t-2 via the shared vi,t-1 term. However, researchers typically do
not assume homoskedasticity in applying these estimators, so this property matters less
than the resilience to gaps. In fact, Arellano and Bover show that in balanced panels,
any two transformations of full row rank will yield numerically identical estimators,
holding the instrument set fixed.
We will use the ∗ superscript to indicate data transformed by differencing or orthog-
onal deviations. The appearance of the t + 1 subscript instead of t on the left side of
(21) reflects the standard software practice of storing orthogonal deviations-transformed
variables one period late, for consistency with the first-difference transform. With this
definition, both transforms effectively drop the first observations for each individual;
and for both, observations wi,t-2 and earlier are the ones absent from the formula for
∗
wit , making them valid instruments.

3.2    Instrumenting with lags
As emphasized at the beginning of this section, we are building an estimator for gen-
eral application, in which we choose not to assume that the researcher has excellent
instruments waiting in the wings. So we must draw instruments from within the
                                              ∗
dataset. Natural candidate instruments for yi,t-1  are yi,t-2 and, if the data are trans-
formed by differencing, Δyi,t-2 . In the differenced case, for example, both yi,t-2 and
Δyi,t-2 are mathematically related to Δyi,t-1 = yi,t-1 - yi,t-2 but not to the error
term Δvit = vit - vi,t-1 as long as the vit are not serially correlated (see section 3.5).
The simplest way to incorporate either instrument is with 2SLS, which leads us to the
Anderson and Hsiao (1982) difference and levels estimators. Of these, the levels esti-
mator, instrumenting with yi,t-2 instead of Δyi,t-2 , seems preferable for maximizing
sample size. Δyi,t-2 is in general not available until t = 4, whereas yi,t-2 is available
                                             `         M
                                                           ´     `
                                                                         ´
10. If Var (vit ) = I, then Var (M⊥ vit ) = E M⊥ vit vit ⊥ = M⊥ E vit vit M⊥ = M⊥ M⊥ .

at t = 3, and an additional time period of data is significant in short panels. Returning
to the employment example, we can implement the Anderson-Hsiao levels estimator
(Anderson and Hsiao 1982) by using the Stata command ivregress:

```text
      . ivregress 2sls D.n (D.nL1= nL2) D.(nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr1979
      > yr1980 yr1981 yr1982 yr1983)
      Instrumental variables (2SLS) regression                   Number of obs =       611
                                                                 Wald chi2(15) =     89.93
                                                                 Prob > chi2   =    0.0000
                                                                 R-squared     =         .
                                                                 Root MSE      =      .247
```

D.n         Coef.   Std. Err.        z    P>|z|      [95% Conf. Interval]

nL1
               D1.      2.307626   1.973193       1.17   0.242     -1.559762    6.175013
               nL2
               D1.     -.2240271    .179043      -1.25   0.211     -.5749448    .1268907
                 w
               D1.     -.8103626    .261805      -3.10   0.002     -1.323491   -.2972342
               wL1
               D1.      1.422246   1.179492       1.21   0.228     -.8895156    3.734007
                 k
               D1.      .2530975   .1447404       1.75   0.080     -.0305884    .5367835
               kL1
               D1.     -.5524613   .6154929      -0.90   0.369     -1.758805    .6538825
               kL2
               D1.     -.2126364   .2397909      -0.89   0.375     -.6826179    .2573451
                ys
               D1.      .9905803   .4630105       2.14   0.032      .0830965    1.898064
              ysL1
               D1.     -1.937912   1.438225      -1.35   0.178      -4.75678    .8809566
              ysL2
               D1.      .4870838   .5099415       0.96   0.339     -.5123832    1.486551
            yr1979
               D1.      .0467148   .0448599       1.04   0.298     -.0412089    .1346385
            yr1980
               D1.      .0761344   .0624919       1.22   0.223     -.0463474    .1986163
            yr1981
               D1.       .022623   .0557394       0.41   0.685     -.0866242    .1318701
            yr1982
               D1.      .0127801   .0548402       0.23   0.816     -.0947048       .120265
            yr1983
               D1.      .0099072   .0456113       0.22   0.828     -.0794894    .0993037
             _cons      .0159337   .0273445       0.58   0.560     -.0376605    .0695279

```text
      Instrumented:   D.nL1
      Instruments:    D.nL2 D.w D.wL1 D.k D.kL1 D.kL2 D.ys
                      D.ysL1 D.ysL2 D.yr1979 D.yr1980 D.yr1981
                      D.yr1982 D.yr1983 nL2
```

This is the first consistent estimate of the employment model, given our assumptions.
It performs rather poorly, with a point estimate on the lagged dependent variable of
2.308, well outside the credible 0.733-1.045 range (between the LSDV and OLS point
estimates discussed in section 3.1). The standard error on the coefficient is large too.

```text
    To improve efficiency, we can take the Anderson-Hsiao approach further, using
longer lags of the dependent variable as additional instruments. To the extent this
introduces more information, it should improve efficiency. But in standard 2SLS, the
longer the lags used, the smaller the sample, because observations for which lagged
observations are unavailable are dropped.
    Working in the GMM framework, Holtz-Eakin, Newey, and Rosen (1988) show a way
around this trade-off. As an example, standard 2SLS would enter the instrument yi,t-2
into Z in one column, as a stack of blocks like
                                        ⎛         ⎞
                                               .
                                        ⎜ yi1 ⎟
                                        ⎜         ⎟
                                  Zi = ⎜       .. ⎟
                                        ⎝       . ⎠
                                                    yi,T -2
```

The “.” at the top represents a missing value, which forces the deletion of that row
from the dataset. (Recall that the transformed variables being instrumented begin at
t = 2, so the vector above starts at t = 2 and only its first observation lacks yi,t-2 .)
Holtz-Eakin, Newey, and Rosen instead build a set of instruments from the second lag
of y, one for each time period, and substitute zeros for missing observations, resulting
in “GMM-style” instruments:
                              ⎛                         ⎞
                                  0    0 ···       0
                              ⎜ yi1 0 · · ·        0    ⎟
                              ⎜                         ⎟
                              ⎜ 0 yi2 · · ·        0    ⎟
                              ⎜                         ⎟
                              ⎜ ..     ..  ..      .    ⎟
                              ⎝ .       .     .    ..   ⎠
                                  0          0      ···    yi,T -2

In unbalanced panels, one also substitutes zeros for other missing values. These
substitutions might seem like a dubious doctoring of the data in response to missing in-
formation. But the resulting columns of Z, each taken as orthogonal to the transformed
errors, correspond to a set of meaningful moment conditions,
                           
                    E Z E  =0⇒         yi,t-2 e∗it = 0 for each t ≥ 3
                                         i

which are based on an expectation we believe: E (yi,t-2 ε∗it ) = 0. (In fact, such instru-
ments are perfectly valid, if unorthodox, in 2SLS, so “GMM-style” is a misleading label.)
Alternatively, one could “collapse” this instrument set into one column:
                                      ⎛          ⎞
                                            0
                                      ⎜ yi1 ⎟
                                      ⎜          ⎟
                                      ⎜      ..  ⎟
                                      ⎝       .  ⎠
                                                 yi,T -2
This embodies the same expectation
                                ' but conveys       slightly less information, because it
generates one moment condition,   yi,t-2 e∗it = 0.
                                   i,t

```text
    Having eliminated the trade-off between lag length and sample length, it becomes
practical to include all valid lags of the untransformed variables as instruments, where
available. For endogenous variables, that means lags 2 and up. For a variable, w, that
                                                                             ∗
is predetermined but not strictly exogenous, lag 1 is also valid, because vit    is a function
of errors no older than vi,t-1 and wi,t-1 is potentially correlated only with errors vi,t-2
and older. For yi,t-1 , which is predetermined, realizations yi,t-2 and earlier can be used,
giving rise to stacked blocks in the instrument matrix of the form
    ⎛                                         ⎞                ⎛                         ⎞
        0     0    0     0    0     0 ···                          0    0     0 ···
    ⎜ yi1 0        0     0    0     0 ··· ⎟                    ⎜ yi1 0        0 ··· ⎟
    ⎜                                         ⎟                ⎜                         ⎟
    ⎜ 0 yi2 yi1 0             0     0   · · · ⎟                ⎜ yi2 yi1 0 · · · ⎟
    ⎜                                         ⎟ or, collapsed, ⎜                         ⎟
    ⎜ 0       0    0 yi3 yi2 yi1 · · · ⎟                       ⎜ yi3 yi2 yi1 · · · ⎟
    ⎝                                         ⎠                ⎝                         ⎠
         ..   ..   ..    ..    ..   ..  ..                         ..   ..    ..    ..
          .    .    .     .     .    .      .                       .    .     .       .
```

Because in the standard, uncollapsed form each instrumenting variable generates one
column for each time period and lag available to that time period, the number of
instruments is quadratic in T . To limit the instrument count (see section 2.6), one
can restrict the lag ranges used in generating these instrument sets. Or one can collapse
them. xtabond2 allows both.11
Although these instrument sets are part of what defines difference (and system)
GMM, researchers are free to incorporate other instruments.    Given the importance of
good instruments, it is worth giving serious thought to all options.
Returning to the employment example, the command line below expands on
Anderson-Hsiao by generating GMM-style instruments for the lags of n, and then uses
them in a 2SLS regression in differences. It treats all other regressors as exogenous;
they instrument themselves, appearing in both the regressor matrix X and the instru-
ment matrix Z. So Z contains both GMM-style instruments and ordinary one-column
“IV-style” ones:

11. After conceiving of such instrument sets and adding a collapse option to xtabond2, I discovered
precedents. Adapting Arellano and Bond’s (1998) dynamic panel package, Dynamic Panel Data
(DPD) for Gauss, and performing system GMM, Calderón, Chong, and Loayza (2002) use such
instruments, followed by Beck and Levine (2004) and Moran, Graham, and Blomström (2005).
Roodman (2009) demonstrates the superiority of collapsed instruments in some common situa-
tions with simulations.

```text
     . forvalues yr=1978/1984 {
       2.    forvalues lag = 2 / `= `yr´ - 1976´ {
       3.       quietly generate z`yr´L`lag´ = L`lag´.n if year == `yr´
       4.    }
       5. }
     . quietly recode z* (. = 0)
     . ivregress 2sls D.n D.(L2.n w L.w k L.k L2.k ys L.ys L2.ys yr1978 yr1979
     > yr1980 yr1981 yr1982 yr1983) (DL.n = z*), nocons
     note: z1978L2 dropped due to collinearity
     note: z1984L3 dropped due to collinearity
     Instrumental variables (2SLS) regression               Number of obs =    611
                                                            Wald chi2(16) =      .
                                                            Prob > chi2   =      .
                                                            R-squared     =      .
                                                            Root MSE      = .10885
```

D.n         Coef.   Std. Err.      z    P>|z|        [95% Conf. Interval]

n
              LD.      .2689418   .1447008     1.86   0.063       -.0146665    .5525501
             L2D.     -.0669834   .0431623    -1.55   0.121       -.1515799    .0176131
                w
              D1.     -.5723355   .0573518    -9.98   0.000        -.684743    -.459928
              LD.      .2112242   .1037099     2.04   0.042        .0079564    .4144919
                k
              D1.      .3843826   .0319335    12.04   0.000        .3217941    .4469711
              LD.      .0796079   .0538637     1.48   0.139        -.025963    .1851788
             L2D.      .0231674   .0364836     0.64   0.525       -.0483391     .094674
               ys
              D1.      .5976429    .119675     4.99   0.000        .3630842    .8322016
              LD.     -.4806272   .1614112    -2.98   0.003       -.7969874    -.164267
             L2D.      .0581721   .1340154     0.43   0.664       -.2044932    .3208374
           yr1978
              D1.      .0429548   .0427985     1.00   0.316       -.0409287    .1268384
           yr1979
              D1.       .047082   .0410286     1.15   0.251       -.0333325    .1274966
           yr1980
              D1.      .0566061   .0390769     1.45   0.147       -.0199833    .1331955
           yr1981
              D1.      .0263295   .0357589     0.74   0.462       -.0437567    .0964158
           yr1982
              D1.      .0018456   .0280028     0.07   0.947       -.0530388    .0567301
           yr1983
              D1.     -.0062288   .0195166    -0.32   0.750       -.0444805     .032023

```text
     Instrumented:   LD.n
     Instruments:    L2D.n D.w LD.w D.k LD.k L2D.k D.ys LD.ys
                     L2D.ys D.yr1978 D.yr1979 D.yr1980 D.yr1981
                     D.yr1982 D.yr1983 z1979L2 z1979L3 z1980L2
                     z1980L3 z1980L4 z1981L2 z1981L3 z1981L4
                     z1981L5 z1982L2 z1982L3 z1982L4 z1982L5
                     z1982L6 z1983L2 z1983L3 z1983L4 z1983L5
                     z1983L6 z1983L7 z1984L2 z1984L4 z1984L5
                     z1984L6 z1984L7 z1984L8
```

Although this estimate is, in theory, not only consistent but also more efficient than
Anderson-Hsiao, it still seems poorly behaved. Now the coefficient estimate for lagged
employment has plunged to 0.269, about 3 standard errors below the 0.733-1.045 range.

What is going on? As discussed in section 2.2, 2SLS is efficient under homoskedasticity.
But after differencing, the disturbances Δvit may be far from independent, apparently
far enough to greatly reduce accuracy. Δvit = vit - vi,t-1 can be correlated with
Δvi,t-1 = vi,t-1 - vi,t-2 , with which it shares a vi,t-1 term. Feasible GMM directly
addresses this problem, modeling the error structure more realistically, which makes it
both more precise asymptotically and better behaved in practice.12

```text
3.3    Applying GMM
The only way errors could reasonably be expected to be spherical in “difference GMM”
is if a) the untransformed errors are i.i.d., which is usually not assumed, and b) the
orthogonal deviations transform is used, so that the errors remain spherical. Otherwise,
as section 2.2 showed, FEGMM is asymptotically superior.
    To implement FEGMM, however, we must estimate Ω∗ , the covariance matrix of the
transformed errors-and do so twice for two-step GMM. For the first step, the least
arbitrary choice of H, the a priori estimate of Ω∗ (see section 2.3), is based, ironically,
on the assumption that the vit are i.i.d. after all. Using this assumption, and letting vi
refer to the vector of idiosyncratic errors for individual i, we set H to IN ⊗ Var (vi∗ | Z),
where
             Var (vi∗ | Z) = Var (M∗ vi | Z) = M∗ Var (vi vi | Z) M∗ = M∗ M∗         (22)
For orthogonal deviations, this is I, as discussed in section 3.1. For differences, it is
                               ⎛                          ⎞
                                    2 -1
                               ⎜ -1 2 -1                  ⎟
                               ⎜                          ⎟
                               ⎜                    .     ⎟                            (23)
                               ⎜         -1 2         . . ⎟
                               ⎝                          ⎠
                                               ..   ..
                                                  .     .
```

As for the second FEGMM step, here we proxy Ω∗ with the robust, clustered esti-
mate in (12), which is built on the assumption that errors are correlated only within
individuals, not across them. For this reason, it is almost always wise to include time
dummies to remove universal time-related shocks from the errors.
With these choices, we reach the classic Arellano and Bond (1991) difference GMM
estimator for dynamic panels. As the name suggests, Arellano and Bond originally
proposed using the differencing transform. When orthogonal deviations are used in-
stead, perhaps the estimator ought to be called “deviations GMM”-but the term is not
common.
Pending the full definition of the xtabond2 syntax in section 4.1, the example in
this section shows how to use the command to estimate the employment equation from
before. First, the final estimates in the previous section can actually be obtained from
xtabond2 by typing
12. Apparent bias toward 0 in the coefficient estimate can also indicate weak instrumentation, a concern
that motivates “system GMM,” discussed later.

```text
     . xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.n)
     > iv(w L.w L(0/2).(k ys) yr*) h(1) nolevel small
```

The h(1) option here specifies H = I, which embodies the incorrect assumption of
homoskedasticity. If we drop that, H defaults to the form given in (23), and the results
greatly improve:

```text
     . xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.n)
     > iv(w L.w L(0/2).(k ys) yr*) nolevel robust
     Favoring space over speed. To switch, type or click on mata: mata set matafavor
     > speed, perm.
     yr1976 dropped due to collinearity
     yr1977 dropped due to collinearity
     yr1984 dropped due to collinearity
     Warning: Two-step estimated covariance matrix of moments is singular.
       Using a generalized inverse to calculate robust weighting matrix for Hansen
     > test.
       Difference-in-Sargan statistics may be negative.
     Dynamic panel-data estimation, one-step difference GMM
```

```text
     Group variable: id                                Number of obs      =         611
     Time variable : year                              Number of groups   =         140
     Number of instruments = 41                        Obs per group: min =           4
     Wald chi2(16) =    1727.45                                       avg =        4.36
     Prob > chi2   =      0.000                                       max =           6
```

Robust
                n        Coef.     Std. Err.      z    P>|z|    [95% Conf. Interval]

n
              L1.     .6862261     .1445943     4.75   0.000    .4028266       .9696257
              L2.    -.0853582     .0560155    -1.52   0.128   -.1951467       .0244302
                w
              --.    -.6078208     .1782055    -3.41   0.001   -.9570972      -.2585445
              L1.     .3926237     .1679931     2.34   0.019    .0633632       .7218842
                k
              --.     .3568456     .0590203     6.05   0.000     .241168       .4725233
              L1.    -.0580012     .0731797    -0.79   0.428   -.2014308       .0854284
              L2.    -.0199475     .0327126    -0.61   0.542   -.0840631       .0441681
               ys
              --.     .6085073     .1725313     3.53   0.000    .2703522       .9466624
              L1.    -.7111651     .2317163    -3.07   0.002   -1.165321      -.2570095
              L2.     .1057969     .1412021     0.75   0.454   -.1709542        .382548
           yr1978     .0077033     .0314106     0.25   0.806   -.0538604        .069267
           yr1979     .0172578     .0290922     0.59   0.553   -.0397619       .0742775
           yr1980     .0297185     .0276617     1.07   0.283   -.0244974       .0839344
           yr1981     -.004071     .0298987    -0.14   0.892   -.0626713       .0545293
           yr1982    -.0193555     .0228436    -0.85   0.397    -.064128       .0254171
           yr1983    -.0136171     .0188263    -0.72   0.469    -.050516       .0232818

Instruments for first differences equation
        Standard
          D.(w L.w k L.k L2.k ys L.ys L2.ys yr1976 yr1977 yr1978 yr1979 yr1980
          yr1981 yr1982 yr1983 yr1984)
        GMM-type (missing=0, separate instruments for each period unless collapsed)
          L(1/.).L.n

$$
Arellano-Bond test for AR(1) in first differences: z =   -3.60   Pr > z =   0.000
      Arellano-Bond test for AR(2) in first differences: z =   -0.52   Pr > z =   0.606
$$

```text
      Sargan test of overid. restrictions: chi2(25)   = 67.59 Prob > chi2 = 0.000
        (Not robust, but not weakened by many instruments.)
      Hansen test of overid. restrictions: chi2(25)   = 31.38 Prob > chi2 = 0.177
        (Robust, but can be weakened by many instruments.)
      Difference-in-Hansen tests of exogeneity of instrument subsets:
        iv(w L.w k L.k L2.k ys L.ys L2.ys yr1976 yr1977 yr1978 yr1979 yr1980 yr1981
      > yr1982 yr1983 yr1984)
          Hansen test excluding group:     chi2(11)   = 12.01 Prob > chi2 = 0.363
          Difference (null H = exogenous): chi2(14)   = 19.37 Prob > chi2 = 0.151
```

To obtain two-step estimates, we would merely change robust to twostep. These
commands exactly match the one- and two-step results in Arellano and Bond (1991).13
Even so, the one-step coefficient on lagged employment of 0.686 (and the two-step
coefficient of 0.629) is not quite in the hoped for 0.733-1.045 range, which hints at
specification problems. Interestingly, Blundell and Bond (1998) write that they “do not
expect wages and capital to be strictly exogenous in our employment application”, but
the above regressions assume just that. If we instrument them too, in GMM style, then
the coefficient on lagged employment moves into the credible range:

```text
      . xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.(n w k)) iv(L(0/2).ys yr*)
      > nolevel robust small
      Favoring space over speed. To switch, type or click on mata: mata set matafavor
      > speed, perm.
      yr1976 dropped due to collinearity
      yr1977 dropped due to collinearity
      yr1984 dropped due to collinearity
      Warning: Two-step estimated covariance matrix of moments is singular.
        Using a generalized inverse to calculate robust weighting matrix for Hansen
      > test.
        Difference-in-Sargan statistics may be negative.
      Dynamic panel-data estimation, one-step difference GMM
```

13. See table 4, columns (a1) and (a2) in that article.

```text
      Group variable: id                               Number of obs      =         611
      Time variable : year                             Number of groups   =         140
      Number of instruments = 90                       Obs per group: min =           4
      F(16, 140)    =      85.30                                      avg =        4.36
      Prob > F      =      0.000                                      max =           6
```

Robust
                 n        Coef.    Std. Err.      t    P>|t|     [95% Conf. Interval]

n
               L1.     .8179867    .0859761     9.51   0.000     .6480073       .987966
               L2.    -.1122756    .0502366    -2.23   0.027     -.211596     -.0129552
                 w
               --.    -.6816685    .1425813    -4.78   0.000    -.9635594     -.3997776
               L1.     .6557083     .202368     3.24   0.001     .2556158      1.055801
                 k
               --.     .3525689    .1217997     2.89   0.004     .1117643      .5933735
               L1.    -.1536626    .0862928    -1.78   0.077     -.324268      .0169428
               L2.    -.0304529    .0321355    -0.95   0.345    -.0939866      .0330807
                ys
               --.     .6509498     .189582     3.43   0.001      .276136      1.025764
               L1.    -.9162028    .2639274    -3.47   0.001    -1.438001     -.3944042
               L2.     .2786584    .1855286     1.50   0.135    -.0881415      .6454584
            yr1978     .0238987    .0367972     0.65   0.517    -.0488513      .0966487
            yr1979     .0352258    .0351846     1.00   0.318     -.034336      .1047876
            yr1980     .0502675    .0365659     1.37   0.171    -.0220252      .1225602
            yr1981     .0102721    .0349996     0.29   0.770     -.058924      .0794683
            yr1982    -.0111623    .0264747    -0.42   0.674    -.0635042      .0411797
            yr1983    -.0069458    .0191611    -0.36   0.718    -.0448283      .0309368

Instruments for first differences equation
        Standard
          D.(ys L.ys L2.ys yr1976 yr1977 yr1978 yr1979 yr1980 yr1981 yr1982 yr1983
          yr1984)
        GMM-type (missing=0, separate instruments for each period unless collapsed)
          L(1/.).(L.n L.w L.k)

$$
Arellano-Bond test for AR(1) in first differences: z =   -5.39   Pr > z =   0.000
      Arellano-Bond test for AR(2) in first differences: z =   -0.78   Pr > z =   0.436
$$

```text
      Sargan test of overid. restrictions: chi2(74)   = 120.62 Prob > chi2 = 0.001
        (Not robust, but not weakened by many instruments.)
      Hansen test of overid. restrictions: chi2(74)   = 73.72 Prob > chi2 = 0.487
        (Robust, but can be weakened by many instruments.)
      Difference-in-Hansen tests of exogeneity of instrument subsets:
        iv(ys L.ys L2.ys yr1976 yr1977 yr1978 yr1979 yr1980 yr1981 yr1982 yr1983
      > yr1984)
          Hansen test excluding group:     chi2(65)   = 56.99 Prob > chi2 = 0.750
          Difference (null H = exogenous): chi2(9)    = 16.72 Prob > chi2 = 0.053
```

3.4    Instrumenting with variables orthogonal to the fixed effects
Arellano and Bond compare the performance of one- and two-step difference GMM
with the OLS, within-groups, and Anderson-Hsiao difference and levels estimators using
Monte Carlo simulations of 7 × 100 panels. Difference GMM exhibits the least bias and

variance in estimating the parameter of interest, although in their tests the Anderson-
Hsiao levels estimator does nearly as well for most parameter choices. But there are
many degrees of freedom in designing such tests. As Blundell and Bond (1998) demon-
strate in separate simulations, if y is close to a random walk, then difference GMM
performs poorly because past levels convey little information about future changes, so
untransformed lags are weak instruments for transformed variables.
To increase efficiency, under an additional assumption, Blundell and Bond develop an
approach outlined in Arellano and Bover (1995), pursuing the second strategy against
dynamic panel bias offered in section 3.1. Instead of transforming the regressors to
expunge the fixed effects, it transforms-differences-the instruments to make them
exogenous to the fixed effects. This is valid assuming that changes in any instrumenting
variable, w, are uncorrelated with the fixed effects: E (Δwit μi ) = 0 for all i and t. This
is to say, E (wit μi ) is time-invariant. If this holds, then Δwi,t-1 is a valid instrument
for the variables in levels:
E (Δwi,t-1 εit ) = E (Δwi,t-1 μi ) + E (wi,t-1 vit ) - E (wi,t-2 vit ) = 0 + 0 - 0
In a nutshell, where Arellano-Bond instruments differences (or orthogonal deviations)
with levels, Blundell-Bond instruments levels with differences. For random walk-like
variables, past changes may indeed be more predictive of current levels than past levels
are of current changes so that the new instruments are more relevant. Again validity
depends on the assumption that the vit are not serially correlated. Otherwise, wi,t-1
and wi,t-2 , correlated with past and contemporary errors, may correlate with future
ones as well. In general, if w is endogenous, Δwi,t-1 is available as an instrument
because Δwi,t-1 = wi,t-1 - wi,t-2 should not correlate with vit ; earlier realizations of
Δw can serve as instruments as well. And if w is predetermined, the contemporaneous
Δwit = wit - wi,t-1 is also valid, because E (wit vit ) = 0.
But the new assumption is not trivial; it is akin to one of stationarity. The Blundell-
Bond approach instruments yi,t-1 with Δyi,t-1 , which from the point of view of (20)
contains the fixed effect μi -yet we assume that the levels equation error, εit , contains
μi too, which makes the proposition that the instrument is orthogonal to the error, that
E (Δyi,t-1 εit ) = 0, counterintuitive. The assumption can hold, but only if the data-
generating process is such that the fixed effect and the autoregressive process governed
by α, the coefficient on the lagged dependent variable, offset each other in expectation
across the whole panel, much like investment and depreciation in a Solow growth model
steady state.
Blundell and Bond formalize this idea.14 They stipulate that α must have absolute
value less than unity so that the process converges. Then they derive the assumption
that E (Δwit μi ) = 0 from a more precise one about the initial conditions of the data-
generating process. It is easiest to state for the simple autoregressive model without
controls: yit = αyi,t-1 + μi + vit . Conditioning on μi , yit can be expected to converge
over time to μi / (1 - α)-the point where the fixed effect and the autoregressive decay
just offset each other.15 For the time-invariance of E (yit μi ) to hold, the deviations of
14. Roodman (2009) provides a pedagogic introduction to these ideas.
15. This can be seen by solving E (yit | μi ) = E (yi,t-1 | μi ), using yit = αyi,t-1 + μi + vit .

the initial observations, yi1 , from these long-term convergent values must not correlate
with the fixed effects: E [μi {yi1 - μi / (1 - α)}] = 0. Otherwise, the “regression to
the mean” that will occur, whereby individuals with higher initial deviations will have
slower subsequent changes as they converge to the long-run mean, will correlate with
the fixed effects in the error. If this condition is satisfied in the first period, then it will
be in subsequent ones as well. Generalizing to models with controls x, this assumption
about initial conditions is that, controlling for the covariates, faster-growing individuals
are not systematically closer or farther from their steady states than slower-growing
ones.
To exploit the new moment conditions for the data in levels while retaining the origi-
nal Arellano-Bond conditions for the transformed equation, Blundell and Bond designed
a system estimator. This involved building a stacked dataset with twice the observa-
tions; in each individual’s data, the untransformed observations follow the transformed
ones. Formally, we produce the augmented, transformed dataset by left-multiplying the
original by an augmented transformation matrix,
                                                 
                                               M∗
                                     M+∗  =
                                                I
where M∗ = MΔ or M⊥. . Thus, for individual i, the augmented dataset is
                                               ∗ 
                        +       Xi ∗       +       Yi
                       Xi =             , Yi =
                                 Xi                Yi
The GMM formulas and the software treat the system as a single-equation estimation
problem because the same linear relationship with the same coefficients is believed to
apply to both the transformed and untransformed variables.
In system GMM, one can include time-invariant regressors, which would disappear in
difference GMM. Asymptotically, this does not affect the coefficient estimates for other
regressors because all instruments for the levels equation are assumed to be orthogonal
to fixed effects, indeed to all time-invariant variables. In expectation, removing them
from the error term does not affect the moments that are the basis for identification.
However, it is still a mistake to introduce explicit fixed-effects dummies, for they would
still effectively cause the within-groups transformation to be applied as described in
section 3.1. In fact, any dummy that is 0 for almost all individuals, or 1 for almost all,
might cause bias in the same way, especially if T is very small.
The construction of the augmented instrument matrix, Z+ , is somewhat more com-
plicated. For a one-column, IV-style instrument, a strictly exogenous variable, w, with
observation vector W, could be transformed and entered like the regressors above,
                                               
                                            W∗
                                                                                    (24)
                                            W
                                  ' ∗ ∗        '
imposing the moment condition       wit eit +   wit eit = 0. Alternative arrangements,
implying slightly different conditions, include
                                                        
                                 0              W∗ 0
                                        and                                         (25)
                                W                0      W

As for GMM-style instruments, the Arellano-Bond instruments for the transformed
data are set to zero for levels observations, and the new instruments for the levels data
are set to zero for the transformed observations. One could enter a full GMM-style set of
differenced instruments for the levels equation, using all available lags, in direct analogy
with the levels instruments entered for the transformed equation. However, most of
these would be mathematically redundant in system GMM. The figure below shows why,
with the example of a predetermined variable, w, under the difference transform.16 The
D symbols link moments equated by the Arellano-Bond conditions on the differenced
equation. The upper-left one, for example, asserts that E (wi1 εi2 ) = E (wi1 εi1 ), which is
equivalent to the Arellano-Bond moment condition, E (wi1 Δεi2 ) = 0. The L symbols
do the same for the new Arellano-Bover conditions.
              E (wi1 εi1 )    D    E (wi1 εi2 ) D      E (wi1 εi3 ) D      E (wi1 εi4 )
                                        L
              E (wi2 εi1 )         E (wi2 εi2 ) D      E (wi2 εi3 ) D      E (wi2 εi4 )
                                                            L
              E (wi3 εi1 )         E (wi3 εi2 )        E (wi3 εi3 ) D      E (wi3 εi4 )
                                                                                L
              E (wi4 εi1 )         E (wi4 εi2 )        E (wi4 εi3 )        E (wi4 εi4 )
One could add more vertical links to the upper triangle of the grid, but it would
add
' no new information. The ones included above embody the moment restrictions
Δwit εit = 0 for each t > 1. If w is endogenous, those conditions become invalid
i
because the wit in Δwit is endogenous to the vit in εit .'
                                                         Lagging w one period sidesteps
this endogeneity, yielding the valid moment conditions     Δwi,t-1 εit = 0 for each t > 2:
                                                                 i

E (wi1 εi1 )       E (wi1 εi2 )    D   E (wi1 εi3 )    D   E (wi1 εi4 )
                                                           L
               E (wi2 εi1 )       E (wi2 εi2 )        E (wi2 εi3 )    D   E (wi2 εi4 )
                                                                               L
               E (wi3 εi1 )       E (wi3 εi2 )        E (wi3 εi3 )        E (wi3 εi4 )

```text
               E (wi4 εi1 )       E (wi4 εi2 )        E (wi4 εi3 )        E (wi4 εi4 )
If w is predetermined, the new moment conditions translate into the system GMM in-
strument matrix with blocks of the form
            ⎛                                  ⎞                 ⎛      ⎞
                 0      0       0     0 ···                         0
            ⎜ wi2      0       0     0 ··· ⎟                    ⎜ wi2 ⎟
            ⎜                                  ⎟                 ⎜      ⎟
            ⎜ 0       w                 · · · ⎟                 ⎜      ⎟
            ⎜               i3  0     0        ⎟ or , collapsed, ⎜ wi3 ⎟
            ⎜ 0         0      w     0  · · · ⎟                 ⎜ wi4 ⎟
            ⎝                      i4          ⎠                 ⎝      ⎠
                 ..      ..     ..    .. . .                        ..
                  .       .      .     .     .                       .
Here the first row of the matrix corresponds to t = 1. If w is endogenous, then the
nonzero elements are shifted down one row.
16. Tue Gørgens devised these diagrams.
```

Again the last item of business is defining H, which now must be seen as a prelim-
inary variance estimate for the augmented error vector, E+ . As before, to minimize
arbitrariness we set H to what Var (E+ ) would be in the simplest case. This time, how-
ever, assuming homoskedasticity and unit variance of the idiosyncratic errors does not
suffice to define a unique H, because the fixed effects are present in the levels errors.
Consider, for example, Var (εit ), for some i, t, which is on the diagonal of Var (E+ ).
Expanding this, we have

$$
Var (\varepsilonit ) = Var (\mui + vit ) = Var (\mui ) + 2 Cov (\mui , vit ) + Var (vit ) = Var (\mui ) + 0 + 1
$$

We must make an a priori estimate of each Var (μi )-and we choose 0. This lets us
proceed as if εit = vit . Then paralleling the construction for difference GMM, H is block
diagonal with blocks
                                                                       
                       +         +        +   +      M∗ M∗ M∗
                  Var εi = Var vi = M∗ M∗ =                                          (26)
                                                            M∗      I

where, in the orthogonal deviations case, M∗ M∗ = I. This is the default value of H
for system GMM in xtabond2. Current versions of Arellano and Bond’s own estima-
tion package, DPD, zero out the upper-right and lower-left quadrants of these matri-
ces. (Doornik, Arellano, and Bond 2006). The original implementation of system GMM
(Blundell and Bond 1998) used H = I. These choices are available in xtabond2 too.
For an application, Blundell and Bond return to the employment equation, using the
same dataset as in Arellano and Bond, and we follow suit. This time, the authors drop
the longest (two-period) lags of employment and capital from their model, and dispense
with sector-wide demand altogether. They also switch to treating wages and capital
as potentially endogenous, generating GMM-style instruments for them. The xtabond2
command line for a one-step estimate is

```text
     . xtabond2 n L.n L(0/1).(w k) yr*, gmmstyle(L.(n w k))
     > ivstyle(yr*, equation(level)) robust small
     Favoring space over speed. To switch, type or click on mata: mata set matafavor
     > speed, perm.
     yr1976 dropped due to collinearity
     yr1984 dropped due to collinearity
     Warning: Two-step estimated covariance matrix of moments is singular.
       Using a generalized inverse to calculate robust weighting matrix for Hansen
     > test.
       Difference-in-Sargan statistics may be negative.
     Dynamic panel-data estimation, one-step system GMM
```

```text
      Group variable: id                                  Number of obs      =            891
      Time variable : year                                Number of groups   =            140
      Number of instruments = 113                         Obs per group: min =              6
      F(12, 139)    =    1154.36                                         avg =           6.36
      Prob > F      =      0.000                                         max =              8
```

Robust
                  n         Coef.   Std. Err.        t    P>|t|      [95% Conf. Interval]

n
               L1.      .9356053     .026569      35.21   0.000      .8830737       .9881369
                 w
               --.     -.6309761    .1192834      -5.29   0.000     -.8668206      -.3951315
               L1.      .4826203    .1383132       3.49   0.001      .2091504       .7560901
                 k
               --.      .4839299    .0544281       8.89   0.000      .3763159        .591544
               L1.     -.4243928     .059088      -7.18   0.000     -.5412204      -.3075653
            yr1977     -.0240573    .0296969      -0.81   0.419     -.0827734       .0346588
            yr1978     -.0176523    .0229277      -0.77   0.443     -.0629845       .0276799
            yr1979     -.0026515    .0207492      -0.13   0.899     -.0436764       .0383735
            yr1980     -.0173995    .0221715      -0.78   0.434     -.0612366       .0264376
            yr1981     -.0435283    .0193348      -2.25   0.026     -.0817565         -.0053
            yr1982     -.0096193    .0186829      -0.51   0.607     -.0465588       .0273201
            yr1983      .0038132    .0171959       0.22   0.825     -.0301861       .0378126
             _cons      .5522011    .1971607       2.80   0.006      .1623793       .9420228

Instruments for first differences equation
        GMM-type (missing=0, separate instruments for each period unless collapsed)
          L(1/.).(L.n L.w L.k)
Instruments for levels equation
        Standard
          _cons
          yr1976 yr1977 yr1978 yr1979 yr1980 yr1981 yr1982 yr1983 yr1984
        GMM-type (missing=0, separate instruments for each period unless collapsed)
          D.(L.n L.w L.k)

$$
Arellano-Bond test for AR(1) in first differences: z =       -5.46      Pr > z =   0.000
      Arellano-Bond test for AR(2) in first differences: z =       -0.25      Pr > z =   0.804
$$

```text
      Sargan test of overid. restrictions: chi2(100) = 186.90 Prob > chi2 = 0.000
        (Not robust, but not weakened by many instruments.)
      Hansen test of overid. restrictions: chi2(100) = 110.70 Prob > chi2 = 0.218
        (Robust, but can be weakened by many instruments.)
      Difference-in-Hansen tests of exogeneity of instrument subsets:
        GMM instruments for levels
          Hansen test excluding group:     chi2(79)   = 84.33 Prob > chi2 = 0.320
          Difference (null H = exogenous): chi2(21)   = 26.37 Prob > chi2 = 0.193
        iv(yr1976 yr1977 yr1978 yr1979 yr1980 yr1981 yr1982 yr1983 yr1984, eq(level))
          Hansen test excluding group:     chi2(93)   = 107.79 Prob > chi2 = 0.140
          Difference (null H = exogenous): chi2(7)    =    2.91 Prob > chi2 = 0.893
```

These estimates do not match the published ones, in part because Blundell and
Bond set H = I instead of using the form in (26).17 The new point estimate of the
coefficient on lagged employment is higher than that at the end of section 3.3 though

17. One could add an h(1) option to the command line to mimic their choice.

not statistically different with reference to the previous standard errors. Moreover, the
new coefficient estimate is within the bracketing LSDV - OLS range of 0.733-1.045, and
the reported standard error is half its previous value.

3.5    Testing for autocorrelation
The Sargan/Hansen test for joint validity of the instruments is standard after GMM
estimation. In addition, Arellano and Bond develop a test for a phenomenon that would
render some lags invalid as instruments, namely, autocorrelation in the idiosyncratic
disturbance term, vit . Of course, the full disturbance, εit , is presumed autocorrelated
because it contains fixed effects, and the estimators are designed to eliminate this source
of trouble. But if the vit are themselves serially correlated of order 1 then, for instance,
yi,t-2 is endogenous to the vi,t-1 in the error term in differences, Δεit = vit - vi,t-1 ,
making it a potentially invalid instrument after all. The researcher would need to restrict
the instrument set to lags 3 and longer of y-unless the researcher found order-2 serial
correlation, in which case he or she would need to start with even longer lags.
To test for autocorrelation aside from the fixed effects, the Arellano-Bond test is
applied to the residuals in differences. Because Δvit is mathematically related to Δvi,t-1
via the shared vi,t-1 term, negative first-order serial correlation is expected in differences
and evidence of it is uninformative. Thus to check for first-order serial correlation in
levels, we look for second-order correlation in differences, on the idea that this will
detect correlation between the vi,t-1 in Δvit and the vi,t-2 in Δvi,t-2 . In general, we
check for serial correlation of order l in levels by looking for correlation of order l + 1
in differences. Such an approach would not work for orthogonal deviations because all
residuals in deviations are mathematically interrelated, depending as they do on many
forward “lags”. So even after estimation in deviations, the test is run on residuals in
differences.
The Arellano-Bond test for autocorrelation is actually valid for any GMM regression
on panel data, including OLS and 2SLS, as long as none of the regressors is “postde-
termined”, depending on future disturbances. (A fixed-effects or within-groups regres-
sion can violate this assumption if T is small.) Also we must assume that errors are
not correlated across individuals.18 The abar command makes the test available after
regress, ivregress, ivreg2, newey, and newey2. So, in deriving the test, we will refer
to a generic GMM estimate, βA , applied to a dataset, X, Y, Z, which may have been

pretransformed; the estimator yields residuals E.

18. For similar reasons, the test appears appropriate for ergodic time series.

If W is a data matrix, let W-l be its l lag, with zeroes for't ≤ l. The Arellano-
Bond autocorrelation test is based on the inner product (1/N ) E -l E
                                                                      i , which is zero
                                                                  i
                                                                 i
in expectation under the null of zero order-l serial correlation. Assuming errors are
sufficiently uncorrelated across individuals, a central limit theorem assures that the
statistic
                           √ 1  -l
                             N         E
                                      E    i = √1 E
                                                      -l E                      (27)
                                       i
                               N i                N
is asymptotically normally distributed. For the tendency toward normality to set in,
only N , not T , needs be large.
To estimate the asymptotic variance of the statistic under the null, Arellano and
Bond start like the Windmeijer derivation above, expressing the quantity of interest
as a deviation from the theoretical
                                 valueit approximates. In particular, because Y =

$$
X\beta + E = X\beta + E, E = E - X \betaA - \beta . Substituting into (27) gives
$$

$$
1  -l         1  -l                                 
 \sqrt E    E =      \sqrt     E - X-l i    \betaA - \beta      E - X \betaA - \beta
  N                N
                              E-l X \sqrt           
$$

1
             = √ E-l E -                N βA - β                              (28)
                   N             N
                  √           X-l  E √             1 X-l  X √          
                 - N βA - β             + N βA - β √               N βA - β
                                    N                      N N
                                                                 √
The last two terms drop out as N → ∞. Why?
                                 √             Because βA is a N -consistent esti-
mate of β (Ruud 2000, 546), the N βA - β terms neither diverge nor converge to

0. Meanwhile, assuming x is not postdetermined, X-l E/N goes to 0, which eliminates

the third term. For similar reasons, assuming that X-l X/N does not diverge, the
fourth term goes to zero. If we then substitute (3) into the second  term, the expres-
                          √       -l       -l
                                                      -1
sion converges to (1/ N ) E E - E X X ZAZ X                   X ZAZ E , whose variance
is consistently estimated by
                                                                          
                                                     
√
1
            E -l Var
                    E     |Z E         -l X X ZAZ X -1 X ZAZ Var
                                 -l - 2E                            E    |Z E -l
N
                                             
                     -l                  -l

+E XAvar βA X E

(Arellano and Bond 1991). Dividing this value into (27) to normalize it yields the
Arellano-Bond z test for serial correlation of order l.
For difference and system GMM, terms in this formula map as follows. E    -l contains
lagged, differenced errors, with observations for the levels data zeroed out in system
GMM because they are not the basis for the test. X and Z hold the transformed and, in
system GMM, augmented
                         dataset used in the estimation. In one-step, nonrobust esti-

mation, Var E | Z is σ H, where σ
                        2
                                    is a consistent estimate of the standard deviation

 
of the errors in levels. Otherwise, Ω                    βA is set to the reported
                                     b is substituted. Avar
                                      β1
variance matrix-robust or not, Windmeijer-corrected or not.19
There are two important lessons here for the researcher. The first is another reminder
of the importance of time dummies in preventing the most likely form of cross-individual
correlation: contemporaneous correlation. The second lesson is that the test depends
on the assumption that N is large. Large has no precise definition, but applying it to
panels with N = 20, for instance, seems worrisome.
In their difference GMM regressions on simulated 7×100 panels with AR(1), Arellano
and Bond find that their test has greater power than the Sargan and Hansen tests to
detect lagged instruments being made invalid through autocorrelation. However, the
test does break down as the correlation falls to 0.2, where it rejects the null of no serial
correlation only half the time.

4     Implementation
4.1    Syntax
The original implementation of difference GMM is the DPD package, written in the Gauss
programming language (Arellano and Bond 1998). An update, DPD98, incorporates
system GMM. DPD has also been implemented in the Ox language (Doornik, Arellano,
and Bond 2006). In 2001, StataCorp shipped xtabond in Stata 7. It performed difference
GMM but not system GMM nor the Windmeijer correction. In late 2003, I set out to
add these features. In the end, I revamped the code and syntax and added other
options. xtabond2 was and is compatible with Stata version 7 and later. I also wrote
abar to make the Arellano-Bond autocorrelation test available after other estimation
commands. Stata 10, shipped in mid-2007, incorporated many features of xtabond2,
via a revised xtabond and the new xtdpd and xtdpdsys commands. Unlike the official
Stata commands, which have computationally intensive sections precompiled, the first
versions of xtabond2 were written purely in Stata’s interpreted ado language, which
made it slow. In late 2005, I implemented xtabond2 afresh in the Mata language
shipped with Stata 9; the Mata version runs much faster, though not as fast as the
built-in commands. The two xtabond2 implementations are bundled together, and the
ado version automatically runs if Mata is not available.20

“      ”
                                                                           d E
19. In one-step, nonrobust estimation in orthogonal deviations, the second Var   b | Z is actually set

to M⊥ MΔ  in difference GMM and M+         +
                                          ⊥ MΔ in system GMM.
20. The Mata code requires Stata 9.1 or later. Version 9.0 users will be prompted to upgrade for free.

The syntax for xtabond2 is

xtabond2 depvar varlist          if         in         weight         , level(#) twostep robust
cluster(varname) noconstant small noleveleq orthogonal artests(#)

arlevels h(#) nodiffsargan nomata ivopt ivopt . . . gmmopt gmmopt

```text
      ...
```

where ivopt is

ivstyle(varlist        , equation(diff | level | both) passthru mz )

and gmmopt is

gmmstyle(varlist   , laglimits(a b) collapse equation(diff | level | both)

passthru split )

All varlists can include time-series operators, such as L., and wildcard expressions,
such as I*.
The if and in qualifiers restrict the estimation sample, but they do not restrict the
sample from which lagged variables are drawn for instrument construction. weight also
follows Stata conventions; analytical weights (aweights), sampling weights (pweights),
and frequency weights (fweights) are accepted. Frequency weights must be constant
over time. (See the appendix for details.)

The level(), robust, cluster(), noconstant, and small options are also mostly
standard. level() controls the size of the reported confidence intervals, the default
being 95%. In one-step GMM, xtabond2’s robust option is equivalent to cluster(id)
in most other estimation commands, where id is the panel identifier variable, requesting
standard errors that are robust to heteroskedasticity and arbitrary patterns of autocor-
relation within individuals; in two-step estimation, where the errors are already robust,
robust triggers the Windmeijer correction. cluster() overrides the default use of the
panel identifier (as set by tsset) as the basis for defining groups. It implies robust in
the senses just described. Changing the clustering variable with this option affects one-
step “robust” standard errors, all two-step results, the Hansen and difference-in-Hansen
tests, and the Arellano-Bond serial correlation tests. cluster() is available only in
the Mata version of xtabond2, which requires Stata 9 or later. noconstant excludes
the constant term from X and Z; however, it has no effect in difference GMM because
differencing eliminates the constant anyway.21 small requests small-sample corrections
to the covariance matrix estimate, resulting in t-test instead of z-test statistics for the
coefficients and an F test instead of a Wald χ2 test for overall fit.
Most of the other options are straightforward. nomata prevents the use of the Mata
implementation even when it is available, in favor of the ado program. twostep requests
two-step FEGMM, one-step GMM being the default. noleveleq invokes difference in-
stead of system GMM, which is the default. nodiffsargan prevents reporting of certain
difference-in-Sargan/Hansen statistics (described below), which are computationally in-
tensive because they involve reestimating the model for each test. It has effect only in
the Mata implementation, because only that version performs the tests. orthogonal,
also meaningful only for the Mata version, requests the forward orthogonal-deviations
transform instead of first differencing. artests() sets the maximum lag distance to
check for autocorrelation, the default being 2. arlevels requests that the Arellano-
Bond autocorrelation test be run on the levels residuals instead of the differenced ones;
it applies only to system GMM and makes sense only in the unconventional case where
it is believed that there are no fixed effects whose own autocorrelation would mask
any in the idiosyncratic errors. The h(#) option, which most users can safely ignore,
controls the choice of H. h(1) sets H = I, for both difference and system GMM. For
difference GMM, h(2) and h(3) coincide, making the matrix in (22). They differ for
system GMM, however, with h(2) imitating DPD for Ox and h(3) being the xtabond2
default, according to (26) (see the end of section 3.4).

21. Here xtabond2 differs from xtabond, xtdpd, and DPD, which by default enter the constant in
difference GMM after transforming the data. DPD does the same for time dummies. xtabond2
avoids this practice for several reasons. First, in Stata, it is more natural to treat time dummies,
typically created with xi, like any other regressor, transforming them. Second, introducing the
constant term after differencing is equivalent to entering t as a regressor before transformation,
which may not be what users intend. By the same token, it introduces an inconsistency with
system GMM: in DPD and xtdpdsys, when doing system GMM, the constant term enters only
in the levels equation, and in the usual way; it means 1 rather than t. Thus switching between
difference and system GMM changes the model. However, these problems are minor as long as a full
set of time dummies is included. Because the linear span of the time dummies and the constant
term together is the same as that of their first differences or orthogonal deviations, it does not
matter much whether the time dummies and constant enter transformed or not.

The most important thing to understand about the xtabond2 syntax is that un-
like most Stata estimation commands, including xtabond, the variable list before the
comma communicates no identification information. The first variable defines Y and
the remaining ones define X. None of them say anything about Z even though X and
Z can share columns. Designing the instrument matrix is the job of the ivstyle()
and gmmstyle() options after the comma, each of which can be listed multiple times
or not at all. (noconstant also affects Z in system GMM.) As a result, most regressors
appear twice in a command line, once before the comma for inclusion in X and once
after as a source of IV- or GMM-style instruments. Variables that serve only as excluded
instruments appear once, in ivstyle() or gmmstyle() options after the comma.
The standard treatment for strictly exogenous regressors or IV-style excluded in-
struments, say, w1 and w2, is ivstyle(w1 w2). This generates one column per variable,
with missing not replaced by 0. In particular, strictly exogenous regressors ordinarily
instrument themselves, appearing in both the variable list before the comma and in an
ivstyle() option. In difference GMM, these IV-style columns are transformed unless
the user specifies ivstyle(w1 w2, passthru). ivstyle() also generates one column
per variable in system GMM, following (24). The patterns in (25) can be requested with
the equation() suboption, as in ivstyle(w1 w2, equation(level)) and the com-
pound ivstyle(w1 w2, equation(diff)) ivstyle(w1 w2, equation(level)). The
mz suboption instructs xtabond2 to substitute zero for missing in the generated IV-style
instruments.
Similarly, the gmmstyle() option includes a list of variables, then suboptions after
a comma that control how the variables enter Z. By default, gmmstyle() generates
the instruments appropriate for predetermined variables: lags 1 and earlier of the in-
strumenting variable for the transformed equation and, for system GMM, lag 0 of the
instrumenting variable in differences for the levels equation. The laglimits() subop-
tion overrides the defaults on lag range. For example, gmmstyle(w, laglimits(2 .))
specifies lags 2 and longer for the transformed equation and lag 1 for the levels equation,
which is the standard treatment for endogenous variables. In general, laglimits(a b)
requests lags a through b of the levels as instruments for the transformed data and lag
a - 1 of the differences for the levels data. a and b can each be missing (“.”). a defaults
to 1 and b to infinity, so that laglimits(. .) is equivalent to leaving the suboption out
altogether. a and b can even be negative, implying forward “lags”. If a > b, xtabond2
swaps their values.22 Because the gmmstyle() varlist allows time-series operators, there
are many routes to the same specification. For example, if w1 is predetermined and
w2 endogenous, then instead of gmmstyle(w1) gmmstyle(w2, laglimits(2 .)), one
could simply type gmmstyle(w1 L.w2). In all these instances, the suboption collapse
is available to “collapse” the instrument sets as described in sections 3.2 and 3.4.

22. If a ≤ b < 0, then lag b - 1 of the differences is normally used as an instrument in the levels
equations instead of that dated a - 1, because it is more frequently in the range [1, T ] of valid time
indexes. Or, for the same reasons, if a ≤ 0 ≤ b or b ≤ 0 ≤ a, the contemporaneous difference is
used. Tue Gørgens developed these decision rules.

gmmstyle() also has equation() and passthru suboptions, which work much like
their ivstyle() counterparts. The exception is that equation(level), by blocking the
generation of the instruments for the transformed equation, causes xtabond2 to generate
a full GMM-style set of instruments for the levels equation because they are no longer
mathematically redundant.23 passthru prevents the usual differencing of instruments
for the levels equation. As with arlevels, this produces invalid results under standard
assumptions. A final suboption, split, is explained below.
Along with the standard estimation results, xtabond2 reports the Sargan/Hansen
test, Arellano-Bond autocorrelation tests, and various summary statistics. Sample size
is not an entirely well-defined concept in system GMM, which runs in effect on two
samples simultaneously. xtabond2 reports the size of the transformed sample after
difference GMM and of the untransformed sample after system GMM.
The Mata implementation carries out certain difference-in-Sargan/Hansen tests un-
less nodiffsargan is specified. In particular, it reports a difference-in-Sargan/Hansen
test for each instrument group defined by an ivstyle() or gmmstyle() option, when
feasible. So a clause like gmmstyle(x y) implicitly requests one test for this entire in-
strument group, while gmmstyle(x) gmmstyle(y) requests the same estimates but two
more-targeted difference-in-Sargan/Hansen tests. In system GMM, a split suboption
in a gmmstyle() option instructs xtabond2 to subject the transformed- and levels-
equation instruments within the given GMM-style group to separate difference tests.
This facilitates testing of the instruments of greatest concern in system GMM, those for
the levels equation based on the dependent variable. The Mata version also tests all the
GMM-style instruments for the levels equation as a group.24

The Mata version of xtabond2 responds to one option that is not set in the command
line, namely, the Mata system parameter matafavor. When this is set to speed (which
can be done by typing mata: mata set matafavor speed, permanently at the Stata
prompt), the Mata code builds a complete internal representation of Z.25 If there are
1,000 observations and 100 instruments, then Z will contain some 200,000 elements
in system GMM, each of which will take 8 bytes in Mata, for a total of roughly 1.5

23. Because an ordinary gmmstyle(w, laglimits(a b)) command in system GMM requests lags a
through b of w as instruments for the transformed equation and lag a-1 of Δw for the levels equation,
for consistency, xtabond2, in versions 1.2.8 and earlier, interpreted gmmstyle(w, laglimits(a b)
equation(level)) to request lags a - 1 through b - 1 of Δw for the levels equation. But with
version 2.0.0, the interpretation changed to lags a through b.
24. The reported differences in Sargan/Hansen will generally not match what would be obtained by
manually running the estimation with and without the suspect instruments. Recall from section 2.3
that in the full, restricted regression, the moment weighting matrix is the inverse of the estimated
covariance of the moments, call it S, b which is Z HZ in one-step and Z Ω
                                                                              b b Z in two-step. In the
                                                                                β1
unrestricted regressions carried out for testing purposes, xtabond2 weights using the submatrix of
the restricted Sb corresponding to the nonsuspect instruments. This reduces the chance of a neg-
ative test statistic (Baum, Schaffer, and Stillman [2003, 18], citing Hayashi [2000]). As described
in section 2.6, adding instruments weakens the Sargan/Hansen test and can actually reduce the
statistic, which is what makes negative differences in Sargan/Hansen more likely if the unrestricted
regression is fully reestimated.
25. Despite the speed setting, there is a delay the first time the Mata version of xtabond2 runs in a
Stata session, because Stata loads the function library.

megabytes. Larger panels can exceed a computer’s physical memory and actually even
slow Mata down because the operating system is forced to repeatedly cache parts of Z to
the hard drive and then reload them. Setting matafavor to space causes the program
to build and destroy submatrices Zi for each individual “on the fly”. The Mata code
in this mode can be even slower than the ado version, but because the ado version also
builds a full representation of Z, the Mata code in space mode still has the advantage
of conserving memory.
The Mata and ado implementations should generate identical results. However, if
some regressors are nearly or fully multicollinear, the two may disagree on the number
and choice of regressors to drop. Because floating-point representations of numbers have
finite precision, even exactly collinear variables may not quite appear that way to the
computer, and algorithms for identifying them must look for “near-multicollinearity”.
There is no one right definition for that term, and the identification can be sensitive to
the exact procedure. Where the ado program calls the built-in Stata command rmcoll,
the Mata program must use its own procedure, which differs in logic and tolerances.26
As a Stata estimation command, xtabond2 can be followed by predict:

predict              type       newvarname        if         in         , statistic difference

where statistic is xb or residuals. The optional type clause controls the data type of

the variable generated. Requesting the xb statistic, the default, essentially gives Xβ,

where β is the parameter vector from the estimation. However, difference GMM never
estimates a coefficient on the constant term, so predict can predict the dependent
variable only up to a constant. To compensate, after difference GMM predict adds a
constant to the series chosen to give it the same average as Y. Putting residuals in the
command line requests Y - Xβ,   where the Xβ again will be adjusted. The difference
option requests predictions and residuals in differences.
The syntax for the postestimation command abar is

abar        if         in         , lags(#)

The lags() option works like xtabond2’s artests() option except that it defaults
to 1. abar can run after regress, ivregress, ivreg2, newey, and newey2. It tests for
autocorrelation in the estimation errors, undifferenced.

4.2      More examples
A simple autoregressive model with no controls except time dummies would be fit by

```text
        . xi: xtabond2 y L.y i.t, gmmstyle(L.y) ivstyle(i.t) robust noleveleq
```

26. The Mata version will not perfectly handle strange and unusual expressions like gmmstyle(L.x,
laglimits(-1 -1)). This is the same as gmmstyle(x, laglimits(0 0)) in principle. But the
Mata code will interpret it by lagging x, thus losing the observation of x for t = T , and then
unlagging the remaining information. The ado version does not lose data in this way.

```text
where t is the time variable. This would run one-step difference GMM with robust
errors. If w1 is strictly exogenous, w2 is predetermined but not strictly exogenous, and
w3 is endogenous, then
     . xi: xtabond2 y L.y w1 w2 w3 i.t, gmmstyle(L.y w2 L.w3) ivstyle(i.t w1)
     > twostep robust small orthogonal
```

```text
would fit the model with the standard choices of instruments-here with two-step system
GMM, Windmeijer-corrected standard errors, small-sample adjustments, and orthogonal
deviations.
   If the user runs system GMM without declaring instruments that are nonzero for
the transformed equation, then the estimation is effectively run on levels only. More-
over, though it is designed for dynamic models, xtabond2 does not require the lagged
dependent variable to appear on the right-hand side. As a result, the command can
perform OLS and 2SLS. Following are pairs of equivalents, all of which can be run on the
Arellano-Bond dataset:
     . regress n w k
     . abar
     . xtabond2 n w k, ivstyle(w k, equation(level)) small arlevels artests(1)
     . ivreg2 n cap (w = k ys), cluster(id)
     . abar, lags(2)
     . xtabond2 n w cap, ivstyle(cap k ys, equation(level)) small robust arlevels
     . ivreg2 n cap (w = k ys), cluster(id) gmm
     . abar
     . xtabond2 n w cap, ivstyle(cap k ys, equation(level)) twostep artests(1) arlevels
```

```text
    The only value in such tricks is that they make the Windmeijer correction available
for linear GMM regressions more generally.
   xtabond2 can replicate results from comparable packages. Here is a matching triplet:
     . xtabond n, lags(1) pre(w, lagstruct(1,.)) pre(k, endog) robust
     . xtdpd n L.n w L.w k, dgmmiv(w k n) vce(robust)
     . xtabond2 n L.n w L.w k, gmmstyle(L.(w n k), eq(diff)) robust
```

```text
   To exactly match difference GMM results from DPD for Gauss and Ox, one must also
create variables that become the constant and time dummies after transformation, to
mimic the way DPD enters these variables directly into the difference equation. This
example exactly imitates the regression for column a1 in table 4 of Arellano and Bond
(1991):
     .forvalues y = 1979/1984 { /* Make variables whose differences are time dummies */
     2.    gen yr`y´c = year>=`y´
     3. }
     . gen cons = year
     . xtabond2 n L(0/1).(L.n w) L(0/2).(k ys) yr198?c cons, gmmstyle(L.n)
     > ivstyle(L(0/1).w L(0/2).(k ys) yr198?c cons) noleveleq noconstant small
     > robust
```

For system GMM, these gymnastics are unnecessary because DPD enters the constant
and time dummies directly into the levels equation, not the difference one. These two

commands exactly reproduce a version of Blundell and Bond’s (1998) regression 4, table
4, included in a demonstration file shipped with DPD for Ox:27

```text
        . xtdpd n L.n L(0/1).(w k) yr1978-yr1984, dgmm(w k n) lgmm(w k n)
        > liv(yr1978-yr1984) vce(robust) two hascons
        . xtabond2 n L.n L(0/1).(w k) yr1978-yr1984, gmmstyle(L.(w k n))
        > ivstyle(yr1978-yr1984, equation(level)) h(2) robust twostep small
```

More replications from the regressions in the Arellano and Bond (1998) and Blundell
and Bond (1998) articles are in two ancillary files that come with xtabond2: abest.do
and bbest.do. In addition, greene.do reproduces an example in Greene (2003, 554).28

5       Conclusion
By way of conclusion, I offer a few pointers on the use of difference and system GMM,
however implemented. Most of these are discussed above.

• Apply the estimators to “small T , large N ” panels. If T is large, dynamic panel
        bias becomes insignificant, and a more straightforward fixed-effects estimator
        works. Meanwhile, the number of instruments in difference and system GMM
        tends to explode with T . If N is small, the cluster-robust standard errors and
        the Arellano-Bond autocorrelation test may be unreliable.

• Include time dummies. The autocorrelation test and the robust estimates of the
        coefficient standard errors assume no correlation across individuals in the idiosyn-
        cratic disturbances. Time dummies make this assumption more likely to hold.

• Use orthogonal deviations in panels with gaps. This maximizes sample size.

• Ordinarily, put every regressor into the instrument matrix, Z, in some form. If a
        regressor, w, is strictly exogenous, standard treatment is to insert it as one column
        (in xtabond2, with ivstyle(w)). If w is predetermined to not be strictly exoge-
        nous, standard treatment is to use lags 1 and longer, GMM-style (gmmstyle(w)).
        And if w is endogenous, standard treatment is lags 2 and longer (gmmstyle(L.w)).

• Before using system GMM, ponder the required assumptions. The validity of the
        additional instruments in system GMM depends on the assumption that changes in
        the instrumenting variables are uncorrelated with the fixed effects. In particular,
        they require that throughout the study period, individuals sampled are not too
        far from steady states, in the sense that deviations from long-run means are not
        systematically related to fixed effects.

• Mind and report the instrument count. As discussed in section 2.6 and Rood-
        man (2009), instrument proliferation can overfit endogenous variables and fail to
        expunge their endogenous components. Ironically, it also weakens the power of
27. In the command file bbest.ox.
28. To download them into your current directory, type net get xtabond2 in Stata.

the Hansen test to detect this very problem and to detect invalidity of the sys-
tem GMM instruments, whose validity should not be taken for granted. Because
the risk is high with these estimators, researchers should report the number of
instruments and reviewers should question regressions where it is not reported. A
telltale sign is a perfect Hansen statistic of 1.000. Researchers should also test for
robustness to severely reducing the instrument count. Options include limiting
the lags used in GMM-style instruments and, in xtabond2, collapsing instruments.
Also, because of the risks, do not take comfort in a Hansen test p-value below 0.1.
View higher values, such as 0.25, as potential signs of trouble.

• Report all specification choices. Using these estimators involves many choices,
and researchers should report the ones they make-difference or system GMM;
first differences or orthogonal deviations; one- or two-step estimation; nonrobust,
cluster-robust, or Windmeijer-corrected cluster-robust errors; and the choice of
instrumenting variables and lags used.

6    Acknowledgments
I thank Manuel Arellano, Christopher Baum, Michael Clemens, Decio Coviello, Mead
Over, Mark Schaffer, and one anonymous reviewer for comments. I also thank all the
users whose feedback has led to steady improvement in xtabond2.

7    References
Anderson, T. G., and B. E. Sørenson. 1996. GMM estimation of a stochastic volatility
model: A Monte Carlo study. Journal of Business & Economic Statistics 328-352.

Anderson, T. W., and C. Hsiao. 1982. Formulation and estimation of dynamic models
using panel data. Journal of Econometrics 18: 47-82.

Arellano, M., and S. Bond. 1991. Some tests of specification for panel data: Monte
Carlo evidence and an application to employment equations. Review of Economic
Studies 58: 277-297.

---. 1998. Dynamic panel data estimation using DPD98 for Gauss: A guide for users.
Mimeo. Available at ftp://ftp.cemfi.es/pdf/papers/ma/dpd98.pdf.

Arellano, M., and O. Bover. 1995. Another look at the instrumental variable estimation
of error-components models. Journal of Econometrics 68: 29-51.

Baum, C. F., M. E. Schaffer, and S. Stillman. 2003. Instrumental variables and GMM:
Estimation and testing. Stata Journal 3: 1-31.

Beck, T., and R. Levine. 2004. Stock markets, banks, and growth: Panel evidence.
Journal of Banking and Finance 28: 423-442.

Blundell, R., and S. Bond. 1998. Initial conditions and moment restrictions in dynamic
panel data models. Journal of Econometrics 87: 115-143.
Bond, S. 2002. Dynamic panel data models: A guide to micro data methods and
practice. Working Paper CWP09/02, Cemmap, Institute for Fiscal Studies. Available
at http://cemmap.ifs.org.uk/wps/cwp0209.pdf.
Bowsher, C. G. 2002. On testing overidentifying restrictions in dynamic panel data
models. Economics Letters 77: 211-220.
Calderón, C. A., A. Chong, and N. V. Loayza. 2002. Determinants of current account
deficits in developing countries. Contributions to Macroeconomics 2: Article 2.
Doornik, J. A., M. Arellano, and S. Bond. 2006. Panel data estimation using DPD for
Ox. Available at http://www.doornik.com/download/dpd.pdf.
Greene, W. H. 2003. Econometric Analysis. 5th ed. Upper Saddle River, NJ: Prentice
Hall.
Hansen, L. P. 1982. Large sample properties of generalized method of moments estima-
tors. Econometrica 50: 1029-1054.
Hayashi, F. 2000. Econometrics. Princeton, NJ: Princeton University Press.
Holtz-Eakin, D., W. Newey, and H. S. Rosen. 1988. Estimating vector autoregressions
with panel data. Econometrica 56: 1371-1395.
Judson, R. A., and A. L. Owen. 1999. Estimating dynamic panel data models: A guide
for macroeconomists. Economics Letters 65: 9-15.
Kiviet, J. F. 1995. On bias, inconsistency, and efficiency of various estimators in dynamic
panel data models. Journal of Econometrics 68: 53-78.
Moran, T. H., E. M. Graham, and M. Blomström. 2005. Does Foreign Direct Investment
Promote Development? Washington, DC: Institute for International Economics.
Nickell, S. J. 1981. Biases in dynamic models with fixed effects. Econometrica 49:
1417-1426.
Roodman, D. M. 2009. A note on the theme of too many instruments. Oxford Bulletin
of Economics and Statistics 71: 135-158.
Ruud, P. A. 2000. An Introduction to Classical Econometric Theory. Oxford: Oxford
University Press.
Sargan, J. D. 1958. The estimation of economic relationships using instrumental vari-
ables. Econometrica 26: 393-415.
Windmeijer, F. 2005. A finite sample correction for the variance of linear efficient
two-step GMM estimators. Journal of Econometrics 126: 25-51.

About the author
David Roodman is a research fellow at the Center for Global Development in Washington, DC.

Appendix. Incorporating observation weights
This appendix shows how weights enter the equations for GMM, the Windmeijer cor-
rection, and the Arellano-Bond autocorrelation test. Along the way, it fills a gap in
section 2.4 in the derivation of the Windmeijer correction.
Stata supports several kinds of weights. Each has a different conceptual basis, but
the implementations work out to be almost identical. In contrast to the matrix A used
in the main text to weight moments, the weights discussed here apply at the level of
observations. They are assumed to be exogenous.

A.1 Analytical weights
The premise of “analytical weights” (a term coined by Stata), or aweights, is that
each observation is an average of some varying number of underlying data points. For
example, the observations might be average reading scores in classes of different sizes. If
the errors in the underlying data are homoskedastic, then those of the observations will
not be but rather will have variance inversely proportional to the number of data points
averaged. Weighting by that number is a classic way to restore homoskedasticity, thus
efficiency for the coefficient estimates and consistency for the standard-error estimates.
Introducing analytical weights starts with two changes to the exposition of linear
GMM in section 2. Let w be the weighting variable, assumed to be exogenous, and W
be a diagonal N × N matrix holding the weights, normalized so that they sum to N .
(Here, as in section 2, N is number of observations, not individuals.) First, the GMM
criterion function in (1) becomes
                                                                  
                              1                    1        1
            EN (zε)    A =      Z WE     A ≡N          Z WE A     Z WE
                              N                      N          N
                             1
                         =     E WZAZW E                                             (1 )
                             N

Following the derivation in the main text, this implies the weighted GMM estimator,

$$
-1
                         \beta = (X WZAZ WX) X ZAZ WY                                (2 )
$$

$$
A proof like that in section 2.2 shows that the efficient choice of A is
                                                              -1
                                                         1
                      AEGMM = Var (zw\varepsilon) = Avar             Z WE                       (4 )
                                                         N
$$

$$
so that EGMM is given by
                                      -1
        \betaEGMM = X WZ Var (zw\varepsilon) Z WX
                                -1                        -1
                                           X WZ Var (zw\varepsilon) Z WY                      (5 )
$$

$$
and FEGMM in general by
                           -1     -1             -1
   \betaFEGMM =
                  X WZ Z W\OmegaWZ
                                 Z WX
                                         X WZ Z W\OmegaWZ    Z WY
                                                                                    (11 )
$$

For analytical weights, we then introduce a second change to the math. For the first
step in FEGMM, we incorporate the heteroskedasticity assumption by replacing H, the
arbitrary initial approximation of Ω based on the assumption of homoskedasticity, with
W-(1/2) HW(1/2) . As a result, the recipe for FEGMM becomes
                      -1     -1                   -1
β1 =
                   1  1                        1    1

X WZ Z W HW Z
                   2  2     Z WX    X WZ Z W 2 HW 2 Z    Z WY

$$
\beta2 = \betaFEGMM
                     -1      -1                -1
$$

$$
= X WZ Z W\Omega\betab1 WZ
                           Z WX                b WZ
                                    X WZ Z W\Omega         Z WY (13 )
                                                \beta1
$$

$$
For 2SLS, where H = I, \beta1 is efficient, and simplifies to
                                         -1
                                   -1                      -1
             \beta2SLS = X WZ (Z WZ) Z WX     X WZ (Z WZ) Z WY
$$

The classical variance estimate for the one- or two-step estimator is
                                        -1       -1
                     β | Z = X WZ Z WΩWZ
                    Var                        Z WX                               (29)

where Ω = W-(1/2) HW-(1/2) or Ω
                                b . And the robust one-step estimator is given by a
                                β1
typical sandwich formula:
                                               -1
               r β1 = Var
              Var        β · X WZ Z W 12 HW 21 Z    Z WΩ b WZ
                                                               β1
                                          -1              
                                   1    1
                            × Z W 2 HW 2 Z             β
                                               Z WX · Var                          (15 )

Paralleling the main text, the Windmeijer correction is derived as follows:
                                       -1      -1
                           ≡ X WZ Z WΩWZ
                     g Y, Ω                   Z WX
                                                  -1

× X WZ Z WΩWZ    Z WE                        (16 )

                          
                                       β + Dg Y, W- 12 HW- 12
                               ≈ g Y, Ω                                             (17 )

$$
       
                b /∂ \beta | b . Repeatedly applying the identity
where D =∂g Y, \Omega \beta         \beta=\beta
∂(A-1 )/∂b = -A-1 · ∂A/∂b · A-1 , D is the matrix whose pth column is
                -1      -1                -1      bb
                                                       ∂\Omega
$$

$$
- X WZ Z W\Omega\beta WZ
                      Z WX                \beta WZ
                               X WZ Z W\Omega         Z W b\beta | \beta=\beta
                                                             b               ∂ \betap
                                         -1
                                     \beta WZ
                            ×WZ Z W\Omega         Z WE
$$

            -1      -1                -1      bb
                                                       ∂Ω

$$
+ X WZ Z W\Omega\beta WZ
                      Z WX                \beta WZ
                               X WZ Z W\Omega         Z W b\beta | \beta=\beta
                                                             b               ∂ \betap
                                    -1               
                                \beta WZ
                       ×WZ Z W\Omega
                                         Z WX · g Y, \Omega
$$

For feasibility, Windmeijer (2005) substitutes Ω        β in this, β1 for β, and E
                                                b for Ω                            2 for
                                               β1
E. As a result, g Y, Ω becomes

              -1     -1                -1

X WZ Z WΩβb1 WZ
                          Z WX               b WZ
                                  X WZ Z WΩ             2
                                                      Z WE
                                              β1

which is the projection of the two-step residuals by the two-step estimator and is exactly
zero. So the second term falls out and the feasible approximation D  is the matrix whose
pth column is
               -1      -1                    -1      bb
                                                             ∂Ω
               b WZ
- X WZ Z WΩ         Z
                           WX    X
                                     WZ   Z
                                             W  b WZ
                                               Ω         Z W bβ | β=
                                                                   b βb1
                β1                               β1                           ∂ βp
                                         -1
                                     b WZ
                            ×WZ Z WΩ             2
                                              Z WE
                                      β1

With this approximation in hand, we turn to estimating the asymptotic variance of
(17 ). For compactness, we note, using (29), that
                                                -1
               g Y, Ω        β2 X WZ Z WΩ
                      b = Avar               b WZ      Z WE
                       β1                      β1
                                        1
                                                      -1
                 1      1
                             β1 X WZ Z W 2 HW 12 Z
         g Y, W- 2 HW- 2 = Avar                           Z WE

So
                           
Avar g Y, Ω       Y, W- 12 HW- 12
            b + Dg
             β1

                         -1                 
               β2 X WZ Z WΩ
= Avar Avar                   b WZ    Z
                                                WE +    β1 X WZ
                                                      Avar
                                                     D
                                     β1
                                
                1     1   -1
         × Z W 2 HW 2 Z     Z WE

                      -1                               -1
         β2 X WZ Z WΩ
= Avar                  b WZ       N 2
                                              Var (zwε)    Z
                                                               W  b WZ
                                                                 Ω
                               β1                                  β1
                                                            -1
                    β2 + Avar
         × Z WXAvar           β2 X WZ Z WΩ         b WZ         N2
                                                         β1
                         1
                                   -1               
                                1
         × Var (zwε) Z W 2 HW 2 Z     Z WXAvar β1 D
                                 1
                                              -1                             -1
         +D    β1 X WZ Z W 2 HW 12 Z
             Avar                                N 2 Var (zwε) Z WΩ     b WZ
                                                                           β1
                                                    1
                                                                    -1
                    β1 + D
         × Z WXAvar             β1 X WZ Z W 2 HW 2 Z
                              Avar                              1
                                                                         N2
                         1
                                   -1               
                                1
         × Var (zwε) Z W 2 HW 2 Z     Z WXAvar β1 D

Substituting once more feasibility-replacing N 2 Var (zwε) with Z WΩ   b WZ-then
                                                                         β1

simplifying and substituting with (29) and (15 ) leads to the Windmeijer correction, as
in (18):

                               
g Y, Ω
Avar         b + Dg   Y, W- 12 HW- 12
               β1
                                    -1                      
        β2 X WZ Z WΩ
= Avar                      b WZ     Z
                                              WX              β2 X WZ
                                                   β2 + Avar
                                                  Avar
                                  β1
                   1
                            -1             
         × Z W 2 HW 2 Z
                         1
                                        β1 D
                                Z WXAvar
                                  1
                                              -1            
         +D     β1 X WZ Z W 2 HW 12 Z
            Avar                                          β1
                                                  Z WXAvar
                                  1
                                              -1                 1
                                                                            -1
         +D     β1 X WZ Z W 2 HW 12 Z
            Avar                                 Z WΩ b WZ Z W 2 HW 12 Z
                                                         β1
                         

× Z WXAvar    β1 D
                    -1                       -1       
         β2 Avar
= Avar        β2    β2 + Avar
                           Avar          β2 Avar
                                                 β1      β1 D
                                                          Avar
                        -1                    
         +D  Avar      β1
               β1 Avar           β1 + D
                                 Avar           r β2 D
                                             Avar
                                              
         β2 + Avar
= Avar         β2 D +D    β2 + D
                                 Avar          r β2 D
                                             Avar

Finally, we derive a weighted version of the Arellano-Bond autocorrelation test. As
in section 3.5, N is the number of individuals in a panel. Paralleling (28), the basic test
statistic is
1  -l              1  -l                                     
√ E       WE = √          E - X-l  i    βA - β     W E - X βA - β
N                   N
                                        E-l WX √             √               

$$
1
                  = \sqrt E-l WE -                      N \betaA - \beta - N \betaA - \beta
                         N                   N
                               -l
                             X WE         \sqrt             1 X-l  WX \sqrt               
                           ×            + N \betaA - \beta \sqrt                      N \betaA - \beta
                                 N                          N      N
$$

Assuming that the weights (before being normalized to sum to N T ) do not diverge,
the last two terms still drop out asymptotically, and the variance of the expression is
estimated by
1   -l      -l           -l WX (X WZAZW X)-1 X WZAZW
√   E WVar E | Z WE - 2E
N
                                                    
         E
×Var             -l + E
                | Z WE                βA X WE
                              -l WXAvar           -l

A.2 Sampling weights
Sampling weights are used to adjust for under-sampling and over-sampling in surveys.
Giving higher weight to observations that correspond to larger fractions of the pop-
ulation can increase efficiency. Unlike with analytical weights, there is, in general, no

assumption that the survey design introduces heteroskedasticity. In principle, then, just
one premise changes in moving from analytical to sampling weights: where the assump-
tion before in formulating the one-step estimator was that Ω = W-1 , now we assume
                                = I into (11 ) would redefine the one-step estimator as
that Ω is scalar. Substituting Ω
                                -1
                           -1                       -1
β1 = X WZ (Z WHWZ) Z WX    X WZ (Z WHWZ) Z WY                          (13 )

However, the Stata convention is not to make this change, but rather to employ exactly
the same formulas as for analytical weights. Using this arguably less accurate model of
the errors in the first stage does not affect the consistency of coefficient estimates-even
without weights, coefficient estimates would be consistent-but it can reduce efficiency
in the first stage, and it makes the classical standard-error estimates inconsistent. This
may be one reason why in Stata pweights always trigger the robust option. (For
xtabond2, “robust” means clustered errors.)
In the context of two-stage FEGMM, carrying over the formulas for analytical weight-
ing to sample weighting in the first stage poses little problem. Recall that the first-stage
proxy for Ω is not assumed to be accurate, and it inevitably contains some arbitrariness.

A.3 Frequency weights
The conceptual model behind frequency weights, or fweights, is rather different and
straightforward. A frequency weight is used to collapse duplicate observations into
one, more-weighted observation to economize on memory and processing power. The
estimation formulas for frequency-weighted data must, therefore, have the property that
they produce the same answer when run on an expanded, unweighted version of the
data. The formulas for analytical weights, in fact, do behave this way, with only minor
modifications. In the construction of W, because the sum of the frequency weights is
the true sample size N , the weights need not be normalized to sum to the number of
rows in the dataset.
