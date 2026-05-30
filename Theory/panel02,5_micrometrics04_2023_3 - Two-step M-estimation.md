# Two-Step M-Estimation

## Two-Step M-Estimators

Sometimes applications of M-estimators involve a first-stage estimation (an example is OLS with generated regressors).

Let $\hat{\gamma}$ be a preliminary estimator, usually based on the random sample $\{w_i : i = 1, 2, \ldots, N\}$.

A two-step M-estimator $\hat{\theta}$ of $\theta_0$ solves the problem

\[
\min_{\theta \in \Theta} \sum_{i=1}^{N} q(w_i,\theta;\hat{\gamma}),
\tag{19}
\]

where $q$ is now defined on $\mathcal{W}\times \Theta \times \Gamma$, and $\Gamma$ is a subset of $\mathbb{R}^{J}$.

---

## Agenda

1. M-Estimation
   - Introduction
   - Identification, Uniform Convergence, and Consistency
   - Asymptotic Normality

2. Two-Step M-Estimation
   - Consistency
   - Asymptotic Normality of Two-Step M-Estimators
   - Estimating the Asymptotic Variance
   - Adjustments for when we cannot ignore the first-stage estimation

---

## Two-Step M-Estimators

For the general two-step M-estimator, when will $\hat{\theta}$ be consistent for $\theta_o$?

In practice, the important condition is the identification assumption.

To state the identification condition, we need to know about the asymptotic behavior of $\hat{\gamma}$.

A general assumption is that

\[
\hat{\gamma} \xrightarrow{p} \gamma^\ast,
\]

where $\gamma^\ast$ is some element in $\Gamma$.

The identification condition for the two-step M-estimator is

\[
E[q(w,\theta_o;\gamma^\ast)] < E[q(w,\theta;\gamma^\ast)]
\quad \text{all } \theta \in \Theta,\ \theta \neq \theta_o,
\tag{20}
\]

---

## Two-Step M-Estimators

The consistency argument is essentially the same as that underlying Theorem 2. If $q(w_i,\theta;\gamma)$ satisfies the UWLLN over $\Theta \times \Gamma$ then expression (19) can be shown to converge to $E[q(w,\theta;\gamma^\ast)]$ uniformly over $\Theta$. Along with identification, this result can be shown to imply consistency of $\hat{\theta}$ for $\theta_o$.

---

## Agenda

1. M-Estimation
   - Introduction
   - Identification, Uniform Convergence, and Consistency
   - Asymptotic Normality

2. Two-Step M-Estimation
   - Consistency
   - Asymptotic Normality of Two-Step M-Estimators
   - Estimating the Asymptotic Variance
   - Adjustments for when we cannot ignore the first-stage estimation

---

## Two-Step M-Estimators

With the two-step M-estimator, there are two cases worth distinguishing.

The first occurs when the asymptotic variance of

\[
\sqrt{N}(\hat{\theta}-\theta_o)
\]

does not depend on the asymptotic variance of

\[
\sqrt{N}(\hat{\gamma}-\gamma^\ast).
\]

The second occurs when the asymptotic variance of

\[
\sqrt{N}(\hat{\theta}-\theta_o)
\]

should be adjusted to account for the first-stage estimation of $\gamma^\ast$.

We first derive conditions under which we can ignore the first-stage estimation error.

---

## Two-Step M-Estimators

First derive conditions under which we can ignore the first-stage estimation error.

Using arguments similar to those used to derive the asymptotic normality of M-estimators, it can be shown that, under standard regularity conditions,

\[
\sqrt{N}(\hat{\theta}-\theta_o)
=
A_o^{-1}
\left(
-N^{-1/2}\sum_{i=1}^{N}s_i(\theta_o;\hat{\gamma})
\right)
+ o_p(1),
\tag{21}
\]

where now

\[
A_o = E[H(w,\theta_o;\gamma^\ast)].
\]

In obtaining the score and the Hessian, we take derivatives only with respect to $\theta$; $\gamma^\ast$ simply appears as an extra argument.

---

## Two-Step M-Estimators

Now if,

\[
N^{-1/2}\sum_{i=1}^{N}s_i(\theta_o;\hat{\gamma})
=
N^{-1/2}\sum_{i=1}^{N}s_i(\theta_o;\gamma^\ast)
+ o_p(1),
\tag{22}
\]

Then

\[
\sqrt{N}(\hat{\theta}-\theta_o)
\]

behaves the same asymptotically whether we used $\hat{\gamma}$ or its plim in defining the M-estimator.

When does equation (22) hold?

---

## Two-Step M-Estimators

Assuming that

\[
\sqrt{N}(\hat{\gamma}-\gamma^\ast)=O_p(1)
\]

(which is standard).

A mean value expansion similar to (12) gives

\[
N^{-1/2}\sum_{i=1}^{N}s_i(\theta_o;\hat{\gamma})
=
N^{-1/2}\sum_{i=1}^{N}s_i(\theta_o;\gamma^\ast)
+
F_o\sqrt{N}(\hat{\gamma}-\gamma^\ast)
+
o_p(1),
\tag{23}
\]

where $F_o$ is the $P \times J$ matrix

\[
F_o \equiv E[\nabla_{\gamma}s(w,\theta_o;\gamma^\ast)].
\]

Therefore if

\[
E[\nabla_{\gamma}s(w,\theta_o;\gamma^\ast)] = 0,
\tag{24}
\]

then equation (22) holds.

And the asymptotic variance of the two-step M-estimator is the same as if $\gamma^\ast$ were plugged in.

---

## Two-Step M-Estimators

There are many problems for which assumption (24) does not hold.

These problems include some the methods for correcting for endogeneity in Probit and Tobit models.

In such cases we need to make an adjustment to the asymptotic variance of

\[
\sqrt{N}(\hat{\theta}-\theta_o).
\]

Assume

\[
\sqrt{N}(\hat{\gamma}-\gamma^\ast)
=
N^{-1/2}\sum_{i=1}^{N}r_i(\gamma^\ast)
+
o_p(1),
\tag{25}
\]

where $r_i(\gamma^\ast)$ is a $J\times 1$ vector with

\[
E[r_i(\gamma^\ast)] = 0.
\]

---

## Two-Step M-Estimators

Now using equation (23) we can write

\[
\sqrt{N}(\hat{\theta}-\theta_o)
=
A_o^{-1}N^{-1/2}\sum_{i=1}^{N}[-g_i(\theta_o;\gamma^\ast)]
+
o_p(1),
\tag{26}
\]

where

\[
g_i(\theta_o;\gamma^\ast) \equiv s_i(\theta_o;\gamma^\ast) + F_o r_i(\gamma^\ast).
\]

Since $g_i(\theta_o;\gamma^\ast)$ has zero mean, the standardized partial sum in equation (26) can be assumed to satisfy the central limit theorem.

Define the $P\times P$ matrix

\[
D_o \equiv E[g_i(\theta_o;\gamma^\ast)g_i(\theta_o;\gamma^\ast)']
=
\operatorname{Var}[g_i(\theta_o;\gamma^\ast)],
\tag{27}
\]

Then

\[
\operatorname{Avar}
\left[
\sqrt{N}(\hat{\theta}-\theta_o)
\right]
=
A_o^{-1}D_oA_o^{-1},
\tag{28}
\]

---

## Agenda

1. M-Estimation
   - Introduction
   - Identification, Uniform Convergence, and Consistency
   - Asymptotic Normality

2. Two-Step M-Estimation
   - Consistency
   - Asymptotic Normality of Two-Step M-Estimators
   - Estimating the Asymptotic Variance
   - Adjustments for when we cannot ignore the first-stage estimation

---

## Two-Step M-Estimators

We first consider estimating the asymptotic variance of $\hat{\theta}$ in the case where there are no nuisance parameters.

Under regularity conditions that ensure uniform converge of the Hessian, the estimator

\[
N^{-1}\sum_{i=1}^{N}H(w_i,\hat{\theta})
\equiv
N^{-1}\sum_{i=1}^{N}\hat{H}_i,
\tag{29}
\]

is consistent for $A_o$, by Lemma 1.

By Lemma 1, under standard regularity conditions we have

\[
N^{-1}\sum_{i=1}^{N}s(w_i,\hat{\theta})s(w_i,\hat{\theta})'
\equiv
N^{-1}\sum_{i=1}^{N}\hat{s}_i\hat{s}'_i
\xrightarrow{p} B_o.
\tag{30}
\]

---

## Two-Step M-Estimators

Combining equations (29) and (30) we can consistently estimate

\[
\operatorname{Avar}
\left[
\sqrt{N}(\hat{\theta}-\theta_o)
\right]
\]

by

\[
\widehat{\operatorname{Avar}}
\left[
\sqrt{N}(\hat{\theta}-\theta_o)
\right]
=
\hat{A}^{-1}\hat{B}\hat{A}^{-1},
\tag{31}
\]

The asymptotic standard errors are obtained from the matrix

\[
\hat{V}
\equiv
\widehat{\operatorname{Avar}}(\hat{\theta})
=
\hat{A}^{-1}\hat{B}\hat{A}^{-1}/N.
\tag{32}
\]

Which can be expressed as

\[
\left(\sum_{i=1}^{N}\hat{H}_i\right)^{-1}
\left(\sum_{i=1}^{N}\hat{s}_i\hat{s}'_i\right)
\left(\sum_{i=1}^{N}\hat{H}_i\right)^{-1}.
\tag{33}
\]

---

## Agenda

1. M-Estimation
   - Introduction
   - Identification, Uniform Convergence, and Consistency
   - Asymptotic Normality

2. Two-Step M-Estimation
   - Consistency
   - Asymptotic Normality of Two-Step M-Estimators
   - Estimating the Asymptotic Variance
   - Adjustments for when we cannot ignore the first-stage estimation

---

## Two-Step M-Estimators

When assumption (24) is violated, the asymptotic variance estimator of $\hat{\theta}$ must account for the asymptotic variance of $\hat{\gamma}$.

We need to estimate equation (28).

We already know how to consistently estimate $A_o$ using equation (29).

Estimation of $D_o$ is also straightforward.

First we need to estimate $F_o$,

\[
\hat{F}
=
N^{-1}\sum_{i=1}^{N}
\nabla_{\gamma}s_i(\hat{\theta};\hat{\gamma}),
\tag{34}
\]

---

## Two-Step M-Estimators

Next, replace $r_i(\gamma^\ast)$ with

\[
\hat{r}_i \equiv r_i(\hat{\gamma}).
\]

Then

\[
\hat{D}
\equiv
N^{-1}\sum_{i=1}^{N}\hat{g}_i\hat{g}'_i
\xrightarrow{p} D_o,
\tag{35}
\]

where

\[
\hat{g}_i = \hat{s}_i + \hat{F}\hat{r}_i.
\]

The asymptotic variance of the two-step M-estimator is,

\[
\left(\sum_{i=1}^{N}\hat{H}_i\right)^{-1}
\left(\sum_{i=1}^{N}\hat{g}_i\hat{g}'_i\right)
\left(\sum_{i=1}^{N}\hat{H}_i\right)^{-1}.
\tag{36}
\]
