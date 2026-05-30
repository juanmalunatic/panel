# Modelos de Datos de Panel Lineales

<!-- Diapositiva 39 / 104 -->

Hasta ahora, hemos supuesto, como mínimo que no existía correlación entre el error del período y las variables explicativas del modelo.

Para ciertos datos de panel este supuesto es demasiado fuerte. Hay varios casos en los que uno debiera esperar una correlación entre variables observables y no observables.

Un ejemplo clásico de este problema es el del error de medición. Si la variable explicativa que observamos no se mide correctamente el error de la ecuación contendrá este error de medición y por lo tanto estará correlacionado con la variable explicativa mal medida.

Otro ejemplo posible es el de variable omitida.

Justamente, uno de los usos más frecuentes de los datos de panel, es el de resolver los problemas de variables omitidas.

Es fácil ver como los datos de panel nos pueden ayudar a resolver el problema de variables omitidas.

---

# Modelos de Datos de Panel Lineales

<!-- Diapositiva 40 / 104 -->

Sean $x = (x_1, x_2, \ldots, x_k)$ e $y$ variables aleatorias observables; y $c$ una variable aleatoria no observable.

Usualmente, estamos interesados en estimar los efectos parciales de las variables explicativas observables sobre la variable dependiente.

El Problema: asumiendo un modelo lineal,

$$
E(y \mid x, c) = \beta_0 + x\beta + c
$$

Estamos interesados en el vector $\beta$.

Si $Cov(x_j, c) \neq 0$ para algún $j$, no podemos estimar consistentemente el vector $\beta$ ni con OLS ni con GLS.

En el contexto de datos de panel $c$ recibe el nombre de componente no observable, efecto no observable o heterogeneidad no observable.

La solución al problema de variables omitidas en panel consiste simplemente en transformar el modelo para eliminar $c$ y luego estimar.

---

# Modelos de Efectos Fijos y Aleatorios

<!-- Diapositiva 41 / 104 -->

Consideremos un modelo para variables observadas a través de unidades de corte transversal durante varios períodos de tiempo. $\beta$ es el parámetro que estamos interesados en estimar y $c_i$ es un efecto no observado, invariante en el tiempo, denominado efecto individual, heterogeneidad individual ó heterogeneidad no observada:

$$
y_{it} = c_i + x_{it}\beta + u_{it}
\tag{24}
$$

donde $x_{it}$ es $1 \times K$ y $u_{it}$ es el error idiosincrático. Este modelo se denomina modelo de efectos no observables.

Tradicionalmente, existen dos modelos basados en la discusión acerca de si $c_i$ puede tratarse como un efecto aleatorio o como un efecto fijo.

Estas discusiones se centraban en si el efecto individual era una variable aleatoria o podía considerarse como un parámetro a ser estimado.

---

# Modelos de Efectos Fijos y Aleatorios

<!-- Diapositiva 42 / 104 -->

En el análisis de panel tradicional $c_i$ se llama un efecto aleatorio cuando se lo trata como variable aleatoria y un efecto fijo cuando se lo trata como parámetro a ser estimado.

Modernamente, la discusión ha cambiado y lo que se discute es básicamente si el efecto no observable está o no correlacionado con las variables explicativas observables.

Ahora, efecto aleatorio es sinónimo de ausencia de correlación entre las variables explicativas observables y el efecto no observable:

$$
Cov(x_{it}, c_i) = 0, \quad t = 1, 2, \ldots, T.
$$

En los trabajos empíricos cuando se dice que el modelo tiene un efecto aleatorio individual es porque se está asumiendo que no existe correlación entre las variables explicativas observables y el efecto no observable.

Similarmente, el término efecto fijo, no quiere decir que $c_i$ se trate como no aleatorio, sino que implica que se permite la correlación entre $c_i$ y $x_{it}$.

---

# Exogeneidad Estricta

<!-- Diapositiva 43 / 104 -->

$$
E(y_{it} \mid x_{i1}, x_{i2}, \ldots, x_{iT}, c_i) = E(y_{it} \mid x_{it}, c_i) = x_{it}\beta + c_i
$$

con $t = 1, 2, \ldots, T$.

Cuando la ecuación anterior se satisface, se dice que las variables explicativas son estríctamente exógenas condicionando en el efecto no observable.

La condición de exogeneidad estricta puede establecerse en términos de los errores idiosincráticos usando el modelo (24),

$$
E(u_{it} \mid x_{i1}, x_{i2}, \ldots, x_{iT}, c_i) = 0, \quad t = 1, 2, \ldots, T.
\tag{25}
$$

La ecuación (25) implica que las variables explicativas en cada período de tiempo no están correlacionadas con el error idiosincrático en cada período de tiempo:

$$
E(x'_{is}u_{it}) = 0, \quad s,t = 1, 2, \ldots, T.
\tag{26}
$$

---

# Exogeneidad Estricta

<!-- Diapositiva 44 / 104 -->

Este supuesto de exogeneidad es mucho más fuerte que el de ausencia de correlación contemporánea

$$
E(x'_{it}u_{it}) = 0, \quad t = 1, 2, \ldots, T.
$$

No obstante, note que (25) permite correlación arbitraria entre las variables explicativas observables y el efecto individual no observable.

## Estimación del modelo de efectos no observables con POLS

Re-escribamos el modelo (24) como:

$$
y_{it} = x_{it}\beta + v_{it}, \quad t = 1, 2, \ldots, T
\tag{27}
$$

donde $v_{it} = c_i + u_{it}$, $t = 1, 2, \ldots, T$ son los errores compuestos.

De acuerdo a lo que hemos visto, sabemos que la ecuación anterior puede estimarse por OLS y obtener estimadores consistentes si

$$
E(x'_{it}v_{it}) = 0, \quad t = 1, 2, \ldots, T.
$$

---

# Modelos de Panel Lineales

<!-- Diapositiva 45 / 104 -->

La última condición implica que estamos asumiendo que:

$$
E(x'_{it}u_{it}) = 0 \quad \text{y} \quad E(x'_{it}c_i) = 0, \quad t = 1, 2, \ldots, T.
$$

Note que el supuesto restrictivo aqui es la segunda condición.

En modelos de panel dinámicos la segunda condición no puede cumplirse porque la variable dependiente rezagada (i.e. $y_{it-1}$) y $c_i$ están necesariamente correlacionadas.

Note que aún cuando las condiciones anteriores se satisfagan los errores compuestos estarán correlacionados debido a la presencia de $c_i$ en cada período temporal.

Una consecuencia del punto anterior es que para realizar inferencia usando POLS se deben calcular los errores estándar de los coeficientes usando la ecuación (13).

Otra consecuencia que afectará nuestro análisis más adelante es que como $v_{it}$ depende de $c_i$ para todo $t$, la correlación entre $v_{it}$ y $v_{it-s}$, $s > 0$ no decrece con $s$.

En el lenguaje de las series temporales: $v_{it}$ no tiene dependencia débil a través del tiempo.

---

# Agenda

<!-- Diapositiva 46 / 104 -->

1. Introducción
2. Teoría Asintótica
3. Modelos de Datos de Panel Lineales
4. Modelos de Efectos Fijos y Aleatorios
   - Modelo de Efectos Aleatorios
   - Modelo de Efectos Fijos
   - Transformación de Efectos Fijos ó Within Transformation
   - Modelo de Variables Binarias (LSDV)
   - Transformación de Diferencias Finitas
   - Transformación por Desviaciones Ortogonales
5. Two-Way Fixed Effects Model

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 47 / 104 -->

Como en el caso de POLS, los métodos de efectos aleatorios ponen a $c_i$ en el término de error.

En general el análisis de efectos aleatorios necesita supuestos más fuertes que POLS: exogeneidad estricta más ortogonalidad entre $c_i$ y $x_{it}$.

**Supuesto RE.1:**

(a) $E(u_{it} \mid X_i, c_i) = 0$ y

(b) $E(c_i \mid X_i) = 0$ con $X_i = (x_{i1}, x_{i2}, \cdots, x_{iT})$.

Necesitamos (a) porque RE estima por GLS, debido a la correlación serial y como vimos antes, GLS necesita exogeneidad estricta para conseguir estimadores consistentes.

Bajo RE.1 podemos escribir el modelo como:

$$
y_{it} = x_{it}\beta + v_{it}
\tag{28}
$$

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 48 / 104 -->

En (28) $E(v_{it} \mid X_i) = 0$, $t = 1, 2, \ldots, T$.

Note que esta última ecuación implica que $\{x_{it}, t = 1, 2, \ldots, T\}$ satisface el supuesto de exogeneidad estricta 1' en POLS.

Por lo tanto podemos aplicar GLS tomando en cuenta la estructura de la matriz de varianzas y covarianzas del error.

Escribamos el modelo stacking sobre $T$.

$$
y_i = X_i\beta + v_i, \quad v_i = c_iJ_T + u_i
$$

donde $J_T$ es un vector $T \times 1$ de unos.

Definamos la matriz de varianzas y covarianzas de los errores del modelo como: $\Omega = E(v_iv_i')$, una matriz $T \times T$ positiva definida.

Recuerde que esta matriz es la misma para todo $i$ por el supuesto de muestra aleatoria.

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 49 / 104 -->

Para obtener estimadores consistentes por GLS necesitamos: **Supuesto RE.2:**

$$
rango E(X_i'\Omega^{-1}X_i) = K.
$$

Aplicando los resultados vistos antes para GLS sabemos que podemos obtener estimadores consistentes y asintóticamente normales con $N \longrightarrow \infty$ y usando una matriz $\Omega$ general.

Pero podemos hacerlo mejor porque conocemos la estructura de los errores.

Los supuestos tradicionales de RE son:

(i) $E(u_{it}^2) = \sigma_u^2$, $t = 1, 2, \ldots, T$.

(ii) $E(u_{it}u_{is}) = 0$, $\forall t \neq s$.

En este caso:

$$
\begin{aligned}
\Omega &= E(v_iv_i') \\
&= E[(c_iJ_T + u_i)(c_iJ_T + u_i)'] \\
&= E\{c_i^2J_TJ_T' + c_iu_iJ_T' + c_iJ_Tu_i' + u_iu_i'\} \\
&= \sigma_c^2J_TJ_T' + \sigma_u^2I_T.
\end{aligned}
$$

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 50 / 104 -->

De la ecuación anterior tenemos:

$$
\Omega = E(v_iv_i') =
\begin{bmatrix}
\sigma_c^2 + \sigma_u^2 & \sigma_c^2 & \cdots & \sigma_c^2 \\
\sigma_c^2 & \sigma_c^2 + \sigma_u^2 & \cdots & \sigma_c^2 \\
\vdots & \vdots & \ddots & \vdots \\
\sigma_c^2 & \sigma_c^2 & \cdots & \sigma_c^2 + \sigma_u^2
\end{bmatrix}
\tag{29}
$$

Cuando $\Omega$ tiene la forma (29) se dice que tiene la estructura de efectos aleatorios.

Note que en este caso $\Omega$ depende solo de dos parámetros $\sigma_c^2$ y $\sigma_u^2$, independientemente del tamaño de $T$.

Para obtener estimadores eficientes necesitamos que: (iii) $E(v_iv_i' \mid X_i) = E(v_iv_i')$.

El siguiente supuesto implica (i), (ii) e (iii)

**Supuesto RE.3:**

(a) $E(u_iu_i' \mid X_i, c_i) = \sigma_u^2 I_T$

(b) $E(c_i^2 \mid X_i) = \sigma_c^2$.

Bajo RE.3, $\Omega$ tiene la forma (29).

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 51 / 104 -->

**Implementación:** Necesitamos un estimador consistente de $\Omega$.

Asumamos que tenemos estimadores consistentes de $\sigma_c^2$ y $\sigma_u^2$ entonces:

$$
\widehat{\Omega} = \widehat{\sigma}_c^2J_TJ_T' + \widehat{\sigma}_u^2I_T
\tag{30}
$$

El estimador FGLS que usa (30) se conoce como estimador de efectos aleatorios.

$$
\widehat{\beta}^{RE} =
\left(\sum_{i=1}^N X_i'\widehat{\Omega}^{-1}X_i\right)^{-1}
\left(\sum_{i=1}^N X_i'\widehat{\Omega}^{-1}y_i\right)
$$

El estimador anterior es consistente bajo RE.1 y RE.2.

$$
\widehat{\beta}^{RE} = \beta +
\left(\sum_{i=1}^N X_i'\widehat{\Omega}^{-1}X_i\right)^{-1}
\left(\sum_{i=1}^N X_i'\widehat{\Omega}^{-1}v_i\right)
$$

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 52 / 104 -->

Bajo el supuesto RE.3, el estimador de efectos aleatorios es eficiente.

La matriz usual de varianzas-covarianzas de FGLS (23) es válida pero con $\widehat{\Omega}$ dada por (30) en lugar de $\widetilde{\Omega}$.

$$
\widehat{AVar}(\hat{\beta}) =
\left(\sum_{j=1}^N X_j'\widehat{\Omega}^{-1}X_j\right)^{-1}
\tag{31}
$$

Para poder implementar FGLS necesitamos las estimaciones consistentes de $\sigma_c^2$ y $\sigma_u^2$. Para esto definamos $\sigma_v^2 = \sigma_c^2 + \sigma_u^2$.

Bajo el supuesto RE.3(a), $\sigma_v^2 = T^{-1}\sum_{t=1}^T E(v_{it}^2)$ para todo $i$.

Por lo tanto, un estimador consistente de $\sigma_v^2$ es:

$$
\widehat{\sigma}_v^2 = \frac{1}{NT-K}\sum_{i=1}^N\sum_{t=1}^T \widehat{\widehat{v}}_{it}^{2}
$$

Donde $\widehat{\widehat{v}}_{it}$ son los residuos de POLS.

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 53 / 104 -->

Para encontrar un estimador consistente de $\sigma_c^2$, recuerde que $\sigma_c^2 = E(v_{it}v_{is})$, para todo $t \neq s$.

Un estimador consistente es entonces:

$$
\widehat{\sigma}_c^2 =
\frac{1}{[NT(T-1)-1]/2-K}
\sum_{i=1}^N\sum_{t=1}^{T-1}\sum_{s=t+1}^{T}
\widehat{\widehat{v}}_{it}\widehat{\widehat{v}}_{is}
\tag{32}
$$

Con estos resultados podemos estimar consistentemente: $\widehat{\sigma}_u^2 = \widehat{\sigma}_v^2 - \widehat{\sigma}_c^2$.

En la práctica, la ecuación para estimar $\sigma_c^2$ no garantiza una estimación POSITIVA.

Si la estimación da negativa entonces eso es un signo de que existe correlación negativa en $u_{it}$ lo que implica que RE.3 no se cumple.

En este caso debieramos estimar FGLS sin restricciones.

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 54 / 104 -->

Si el supuesto RE.3 no se cumple es importante poder realizar inferencia estadística sin ese supuesto.

Para ello, simplemente utilizamos la estimación robusta de la matriz de varianzas y covarianzas dada por la ecuación (22), reemplazando $\widetilde{u}_i$ por

$$
\widehat{v}_i = y_i - X_i\widehat{\beta}^{RE}, \quad i = 1,2, \ldots, N
$$

$$
\widehat{V} =
\left(\sum_{i=1}^N X_i'\widehat{\Omega}^{-1}X_i\right)^{-1}
\left(\sum_{i=1}^N X_i'\widehat{\Omega}^{-1}\widehat{v}_i\widehat{v}_i'\widehat{\Omega}^{-1}X_i\right)
\left(\sum_{i=1}^N X_i'\widehat{\Omega}^{-1}X_i\right)^{-1}
\tag{33}
$$

Los errores estándar robustos se obtienen de la raiz cuadrada de la diagonal principal de (33), y el test de Wald robusto se obtiene con la fórmula:

$$
W = (R\widehat{\beta}^{RE} - r)'[R\widehat{V}R']^{-1}(R\widehat{\beta}^{RE} - r)
\overset{d}{\longrightarrow} \chi_Q^2
\tag{34}
$$

donde $\widehat{V}$ es la matriz de varianzas y covarianzas estimada en forma robusta.

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 55 / 104 -->

Si los errores idiosincráticos $\{u_{it}: t = 1,2, \ldots, T\}$ son heterocedásticos y/o tienen correlación serial, se debe utilizar un estimador de $\Omega$ más general:

$$
\widehat{\Omega} = N^{-1}\sum_{i=1}^N \widehat{\widehat{v}}_i\widehat{\widehat{v}}_i'
$$

donde $\widehat{\widehat{v}}_i$ son los residuos de POLS.

Con $N$ grande el estimador de FGLS más general es tan eficiente como RE.

El estimador de FGLS más general es más eficiente que RE si $E(v_iv_i' \mid X_i) = \Omega$, pero $\Omega$ no tiene la estructura de efectos aleatorios.

Por qué entonces no se usa siempre el modelo más general?

Históricamente, la estructura de la matriz de varianzas y covarianzas de RE se consideró sinónimo de efectos no observables.

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 56 / 104 -->

## Contraste por la presencia de un efecto no observable.

Si los supuestos RE.1-RE.3 se cumplen pero no existe un efecto no observable, entonces POLS es eficiente y todos los estadísticos asociados a POLS son asintóticamente válidos.

La ausencia de un efecto no observable es estadísticamente equivalente a

$$
H_0 : \sigma_c^2 = 0.
$$

El estadístico de contraste se basa en (32) y en la distribución asintótica de

$$
N^{-1/2}\sum_{i=1}^N\sum_{t=1}^{T-1}\sum_{s=t+1}^{T}\widehat{\widehat{v}}_{it}\widehat{\widehat{v}}_{is}
\tag{35}
$$

que es esencialmente el estimador de $\sigma_c^2$ escalado por $N^{-1/2}$.

Por el supuesto de exogeneidad estricta la distribución de (35) es la misma con los residuos de POLS que con los errores verdaderos.

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 57 / 104 -->

$N^{-1/2}\sum_{i=1}^N\sum_{t=1}^{T-1}\sum_{s=t+1}^{T} v_{it}v_{is}$ tiene distribución normal con varianza dada por $E\left(\sum_{t=1}^{T-1}\sum_{s=t+1}^{T} v_{it}v_{is}\right)$.

Haciendo el cociente entre (35) y su error estándar tenemos un estadístico de contraste con distribución normal estandar.

$$
z =
\frac{\sum_{i=1}^N\sum_{t=1}^{T-1}\sum_{s=t+1}^{T}\widehat{\widehat{v}}_{it}\widehat{\widehat{v}}_{is}}
{\left(\sum_{i=1}^N\left(\sum_{t=1}^{T-1}\sum_{s=t+1}^{T}\widehat{\widehat{v}}_{it}\widehat{\widehat{v}}_{is}\right)^2\right)^{1/2}}
\tag{36}
$$

El estadístico (36) tiene la capacidad de detectar muchas formas de correlación serial en el error compuesto.

Tradicionalmente, el estadístico de contraste utilizado para detectar la presencia de efectos no observables es el estadístico del multiplicador de Lagrange (Breusch-Pagan, 1980).

---

# Modelo de Efectos Aleatorios

<!-- Diapositiva 58 / 104 -->

La hipótesis nula del test de Breusch-Pagan es la misma: $H_0 : \sigma_c^2 = 0$, y el estadístico de contraste es:

$$
LM = \frac{NT}{2(T-1)}
\left[
\frac{\sum_{i=1}^N\left(\sum_{t=1}^{T}\widehat{\widehat{v}}_{it}\right)^2}
{\sum_{i=1}^N\sum_{t=1}^{T}\widehat{\widehat{v}}_{it}^{2}}
- 1
\right]^2
\tag{37}
$$

Bajo la hipótesis nula (37) se distribuye como una $\chi_1^2$ siempre y cuando los errores tengan DISTRIBUCION NORMAL.

Como (36) no hace ningún supuesto sobre la distribución de los errores compuestos es preferible a (37).
