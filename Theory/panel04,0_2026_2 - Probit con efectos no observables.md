# panel04,0_2026_2 - Probit con efectos no observables

## Página 1 / 12

# Agenda

1. Modelos de Respuesta Binaria  
   Modelo Probit de Efectos no Observables  
   Modelo Logit de Efectos no Observables

2. Modelos Dinámicos de Respuesta Binaria con Efectos no Observables

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
8 / 49

---

## Página 2 / 12

# Modelo Probit de Efectos no Observables

Este modelo tiene como supuesto principal que:

$$
P(y_{jt} = 1 \mid X_j, c_j) = P(y_{jt} = 1 \mid x_{jt}, c_j) = \Phi(x_{jt}\beta + c_j), \quad t = 1, 2, ..., T
\tag{2}
$$

La primera igualdad dice que \(x_{jt}\) es estrictamente exógeno condicional en \(c_j\).

Esto deja afuera a los modelos dinámicos vistos en el curso.

La segunda igualdad de la condición anterior es el supuesto estándar del Probit.

Además del supuesto de exogeneidad estricta, necesitamos el supuesto estándar de que la variable dependiente es independiente condicional en \((X_j, c_j)\). Esto es:

$$
y_{j1}, y_{j2}, ..., y_{jT}
$$

son independientes condicionando en \((X_j, c_j)\). \((3)\)

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
9 / 49

---

## Página 3 / 12

# Modelo Probit de Efectos no Observables

Bajo estos dos supuestos podemos construir la función de verosimilitud como:

$$
L(c_j, \beta) =
\prod_{j=1}^{N}
\prod_{t=1}^{T}
\Phi(x_{jt}\beta + c_j)^{y_{jt}}
[1 - \Phi(x_{jt}\beta + c_j)]^{1-y_{jt}}
$$

Idealmente, uno podría estimar los parámetros del modelo sin restringir la relación entre \(c_j\) y \(x_{jt}\). Con este espíritu, un modelo Probit de efectos fijos trata a los efectos no observables \(c_j\) como parámetros a estimar.

El logaritmo de la función de verosimilitud es simplemente el logaritmo de la expresión anterior.

Desafortunadamente, además de ser una expresión complicada de estimar, en este modelo estimar juntos los \(\beta\) y los \(c_j\) lleva a obtener estimadores inconsistentes para \(\beta\) con \(T\) fijo y \(N \to \infty\).

Para poder obtener estimaciones consistentes de \(\beta\) necesitamos hacer algún supuesto acerca de la relación entre \(c_j\) y \(x_{jt}\).

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
10 / 49

---

## Página 4 / 12

# Modelo Probit de Efectos no Observables

El modelo tradicional adiciona el siguiente supuesto:

$$
c_j \mid X_j \sim Normal(0, \sigma_c^2)
\tag{4}
$$

Este es un supuesto fuerte porque implica que \(c_j\) y \(X_j\) son independientes y que \(c_j\) tiene distribución normal.

Bajo los supuestos (2), (3) y (4) existe un enfoque de máxima verosimilitud condicional para estimar \(\beta\) y \(\sigma_c^2\).

Como los \(c_j\) no se observan, no pueden aparecer en la función de verosimilitud. En este caso, construimos la función de verosimilitud de \((y_{j1}, y_{j2}, ..., y_{jT})\) condicional a \(X_j\), lo que requiere eliminar los \(c_j\) vía integrarlos entre menos y más infinito (i.e. tienen distribución normal). Por lo tanto:

$$
L(c_j, \beta) =
\int_{-\infty}^{\infty}
\left[
\prod_{j=1}^{N}
\prod_{t=1}^{T}
\Phi(x_{jt}\beta + c_j)^{y_{jt}}
\left[
1 - \Phi(x_{jt}\beta + c_j)
\right]^{1-y_{jt}}
\right]
(1/\sigma_c)\phi(c/\sigma_c)\,dc
$$

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
11 / 49

---

## Página 5 / 12

# Modelo Probit de Efectos no Observables

Tomando el logaritmo de la expresión anterior obtenemos la función objetivo a maximizar para obtener estimadores de \(\beta\) y \(\sigma_c^2\) consistentes y asintóticamente normales.

La estimación por máxima verosimilitud condicional recibe el nombre en la literatura de modelo Probit de efectos aleatorios.

Los supuestos (3) y (4) son bastante fuertes y es posible relajarlos.

Consideremos relajar el supuesto (3).

Bajo los supuestos (2) y (4) solamente,

$$
P(y_{jt} = 1 \mid X_j) = P(y_{jt} = 1 \mid x_{jt}) = \Phi(x_{jt}\beta_c), \quad t = 1, 2, ..., T.
$$

Donde

$$
\beta_c = \frac{\beta}{(1 + \sigma_c^2)^{1/2}}.
$$

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
12 / 49

---

## Página 6 / 12

# Modelo Probit de Efectos no Observables

Acabamos de mostrar que Pooled Probit de \(y\) sobre \(X\) estima consistentemente:

$$
\beta_c = \frac{\beta}{(1 + \sigma_c^2)^{1/2}}
$$

en lugar de \(\beta\), por lo tanto, el problema de los efectos no observables es más grave en el modelo Probit que en modelos lineales ya que aun cuando \(c_j\) y \(X_j\) sean independientes los coeficientes estimados son inconsistentes.

Sin embargo, usualmente uno está interesado en el efecto parcial de las variables independientes sobre la variable dependiente y en estos casos estimar \(\beta_c\) es igual de bueno que estimar \(\beta\).

Para ilustrar este punto calculemos el efecto parcial para una variable \(x_{jt}\) contínua,

$$
\partial P(y_{jt} = 1 \mid X_j, c_j) / \partial x_{jt}
=
\beta_j \phi(x_{jt}\beta + c_j)
$$

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
13 / 49

---

## Página 7 / 12

# Modelo Probit de Efectos no Observables

Usualmente lo que uno hace en la práctica es calcular el efecto parcial promedio. Esto es, se reemplazan las variables \(x_{jt}\) por sus promedios y se promedia la ecuación anterior a lo largo de la distribución de \(c\) en la población.

Es decir:

$$
E_c[\beta_j \phi(x\beta + c_j)]
=
\left[
\frac{\beta_j}{(1 + \sigma_c^2)^{1/2}}
\right]
\phi
\left[
\frac{x\beta}{(1 + \sigma_c^2)^{1/2}}
\right]
$$

En otras palabras, pooled Probit de \(y\) sobre \(X\) estima consistentemente los efectos parciales promedio, que es lo que uno usualmente quiere.

Sin embargo, como sucedía en el caso lineal, muchas veces el punto de introducir los efectos no observables es permitir explícitamente que estén correlacionados con las variables explicativas.

Chamberlain (1980) permite esta correlación asumiendo una distribución normal condicional con esperanza lineal y varianza constante.

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
14 / 49

---

## Página 8 / 12

# Modelo Probit de Efectos no Observables

La versión de Mundlak (1978) del supuesto de Chamberlain es:

$$
c_j \mid X_j \sim Normal(\psi + \bar{X}_j \xi, \sigma_a^2)
\tag{5}
$$

Donde \(\bar{X}_j\) es el promedio de las \(x_{jt}\), \(t = 1, 2, ..., T\) y \(\sigma_a^2\) es la varianza de \(a_j\) en la ecuación:

$$
c_j = \psi + \bar{X}_j \xi + a_j
$$

Chamberlain permite una mayor generalidad reemplazando \(\bar{X}_j\) con \(X_j\) en el supuesto anterior. Esta mayor generalización tiene como contrapartida menos grados de libertad.

Chamberlain llamó al modelo dado por (2) y (5) un modelo Probit de efectos aleatorios, y la literatura se refiere a este modelo como el modelo Probit de efectos aleatorios de Chamberlain.

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
15 / 49

---

## Página 9 / 12

# Modelo Probit de Efectos no Observables

Si los supuestos (2), (3) y (5) se cumplen, la estimación de \(\beta\), \(\psi\), \(\xi\), y \(\sigma_a^2\) es directa porque podemos escribir el modelo en forma de variable latente como:

$$
y^*_{jt} = \psi + x_{jt}\beta + \bar{X}_j\xi + a_j + u_{jt}
$$

En otras palabras, adicionando \(\bar{X}_j\) a la ecuación para cada período temporal llegamos al modelo tradicional Probit con efectos aleatorios.

Note que el efecto de asumir que la esperanza de los efectos no observables es lineal provoca el mismo efecto que en la corrección de Wooldridge en el caso de los paneles no balanceados. Allí aparecía en la ecuación de interés el término \(\bar{X}_j\pi\) y ahora aparece \(\bar{X}_j\xi\) debido al supuesto de Mundlak.

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
16 / 49

---

## Página 10 / 12

# Modelo Probit de Efectos no Observables

Dadas las estimaciones de \(\psi\) y \(\xi\) podemos estimar

$$
E(c_j) = \psi + E(\bar{X}_j)\xi
$$

con

$$
\hat{\psi} + \bar{X}\hat{\xi}
$$

Donde \(\bar{X}\) es la media muestral de \(\bar{X}_j\).

Por lo tanto para cualquier vector \(X_t\), podemos estimar la probabilidad de respuesta en \(E(c_j)\) como:

$$
\Phi\left(\hat{\psi} + X_t \hat{\beta} + \bar{X}\hat{\xi}\right)
$$

Tomando derivadas con respecto a los elementos de \(X_t\) podemos estimar los efectos parciales de las variables sobre las probabilidades de respuesta.

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
17 / 49

---

## Página 11 / 12

# Modelo Probit de Efectos no Observables

Si solo asumimos (2) y (5):

$$
P(y_{jt} = 1 \mid X_j)
=
\Phi
\left[
\left(\psi + x_{jt}\beta + \bar{X}_j\xi\right)
(1 + \sigma_a^2)^{-1/2}
\right]
\equiv
\Phi(\psi_a + x_{jt}\beta_a + \bar{X}_j\xi_a)
$$

Donde el subíndice \(a\) indica que el vector de parámetros ha sido multiplicado por \((1 + \sigma_c^2)^{-1/2}\).

Se sigue inmediatamente que \(\beta_a\), \(\psi_a\), y \(\xi_a\) pueden estimarse consistentemente usando pooled Probit en \(y_{jt}\) sobre \(1\), \(x_{jt}\), y \(\bar{X}_j\).

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
18 / 49

---

## Página 12 / 12

# Modelo Probit de Efectos no Observables

Como los \(y_{jt}\) son dependientes (no estamos asumiendo (3)) necesitamos varianzas y covarianzas robustas.

Una vez que estimamos \(\beta_a\), \(\psi_a\), y \(\xi_a\) pueden estimarse los efectos parciales promedios usando el promedio a través de \(j\) de:

$$
\hat{\beta}_{aj}
\phi
\left(
\hat{\psi}_a + x^0\hat{\beta}_a + \bar{X}_j\hat{\xi}_a
\right)
$$

Donde \(x^0\) es un vector no aleatorio de números que se eligen como valores interesantes de las variables explicativas.

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
19 / 49
