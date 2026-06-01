<!-- Transcripción a Markdown generada desde ts_prais.pdf. Fórmulas principales normalizadas a LaTeX; salidas de Stata preservadas en texto cuando el PDF las contenía como bloques de salida. -->

Title                                                                                          stata.com
        prais — Prais – Winsten and Cochrane – Orcutt regression


        Description         Quick start                      Menu             Syntax
        Options             Remarks and examples             Stored results   Methods and formulas
        Acknowledgment      References                       Also see



Description
       prais uses the generalized least-squares method to estimate the parameters in a linear regression
   model in which the errors are serially correlated. Specifically, the errors are assumed to follow a
   first-order autoregressive process.


Quick start
   Prais–Winsten regression of y on x estimating the autocorrelation parameter by a single-lag OLS
      regression of residuals using tsset data
         prais y x
   As above, but estimate the autocorrelation parameter using a single-lead OLS of residuals
        prais y x, rhotype(freg)
   As above, but estimate the autocorrelation parameter using autocorrelation of residuals
        prais y x, rhotype(tscorr)
   Cochrane–Orcutt regression of y on x with first-order serial correlation
        prais y x, corc


Menu
   Statistics > Time series > Prais–Winsten regression




                                                         1


---

  2   prais — Prais – Winsten and Cochrane – Orcutt regression


Syntax
                                                                       
      prais depvar        indepvars         if         in         , options

  options                       Description
 Model
  rhotype(regress)              base ρ on single-lag OLS of residuals; the default
  rhotype(freg)                 base ρ on single-lead OLS of residuals
  rhotype(tscorr)               base ρ on autocorrelation of residuals
  rhotype(dw)                   base ρ on autocorrelation based on Durbin–Watson
  rhotype(theil)                base ρ on adjusted autocorrelation
  rhotype(nagar)                base ρ on adjusted Durbin–Watson
  corc                          use Cochrane–Orcutt transformation
  ssesearch                     search for ρ that minimizes SSE
  twostep                       stop after the first iteration
  noconstant                    suppress constant term
  hascons                       has user-defined constant
  savespace                     conserve memory during estimation
 SE/Robust
  vce(vcetype)                  vcetype may be ols, robust, cluster clustvar, hc2, or hc3
 Reporting
  level(#)                      set confidence level; default is level(95)
  nodw                          do not report the Durbin–Watson statistic
  display options               control columns and column formats, row spacing, line width,
                                   display of omitted variables and base and empty cells, and
                                   factor-variable labeling
 Optimization
  optimize options              control the optimization process; seldom used
  coeflegend                    display legend instead of statistics
  You must tsset your data before using prais; see [TS] tsset.
  indepvars may contain factor variables; see [U] 11.4.3 Factor variables.
  depvar and indepvars may contain time-series operators; see [U] 11.4.4 Time-series varlists.
  by, collect, fp, rolling, and statsby are allowed; see [U] 11.1.10 Prefix commands.
  coeflegend does not appear in the dialog box.
  See [U] 20 Estimation and postestimation commands for more capabilities of estimation commands.


---

                                            prais — Prais – Winsten and Cochrane – Orcutt regression       3


Options
           
           Model

     rhotype(rhomethod) selects a specific computation for the autocorrelation parameter ρ, where
       rhomethod can be

                 regress         ρreg = β from the residual regression t = βt−1
                 freg            ρfreg = β from the residual regression t = βt+1
                 tscorr          ρtscorr = 0 t−1 /0 , where  is the vector of residuals
                 dw              $\rho_{dw} = 1 - dw/2$, where $dw$ is the Durbin–Watson $d$ statistic
                 theil           $\rho_{theil} = \rho_{tscorr}(N-k)/N$
                 nagar           ρnagar = (ρdw * N 2 + k 2 )/(N 2 − k 2 )

        The prais estimator can use any consistent estimate of ρ to transform the equation, and each
        of these estimates meets that requirement. The default is regress, which produces the minimum
        sum-of-squares solution (ssesearch option) for the Cochrane – Orcutt transformation — none of
        these computations will produce the minimum sum-of-squares solution for the full Prais – Winsten
        transformation. See Judge et al. (1985) for a discussion of each estimate of ρ.
     corc specifies that the Cochrane – Orcutt transformation be used to estimate the equation. With this
       option, the Prais – Winsten transformation of the first observation is not performed, and the first
       observation is dropped when estimating the transformed equation; see Methods and formulas below.
     ssesearch specifies that a search be performed for the value of ρ that minimizes the sum-of-squared
       errors of the transformed equation (Cochrane – Orcutt or Prais – Winsten transformation). The search
       method is a combination of quadratic and modified bisection searches using golden sections.
     twostep specifies that prais stop on the first iteration after the equation is transformed by ρ — the
       two-step efficient estimator. Although iterating these estimators to convergence is customary, they
       are efficient at each step.
     noconstant; see [R] Estimation options.
     hascons indicates that a user-defined constant, or a set of variables that in linear combination forms a
       constant, has been included in the regression. For some computational concerns, see the discussion
       in [R] regress.
     savespace specifies that prais attempt to save as much space as possible by retaining only those
       variables required for estimation. The original data are restored after estimation. This option is
       rarely used and should be used only if there is insufficient space to fit a model without the option.

           
           SE/Robust

     vce(vcetype) specifies the estimator for the variance–covariance matrix of the estimator; see
       [R] vce option.
        vce(ols), the default, uses the standard variance estimator for ordinary least-squares regression.
        vce(robust) specifies to use the Huber/White/sandwich estimator.
        vce(cluster clustvar) specifies to use the intragroup correlation estimator.
        vce(hc2) and vce(hc3) specify an alternative bias correction for the vce(robust) variance
          calculation; for more information, see [R] regress. You may specify only one of vce(hc2),
          vce(hc3), or vce(robust).


---

     4   prais — Prais – Winsten and Cochrane – Orcutt regression


         All estimates from prais are conditional on the estimated value of ρ. Robust variance estimates
         here are robust only to heteroskedasticity and are not generally robust to misspecification of the
         functional form or omitted variables. The estimation of the functional form is intertwined with
         the estimation of ρ, and all estimates are conditional on ρ. Thus estimates cannot be robust to
         misspecification of functional form. For these reasons, it is probably best to interpret vce(robust)
         in the spirit of White’s (1980) original paper on estimation of heteroskedastic-consistent covariance
         matrices.
            
            Reporting
     level(#); see [R] Estimation options.
     nodw suppresses reporting of the Durbin – Watson statistic.
     display options: noci, nopvalues, noomitted, vsquish, noemptycells, baselevels,
        allbaselevels, nofvlabel, fvwrap(#), fvwrapon(style), cformat(% fmt), pformat(% fmt),
        sformat(% fmt), and nolstretch; see [R] Estimation options.
            
            Optimization
                                       
     optimize options: iterate(#), no log, tolerance(#). iterate() specifies the maximum num-
        ber of iterations. log/nolog specifies whether to show the iteration log (see set iterlog in
        [R] set iter). tolerance() specifies the tolerance for the coefficient vector; tolerance(1e-6)
        is the default. These options are seldom used.

     The following option is available with prais but is not shown in the dialog box:
     coeflegend; see [R] Estimation options.


Remarks and examples                                                                                 stata.com
        prais fits a linear regression of depvar on indepvars that is corrected for first-order serially correlated
     residuals by using the Prais – Winsten (1954) transformed regression estimator, the Cochrane – Orcutt
     (1949) transformed regression estimator, or a version of the search method suggested by Hildreth
     and Lu (1960). Davidson and MacKinnon (1993) provide theoretical details on the three methods
     (see pages 333–335 for the latter two and pages 343–351 for Prais–Winsten). See Becketti (2020)
     for more examples showing how to use prais.
        The most common autocorrelated error process is the first-order autoregressive process. Under this
     assumption, the linear regression model can be written as

$$
y_t = x_t\beta + u_t
$$

where the errors satisfy

$$
u_t = \rho u_{t-1} + e_t
$$

and the $e_t$ are independent and identically distributed as $N(0,\sigma^2)$. The covariance matrix $\Psi$ of the error term $u$ can then be written as

$$
\Psi = \frac{1}{1-\rho^2}
\begin{bmatrix}
1 & \rho & \rho^2 & \cdots & \rho^{T-1} \\
\rho & 1 & \rho & \cdots & \rho^{T-2} \\
\rho^2 & \rho & 1 & \cdots & \rho^{T-3} \\
\vdots & \vdots & \vdots & \ddots & \vdots \\
\rho^{T-1} & \rho^{T-2} & \rho^{T-3} & \cdots & 1
\end{bmatrix}
$$


---

                                       prais — Prais – Winsten and Cochrane – Orcutt regression       5


    The Prais – Winsten estimator is a generalized least-squares (GLS) estimator. The Prais – Winsten
 method (as described in Judge et al. 1985) is derived from the AR(1) model for the error term described
 above. Whereas the Cochrane – Orcutt method uses a lag definition and loses the first observation in
 the iterative method, the Prais – Winsten method preserves that first observation. In small samples,
 this can be a significant advantage.

Technical note
    To fit a model with autocorrelated errors, you must specify your data as time series and have (or
 create) a variable denoting the time at which an observation was collected. The data for the regression
 should be equally spaced in time.


Example 1
   Say that we wish to fit a time-series model of usr on idle but are concerned that the residuals
 may be serially correlated. We will declare the variable t to represent time by typing
       . use https://www.stata-press.com/data/r17/idle
       . tsset t
       Time variable: t, 1 to 30
               Delta: 1 unit

 We can obtain Cochrane–Orcutt estimates by specifying the corc option:
       . prais usr idle, corc
       Iteration 0:        rho = 0.0000
       Iteration 1:        rho = 0.3518
         (output omitted )
       Iteration 13: rho = 0.5708
       Cochrane- Orcutt AR(1) regression with iterated estimates
               Source            SS       df       MS      Number of obs          =        29
                                                           F(1, 27)               =      6.49
                Model       40.1309584     1 40.1309584    Prob > F               =    0.0168
            Residual        166.898474    27 6.18142498    R-squared              =    0.1938
                                                           Adj R-squared          =    0.1640
                Total       207.029433    28 7.39390831    Root MSE               =    2.4862

                 usr   Coefficient    Std. err.       t     P>|t|      [95% conf. interval]

               idle     -.1254511     .0492356     -2.55    0.017     -.2264742       -.024428
              _cons      14.54641     4.272299      3.40    0.002       5.78038       23.31245

                 rho     .5707918

       Durbin- Watson statistic (original)    = 1.295766
       Durbin- Watson statistic (transformed) = 1.466222

 The fitted model is

              usrt = −0.1255 idlet + 14.55 + ut            and      ut = 0.5708 ut−1 + et


---

 6   prais — Prais – Winsten and Cochrane – Orcutt regression


 We can also fit the model with the Prais – Winsten method,
       . prais usr idle
       Iteration 0:        rho = 0.0000
       Iteration 1:        rho = 0.3518
         (output omitted )
       Iteration 14: rho = 0.5535
       Prais- Winsten AR(1) regression with iterated estimates
               Source            SS       df       MS      Number of obs             =         30
                                                           F(1, 28)                  =       7.12
                Model       43.0076941     1 43.0076941    Prob > F                  =     0.0125
            Residual        169.165739    28 6.04163354    R-squared                 =     0.2027
                                                           Adj R-squared             =     0.1742
                Total       212.173433    29 7.31632528    Root MSE                  =      2.458

                 usr   Coefficient    Std. err.         t      P>|t|       [95% conf. interval]

               idle     -.1356522     .0472195       -2.87     0.008     -.2323769       -.0389275
              _cons      15.20415     4.160391        3.65     0.001      6.681978        23.72633

                 rho     .5535476

       Durbin- Watson statistic (original)    = 1.295766
       Durbin- Watson statistic (transformed) = 1.476004

 where the Prais – Winsten fitted model is

                usrt = −.1357 idlet + 15.20 + ut              and      ut = .5535 ut−1 + et

    As the results indicate, for these data there is little difference between the Cochrane – Orcutt and
 Prais – Winsten estimators, whereas the OLS estimate of the slope parameter is substantially different.



Example 2
    We have data on quarterly sales, in millions of dollars, for 5 years, and we would like to use
 this information to model sales for company X. First, we fit a linear model by OLS and obtain the
 Durbin–Watson statistic by using estat dwatson; see [R] regress postestimation time series.
       . use https://www.stata-press.com/data/r17/qsales
       . regress csales isales
             Source           SS             df         MS          Number of obs    =          20
                                                                    F(1, 18)         =    14888.15
              Model     110.256901            1   110.256901        Prob > F         =      0.0000
           Residual     .133302302           18   .007405683        R-squared        =      0.9988
                                                                    Adj R-squared    =      0.9987
              Total     110.390204           19   5.81001072        Root MSE         =      .08606

             csales    Coefficient    Std. err.         t      P>|t|       [95% conf. interval]

             isales      .1762828     .0014447       122.02    0.000      .1732475        .1793181
              _cons     -1.454753     .2141461        -6.79    0.000     -1.904657       -1.004849

       . estat dwatson
       Durbin- Watson d-statistic(    2,     20) =    .7347276


---

                                          prais — Prais – Winsten and Cochrane – Orcutt regression   7


Because the Durbin–Watson statistic is far from 2 (the expected value under the null hypothesis of
no serial correlation) and well below the 5% lower limit of 1.2, we conclude that the disturbances are
serially correlated. (Upper and lower bounds for the d statistic can be found in most econometrics
texts; for example, Harvey [1990]. The bounds have been derived for only a limited combination of
regressors and observations.) To reinforce this conclusion, we use two other tests to test for serial
correlation in the error distribution.
      . estat bgodfrey, lags(1)
      Breusch- Godfrey LM test for autocorrelation

          lags(p)                 chi2                  df                  Prob > chi2

             1                    7.998                    1                     0.0047

                                  H0: no serial correlation
      . estat durbinalt
      Durbin’s alternative test for autocorrelation

          lags(p)                 chi2                  df                  Prob > chi2

             1                 11.329                      1                 0.0008

                                  H0: no serial correlation

estat bgodfrey reports the Breusch–Godfrey Lagrange multiplier test statistic, and estat
durbinalt reports the Durbin’s alternative test statistic. Both tests give a small p-value and thus
reject the null hypothesis of no serial correlation. These two tests are asymptotically equivalent when
testing for AR(1) process. See [R] regress postestimation time series if you are not familiar with
these two tests.
   We correct for autocorrelation with the ssesearch option of prais to search for the value of ρ
that minimizes the sum-of-squared residuals of the Cochrane – Orcutt transformed equation. Normally,
the default Prais – Winsten transformations is used with such a small dataset, but the less-efficient
Cochrane – Orcutt transformation allows us to demonstrate an aspect of the estimator’s convergence.
      . prais csales isales, corc ssesearch
      Iteration 1:        rho = 0.8944, criterion =   -.07298558
      Iteration 2:        rho = 0.8944, criterion =   -.07298558
        (output omitted )
      Iteration 15: rho = 0.9588, criterion =          -.07167037
      Cochrane- Orcutt AR(1) regression with SSE search estimates
            Source           SS               df       MS        Number of obs     =          19
                                                                 F(1, 17)          =      553.14
             Model     2.33199178              1   2.33199178    Prob > F          =      0.0000
          Residual     .071670369             17   .004215904    R-squared         =      0.9702
                                                                 Adj R-squared     =      0.9684
             Total     2.40366215             18   .133536786    Root MSE          =      .06493

            csales     Coefficient   Std. err.         t       P>|t|    [95% conf. interval]

            isales       .1605233    .0068253        23.52     0.000    .1461233       .1749234
             _cons       1.738946    1.432674         1.21     0.241   -1.283732       4.761624

                 rho     .9588209

      Durbin- Watson statistic (original)    = 0.734728
      Durbin- Watson statistic (transformed) = 1.724419


---

8   prais — Prais – Winsten and Cochrane – Orcutt regression


   We noted in Options that, with the default computation of ρ, the Cochrane – Orcutt method produces
an estimate of ρ that minimizes the sum-of-squared residuals — the same criterion as the ssesearch
option. Given that the two methods produce the same results, why would the search method ever be
preferred? It turns out that the back-and-forth iterations used by Cochrane – Orcutt may have difficulty
converging if the value of ρ is large. Using the same data, the Cochrane – Orcutt iterative procedure
requires more than 350 iterations to converge, and a higher tolerance must be specified to prevent
premature convergence:
      . prais csales isales, corc tol(1e-9) iterate(500)
      Iteration 0:        rho = 0.0000
      Iteration 1:        rho = 0.6312
      Iteration 2:        rho = 0.6866
        (output omitted )
      Iteration 377: rho = 0.9588
      Iteration 378: rho = 0.9588
      Iteration 379: rho = 0.9588
      Cochrane- Orcutt AR(1) regression with iterated estimates
            Source          SS           df       MS      Number of obs          =        19
                                                          F(1, 17)               =    553.14
             Model     2.33199171         1 2.33199171    Prob > F               =    0.0000
          Residual     .071670369        17 .004215904    R-squared              =    0.9702
                                                          Adj R-squared          =    0.9684
             Total     2.40366208        18 .133536782    Root MSE               =    .06493

            csales    Coefficient    Std. err.        t    P>|t|      [95% conf. interval]

            isales       .1605233    .0068253     23.52    0.000      .1461233       .1749234
             _cons       1.738946    1.432674      1.21    0.241     -1.283732       4.761625

                rho      .9588209

      Durbin- Watson statistic (original)    = 0.734728
      Durbin- Watson statistic (transformed) = 1.724419

Once convergence is achieved, the two methods produce identical results.


---

                                         prais — Prais – Winsten and Cochrane – Orcutt regression                      9


Stored results
     prais stores the following in e():
     Scalars
          e(N)                  number of observations
          e(N gaps)             number of gaps
          e(mss)                model sum of squares
          e(df m)               model degrees of freedom
          e(rss)                residual sum of squares
          e(df r)               residual degrees of freedom
          e(r2)                 R2
          e(r2 a)               adjusted R2
          e(F)                  F statistic
          e(rmse)               root mean squared error
          e(ll)                 log likelihood
          e(N clust)            number of clusters
          e(rho)                autocorrelation parameter ρ
          e(dw)                 Durbin–Watson d statistic for transformed regression
          e(dw 0)               Durbin–Watson d statistic of untransformed regression
          e(rank)               rank of e(V)
          e(tol)                target tolerance
          e(max ic)             maximum number of iterations
          e(ic)                 number of iterations
     Macros
         e(cmd)                 prais
         e(cmdline)             command as typed
         e(depvar)              name of dependent variable
         e(title)               title in estimation output
         e(clustvar)            name of cluster variable
         e(cons)                noconstant or not reported
         e(method)              twostep, iterated, or SSE search
         e(tranmeth)            corc or prais
         e(rhotype)             method specified in rhotype() option
         e(vce)                 vcetype specified in vce()
         e(vcetype)             title used to label Std. err.
         e(properties)          b V
         e(predict)             program used to implement predict
         e(marginsok)           predictions allowed by margins
         e(asbalanced)          factor variables fvset as asbalanced
         e(asobserved)          factor variables fvset as asobserved
     Matrices
         e(b)                   coefficient vector
         e(V)                   variance–covariance matrix of the estimators
         e(V modelbased)        model-based variance
     Functions
         e(sample)              estimation sample

  In addition to the above, the following is stored in r():
     Matrices
         r(table)               matrix containing the coefficients with their standard errors, test statistics, p-values,
                                   and confidence intervals

  Note that results stored in r() are updated when the command is replayed and will be replaced when
  any r-class command is run after the estimation command.


---

  10    prais — Prais – Winsten and Cochrane – Orcutt regression


Methods and formulas
     Consider the command ‘prais y x z ’. The 0th iteration is obtained by estimating a, b, and c
  from the standard linear regression:

$$
y_t = ax_t + bz_t + c + u_t
$$
  An estimate of the correlation in the residuals is then obtained. By default, prais uses the auxiliary
  regression:

$$
u_t = \rho u_{t-1} + e_t
$$
  This can be changed to any computation noted in the rhotype() option.
       Next we apply a Cochrane – Orcutt transformation (1) for observations t = 2, . . . , n

$$
y_t - \rho y_{t-1} = a(x_t - \rho x_{t-1}) + b(z_t - \rho z_{t-1}) + c(1-\rho) + v_t \tag{1}
$$
                             0
  and the transformation (1 ) for t = 1

$$
\sqrt{1-\rho^2}\,y_1 = a(\sqrt{1-\rho^2}\,x_1) + b(\sqrt{1-\rho^2}\,z_1) + c\sqrt{1-\rho^2} + \sqrt{1-\rho^2}\,v_1 \tag{1'}
$$
  Thus the differences between the Cochrane – Orcutt and the Prais – Winsten methods are that the latter
  uses (10 ) in addition to (1), whereas the former uses only (1), necessarily decreasing the sample size
  by one.
       Equations (1) and (10 ) are used to transform the data and obtain new estimates of a, b, and c.
     When the twostep option is specified, the estimation process stops at this point and reports these
  estimates. Under the default behavior of iterating to convergence, this process is repeated until the
  change in the estimate of ρ is within a specified tolerance.
       The new estimates are used to produce fitted values

$$
\hat{y}_t = \hat{a}x_t + \hat{b}z_t + \hat{c}
$$
  and then ρ is reestimated using, by default, the regression defined by

$$
y_t - \hat{y}_t = \rho(y_{t-1} - \hat{y}_{t-1}) + u_t \tag{2}
$$
  We then reestimate (1) by using the new estimate of ρ and continue to iterate between (1) and (2)
  until the estimate of ρ converges.
     Convergence is declared after iterate() iterations or when the absolute difference in the estimated
  correlation between two iterations is less than tol(); see [R] Maximize. Sargan (1964) has shown
  that this process will always converge.
     Under the ssesearch option, a combined quadratic and bisection search using golden sections
  searches for the value of ρ that minimizes the sum-of-squared residuals from the transformed equation.
  The transformation may be either the Cochrane – Orcutt (1 only) or the Prais – Winsten (1 and 10 ).
     All reported statistics are based on the ρ-transformed variables, and ρ is assumed to be estimated
  without error. See Judge et al. (1985) for details.
       The Durbin–Watson $d$ statistic reported by prais and estat dwatson is

$$
d = \frac{\sum_{j=1}^{n-1}(u_{j+1}-u_j)^2}{\sum_{j=1}^n u_j^2}
$$

  where uj represents the residual of the j th observation.


---

                                                prais — Prais – Winsten and Cochrane – Orcutt regression                11


     This command supports the Huber/White/sandwich estimator of the variance and its clustered
  version using vce(robust) and vce(cluster clustvar), respectively. See [P] robust, particularly
  Introduction and Methods and formulas.
     All estimates from prais are conditional on the estimated value of ρ. Robust variance estimates here
  are robust only to heteroskedasticity and are not generally robust to misspecification of the functional
  form or omitted variables. The estimation of the functional form is intertwined with the estimation
  of ρ, and all estimates are conditional on ρ. Thus estimates cannot be robust to misspecification
  of functional form. For these reasons, it is probably best to interpret vce(robust) in the spirit of
  White’s original paper on estimation of heteroskedastic-consistent covariance matrices.


Acknowledgment
     We thank Richard Dickens of the Department of Economics, University of Sussex, UK, for testing
  and assistance with an early version of this command.

  
       Sigbert Jon Prais (1928–2014) was born in Frankfurt and moved to Britain in 1934 as a refugee.
       After earning degrees at the universities of Birmingham and Cambridge and serving in various
       posts in research and industry, he settled at the National Institute of Economic and Social
       Research. Prais’s interests extended widely across economics, including studies of the influence
       of education on economic progress.
       Christopher Blake Winsten (1923–2005) was born in Welwyn Garden City, England; the son
       of the writer Stephen Winsten and the painter and sculptress Clare Blake. He was educated
       at the University of Cambridge and worked with the Cowles Commission at the University of
       Chicago and at the universities of Oxford, London (Imperial College) and Essex, making many
       contributions to economics and statistics, including the Prais–Winsten transformation and joint
       authorship of a celebrated monograph on transportation economics.
       Donald Cochrane (1917–1983) was an Australian economist and econometrician. He was born
       in Melbourne and earned degrees at Melbourne and Cambridge. After wartime service in the
       Royal Australian Air Force, he held chairs at Melbourne and Monash, being active also in work
       for various international organizations and national committees.
       Guy Henderson Orcutt (1917–2006) was born in Michigan and earned degrees in physics and
       economics at the University of Michigan. He worked at Harvard, the University of Wisconsin,
       and Yale. He contributed to econometrics and economics in several fields, most distinctively in
       developing microanalytical models of economic behavior.
                                                                                                                         


References
   Becketti, S. 2020. Introduction to Time Series Using Stata. Rev. ed. College Station, TX: Stata Press.
  Cochrane, D., and G. H. Orcutt. 1949. Application of least squares regression to relationships containing auto-correlated
    error terms. Journal of the American Statistical Association 44: 32–61. https://doi.org/10.2307/2280349.
   Davidson, R., and J. G. MacKinnon. 1993. Estimation and Inference in Econometrics. New York: Oxford University
     Press.
      Durbin, J., and G. S. Watson. 1950. Testing for serial correlation in least squares regression. I. Biometrika 37:
       409–428. https://doi.org/10.2307/2332391.
           . 1951. Testing for serial correlation in least squares regression. II. Biometrika 38: 159–177.
        https://doi.org/10.2307/2332325.


---

  12   prais — Prais – Winsten and Cochrane – Orcutt regression


   Harvey, A. C. 1990. The Econometric Analysis of Time Series. 2nd ed. Cambridge, MA: MIT Press.
   Hildreth, C., and J. Y. Lu. 1960. Demand relations with autocorrelated disturbances. Reprinted in Agricultural
     Experiment Station Technical Bulletin, No. 276. East Lansing, MI: Michigan State University Press.
   Judge, G. G., W. E. Griffiths, R. C. Hill, H. Lütkepohl, and T.-C. Lee. 1985. The Theory and Practice of Econometrics.
      2nd ed. New York: Wiley.
   King, M. L., and D. E. A. Giles, ed. 1987. Specification Analysis in the Linear Model: Essays in Honor of Donald
     Cochrane. London: Routledge & Kegan Paul.
   Kmenta, J. 1997. Elements of Econometrics. 2nd ed. Ann Arbor: University of Michigan Press.
   Prais, S. J., and C. B. Winsten. 1954. Trend estimators and serial correlation. Working paper 383, Cowles Commission.
      http://cowles.yale.edu/sites/default/files/files/pub/cdp/s-0383.pdf.
   Sargan, J. D. 1964. Wages and prices in the United Kingdom: A study in econometric methodology. In Econometric
     Analysis for National Economic Planning, ed. P. E. Hart, G. Mills, and J. K. Whitaker, 25–64. London: Butterworths.
   Theil, H. 1971. Principles of Econometrics. New York: Wiley.
  White, H. L., Jr. 1980. A heteroskedasticity-consistent covariance matrix estimator and a direct test for heteroskedasticity.
    Econometrica 48: 817–838. https://doi.org/10.2307/1912934.
   Wooldridge, J. M. 2020. Introductory Econometrics: A Modern Approach. 7th ed. Boston: Cengage.
   Zellner, A. 1990. Guy H. Orcutt: Contributions to economic statistics. Journal of Economic Behavior and Organization
     14: 43–51. https://doi.org/10.1016/0167-2681(90)90040-K.



Also see
  [TS] prais postestimation — Postestimation tools for prais
  [TS] arima — ARIMA, ARMAX, and other dynamic regression models
  [TS] mswitch — Markov-switching regression models
  [TS] tsset — Declare data to be time-series data
  [R] regress — Linear regression
  [R] regress postestimation time series — Postestimation tools for regress with time series
  [U] 20 Estimation and postestimation commands


---

