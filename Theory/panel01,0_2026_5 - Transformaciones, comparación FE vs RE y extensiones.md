# Modelo de Efectos Fijos

Aparte de la within transformation existen otras transformaciones para eliminar la heterogeneidad no observada. Una de las más utilizadas es la transformación de diferencias finitas (FD).

Considere el modelo de componentes no observados escrito para los períodos $t$ y $t - 1$,

$$
y_{it} = \alpha_i + x_{it}\beta + u_{it}
\tag{53}
$$

$$
y_{it-1} = \alpha_i + x_{it-1}\beta + u_{it-1}
\tag{54}
$$

Restando miembro a miembro,

$$
y_{it} - y_{it-1} = (x_{it} - x_{it-1})\beta + (u_{it} - u_{it-1})
\tag{55}
$$

$$
\Delta y_{it} = \Delta x_{it}\beta + \Delta u_{it}
\tag{56}
$$

Como ocurría con la transformación de FE, FD también elimina el efecto individual $c_i$.

Igual que antes, la ecuación (56) pone en evidencia porque no puede haber en $x_{it}$ elementos que no varíen en el tiempo.

---

# Modelo de Efectos Fijos

El estimador de diferencias finitas de $\beta$, $\hat{\beta}_{FD}$, es:

$$
\hat{\beta}_{FD}
=
\left(\sum_{i=1}^{N}\Delta X_i'\Delta X_i\right)^{-1}
\left(\sum_{i=1}^{N}\Delta X_i'\Delta y_i\right)
$$

$$
=
\left(\sum_{i=1}^{N}(DX_i)'DX_i\right)^{-1}
\left(\sum_{i=1}^{N}(DX_i)'Dy_i\right)
$$

$$
=
\left(\sum_{i=1}^{N}X_i'D' D X_i\right)^{-1}
\left(\sum_{i=1}^{N}X_i'D'D y_i\right)
\tag{57}
$$


donde

$$
D =
\begin{bmatrix}
-1 & 1 & 0 & \cdots & 0 & 0 \\
0 & -1 & 1 & \cdots & 0 & 0 \\
\vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\
0 & 0 & 0 & \cdots & -1 & 1
\end{bmatrix}
\tag{58}
$$

---

# Modelo de Efectos Fijos

Note que para que este estimador sea consistente necesitamos que se cumpla que:

Supuesto FD.1 : $E(u_{it}|X_i, c_i) = 0$, $t = 1, 2, \ldots, T$

El supuesto FD.1, es igual a FE.1 y a RE.1(a).

Bajo supuesto FD.1, POLS en (56) será consistente porque

$$
E(\Delta x_{it}'\Delta u_{it}) = 0, \quad t = 2, \ldots, T,
$$

respectivamente.

Recuerde que además de este supuesto necesitamos una condición de rango estándar: supuesto FD.2: $\operatorname{rango} E(\Delta X_i'\Delta X_i) = K$.

Una de las razones para preferir FD sobre FE es que es fácil de calcular usando un paquete estadístico común.

Lo único que debemos tener en cuenta es que las observaciones correspondientes a los períodos $1, T + 1, 2T + 1, \ldots, (N - 1)T + 1$ deben considerarse como no disponibles.

---

# Modelo de Efectos Fijos

Sin embargo, bajo los supuestos FE.1-FE.3, el estimador de FE es el más eficiente dentro de la clase de estimadores que utilizan el supuesto de exogeneidad estricta.

Una consecuencia de este último punto es que el estimador de FD debe ser menos eficiente si se cumple FE.3. FE.3

Si se cumple FE.3, entonces:

$$
E(Du_i u_i'D'|X_i, c_i) = D E(u_i u_i'|X_i, c_i)D' = \sigma_u^2 DD'
$$

Lo que muestra que los errores estarán correlacionados para períodos adjacentes.

En este caso, argumentos estándares de GLS nos darán el siguiente estimador óptimo:

$$
\hat{\beta}_{FDGLS}
=
\left(\sum_{i=1}^{N}X_i'D'(DD')^{-1}DX_i\right)^{-1}
\left(\sum_{i=1}^{N}X_i'D'(DD')^{-1}Dy_i\right)
\tag{59}
$$

---

# Modelo de Efectos Fijos

Note que en este caso GLS $\equiv$ FGLS porque $DD'$ es conocida.

Otro punto interesante es que, la matriz idempotente $D'(DD')^{-1}D$ también puede escribirse como:

$$
D'(DD')^{-1}D \equiv I_T - J_T(J_T'J_T)^{-1}J_T' = Q_T
$$


donde $Q_T$ es la matriz time demeaning que vimos antes.

Esto muestra que: $\hat{\beta}_{FDGLS} = \hat{\beta}_{FE}$

Si no se cumple FE.3 entonces uno puede asumir que la primera diferencia de los errores idiosincráticos no tienen correlación serial.

Supuesto FD.3: $E(e_i e_i'|X_i, c_i) = \sigma_e^2 I_{T-1}$, donde $e_i$ es el vector que contiene a $e_{it} = \Delta u_{it}$, $t = 2, \ldots, T$ (ó $e_i = Du_i$).

---

# Modelo de Efectos Fijos

Bajo el supuesto FD.3, podemos escribir los errores idiosincráticos como:

$$
u_{it} = u_{it-1} + e_{it}
$$

Tal que, ausencia de correlación serial en $e_{it}$ implica que $u_{it}$ sigue un paseo al azar (i.e. tiene una dependencia serial muy fuerte).

Es decir que el supuesto FD.3 representa el otro extremo de FE.3

Bajo los supuestos FD.1-FD.3, el estimador de FD es el más eficiente dentro de la clase de estimadores que cumplen FE.1.

Utilizando los resultados de POLS en (57) tenemos que:

$$
\widehat{Avar}(\hat{\beta}_{FD})
=
\hat{\sigma}_e^2
\left(\sum_{i=1}^{N}X_i'D'D X_i\right)^{-1}
$$


donde $\hat{\sigma}_e^2$ es un estimador consistente de $\sigma_e^2$.

---

# Modelo de Efectos Fijos

El estimador más simple se obtiene calculando los residuos

$$
\hat{e}_{it} = y_{it} - x_{it}\hat{\beta}_{FD}
$$

Y luego estimando $\sigma_e^2$ como:

$$
\hat{\sigma}_e^2
=
\frac{1}{N(T - 1) - K}
\sum_{i=1}^{N}\sum_{t=1}^{T}\hat{e}_{it}^{2}
$$

Si el supuesto FD.3 no se cumple, entonces debemos utilizar una matriz de varianzas y covarianzas robusta.

Usando (13) tenemos:

$$
\hat{V}
=
\left(\sum_{i=1}^{N}X_i'D'D X_i\right)^{-1}
\left(\sum_{i=1}^{N}X_i'D'\hat{e}_i\hat{e}_i'DX_i\right)
\left(\sum_{i=1}^{N}X_i'D'D X_i\right)^{-1}
\tag{60}
$$

---

# Modelo de Efectos Fijos

## Transformación de Helmert

Otra forma de eliminar el efecto individual en (38) es mediante la transformación de Helmert ó desviaciones ortogonales hacia adelante:

$$
y_{it}^{*}
=
\sqrt{\frac{T - t}{T - t + 1}}
\left[
 y_{it} - \frac{1}{T - t}(y_{it+1} + \cdots + y_{iT})
\right],
\quad t = 1, 2, \ldots, T - 1
$$

El modelo transformado es entonces:

$$
y_{it}^{*} = x_{it}^{*}\beta + u_{it}^{*}
\tag{61}
$$

Tal como ocurría con FD y FE, la transformación de Helmert elimina el efecto individual.

El estimador de desviaciones ortogonales es el estimador POLS en (61).

---

# Modelo de Efectos Fijos

Definamos la matriz $H_T$ de dimensión $(T - 1) \times T$: $H_T = (DD')^{-1/2}D$.

Eligiendo $(DD')^{-1/2}$ como la matriz triangular superior que surge de la factorización de Cholesky, tenemos:

$$
H_T = \operatorname{diag}[(T - 1)/T, \ldots, 1/2]^{-1/2}H^{+}
$$

con

$$
H^{+} \equiv
\begin{bmatrix}
1 & (1-T)^{-1} & (1-T)^{-1} & \cdots & (1-T)^{-1} & (1-T)^{-1} & (1-T)^{-1} \\
0 & 1 & (2-T)^{-1} & \cdots & (2-T)^{-1} & (2-T)^{-1} & (2-T)^{-1} \\
\vdots & \vdots & \vdots & \ddots & \vdots & \vdots & \vdots \\
0 & 0 & 0 & \cdots & 1 & -1/2 & -1/2 \\
0 & 0 & 0 & \cdots & 0 & 1 & -1
\end{bmatrix}
$$

---

# Modelo de Efectos Fijos

Usando esta matriz $H_T$ el modelo (61) puede escribirse como:

$$
H_T y_i = H_T x_i\beta + H_T u_i
$$

El estimador HT es entonces:

$$
\hat{\beta}_{HT}
=
\left(\sum_{i=1}^{N}X_i'H_T'H_T X_i\right)^{-1}
\left(\sum_{i=1}^{N}X_i'H_T'H_T y_i\right)
\tag{62}
$$

$$
= \beta +
\left(\sum_{i=1}^{N}X_i'H_T'H_T X_i\right)^{-1}
\left(\sum_{i=1}^{N}X_i'H_T'H_T u_i\right)
$$

Bajo que supuestos este estimador es consistente?

Claramente como $H_T = (DD')^{-1/2}D$, entonces $H_T'H_T = Q_T$. Y por lo tanto

$$
\hat{\beta}_{FE} \equiv \hat{\beta}_{FDGLS} \equiv \hat{\beta}_{HT}
$$

---

# Modelo de Efectos Fijos

El último punto implica que necesitamos:

Supuesto HT.1: $E(u_{it}|X_i, c_i) = 0$, $t = 1, 2, \ldots, T$

El supuesto HT.1 es igual a FE.1, a FD.1 y a RE.1(a).

Supuesto HT.2: $\operatorname{rango} [E(X_i'H_T'H_T X_i)] = K$

Bajo los supuestos HT.1 y HT.2, el estimador $\hat{\beta}_{HT}$ es consistente.

Note que como $H_T = (DD')^{-1/2}D$, entonces $H_T H_T' = I_{T-1}$, y por lo tanto si se cumple FE.3:

$$
E(u_i^{*}u_i^{*'}|X_i, c_i)
= H_T E(u_i u_i'|X_i, c_i)H_T'
= \sigma_u^2 I_{T-1}.
$$

Queda claro de (62) que

$$
\hat{\beta}_{HT}
= \beta +
\left(\sum_{i=1}^{N}X_i'H_T'H_T X_i\right)^{-1}
\left(\sum_{i=1}^{N}X_i'H_T'H_T u_i\right)
$$

$$
= \beta +
\left(\sum_{i=1}^{N}X_i'Q_T X_i\right)^{-1}
\left(\sum_{i=1}^{N}X_i'Q_T u_i\right)
= \hat{\beta}_{FE}
\tag{63}
$$

---

# Modelo de Efectos Fijos

Por lo tanto, bajo HT.1-HT.2 y FE.3,

$$
\sqrt{N}(\hat{\beta}_{HT} - \beta)
\xrightarrow{d}
Normal\left(0, \sigma_u^2 [E(X_i'H_T'H_T X_i)]^{-1}\right)
$$

Y además:

$$
Avar(\hat{\beta}_{HT}) = \sigma_u^2 [E(X_i'H_T'H_T X_i)]^{-1}/N.
$$

Dado un estimador consistente de $\sigma_u^2$, la varianza asintótica puede ser estimada reemplazando la esperanza por su análogo muestral.

$$
\widehat{Avar}(\hat{\beta}_{HT})
=
\hat{\sigma}_u^2
\left[\sum_{i=1}^{N}X_i'H_T'H_T X_i\right]^{-1}
\tag{64}
$$

Los errores estándar asintóticos se obtienen con la raiz cuadrada de los elementos de la diagonal principal de (64).

Al igual que ocurría con la transformación de FE, el único punto a tener en cuenta es la estimación de $\sigma_u^2$.

---

# Modelo de Efectos Fijos

Un estimador consistente de $\sigma_u^2$ es:

$$
\hat{\sigma}_u^2
=
\frac{1}{N(T - 1) - K}
\sum_{i=1}^{N}\sum_{t=1}^{T}
\hat{u}_{it}^{*}\hat{u}_{it}^{*'}
\tag{65}
$$


donde, $\hat{u}_{it}^{*} = y_{it}^{*} - x_{it}^{*}\hat{\beta}_{HT}$.

Si FE.3 no se satisface, entonces debemos reemplazar (64) por una estimación robusta.

Aplicando los resultados ya vistos, podemos utilizar la ecuación (13) reemplazando los residuos por los estimados por HT.

$$
\hat{V}
=
\left(\sum_{i=1}^{N}X_i^{*'}X_i^{*}\right)^{-1}
\left(\sum_{i=1}^{N}X_i^{*'}\hat{u}_i^{*}\hat{u}_i^{*'}X_i^{*}\right)
\left(\sum_{i=1}^{N}X_i^{*'}X_i^{*}\right)^{-1}
\tag{66}
$$

Los errores estándar de los estimadores de HT se obtienen de la raiz cuadrada de los elementos de la diagonal principal de (66).

---

# Modelo de Efectos Fijos

## Relación entre FE y RE

Escribamos la matriz de varianzas y covarianzas con la estructura de RE:

$$
\Omega = \sigma_u^2 I_T + \sigma_c^2 J_T J_T'
= \sigma_u^2 I_T + T\sigma_c^2 J_T(J_T'J_T)^{-1}J_T'
$$

$$
= \sigma_u^2 I_T + T\sigma_c^2 P_T
= (\sigma_u^2 + T\sigma_c^2)(P_T + \eta Q_T)
$$


donde

$$
P_T \equiv I_T - Q_T = J_T(J_T'J_T)^{-1}J_T',
\quad
\eta = \sigma_u^2/(\sigma_u^2 + T\sigma_c^2).
$$

Note que de la definición de $P_T$ tenemos las siguientes relaciones:

(i) $P_T + Q_T = I_T$

(ii) $P_T Q_T = 0$

(iii) $P_TP_T = P_T$

Ahora definamos $S_T = P_T + \eta Q_T$. $S_T^{-1} = P_T + (1/\eta)Q_T$ y

$$
S_T^{-1/2} = P_T + (1/\sqrt{\eta})Q_T.
$$

---

# Modelo de Efectos Fijos

Usando álgebra: $S_T^{-1/2} = (1 - \lambda)^{-1}[I_T - \lambda P_T]$, con $\lambda = 1 - \sqrt{\eta}$.

Por lo tanto,

$$
\Omega^{-1/2}
= (\sigma_u^2 + T\sigma_c^2)^{-1/2}(1 - \lambda)^{-1}[I_T - \lambda P_T]
$$

$$
= (1/\sqrt{\sigma_u^2})[I_T - \lambda P_T]
$$


donde

$$
\lambda = 1 - [\sigma_u^2/(\sigma_u^2 + T\sigma_c^2)]^{1/2}.
$$

Asumamos por un momento que conocemos $\lambda$. Entonces, RE se obtiene con la ecuación transformada: $C_Ty_i = C_TX_i\beta + C_Tu_i$ con $C_T = [I_T - \lambda P_T]$.

Escribamos la ecuación transformada como:

$$
\check{y}_i = \check{X}_i\beta + \check{u}_i
$$

La varianza de $\check{u}_i$ es $E(\check{u}_i\check{u}_i') = C_T\Omega C_T = \sigma_u^2 I_T$.

---

# Modelo de Efectos Fijos

Claramente el elemento $t$ de $\check{y}_i$ es

$$
y_{it} - \lambda \bar{y}_i
$$

Por lo tanto RE es POLS en:

$$
y_{it} - \lambda \bar{y}_i = (x_{it} - \lambda \bar{x}_i)\beta + (u_{it} - \lambda \bar{u}_i), \quad \forall i,t
\tag{67}
$$

Los errores de esta ecuación son homocedásticos y no están serialmente correlacionados bajo el supuesto RE.3.

FGLS se obtiene reemplazando $\lambda$ con un estimador consistente.

Si $\hat{\lambda}$ es un estimador consistente de $\lambda$, entonces:

$$
\hat{\beta}_{RE}
=
\left(\sum_{i=1}^{N}\sum_{t=1}^{T}\check{x}_{it}'\check{x}_{it}\right)^{-1}
\sum_{i=1}^{N}\sum_{t=1}^{T}\check{x}_{it}'\check{y}_{it}
\tag{68}
$$

El estimador usual de la varianza de los errores en (67) es un estimador consistente de $\sigma_u^2$.

---

# Modelo de Efectos Fijos

Los estadísticos $t$ y $F$ usuales son válidos asintóticamente bajo los supuestos RE.1-RE.3.

La ecuación (68) muestra que el estimador de RE se puede obtener con lo que se denomina quasi-time-demeaning.

En lugar de sacarle la media temporal, los RE le sacan una fracción $\hat{\lambda}$ de la media temporal a las variables.

Si $\hat{\lambda}$ es cercano a 1, entonces RE y FE tienden a acercarse.

Para ver cuando esto ocurre escribamos $\hat{\lambda}$ como:

$$
\hat{\lambda} = 1 - \{1/[1 + T(\sigma_c^2/\sigma_u^2)]\}^{1/2}
$$

Por lo tanto: $\hat{\lambda} \longrightarrow 1$ cuando $T \longrightarrow \infty$ ó $(\sigma_c^2/\sigma_u^2) \longrightarrow \infty$.

---

# Inferencia en Modelos de Panel

Como la consideración fundamental para elegir entre FE y RE es el hecho de que los efectos no observables estén o no correlacionados con las variables explicativas, es importante tener un test que contraste este supuesto.

Hausman (1978) propuso un test basado en las diferencias entre los estimadores de FE y RE.

La hipótesis nula del test asume no correlación entre $c_i$ y $x_{it}$ por lo tanto ambos FE y RE son consistentes, pero FE es ineficiente.

La hipótesis alternativa asume que hay correlación entre $c_i$ y $x_{it}$ por lo tanto FE es consistente, pero RE no.

Por lo tanto bajo la nula, los dos estimadores no debieran diferir mucho.

Denotemos por $\hat{\delta}_{RE}$ al vector de estimadores de RE sin los coeficientes que acompañan a variables constantes en el tiempo; y por $\hat{\delta}_{FE}$ a los correspondientes estimadores de FE.

---

# Inferencia en Modelos de Panel

Suponiendo que ambos vectores de estimadores tienen dimensión $M \times 1$, el estadístico del test de Hausman es:

$$
H = (\hat{\delta}_{FE} - \hat{\delta}_{RE})'
[\widehat{Var}(\hat{\delta})_{FE} - \widehat{Var}(\hat{\delta})_{RE}]^{-1}
(\hat{\delta}_{FE} - \hat{\delta}_{RE})
\Longrightarrow \chi_M^2
\tag{69}
$$

Si estamos interesados en un único parámetro podemos transformar el test de Hausman en un test $t$.

Asumamos que estamos interesados en $\delta_1$. El test se vuelve:

$$
t =
\frac{(\hat{\delta}_{1FE} - \hat{\delta}_{1RE})}
{\sqrt{[\widehat{Var}(\hat{\delta}_1)_{FE} - \widehat{Var}(\hat{\delta}_1)_{RE}]}}
\Longrightarrow N(0, 1)
\tag{70}
$$

---

# Inferencia en Modelos de Panel

Remark 1: Se mantienen el supuesto de exogeneidad estricta RE.1(a) bajo la nula y la alternativa.

Remark 2: El test se implementa usualmente asumiendo que RE.3 se cumple bajo la nula.

---

# Extensión del Modelo de Efectos Fijos

Una generalización del modelo de componentes no observados incluye efectos fijos temporales.

Esto es:

$$
y_{it} = \alpha_i + \lambda_t + x_{it}\beta + u_{it}, \quad i \in \{1, \ldots, N\}, \quad t \in \{1, \ldots, T\}
$$

La inclusión de $\alpha_i$ controla por factores no obervables específicos de las unidades pero constantes en el tiempo.

La inclusión de $\lambda_t$ controla por factores específicos en el tiempo pero constantes en el corte transversal.

Ahora, además de calcular las medias temporales de cada variable,

$$
\bar{y}_i = (1/T)\sum_{t=1}^{T}y_{it},
$$

necesitamos calcular las medias a través del corte transversal:

$$
\bar{y}_t = (1/N)\sum_{i=1}^{N}y_{it}
$$


y las medias totales:

$$
\bar{y} = (1/NT)\sum_{i=1}^{N}\sum_{t=1}^{T}y_{it}
$$

---

# Extensión del Modelo de Efectos Fijos

Para estimar este modelo considere la siguiente transformación:

$$
y_{it} = \alpha_i + \lambda_t + x_{it}\beta + u_{it}
\tag{71}
$$

$$
\bar{y}_i = \alpha_i + \bar{\lambda} + \bar{x}_i\beta + \bar{u}_i
\tag{72}
$$

$$
\bar{y}_t = \bar{\alpha} + \lambda_t + \bar{x}_t\beta + \bar{u}_t
\tag{73}
$$

$$
\bar{y} = \bar{\alpha} + \bar{\lambda} + \bar{x}\beta + \bar{u}
\tag{74}
$$

---

# Extensión del Modelo de Efectos Fijos

Restando miembro a miembro de la ecuación (71) la (72) y la (73) y sumando la (74) tenemos

$$
y_{it} - \bar{y}_i - \bar{y}_t + \bar{y}
= (x_{it} - \bar{x}_i - \bar{x}_t + \bar{x})\beta
+ (u_{it} - \bar{u}_i - \bar{u}_t + \bar{u})
$$

$$
\ddot{y}_{it} = \ddot{x}_{it}\beta + \ddot{u}_{it}
\tag{75}
$$

El estimador de MCC de la ecuación (75) se conoce en la literatura como two-way fixed effects estimator.
