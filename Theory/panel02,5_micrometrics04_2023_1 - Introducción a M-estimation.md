# Microeconometría I

**Maestría en Econometría**

**Lecture 4**

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

## M-Estimation

M-estimation methods include maximum likelihood, nonlinear least squares, least absolute deviations, quasi-maximum likelihood, and many other procedures used by econometricians.

In a nonlinear regression model, we have a random variable, $y$, and we would like to model $E(y \mid x)$ as a function of the explanatory variables $x$, a $K$-vector.

We already know how to estimate models of $E(y \mid x)$ when the model is linear in its parameters: OLS produces consistent, asymptotically normal estimators.

What happens if the regression function is nonlinear in its parameters?

---

## M-Estimation

Generally, let $m(x; \theta)$ be a parametric model for $E(y \mid x)$, where $m$ is a known function of $x$ and $\theta$, and $\theta$ is a $P \times 1$ parameter vector.

This is a parametric model because $m(x; \theta)$ is assumed to be known up to a finite number of parameters.

The dimension of the parameters, $P$, can be less than or greater than $K$. The parameter space, $\Theta$, is a subset of $\mathbb{R}^P$

This is the set of values of $y$ that we are willing to consider in the regression function. Unlike in linear models, for nonlinear models the asymptotic analysis requires explicit assumptions on the parameter space

---

## M-Estimation

An example of a nonlinear regression function is the logistic function, $m(x; \theta) = \exp(x\theta)/[1 + \exp(x\theta)]$. The logistic function is nonlinear in $\theta$.

We say that we have a correctly specified model for the conditional mean, $E(y \mid x)$, if, for some $\theta_o \in \Theta$,

$$
E(y \mid x) = m(x, \theta_o)
\tag{1}
$$

We introduce the subscript “$o$” on theta to distinguish the parameter vector appearing in $E(y \mid x)$ from other candidates for that vector.

Often, the value $\theta_o$ is called the true value of theta.

---

## M-Estimation

Equation (1) is the most general way of thinking about what nonlinear least squares is intended to do: estimate models of conditional expectations.

As a statistical matter, equation (1) is equivalent to a model with an additive, unobservable error with a zero conditional mean:

$$
y = m(x, \theta_o) + u, \quad E(u \mid x) = 0,
\tag{2}
$$

Given equation (1), we obtain equation (2) by defining the error to be $u \equiv y - m(x, \theta_o)$.

We formalize the first nonlinear least squares (NLS) assumption as follows:

**Assumption NLS.1:** For some $\theta_o \in \Theta$, $E(y \mid x) = m(x, \theta_o)$.

---

## M-Estimation

If we let $w \equiv (x, y)$, then $\theta_o$ indexes a feature of the population distribution of $w$, namely, the conditional mean of $y$ given $x$.

More generally, let $w$ be an $M$-vector of random variables with some distribution in the population.

We let $\mathcal{W}$ denote the subset of $\mathbb{R}^M$ representing the possible values of $w$.

Let $\theta_o$ denote a parameter vector describing some feature of the distribution of $w$ (i.e. a conditional mean).

We assume that $\theta_o$ belongs to a known parameter space $\Theta \subset \mathbb{R}^P$.

We assume that our data come as a random sample of size $N$ from the population; we label this random sample $\{w_i : i = 1, 2, \ldots\}$, where each $w_i$ is an $M$-vector.

---

## M-Estimation

What allows us to estimate $\theta_o$ when it indexes $E(y \mid x)$? It is the fact that $\theta_o$ is the value of $\theta$ that minimizes the expected squared error between $y$ and $m(x; \theta)$.

That is, $\theta_o$ solves the population problem

$$
\min_{\theta \in \Theta} E\left\{[y - m(x, \theta)]^2\right\},
\tag{3}
$$

where the expectation is over the joint distribution of $(x, y)$.

Because $\theta_o$ solves the population problem in expression (3), the analogy principle suggests estimating $\theta_o$ by solving the sample analogue.

---

## M-Estimation

In other words, we replace the population moment $E\{[(y - m(x, \theta)]^2\}$ with the sample average.

The NLS estimator of $\theta_o$, $\hat{\theta}$, solves

$$
\min_{\theta \in \Theta} N^{-1} \sum_{i=1}^N [y_i - m(x_i, \theta)]^2
\tag{4}
$$

For now, we assume that a solution to this problem exists.

The NLS objective function in expression (3) is a special case of a more general class of estimators. Let $q(w, \theta)$ be a function of the random vector $w$ and the parameter vector $\theta$.

---

## M-Estimation

An M-estimator of $\theta_o$ solves the problem

$$
\min_{\theta \in \Theta} N^{-1} \sum_{i=1}^N q(w_i, \theta),
\tag{5}
$$

assuming that a solution, call it $\hat{\theta}$, exists. The estimator clearly depends on the sample $\{w_i : i = 1, 2, \ldots\}$, but we suppress that fact in the notation.

The parameter vector $\theta_o$ is assumed to uniquely solve the population problem

$$
\min_{\theta \in \Theta} E[q(w, \theta)],
\tag{6}
$$
