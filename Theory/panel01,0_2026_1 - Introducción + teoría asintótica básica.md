# Econometría de Datos de Panel

**Maestrías en Economía y Econometría**  
**Lecture 1**

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel — Primer Trimestre, 2026

---

## Agenda

1. Introducción
2. Teoría Asintótica
3. Modelos de Datos de Panel Lineales
4. Modelos de Efectos Fijos y Aleatorios
   - Modelo de Efectos Aleatorios
   - Modelo de Efectos Fijos
     - Transformación de Efectos Fijos ó *Within Transformation*
     - Modelo de Variables Binarias (LSDV)
     - Transformación de Diferencias Finitas
     - Transformación por Desviaciones Ortogonales
5. Two-Way Fixed Effects Model

---

## Introducción

**Datos de Corte Transversal**

$$
j = 1, 2, \ldots, N
$$

**Datos de Series Temporales**

$$
t = 1, 2, \ldots, T
$$

**Datos de Panel**

$$
j = 1, 2, \ldots, N \quad \text{y} \quad t = 1, 2, \ldots, T
$$

---

## Introducción

[Figura: gráfico de salario real promedio del Decil 1, con observaciones por año entre 1992 y 2002.]

- Datos Longitudinales. $N$ es fijo y $T \longrightarrow \infty$.
- Datos de Panel. $N \longrightarrow \infty$ y $T$ es fijo.

---

## Convergencia en Probabilidad

1. Una secuencia de variables aleatorias $\{x_N : N = 1, 2, \ldots\}$ converge en probabilidad a la constante $a$ si para todo $\varepsilon > 0$,

$$
\lim_{N \to \infty} P\left[\left|x_N - a\right| > \varepsilon\right] = 0.
$$

En general, escribimos

$$
x_N \xrightarrow{p} a
$$

y decimos que $a$ es el $p$-límite de $x_N$.

2. En el caso especial en que $a = 0$, también decimos que $\{x_N\}$ es $o_p(1)$ (o pequeña p uno). En este caso escribimos

$$
x_N = o_p(1)
$$

ó

$$
x_N \xrightarrow{p} 0.
$$

3. Una secuencia de variables aleatorias $\{x_N\}$ está limitada en probabilidad (*bounded in probability*) sí y solo sí para cada $\varepsilon > 0$, existe un $b_\varepsilon < \infty$ y un entero $N_\varepsilon$, tal que:

$$
P\left[\left|x_N\right| \geq b_\varepsilon\right] < \varepsilon \quad \text{para todo } N > N_\varepsilon.
$$

---

## Convergencia en Probabilidad

En este caso escribimos

$$
x_N = O_p(1)
$$

($\{x_N\}$ es O grande p uno).

**Lema 1:** si

$$
x_N \xrightarrow{p} a,
$$

entonces

$$
x_N = O_p(1).
$$

4. Una secuencia aleatoria $\{x_N : N = 1, 2, \ldots\}$ es $o_p(N^\delta)$ para $\delta \in \mathbb{R}$ si

$$
N^{-\delta}x_N = o_p(1).
$$

**Lema 2:** si $w_N = o_p(1)$, $x_N = o_p(1)$, $y_N = O_p(1)$, y $z_N = O_p(1)$, entonces

1. $w_N + x_N = o_p(1)$;
2. $y_N + z_N = O_p(1)$;
3. $y_N \times z_N = O_p(1)$;
4. $x_N \times z_N = o_p(1)$.

Todas las definiciones anteriores se aplican elemento por elemento a secuencias de vectores y matrices.

**Lema 3:** Sea $\{Z_N : N = 1, 2, \ldots\}$ una secuencia de matrices $J \times K$ tal que

$$
Z_N = o_p(1),
$$

y sea $\{x_N\}$ una secuencia de vectores aleatorios $J \times 1$ tal que

$$
x_N = O_p(1).
$$

Entonces

$$
Z_N' x_N = o_p(1).
$$

---

## Convergencia en Probabilidad

**Lema 4 (Teorema de Slutsky):** Sea

$$
g : \mathbb{R}^K \to \mathbb{R}^J
$$

una función continua en algun punto $c \in \mathbb{R}^K$. Sea $\{x_N : N = 1, 2, \ldots\}$ una secuencia de vectores aleatorios $K \times 1$ tal que

$$
x_N \xrightarrow{p} c.
$$

Entonces

$$
g(x_N) \xrightarrow{p} g(c)
$$

cuando $N \to \infty$.

En otras palabras:

$$
\operatorname{plim} g(x_N) = g\left(\operatorname{plim} x_N\right)
$$

si $g(\cdot)$ es continua en $\operatorname{plim} x_N$.

**Definición 1:** Sea $(\Omega, \mathcal{F}, P)$ un espacio de probabilidad. Una secuencia de eventos $\{\Omega_N : N = 1, 2, \ldots\} \subset \mathcal{F}$ se dice que ocurre con probabilidad aproximándose a uno (w.p.a. 1) sí y solo sí

$$
P(\Omega_N) \to 1
$$

cuando $N \to \infty$.

**Corolario 1:** Sea $\{Z_N : N = 1, 2, \ldots\}$ una secuencia de matrices aleatorias $K \times K$, y sea $A$ una matriz invertible no aleatoria $K \times K$. Si

$$
Z_N \xrightarrow{p} A,
$$

entonces:

1. $Z_N^{-1}$ existe w.p.a. 1.
2. $Z_N^{-1} \xrightarrow{p} A^{-1}$.

---

## Convergencia en Distribución

**Definición 2:** Una secuencia de variables aleatorias $\{x_N : N = 1, 2, \ldots\}$ converge en distribución a la variable aleatoria continua $x$ sí y solo sí

$$
F_N(\xi) \to F(\xi)
$$

cuando $N \to \infty$ para todo $\xi \in \mathbb{R}$.

Donde $F_N$ es la función de distribución acumulada de $x_N$ y $F$ es la función de distribución acumulada de $x$. En este caso escribimos:

$$
x_N \xrightarrow{d} x.
$$

**Definición 3:** Una secuencia de vectores aleatorios $\{x_N : N = 1, 2, \ldots\}$, $K \times 1$, converge en distribución al vector aleatorio continuo $x$ sí y solo sí para cualquier vector no aleatorio $K \times 1$, $c$, tal que

$$
c'c = 1,
$$

se cumple que

$$
c'x_N \xrightarrow{d} c'x
$$

y escribimos

$$
x_N \xrightarrow{d} x.
$$

**Lema 5:** Si

$$
x_N \xrightarrow{d} x,
$$

donde $x$ es cualquier vector aleatorio $K \times 1$, entonces

$$
x_N = O_p(1).
$$

---

## Convergencia en Distribución

**Lema 6 (*Continuous mapping theorem*):** Sea $\{x_N\}$ una secuencia de vectores aleatorios $K \times 1$, tal que

$$
x_N \xrightarrow{d} x.
$$

Si

$$
g : \mathbb{R}^K \to \mathbb{R}^J
$$

es una función continua, entonces

$$
g(x_N) \xrightarrow{d} g(x).
$$

**Corolario 2:** Si $\{z_N\}$ es una secuencia de vectores aleatorios $K \times 1$, tal que

$$
z_N \xrightarrow{d} N(0,V),
$$

entonces:

1. Para cualquier matriz no aleatoria $K \times M$, $A$:

$$
A'z_N \xrightarrow{d} N(0, A'VA).
$$

2. 

$$
z_N'V^{-1}z_N \xrightarrow{d} \chi_K^2.
$$

**Lema 7:** Sean $\{x_N\}$ y $\{z_N\}$ secuencias de vectores aleatorios $K \times 1$. Si

$$
z_N \xrightarrow{d} z
$$

y

$$
z_N - x_N \xrightarrow{p} 0,
$$

entonces

$$
x_N \xrightarrow{d} z.
$$

**Teorema 1:** Sea $\{w_j : j = 1, 2, \ldots\}$ una secuencia de vectores aleatorios $G \times 1$, independientes, idénticamente distribuidos tal que

$$
E\left(\left|w_{jg}\right|\right) < \infty,
\quad g = 1, 2, \ldots, G.
$$

Entonces la secuencia satisface la ley débil de los grandes números (WLLN):

$$
N^{-1}\sum_{j=1}^{N} w_j \xrightarrow{p} \mu_w,
$$

donde

$$
\mu_w = E(w_j).
$$

---

## Convergencia en Distribución

**Teorema 2 (Lindeberg-Levy):** Sea $\{w_j : j = 1, 2, \ldots\}$ una secuencia de vectores aleatorios $G \times 1$, independientes, idénticamente distribuidos tal que

$$
E\left(\left|w_{jg}\right|^2\right) < \infty,
\quad g = 1, 2, \ldots, G,
$$

y

$$
E(w_j) = 0.
$$

Entonces la secuencia satisface el teorema central del límite (CLT):

$$
N^{-1/2}\sum_{j=1}^{N} w_j \xrightarrow{d} N(0,B),
$$

donde

$$
B = \operatorname{Var}(w_j) = E(w_jw_j').
$$
