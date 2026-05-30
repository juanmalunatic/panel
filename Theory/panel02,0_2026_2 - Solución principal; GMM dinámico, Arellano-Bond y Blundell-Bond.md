# panel02,0_2026_2 - Solución principal; GMM dinámico, Arellano-Bond y Blundell-Bond

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

## Arellano-Bond y Blundell-Bond

Para estimar $\rho$ en forma consistente, necesitamos asumir lo siguiente. Sea:

$$
y_i^{t-1} =
\begin{bmatrix}
y_{it-1} \\
\vdots \\
y_{i1}
\end{bmatrix}
$$

el vector de la historia de las observaciones de $y_i$ hasta el período $t-1$.

Además del supuesto típico:

$$
|\rho| < 1
$$

vamos a asumir (y esto es lo máximo que podemos requerir) exogeneidad secuencial:

$$
\forall i \in \mathbb{N}, \forall t \in \mathbb{T}: E\left(u_{it}\mid c_i, y_i^{t-1}\right) = 0
$$

---

## Arellano-Bond and Blundell-Bond

La exogeneidad secuencial implica la ausencia de correlación serial:

$$
\forall s > 0:
$$

$$
\begin{aligned}
E(u_{it}u_{it-s})
&= E\left(E\left(u_{it}u_{it-s}\mid c_i, y_i^{t-1}\right)\right) \\
&= E\left(E\left(u_{it}(y_{it-s} - c_i + \rho y_{it-s-1})\mid c_i, y_i^{t-1}\right)\right) \\
&= E\left((y_{it-s} - c_i + \rho y_{it-s-1})E\left(u_{it}\mid c_i, y_i^{t-1}\right)\right) \\
&= E\left[(y_{it-s} - c_i + \rho y_{it-s-1})0\right] \\
&= 0
\end{aligned}
$$

---

## Arellano-Bond and Blundell-Bond

Volviendo a la condición de estacionariedad, en el contexto de series temporales, usualmente se asume que el proceso estocástico comienza arbitrariamente muy lejos en el tiempo. Esto implica que $|\rho| < 1$ asegura la estacionariedad. Sin embargo, la condición de estabilidad no asegura la estacionariedad si el proceso comienza en algún período finito $t$, por ejemplo $t = 1$. Para ver esto, escribamos el proceso en términos de esta condición inicial:

$$
\begin{aligned}
y_{it} &= c_i + \rho y_{it-1} + u_{it} \\
&= c_i + \rho(c_i + \rho y_{it-2} + u_{it-1}) + u_{it} \\
&= (1+\rho)c_i + \rho^2 y_{it-2} + u_{it} + \rho u_{it-1} \\
&\vdots \\
y_{it} &= c_i\left(\sum_{s=0}^{t-2}\rho^s\right) + \rho^{t-1}y_{i1} + \sum_{s=0}^{t-2}\rho^s u_{it-s}
\end{aligned}
$$

---

## Arellano-Bond and Blundell-Bond

Como no podemos seguir con este proceso recursivo hasta llegar a $-\infty$ para eliminar el término $\rho^{t-1}y_{i1}$, encontramos que la distribución de $y_{it}$ depende de la distribución de la observación inicial, $y_{i1}$. por lo tanto, los momentos de $y_{it}$ dependen de los momentos de $y_{i1}$.

Tomemos primero la esperanza de $y_{it}$ condicional en $c_i$, que es:

$$
\begin{aligned}
E(y_{it}\mid c_i)
&= E\left(E\left(y_{it}\mid y_i^{t-1}, c_i\right)\mid c_i\right) \\
&= E\left[
E\left(
 c_i\left(\sum_{s=0}^{t-2}\rho^s\right) + \rho^{t-1}y_{i1} + \sum_{s=0}^{t-2}\rho^s u_{it-s}
\mid y_i^{t-1}, c_i
\right)\mid c_i
\right] \\
&= c_i\left(\sum_{s=0}^{t-2}\rho^s\right) + \rho^{t-1}E[y_{i1}\mid c_i] \\
&= c_i\frac{1-\rho^{t-1}}{1-\rho} + \rho^{t-1}E[y_{i1}\mid c_i]
\end{aligned}
$$

---

## Arellano-Bond and Blundell-Bond

Este momento depende de la misma esperanza pero de $y_{i1}$. Para un proceso AR(1) estacionario, condicional en $c_i$, la esperanza hubiera sido:

$$
\mu_i = \frac{c_i}{1-\rho}
$$

Para que esta esperanza sea la esperanza de nuestro proceso de panel, necesitamos asumir además de $|\rho| < 1$ que:

$$
E[y_{i1}\mid c_i] = \mu_i = \frac{c_i}{1-\rho}
$$

---

## Arellano-Bond and Blundell-Bond

Bajo este supuesto adicional, se verifica que $\mu_i$ es de hecho la esperanza de $y_{it}$ para cada $t$:

$$
\begin{aligned}
E(y_{it}\mid c_i)
&= c_i\frac{1-\rho^{t-1}}{1-\rho} + \rho^{t-1}E[y_{i1}\mid c_i] \\
&= c_i\frac{1-\rho^{t-1}}{1-\rho} + \rho^{t-1}\frac{c_i}{1-\rho} \\
&= \frac{c_i}{1-\rho}(1-\rho^{t-1} + \rho^{t-1}) \\
&= \frac{c_i}{1-\rho} \\
&= \mu_i
\end{aligned}
$$

Lo mismo ocurre con las autocovarianzas del proceso de panel. Asumamos que:

$$
\forall i \in \mathbb{N}, \forall t \in \mathbb{T}: E\left(u_{it}^2\mid c_i, y_i^{t-1}\right) = \sigma^2
$$

---

## Arellano-Bond and Blundell-Bond

y que:

$$
\operatorname{var}(y_{i1}\mid c_i) = \frac{\sigma^2}{1-\rho^2}
$$

Ahora, bajo los supuestos hechos hasta ahora, el modelo AR(1) de panel puede escribirse en términos de las desviaciones con respecto a su media como sigue:

$$
\begin{aligned}
y_{it} - \mu_i
&= \rho(y_{it-1} - \mu_i) + u_{it} \\
&= \rho^{t-1}(y_{i1} - \mu_i) + \sum_{s=0}^{t-2}\rho^s u_{it-s}
\end{aligned}
$$

$$
\begin{aligned}
y_{it-k} - \mu_i
&= \rho(y_{it-k-1} - \mu_i) + u_{it-k} \\
&= \rho^{t-k-1}(y_{i1} - \mu_i) + \sum_{s=0}^{t-k-2}\rho^s u_{it-k-s}
\end{aligned}
$$

---

## Arellano-Bond and Blundell-Bond

Entonces, las autocovarianzas pueden escribirse como:

$$
\begin{aligned}
\operatorname{cov}(y_{it}, y_{it-k}\mid c_i)
&= E[(y_{it} - \mu_i)(y_{it-k} - \mu_i)\mid c_i] \\
&= \rho^{2t-k-2}\operatorname{var}(y_{i1}\mid c_i) + \rho^k\sum_{s=0}^{t-k-2}\rho^{2s}\sigma^2 \\
&= \rho^{2t-k-2}\frac{\sigma^2}{1-\rho^2} + \rho^k\frac{1-\rho^{2t-2k-2}}{1-\rho^2}\sigma^2 \\
&= \frac{\sigma^2}{1-\rho^2}(\rho^{2t-k-2} + \rho^k - \rho^{2t-k-2}) \\
&= \rho^k\frac{\sigma^2}{1-\rho^2} \\
&= \gamma_k
\end{aligned}
$$

---

## Arellano-Bond and Blundell-Bond

Por lo tanto, para cada $t$ tenemos:

$$
\operatorname{var}(y_{it}\mid c_i) = \gamma_0 = \frac{\sigma^2}{1-\rho^2} = \operatorname{var}(y_{i1}\mid c_i)
$$

Para concluir, si los momentos de la primera observación del proceso son los momentos en estado estacionario, el proceso entero es estacionario y comparte esos mismos momentos.

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

## Estimador de Arellano-Bond

Volviendo al problema de la estimación, las transformaciones usuales para eliminar $c_i$ generan estimadores inconsistentes en el contexto de paneles dinámicos. El problema recae en el hecho de que, bajo exogeneidad secuencial, tomar primeras diferencias (o transformar por efectos fijos) elimina $c_i$ pero provoca que la condición de exogeneidad se viole:

$$
y_{it} = c_i + \rho y_{it-1} + u_{it}
$$

$$
\Delta y_{it} = \rho\Delta y_{it-1} + \Delta u_{it}
$$

$$
\begin{aligned}
E(\Delta y_{it-1}\Delta u_{it})
&= E(y_{it-1}u_{it} - y_{it-1}u_{it-1} - y_{it-2}u_{it} - y_{it-2}u_{it-1}) \\
&= -E(y_{it-1}u_{it-1}) \neq 0
\end{aligned}
$$

Entonces, para estimar $\rho$ en forma consistente, necesitamos instrumentos para $\Delta y_{it-1}$. Tomemos $y_{it-2}$ en niveles como instrumento de $\Delta y_{it-1}$:

$$
E(y_{it-2}\Delta u_{it}) = E(y_{it-2}u_{it} - y_{it-2}u_{it-1}) = 0
$$

---

## Estimador de Arellano-Bond

En general,

$$
E\left(y_i^{t-2}\Delta u_{it}\right) = 0_{t-2}
$$

Esto significa que el instrumento es válido. El estimador de Arellano-Bond es el estimador de GMM con matriz de instrumentos:

$$
Z =
\begin{bmatrix}
Z_1 \\
\vdots \\
Z_N
\end{bmatrix}
$$

$$
Z_i =
\begin{bmatrix}
y_{i1} & 0 & 0 & 0 & \cdots & 0 & \cdots & 0 \\
0 & y_{i1} & y_{i2} & 0 & \cdots & 0 & \cdots & 0 \\
0 & 0 & 0 & \ddots & \ddots & \ddots & \cdots & \vdots \\
\vdots & \vdots & \vdots & \vdots & \vdots & 0 & \cdots & 0 \\
0 & 0 & 0 & \cdots & \cdots & y_{i1} & \cdots & y_{iT-2}
\end{bmatrix}
$$

para una muestra aleatoria de tamaño $NT$.

---

## Estimador de Arellano-Bond

Tomando primeras diferencias e instrumentando con valores rezagados, las primeras dos observaciones no pueden usarse en la estimación. Definamos los vectores de observaciones usables como:

$$
\Delta y =
\begin{bmatrix}
\Delta y_{13} \\
\vdots \\
\Delta y_{NT}
\end{bmatrix}
;
\qquad
\Delta y_{-1} =
\begin{bmatrix}
\Delta y_{12} \\
\vdots \\
\Delta y_{N(T-1)}
\end{bmatrix}
$$


y matriz ponderadora $W$.

Entonces, el estimador de Arellano-Bond de $\rho$ es:

$$
\hat{\rho}_{AB}(W) =
\left[\Delta'_ {y_{-1}}\left(ZWZ'\right)\Delta y_{-1}\right]^{-1}
\Delta'_{y_{-1}}\left(ZWZ'\right)\Delta y
$$

---

## Estimador de Arellano-Bond

Hay dos elecciones disponibles para $W$: $W_1$, una matriz ponderadora de un solo paso, y $W_2$, una matriz ponderadora de dos pasos que usa los residuos del estimador que usa $W_1$, $\hat{u}^{(1)}_i$:

$$
W_1 = \left(\sum_{i=1}^{N}\Delta Z'_i\Delta Z_i\right)^{-1}
$$

$$
W_2 = \left(\sum_{i=1}^{N}Z'_i\Delta\hat{u}^{(1)}_i\Delta\hat{u}^{(1)'}_i Z_i\right)^{-1}
$$

---

## Estimador de Arellano-Bond

Cada matriz ponderadora da un estimador de Arellano-Bond diferente:

$$
\hat{\rho}^{1}_{AB} =
\left[\Delta'_{y_{-1}}\left(ZW_1Z'\right)\Delta y_{-1}\right]^{-1}
\Delta'_{y_{-1}}\left(ZW_1Z'\right)\Delta y
$$

$$
\hat{\rho}^{2}_{AB} =
\left[\Delta'_{y_{-1}}\left(ZW_2Z'\right)\Delta y_{-1}\right]^{-1}
\Delta'_{y_{-1}}\left(ZW_2Z'\right)\Delta y
$$

La estimación de las varianzas de estos estimadores es:

$$
\widehat{\operatorname{var}}\left(\hat{\rho}^{1}_{AB}\right) =
\hat{\sigma}^2\left[\Delta'_{y_{-1}}\left(ZW_1Z'\right)\Delta y_{-1}\right]^{-1}
$$

$$
\widehat{\operatorname{var}}\left(\hat{\rho}^{2}_{AB}\right) =
\hat{\sigma}^2\left[\Delta'_{y_{-1}}\left(ZW_2Z'\right)\Delta y_{-1}\right]^{-1}
$$


donde $\hat{\sigma}^2$ es la estimación de la varianza de $u_{it}$.

---

## Estimador de Arellano-Bond

Una estimación consistente de $\sigma^2$ viene dada por:

$$
\hat{\sigma}^2 = \frac{1}{2(N(T-2)-K)}\sum_{i=1}^{N}\Delta\hat{u}'_i\Delta\hat{u}_i
$$


donde $K$ es la dimensión de $X_i \equiv y_{it-1} = 1$ y $\Delta\hat{u}_i$ es la estimación de los errores del modelo transformado. Note que el número de observaciones en la ecuación estimada es $N(T-2)$ porque perdemos las primeras dos observaciones debido a la variable dependiente rezagada y a la transformación de diferencias finitas.

$$
\Delta\hat{u}_i = \Delta y_i - \Delta y_{it-1}\hat{\rho}^{1}_{AB}
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

## Estimador de Blundell-Bond

Un buen estimador de variables instrumentales es aquel en el que el instrumento y la variable instrumentada están altamente correlacionadas. Esta correlación, en el caso del estimador de Arellano-Bond, está dada por:

$$
\begin{aligned}
E(y_{it-2}\Delta y_{it-1})
&= E[y_{it-2}(c_i + (\rho - 1)y_{it-2} + u_{it})] \\
&= E[y_{it-2}c_i] + (\rho - 1)E(y_{it-2}^2)
\end{aligned}
$$

Como asumiremos más adelante, $E[y_{it-2}c_i] = 0$. Entonces,

$$
E(y_{it-2}\Delta y_{it-1}) = (\rho - 1)E(y_{it-2}^2)
$$

Cuando el proceso de panel es un modelo de panel con raiz unitaria, esto es, cuando $\rho = 1$, esta correlación alcanza su menor valor (en valor absoluto). Lo que sucede es que, bajo $\rho = 1$, el proceso es un paseo aleatorio (random walk) de panel y sus incrementos, $\Delta y_{it}$ son ruido blanco.

---

## Estimador de Blundell-Bond

Entonces, cuando $\rho$ se aproxima a uno, los instrumentos utilizados por Arellano-Bond se vuelven instrumentos débiles.

Por lo tanto, Blundell-Bond proponen agregar nuevos instrumentos.

Para esto, note que los valores rezagados de la diferencia $\Delta y_{it}$ son ortogonales a los niveles de $u_{it}$:

$$
\forall i \in \mathbb{N}, \forall s > 0: E(\Delta y_{it-s}u_{it}) = 0
$$

Entonces, podemos estimar el siguiente modelo:

$$
\begin{cases}
\Delta y_{it} = \rho\Delta y_{it-1} + \Delta u_{it} \\
y_{it} = \rho y_{it-1} + v_{it}
\end{cases}
$$

con $v_{it} = c_i + u_{it}$.

---

## Estimador de Blundell-Bond

Usando los instrumentos de Arellano-Bond para la ecuación en diferencias y las diferencias rezagadas como instrumento para la ecuación en niveles.

Para obtener estimadores consistentes, el nuevo conjunto de instrumentos no tiene que estar correlacionado con el nuevo término de error, $v_{it}$. Esto está asegurado por el supuesto:

$$
\forall i \in \mathbb{N}, \forall s > 0: E(\Delta y_{it-s}c_i) = 0
$$

Note que esto implica la condición, ya establecida, que:

$$
E[y_{it-2}c_i] = 0
$$

Para obtener una única expresión para el modelo y el estimador, note que $\Delta u_{it} = \Delta v_{it}$.

---

## Estimador de Blundell-Bond

Además, definamos $D$ como la matriz $(T-2)\times(T-1)$ que representa la operación de tomar primeras diferencias. También, definamos $Z^+$ como la matriz de instrumentos aumentada:

$$
Z_i^+ =
\begin{bmatrix}
Z_i & 0 & 0 & 0 & \cdots & 0 \\
0 & \Delta y_{i2} & 0 & 0 & \cdots & 0 \\
0 & 0 & \Delta y_{i3} & 0 & \ddots & \vdots \\
\vdots & \vdots & \vdots & \ddots & \vdots & 0 \\
0 & 0 & 0 & \cdots & \ddots & 0 \\
0 & 0 & 0 & \cdots & 0 & \Delta y_{i(T-1)}
\end{bmatrix}
$$

$$
Z^+ =
\begin{bmatrix}
Z_1^+ \\
\vdots \\
Z_N^+
\end{bmatrix}
$$

---

## Estimador de Blundell-Bond


y $H$ como la matriz, en bloques, de transformación:

$$
H =
\begin{bmatrix}
D \\
I_{T-1}
\end{bmatrix}
$$

El modelo en

$$
\begin{cases}
\Delta y_{it} = \rho\Delta y_{it-1} + \Delta u_{it} \\
y_{it} = \rho y_{it-1} + v_{it}
\end{cases}
$$

puede ser escrito como:

$$
(I_N \otimes H)y = \rho(I_N \otimes H)y_{-1} + (I_N \otimes H)v
$$

---

## Estimador de Blundell-Bond

con:

$$
y_i =
\begin{bmatrix}
y_{i2} \\
\vdots \\
y_{iT}
\end{bmatrix}
;
\qquad
y_{i-1} =
\begin{bmatrix}
y_{i1} \\
\vdots \\
y_{i(T-1)}
\end{bmatrix}
;
\qquad
v_i =
\begin{bmatrix}
v_{i2} \\
\vdots \\
v_{iT}
\end{bmatrix}
$$

$$
y =
\begin{bmatrix}
y_2 \\
\vdots \\
y_N
\end{bmatrix}
;
\qquad
y_{-1} =
\begin{bmatrix}
y_{11} \\
\vdots \\
y_{N(T-1)}
\end{bmatrix}
;
\qquad
v =
\begin{bmatrix}
v_2 \\
\vdots \\
v_N
\end{bmatrix}
$$

Entonces, queremos estimar $\rho$ por GMM con la matriz de instrumentos aumentada. Nuevamente, necesitamos la condición de ortogonalidad:

$$
E\left[Z^{+\prime}(I_N \otimes H)v\right] = 0_{2N(T-2)}
$$

---

## Estimador de Blundell-Bond

El estimador de Blundell-Bond es el siguiente estimador de dos pasos.

En el primer paso calculamos el siguiente estimador de GMM:

$$
\hat{\rho}^{(1)} =
\left\{
\left[y'_{-1}(I_N \otimes H')Z^+\right]^{-1}W^{(1)}\left[Z^{+\prime}(I_N \otimes H)y_{-1}\right]
\right\}^{-1}
\times
\left\{
\left[y'_{-1}(I_N \otimes H')Z^+\right]^{-1}W^{(1)}\left[Z^{+\prime}(I_N \otimes H)y\right]
\right\}
$$

con:

$$
W^{(1)} = \left[\sum_{i=1}^{N}Z_i^{+\prime}HH'Z_i^+\right]^{-1}
$$

---

## Estimador de Blundell-Bond

Este estimador $\hat{\rho}^{(1)}$ se conoce como el estimador de Blundell-Bond de un paso.

La varianza del estimador de Blundell-Bond de un paso es:

$$
\widehat{\operatorname{var}}\left(\hat{\rho}^{(1)}\right)
= \hat{\sigma}^2
\left\{
\left[y'_{-1}(I_N \otimes H')Z^+\right]^{-1}W^{(1)}\left[Z^{+\prime}(I_N \otimes H)y_{-1}\right]
\right\}^{-1}
$$

Una estimación consistente de $\sigma^2$ viene dada por:

$$
\hat{\sigma}^2 = \frac{1}{2(N(T-2)-K)}\sum_{i=1}^{N}\Delta\hat{u}'_i\Delta\hat{u}_i
$$

Con

$$
\Delta\hat{u}_i = \Delta y_i - \Delta y_{it-1}\hat{\rho}^{(1)}
$$

---

## Estimador de Blundell-Bond

Tome los residuos de este primer paso, $\hat{v}_i^{(1)}$. El estimador propuesto por Blundell-Bond es el estimador de GMM con una matriz ponderadora óptima que puede obtenerse en el segundo paso:

$$
\hat{\rho}^{BB} =
\left\{
\left[y'_{-1}(I_N \otimes H')Z^+\right]^{-1}W_{BB}\left[Z^{+\prime}(I_N \otimes H)y_{-1}\right]
\right\}^{-1}
\times
\left\{
\left[y'_{-1}(I_N \otimes H')Z^+\right]^{-1}W_{BB}\left[Z^{+\prime}(I_N \otimes H)y\right]
\right\}
$$

con:

$$
W_{BB} = \left[\sum_{i=1}^{N}Z_i^{+\prime}H\hat{v}_i\hat{v}'_iH'Z_i^+\right]^{-1}
$$

---

## Estimador de Blundell-Bond

La varianza del estimador de Blundell-Bond es:

$$
\widehat{\operatorname{var}}\left(\hat{\rho}^{BB}\right)
= \hat{\sigma}^2
\left\{
\left[y'_{-1}(I_N \otimes H')Z^+\right]^{-1}W_{BB}\left[Z^{+\prime}(I_N \otimes H)y_{-1}\right]
\right\}^{-1}
$$

Una estimación consistente de $\sigma^2$ viene dada por:

$$
\hat{\sigma}^2 = \frac{1}{2(N(T-2)-K)}\sum_{i=1}^{N}\Delta\hat{u}'_i\Delta\hat{u}_i
$$


donde $K$ es la dimensión de $X_i \equiv y_{it-1} = 1$ y $\Delta\hat{u}_i$ es la estimación de los errores del modelo transformado. Note que el número de observaciones en la ecuación estimada es $N(T-2)$ porque perdemos las primeras dos observaciones debido a la variable dependiente rezagada y a la transformación de diferencias finitas.

$$
\Delta\hat{u}_i = \Delta y_i - \Delta y_{it-1}\hat{\rho}^{BB}
$$

