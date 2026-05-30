# Estimación en Presencia de Sesgo de Selección y Endogeneidad

## Pooled 2SLS (Wooldridge & Semykina, 2010)

Considere el siguiente modelo,

$$
y_{it}=x_{it}\beta+v_{it}
\tag{15}
$$

donde $x_{it}$ es un vector $1\times K$ que contiene variables exógenas y endógenas, $\beta$ es un vector $K\times 1$ de parámetros y $v_{it}$ es el error compuesto.

Adicionalmente, asumamos que existe un vector $L\times 1$ de instrumentos $(L\geq K)$, $z_{it}$, tal que el supuesto de exogeneidad contemporánea se cumple para todas las variables en $z_{it}$:

$$
E(v_{it}\mid z_{it})=0,\quad t=1,2,\ldots,T.
$$

Asumimos también que: (i) los vectores $x_{it}$ y $z_{it}$ contienen una constante; (ii) los instrumentos están suficientemente correlacionados con las variables explicativas en el análogo poblacional de (15); (iii) $z_{it}$ incluye todas las variables de $x_{it}$ que son exógenas.

---

## Estimación en Presencia de Sesgo de Selección y Endogeneidad: Pooled 2SLS

Ahora introduzcamos sesgo de selección (truncamiento incidental) en el modelo.

Sea $s_{it}$ un indicador de selección que vale uno si $(y_{it},x_{it},z_{it})$ se observa y vale cero en otro caso.

Entonces,

$$
\begin{aligned}
\hat\beta_{2SLS}
=&\left[\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}x'_{it}z_{it}\right)
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}z'_{it}z_{it}\right)^{-1}
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}z'_{it}x_{it}\right)\right]^{-1}\\
&\times\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}x'_{it}z_{it}\right)
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}z'_{it}z_{it}\right)^{-1}
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}z'_{it}y_{it}\right).
\end{aligned}
\tag{16}
$$

---

## Estimación en Presencia de Sesgo de Selección y Endogeneidad: Pooled 2SLS

La ecuación (16) se puede escribir como,

$$
\begin{aligned}
\hat\beta_{2SLS}
=&\ \beta+\left[\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}x'_{it}z_{it}\right)
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}z'_{it}z_{it}\right)^{-1}
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}z'_{it}x_{it}\right)\right]^{-1}\\
&\times\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}x'_{it}z_{it}\right)
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}z'_{it}z_{it}\right)^{-1}
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}z'_{it}v_{it}\right).
\end{aligned}
\tag{17}
$$

Para $T$ fijo y $N\longrightarrow \infty$ las siguientes condiciones establecen la consistencia del estimador Pooled 2SLS.

---

## Estimación en Presencia de Sesgo de Selección y Endogeneidad: Pooled 2SLS

**Supuesto P2SLS.1:**

(i) $(y_{it},x_{it},z_{it})$ se observa cuando $s_{it}=1$;

(ii) $E(v_{it}\mid z_{it},s_{it})=0$, $t=1,2,\ldots,T$;

(iii) $\operatorname{rango} E\left(\sum_{t=1}^T s_{it}z'_{it}x_{it}\right)=K$;

(iv) $\operatorname{rango} E\left(\sum_{t=1}^T s_{it}z'_{it}z_{it}\right)=L$.

El Supuesto P2SLS.1 (iii) es la condición de rango importante (sobre la subpoblación observada) y requiere que haya suficientes instrumentos $(L\geq K)$ y que estén correlacionados con $x_{it}$.

El Supuesto P2SLS.1 (ii) establece el sentido en el que la selección se asume exógena en (17). Requiere que $v_{it}$ sea independiente en media (condicionalmente) de $z_{it}$ y el mecanismo de selección en $t$.

**Supuesto P2SLS.2:** Bajo el Supuesto P2SLS.1 y condiciones de regularidad estándar el estimador Pooled 2SLS es consistente y asintóticamente normal.

---

## Estimación en Presencia de Sesgo de Selección y Endogeneidad: Pooled 2SLS

**Remark 1:** Note que el Supuesto P2SLS.1 (ii) no restringe la relación entre $v_{it}$ y $s_{ir}$, para $r\neq t$. En otras palabras, el mecanismo de selección se asume exógeno en forma contemporánea pero no en forma estricta.

**Remark 2:** El Supuesto P2SLS.1 no impone ninguna relación acerca de la naturaleza de la endogeneidad de los elementos de $x_{it}$ (i.e. podemos tener variables binarias endógenas en este contexto).

---

## Estimación en Presencia de Sesgo de Selección y Endogeneidad: FE-2SLS

Como mencionamos anteriormente, en muchas aplicaciones de datos de panel queremos introducir en el modelo heterogeneidad no observada que esté correlacionada con las variables explicativas observadas y, en este caso particular, también con las variables instrumentales.

Considere el modelo de componentes no observados,

$$
y_{it}=x_{it}\beta+c_i+u_{it}
\tag{18}
$$

donde $c_i$ es el efecto individual no observado y $u_{it}$ es el error idiosincrático.

Supuestos: (i) correlación arbitraria entre la heterogeneidad no observada y las variables explicativas observadas; (ii) permitimos que algunos elementos de $x_{it}$ estén correlacionados con el error idiosincrático $u_{it}$; (iii) existen instrumentos $z_{it}$ que son estrictamente exógenos condicionados en $c_i$.

---

## Estimación en Presencia de Sesgo de Selección y Endogeneidad: FE-2SLS

Estos supuestos permiten correlación entre $z_{it}$ y $c_i$ pero requieren que los $z_{it}$ no estén correlacionados con $\{u_{ir}:r=1,2,\ldots,T\}$.

Como el modelo de efectos fijos requiere de alguna transformación para eliminar los $c_i$, asumimos que todas las variables en $x_{it}$ y $z_{it}$ varían en el tiempo.

Bajo que condiciones ignorar la selección produce un estimador consistente?

definamos para cada $i$ y $t$:

$$
\ddot{x}_{it}=x_{it}-\frac{1}{T_i}\sum_{r=1}^T s_{ir}x_{ir};\quad
\ddot{z}_{it}=z_{it}-\frac{1}{T_i}\sum_{r=1}^T s_{ir}z_{ir};\quad
\ddot{y}_{it}=y_{it}-\frac{1}{T_i}\sum_{r=1}^T s_{ir}y_{ir}
$$

and

$$
T_i=\sum_{r=1}^T s_{ir}.
$$

Entonces el estimador de 2SLS de efectos fijos (FE-2SLS) es:

---

## Estimación en Presencia de Sesgo de Selección y Endogeneidad: FE-2SLS

$$
\begin{aligned}
\hat\beta_{FE-2SLS}
=&\left[\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{x}'_{it}\ddot{z}_{it}\right)
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{z}'_{it}\ddot{z}_{it}\right)^{-1}
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{z}'_{it}\ddot{x}_{it}\right)\right]^{-1}\\
&\times\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{x}'_{it}\ddot{z}_{it}\right)
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{z}'_{it}\ddot{z}_{it}\right)^{-1}
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{z}'_{it}\ddot{y}_{it}\right).
\end{aligned}
\tag{19}
$$

Usando álgebra,

---

## Estimación en Presencia de Sesgo de Selección y Endogeneidad: FE-2SLS

$$
\begin{aligned}
\hat\beta_{FE-2SLS}
=&\ \beta+\left[\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{x}'_{it}\ddot{z}_{it}\right)
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{z}'_{it}\ddot{z}_{it}\right)^{-1}
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{z}'_{it}\ddot{x}_{it}\right)\right]^{-1}\\
&\times\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{x}'_{it}\ddot{z}_{it}\right)
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{z}'_{it}\ddot{z}_{it}\right)^{-1}
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it}\ddot{z}'_{it}u_{it}\right).
\end{aligned}
\tag{20}
$$

Denote por $z_i=(z_{i1},\ldots,z_{iT})$ y $s_i=(s_{i1},\ldots,s_{iT})$. Para que el estimador FE-2SLS sea consistente en paneles no balanceados necesitamos los siguientes supuestos:

---

## Estimación en Presencia de Sesgo de Selección y Endogeneidad: FE-2SLS

**Supuesto FE2SLS.1:**

(i) $(y_{it},x_{it},z_{it})$ se observa cuando $s_{it}=1$;

(ii) $E(u_{it}\mid z_i,s_i,c_i)=0$, $t=1,2,\ldots,T$;

(iii) $\operatorname{rango}E\left(\sum_{t=1}^T s_{it}\ddot{z}'_{it}\ddot{x}_{it}\right)=K$;

(iv) $\operatorname{rango}E\left(\sum_{t=1}^T s_{it}\ddot{z}'_{it}\ddot{z}_{it}\right)=L$.

Asumiendo que hay suficientes instrumentos que varíen en el tiempo el Supuesto FE2SLS.1 (ii) es el supuesto crítico. Usando la ley de expectativas iteradas, el Supuesto FE2SLS.1 (ii) garantiza que

$$
E\left(\sum_{t=1}^T s_{it}\ddot{z}'_{it}u_{it}\right)=0
$$

y el último término de la ecuación (20) converge en probabilidad a cero cuando $N\longrightarrow \infty$.

El Supuesto FE2SLS.1 (ii) siempre se satisface si los $z_{it}$ son estrictamente exógenos, condicional en $c_i$, y el mecanismo de selección es completamente aleatorio, tal que $s_i$ es independiente de $(u_{it},z_i,c_i)$ en todos los períodos temporales.

---

## Estimación en Presencia de Sesgo de Selección y Endogeneidad: FE-2SLS

Permitir correlación arbitraria entre $s_{it}$ y $c_i$ es lo que hace atractivo al modelo de efectos fijos en paneles no balanceados cuando se sospecha que la propensión a dejar el panel (attrition) o seleccionarse fuera del mismo (truncamiento incidental) está relacionado con la heterogeneidad no observada.

El Supuesto FE2SLS.1: sugiere contrastes simples de adición de variables para detectar sesgo de selección.

Como el Supuesto FE2SLS.1 (ii) implica que $u_{it}$ no está correlacionado con $s_{ir}$ para todo $t$ y $r$, se pueden adicionar funciones, que varíen en el tiempo, de los indicadores de selección y obtener tests $t$ o de Wald.

En el espíritu de Nijman y Verbeek (1992), se pueden adicionar $s_{i,t-1}$ o $s_{i,t+1}$ a (18) y contrastar por su significancia estadística.

---

# Contraste por Sesgo de Selección bajo Truncamiento Incidental

El objetivo es contrastar si existe sesgo de selección en la ecuación de interés (i.e. si existe correlación entre el mecanismo de selección y el error idiosincrático).

Cambiando solo un poco la notación anterior considere la siguiente ecuación de interés:

$$
y_{it1}=x_{it}\beta_1+c_{i1}+u_{it1},\quad t=1,\ldots,T
\tag{21}
$$

donde $x_{it}$ es un vector $1\times K$ que contiene variables exógenas y endógenas, $\beta_1$ es un vector $K\times 1$ de parámetros y $c_{i1}$ es la heterogeneidad no observada y $u_{it1}$ es el error idiosincrático.

Adicionalmente, asumimos que existe un vector $L\times 1$ de instrumentos $(L\geq K)$, $z_{it}$, estrictamente exógenos, condicional en $c_i$.

---

## Contraste por Sesgo de Selección bajo Truncamiento Incidental

Asumimos que las variables instrumentales $z_{it}$ siempre se observan mientras que $(y_{it1},x_{it1})$ solo se observan si el indicador de selección, ahora llamado $s_{it2}$, vale uno.

Definamos la variable latente $s^*_{it2}$,

$$
s^*_{it2}=z_{it}\delta_2+c_{i2}+u_{it2},\quad t=1,\ldots,T
\tag{22}
$$

donde $c_{i2}$ es la heterogeneidad no observada y $u_{it2}$ es un error idiosincrático.

El mecanismo de selección $s_{it2}$ se genera como

$$
s_{it2}=1[s^*_{it2}>0]=1[z_{it}\delta_2+c_{i2}+u_{it2}>0],
\tag{23}
$$

con $1[\cdot]$ es la función indicadora.

Para derivar el test asumimos que

$$
u_{it2}\mid z_i,c_{i2}\sim Normal(0,1),\quad t=1,\ldots,T
\tag{24}
$$

tal que $s_{it2}$ sigue un modelo Probit de efectos fijos.

---

## Contraste por Sesgo de Selección bajo Truncamiento Incidental

Igual que en el caso de los modelos sin variables endógenas la heterogeneidad no observada se relaciona con las variables exógenas, $z_i$, usando el supuesto de Mundlak (1978),

$$
c_{i2}=\bar{z}_i\xi_2+a_{i2},
\tag{25}
$$

$$
a_{i2}\mid z_i\sim Normal(0,\tau_2^2),\quad t=1,\ldots,T
\tag{26}
$$

que asume que la correlación entre $c_{i2}$ y $z_i$ actúa solo a través de de las medias temporales de las variables exógenas mientras que la parte remanente del componente no observado, $a_{i2}$, es independiente de $z_i$.

Combinando las ecuaciones (22) a (26) el indicador de selección se puede escribir como,

$$
\begin{aligned}
s_{it2}
&=1[z_{it}\delta_2+\bar{z}_i\xi_2+a_{i2}+u_{it2}
=z_{it}\delta_2+\bar{z}_i\xi_2+v_{it2}>0],\\
v_{it2}\mid z_i&\sim Normal(0,1+\tau_2^2),\quad t=1,\ldots,T.
\end{aligned}
\tag{27}
$$

---

## Contraste por Sesgo de Selección bajo Truncamiento Incidental

El modelo de la ecuación (27) es más restrictivo de lo necesario. Uno puede permitir que los coeficientes del modelo de selección varíen en el tiempo,

$$
\begin{aligned}
s_{it2}&=1[z_{it}\delta_2+\bar{z}_i\xi_{2t}+a_{i2}+u_{it2}
=z_{it}\delta_2+\bar{z}_i\xi_{2t}+v_{it2}>0],\\
v_{it2}\mid z_i&\sim Normal(0,1),\quad t=1,\ldots,T.
\end{aligned}
\tag{28}
$$

**Supuesto FE2SLS.2:** $(u_{it1},v_{i2})$ es independiente de $(z_i,c_{i1})$ y $(u_{it1},v_{it2})$ es independiente de $(v_{i1,2},\ldots,v_{i,t-1,2},v_{i,t+1,2},\ldots,v_{i,T,2})$. Entonces, si $E(u_{it1}\mid v_{it2})$ es lineal,

$$
E(u_{it1}\mid z_i,c_{i1},v_{i2})=E(u_{it1}\mid v_{i2})=E(u_{it1}\mid v_{it2})=\rho_1 v_{it2},\quad t=1,\ldots,T
\tag{29}
$$

donde, por ahora $\rho_1$ es constante en el tiempo.

Bajo el supuesto anterior:

$$
E(u_{it1}\mid z_i,c_{i1},s_{i2})=\rho_1E(v_{it2}\mid z_i,c_{i1},s_{i2})=\rho_1E(v_{it2}\mid z_i,s_{it2}),\quad t=1,\ldots,T
\tag{30}
$$

---

## Contraste por Sesgo de Selección bajo Truncamiento Incidental

Tomando esperanzas condicionales en la ecuación de interes (21) tenemos,

$$
\begin{aligned}
E(y_{it1}\mid z_i,c_{i1},s_{i2})
&=x_{it}\beta_1+c_{i1}+E(u_{it1}\mid z_i,c_{i1},s_{i2})\\
&=x_{it}\beta_1+c_{i1}+\rho_1E(v_{it2}\mid z_i,s_{it2})\quad\Longrightarrow
\end{aligned}
$$

$$
y_{it1}=x_{it}\beta_1+c_{i1}+\rho_1E(v_{it2}\mid z_i,s_{it2})+e_{it1},\quad t=1,\ldots,T
\tag{31}
$$


donde por construcción $E(e_{it1}\mid z_i,c_{i1},s_{i2})=0$, $t=1,\ldots,T$.

Si conociéramos $E(v_{it2}\mid z_i,s_{it2})$, se podría contrastar por sesgo de selección contrastando $H_0:\rho_1=0$ en (31) usando la estimación de FE-2SLS.

Como solo estaríamos utilizando las observaciones para las que $s_{it2}=1$ solo necesitamos conocer $E(v_{it2}\mid z_i,s_{it2}=1)$.

---

## Contraste por Sesgo de Selección bajo Truncamiento Incidental

Utilizando el teorema 20.4 de Greene para los momentos de una normal bivariante truncada obtenemos el cálculo Probit usual,

$$
E(v_{it2}\mid z_i,s_{it2}=1)=\lambda(z_{it}\delta_{t2}+\bar{z}_i\xi_{t2}),\quad t=1,\ldots,T
\tag{32}
$$

donde $\lambda(\cdot)$ denota la inversa del cociente de Mills.

Este desarrollo sugiere el siguiente procedimiento para contrastar por sesgo de selección muestral:

1. Para cada período temporal estime un modelo Probit para la ecuación:

$$
Pr(s_{it2}\mid z_i)=\Phi(z_{it}\delta_{t2}+\bar{z}_i\xi_{t2}),\quad t=1,\ldots,T.
\tag{33}
$$

Usando los resultados de la estimación construya la inversa de los cocientes de Mills: $\hat\lambda_{it2}\equiv\lambda(z_{it}\hat\delta_{t2}+\bar{z}_i\hat\xi_{t2})$.

2. Para la muestra observada, estime (31) usando FE-2SLS, reemplazando $E(v_{it2}\mid z_i,s_{it2})$ por $\hat\lambda_{it2}$.

---

## Contraste por Sesgo de Selección bajo Truncamiento Incidental

3. Use un estadístico $t$, robusto ante la presencia de heterocedasticidad y correlación serial, para contrastar la hipótesis nula: $H_0:\rho_1=0$.

Si la hipótesis nula no se rechaza, no hay problemas de selección muestral y el estimador de FE-2SLS es consistente.

**Remark 1:** Note que en el paso 2. además de $\hat\lambda_{it2}$ se pueden agregar interacciones de la inversa del cociente de Mills con variables binarias temporales para permitir correlaciones diferentes entre los errores idiosincráticos $u_{it1}$ y $v_{it2}$ (i.e. un $\rho_1$ diferente en cada $t$).

Si se incluyen esta interacciones el contraste por sesgo de selección se realiza por un test de Wald que chequea que todos los coeficientes de las interacciones son en conjunto iguales a cero.

---

# Corrección del Sesgo de Selección bajo Truncamiento Incidental

Si el contraste anterior rechaza la hipótesis nula de ausencia de sesgo de selección, entonces se requiere un procedimiento de corrección.

El procedimiento utilizado para el contraste no funciona para corregir por sesgo de selección.

El principal problema es la heterogeneidad no observada que aparece en el indicador de selección ($c_{i2}$). Esto provoca que los errores del mecanismo de selección estén serialmente correlacionados provocando que $E(v_{it2}\mid z_i,s_{i2})$ tenga una expresión muy complicada.

Usando el mecanismo de Chamberlain (1980) o el de Mundlak (1978) se puede asumir linealidad en la esperanza condicional de $c_{i1}$ y obtener una corrección de sesgo de selección válida.

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

Específicamente,

$$
c_{i1}=\bar{z}_i\xi_1+a_{i1},
$$

$$
E(a_{i1}\mid z_i)=0
\tag{34}
$$

Reemplazando (34) en la ecuación de interés tenemos,

$$
y_{it1}=x_{it}\beta_1+\bar{z}_i\xi_1+a_{i1}+u_{it1}=x_{it}\beta_1+\bar{z}_i\xi_1+v_{it1},\quad t=1,\ldots,T
\tag{35}
$$

con $v_{it1}\equiv a_{i1}+u_{it1}$ independiente en media de $z_i$.

Ahora, introduciendo selección correlacionada con heterogeneidad no observada y con el error idiosincrático de la ecuación de interés podemos escribir el modelo tomando esperanzas condicionales en la ecuación de interés:

$$
y_{it1}=x_{it}\beta_1+\bar{z}_i\xi_1+E(v_{it1}\mid z_i,s_{it2})+e_{it1}
$$

$$
E(e_{it1}\mid z_i,s_{it2})=0,\quad t=1,\ldots,T
\tag{36}
$$

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

Si conociéramos $E(v_{it1}\mid z_i,s_{it2})$ en la ecuación anterior, la consistencia del estimador de Pooled 2SLS estaría garantizada por el Supuesto P2SLS.1.

Recuerde que lo único que requiere el Supuesto P2SLS.1 es que $e_{it1}$ sea independiente en media (condicionalmente) de $z_{it}$ y el mecanismo de selección en $t$.

**Supuesto P2SLS.2:** (i) las variables instrumentales $z_{it}$ siempre se observan mientras que $(y_{it1},x_{it1})$ solo se observan si $s_{it2}=1$; (ii) el mecanismo de selección está dado por (28); (iii) $c_{i1}$ satisface (34); (iv)

$$
E(v_{it1}\mid z_i,v_{it2})\equiv E(a_{i1}+u_{it1}\mid z_i,v_{it2})=E(a_{i1}+u_{it1}\mid v_{it2})=\gamma_{t1}v_{it2},\quad t=1,\ldots,T.
$$

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

Usando (iii) y (iv) tenemos,

$$
y_{it1}=x_{it}\beta_1+\bar{z}_i\xi_1+\gamma_{t1}E(v_{it2}\mid z_i,s_{it2})+e_{it1}
$$

$$
E(e_{it1}\mid z_i,s_{it2})=0,\quad t=1,\ldots,T.
\tag{37}
$$

Escribiendo el modelo para la muestra que observamos queda,

$$
y_{it1}\mid (s_{it2}=1)=x_{it}\beta_1+\bar{z}_i\xi_1+\gamma_{t1}\lambda_{it2}+e_{it1},\quad t=1,\ldots,T.
\tag{38}
$$

Esto significa que podemos estimar $\beta_1$, $\xi_1$ y $(\gamma_{11},\gamma_{21},\ldots,\gamma_{T1})$ usando Pooled 2SLS una vez que reemplazamos $\lambda_{it2}$ con $\hat\lambda_{it2}$.

Podemos resumir la corrección del sesgo de selección en presencia de variables endógenas con el siguiente procedimiento.

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

1. Para cada período temporal estime un modelo Probit para $s_{it2}$ sobre $1$, $z_{it}$, $\bar{z}_i$, $i=1,\ldots,N$, y obtenga la inversa de los cocientes de Mills, $\hat\lambda_{it2}$.

2. Para la muestra de datos observados, estime la ecuación (38) con $\lambda_{it2}$ reemplazada por $\hat\lambda_{it2}$ por Pooled 2SLS usando $1$, $z_{it}$, $\bar{z}_i$, $\hat\lambda_{it2}$ como instrumentos. Note que (38) implica diferentes coeficientes para $\lambda_{it2}$ en cada período temporal. Como antes, esto puede implementarse adicionando los términos de interacción apropiados en la regresión. Alternativamente, se puede estimar un modelo más restrictivo asumiendo $\gamma_{t1}=\gamma_1$, $\forall t$.

Para realizar inferencia estadística en el modelo necesitamos estimar la matriz de varianzas y covarianzas de los estimadores del paso 2. de arriba.

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

Definamos los regresores generados y los instrumentos para el período $t$ como:

$$
\hat{w}_{it}=(x_{it},\bar{z}_i,0,\ldots,0,\hat\lambda_{it2},0,\ldots,0)
$$

and

$$
\hat{h}_{it}=(z_{it},\bar{z}_i,0,\ldots,0,\hat\lambda_{it2},0,\ldots,0),
$$

respectivamente. Sin el “$\hat{}$” estos vectores están evaluados en los parámetros poblacionales.

El vector de parámetros de la ecuación de interés es:

$$
\theta=(\beta'_1,\xi'_1,\gamma'_{11},\ldots,\gamma'_{T1})'.
$$

El vector de parámetros de la ecuación de selección es:

$$
\pi_t=(\delta'_{t2},\xi'_{t2})',\quad \text{y}\quad \pi=(\pi'_1,\pi'_2,\ldots,\pi'_T)'.
$$

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

El estimador de Pooled 2SLS es,

$$
\begin{aligned}
\hat\theta
=&\left[\left(\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{w}'_{it}\hat{h}_{it}\right)
\left(\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}\hat{h}_{it}\right)^{-1}
\left(\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}\hat{w}_{it}\right)\right]^{-1}\\
&\times\left(\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{w}'_{it}\hat{h}_{it}\right)
\left(\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}\hat{h}_{it}\right)^{-1}
\left(\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}y_{it1}\right).
\end{aligned}
\tag{39}
$$

Sustituyendo $y_{it1}=w_{it}\theta+e_{it1}=\hat{w}_{it}\theta+(w_{it}-\hat{w}_{it})\theta+e_{it1}$ en (39) tenemos,

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

$$
\begin{aligned}
\sqrt{N}(\hat\theta-\theta)
=&\left[\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{w}'_{it}\hat{h}_{it}\right)
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}\hat{h}_{it}\right)^{-1}
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}\hat{w}_{it}\right)\right]^{-1}\\
&\times\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{w}'_{it}\hat{h}_{it}\right)
\left(N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}\hat{h}_{it}\right)^{-1}\\
&\times\left(N^{-1/2}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}\left[(w_{it}-\hat{w}_{it})\theta+e_{it1}\right]\right)\\
=&\ (C'D^{-1}C)^{-1}C'D^{-1}
\left(N^{-1/2}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}\left[(w_{it}-\hat{w}_{it})\theta+e_{it1}\right]\right)+o_p(1).
\end{aligned}
\tag{40}
$$

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

En la expresión anterior $C\equiv E\left(\sum_{t=1}^T s_{it2}h'_{it}w_{it}\right)$ y $D\equiv E\left(\sum_{t=1}^T s_{it2}h'_{it}h_{it}\right)$.

Usando Wooldridge (2002) y $E(e_{it1}\mid h_{it},s_{it2})=0$,

$$
\left(N^{-1/2}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}[(w_{it}-\hat{w}_{it})\theta+e_{it1}]\right)
=N^{-1/2}\sum_{i=1}^N\left[\sum_{t=1}^T s_{it2}h'_{it}e_{it1}-F\psi_i(\pi)\right]+o_p(1)
\tag{41}
$$


donde

$$
F=E\left[\sum_{t=1}^T s_{it2}h'_{it}(\theta'\nabla_\pi w'_{it})\right],
$$

$\nabla_\pi w'_{it}$ es el Jacobiano de $w'_{it}$ con respecto a $\pi$ y $\psi_i(\pi)$ depende de la esperanza matemática de Hesianos y funciones score de la estimación del Probit del primer paso.

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

Combinando (41) con (40) tenemos,

$$
\sqrt{N}(\hat\theta-\theta)
=(C'D^{-1}C)^{-1}C'D^{-1}
\left(N^{-1/2}\sum_{i=1}^N\left[\sum_{t=1}^T s_{it2}h'_{it}e_{it1}-F\psi_i(\pi)\right]\right)+o_p(1).
\tag{42}
$$

Entonces,

$$
\sqrt{N}(\hat\theta-\theta)\xrightarrow{d}
Normal\left[0,(C'D^{-1}C)^{-1}C'D^{-1}GD^{-1}C(C'D^{-1}C)^{-1}\right]
\tag{43}
$$


donde

$$
G=Var\left(\sum_{t=1}^T s_{it2}h'_{it}e_{it1}-F\psi_i(\pi)\right)\equiv Var[g_i(\theta,\pi)].
$$

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

La estimación consistente de $Avar[\sqrt{N}(\hat\theta-\theta)]$ se obtiene reemplazando los parámetros desconocidos por sus estimadores consistentes.

Estimadores consistentes de $C$, $D$, y $G$ viene dados por:

$$
\hat{C}\equiv N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}\hat{w}_{it}
\tag{44}
$$

$$
\hat{D}=N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}\hat{h}_{it}
\tag{45}
$$

$$
\hat{G}=N^{-1}\sum_{i=1}^N\sum_{t=1}^T \hat{g}_i\hat{g}'_i
\tag{46}
$$


donde

$$
\hat{g}_i=\sum_{t=1}^T s_{it2}\hat{h}'_{it}\hat{e}_{it1}-\hat{F}\hat{\psi}_i,
$$

$$
\hat{e}_{it1}=y_{it1}-\hat{w}_{it}\hat\theta,
$$

y

$$
\hat{F}=N^{-1}\sum_{i=1}^N\sum_{t=1}^T s_{it2}\hat{h}'_{it}(\hat\theta'\nabla_\pi \hat{w}'_{it}).
$$

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

En la expresión anterior para cada $(i,t)$,

$$
\hat\theta'\nabla_\pi \hat{w}'_{it}=
(0,\ldots,0,-\hat\gamma_{t1}q_{it}\hat\lambda_{it2}(q_{it}\hat\pi_t+\hat\lambda_{it2}),0,\ldots,0,)
$$

con $q_{it}\equiv (z_{it},\bar{z}_i)$ y donde $\lambda_{it2}(q_{it}\pi_t+\lambda_{it2})$ es la derivada de la inversa del cociente de Mills.

Con estos resultados tenemos,

$$
\hat{F}=-N^{-1}\sum_{i=1}^N\sum_{t=1}^T
[0,\ldots,0,s_{it2}\hat{h}'_{it}\hat\gamma_{t1}q_{it}\hat\lambda_{it2}(q_{it}\hat\pi_t+\hat\lambda_{it2}),0,\ldots,0,]
\tag{47}
$$

Desde los resultados de la estimación del Probit de la primera etapa, para cada $(i,t)$, tenemos,

$$
\hat\psi_{it}=\hat{H}^{-1}_t\{\Phi(q_{it}\hat\pi_t)[1-\Phi(q_{it}\hat\pi_t)]\}^{-1}\phi(q_{it}\hat\pi_t)q'_{it}[s_{it2}-\Phi(q_{it}\hat\pi_t)]
\tag{48}
$$

---

## Corrección del Sesgo de Selección bajo Truncamiento Incidental

En la expresión anterior

$$
\hat{H}^{-1}_t=N^{-1}\sum_{i=1}^N \{\Phi(q_{it}\hat\pi_t)[1-\Phi(q_{it}\hat\pi_t)]\}^{-1}
[\phi(q_{it}\hat\pi_t)]^2 q'_{it}q_{it}
\tag{49}
$$

es la estimación consistente de la esperanza del Hesiano y $\hat\pi_t$ es estimador de máxima verosimilitud del modelo Probit de $s_{it2}$ contra $q_{it}$, $i=1,\ldots,N$.

Para cada $i$ hay que “apilar” los $\hat\psi_{it}$ para obtener el $\hat\psi_i$ que se usa en la ecuación (46).
