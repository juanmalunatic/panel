# Econometría de Datos de Panel

Maestrías en Economía y Econometría  
Lecture 4  
Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026

---

## Agenda

1. Modelos de Respuesta Binaria
   - Modelo Probit de Efectos no Observables
   - Modelo Logit de Efectos no Observables
2. Modelos Dinámicos de Respuesta Binaria con Efectos no Observables

---

## Modelo Logit de Efectos no Observables

Reemplazando la función de distribución acumulada de la normal estándar por la de la logística en (2) tenemos:

$$
P(y_{jt}=1 \mid X_j,c_j)=P(y_{jt}=1 \mid x_{jt},c_j)=\Lambda(x_{jt}\beta+c_j), \quad t=1,2,\ldots,T.
\tag{6}
$$

Manteniendo los supuestos (3) y (4) llegamos a lo que se conoce como el modelo Logit de efectos aleatorios.

Este modelo no es tan atractivo como el modelo Probit de efectos aleatorios porque no existen estimadores fáciles de obtener.

El modelo Probit de efectos aleatorios utiliza el hecho de que la combinación de dos funciones normales es otra normal. En el caso del Logit, $P(y_{jt}=1 \mid X_j)$ no tiene una forma simple porque hay que integrar la función $\Lambda(X_t\beta+c)$ con respecto a la densidad de la normal $(1/\sigma_c)\phi(c/\sigma_c)$ lo que no da una forma funcional simple.

---

## Modelo Logit de Efectos no Observables

La mayor ventaja del modelo Logit de efectos no observables por sobre el Probit es que bajo los supuestos (6) y (3) es posible obtener estimaciones consistentes de $\beta$ sin hacer supuestos acerca de la relación de $c_j$ con $x_{jt}$.

En el caso lineal, utilizamos la transformación de FE ó FD para eliminar $c_j$ de la ecuación a estimar.

En el caso del Logit, se puede emplear una estrategia similar. Lo que necesitamos hacer es encontrar la distribución conjunta de

$$
y_j \equiv (y_{j1},y_{j2},\ldots,y_{jT})'
$$

condicional a $X_j$, $c_j$ y

$$
n_j \equiv \sum_{t=1}^{T} y_{jt}.
$$

Se puede verificar que esta distribución no depende de $c_j$ tal que queda la distribución de $y_j$ condicionada a $X_j$ y $n_j$.

---

## Modelo Logit de Efectos no Observables

Ilustremos el caso con $T=2$, donde $n_j$ puede adoptar los valores $0,1,2$.

Intuitivamente la distribución condicional de $(y_{j1},y_{j2})'$ dado $n_j$ no puede ser informativa acerca de $\beta$ cuando $n_j=0$ ó $n_j=2$ porque esos valores determinan completamente el resultado de $y_j$.

Sin embargo para $n_j=1$ tenemos:

$$
P(y_{j2}=1 \mid X_j,c_j,n_j=1)
= \frac{P(y_{j2}=1,n_j=1 \mid X_j,c_j)}{P(n_j=1 \mid X_j,c_j)}
$$

$$
= \frac{P(y_{j2}=1 \mid X_j,c_j)P(y_{j1}=0 \mid X_j,c_j)}{\left\{P(y_{j1}=0,y_{j2}=1 \mid X_j,c_j)+P(y_{j1}=1,y_{j2}=0 \mid X_j,c_j)\right\}}
$$

$$
= \frac{\Lambda(x_{j2}\beta+c_j)[1-\Lambda(x_{j1}\beta+c_j)]}{\left\{[1-\Lambda(x_{j1}\beta+c_j)]\Lambda(x_{j2}\beta+c_j)+\Lambda(x_{j1}\beta+c_j)[1-\Lambda(x_{j2}\beta+c_j)]\right\}}
$$

$$
= \Lambda[(x_{j2}-x_{j1})\beta].
$$

---

## Modelo Logit de Efectos no Observables

Similarmente,

$$
P(y_{j1}=1 \mid X_j,c_j,n_j=1)=\Lambda[-(x_{j2}-x_{j1})\beta]
$$

$$
=1-\Lambda[(x_{j2}-x_{j1})\beta].
$$

El logaritmo de la función de verosimilitud condicional para la observación $j$ se puede escribir como:

$$
\ell_j(\beta)=1[n_j=1]\left(w_j\log\Lambda[(x_{j2}-x_{j1})\beta]+(1-w_j)\log\{1-\Lambda[(x_{j2}-x_{j1})\beta]\}\right).
$$

Donde $w_j=1$ si $(y_{j1}=0,y_{j2}=1)$ y $w_j=0$ si $(y_{j1}=1,y_{j2}=0)$.

El estimador de máxima verosimilitud condicional se obtiene maximizando la suma de $\ell_j(\beta)$ sobre $j$.

La función indicador $1[n_j=1]$ selecciona las observaciones para las que $n_j=1$.

Note que la función de verosimilitud anterior es la función estándar del Logit de corte transversal para una regresión de $w_j$ sobre $x_{j2}-x_{j1}$ utilizando las observaciones para las que $n_j=1$.

---

## Modelo Logit de Efectos no Observables

El estimador de máxima verosimilitud condicional que se obtiene en este caso se denomina estimador Logit de efectos fijos.

Lo que hace este tipo de estimación es simplemente encontrar la distribución condicional, que describe la subpoblación con $n_j=1$, que depende solo de los datos observados y de $\beta$.

Para el caso de $T$ general, la función de verosimilitud es un poco más complicada pero tiene un tratamiento posible.

Primero, se tiene que:

$$
P(y_{j1}=y_1,\ldots,y_{jT}=y_T \mid X_j,c_j,n_j=n)
= \frac{P(y_{j1}=y_1,\ldots,y_{jT}=y_T \mid X_j,c_j)}{P(n_j=n \mid X_j,c_j)}.
$$

Y el numerador se puede expresar como:

$$
P(y_{j1}=y_1 \mid X_j,c_j)P(y_{j2}=y_2 \mid X_j,c_j)\cdots P(y_{jT}=y_T \mid X_j,c_j)
$$

usando el supuesto (3). El denominador es la parte complicada pero es fácil de describir.

---

## Modelo Logit de Efectos no Observables

$P(n_j=n \mid X_j,c_j)$ es la suma de las probabilidades de todos los posibles resultados de $y_j$ tal que $n_j=n$.

Usando la forma específica de la función logística podemos escribir:

$$
\ell_j(\beta)=\log\left\{\exp\left(\sum_{t=1}^{T} y_{it}x_{jt}\beta\right)\left[\sum_{a\in R_j}\exp(a_tx_{jt}\beta)\right]^{-1}\right\}.
$$

Donde $R_j$ es un subconjunto de $R^T$ definido como

$$
\left\{a\in R^T: a_t\in\{0,1\}\text{ y }\sum_{t=1}^{T}a_t=n_j\right\}.
$$

El logaritmo de la función de verosimilitud anterior debe sumarse a través de $j$ para luego maximizarse y obtener estimadores de $\beta$ consistentes y asintóticamente normales.

El estimador Logit de efectos fijos de $\beta$ nos da el efecto de cada elemento de $X_t$ en el logaritmo de la tasa de probabilidad.

---

## Modelo Logit de Efectos no Observables

Esto es,

$$
\log\left\{\frac{\Lambda(X_t\beta+c)}{1-\Lambda(X_t\beta+c)}\right\}=X_t\beta+c.
$$

Desafortunadamente, no se puede estimar el efecto parcial sobre la probabilidad de respuesta a menos que insertemos el valor de $c$.

Como la distribución de $c_j$ no esta especificada es difícil saber que valor insertar.

Además, tampoco se pueden calcular los efectos parciales promedio porque requerirían encontrar $E[\Lambda(X_t\beta+c)]$ que necesita una especificación de la distribución de $c_j$.
