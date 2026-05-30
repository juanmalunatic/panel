# Econometría de Datos de Panel

Maestrías en Economía y Econometría

Lecture 4

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026

---

# Agenda

1. Modelos de Respuesta Binaria
   - Modelo Probit de Efectos no Observables
   - Modelo Logit de Efectos no Observables

2. Modelos Dinámicos de Respuesta Binaria con Efectos no Observables

---

# Modelos de Respuesta Binaria

En el caso de paneles, utilizar un modelo de probabilidad lineal cuando la variable dependiente es binaria tiene los mismos problemas que en el caso de una muestra de corte transversal. Go

Por lo tanto comenzaremos discutiendo directamente los modelos Probit y Logit.

Para ilustrar estos modelos veremos el caso más sencillo: Pooled Probit y Logit.

Supongamos que el modelo es:

$$
P(y_{jt}=1 \mid x_{jt}) = G(x_{jt}\beta), \qquad t = 1, 2, \ldots, T.
$$

Donde $G(\cdot)$ es una función conocida que toma valores en el intervalo abierto cero-uno. $x_{jt}$ son las variables explicativas del modelo que pueden incluir dummies temporales, interacciones de estas variables con variables constantes o no en el tiempo etc.

---

# Modelos de Respuesta Binaria

Dada esta especificación uno puede obtener estimaciones consistentes de $\beta$ maximizando el logaritmo de la función de verosimilitud:

$$
\sum_{j=1}^{N}\sum_{t=1}^{T}
\left\{
 y_{jt}\log G(x_{jt}\beta) + (1-y_{jt})\log[1-G(x_{jt}\beta)]
\right\}
$$

Sin supuestos adicionales se debe utilizar un estimador robusto de la matriz de varianzas y covarianzas.

---

# Modelos de Respuesta Binaria

En particular un estimador simple de esta matriz viene dado por:

$$
\left[
\sum_{j=1}^{N}\sum_{t=1}^{T} A_{jt}(\hat\beta)
\right]^{-1}
\left[
\sum_{j=1}^{N} S_j(\hat\beta)S_j(\hat\beta)'
\right]
\left[
\sum_{j=1}^{N}\sum_{t=1}^{T} A_{jt}(\hat\beta)
\right]^{-1}
\tag{1}
$$

Donde,

$$
A_{jt}(\hat\beta)
=
\frac{\left\{g(x_{jt}\hat\beta)\right\}^{2}x'_{jt}x_{jt}}
{G(x_{jt}\hat\beta)\left[1-G(x_{jt}\hat\beta)\right]}
$$

---

# Modelos de Respuesta Binaria

y por otro lado se tiene que:

$$
S_j(\hat\beta)
=
\sum_{t=1}^{T} S_{jt}(\hat\beta)
=
\sum_{t=1}^{T}
\frac{
g(x_{jt}\hat\beta)x'_{jt}\left[y_{jt}-G(x_{jt}\hat\beta)\right]
}
{G(x_{jt}\hat\beta)\left[1-G(x_{jt}\hat\beta)\right]}
$$

con

$$
g(x_{jt}\hat\beta)
=
\frac{\partial G(x_{jt}\hat\beta)}{\partial x_{jt}\hat\beta}
$$

---

# Modelos de Respuesta Binaria

Note que $S_{jt}(\hat\beta)$ es la denominada *score function* (i.e. la derivada primera del logaritmo de la función de verosimilitud); mientras que $A_{jt}(\hat\beta)$ es igual a menos la matriz Hesiana promedio estimada (i.e. la matriz de información de Fisher).

El estimador en (1) contiene los productos cruzados de la función score y por lo tanto es robusta ante la presencia de heterocedasticidad y correlación serial.

Si en todas las expresiones anteriores reemplazamos a $G(\cdot)$ y $g(\cdot)$ por las funciones $\Phi(\cdot)$ y $\phi(\cdot)$ respectivamente, tenemos el modelo Probit. $\Phi(\cdot)$ y $\phi(\cdot)$ son las funciones de distribución acumulada y de densidad de la normal estándar, respectivamente.

Si en todas las expresiones anteriores reemplazamos a $G(\cdot)$ y $g(\cdot)$ por las funciones $\Lambda(\cdot)$ y $\lambda(\cdot)$ respectivamente, tenemos el modelo Logit. $\Lambda(\cdot)$ y $\lambda(\cdot)$ son las funciones de distribución acumulada y de densidad de la logística, respectivamente.

