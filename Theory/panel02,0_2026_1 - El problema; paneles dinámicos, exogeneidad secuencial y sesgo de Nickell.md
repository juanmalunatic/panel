# Econometría de Datos de Panel

Maestrías en Economía y Econometría  
Lecture 2

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

## Modelos Dinámicos

En los modelos que hemos visto hasta ahora se asumió que las variables explicativas eran estrictamente exógenas (en el caso de FE condicional al efecto no observable).

En general, FE y RE son inconsistentes si existe correlación entre el error idiosincrático y alguna variable explicativa en algún período.

Necesitamos una forma de estimación consistente, con $N \longrightarrow \infty$ y $T$ fijo, cuando las variables explicativas no son estrictamente exógenas.

Esto es lo que ocurre cuando tenemos modelos dinámicos (i.e. la variable dependiente aparece como regresor rezagada).

El modelo que vamos a analizar es el mismo que en FE:

$$
y_{it} = x_{it}\beta + c_i + u_{it}, \quad t = 1, 2, \ldots, T
\tag{1}
$$

---

## Modelos Dinámicos

Pero además de permitir que $c_i$ y $x_{it}$ estén arbitrariamente correlacionadas, ahora también permitimos que $u_{it}$ esté correlacionada con valores futuros de las variables explicativas, $(x_{it+1}, x_{it+2}, \ldots, x_{it+T})$.

Ejemplo: AR(1)

$$
y_{it} = y_{it-1}\beta + c_i + u_{it}, \quad t = 1, 2, \ldots, T
$$

En este ejemplo $x_{it} = y_{it-1}$ por lo tanto $u_{it}$ va a estar correlacionado con $x_{it+1} = y_{it}$.

Para resolver este problema necesitamos una nueva condición de exogeneidad: exogeneidad secuencial (Chamberlain, 1992)

Decimos que las variables explicativas son secuencialmente exógenas condicionadas en el efecto no observable cuando se cumple que:

$$
E(u_{it}\mid x_{it}, x_{it-1}, \ldots, x_{i1}, c_i) = 0, \quad t = 1, 2, \ldots, T.
\tag{2}
$$

---

## Modelos Dinámicos

Usando el modelo (1) esta última condición es equivalente a:

$$
E(y_{it}\mid x_{it}, x_{it-1}, \ldots, x_{i1}, c_i) = E(y_{it}\mid x_{it}, c_i) = x_{it}\beta + c_i.
$$

La primera igualdad es la que le da el sentido a la condición: exogeneidad secuencial implica que después de haber controlado por $x_{it}$ y $c_i$, ningún valor pasado de $x_{it}$ afecta el valor esperado de $y_{it}$.

Si estimamos por FE cuando el supuesto de exogeneidad estricta no se cumple obtendremos estimadores inconsistentes.

Considere un modelo de panel para variables observadas a través de un corte transversal y en el tiempo, siendo $\beta$ el parámetro que estamos interesados en estimar y con $c_i$ siendo la heterogeneidad no observada:

$$
y_{it} = x_{it}\beta + c_i + u_{it}, \quad i = 1, \ldots, N \quad t = 1, \ldots, T
$$

---

## Introducción a los Modelos de Panel Dinámicos

Este modelo se puede re-escribir *stacking* las observaciones de series temporales como:

$$
y_i = X_i\beta + c_i + u_i
$$

Los métodos de panel tradicionales para estimar $\beta$, como los modelos de fixed-effect o random-effect, transforman el modelo de forma tal de erradicar los problemas que causan la presencia de $c_i$. Esto lo hacen poniendo a $c_i$ como parte del error y estimando $\beta$ por FGLS o eliminándolo a través de primeras diferencias o con la *within transformation*.

Estos métodos descansan en algún supuesto de exogeneidad para alcanzar la consistencia en términos de una teoría asintótica con $T$ fijo. Considere, por ejemplo, el estimador de efectos fijos de $\beta$. Haciendo que las variables expresadas como desviaciones de sus medias temporales se denoten por $\ddot{\ }$, el estimador de efectos fijos de $\beta$, $\hat\beta^{FE}$ es:

---

## Introducción a los Modelos de Panel Dinámicos

$$
\hat\beta^{FE}
= \beta +
\left(\sum_{i=1}^{N} \ddot X_i' \ddot X_i\right)^{-1}
\left(\sum_{i=1}^{N} \ddot X_i' \ddot u_i\right)
$$

$$
= \beta +
\left(\sum_{i=1}^{N} \ddot X_i' \ddot X_i\right)^{-1}
\left(\sum_{i=1}^{N} \ddot X_i' u_i\right)
$$

$$
= \beta +
\left(\frac{1}{N}\sum_{i=1}^{N} \ddot X_i' \ddot X_i\right)^{-1}
\left(\frac{1}{N}\sum_{i=1}^{N} \ddot X_i' u_i\right)
$$

Para chequear las propiedades asintóticas (con $T$ fijo) de $\hat\beta^{FE}$, asumamos que tenemos una muestra aleatoria de las observaciones de corte transversal. Bajo la muestra aleatoria,

$$
p\lim \left(\sum_{i=1}^{N} \ddot X_i' u_i\right) = E\left(\ddot X_i' u_i\right)
$$

---

## Introducción a los Modelos de Panel Dinámicos

La consistencia requiere que,

$$
\forall i \in \mathcal{N} : E\left(\ddot X_i' u_i\right) = 0_k
$$

Esta condición puede asegurarse claramente por el supuesto usual de exogeneidad estricta:

$$
\forall i \in \mathcal{N}, \ \forall t \in \mathcal{T} : E(u_{it}\mid c_i, X_i) = E(u_{it}\mid c_i, x_{i1}, x_{i2}, \ldots, x_{iT}) = 0
$$

Nosotros vamos a considerar un modelo de datos de panel dinámico cuando se cumpla la siguiente condición, más débil, de exogeneidad, exogeneidad secuencial:

$$
\forall i \in \mathcal{N} : E(u_{it}\mid c_i, x_{i1}, \ldots, x_{it-1}, x_{it}) = 0
$$

---

## Introducción a los Modelos de Panel Dinámicos

Bajo exogeneidad secuencial, la condición de consistencia para el estimador de efectos fijos no puede garantizarse que se cumpla. Para ver porqué, calculemos $E(\ddot x_{it}u_{it})$:

$$
E(\ddot x_{it}u_{it})
= E\left[\left(x_{it} - \frac{1}{T}\sum_{t=1}^{T} x_{it}\right)u_{it}\right]
$$

$$
= E[x_{it}u_{it}] - \frac{1}{T}\sum_{j=1}^{T} E[x_{ij}u_{it}]
$$

Por la ley de expectativas iteradas y la condición de exogeneidad secuencial, tenemos

$$
E[x_{it}u_{it}] = E\left[x_{it} E\left[u_{it}\mid c_i, x_{i1}, \ldots, x_{it-1}, x_{it}\right]\right]
$$

$$
= 0
$$

---

## Introducción a los Modelos de Panel Dinámicos

$$
E[x_{ij}u_{it}] = 0 \quad \forall j \leq t
$$

$$
\Rightarrow \quad
E(\ddot x_{it}u_{it}) = -\frac{1}{T}\sum_{j=t+1}^{T} E[x_{ij}u_{it}]
$$

que no puede asumirse igual a cero. Por lo tanto, $\hat\beta^{FE}$ no es consistente en el contexto de modelos de panel dinámicos. La estimación consistente de $\beta$ requiere de un nuevo método.

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

## Sesgo de Nickell

El modelo típico de datos de panel macro incluye valores rezagados de la variable $y_{it}$ entre los regresores. En tales modelos es claro que solo la condición de exogeneidad secuencial puede asumirse. Considere, por ejemplo, $x_{it} = y_{it-1}$:

$$
E(u_{it}\mid c_i, y_{i1}, \ldots, y_{it-2}, y_{it-1}) \text{ podría ser igual a } 0
$$

pero $E(u_{it}y_{it})$ no porque $y_{it}$ depende de $u_{it}$

El ejemplo de arriba es conocido como el modelo AR(1) de efectos no observados, el modelo de panel dinámico por excelencia:

$$
y_{it} = c_i + \rho y_{it-1} + u_{it}
$$

---

## Sesgo de Nickell

Aquí el parámetro de interés es $\rho$. La expresión analítica del sesgo asintótico de $\rho$ en este modelo fue derivada por Nickell (1981) y se conoce como el sesgo de Nickell. Puede escribirse como:

$$
\nu(\rho, T) = p\lim \hat\rho^{FE} - \rho
$$

$$
= \left\{
\frac{2\rho}{1-\rho^2}
-
\left[
\frac{1+\rho}{T-1}
\left(
1 - \frac{1}{T}\left(\frac{1-\rho^T}{1-\rho}\right)
\right)
\right]^{-1}
\right\}^{-1}
$$

Nickell mostró que este sesgo es siempre negativo si $\rho > 0$ y que nunca converge a cero aún si $\rho = 0$. Más aún, el sesgo se vuelve más grande si se adicionan regresores exógenos a la ecuación. Y los estimadores de los coeficientes que acompañan a los regresores exógenos también son inconsistentes.

---

## Sesgo de Nickell

No obstante, este problema ha sido considerado como un problema de $T$ fijo. Con una condición de estabilidad, $|\rho| < 1$, se puede mostrar que:

$$
\lim_{T \to \infty} \nu(\rho, T) = 0
$$

Sin embargo, el sesgo persiste aún cuando $T \to \infty$ si $\rho$ se acerca a uno.
