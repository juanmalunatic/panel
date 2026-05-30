# Truncamiento Incidental

Suponga que $y$ y $z$ tienen una distribución bivariada con correlación $\rho$.
Nosotros estamos interesados en la distribución de $y$ dado que $z$ excede un determinado valor. Esto es, la función de densidad conjunta de $y$ y $z$ es:

$$
f(y,z \mid z>a)=\frac{f(y,z)}{\operatorname{Prob}(z>a)}
$$

**Teorema 20.4 (Greene, 1997, Cap. 20, p. 975):** Si $y$ y $z$ tienen una distribución normal bivariada com medias $\mu_y$ y $\mu_z$, desviaciones estándar $\sigma_y$ y $\sigma_z$ y correlación $\rho$, entonces:

$$
E(y \mid z>a)=\mu_y+\rho\sigma_y\lambda(\alpha_z),
\qquad
\operatorname{Var}(y \mid z>a)=\sigma_y^2[1-\rho^2\delta(\alpha_z)],
$$

donde:

$$
\alpha_z=\frac{a-\mu_z}{\sigma_z},
\qquad
\lambda(\alpha_z)=\frac{\phi(\alpha_z)}{1-\Phi(\alpha_z)},
\qquad
\delta(\alpha_z)=\lambda(\alpha_z)[\lambda(\alpha_z)-\alpha_z].
$$

---

# Truncamiento Incidental

En economía el caso emblemático es el modelo de oferta de trabajo de las mujeres (Gronau, 1974; Heckman, 1976). Este modelo consiste de dos ecuaciones, una ecuación de salarios que representa la diferencia entre el salario de mercado de una persona y su salario de reserva, en función de características tales como la edad, educación, experiencia etc.

La segunda ecuación es una ecuación de horas deseadas de trabajo que depende del salario, de la presencia de hijos pequeños, del estado civil, etc.

El problema del truncamiento es que en la segunda ecuación observamos las horas reales solo si la persona está trabajando. Esto es, solo si el salario de mercado excede al salario de reserva. En este caso se dice que la variable horas en la segunda ecuación está incidentalmente truncada.

---

# Truncamiento Incidental

Para poner este ejemplo en un marco general de análisis, digamos que la ecuación que determina la selección muestral es:

$$
z_i^* = \gamma' w_i + u_i,
$$

y la ecuación de interés es:

$$
y_i = \beta' x_i + \varepsilon_i
$$

La regla es que $y_i$ es observada solo cuando $z_i^*$ es mayor a cero. Asumamos que $u_i$ y $\varepsilon_i$ tienen distribución normal bivariada con medias iguales a cero y coeficiente de correlación $\rho$.

---

# Truncamiento Incidental

Aplicando teorema 20.4:

$$
(y_i \mid y_i \text{ es observada}) = E[y_i \mid z_i^*>0] \tag{50}
$$

$$
= E[y_i \mid u_i > -\gamma' w_i] \tag{51}
$$

$$
= \beta' x_i + E[\varepsilon_i \mid u_i > -\gamma' w_i] \tag{52}
$$

$$
= \beta' x_i + \rho\sigma_\varepsilon\lambda_i(\alpha_u) \tag{53}
$$

$$
= \beta' x_i + \beta_\lambda\lambda_i(\alpha_u), \tag{54}
$$

donde $\alpha_u=-\gamma'w_i/\sigma_u$ y $\lambda_i(\alpha_u)=\phi(\gamma'w_i/\sigma_u)/\Phi(\gamma'w_i/\sigma_u)$.

---

# Truncamiento Incidental

Por lo tanto:

$$
y_i \mid z_i^*>0 = E[y_i \mid z_i^*>0]+v_i
=\beta'x_i+\beta_\lambda\lambda_i(\alpha_u)+v_i
$$

Está claro de este desarrollo que estimar por OLS la ecuación de horas trabajadas, solo con los datos observados, produce estimadores inconsistentes de $\beta$ por el argumento estándar de variables omitidas.

---

# Truncamiento Incidental

Heckman (1979) diseñó un método de estimación en dos etapas.

1. Estime una ecuación probit para obtener estimaciones de $\gamma$. Para cada observación en la muestra seleccionada calcule:

$$
\hat{\lambda}_i=\frac{\phi(\hat{\gamma}'w_i)}{\Phi(\hat{\gamma}'w_i)}
$$

2. Estime por OLS $\beta$ y $\beta_\lambda$ en la regresión de $y$ sobre $x$ y $\hat{\lambda}$.

Contraste la hipótesis nula que el coeficiente asociado a $\hat{\lambda}$ es cero usando un estadístico $t$ de significación individual (completamente robusto). Si acepta la hipótesis nula, no hay evidencia de sesgo de selección. Por otro lado, si se rechaza la hipótesis nula entonces existe sesgo de selección.

La estimación del segundo paso de Heckman produce estimadores insesgados y consistentes de $\beta$.

Go Back

---

# Modelo Probit

Denotemos por $\phi(.)$ y por $\Phi(.)$ a las funciones de densidad y de distribución acumulada de una normal estándar.

La función de verosimilitud para el modelo Probit en cada $t$ es:

$$
L(\delta_t;X_j)=\prod_{j=1}^{N}[\Phi(X_j\delta_t)]^{Y_j}[1-\Phi(X_j\delta_t)]^{1-Y_j}
$$

Donde $Y_j$ es una variable binaria que adopta el valor 1 si $j$ está en la muestra seleccionada.

---

# Modelo Probit

Y su logaritmo natural es:

$$
\ell=\sum_{j=1}^{N}\{Y_j\log[\Phi(X_j\delta_t)]+(1-Y_j)\log[1-\Phi(X_j\delta_t)]\}
$$

Las condiciones de primer orden son:

$$
S(\hat{\delta}_t)=\frac{\partial \ell}{\partial \hat{\delta}_t}
=
\sum_{j=1}^{N}
\left(
\frac{Y_j-\Phi(X_j\hat{\delta}_t)}{\Phi(X_j\hat{\delta}_t)[1-\Phi(X_j\hat{\delta}_t)]}
\phi(X_j\hat{\delta}_t)
\right)X_j=0
$$

---

# Modelo Probit

La matriz de información de Fisher es:

$$
I(\hat{\delta}_t)=E\left(-\frac{\partial^2\ell}{\partial\hat{\delta}\partial\hat{\delta}_t}\right)
=
\sum_{j=1}^{N}
\left(
\frac{\phi(X_j\hat{\delta}_t)^2}{\Phi(X_j\hat{\delta}_t)[1-\Phi(X_j\hat{\delta}_t)]}
\right)X_jX'_j
$$

Por lo tanto:

$$
\hat{r}_{jt}=\left[I(\hat{\delta}_t)\right]^{-1}S(\hat{\delta}_t),
\qquad t=1,2,\ldots,T.
$$

Donde $\hat{\delta}_t$ es de dimensión $(1+TK)\times 1$; $[I(\hat{\delta}_t)]^{-1}$ es de dimensión $(1+TK)\times(1+TK)$; y $S(\hat{\delta}_t)$ es de dimensión $(1+TK)\times1$.

Construya el vector $\hat{r}_j$ de dimensión $T(1+TK)\times1$ “stacking” $\{\hat{r}_{j1},\hat{r}_{j2},\ldots,\hat{r}_{jT}\}$.

Go Back

---

# Modelo Tobit

El modelo Tobit se define como sigue: $y_i=\beta'x_i+u_i$ si $\beta'x_i+u_i>0$; e $y_i=0$ en cualquier otro caso.

$\beta$ es un vector $k\times1$ de parámetros, $x_i$ es un vector $k\times1$ de variables explicativas; y $u_i$ son los errores que son independientes y se distribuyen con distribución normal con media cero y varianza $\sigma^2$.

Supongamos que tenemos $N_0$ observaciones para las que $y_i=0$, y $N_1$ observaciones para las que $y_i>0$. Sin pérdida de generalidad asumamos que las $N_1$ observaciones no cero de $y_i$ están primero en la muestra.

Por conveniencia definamos:

$$
F_i=F(\beta'x_i,\sigma^2)=\int_{-\infty}^{\beta'x_i}\frac{1}{\sigma(2\pi)^{1/2}}e^{-t^2/2\sigma^2}\,dt
$$

$$
f_i=f(\beta'x_i,\sigma^2)=\frac{1}{\sigma(2\pi)^{1/2}}e^{-t^2/2\sigma^2}
$$

---

# Modelo Tobit

$$
\Phi_i=F_i=\int_{-\infty}^{\beta'x_i/\sigma}\frac{1}{(2\pi)^{1/2}}e^{-t^2/2}\,dt;
\qquad
\phi_i=\sigma f_i=\frac{1}{(2\pi)^{1/2}}e^{-(\beta'x_i)^2/2\sigma^2}
$$

Son las funciones acumulada y de densidad de la normal estándar evaluadas en $\beta'x_i/\sigma$.

Además,

$$
\gamma_i=\frac{\phi_i}{1-\Phi_i},
$$

$$
Y'_1=(y_i,y_2,\ldots,y_{N_1}),
$$

$$
X'_1=(x_1,x_2,\ldots,x_{N_1}),
$$

$$
X'_0=(x_{N_1+1},x_{N_1+2},\ldots,x_N)
\qquad \text{y} \qquad
\gamma'_0=(\gamma_{N_1+1},\gamma_{N_1+2},\ldots,\gamma_N).
$$

Para las observaciones $y_i=0$, lo único que sabemos es:

$$
\operatorname{Prob}(y_i=0)=\operatorname{Prob}(u_i<-\beta'x_i)=(1-F_i)
$$

Para las observaciones $y_i>0$, tenemos

$$
\operatorname{Prob}(y_i>0)f_i(y_i\mid y_i>0)
=F_i\frac{f(y_i-\beta'x_i,\sigma^2)}{F_i}
=\frac{1}{(2\pi\sigma^2)^{1/2}}e^{-(1/2\sigma^2)(y_i-\beta'x_i)^2}
$$

---

# Modelo Tobit

La función de verosimilitud es entonces,

$$
L=\prod_{\forall y_i=0}(1-F_i)\prod_{\forall y_i>0}\frac{1}{(2\pi\sigma^2)^{1/2}}e^{-(1/2\sigma^2)(y_i-\beta'x_i)^2}
$$

Tomando logaritmos:

$$
\log L=\sum_{\forall y_i=0}\log(1-F_i)
+\sum_{\forall y_i>0}\log\left(\frac{1}{(2\pi\sigma^2)^{1/2}}\right)
-
\sum_{\forall y_i>0}\frac{1}{2\sigma^2}(y_i-\beta'x_i)^2
$$

---

# Modelo Tobit

Usando las siguientes expresiones:

$$
\frac{\partial F_i}{\partial\beta}=f_ix_i
$$

$$
\frac{\partial F_i}{\partial\sigma^2}=-\frac{1}{2\sigma^2}\beta'x_i f_i
$$

$$
\frac{\partial f_i}{\partial\beta}=-\frac{1}{\sigma^2}\beta'x_i f_i x_i
$$

$$
\frac{\partial f_i}{\partial\sigma^2}=\frac{(\beta'x_i)^2-\sigma^2}{2\sigma^4}f_i
$$

---

# Modelo Tobit

Las condiciones de primer orden quedan:

$$
\frac{\partial \log L}{\partial \beta}
=-\sum_{\forall y_i=0}\frac{f_i x_i}{1-F_i}
+\frac{1}{\sigma^2}\sum_{\forall y_i>0}(y_i-\beta'x_i)x_i=0
$$

$$
\frac{\partial \log L}{\partial \sigma^2}
=\frac{1}{2\sigma^2}\sum_{\forall y_i=0}\frac{\beta'x_i f_i}{1-F_i}
-\frac{N_1}{2\sigma^2}
+\frac{1}{2\sigma^4}\sum_{\forall y_i>0}(y_i-\beta'x_i)^2=0
$$

Premultiplicando la primera ecuación por $\beta'/2\sigma^2$ y sumando el resultado a la segunda ecuación obtenemos:

$$
\sigma^2=\frac{1}{N_1}\sum_{\forall y_i>0}(y_i-\beta'x_i)y_i
=\frac{Y_1(Y_1-X_1\beta)}{N_1}
$$

Después, multiplicando la primera ecuación por $\sigma$ y despejando $\beta$:

$$
\beta=(X'_1X_1)^{-1}X'_1Y_1-\sigma(X'_1X_1)^{-1}X'_0\gamma_0
$$

---

# Modelo Tobit

Las condiciones de segundo orden son:

$$
\frac{\partial^2\log L}{\partial\beta\partial\beta'}
=-\sum_{\forall y_i=0}\frac{f_i}{(1-F_i)^2}
\left[f_i-\frac{1}{\sigma^2}(1-F_i)\beta'x_i\right]x_ix'_i
-\frac{1}{\sigma^2}\sum_{\forall y_i>0}x_ix'_i
$$

$$
\frac{\partial^2\log L}{\partial\sigma^2\partial\beta}
=-\frac{1}{2\sigma^2}\sum_{\forall y_i=0}\frac{f_i}{(1-F_i)^2}
\left[\frac{1}{\sigma^2}(1-F_i)(\beta'x_i)^2-(1-F_i)-\beta'x_i f_i\right]x_i
-\frac{1}{\sigma^4}\sum_{\forall y_i>0}(y_i-\beta'x_i)x_i
$$

$$
\frac{\partial^2\log L}{\partial(\sigma^2)^2}
=\frac{1}{4\sigma^4}\sum_{\forall y_i=0}\frac{f_i}{(1-F_i)^2}
\left[\frac{1}{\sigma^2}(1-F_i)(\beta'x_i)^3-3(1-F_i)\beta'x_i-(\beta'x_i)^2f_i\right]
+\frac{N_1}{2\sigma^4}
-\frac{1}{\sigma^6}\sum_{\forall y_i>0}(y_i-\beta'x_i)^2
$$

---

# Modelo Tobit

Defina la score function como

$$
S(\hat{\beta})=\frac{\partial \log L}{\partial\hat{\beta}}
$$

Y la matriz de información de Fisher como:

$$
I(\hat{\beta})=E\left(-\frac{\partial^2\log L}{\partial\hat{\beta}\partial\hat{\beta}'}\right)
$$

Por lo tanto

$$
\hat{r}_{jt}=\left[I(\hat{\beta})\right]^{-1}S(\hat{\beta})
$$

Go Back

---

# Modelo Probit Bivariante

En economía la motivación para utilizar este tipo de modelos proviene de la racionalización de que los resultados binarios observados pueden no reflejar la elección de un solo agente económico sino de la decisión conjunta de dos.

Por ejemplo, Gunderson (1974) discute modelos estadísticos para estimar la probabilidad de que un empleado que recibe entrenamiento en el trabajo sea retenido por la empresa después de dicho entrenamiento.

---

# Modelo Probit Bivariante

En esta situación, el empleador debe decidir si hacer o no una oferta de trabajo, y el empleado debe decidir si busca o no que le hagan la oferta.

Las decisiones individuales no son observables y lo único que uno observa es si el empleado continúa trabajando después de completar su entrenamiento o no.

En particular, las decisiones individuales se modelan como probits univariantes. Mientras que las dos decisiones tomadas conjuntamente se modelan como un probit bivariante.

Por ejemplo, considere las siguientes decisiones individuales:

$$
y^*_1=x\beta_1+v_1,\qquad y_i=1 \Longleftrightarrow y^*_1>0
$$

$$
y^*_2=x\beta_2+v_2,\qquad y_2=1 \Longleftrightarrow y^*_2>0
$$

---

# Modelo Probit Bivariante

Consideremos el caso de Gunderson, donde solo observamos si o no, $y_1$ e $y_2$ son iguales a uno. Definamos $z_j=y_{1j}y_{2j}$ para $j=1,2,\ldots,N$.

Como $z_j=1$ sí y solo sí $y_{ij}=1$ e $y_{2j}=1$, la distribución de $z_j$ es,

$$
p_j=\Pr(z_j=1)=\Pr(y_{ij}=1,y_{2j}=1)=F(x_j\beta_1,x_j\beta_2;\rho),
$$

$$
1-p_j=\Pr(z_j=0)=\Pr(y_{ij}=0 \text{ ó } y_{2j}=0)=1-F(x_j\beta_1,x_j\beta_2;\rho)
$$

Donde $\rho$ es el coeficiente de correlación entre $v_1$ y $v_2$, y $F(.)$ denota la distribución normal estándar bivariada.

---

# Modelo Probit Bivariante

El logaritmo de la función de verosimilitud es:

$$
L(\beta_1,\beta_2,\rho)=\sum_{j=1}^{N}z_j\log[F(x_j\beta_1,x_j\beta_2;\rho)]
+(1-z_j)\log[1-F(x_j\beta_1,x_j\beta_2;\rho)] \tag{55}
$$

Los estimadores de MV se obtienen maximizando esta función con respecto a:

$$
\hat{\theta}=(\hat{\beta}'_1,\hat{\beta}'_2,\hat{\rho})'
$$

---

# Modelo Probit Bivariante

Estos modelos tienen importantes implicancias para los problemas de sesgo de selección muestral.

Supongamos que al modelo de Gunderson le agregamos una ecuación salarial:

$$
y_3=x\beta_3+v_3,
$$

Donde $y_3$ denota salarios. Supongamos que $v=[v_1,v_2,v_3]$ tiene distribución normal trivariante con media cero y matriz de varianzas covarianzas igual a:

---

# Modelo Probit Bivariante

$$
\begin{pmatrix}
1 & \rho & \sigma_{13} \\
\rho & 1 & \sigma_{23} \\
\sigma_{13} & \sigma_{23} & \sigma_{33}
\end{pmatrix}
$$

Dado que observamos solo los salarios de los empleados que siguen trabajando en la empresa después de terminar el entrenamiento, la esperanza condicional del error de la ecuación de salarios es:

---

# Modelo Probit Bivariante

$$
E(v_3 \mid y^*_1>0,y^*_2>0)=E(v_3 \mid v_1>-x\beta_1,v_2>-x\beta_2)
$$

$$
=\sigma_{23}\left[
\frac{\phi(x\beta_1)\Phi\left[x(\beta_2-\rho\beta_1)/(1-\rho^2)^{1/2}\right]}{F(x\beta_1,x\beta_2;\rho)}
\right]
$$

$$
+\sigma_{23}\left[
\frac{\phi(x\beta_2)\Phi\left[x(\beta_1-\rho\beta_2)/(1-\rho^2)^{1/2}\right]}{F(x\beta_1,x\beta_2;\rho)}
\right]
$$

$$
=\sigma_{23}\lambda_1+\sigma_{23}\lambda_2 \tag{56}
$$

Por lo tanto para corregir la ecuación de salarios por sesgo de selección muestral hay que agregarle estos dos términos de la esperanza condicional.

---

# Modelo Probit Bivariante

Lo importante de este procedimiento es que si $z_j$ hubiera sido modelada como un modelo probit univariante el (incorrecto) término de corrección por sesgo de selección muestral sería la inversa del cociente de Mills.

Como el proceso de decisión involucra un modelo probit bivariado, aparecen dos términos para corregir por el sesgo de selección muestral.

---

# Modelo Probit Bivariante

En la práctica este procedimiento sería:

1. Estimar el modelo probit bivariante maximizando (55) y obtener los estimadores de $\beta_1$, $\beta_2$, y $\rho$;
2. Construir los términos expresados entre corchetes en (56) (i.e. $\lambda_1$ y $\lambda_2$); y
3. Estimar por OLS: $y_3=x\beta_3+\ell_1\lambda_1+\ell_2\lambda_2+v_3$.

---

# Modelo Probit Bivariante

Para más detalles puede consultar

Poirier, D (1980) “Partial observability in bivariate probit models”, Journal of Econometrics, 12, pp. 209-217.

Go Back

---

# La Matriz de Varianzas

Recuerde (9) con:

$$
y_{jt}-y_{js}=(x^1_{jt}-x^1_{js})\beta+(u_{jt}-u_{js}),
$$

y

$$
s_{j\tau}=1[X_j\delta_\tau+v_{j\tau}\geq0]
\qquad \text{para } \tau=t,s.
$$

Entonces,

$$
E(y_{it}-y_{js}\mid X_j,v_{jt}\geq -H_{jt},v_{js}\geq -H_{js})
=(x^1_{jt}-x^1_{js})\beta+\ell_{ts}\lambda_{jts}+\ell_{st}\lambda_{jst},
$$

---

# La Matriz de Varianzas

Donde,

$$
\lambda_{jts}=\frac{\phi[X_j\delta_t]\Phi\left[\frac{X_j\delta_s-\rho_{ts}X_j\delta_t}{(1-\rho_{ts}^2)^{1/2}}\right]}{\Phi_2[X_j\delta_t,X_j\delta_s,\rho_{ts}]}
$$

$$
\lambda_{jst}=\frac{\phi[X_j\delta_s]\Phi\left[\frac{X_j\delta_t-\rho_{ts}X_j\delta_s}{(1-\rho_{ts}^2)^{1/2}}\right]}{\Phi_2[X_j\delta_t,X_j\delta_s,\rho_{ts}]}
$$

---

# La Matriz de Varianzas

La estimación en dos pasos es como sigue. Primero estime

$$
\omega_{ts}=(\delta'_t,\delta'_s,\rho_{ts})'
$$

con

$$
\hat{\omega}_{ts}=(\hat{\delta}'_t,\hat{\delta}'_s,\hat{\rho}_{ts})'
$$

Usando un modelo Probit bivariado con las observaciones de $(s_{jt},s_{js},X_j)$.

Segundo, para la submuestra con $s_{jt}=s_{js}=1$, estime por POLS $\Delta y_{jts}=(y_{jt}-y_{js})$ sobre $\Delta x^1_{jts}=(x^1_{jt}-x^1_{js})$ y $(\hat{\lambda}_{jts},\hat{\lambda}_{jst})$.

---

# La Matriz de Varianzas

El segundo paso da estimaciones consistentes de los parámetros de interés $\beta$ y de los coeficientes que acompañan a los términos de corrección del sesgo de selección muestral $\ell_{ts}$ y $\ell_{st}$.

Definamos

$$
R_{jts}\equiv(\Delta x^1_{jts},\lambda_{jts},\lambda_{jst})'
$$

y las condiciones de primer orden en el segundo paso son:

$$
\frac{1}{N}\sum_j s_{jt}s_{js}
\left\{\Delta y_{jts}-\Delta x^1_{jts}\hat{\beta}-\hat{\ell}_{ts}\hat{\lambda}_{jts}-\hat{\ell}_{st}\hat{\lambda}_{jst}\right\}R_{jts}=0
$$

---

# La Matriz de Varianzas

Defina las siguientes equivalencias:

$$
\hat{\pi}_{ts}\equiv(\hat{\beta},\hat{\ell}_{ts},\hat{\ell}_{st})'
$$

$$
\pi_{ts}\equiv(\beta,\ell_{ts},\ell_{st})'
$$

$$
e_{jts}\equiv \Delta y_{jts}-\Delta x^1_{jts}\beta-\ell_{ts}\lambda_{jts}-\ell_{st}\lambda_{jst}
$$

Con estas definiciones se puede mostrar que:

$$
\sqrt{N}(\hat{\omega}_{ts}-\omega_{ts})
\overset{p}{\to}
\frac{1}{\sqrt{N}}\sum_j
I^{-1}_{\omega_{ts}}
\begin{pmatrix}
X'_j(q_{jt}\phi_{jt}\Phi_{jts}/\Phi_{2,jts}) \\
X'_j(q_{js}\phi_{st}\Phi_{jts}/\Phi_{2,jts}) \\
q_{jt}q_{js}\phi_{2,jts}/\Phi_{2,jts}
\end{pmatrix}
\equiv \frac{1}{\sqrt{N}}\sum_j\Lambda_j
$$

---

# La Matriz de Varianzas

Donde $I^{-1}_{\omega_{ts}}$ es la inversa de la matriz de información de Fisher del modelo Probit bivariado para $\omega_{ts}$,

$$
\phi_{jt}\equiv\phi[q_{jt}X_j\delta_t],
\qquad
\phi_{js}\equiv\phi[q_{js}X_j\delta_s]
$$

$$
\Phi_{jts}\equiv\Phi\left[\frac{q_{js}X_j\delta_s-\rho^*_{jts}q_{jt}X_j\delta_t}{(1-\rho_{jts}^{*2})^{1/2}}\right]
$$

$$
\Phi_{jts}\equiv\Phi\left[\frac{q_{jt}X_j\delta_t-\rho^*_{jts}q_{js}X_j\delta_t}{(1-\rho_{jts}^{*2})^{1/2}}\right]
$$

$$
\Phi_{2,jts}\equiv\Phi(q_{jt}X_j\delta_t,q_{js}X_j\delta_s,\rho^*_{jts})
\quad \text{y} \quad
\phi_{2,jts}\equiv\phi(q_{jt}X_j\delta_t,q_{js}X_j\delta_s,\rho^*_{jts}),
$$

$$
q_{jt}\equiv 2s_{jt}-1,
\qquad
q_{js}\equiv 2s_{js}-1,
\qquad
\rho^*_{jts}\equiv q_{jt}q_{js}\rho_{ts}.
$$

---

# La Matriz de Varianzas

Además,

$$
\sqrt{N}(\hat{\pi}_{ts}-\pi_{ts})
\overset{p}{\to}
E(s_ts_sR_{ts}R'_{ts})^{-1}\frac{1}{\sqrt{N}}\sum_j
\{s_{jt}s_{js}e_{jts}R_{jts}+A\Lambda_j\}
$$

Donde,

$$
A\equiv E\left\{s_ts_s
\left[
\left(-\ell_{ts}\frac{\partial\lambda_{ts}}{\partial X\delta_t}
-\ell_{ts}\frac{\partial\lambda_{st}}{\partial X\delta_t}\right)R_{ts}X
\right.
\right.
$$

$$
\left.
\left.
\left(-\ell_{ts}\frac{\partial\lambda_{ts}}{\partial X\delta_s}
-\ell_{ts}\frac{\partial\lambda_{st}}{\partial X\delta_s}\right)R_{ts}X
\right.
\right.
$$

$$
\left.
\left.
\left(-\ell_{ts}\frac{\partial\lambda_{ts}}{\partial X\rho_{ts}}
-\ell_{ts}\frac{\partial\lambda_{st}}{\partial X\rho_{ts}}\right)R_{ts}
\right]
\right\}
$$

---

# La Matriz de Varianzas

Por lo tanto, $\sqrt{N}(\hat{\pi}_{ts}-\pi_{ts})\to N(0,\Gamma)$

Donde

$$
\Gamma=E(s_ts_sR_{ts}R'_{ts})^{-1}
\times E\{(s_ts_se_{ts}R_{ts}+A\Lambda)(s_ts_se_{ts}R_{ts}+A\Lambda)'\}
\times E(s_ts_sR_{ts}R'_{ts})^{-1}
$$

El término $A\Lambda$ es el efecto del primer paso en el segundo.

---

# La Matriz de Varianzas

La estimación de la inversa de la matriz de información de Fisher puede obtenerse usando el estimador de Berndt et al. (1974)

$$
\hat{I}^{-1}_{\omega_{ts}}=
\left\{
\frac{1}{N}\sum_j
\begin{bmatrix}
X'_j(q_{jt}\phi_{jt}\Phi_{jts}/\Phi_{2,jts})\\
X'_j(q_{js}\phi_{st}\Phi_{jts}/\Phi_{2,jts})\\
q_{jt}q_{js}\phi_{2,jts}/\Phi_{2,jts}
\end{bmatrix}
\begin{bmatrix}
X'_j(q_{jt}\phi_{jt}\Phi_{jts}/\Phi_{2,jts})\\
X'_j(q_{js}\phi_{st}\Phi_{jts}/\Phi_{2,jts})\\
q_{jt}q_{js}\phi_{2,jts}/\Phi_{2,jts}
\end{bmatrix}'
\right\}^{-1}
$$

Go Back

---

# Sample Selection: Type III Tobit Model

Consider the case where the selection equation is of the censored Tobit form.

The population model is

$$
y_1=x_1\beta_1+u_1 \tag{57}
$$

$$
y_2=\max(0;x\delta_2+v_2) \tag{58}
$$

where $(x,y_2)$ is always observed in the population but $y_1$ is observed only when $y_2>0$.

A standard example occurs when $y_1$ is the log of the hourly wage offer and $y_2$ is weekly hours of labor supply.

---

# Sample Selection: Type III Tobit Model

Assumption: (a) $(x,y_2)$ is always observed in the population, but $y_1$ is observed only when $y_2>0$; (b) $(u_1;v_2)$ is independent of $x$; (c) $v_2\sim \operatorname{Normal}(0;\tau_2^2)$; and (d) $E(u_1\mid v_2)=\gamma_1v_2$.

---

# Sample Selection: Type III Tobit Model

Define the selection indicator as $s_2=1$ if $y_2>0$, and $s_2=0$ otherwise.

Since $s_2$ is a function of $x$ and $v_2$, it follows immediately that

$$
E(y_1\mid x;v_2;s_2=1)=x_1\beta_1+\gamma_1v_2 \tag{59}
$$

This equation means that, if we could observe $v_2$, then an OLS regression of $y_1$ on $x_1$, and $v_2$ using the selected subsample would consistently estimate $(\beta_1;\gamma_1)$.

$v_2$ cannot be observed when $y_2=0$ (because when $y_2=0$, we only know that $v_2\leq x\delta_2$, for $y_2>0$, $v_2=y_2-x\delta_2$.

If we knew $\delta_2$, we would know $v_2$ whenever $y_2>0$.

It seems reasonable that, because $\delta_2$ can be consistently estimated by Tobit on the whole sample, we can replace $v_2$ with consistent estimates.

---

# Sample Selection: Type III Tobit Model

Estimation Procedure: (a) Estimate equation (58) by standard Tobit using all $N$ observations. For $y_{i2}>0$ (say $i=1,2,\ldots,N_1$), define

$$
\hat{v}_{i2}=y_{i2}-x_i\hat{\delta}_2 \tag{60}
$$

(b) Using observations for which $y_{i2}>0$, estimate $(\beta_1;\gamma_1)$ by the OLS regression: $y_{i1}$ on $x_{i1}$, and $\hat{v}_{i2}$ $i=1,2,\ldots,N_1$.

This regression produces consistent and $\sqrt{N}$ asymptotically normal estimators of $(\beta_1;\gamma_1)$.

Go Back
