# Clase 2 — transcripción de notas manuscritas

Fuente: `Clase 2.pdf`.

Notas de transcripción:

- Transcripción manual/OCR visual desde 5 páginas renderizadas. La página 5 está en blanco.
- Mantengo la notación original cuando es legible, incluyendo decimales con coma: `0{,}2`, `0{,}25`.
- Marco con `(?)` lecturas dudosas del manuscrito.
- En algunos lugares normalizo por contexto econométrico: por ejemplo, `MCO` para OLS y `VCE` para variance-covariance estimator.

---

## Página 1

# PS 0 — EJ 3

Modelo:

$$
y_i = \beta_1 + \beta_2 x_{2i} + \beta_3 x_{3i} + u_i, \qquad i = 1,\ldots,N
$$

$$
u_i = \sqrt{\exp(-1 + 0{,}2x_{2i})}\,\varepsilon_i
$$

$$
\beta_1 = 1 = \beta_2 = \beta_3
$$

$$
x_2 \sim N(0,0{,}25), \qquad x_3 \sim N(0,0{,}25), \qquad \varepsilon \sim N(0,0{,}25)
$$

Tengo un modelo heterocedástico $\Rightarrow$ la idea es ver que necesito estimadores robustos.

$$
u \not\sim iid \quad (\text{depende de }x_2)
$$

> Hace que dependa de la observación en la que estás.

¿Cómo saber que la varianza de $u_i$ es

$$
\operatorname{Var}(u_i) = 0{,}25\exp(-1+0{,}2x_{2i})?
$$

Partimos de:

$$
\operatorname{Var}(u_i\mid x_i)
= E(u_i^2\mid x_i) - \underbrace{E(u_i\mid x_i)^2}_{=0}
$$

Entonces:

$$
\begin{aligned}
\operatorname{Var}(u_i\mid x_i)
&= E\left[\left(\sqrt{\exp(-1+0{,}2x_{2i})}\,\varepsilon_i\right)^2 \mid x_i\right] \\
&= \exp(-1+0{,}2x_{2i})E(\varepsilon_i^2\mid x_i)
\end{aligned}
$$

Como

$$
E(\varepsilon_i^2\mid x_i)=\operatorname{Var}(\varepsilon_i)=0{,}25,
$$

queda:

$$
\operatorname{Var}(u_i\mid x_i)=\exp(-1+0{,}2x_{2i})\cdot 0{,}25.
$$

### ¿Cómo va a ser la matriz de VCV?

$$
V =
\begin{bmatrix}
0{,}25\exp(-1+0{,}2x_{21}) & & \\
& 0{,}25\exp(-1+0{,}2x_{22}) & \\
& & \ddots
\end{bmatrix}
$$

Puedo sacar el $0{,}25$ como factor común fuera de la matriz y armo la matriz $\Omega$.

Conozco la forma de la heterocedasticidad. Esto me va a servir para GLS, donde:

$$
\tilde\beta = (X'\Omega^{-1}X)^{-1}X'\Omega^{-1}y
$$

Necesito $\Omega^{-1}$ $\Rightarrow$ inversos de los elementos de la diagonal.

### FGLS

Si no puedo asegurar que esa sea la forma de la heterocedasticidad, construimos $\widehat\Omega$ con los residuos:

$$
\widehat u_i = y_i - \widehat\beta_1 - \widehat\beta_2x_{2i} - \widehat\beta_3x_{3i}
$$

Después elevo al cuadrado.

> Les dejo el repaso para construir $\widehat\Omega$ de Metrics (`metrics2`, slide 69?).

---

## Página 2

### Recorte de slide: heterocedasticidad — procedimiento de White

Suponga el siguiente modelo estructural:

$$
y_i = \alpha_0 + \alpha_1x_{i,1} + \alpha_2x_{i,2} + u_i \tag{45}
$$

Entonces, la forma funcional de la heterocedasticidad de White es:

$$
\sigma_i^2
= \gamma_0 + \gamma_1x_{i,1} + \gamma_2x_{i,2}
+ \gamma_3x_{i,1}^2 + \gamma_4x_{i,2}^2
+ \gamma_5x_{i,1}x_{i,2}
\tag{46}
$$

#### FGLS White

1. Estimar (45) por OLS y obtener las estimaciones de los parámetros del modelo.
2. Calcular los residuos del modelo y elevarlos al cuadrado, $\widehat u_i^2$.
3. Estimar (46) por OLS usando $\widehat u_i^2$ como proxy de $\sigma_i^2$.
4. Usar las estimaciones de la regresión auxiliar y obtener las varianzas ajustadas como:

$$
\widehat\sigma_i^2
= \widehat\theta_i^2
= \widehat\gamma_0 + \widehat\gamma_1x_{i,1} + \widehat\gamma_2x_{i,2}
+ \widehat\gamma_3x_{i,1}^2 + \widehat\gamma_4x_{i,2}^2
+ \widehat\gamma_5x_{i,1}x_{i,2}
$$

Acá conjeturamos que el error solo se relaciona con $x_2$, entonces no tenemos que hacer todo el método completo de White sino usar la información que tenemos.

Queremos ver que son equivalentes FGLS y GLS; por eso tenemos que usar la misma forma de la varianza.

---

# PS 1 — EJ 1

Tenemos un panel $\Rightarrow$ vamos a correr POLS sobre tasa de crecimiento. Va a tener problemas de autocorrelación probablemente $\Rightarrow$ chequeamos y también chequeamos heterocedasticidad.

POLS $\Rightarrow$ MCO sobre un modelo de panel:

$$
y_{it} = x_{it}\beta + \lambda_t + u_{it}
$$

> Agregamos dummies temporales.

No vienen en la base, pero vamos a ver cómo crearlas.

No asumimos ninguna estructura del $c_i$ (?) —los $e_i$ de los slides.

Recuerden que los coeficientes en un modelo log-log $\Rightarrow$ elasticidad.

Problema de correlación $\neq$ causalidad: condados con más historia criminal van a tener ratio de police P-C más alto (?) y otros factores.

> Acá hay indicios de efectos en el corte transversal.

Si no consideramos esta potencial autocorrelación, tenemos el problema de que POLS es inconsistente.

Una forma de hacerlo robusto a la heterocedasticidad es con clusters:

- los estimadores $\widehat\beta$ son iguales;
- cambian los errores estándar;
- ahora son t-ratios;
- o sea que antes estaba teniendo conclusiones erróneas —inferencia errónea.

---

## Página 3

VCE $\Rightarrow$ variance-covariance estimator. Le decimos cómo estimar $V$.

Cuando la opción es cluster, le “aviso” a Stata que hay correlación adentro del $i$ —en este caso, conducida en el tiempo—, es decir, que pierdo independencia de las observaciones en el grupo/cluster.

Entre clusters sí son independientes.

### c) Contraste de correlación serial

Quiero ver si es un AR(1):

$$
u_{jt} = \alpha u_{j,t-1} + \varepsilon_{jt}
$$

con:

$$
E(\varepsilon_{jt}\mid X_{jt}, u_{j,t+1},\ldots)=0
$$

Pasos para chequear esto:

1. Correr el modelo por POLS y obtener $\widehat u$.
2. Estimar por OLS el modelo AR(1) de esta forma:

$$
\widehat u_{jt}
= \alpha\widehat u_{j,t-1} + \beta X_{jt} + \varepsilon_{jt}
$$

3. Construyo el estadístico y me fijo si puedo o no rechazar $H_0$.

> Residuos y $X$ no deberían estar relacionados, son ortogonales por definición. Si son estadísticamente significativos, hay un problema.

Hipótesis nula:

$$
H_0: \text{todo está bien, no hay correlación serial} \Rightarrow \alpha = 0.
$$

Si rechazo $H_0$, tengo que hacer alguna corrección.

### d) Test de heterocedasticidad

Pasos —salen de slides, solo para repasar:

1. Estimar el modelo por POLS, obtener $\widehat u_{jt}$ y $\widehat u_{jt}^2$.
2. Estimar por POLS $\widehat u_{jt}^2$ sobre una constante y $h_{jt}$ de $1\times Q$, funciones no constantes.

   > Paralelismo con White de Metrics.

3. Obtener el $R^2$ y con él construir:

$$
LM = N\times T\times R^2 \sim \chi_Q^2
$$

Ver si puedo o no rechazar $H_0$.

Hipótesis nula:

$$
H_0: \text{está todo bien; homocedasticidad.}
$$

Si no puedo rechazar $H_0$, POLS es lo más eficiente y no tengo que hacer nada adicional.

### e) Estimador Prais-Winsten

Inconsistente si no vale exogeneidad estricta. Es para errores con proceso AR(1):

$$
u_{it} = \rho u_{i,t-1} + \varepsilon_{it}
$$

Matriz de VCV —lo vieron en Series de Tiempo; también la calcularon en Metrics:

$$
\Omega
= \sigma_u^2
\begin{bmatrix}
1 & \rho & \rho^2 \\
\rho & 1 & \rho \\
\rho^2 & \rho & 1
\end{bmatrix}
$$

---

## Página 4

PW descompone esta matriz siguiendo la descomposición de Cholesky:

$$
\Omega = PP'
$$

- Toma la primera observación —no tiene lag— y la transforma diferente.
- Si a PW le añadimos Cochrane-Orcutt directamente, perdemos nuestra primera observación.
  - Esto no es un problema en grandes muestras.
- Al tener diferentes observaciones, los estadísticos serán distintos comparados con POLS.

### Recorte: descripción de Prais-Winsten

> Prais uses the generalized least-squares method to estimate the parameters in a linear regression model in which the errors are serially correlated. Specifically, the errors are assumed to follow a first-order autoregressive process.

### Textual de Wooldridge

#### 12-3b Feasible GLS Estimation with AR(1) Errors

The problem with the GLS estimator is that $\rho$ is rarely known in practice. However, we already know how to get a consistent estimator of $\rho$: we simply regress the OLS residuals on their lagged counterparts, exactly as in equation (12.14). Next, we use this estimate, $\widehat\rho$, in place of $\rho$ to obtain the quasi-differenced variables. We then use OLS on the equation

$$
\widetilde y_t
= \beta_0\widetilde x_{t0} + \beta_1\widetilde x_{t1} + \cdots + \beta_k\widetilde x_{tk} + error_t
\tag{12.33}
$$

where $\widetilde x_{t0}=(1-\widehat\rho)$ for $t\geq 2$, and $\widetilde x_{10}=(1-\widehat\rho^2)^{1/2}$. This results in the feasible GLS (FGLS) estimator of the $\beta_j$. The error term in (12.33) contains $e_t$ and also the terms involving the estimation error in $\widehat\rho$. Fortunately, the estimation error in $\widehat\rho$ does not affect the asymptotic distribution of the FGLS estimators.

#### Feasible GLS Estimation of the AR(1) Model

1. Run the OLS regression of $y_t$ on $x_{t1},\ldots,x_{tk}$ and obtain the OLS residuals, $\widehat u_t$, $t=1,2,\ldots,n$.
2. Run the regression in equation (12.14) and obtain $\widehat\rho$.

   > Nota manuscrita: regresión de $\widehat u_t$ sobre $\widehat u_{t-1}$.

3. Apply OLS to equation (12.33) to estimate $\beta_0,\beta_1,\ldots,\beta_k$. The usual standard errors, $t$ statistics, and $F$ statistics are asymptotically valid.

The cost of using $\widehat\rho$ in place of $\rho$ is that the FGLS estimator has no tractable finite sample properties. In particular, it is not unbiased, although it is consistent when the data are weakly dependent. Further, even if $e_t$ in (12.32) is normally distributed, the $t$ and $F$ statistics are only approximately $t$ and $F$ distributed because of the estimation error in $\widehat\rho$. This is fine for most purposes, although we must be careful with small sample sizes.

Since the FGLS estimator is not unbiased, we certainly cannot say it is BLUE. Nevertheless, it is asymptotically more efficient than the OLS estimator when the AR(1) model for serial correlation holds —and the explanatory variables are strictly exogenous. Again, this statement assumes that the time series are weakly dependent.

There are several names for FGLS estimation of the AR(1) model that come from different methods of estimating $\rho$ and different treatment of the first observation. Cochrane-Orcutt (CO) estimation omits the first observation and uses $\widehat\rho$ from (12.14), whereas Prais-Winsten (PW) estimation uses the first observation in the previously suggested way. Asymptotically, it makes no difference whether or not the first observation is used, but many time series samples are small, so the differences can be notable in applications.

In practice, both the Cochrane-Orcutt and Prais-Winsten methods are used in an iterative scheme. That is, once the FGLS estimator is found using $\widehat\rho$ from (12.14), we can compute a new set of residuals, obtain a new estimator of $\rho$ from (12.14), transform the data using the new estimate of $\rho$, and ...

> El recorte queda cortado al final de la página.

---

## Página 5

Página en blanco.

---

# Chequeo contra el mapa de prácticas 2023

Mapa 2023 relevante:

- P01 $\rightarrow$ PS0: ex1, ex2, ex3 parcialmente/apurado.
- P02 $\rightarrow$ PS1: ex1, ex2, ex3.

Diagnóstico para estas notas 2026:

| Set 2026 | Contenido detectado | Match 2023 probable | Diagnóstico |
|---|---|---|---|
| Clase 2, p. 1 | PS0 Ej. 3: heterocedasticidad conocida, GLS/FGLS, matriz $\Omega$, residuos para $\widehat\Omega$ | Cola de P01 | Coincide con que PS0 ex3 quedó parcial/apurado en P01 2023. En 2026 parece retomarse al inicio de la clase 2. |
| Clase 2, pp. 2-4 | PS1 Ej. 1: POLS en panel, dummies temporales, VCE/cluster, autocorrelación serial, test de heterocedasticidad, Prais-Winsten/Cochrane-Orcutt | Inicio de P02 | Coincide con P02 2023 empezando PS1. |
| Clase 2 | No aparece evidencia clara de PS1 Ej. 2 o Ej. 3 en estas notas | P02 incompleto respecto al mapa 2023 | Puede ser que las notas no cubran todo lo visto o que 2026 haya ido más lento en esta clase. |

Conclusión: la paridad general 2026-2023 sigue teniendo sentido, pero con una precisión importante: **Clase 2 de 2026 parece mezclar cierre de PS0 Ej. 3 + arranque de PS1 Ej. 1**. Por ahora no reorganizaría el mapa completo; solo anotaría que el corte entre P01/P02 es poroso.

