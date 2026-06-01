# Universidad Torcuato Di Tella

Maestría en Economía y Econometría  
2022

**Datos de Panel**  
**Problem Set 1**  
**Modelo de Regresión Lineal**

---

1. Utilice la base de datos provista “cornwell.dta”.

    a) A partir de los datos de los siete años, y utilizando los logaritmos de todas las variables, estime un modelo por POLS que relacione la tasa de crimen con `prbarr`, `prbconv`, `prbpris`, `avgsen` y `polpc` y que incluya un conjunto de *dummies* de año.

    b) Compute los errores estándar robustos a heteroscedasticidad arbitraria y a autocorrelación serial arbitraria.

    c) Implemente un contraste de Correlación Serial.

    d) Implemente un contraste de Heterocedasticidad.

    e) Asuma que se cumple el supuesto de exogeneidad estricta y que $u_{it}$ sigue un proceso AR(1). Compute el estimador de FGLS siguiendo el enfoque de Prais-Winsten. Una descripción del procedimiento puede encontrarla en Wooldridge (2010), sección 7.8.6.

    **Observación:** GLS necesita exogeneidad estricta para conseguir estimadores consistentes.

    f) Compute los errores estándar robustos a heteroscedasticidad arbitraria y a autocorrelación serial arbitraria para el modelo con las variables transformadas del inciso previo.

    **Sugerencia de Wooldridge.** “..If we have any doubts about the homoskedasticity assumption, or whether the AR(1) assumption sufficiently captures the serial dependence, we can just apply the usual fully robust variance matrix and associated statistics to pooled OLS on the transformed variables. This allows us to probably obtain an estimator more efficient than POLS (on the original data) but also guards against the rather simple structure we imposed on $\Omega$. Of course, failure of strict exogeneity generally causes the Prais-Winsten estimator of $\beta$ to be inconsistent.”

2. En este ejercicio examinará un modelo para el costo total de producción en la industria aeronáutica a modo de ilustrar una aplicación de un modelo heteroscedástico por grupos. Considere la siguiente función de costos:

$$
\begin{aligned}
\ln cost_{jt} &= \beta_1 + \beta_2 \ln output_{jt} + \beta_3 load\ factor_{jt} + \beta_4 \ln fuel\ price_{jt} \\
&\quad \delta_2 Firm_2 + \delta_3 Firm_3 + \delta_4 Firm_4 + \delta_5 Firm_5 + \delta_6 Firm_6 + \varepsilon_{jt}
\end{aligned}
$$

    a) Utilice la base de datos provista “greene97.dta”, la cual contiene datos para seis compañías aéreas observadas anualmente durante 15 años. Estime la ecuación por POLS.

    b) Ahora, asuma que dentro de cada compañía aérea se tiene que:

$$
Var[\varepsilon_{jt} \mid x_{jt}] = \sigma_j^2, \quad t = 1,\ldots,T
$$

Por lo tanto, si las varianzas fueran conocidas, el estimador de GLS sería:

$$
\hat{\beta} =
\left[
\sum_{j=1}^{N}
\left(\frac{1}{\sigma_j^2}\right)
X'_j X_j
\right]^{-1}
\left[
\sum_{j=1}^{N}
\left(\frac{1}{\sigma_j^2}\right)
X'_j y_j
\right]
$$

    donde $X_j$ es una matriz $T \times K$. Sin embargo, en este caso práctico las varianzas son desconocidas. Luego, se le solicita computar el estimador de FGLS a través de los siguientes métodos:

    1) Estime el modelo calculando el estimador necesario para la varianza específica de la compañía aérea a partir de los residuos de OLS, es decir,

$$
\hat{\sigma}_j^2 = \frac{e'_j e_j}{n_j}.
$$

    2) Estimar el modelo tratándolo como una forma del modelo de heteroscedasticidad multiplicativa de Harvey (1976). Utilice el procedimiento en dos etapas.

    c) Compare los resultados obtenidos en el inciso b).

3. Considere la siguiente ecuación de salarios:

$$
y_{jt} = \beta_0 + \beta_1 x_{jt} + u_{jt}, \quad j = 1,2,\ldots,N; t = 1,2
\tag{1}
$$

    donde $\beta_0 = \beta_1 = 1$, $u_j \sim N(0,\Omega)$,

$$
\Omega =
\begin{bmatrix}
1 & 0 \\
0 & 4
\end{bmatrix}
$$

    y $x_j \sim U[1,20]$

Genere 1000 muestras de $N = 5$ observaciones de corte transversal a partir del modelo (1). Para cada muestra estime por FGLS los parámetros del modelo y realice un test de hipótesis para contrastar que $H_0 : \beta_1 = 1$. Reporte tamaño del test al 1 % y el poder del test cuando $\beta_1 = 0{,}8$. Luego, repita el procedimiento con $N = 500$. ¿Se aprecia algún cambio en el tamaño y/o en el poder del test ante el incremento de $N$?
