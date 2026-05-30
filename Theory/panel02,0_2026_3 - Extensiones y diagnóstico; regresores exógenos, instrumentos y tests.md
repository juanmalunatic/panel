# Econometría de Datos de Panel — Lecture 2

Maestrías en Economía y Econometría

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026

---

## Agenda

1. Modelos Dinámicos
   - Introducción a Modelos de Datos de Panel Dinámicos
   - El Modelo AR(1) de Efectos No Observados y el sesgo de Nickell
   - Estimación de $\rho$ Consistente: Arellano-Bond y Blundell-Bond
   - El Estimador de Arellano-Bond
   - El Estimador de Blundell-Bond
   - Extensión: Regresores Exógenos
   - Contrastes de Validez de los Instrumentos
   - Datos con Persistencia

---

## AB y BB con Regresores Exógenos

Los estimadores de Arellano-Bond y de Blundell-Bond pueden extenderse en forma directa a modelos que incluyan regresores estrictamente exógenos, agrupados en el vector $k$-dimensional $x_{it}$. tales modelos se denominan AR(1)-X modelos de efectos no observados:

$$
y_{it} = c_i + \rho y_{it-1} + \gamma' x_{it} + u_{it}
$$

where:

$$
\forall i \in N, \forall t \in T : E(u_{it} \mid c_i, x_{i1}, x_{i2}, ..., x_{iT}) = 0
$$

La extensión es directa ya que los regresores estrictamente exógenos, $x_{it}$ pueden ser usados como sus propios instrumentos. Por lo tanto, aumentando adecuadamente las matrices $Z$, $Z^+$, las mismas fórmulas de arriba pueden ser usadas para estimar consistentemente $\rho$ y $\gamma$.

---

## AB y BB con Regresores Exógenos

Si los regresores $x_{it}$ son secuencialmente exógenos, esto es

$$
E(x_{it} u_{is}) = 0, \quad \forall t \neq s,
$$

entonces solo $(x_{i1}, ..., x_{is-1})$ son instrumentos válidos para la ecuación en primeras diferencias del período $s$.

Entonces, el estimador de Arellano-Bond utiliza como matriz de instrumentos:

$$
Z_i =
\begin{bmatrix}
y_{i1}\ x_{i2} & 0 & 0 & \cdots & 0 \\
0 & y_{i1}\ y_{i2} & x_{i2}\ x_{i3} & \ddots & 0 \\
\vdots & & & \ddots & \vdots \\
0 & 0 & 0 & \cdots & y_{i1}\ \cdots\ y_{iT-2}\ x_{i2}\ \cdots\ x_{iT-1}
\end{bmatrix}
$$

En la ecuación

$$
\Delta y_{it} = \Delta x_{it}^{\ddagger}\delta + \Delta u_{it}, \quad t = 3, 4, ..., T.
$$

Con

$$
x_{it}^{\ddagger} = [y_{it-1}\ x_{it}].
$$

---

## AB y BB con Regresores Exógenos

Claramente, las $x_{it}$ pueden tener elementos estrictamente exógenos o secuencialmente exógenos en cuyo caso la matriz de instrumentos se puede definir de forma apropiada.

Sin embargo, el número de columnas de $Z_i$ en cualquiera de los casos anteriores puede llegar a ser muy grande produciéndose una pérdida de eficiencia.

Para corregir esto, en general, los programas que resuelven estos modelos utilizan solo algunas de esas columnas.

---

## AB y BB con Regresores Exógenos: ejemplo

Considere el siguiente modelo,

$$
y_{it} = \rho y_{it-1} + x_{it}\beta + c_i + u_{it}, \quad T = 5.
$$

Donde $x_{it}$ es $1 \times 1$, y es una variable estrictamente exógena.

Primero aplicamos diferencias finitas.

$$
\Delta y_{it} = \rho \Delta y_{it-1} + \Delta x_{it}\beta + \Delta u_{it},
$$

Ahora instrumentemos la ecuación utilizando solo dos rezagos. Entonces $Z_i$ queda,

$$
Z_i =
\begin{bmatrix}
y_{i1} & 0 & 0 & 0 & 0 & \Delta x_{i3} \\
0 & y_{i1} & y_{i2} & 0 & 0 & \Delta x_{i4} \\
0 & 0 & 0 & y_{i2} & y_{i3} & \Delta x_{i5}
\end{bmatrix}
$$

En este caso como las $x$'s son estrictamente exógenas utilizamos la propia variable como instrumento de si misma.

---

## AB y BB con Regresores Exógenos: ejemplo

Note que debido al rezago de la variable dependiente se pierde una observación y debido a las diferencias finitas se pierde otra observación de forma que $t = 3, 4, 5$.

Escribiendo el modelo *stacking* sobre $t$, tenemos:

$$
Dy_i = Dy_i^{(-1)}\rho + DX_i\beta + Du_i
$$

Reagrupando:

$$
Dy_i = [Dy_i^{(-1)} \mid DX_i](\rho\ \beta)' + Du_i
$$

Llamando $V_i = D[y_i^{(-1)} \mid X_i]$, obtenemos

$$
\begin{pmatrix}
\hat{\rho} \\
\hat{\beta}
\end{pmatrix}
= \left[
\left(\sum_{i=1}^{N} V_i' D Z_i\right)
W
\left(\sum_{i=1}^{N} Z_i' D V_i\right)
\right]^{-1}
\times
\left(\sum_{i=1}^{N} V_i' D Z_i\right)
W
\left(\sum_{i=1}^{N} Z_i' D y_i\right)
$$

---

## AB y BB con Regresores Exógenos: ejemplo

Igual que antes, el estimador de un paso, usa

$$
W = \left(\frac{1}{N}\sum_{i=1}^{N}(D Z_i)' D Z_i\right)^{-1}
$$

Si queremos estimar usando el estimador de Blundell-Bond, entonces hay que agregar a las ecuaciones en primeras diferencias, las ecuaciones en niveles,

$$
Dy_i = Dy_i^{(-1)}\rho + DX_i\beta + Du_i
$$

$$
y_i = y_i^{(-1)}\rho + X_i\beta + c_i J_T + u_i
$$

Y estimar usando la matriz de instrumentos,

$$
Z_i^+ =
\begin{bmatrix}
Z_i & 0 & 0 & 0 & 0 & 0 \\
0 & \Delta y_{i2} & 0 & 0 & x_{i3} & 1 \\
0 & 0 & \Delta y_{i3} & 0 & x_{i4} & 1 \\
0 & 0 & 0 & \Delta y_{i4} & x_{i5} & 1
\end{bmatrix}
$$

---

## Agenda

1. Modelos Dinámicos
   - Introducción a Modelos de Datos de Panel Dinámicos
   - El Modelo AR(1) de Efectos No Observados y el sesgo de Nickell
   - Estimación de $\rho$ Consistente: Arellano-Bond y Blundell-Bond
   - El Estimador de Arellano-Bond
   - El Estimador de Blundell-Bond
   - Extensión: Regresores Exógenos
   - Contrastes de Validez de los Instrumentos
   - Datos con Persistencia

---

## Contrastes de Validez de los Instrumentos

Como ambos estimadores, el de Arellano-Bond y el de Blundell-Bond son estimadores de GMM, es usual contrastar por la validez de sus instrumentos. Para el contexto de datos de panel hay dos contrastes disponibles.

El primer test es el test-$J$ de Sargan típico. Este es el test estándar de validez de los instrumentos. Tome una matriz de instrumentos $J$ y los errores en primeras diferencias, $\Delta u_i$. Las hipótesis son:

$$
\begin{cases}
H_0 : E(J_i \Delta u_i) = 0_{T-2} \\
H_1 : E(J_i \Delta u_i) \neq 0_{T-2}
\end{cases}
$$

El estadístico de contraste, $s(J)$, es:

$$
s(J) =
\left(\sum_{i=1}^{N} \Delta \hat{u}_i^{(J)'} J_i\right)
\left(\sum_{i=1}^{N} J_i' \Delta \hat{u}_i^{(J)}\Delta \hat{u}_i^{(J)'} J_i\right)^{-1}
\left(\sum_{i=1}^{N} J_i' \Delta \hat{u}_i^{(J)}\right)
$$

---

## Contrastes de Validez de los Instrumentos

Se puede mostrar que, para $J = Z$, $J = Z^+$:

$$
s^{AB} = s(Z) \xrightarrow{\mathcal{D}} \chi^2_{\mathrm{col}(Z)-k}
$$

$$
s^{BB} = s(Z^+) \xrightarrow{\mathcal{D}} \chi^2_{\mathrm{col}(Z^+)-k}
$$

with $\mathrm{col}(Z^+) = T - 2 + \mathrm{col}(Z)$.

Rechazar la hipótesis nula en el test-$J$ significa que los instrumentos no son válidos. Esto implica que el DGP no es el modelo AR(1) de efectos no observables ya que para este modelo los instrumentos de Arellano-Bond y Blundell-Bond son válidos. Entonces, el test-$J$ puede ser pensado como un test de especificación del modelo.

---

## Contrastes de Validez de los Instrumentos

El segundo test es el test-M. A diferencia del test anterior, este contraste es un test de especificación directamente.

Tome el modelo en primeras diferencias. Si los errores en niveles son ruido blanco, los errores en primeras diferencias tendrán una estructura de autocovarianzas determinada.

Más precisamente, la autocovarianza de primer orden de los errores en primeras diferencias es negativa y la autocovarianza de segundo orden es cero:

$$
\gamma_{\Delta u}(1) = E(\Delta u_{it}\Delta u_{it-1})
$$

$$
= E[(u_{it} - u_{it-1})(u_{it-1} - u_{it-2})]
$$

$$
= E[u_{it}u_{it-1} - u_{it-1}u_{it-1} - u_{it}u_{it-2} + u_{it-1}u_{it-2}]
$$

$$
= -\gamma_u(0) < 0
$$

$$
\gamma_{\Delta u}(2) = E(\Delta u_{it}\Delta u_{it-2})
$$

$$
= E[(u_{it} - u_{it-1})(u_{it-2} - u_{it-3})]
$$

$$
= 0
$$

---

## Contrastes de Validez de los Instrumentos

Entonces, tenemos los siguientes dos conjuntos de hipótesis:

$$
(1) \begin{cases}
H_0^{(1)} : \gamma_{\Delta u}(1) = 0 \\
H_1^{(1)} : \gamma_{\Delta u}(1) < 0
\end{cases}
$$

$$
(2) \begin{cases}
H_0^{(2)} : \gamma_{\Delta u}(2) = 0 \\
H_1^{(2)} : \gamma_{\Delta u}(2) \neq 0
\end{cases}
$$

 y debemos rechazar $H_0^{(1)}$ y aceptar $H_0^{(2)}$. Los estadísticos de contraste, $m_1$ y $m_2$, son asintóticamente normales bajo cada hipótesis nula (y son provistos por Stata después de la estimación):

$$
m_1 \xrightarrow{\mathcal{D}H_0^{(1)}} N(0,1)
$$

$$
m_2 \xrightarrow{\mathcal{D}H_0^{(2)}} N(0,1)
$$
