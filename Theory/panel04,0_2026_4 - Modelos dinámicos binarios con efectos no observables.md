# Modelos dinámicos binarios con efectos no observables

## Modelos Dinámicos con Efectos no Observables

Supongamos que la primera observación es con $t = 0$, de forma tal que $y_{j0}$ es la primera observación de la variable $y$. Para $t = 1, 2, ..., T$ estamos interesados el el modelo dinámico:

$$
P(y_{jt} = 1 \mid y_{j,t-1}, ..., y_{j0}, Z_j, c_j) = G(z_{jt}\delta + \rho y_{j,t-1} + c_j)
$$

Donde $z_{jt}$ es un vector de variables explicativas contemporáneas, $Z_j = (z_{j1}, \ldots, z_{jT})$ y $G$ puede ser la función Probit o Logit.

Los puntos importantes del modelo anterior son:

Primero, los $z_{jt}$ se asume que satisfacen un supuesto de exogeneidad estricta (condicional en $c_j$) dado que $Z_j$ aparece en el conjunto de condiciones del lado izquierdo de la ecuación pero solo aparece $z_{jt}$ en el lado derecho.

Segundo, la probabilidad de éxito en $t$ depende del resultado en $t - 1$ y de los efectos no observables, $c_j$.

---

## Modelos Dinámicos con Efectos no Observables

Como podríamos estimar $\delta$ y $\rho$ en la ecuación anterior?

Primero podemos construir la función de probabilidad conjunta de las observaciones de la muestra: $f(y_1, y_2, ..., y_T \mid y_0, z, c; \beta)$

$$
= \prod_{t=1}^{T} f(y_t \mid y_{t-1}, ..., y_1, y_0, z_t, c; \beta)
$$

$$
= \prod_{t=1}^{T} G(z_t\delta + \rho y_{t-1} + c)^{y_t}
\left[1 - G(z_t\delta + \rho y_{t-1} + c)\right]^{1-y_t}
\tag{D.1}
$$

El problema es que con $T$ fijo, debido a la presencia del efecto no observable $c$, no se puede construir la función de verosimilitud que nos permita estimar $\beta$ consistentemente.

Tal como pasaba en el caso con variables estrictamente exógenas, tratar a los $c_j$ como parámetros a ser estimados no permite obtener estimadores consistentes de $\delta$ y $\rho$ cuando $N \to \infty$.

---

## Modelos Dinámicos con Efectos no Observables

Lo que uno debe hacer en este caso es eliminar $c$ vía integración como hicimos antes. El problema ahora es que para hacer esto hay que realizar algún supuesto acerca del comportamiento de la primera observación de $y$, $y_{j0}$.

Una forma de proceder es obtener la distribución conjunta de $(y_{j1}, y_{j2}, ..., y_{jT})$ condicional en $(y_{j0}, Z_j)$.

Para obtener $f(y_1, y_2, ..., y_T \mid y_0, z, \theta)$ necesitamos la densidad de $c_j$ dado $(y_{j0}, Z_j)$.

Dada una densidad $h(c \mid y_0, z; \gamma)$ tenemos $f(y_1, y_2, ..., y_T \mid y_0, z, \theta)$

$$
= \int_{-\infty}^{\infty} f(y_1, y_2, ..., y_T \mid y_0, z, c; \beta) h(c \mid y_0, z; \gamma) \, dc
$$

La integral puede ser reemplazada por una suma ponderada si la distribución de $c$ es discreta.

---

## Modelos Dinámicos con Efectos no Observables

Cuando $G = \Phi$ en el modelo (D.1) una elección conveniente para $h(c \mid y_0, z; \gamma)$ es:

$$
\text{Normal}(\psi + \xi_0 y_{j0} + Z_j\xi, \sigma_a^2),
$$

que sigue de escribir

$$
c_j = \psi + \xi_0 y_{j0} + Z_j\xi + a_j,
$$

 donde $a_j \sim \text{Normal}(0, \sigma_a^2)$ e independiente de $(y_{j0}, Z_j)$.

Por lo tanto se puede escribir,

$$
y_{jt} = 1[\psi + z_{jt}\delta + \rho y_{j,t-1} + \xi_0 y_{j0} + Z_j\xi + a_j + e_{jt} > 0]
$$

Tal que $y_{jt}$ dado $(y_{j,t-1}, ..., y_{j0}, Z_j, a_j)$ sigue un modelo Probit.

---

## Modelos Dinámicos con Efectos no Observables

Por lo tanto, la densidad de $(y_{j1}, ..., y_{jT})$ dado $(y_{j0}, Z_j)$ tiene la siguiente forma:

$$
L(c_j, \beta) = \int_{-\infty}^{\infty}
\left[\prod_{j=1}^{N} \prod_{t=1}^{T}
\Phi(x_{jt}\beta + c_j)^{y_{jt}}
\left[1 - \Phi(x_{jt}\beta + c_j)\right]^{1-y_{jt}}
\right]
* (1/\sigma_c)\phi(c/\sigma_c) \, dc
$$

Donde $x_{jt} = (1, z_{jt}, y_{j,t-1}, y_{j0}, Z_j)$ y con $a$ y $\sigma_a$ reemplazando a $c$ y $\sigma_c$.

Este resultado implica que podemos utilizar el software del Probit de efectos aleatorios para estimar $\psi$, $\delta$, $\rho$, $\xi_0$, $\xi$, y $\sigma_c^2$.

---

## Supuestos

Se tienen los siguientes supuestos:

$$
P(y_{jt} = 1 \mid X_j, c_j) = P(y_{jt} = 1 \mid x_{jt}, c_j)
$$

$$
= \Phi(x_{jt}\beta + c_j), \quad t = 1, 2, ..., T. \tag{2}
$$

$$
y_{j1}, y_{j2}, ..., y_{jT} \text{ son independientes condicionando en } (X_j, c_j). \tag{3}
$$

$$
c_j \mid X_j \sim \text{Normal}(0, \sigma_c^2) \tag{4}
$$

Back

---

## Supuestos

Si escribimos el supuesto (2) en forma de variable latente tenemos:

$$
y^*_{jt} = x_{jt}\beta + c_j + u_{jt}, \quad \text{con } y_{jt} = 1[y^*_{jt} > 0]
$$

 y $u_{jt} \mid X_j, c_j \sim N(0, 1)$. Además se cumple (4).

Con estos supuestos $c_j + u_{jt} \sim N(0, 1 + \sigma_c^2)$.

Por lo tanto:

$$
P(y_{jt} = 1 \mid X_j) = P(c_j + u_{jt} > -x_{jt}\beta \mid X_j)
$$

$$
= \Phi\left[\frac{x_{jt}\beta}{(1 + \sigma_c^2)^{1/2}}\right], \quad t = 1, 2, ..., T.
$$

Se sigue inmediatamente de la ecuación anterior que pooled Probit de $y$ sobre $X$ estima consistentemente:

$$
\beta_c = \beta / (1 + \sigma_c^2)^{1/2}
$$

Back

---

## References

Chamberlain, G (1980) “Analysis of covariance with qualitative data,” *Review of Economic Studies*, 47, pp. 225-238.

Mundlak, Y. (1978) “On the pooling of time series and cross section data,” *Econometrica*, 46, 69-85.
