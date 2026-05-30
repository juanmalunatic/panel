# Agenda

<!-- Diapositiva 59 / 104 -->

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

# Modelo de Efectos Fijos

<!-- Diapositiva 60 / 104 -->

Consideremos nuevamente el modelo de componentes no observados

$$
y_{it} = x_{it}\beta + c_i + u_{it} \quad \forall\ i,t
\tag{38}
$$

$$
y_i = X_i\beta + c_i J_T + u_i \quad \forall\ i
$$

donde:

$$
y_i =
\begin{bmatrix}
y_{i1} \\
\vdots \\
y_{iT}
\end{bmatrix}
;
\quad
X_i =
\begin{bmatrix}
x_{i1} \\
\vdots \\
x_{iT}
\end{bmatrix}
;
\quad
J_T =
\begin{bmatrix}
1 \\
\vdots \\
1
\end{bmatrix}
$$

Como vimos, el procedimiento de RE para estimar $\beta$ es poner a $c_i$ en el término de error bajo el supuesto de que $c_i$ es ortogonal a $X_i$ y luego tomar en cuenta la correlación serial del error compuesto usando GLS.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 61 / 104 -->

En muchas aplicaciones, todo el punto de trabajar con datos de panel es permitir que $c_i$ y $X_i$ estén arbitrariamente correlacionados.

El modelo de efectos fijos asume que $cov(c_i, x_{it}) \neq 0$ y por lo tanto $E(v_{it}\mid X_i) \neq 0$. En otras palabras, una o más variables explicativas están correlacionadas con el error compuesto y FGLS dará estimaciones sesgadas e inconsistentes.

Para obtener estimaciones consistentes, el modelo de efectos fijos asume exogeneidad estricta de las variables explicativas condicionadas en $c_i$.

**Supuesto FE.1:**

$$
E(u_{it}\mid X_i, c_i) = 0, \quad t = 1, 2, \ldots, T
$$

Note que este supuesto es exactamente el mismo que RE.1(a).

La diferencia fundamental con RE es que no asumimos RE.1(b). Esto es, el análisis de efectos fijos permite que $E(c_i\mid X_i)$ sea una función de $X_i$.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 62 / 104 -->

Relajando el supuesto RE.1(b) podemos estimar en forma consistente efectos parciales en presencia de variables omitidas constantes en el tiempo.

En este último sentido, el análisis de FE es más robusto que el de RE.

Sin embargo, esta mayor robustez tiene un precio.

No podemos incluir en $x_{it}$ factores constantes en el tiempo.

La idea detrás de la estimación de $\beta$ bajo el supuesto FE.1 es transformar (38) para eliminar el efecto no observable $c_i$.

Existen varias transformaciones que logran eliminar $c_i$.

Nosotros trabajaremos con tres transformaciones:

(a) Efectos fijos (FE ó within transformation)

(b) Diferencias finitas

(c) Desviaciones ortogonales (forward orthogonal deviations)

---

# Modelo de Efectos Fijos

<!-- Diapositiva 63 / 104 -->

## Within Transformation

La transformación de FE se obtiene promediando la ecuación (38) sobre $t = 1, 2, \ldots, T$ para obtener la ecuación de corte transversal:

$$
\bar{y}_i = \bar{x}_i\beta + c_i + \bar{u}_i
\tag{39}
$$

donde $\bar{y}_i = (1/T)\sum_{t=1}^T y_{it}$, $\bar{x}_i = (1/T)\sum_{t=1}^T x_{it}$ y $\bar{u}_i = (1/T)\sum_{t=1}^T u_{it}$.

Restando miembro a miembro (39) de (38) se obtiene

$$
y_{it} - \bar{y}_i = (x_{it} - \bar{x}_i)\beta + u_{it} - \bar{u}_i
$$

$$
\ddot{y}_{it} = \ddot{x}_{it}\beta + \ddot{u}_{it}
\tag{40}
$$

donde $\ddot{y}_{it} = y_{it} - \bar{y}_i$, $\ddot{x}_{it} = x_{it} - \bar{x}_i$ y $\ddot{u}_{it} = u_{it} - \bar{u}_i$.

Con $c_i$ fuera de la ecuación es lógico pensar en estimar (40) por POLS.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 64 / 104 -->

Recordemos que para obtener estimadores consistentes por POLS necesitamos que se cumplan los supuestos 1 y 2. Esto es:

$$
E(\ddot{x}_{it}'\ddot{u}_{it}) = 0, \quad t = 1, 2, \ldots, T
\tag{41}
$$

Para cada $t$, (41) puede escribirse como:

$$
E[(x_{it} - \bar{x}_i)'(u_{it} - \bar{u}_i)]
$$

Bajo el supuesto FE.1 de exogeneidad estricta (41) se cumple.

Por lo tanto, POLS puede aplicarse para obtener estimaciones consistentes.

Note que el supuesto de exogeneidad estricta no puede relajarse a algo como exogeneidad contemporánea porque este último supuesto no garantiza que se cumpla (41).

El estimador de efectos fijos, denotado por $\hat{\beta}^{FE}$ es el estimador POLS de la regresión de $\ddot{y}_{it}$ sobre $\ddot{x}_{it}\ \forall\ i,t$.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 65 / 104 -->

Entonces el estimador de efectos fijos de $\beta$, $\hat{\beta}^{FE}$ es:

$$
\begin{aligned}
\hat{\beta}^{FE}
&=
\left(\sum_{i=1}^N \ddot{X}_i'\ddot{X}_i\right)^{-1}
\left(\sum_{i=1}^N \ddot{X}_i'\ddot{y}_i\right) \\
&=
\left(\sum_{i=1}^N X_i'Q_T X_i\right)^{-1}
\left(\sum_{i=1}^N X_i'Q_T y_i\right) \\
&=
(\ddot{X}'\ddot{X})^{-1}\ddot{X}'\ddot{y} \\
&=
[X'(I_N \otimes Q_T)X]^{-1}X'(I_N \otimes Q_T)y
\end{aligned}
\tag{42}
$$

donde $Q_T = I_T - J_T(J_T'J_T)^{-1}J_T'$ es la matriz time-demeaning que es una matriz simétrica e idempotente de rango $T - 1$.

Note que $Q_T \times J_T = 0$; $Q_T \times y_i = \ddot{y}_i$ y $Q_T \times X_i = \ddot{X}_i$.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 66 / 104 -->

Para que el estimador de FE se comporte bien asintóticamente necesitamos la condición de rango estándar:

**Supuesto FE.2:**

$$
rango\left[\sum_{t=1}^T E(\ddot{x}_{it}'\ddot{x}_{it})\right]
= rango\left[E(\ddot{X}_i'\ddot{X}_i)\right]
= K
$$

Note que si $x_{it}$ contiene algún elemento que no varía en el tiempo para cualquier $i$, entonces el elemento correspondiente en $\ddot{x}_{it}$ es idénticamente igual a cero.

Como $\ddot{X}_i$ contendría una columna de ceros, el supuesto FE.2 no podría ser verdadero.

Esto muestra explícitamente porque las variables constantes en el tiempo no están permitidas en el análisis.

El estimador de efectos fijos (42) recibe usualmente el nombre de within estimator porque utiliza la variación temporal dentro de cada corte transversal.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 67 / 104 -->

Existe un segundo estimador de $\beta$ conocido como el between estimator.

El between estimator consiste en aplicar OLS a la ecuación promediada en el tiempo (39): $\bar{y}_i = \bar{x}_i\beta + c_i + \bar{u}_i$

Este estimador NO es consistente bajo el supuesto FE.1 porque $E(\bar{x}_i'c_i) \neq 0$.

Para obtener un estimador consistente en (39) necesitamos asumir RE.1 y la condición de rango estándar.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 68 / 104 -->

## Inferencia Asintótica en FE

El siguiente supuesto asegura que el estimador de FE es el más eficiente:

**Supuesto FE.3:**

$$
E(u_i u_i'\mid X_i, c_i) = \sigma_u^2 I_T.
$$

El supuesto FE.3 es idéntico a RE.3(a).

Como $E(u_i\mid X_i, c_i) = 0$ por FE.1, el supuesto FE.3 es igual a decir que

$$
Var(u_i\mid X_i, c_i) = \sigma_u^2 I_T.
$$

El supuesto FE.3 junto con el supuesto FE.1 aseguran que la matriz de varianzas y covarianzas marginal del error compuesto tiene la estructura que vimos para RE, pero sin el supuesto RE.3(b).

Este resultado que es importante para RE no tiene ninguna importancia para hacer inferencia bajo FE.

Back

---

# Modelo de Efectos Fijos

<!-- Diapositiva 69 / 104 -->

Considere la siguiente ecuación

$$
\ddot{y}_{it} = \ddot{x}_{it}\beta + \ddot{u}_{it}
\tag{43}
$$

Para que POLS aplicado a (43) resulte eficiente necesitamos que los errores sean homocedásticos y que no estén serialmente correlacionados en el tiempo.

La varianza de $\ddot{u}_{it}$ puede calcularse como:

$$
\begin{aligned}
E(\ddot{u}_{it}^2)
&= E[(u_{it} - \bar{u}_i)^2]
= E(u_{it}^2) + E(\bar{u}_i^2) - 2E(u_{it}\bar{u}_i) \\
&= \sigma_u^2 + \sigma_u^2/T - 2\sigma_u^2/T
= \sigma_u^2(1 - 1/T)
\end{aligned}
$$

lo que verifica la homocedasticidad.

La covarianza entre $\ddot{u}_{it}$ y $\ddot{u}_{is}$ es:

$$
\begin{aligned}
E(\ddot{u}_{it}\ddot{u}_{is})
&= E[(u_{it} - \bar{u}_i)(u_{is} - \bar{u}_i)] \\
&= E(u_{it}u_{is}) + E(\bar{u}_i^2) - E(u_{it}\bar{u}_i) - E(u_{is}\bar{u}_i) \\
&= 0 + \sigma_u^2/T - \sigma_u^2/T - \sigma_u^2/T
= -\sigma_u^2/T
\end{aligned}
$$

---

# Modelo de Efectos Fijos

<!-- Diapositiva 70 / 104 -->

Combinando las dos expresiones anteriores tenemos:

$$
Corr(\ddot{u}_{it}, \ddot{u}_{is}) = -1/(T - 1)
$$

Lo que muestra que los errores transformados tienen correlación serial negativa en el tiempo.

Para encontrar la varianza asintótica del estimador de FE escribamos (42) de la siguiente manera:

$$
\begin{aligned}
\hat{\beta}^{FE}
&= \left(\sum_{i=1}^N \ddot{X}_i'\ddot{X}_i\right)^{-1}
\left(\sum_{i=1}^N \ddot{X}_i'\ddot{y}_i\right) \\
&= \beta + \left(\sum_{i=1}^N \ddot{X}_i'\ddot{X}_i\right)^{-1}
\left(\sum_{i=1}^N \ddot{X}_i'u_i\right)
\end{aligned}
$$

$$
\Rightarrow
\sqrt{N}(\hat{\beta}^{FE} - \beta)
=
\left(N^{-1}\sum_{i=1}^N \ddot{X}_i'\ddot{X}_i\right)^{-1}
\left(N^{-1/2}\sum_{i=1}^N \ddot{X}_i'u_i\right)
\tag{44}
$$

---

# Modelo de Efectos Fijos

<!-- Diapositiva 71 / 104 -->

La ecuación anterior surge de utilizar la siguiente relación:

$$
\ddot{X}_i'\ddot{u}_i = (Q_T X_i)'Q_T u_i = X_i'Q_T u_i = \ddot{X}_i'u_i
$$

Por el supuesto FE.3:

$$
E(u_i u_i'\mid X_i, c_i) = \sigma_u^2 I_T.
$$

Por lo tanto:

$$
\sqrt{N}(\hat{\beta}^{FE} - \beta)
\xrightarrow{d}
Normal\left(0, \sigma_u^2[E(\ddot{X}_i'\ddot{X}_i)]^{-1}\right)
$$

Y además:

$$
Avar(\hat{\beta}^{FE}) = \sigma_u^2[E(\ddot{X}_i'\ddot{X}_i)]^{-1}/N
$$

Dado un estimador consistente de $\sigma_u^2$, la varianza asintótica puede ser estimada reemplazando la esperanza por su análogo muestral.

$$
\widehat{Avar}(\hat{\beta}^{FE})
= \hat{\sigma}_u^2
\left(\sum_{i=1}^N \ddot{X}_i'\ddot{X}_i\right)^{-1}
= \hat{\sigma}_u^2
\left(\sum_{i=1}^N\sum_{t=1}^T \ddot{x}_{it}'\ddot{x}_{it}\right)^{-1}
\tag{45}
$$

---

# Modelo de Efectos Fijos

<!-- Diapositiva 72 / 104 -->

Los errores estándar asintóticos se obtienen con la raiz cuadrada de los elementos de la diagonal principal de (45).

El único punto a tener en cuenta es la estimación de $\sigma_u^2$.

Note que sumando sobre $t$, $E(\ddot{u}_{it}^2)$ obtenemos $(T - 1)\sigma_u^2$. Por lo tanto:

$$
\frac{1}{T - 1}\sum_{t=1}^T E(\ddot{u}_{it}^2) = \sigma_u^2
\tag{46}
$$

Definamos los residuos de FE como:

$$
\hat{\ddot{u}}_{it} = \ddot{y}_{it} - \ddot{x}_{it}\hat{\beta}^{FE}, \quad \forall\ i,t
$$

Un estimador consistente de $\sigma_u^2$ es entonces:

$$
\hat{\sigma}_u^2 =
\frac{1}{N(T - 1) - K}
\sum_{i=1}^N\sum_{t=1}^T \hat{\ddot{u}}_{it}^2
\tag{47}
$$

---

# Modelo de Efectos Fijos

<!-- Diapositiva 73 / 104 -->

Piense que uno podría haber conseguido un estimador para $\sigma_u^2$ aplicando el principio de analogía en (46) y reemplazar la esperanza por su análogo muestral.

Un punto a tener en cuenta es que el denominador de (47) NO son los grados de libertad que uno obtendría de aplicar POLS a la ecuación transformada por FE (43).

La estimación de la varianza de los errores en (43) sería $RSS/(NT - K)$.

La diferencia entre esta útima estimación y (47) puede ser grande si $T$ es chico.

En general los errores estándar reportados directamente de (43) tienden a ser pequeños comparados con los verdaderos.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 74 / 104 -->

Bajo los supuestos FE.1-FE.3 restricciones múltiples en los coeficientes pueden ser contrastadas utilizando la fórmula estándar del test de Wald:

$$
F = \frac{(RSS_r - RSS_u)/Q}{RSS_u/[N(T - 1) - K]}
\xrightarrow{d}
F_{Q,N(T-1)-K}
$$

---

# Modelo de Efectos Fijos

<!-- Diapositiva 75 / 104 -->

## El Modelo de Variables Binarias (LSDV)

El enfoque tradicional de FE es ver a $c_i$ como parámetros a ser estimados.

Si cambiamos el supuesto FE.2 a su versión de muestra finita: $rango\ \ddot{X}'\ddot{X} = K$.

el modelo satisface todos los supuestos de Gauss-Markov.

Para estimar el modelo se definen $N$ variables binarias, una para cada observación de corte transversal.

Luego se estima por POLS una regresión de $y_{it}$ sobre las variables binarias, y $x_{it}$ con $t = 1, 2, \ldots, T$; $j = 1, 2, \ldots, N$.

Los coeficientes que acompañan a las variables binarias son las estimaciones de los $c_i$.

El estimador obtenido de esta última regresión es exactamente igual al estimador de FE. Debido a esto, el estimador de FE recibe el nombre de estimador de variables binarias.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 76 / 104 -->

Considere el siguiente modelo,

$$
y = X\beta + C\gamma + u = X\beta + (I_N \otimes J_T)\gamma + u
\tag{48}
$$

donde $\gamma$ es $N \times 1$ y es el vector de coeficientes que acompañan a las variables binarias.

Re-escribiendo (48) como

$$
y = [X\mid (I_N \otimes J_T)]
\begin{pmatrix}
\beta \\
\gamma
\end{pmatrix}
+ u
\tag{49}
$$

Obtenemos,

$$
\hat{\beta}^{LSDV}
= [X'(I_N \otimes Q_T)X]^{-1}X'(I_N \otimes Q_T)y
\tag{50}
$$

Los residuos del modelo LSDV son exactamente iguales a los de (43).

Una ventaja del modelo LSDV es que produce el estimador correcto de la varianza de los errores porque usa como grados de libertad $NT - N - K = N(T - 1) - K$.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 77 / 104 -->

Un problema con el enfoque LSDV es que los estimadores de $c_i$ son insesgados pero no son consistentes.

El estimador de FE es consistente y asintóticamente normal si se cumplen FE.1 y FE.2.

Si no se cumple FE.3, entonces (45) nos dará un estimador incorrecto de la matriz de varianzas y covarianzas de los estimadores.

Si no se cumple FE.3, entonces debemos reemplazar (45) por una estimación robusta.

Aplicando los resultados ya vistos, podemos utilizar la ecuación (13) reemplazando los residuos por los estimados por FE.

$$
\hat{V} =
\left(\sum_{j=1}^N \ddot{X}_j'\ddot{X}_j\right)^{-1}
\left(\sum_{j=1}^N \ddot{X}_j'\hat{\ddot{u}}_j\hat{\ddot{u}}_j'\ddot{X}_j\right)
\left(\sum_{j=1}^N \ddot{X}_j'\ddot{X}_j\right)^{-1}
\tag{51}
$$

Los errores estándar de los estimadores de FE se obtienen de la raiz cuadrada de los elementos de la diagonal principal de (51).

---

# Modelo de Efectos Fijos

<!-- Diapositiva 78 / 104 -->

En lugar de calcular una matriz de varianzas y covarianzas robusta para el estimador FE, se podría relajar el supuesto FE.3 para permitir una matriz no restringida general y aplicar GLS.

**Supuesto FEGLS.3:**

$$
E(u_i u_i'\mid X_i, c_i) = \Lambda,
$$

una matriz $T \times T$ definida positiva.

Bajo FEGLS.3, $E(\ddot{u}_i\ddot{u}_i'\mid \ddot{X}_i) = E(\ddot{u}_i\ddot{u}_i')$ y usando el hecho de que $\ddot{u}_i = Q_Tu_i$, tenemos,

$$
E(\ddot{u}_i\ddot{u}_i') = Q_T\Lambda Q_T,
$$

que tiene rango $T - 1$.

Esto es un problema porque no podemos invertir esta matriz para obtener los estimadores GLS.

Dos soluciones:

(i) trabajar con la inversa generalizada.

(ii) eliminar un período temporal.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 79 / 104 -->

Supongamos que eliminamos el período $T$. Entonces tenemos las siguientes ecuaciones:

$$
\begin{aligned}
\ddot{y}_{i1} &= \ddot{x}_{i1}\beta + \ddot{u}_{i1} \\
\vdots &= \vdots \\
\ddot{y}_{iT-1} &= \ddot{x}_{iT-1}\beta + \ddot{u}_{iT-1}
\end{aligned}
$$

Podemos re-escribir este sistema como si fuera (42) con la única diferencia que ahora los vectores y matrices tienen dimensión $(T - 1)$.

Definamos la matriz $(T - 1) \times (T - 1)$: $\Omega = E(\ddot{u}_i\ddot{u}_i')$

Para estimar $\Omega$, tenemos que estimar $\beta$ por FE en un primer paso.

Después hay que eliminar el período $T$ y construir los $(T - 1) \times 1$ residuos

$$
\hat{\hat{\ddot{u}}}_i = \ddot{y}_i - \ddot{X}_i\hat{\beta}^{FE}, \quad i = 1, 2, \ldots, N
$$

---

# Modelo de Efectos Fijos

<!-- Diapositiva 80 / 104 -->

Un estimador consistente de $\Omega$ es:

$$
\hat{\Omega} = N^{-1}\sum_{i=1}^N \hat{\hat{\ddot{u}}}_i\hat{\hat{\ddot{u}}}_i'
$$

El estimador de FE por GLS se define como:

$$
\hat{\beta}^{FEGLS}
=
\left(\frac{1}{N}\sum_{j=1}^N \ddot{X}_i'\hat{\Omega}^{-1}\ddot{X}_i\right)^{-1}
\left(\frac{1}{N}\sum_{j=1}^N \ddot{X}_i'\hat{\Omega}^{-1}\ddot{y}_i\right)
\tag{52}
$$

donde las variables están definidas sin el último período temporal.

Para obtener consistencia necesitamos una nueva condición de rango:

**Supuesto FEGLS.2:**

$$
rangoE(\ddot{X}_i'\Omega^{-1}\ddot{X}_i) = K.
$$

Bajo FE.1 y FEGLS.2 el estimador de FEGLS es consistente.

---

# Modelo de Efectos Fijos

<!-- Diapositiva 81 / 104 -->

Adicionando el supuesto FEGLS.3, la matriz de varianzas y covarianzas asintótica se estima por:

$$
\widehat{Avar}(\hat{\beta}^{FEGLS}) =
\left(\sum_{j=1}^N \ddot{X}_i'\hat{\Omega}^{-1}\ddot{X}_i\right)^{-1}
$$
