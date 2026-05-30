# Microeconometría I

**Maestría en Econometría**  
**Lecture 4**  
Martín González-Rozada (UTDT)  
Microeconometría I - Tercer Trimestre, 2024

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

How do we translate the fact that $\theta_o$ solves the population problem (6) into consistency of the M-estimator $\hat{\theta}$ that solves problem (5)?

Heuristically, the argument is as follows. Since for each $\theta \in \Theta$, $\{q(w_i, \theta) : i = 1, 2, \ldots\}$ is just an i.i.d. sequence, the law of large numbers implies that

$$
N^{-1}\sum_{i=1}^N q(w_i, \theta) \xrightarrow{p} E[q(w, \theta)],
\tag{7}
$$

under very weak finite moment assumptions.

Since $\hat{\theta}$ minimizes the function on the left hand side of (7) and $\theta_o$ minimizes the function on the right, it seems plausible that $\hat{\theta} \xrightarrow{p} \theta_o$.

---

## M-Estimation

There are essentially two issues to address.

The first is identifiability of $\theta_o$, which is purely a population issue.

The second is the sense in which the convergence in equation (7) happens across different values of $\theta$ in $\Theta$.

For nonlinear regression, we showed how $\theta_o$ solves the population problem (3).

However, we did not argue that $\theta_o$ is always the unique solution to problem (3).

Whether or not this is the case depends on the distribution of $x$ and the nature of the regression function:

**Assumption NLS.2:**

$$
E\left\{[m(x, \theta_o) - m(x, \theta)]^2\right\} > 0,
\quad \text{all } \theta \in \Theta, \ \theta \neq \theta_o.
$$

Assumption NLS.2 plays the same role as the assumption of no multicollinearity in OLS.

---

## M-Estimation

For the general M-estimation case, we assume that $q(w, \theta)$ has been chosen so that $\theta_o$ is a solution to problem (6).

Identification requires that $\theta_o$ be the unique solution:

$$
E[q(w, \theta_o)] < E[q(w, \theta)],
\quad \text{all } \theta \in \Theta, \ \theta \neq \theta_o,
\tag{8}
$$

The second component for consistency of the M-estimator is convergence of the sample average $N^{-1}\sum_{i=1}^N q(w_i, \theta)$ to its expected value.

It is not enough to simply invoke the usual weak law of large numbers at each $\theta \in \Theta$.

---

## M-Estimation

Instead, uniform convergence in probability is sufficient. Mathematically,

$$
\max_{\theta \in \Theta}
\left|
N^{-1}\sum_{i=1}^N q(w_i, \theta) - E[q(w, \theta)]
\right| \xrightarrow{p} 0,
\tag{9}
$$

Uniform convergence clearly implies pointwise convergence, but the converse is not true: it is possible for equation (7) to hold but equation (9) to fail.

To state a formal result concerning uniform convergence, we need to be more careful in stating assumptions about the function $q(\cdot, \cdot)$ and the parameter space $\Theta$.

Technically, we should assume that $q(\cdot, \theta)$ is a Borel measurable function on $W$ for each $\theta \in \Theta$.

---

## M-Estimation

The next assumption concerning $q$ is practically more important.

We assume that, for each $w \in W$, $q(w, \cdot)$ is a continuous function over the parameter space $\Theta$.

We can now state a theorem concerning uniform convergence appropriate for the random sampling environment. This result, known as the uniform weak law of large numbers (UWLLN), dates back to LeCam (1953).

**Theorem 1 (Uniform Weak Law of Large Numbers):** Let $w$ be a random vector taking values in $W \subset \mathbb{R}^M$, let $\Theta$ be a subset of $\mathbb{R}^P$ and let $q : W \times \Theta \to \mathbb{R}$ be a real valued function. Assume that:

(a) $\Theta$ is compact;  
(b) for each $\theta \in \Theta$, $q(\cdot, \theta)$ is Borel measurable on $W$;  
(c) for each $w \in W$, $q(w, \cdot)$ is continuous on $\Theta$; and  
(d) $|q(w, \theta)| \leq b(w)$ for all $\theta \in \Theta$, where $b$ is a nonnegative function on $W$ such that $E[b(w)] < \infty$.

Then equation (9) holds.

---

## M-Estimation

**Theorem 2 (Consistency of M-Estimators):** Under the assumptions of Theorem 1, assume that the identification assumption (8) holds. Then a random vector, $\hat{\theta}$, solves problem (5), and

$$
\hat{\theta} \xrightarrow{p} \theta_o.
$$

**Lemma 1:** Suppose that $\hat{\theta} \xrightarrow{p} \theta_o$, and assume that $r(w, \theta)$ satisfies the same assumptions on $q(w, \theta)$ in Theorem 2. Then

$$
N^{-1}\sum_{i=1}^N r\left(w_i, \hat{\theta}\right)
\ \xrightarrow{p}\
E[r(w, \theta_o)],
\tag{10}
$$

That is $N^{-1}\sum_{i=1}^N r\left(w_i, \hat{\theta}\right)$ is a consistent estimator of $E[r(w, \theta_o)]$.

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

The simplest asymptotic normality proof proceeds as follows.

Assume that $\theta_o$ is in the interior of $\Theta$, which means that $\Theta$ must have nonempty interior (this assumption is true in most applications). Then, since $\hat{\theta} \xrightarrow{p} \theta_o$, $\hat{\theta}$ is in the interior of $\Theta$ with probability approaching one.

If $q(w, \cdot)$ is continuously differentiable on the interior of $\Theta$, then (with probability approaching one) $\hat{\theta}$ solves the first-order condition

$$
\sum_{i=1}^N s\left(w_i, \hat{\theta}\right) = 0,
\tag{11}
$$

where $s(w, \theta)$ is the $P \times 1$ vector of partial derivatives of $q(w, \theta)$:

$$
s(w, \theta)' = \nabla_{\theta} q(w, \theta)
\equiv
\left[
\frac{\partial q(w, \theta)}{\partial \theta_1},
\frac{\partial q(w, \theta)}{\partial \theta_2},
\ldots,
\frac{\partial q(w, \theta)}{\partial \theta_P}
\right].
$$

(That is, $s(w, \theta)$ is the transpose of the gradient of $q(w, \theta)$).

We call $s(w, \theta)$ the score of the objective function $q(w, \theta)$.

---

## M-Estimation

If $q(w, \theta)$ is twice continuously differentiable, then each row of the left-hand side of equation (11) can be expanded about $\theta_o$ in a mean-value expansion:

$$
\sum_{i=1}^N s\left(w_i, \hat{\theta}\right)
= \sum_{i=1}^N s(w_i, \theta_o)
+ \left(\sum_{i=1}^N \ddot{H}_i\right)
\left(\hat{\theta} - \theta_o\right),
\tag{12}
$$

The notation $\ddot{H}_i$ denotes the $P \times P$ Hessian of the objective function, $q(w_i, \theta)$, with respect to $\theta$, but with each row of

$$
H(w_i, \theta) \equiv
\frac{\partial^2 q(w_i, \theta)}{\partial \theta \, \partial \theta'}
\equiv \nabla_{\theta}^2 q(w_i, \theta)
$$

evaluated at a different mean value.

---

## M-Estimation

Combining equations (11) and (12) and multiplying through by $1/\sqrt{N}$ gives

$$
0 = N^{-1/2}\sum_{i=1}^N s(w_i, \theta_o)
+ \left(N^{-1}\sum_{i=1}^N \ddot{H}_i\right)
\sqrt{N}\left(\hat{\theta} - \theta_o\right),
\tag{13}
$$

Using Lemma 1 we get

$$
N^{-1}\sum_{i=1}^N \ddot{H}_i \xrightarrow{p} E[H(w, \theta_o)].
$$

If $A_o \equiv E[H(w, \theta_o)]$ is nonsingular, then $N^{-1}\sum_{i=1}^N \ddot{H}_i$ is nonsingular w.p.a. 1 and

$$
\left(N^{-1}\sum_{i=1}^N \ddot{H}_i\right)^{-1}
\xrightarrow{p} A_o^{-1}.
$$

Therefore, we can write

$$
\sqrt{N}\left(\hat{\theta} - \theta_o\right)
=
\left(N^{-1}\sum_{i=1}^N \ddot{H}_i\right)^{-1}
\left[-N^{-1/2}\sum_{i=1}^N s_i(\theta_o)\right],
\tag{14}
$$

where $s_i(\theta_o) \equiv s(w_i, \theta_o)$.

---

## M-Estimation

Since $o_p(1) \cdot O_p(1) = o_p(1)$ we have,

$$
\sqrt{N}\left(\hat{\theta} - \theta_o\right)
= A_o^{-1}
\left[-N^{-1/2}\sum_{i=1}^N s_i(\theta_o)\right]
+ o_p(1),
\tag{15}
$$

This is an important equation. It shows that $\sqrt{N}(\theta - \theta_o)$ inherits its limiting distribution from the average of the scores, evaluated at $\theta_o$. The matrix $A_0^{-1}$ simply acts as linear transformation.

Absorbing this linear transformation into $s_i(\theta_o)$, we can write

$$
\sqrt{N}\left(\hat{\theta} - \theta_o\right)
= N^{-1/2}\sum_{i=1}^N e_i(\theta_o) + o_p(1),
\tag{16}
$$

where $e_i(\theta_o) \equiv -A_o^{-1}s_i(\theta_o)$; this is sometimes called the influence function representation of $\theta$, where $e(w, \theta)$ is the influence function.

---

## M-Estimation

**THEOREM 3 (Asymptotic Normality of M-Estimators):** In addition to the assumptions in Theorem 2, assume:

(a) $\theta_o$ is in the interior of $\Theta$;  
(b) $s(w, \cdot)$ is continuously differentiable on the interior of $\Theta$ for all $w \in W$;  
(c) each element of $H(w, \theta)$ is bounded in absolute value by a function $b(w)$, where $E[b(w)] < \infty$;  
(d) $A_0 \equiv E[H(w, \theta_o)]$ is positive definite;  
(e) $E[s(w, \theta_o)] = 0$; and  
(f) each element of $s(w, \theta_o)$ has finite second moment.

Then

$$
\sqrt{N}\left(\hat{\theta} - \theta_o\right)
\xrightarrow{d}
\operatorname{Normal}\left(0, A_o^{-1}B_oA_o^{-1}\right),
\tag{17}
$$

where

$$
A_o \equiv E[H(w, \theta_o)]
$$

and

$$
B_o \equiv E\left[s(w, \theta_o)s(w, \theta_o)'\right]
= \operatorname{Var}[s(w, \theta_o)].
$$

Thus,

$$
Avar(\hat{\theta}) = A_o^{-1}B_oA_o^{-1}/N.
\tag{18}
$$
