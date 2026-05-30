# Panel 03,0 2026 2 - Corrección del sesgo de selección sin endogeneidad

**Fuente:** Econometría de Datos de Panel, Maestrías en Economía y Econometría, Lecture 3. Martín González-Rozada (UTDT), Primer Trimestre, 2026.

> Nota de transcripción: se sigue lo más verbatim posible la notación del profesor. Los botones de navegación tipo “Go” se omiten por no ser contenido sustantivo. No hay imágenes sustantivas; el material contiene texto, ecuaciones y procedimientos.

---

## Agenda

1. Sesgo de Selección: “Attrition” y Truncamiento Incidental
   - Cuándo Podemos Ignorar el Sesgo de Selección?
   - Contrastes por Sesgo de Selección
   - Corrección del Sesgo de Selección Muestral: Truncamiento Incidental
   - Procedimiento de Wooldridge
   - Procedimiento de Rochina-Barrachina
   - Corrección del Sesgo de Selección Muestral: Attrition
2. Sesgo de Selección y Endogeneidad

---

## Truncamiento Incidental: Estimación

Corregir el sesgo de selección en el caso de truncamiento incidental requiere mucho más cuidado.

Desafortunadamente, bajo cualquier supuesto que permita heterogeneidad no observada en la ecuación de selección, adicionar $\hat{\lambda}_{it}$ a la ecuación (3) y usar FE no produce estimadores consistentes (Wooldridge, 1995).

Para tener un método que funcione necesitamos agregar algunos supuestos de linealidad a los valores esperados de $u_{it}$ y $c_i$ dados $x_i$ y $v_{it}$.

**Supuesto FEUP.2:**

(a) La ecuación de selección está dada por (4);

(b)

$$
E(u_{it}\mid x_i; v_{it}) = E(u_{it}\mid v_{it}) = \rho_t v_{it}, \quad t = 1; \ldots ; T;
$$

y (c)

$$
E(c_i \mid x_i; v_{it}) = L(c_i \mid 1; \bar{x}_i; v_{it}),
$$

donde $L(\cdot\mid\cdot)$ es el operador proyección lineal.

El Supuesto FEUP.2 (b) es estándar y se sigue del supuesto de normalidad conjunta de $(u_{it}, v_{it})$ como en Heckman (1976).

---

## Truncamiento Incidental: Estimación

El Supuesto FEUP.2 (c) implica que $c_i$ depende (linealmente) de $x_i$ solo a través del promedio temporal,

$$
E(c_i \mid x_i, v_{it}) = \pi_0 + \bar{x}_i \pi + \phi_t v_{it}.
$$

Tomando esperanzas condicionales en (3),

$$
\begin{aligned}
E(y_{it}\mid x_i, v_{it})
&= x_{it}\beta + E(c_i\mid x_i, v_{it}) + E(u_{it}\mid x_i, v_{it}) \\
&= \pi_0 + x_{it}\beta + \bar{x}_i\pi + \phi_t v_{it} + \rho_t v_{it} \\
&= \pi_0 + x_{it}\beta + \bar{x}_i\pi + \gamma_t v_{it}.
\end{aligned}
$$

Condicionando en $s_{it}=1$,

$$
\begin{aligned}
E(y_{it}\mid x_i, s_{it}=1)
&= \pi_0 + x_{it}\beta + \bar{x}_i\pi + \gamma_t E(v_{it}\mid x_i, s_{it}=1) \\
&= \pi_0 + x_{it}\beta + \bar{x}_i\pi + \gamma_t E(v_{it}\mid x_i, v_{it} > -\eta_0 - \bar{x}_i\eta - x_{it}\delta) \\
&= \pi_0 + x_{it}\beta + \bar{x}_i\pi + \gamma_t \lambda_{it},
\end{aligned}
$$

donde $\lambda_{it}$ denota la inversa del cociente de Mills.

---

## Truncamiento Incidental: Estimación

La última ecuación lleva al siguiente procedimiento,

1. Estime la ecuación (4) por pooled probit a través de $i$ y $t$. Para $s_{it}=1$ obtenga la inversa del cociente de Mills estimado

$$
\hat{\lambda}_{it}
= \phi(\hat{\eta}_0 + \bar{x}_i\hat{\eta} + x_{it}\hat{\delta}) / \Phi(\hat{\eta}_0 + \bar{x}_i\hat{\eta} + x_{it}\hat{\delta})
= \phi(h_{it}\hat{\mu}) / \Phi(h_{it}\hat{\mu}).
$$

Donde $\phi(\cdot)$ y $\Phi(\cdot)$ son la densidad y la distribución acumulada de la normal estándar, respectivamente.

$$
h_{it} \equiv (1\ \bar{x}_i\ x_{it});
\qquad
\hat{\mu} = (\hat{\eta}_0\ \hat{\eta}'\ \hat{\delta}')'.
$$

2. Para $s_{it}=1$ defina el vector $1\times(1+2K+T)$,

$$
\hat{w}_{it} = (1, \underbrace{\bar{x}_i}_{K}, \underbrace{x_{it}}_{K}, \underbrace{0,\ldots,0,\hat{\lambda}_{it},0,\ldots,0}_{T}),
$$

y obtenga $\hat{\theta} = (\hat{\pi}_0, \hat{\pi}', \hat{\beta}', \hat{\gamma}')'$ como el estimador pooled OLS en

$$
y_{it} = \hat{w}_{it}\theta + error_{it}, \quad s_{it}=1.
$$

---

## Truncamiento Incidental: Inferencia

Esto da,

$$
\hat{\theta}
= \left(\sum_{i=1}^{N}\sum_{t=1}^{T} s_{it}\hat{w}_{it}'\hat{w}_{it}\right)^{-1}
\left(\sum_{i=1}^{N}\sum_{t=1}^{T} s_{it}\hat{w}_{it}' y_{it}\right).
$$

$\hat{\theta}$ será consistente y $\sqrt{N}$-asintóticamente normal. Sin embargo, la inferencia no es estándar debido a la presencia de $\hat{\lambda}_{it}$ en el segundo paso de la estimación.

---

## Truncamiento Incidental: Inferencia

Estime la varianza asintótica de $\hat{\theta}$, $Avar(\hat{\theta})$ como sigue:

1. Defina los residuos de pooled OLS

$$
\hat{e}_{it} \equiv y_{it} - \hat{w}_{it}\hat{\theta}, \quad s_{it}=1.
$$

2. Defina la matriz

$$
\hat{D} \equiv N^{-1}\sum_{i=1}^{N}\sum_{t=1}^{T} s_{it}\hat{w}_{it}'\hat{\theta}'G_{it}
$$

Donde,

$$
G_{it} =
\begin{pmatrix}
0 & 0 & \cdots & 0 & 0 & 0 & \cdots & 0 \\
0 & 0 & \cdots & 0 & Z_{it} & 0 & \cdots & 0
\end{pmatrix}
$$

es $(1+2K+T)\times T(1+2K)$. Cada cero en la primera fila (bloque) de $G_{it}$ es una matriz de $(1+2K)\times(1+2K)$ y cada cero en la segunda fila (bloque) es una matriz de $T\times(1+2K)$. La matriz $Z_{it}$ está en la $t$-ésima columna (bloque) de la matriz.

---

## Truncamiento Incidental: Inferencia

Continuación

2. (Cont.) La matriz, $T\times(1+2K)$, $Z_{it}$ se define como

$$
Z_{it} = (0'\ 0'\ \ldots\ 0'\ (\dot{\lambda}_{it}h_{it})'\ 0'\ \ldots\ 0')',
$$

donde $\dot{\lambda}_{it}$ es la derivada de $\lambda_{it}$ evaluada en $h_{it}\hat{\mu}$. Cada cero en $Z_{it}$ es $1\times(1+2K)$.

3. Para cada $i$, $\hat{r}_i$ es el vector $(1+2K)\times1$ igual a menos la inversa del Hesiano promedio por la función score del logaritmo de la función de verosimilitud del probit estimada para la observación $i$.

4. Obtenga

$$
\hat{A} = N^{-1}\sum_{i=1}^{N}\sum_{t=1}^{T} s_{it}\hat{w}_{it}'\hat{w}_{it}.
$$

---

## Truncamiento Incidental: Inferencia

(cont.) Para cada $i$ defina,

$$
\hat{q}_i = \sum_{t=1}^{T} s_{it}\hat{w}_{it}'\hat{e}_{it}
\qquad \text{y} \qquad
\hat{p}_i = \hat{q}_i - \hat{D}\hat{r}_i.
$$

5. Defina,

$$
\hat{B} = N^{-1}\sum_{i=1}^{N}\sum_{t=1}^{T}\hat{p}_i\hat{p}_i'.
$$

Entonces,

$$
\widehat{Avar}(\hat{\theta}) = \hat{A}^{-1}\hat{B}\hat{A}^{-1}/N.
$$

---

## Paneles No Balanceados: Truncamiento Incidental

Un segundo caso que a veces se encuentra en la práctica es aquel en el que la variable de selección se observa en forma parcial.

En economía uno de los casos en donde esta situación aparece es en estudios del mercado de trabajo donde las ecuaciones son las de oferta de trabajo y las de salario.

En este caso la ecuación de interés es:

$$
y_{jt} = x^1_{jt}\beta + c_j + u_{jt}, \quad t = 1,2,\ldots,T. \tag{5}
$$

La variable $y_{jt}$ se observa siempre que $h_{jt}$ se observa. Para cada $t=1,2,\ldots,T$, definamos la siguiente variable censurada:

$$
h_{jt} = \max(0,h^*_{jt}), \quad \text{se observa, y}
$$

$$
h^*_{jt} = \delta_{t0} + x_{j1}\delta_{t1} + \ldots + x_{jT}\delta_{tT} + v_{jt}. \tag{6}
$$

Donde

$$
v_{jt}\mid X_j \sim Normal(0,1).
$$

---

## Paneles No Balanceados: Truncamiento Incidental

$x_{jt}$ denota el conjunto total de variables explicativas en el período $t$ y $x^1_{jt}$ es un subconjunto de esas variables.

El mecanismo de selección descripto por la ecuación (6) puede ser visto como la forma reducida de la ecuación de selección.

Los supuestos necesarios para derivar la generalización del procedimiento de Heckman en este caso son.

**Supuesto W.1:**

(a) La ecuación de selección está dada por (6) con todos sus supuestos;

(b)

$$
E(u_{jt}\mid X_j, v_{jt}) = E(u_{jt}\mid v_{jt}) = \rho_t v_{jt}, \quad t = 1,2,\ldots,T;
$$

y

(c)

$$
E(c_j\mid X_j, v_{jt}) = L(c_j\mid X_j, v_{jt}).
$$

---

## Paneles No Balanceados: Truncamiento Incidental

La estrategia utilizada para estimar en forma consistente en este caso es:

(1) Para cada $t$, estime la ecuación:

$$
h_{jt} = \max(0, X_j\delta_t + v_{jt})
$$

usando un modelo Tobit estándar.

Recuerde que en este set up $X_j=(1,x_{j1},x_{j2},\ldots,x_{jt})$ y $\delta_t=(\delta_{t0},\delta_{t1},\ldots,\delta_{tT})$.

Para $s_{jt}=1$, defina

$$
\hat{v}_{jt} = h_{jt} - X_j\hat{\delta}_t
$$

y el vector $1\times(1+TK+K+T)$:

$$
\hat{w}_{jt} = (1, x_{j1},\ldots,x_{jT}, 0,\ldots,0, \hat{v}_{jt}, 0,\ldots,0).
$$

---

## Paneles No Balanceados: Truncamiento Incidental

(2) Aplique POLS a:

$$
y_{jt} = \hat{w}_{jt}
\begin{pmatrix}
\hat{\pi} \\
\hat{\beta} \\
\hat{\gamma}
\end{pmatrix}
+ error_{jt}; \quad s_{jt}=1.
$$

Lo que da:

$$
\hat{\theta} =
\begin{pmatrix}
\hat{\pi} \\
\hat{\beta} \\
\hat{\gamma}
\end{pmatrix}
=
\left(\sum_{j=1}^{N}\sum_{t=1}^{T}s_{jt}\hat{w}_{jt}'\hat{w}_{jt}\right)^{-1}
\left(\sum_{j=1}^{N}\sum_{t=1}^{T}s_{jt}\hat{w}_{jt}'y_{jt}\right).
$$

---

## Paneles No Balanceados: Truncamiento Incidental

(3) Estime la varianza asintótica de los estimadores, $\widehat{Avar}(\hat{\theta})$, como sigue:

Primero defina los residuos, $\hat{e}_{jt}\equiv y_{jt}-\hat{w}_{jt}\hat{\theta}$, donde $s_{jt}=1$.

Defina la matriz:

$$
\hat{D} \equiv N^{-1}\sum_{j=1}^{N}\sum_{t=1}^{T}s_{jt}\hat{w}_{jt}'\hat{\theta}'G_{jt}.
$$

Donde

$$
G_{jt} =
\begin{pmatrix}
0 & 0 & \ldots & 0 & 0 & 0 & \ldots & 0 \\
0 & 0 & \ldots & 0 & Z_{jt} & 0 & \ldots & 0
\end{pmatrix}
$$

es una matriz de dimensión:

$$
(1+TK+K+T)\times T(1+TK).
$$

Cada cero en la primera fila de $G_{jt}$ es de dimensión $(1+TK+K)\times(1+TK)$, y cada cero en la segunda fila de la matriz es de dimensión $T\times(1+TK)$. La matriz $Z_{jt}$ está ubicada a partir de la columna $t$-ésima y es de dimensión $T\times(1+TK)$.

$$
Z_{jt} = (0',0',\ldots,0', -X_j, 0',\ldots,0')'.
$$

---

## Paneles No Balanceados: Truncamiento Incidental

Cada cero en $Z_{jt}$ es de dimensión $1\times(1+TK)$ y el vector $1\times(1+TK)$, $-X_j$, está ubicado en la $t$-ésima fila.

Para cada $t$, defina $\hat{r}_{jt}$ como el vector $(1+TK)\times1$ igual a menos la inversa de la matriz Hesiana promedio estimada multiplicada por la derivada de la función del logaritmo de verosimilitud del modelo Tobit para la observación $j$ (recuerde eliminar el último elemento de este vector porque la varianza no aparece en $\hat{v}_{jt}$).

Construya el vector $\hat{r}_j$ de dimensión $T(1+TK)\times1$ “stacking” $\{\hat{r}_{j1},\hat{r}_{j2},\ldots,\hat{r}_{jT}\}$.

---

## Paneles No Balanceados: Truncamiento Incidental

La matriz $\hat{A}$ viene dada por:

$$
\hat{A} \equiv N^{-1}\sum_{j=1}^{N}\sum_{t=1}^{T}s_{jt}\hat{w}_{jt}'\hat{w}_{jt}.
$$

Además, para cada $j=1,2,\ldots,N$ defina:

$$
\hat{q}_j = \sum_{t=1}^{T}s_{jt}\hat{w}_{jt}'\hat{e}_{jt}
\qquad \text{y} \qquad
\hat{p}_j = \hat{q}_j - \hat{D}\hat{r}_j.
$$

Un estimador consistente de $B$ es:

$$
\hat{B} \equiv N^{-1}\sum_{j=1}^{N}\hat{p}_j\hat{p}_j'.
$$

Finalmente la varianza asintótica de los estimadores del modelo viene dada por:

$$
\widehat{Avar}(\hat{\theta}) = \hat{A}^{-1}\hat{B}\hat{A}^{-1}/N.
$$

Y los desvíos estándar asintóticos se obtienen con la raíz cuadrada de los elementos de la diagonal de esta matriz.

**Remark 2.** Como ocurría con el caso anterior, la corrección propuesta por Wooldridge requiere que se cumpla el supuesto de exogeneidad estricta de los regresores (condicional a los efectos no observables).

---

## Paneles No Balanceados: Truncamiento Incidental

Existe un estimador alternativo al de Wooldridge para el caso en que el mecanismo de selección viene dado por una variable binaria.

Este estimador, sugerido por Rochina-Barrachina (1999) (RB a partir de ahora) difiere del estimador de Wooldridge en que permite que la media condicional de los efectos no observables de la ecuación de interés sea desconocida.

Para levantar el supuesto W.1(c) de Wooldridge, RB impone el supuesto de que la distribución conjunta de los errores de la ecuación de interés en primeras diferencias y los errores de las dos ecuaciones de selección (correspondientes a los dos períodos de las diferencias finitas), condicional al vector completo de variables explicativas estrictamente exógenas, es normal.

---

## Paneles No Balanceados: Truncamiento Incidental

RB desarrolla su estimador en el contexto de un panel en donde el número de observaciones de corte transversal es grande y las propiedades asintóticas del estimador son válidas con $N\to\infty$.

El desarrollo se basa en dos períodos temporales, $T=2$, y es como lo estudiaremos aquí.

La idea básica del estimador es, primero, eliminar los efectos no observables de la ecuación de interés tomando diferencias.

---

## Paneles No Balanceados: Truncamiento Incidental

Después, condicionando en que el resultado del proceso de selección sea uno en los dos períodos temporales, construir la ecuación a estimar en el segundo paso.

Esta ecuación contiene dos términos de corrección por sesgo de selección muestral.

La ecuación de interés es:

$$
y_{jt} = x^1_{jt}\beta + c_j + u_{jt}, \quad t = 1,2,\ldots,T. \tag{7}
$$

RB plantea la siguiente ecuación estructural para el mecanismo de selección:

$$
h^*_{jt} = \xi_j + x_{jt}\delta + a_{jt},
$$

con

$$
s_{jt} = 1[h^*_{jt} \geq 0],
$$

---

## Paneles No Balanceados: Truncamiento Incidental

Donde $c_j$ y $\xi_j$ son efectos específicos de corte transversal no observables que probablemente estén correlacionados con las variables explicativas observables.

$u_{jt}$ y $a_{jt}$ son errores idiosincráticos no necesariamente independientes uno del otro.

Para obtener estimadores consistentes en (7) utilizando solo las observaciones de la muestra seleccionada necesitamos la siguiente condición:

$$
E(u_{jt}-u_{js}\mid X_j, s_{jt}=s_{js}=1)=0, \quad s\neq t. \tag{8}
$$

Esta condición está expresada en forma diferente a la que utilizamos cuando vimos la estimación usando diferencias finitas.

---

## Paneles No Balanceados: Truncamiento Incidental

Note que en la condición anterior, a diferencia de lo que hacíamos con FD, no necesariamente necesitamos el operador diferencias finitas de orden uno. De hecho, cualquier diferencia temporal entre dos observaciones del mismo corte transversal eliminará el componente $c_j$.

En particular, esta condición nos permitirá trabajar con aquellas observaciones que tengan $s_{jt}=s_{js}=1\ (t\neq s)$.

---

## Paneles No Balanceados: Truncamiento Incidental

Como mencionamos anteriormente, la condición (8) en general será diferente de cero debido al sesgo de selección muestral.

Los supuestos necesarios para derivar la corrección propuesta por RB son:

**Supuesto RB.1**

(a) $\xi_j$ está correlacionado con $X_j$, a través de la siguiente especificación:

$$
\xi_j = \eta_0 + x_{j1}\eta_1 + \ldots + x_{jT}\eta_T + \alpha_j.
$$

(b) los errores de la ecuación de selección tienen distribución normal,

$$
v_{jt} = a_{jt} + \xi_j \sim N(0,\sigma_t^2).
$$

(c) los errores $[(u_{jt}-u_{js}), v_{jt}, v_{js}]$ tienen distribución conjunta trivariada normal condicional a $X_j$.

---

## Paneles No Balanceados: Truncamiento Incidental

Bajo el supuesto RB.1, la forma funcional del término de sesgo de selección se puede derivar de la generalización del Teorema 20.4 de Greene para el caso de la distribución normal multivariante truncada.

La esperanza condicional (8) puede escribirse como:

$$
E(u_{jt}-u_{js}\mid X_j, v_{jt}\geq -H_{jt}, v_{js}\geq -H_{js})
= \sigma_{(u_j-u_s)(v_t/\sigma_t)}\lambda_{jts}
+ \sigma_{(u_j-u_s)(v_s/\sigma_s)}\lambda_{jts},
$$

Donde $H_{j\tau}=X_{j\tau}\delta+E(\xi_j\mid X_j)$ para $\tau=t,s$, es la forma reducida de los indicadores de selección para los períodos $t$ y $s$.

Además,

$$
\lambda_{jts} = \phi(M_{jt})\Phi(M^*_{jts})/\Phi_2(M_{jt},M_{js},\rho_{ts}),
$$

y

$$
\lambda_{jst} = \phi(M_{js})\Phi(M^*_{jtt})/\Phi_2(M_{jt},M_{js},\rho_{ts}).
$$

Donde,

$$
M_{jt}=\frac{H_{jt}}{\sigma_t}, \qquad
M_{jt}=\frac{H_{js}}{\sigma_s},
$$

$$
M^*_{jts} = \frac{M_{js}-\rho_{ts}M_{jt}}{(1-\rho_{ts}^2)^{1/2}}
\qquad \text{y} \qquad
M^*_{jst} = \frac{M_{jt}-\rho_{ts}M_{js}}{(1-\rho_{ts}^2)^{1/2}}.
$$

---

## Paneles No Balanceados: Truncamiento Incidental

Y $\rho_{ts}=\rho_{(v_t/\sigma_t)(v_s/\sigma_s)}$ es el coeficiente de correlación entre los errores del proceso de selección.

Como antes $\phi(.)$ es la función de densidad y $\Phi(.)$ y $\Phi_2(.)$ son las funciones acumuladas de la distribución normal estándar univariante y bivariante, respectivamente.

Por lo tanto, la ecuación a estimar queda:

$$
y_{jt}-y_{js} = (x^1_{jt}-x^1_{js})\beta
+ \ell_{ts}\lambda(M_{jt},M_{js},\rho_{ts})
+ \ell_{st}\lambda(M_{js},M_{jt},\rho_{ts}) + e_{jts}. \tag{9}
$$

Donde

$$
e_{jts} \equiv (u_{jt}-u_{js}) - [\ell_{ts}\lambda(M_{jt},M_{js},\rho_{ts}) + \ell_{st}\lambda(M_{js},M_{jt},\rho_{ts})]
$$

Es un nuevo término de error que por construcción satisface:

$$
E(u_{jt}-u_{js}\mid X_j, v_{jt}\geq -H_{jt}, v_{js}\geq -H_{js})=0.
$$

Con estas condiciones la solución del problema es inmediata.

---

## Paneles No Balanceados: Truncamiento Incidental

Si podemos estimar consistentemente, $\lambda_{jts}$ y $\lambda_{jst}$, POLS en (9) puede utilizarse para obtener estimaciones consistentes de $\beta$, $\ell_{ts}$ y $\ell_{st}$.

En la práctica, para construir estimaciones consistentes de los términos $\lambda_{jts}$ y $\lambda_{jst}$, los coeficientes $(\delta,\rho_{ts})$ se determinan conjuntamente usando un modelo Probit bivariado para cada combinación de períodos temporales. El segundo paso, consiste en aplicar POLS a (9).

---

## Paneles No Balanceados: Truncamiento Incidental

Una de las complicaciones del estimador de RB es que todo el análisis está basado en $T=2$. Si $T>2$, entonces en el primer paso se pueden estimar

$$
\binom{T}{2}
$$

modelos Probit bivariados, cada uno de ellos basado en una combinación diferente de dos períodos temporales.

Una vez que las estimaciones de los términos que corrigen el sesgo de selección muestral se incluyen en (9), esta ecuación puede ser estimada para cada combinación de ondas del panel $(t,s)$, $t\neq s$, lo que da un total de

$$
\binom{T}{2}
$$

pares para un panel de largo $T$.

---

## Paneles No Balanceados: Truncamiento Incidental

Por lo tanto para $T>2$, hay que utilizar un procedimiento que combine todas estas estimaciones en una sola.

RB sugieren un procedimiento de mínima distancia (i.e. GMM) con su correspondiente matriz ponderadora.

Para construir la matriz ponderadora se requiere la estimación de la matriz de varianzas y covarianzas de los estimadores para los diferentes períodos temporales.

---

## Agenda

1. Sesgo de Selección: “Attrition” y Truncamiento Incidental
   - Cuándo Podemos Ignorar el Sesgo de Selección?
   - Contrastes por Sesgo de Selección
   - Corrección del Sesgo de Selección Muestral: Truncamiento Incidental
   - Procedimiento de Wooldridge
   - Procedimiento de Rochina-Barrachina
   - Corrección del Sesgo de Selección Muestral: Attrition
2. Sesgo de Selección y Endogeneidad

---

## Attrition: Marco de Análisis

Attrition general, donde las unidades de corte transversal re-ingresan en la muestra después de dejarla, es complicado.

Vamos a analizar un caso especial.

En $t=1$ se obtiene una muestra aleatoria de la población relevante.

En $t=2$ algunas unidades de corte transversal eligen salirse del panel por razones que no son enteramente aleatorias.

Asumimos que, una vez que la persona se sale del panel, el o ella sale para siempre: attrition es un estado absorvente.

Cualquier panel con attrition puede ser construido de esta manera, ignorando cualquier observación subsiguiente de las unidades de corte transversal que ya han salido de la muestra.

---

## Attrition: Corrección

Considere el siguiente modelo.

$$
y_{jt} = x_{jt}\beta + c_j + u_{jt}, \tag{10}
$$

donde asumimos que $(x_{jt},y_{jt})$ se observa para todo $j$ cuando $t=1$.

Hagamos que $s_{jt}$ denote el indicador de selección para cada período temporal, donde $s_{jt}=1$ si $(x_{jt},y_{jt})$ se observan.

Como ignoramos las unidades una vez que han salido de la muestra, $s_{jt}=1$ implica $s_{jr}=1$ para $r<t$.

Tomemos diferencias finitas de primer orden.

$$
\Delta y_{jt} = \Delta x_{jt}\beta + \Delta u_{jt}, \quad t=2,\ldots,T. \tag{11}
$$

---

## Attrition: Corrección

Condicional en $s_{jt-1}=1$, escribamos la forma reducida de la ecuación de selección para $t\geq2$ como

$$
s_{jt} = 1[w_{jt}\delta_t + v_{jt} > 0],
\quad
v_{jt}\mid\{w_{jt},s_{jt-1}=1\}\sim Normal(0,1). \tag{12}
$$

Donde $w_{jt}$ debe contener variables observadas en $t$ para todas las unidades con $s_{jt-1}=1$.

Buenos candidatos para $w_{jt}$ incluyen las variables en $x_{jt-1}$ y cualquier variable in $x_{jt}$ que sea observada en $t$ cuando $s_{jt-1}=1$ (por ejemplo, si $x_{jt}$ contiene rezagos de variables o una variable como edad).

Sin embargo, como $y_{jt-1}$ está correlacionada con $u_{jt-1}$ no debería incluirse en $w_{jt}$.

---

## Attrition: Corrección

Si las $x_{jt}$ son estrictamente exógenas y la selección no depende de $\Delta x_{jt}$ una vez que se controla por $w_{jt}$, un supuesto razonable (bajo normalidad conjunta de $\Delta u_{jt}$ y $v_{jt}$ es

$$
E(\Delta u_{jt}\mid \Delta x_{jt}, w_{jt}, v_{jt}, s_{jt-1}=1)
= E(\Delta u_{jt}\mid v_{jt}) = \rho_t v_{jt}. \tag{13}
$$

Entonces,

$$
E(\Delta y_{jt}\mid \Delta x_{jt}, w_{jt}, s_{jt}=1)
= \Delta x_{jt}\beta + \rho_t\lambda(w_{jt}\delta_t), \quad t=2,\ldots,T. \tag{14}
$$

Note como, porque $s_{jt-1}=1$ cuando $s_{jt}=1$, no necesitamos condicionar en $s_{jt-1}$.

---

## Attrition: Corrección

Se sigue de la última ecuación que pooled OLS de $\Delta y_{jt}$ sobre $\Delta x_{jt}, d_{2t}\hat{\lambda}_{jt}, \ldots, d_{Tt}\hat{\lambda}_{jt}$, $t=2,\ldots,T$, donde los $\hat{\lambda}_{jt}$ vienen de los $T-1$ probits de corte transversal de la ecuación (12), es consistente para $\beta$ y $\rho_t$.

Un contraste conjunto (completamente robusto) de $H_0:\rho_t=0$, $t=2,\ldots,T$ es un test simple por la presencia de sesgo de selección por attrition.

Hay dos problemas potenciales con este enfoque.

1. La primera igualdad en (13) es restrictiva porque significa que $x_{jt}$ no afecta la attrition una vez que se controla por los elementos de $w_{jt}$.
2. Asumimos exogeneidad estricta de $x_{jt}$.

Ambas restricciones se pueden relajar con un procedimiento de IV.
