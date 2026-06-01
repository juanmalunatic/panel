# Universidad Torcuato Di Tella

**Maestría en Economía y Econometría**  
**2022**

---

**Datos de Panel**  
**Problem Set 5**  
**Modelos de Variable Dependiente Discreta**

---

1. El archivo `wagepan.dta` contiene los datos utilizados por Vella y Verbeek (1998). Estos datos contienen información para 545 hombres que trabajaron cada año de 1980 a 1987. Utilice los datos para analizar el impacto de la escolaridad ($educ_{it}$) en la probabilidad de estar afiliado a un sindicato ($union_{it}$). Las variables se describen en el conjunto de datos. Observe que la educación no cambia con el tiempo.

    a) Use Pooled OLS para estimar el modelo:

    $$
    P(union_{it}=1 \mid educ_{it}) = \beta_0 + \beta_1 educ_{it}
    \tag{1}
    $$

    De acuerdo a los resultados obtenidos, ¿tiene impacto un año más de escolaridad sobre la probabilidad de estar afiliado a un sindicato?

    b) Use Pooled Probit para estimar el modelo:

    $$
    P(union_{it}=1 \mid educ_{it}) = \Phi(\beta_0 + \beta_1 educ_{it})
    \tag{2}
    $$

    Comente sobre el impacto de un año más de educación en la probabilidad de estar afiliado a un sindicato.

    c) Use Pooled Logit para estimar el modelo:

    $$
    P(union_{it}=1 \mid educ_{it}) = \Lambda(\beta_0 + \beta_1 educ_{it}) = \frac{e^{\beta_0 + \beta_1 educ_{it}}}{1 + e^{\beta_0 + \beta_1 educ_{it}}}
    \tag{3}
    $$

    Comente sobre el impacto de un año más de educación en la probabilidad de estar afiliado a un sindicato. Compute el error estándar para esta estimación.

    d) Estime la siguiente extensión del modelo (2):

    $$
    P(union_{it}=1 \mid educ_{it}, c_i) = \Phi(\beta_0 + \beta_1 educ_{it} + c_i)
    \tag{4}
    $$

    donde $c_i$ son efectos no observables individuales. Use el modelo Probit de efectos aleatorios. ¿Cuál es el problema que surge al momento de estimar el efecto parcial de interés?

    e) Estime la siguiente extensión del modelo (3):

    $$
    P(union_{it}=1 \mid educ_{it}, c_i) = \Lambda(\beta_0 + \beta_1 educ_{it} + c_i)
    \tag{5}
    $$

    donde $c_i$ son efectos no observables individuales. Use el modelo Logit de efectos aleatorios. ¿Surge el mismo problema que en el inciso anterior al momento de estimar el efecto parcial de interés?

    f) Compute el denominado estimador Logit de efectos fijos para el modelo (5). ¿Se puede computar el efecto de un año más de educación sobre la probabilidad de estar afiliado a un sindicato? Explique.

    g) Considere la siguiente extensión del modelo (4):

    $$
    P(union_{it}=1 \mid educ_{it}, black_{it}, married_{it}, c_i) =
    $$

    $$
    \Phi(\beta_0 + \beta_1 educ_{it} + \beta_2 black_{it} + \beta_3 married_{it} + c_i)
    \tag{6}
    $$

    donde $black_{it}$ es una variable binaria que toma valor 1 si la persona es afroamericana y $married_{it}$ es una variable binaria que toma valor 1 si la persona es casada. Asuma la siguiente versión de Mundlak (1978) del supuesto de Chamberlain (1980):

    $$
    c_i \mid X_i \sim Normal\left(\psi + \xi \cdot \overline{married_i}, \sigma_a^2\right)
    \tag{7}
    $$

    El modelo dado por (6) y (7) es un caso de lo que en la literatura se denomina modelo Probit de efectos aleatorios de Chamberlain. Al asumir solamente (6) y (7) se tiene que:

    $$
    P(union_{it}=1 \mid educ_{it}, black_{it}, married_{it}) =
    $$

    $$
    \Phi\left[(\beta_0 + \beta_1 educ_{it} + \beta_2 black_{it} + \beta_3 married_{it} + \psi + \xi \overline{married_i})(1 + \sigma_a^2)^{-1/2}\right] \equiv
    $$

    $$
    \Phi\left[\beta_{0,a} + \beta_{1,a} educ_{it} + \beta_{2,a} black_{it} + \beta_{3,a} married_{it} + \xi_a \overline{married_i}\right]
    $$

    Use Pooled Probit para estimar el modelo. Estime el efecto de la escolaridad sobre la probabilidad de estar sindicalizado para una persona afroamericana casada.

2. Considere los datos del ejercicio previo para analizar la probabilidad de estar afiliado a un sindicato según la situación de afiliación sindical del año previo.

    a) Use Pooled Probit para estimar el modelo:

    $$
    P(union_{it}=1 \mid union_{it-1}) = \Phi(\psi + \rho \cdot union_{it-1})
    \tag{8}
    $$

    A continuación, obtenga una estimación para

    $$
    P(union_{it}=1 \mid union_{it-1}=1)
    $$

    y para

    $$
    P(union_{it}=1 \mid union_{it-1}=0).
    $$

    . Comente sobre el efecto marginal de estar afiliado a un sindicato en el año $t - 1$ en la probabilidad de estar afiliado a un sindicato en el año $t$.

    b) Adicione al modelo el conjunto completo de variables binarias temporales. Vuelva a estimar las probabilidades solicitadas para cada año de la muestra.

    c) Estime un modelo de efectos no observables dinámico. Use el modelo Probit de efectos aleatorios incluyendo $union_{i,80}$ como una variable explicativa adicional. Luego, promedie las probabilidades estimadas a lo largo de $union_{i,80}$ para obtener la probabilidad promedio de estar afiliado a un sindicato en el año 1987 dado que estaba afiliado en el período anterior.
