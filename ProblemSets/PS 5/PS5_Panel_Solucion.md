# Universidad Torcuato Di Tella

**Maestría en Economía y Econometría**  
**2022**

# Datos de Panel

# Problem Set 5

# Modelos de Variable Dependiente Discreta

## 1.

El archivo `wagepan.dta` contiene los datos utilizados por Vella y Verbeek (1998). Estos datos contienen información para 545 hombres que trabajaron cada año de 1980 a 1987. Utilice los datos para analizar el impacto de la escolaridad ($educ_{it}$) en la probabilidad de estar afiliado a un sindicato ($union_{it}$). Las variables se describen en el conjunto de datos. Observe que la educación no cambia con el tiempo.

### a)

Use Pooled OLS para estimar el modelo:

$$
P(union_{it}=1 \mid educ_{it}) = \beta_0 + \beta_1 educ_{it}
\tag{1}
$$

De acuerdo a los resultados obtenidos, ¿tiene impacto un año más de escolaridad sobre la probabilidad de estar afiliado a un sindicato?

**Solution:** Si bien el coeficiente de interés estimado es negativo, $\hat{\beta}_1 = -0,0015$, el mismo no es estadísticamente significativo. Por lo tanto, no hay evidencia suficiente para rechazar la hipótesis nula que un año más de escolaridad no modifica la probabilidad de estar afiliado a un sindicato.

Por otra parte, respecto a la metodología, utilizar un modelo de probabilidad lineal cuando la variable dependiente es lineal tiene los mismos problemas que en el caso de una muestra de corte transversal: 1) Nada garantiza que el valor predicho esté entre 0 y 1, y 2) el modelo tiene heterocedasticidad por construcción.

### b)

Use Pooled Probit para estimar el modelo:

$$
P(union_{it}=1 \mid educ_{it}) = \Phi(\beta_0 + \beta_1 educ_{it})
\tag{2}
$$

Comente sobre el impacto de un año más de educación en la probabilidad de estar afiliado a un sindicato.

**Solution:** Dado que la variable años de educación se trata de una variable continua, entonces el efecto parcial de la escolaridad sobre la probabilidad de estar afiliado a un sindicato es:

$$
\frac{\partial P(union_{it}=1 \mid educ_{it})}{\partial educ_{it}}
= \beta_1 \phi(\beta_0 + \beta_1 educ_{it})
$$

Claramente el signo del efecto marginal depende del signo de $\beta_1$. Sin embargo, la magnitud cambiará con respecto a los valores de $educ_{it}$. Un consenso en la práctica es evaluar en el promedio de las $x$. Cuando hacemos esto en Stata obtenemos que un año más de educación reduce la probabilidad de estar afiliado en $-0,0016$, aunque esta caída no resulta estadísticamente significativa.

### c)

Use Pooled Logit para estimar el modelo:

$$
P(union_{it}=1 \mid educ_{it}) = \Lambda(\beta_0 + \beta_1 educ_{it}) =
\frac{e^{\beta_0 + \beta_1 educ_{it}}}{1 + e^{\beta_0 + \beta_1 educ_{it}}}
\tag{3}
$$

Comente sobre el impacto de un año más de educación en la probabilidad de estar afiliado a un sindicato. Compute el error estándar para esta estimación.

**Solution:** El efecto parcial de la escolaridad sobre la probabilidad de estar afiliado a un sindicato es:

$$
\frac{\partial P(union_{it}=1 \mid educ_{it})}{\partial educ_{it}}
= g(\beta_0,\beta_1)
= \beta_1 \Lambda(\beta_0 + \beta_1 educ_{it})\left(1 - \Lambda(\beta_0 + \beta_1 educ_{it})\right)
$$

Al computar el efecto marginal en el promedio de la variable escolaridad, encontramos que un año más de escolaridad reduce la probabilidad de estar afiliado a un sindicato en $-0,0015$, aunque nuevamente se encuentra que esta caída no es estadísticamente significativa.

Para computar el error estándar de la estimación debemos utilizar el Método Delta:

$$
V\left(\frac{\partial P(union_{it}=1 \mid educ_{it})}{\partial educ_{it}}\right)
= \frac{\partial \hat{g}}{\partial \beta'} \cdot \widehat{V}(\hat{\beta}) \cdot \frac{\partial \hat{g}'}{\partial \beta'}
$$

La estimación puntual $\widehat{V}(\hat{\beta})$ la recuperamos de los resultados de la estimación del modelo al utilizar el comando `logit`. Lo que es importante es calcular las derivadas parciales de la función $g$ con respecto a los parámetros $\beta$. Lo hacemos a continuación:

$$
\frac{g(\beta_0,\beta_1)}{\beta_1}
= \Lambda(1-\Lambda) + \beta_1[\Lambda'(1-\Lambda)educ_{it} - \Lambda'\Lambda educ_{it}]
$$

$$
= \Lambda(1-\Lambda) + \beta_1[1-2\Lambda]\Lambda'educ_{it}
$$

Luego, tenemos que:

$$
\frac{\hat{g}(\beta_0,\beta_1)}{\beta_1}
= \hat{\Lambda}\left(1-\hat{\Lambda}\right)
+ \hat{\beta}_1\left[1-2\hat{\Lambda}\right]\hat{\Lambda}' educ_{it}
$$

Bajo un procedimiento análogo se puede obtener que:

$$
\frac{\hat{g}(\beta_0,\beta_1)}{\beta_0}
= \hat{\beta}_1\left[1-2\hat{\Lambda}\right]\hat{\Lambda}'
$$

Por último, se recuerda que $\Lambda' = \Lambda(1-\Lambda)$.

### d)

Estime la siguiente extensión del modelo (2):

$$
P(union_{it}=1 \mid educ_{it}, c_i) = \Phi(\beta_0 + \beta_1 educ_{it} + c_i)
\tag{4}
$$

donde $c_i$ son efectos no observables individuales. Use el modelo Probit de efectos aleatorios. ¿Cuál es el problema que surge al momento de estimar el efecto parcial de interés?

**Solution:** El efecto parcial de interés es:

$$
\frac{\partial P(union_{it}=1 \mid educ_{it}, c_i)}{\partial educ_{it}}
= \beta_1 \phi(\beta_0 + \beta_1 educ_{it} + c_i)
$$

El efecto parcial depende de $c_i$, lo cual no es estimado. Por lo tanto, no se puede estimar la magnitud del efecto parcial a menos que insertemos el valor de $c_i$. Una posibilidad que permite Stata es calcular el efecto marginal en $c_i = 0$ lo que tiene sentido ya que estamos asumiendo que $c_i \mid X_i \sim Normal(0,\sigma_c^2)$. Haciendo esto último encontramos que un año más de educación reduce la probabilidad de estar afiliado a un sindicato en $-0,0076$. Sin embargo, este efecto no es estadísticamente significativo.

### e)

Estime la siguiente extensión del modelo (3):

$$
P(union_{it}=1 \mid educ_{it}, c_i) = \Lambda(\beta_0 + \beta_1 educ_{it} + c_i)
\tag{5}
$$

donde $c_i$ son efectos no observables individuales. Use el modelo Logit de efectos aleatorios. ¿Surge el mismo problema que en el inciso anterior al momento de estimar el efecto parcial de interés?

**Solution:** El efecto parcial de interés es:

$$
\frac{\partial P(union_{it}=1 \mid educ_{it}, c_i)}{\partial educ_{it}}
= \beta_1 \frac{\exp(\beta_0 + \beta_1 educ_{it} + c_i)}{\left(1 + \exp(\beta_0 + \beta_1 educ_{it} + c_i)\right)^2}
$$

Nuevamente, no se puede estimar la magnitud del efecto parcial a menos que insertemos el valor de $c_i$. Al calcular el efecto marginal en $c_i = 0$ encontramos que un año más de educación reduce la probabilidad de estar afiliado a un sindicato en $-0,0059$, pero la caída no es estadísticamente significativa.

### f)

Compute el denominado estimador Logit de efectos fijos para el modelo (5). ¿Se puede computar el efecto de un año más de educación sobre la probabilidad de estar afiliado a un sindicato? Explique.

**Solution:** El efecto de interés no puede ser computado porque en este método no se identifican los coeficientes de los regresores que no varían en el tiempo como es el caso de la variable educación en este ejercicio. Por otra parte, aún si el coeficiente estuviera identificado (en el caso de que la variable varíe en el tiempo), correríamos la misma suerte que en los incisos previos de que deberíamos inservar el valor de $c_i$ sumado a que en este caso es difícil saber que valor insertar ya que no estamos asumiendo que conocemos la distribución de $c_i$.

### g)

Considere la siguiente extensión del modelo (4):

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
\Phi\left[\left(\beta_0 + \beta_1 educ_{it} + \beta_2 black_{it} + \beta_3 married_{it} + \psi + \xi \overline{married_i}\right)\left(1 + \sigma_a^2\right)^{-1/2}\right] \equiv
$$

$$
\Phi\left[\beta_{0,a} + \beta_{1,a}educ_{it} + \beta_{2,a}black_{it} + \beta_{3,a}married_{it} + \xi_a \overline{married_i}\right]
$$

Use Pooled Probit para estimar el modelo. Estime el efecto de la escolaridad sobre la probabilidad de estar sindicalizado para una persona afroamericana casada.

**Solution:** Se obtiene que para una persona afroamericana y casada un año más de educación reduce la probabilidad de estar afiliado en un sindicato en $-0,0012$. Sin embargo, el efecto no es estadísticamente significativo.

La siguiente tabla del libro de Wooldridge (2010) resume de manera clara gran parte de lo que vimos hasta aquí:

> **Descripción de la imagen/tabla:** la imagen reproduce la **Table 15.4: Summary of Features of Models and Estimation Methods for Unobserved Effects Binary Response Models**. La tabla compara distintos métodos para modelos binarios con efectos no observados: Probit de efectos aleatorios por MLE, Probit RE pooled MLE, Probit RE GEE, las variantes de Probit RE de Chamberlain, LPM within y Logit FE MLE. Las columnas indican si la probabilidad condicional queda acotada en $(0,1)$, si el método restringe la distribución de $c_i \mid x_i$, si permite dependencia serial idiosincrática, si permite efectos parciales evaluados en $E(c_i)$ y si permite APEs. La función de la tabla es sintetizar el trade-off entre modelos paramétricos/no paramétricos de efectos no observados y la posibilidad de calcular efectos parciales.

| Model, Estimation Method | $P(y_{it}=1 \mid x_{it},c_i)$ bounded in $(0,1)$? | Restricts $D(c_i \mid x_i)$? | Idiosyncratic Serial Dependence? | Partial Effects at $E(c_i)$? | APEs? |
|---|---:|---|---:|---:|---:|
| RE probit, MLE | Yes | Yes (independence, normal) | No | Yes | Yes |
| RE probit, pooled MLE | Yes | Yes (independence, normal) | Yes | No | Yes |
| RE probit, GEE | Yes | Yes (independence, normal) | Yes | No | Yes |
| Chamberlain's RE probit, MLE | Yes | Yes (linear mean, normal) | No | Yes | Yes |
| Chamberlain's RE probit, pooled MLE | Yes | Yes (linear mean, normal) | Yes | No | Yes |
| Chamberlain's RE probit, GEE | Yes | Yes (linear mean, normal) | Yes | No | Yes |
| LPM, within | No | No | Yes | Yes | Yes |
| FE logit, MLE | Yes | No | No | No | No |

## 2.

Considere los datos del ejercicio previo para analizar la probabilidad de estar afiliado a un sindicato según la situación de afiliación sindical del año previo.

### a)

Use Pooled Probit para estimar el modelo:

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

Comente sobre el efecto marginal de estar afiliado a un sindicato en el año $t-1$ en la probabilidad de estar afiliado a un sindicato en el año $t$.

**Solution:** Se estima que:

- La probabilidad estar afiliado a un sindicato dado que estaba afiliado en el período anterior es 0.727
- La probabilidad estar afiliado a un sindicato dado que no estaba afiliado en el período anterior es 0.089

Luego, el cambio marginal de estar afiliado a un sindicato en el año $t-1$ resulta en un aumento en la probabilidad de estar afiliado a un sindicato en el año $t$ de $0,727 - 0,089 = 0,638$.

### b)

Adicione al modelo el conjunto completo de variables binarias temporales. Vuelva a estimar las probabilidades solicitadas para cada año de la muestra.

**Solution:** Se estima que:

- La probabilidad estar afiliado a un sindicato en el año 1982 dado que estaba afiliado en el período anterior es 0.748
- La probabilidad estar afiliado a un sindicato en el año 1982 dado que no estaba afiliado en el período anterior es 0.097
- La probabilidad estar afiliado a un sindicato en el año 1983 dado que estaba afiliado en el período anterior es 0.717
- La probabilidad estar afiliado a un sindicato en el año 1983 dado que no estaba afiliado en el período anterior es 0.082
- La probabilidad estar afiliado a un sindicato en el año 1984 dado que estaba afiliado en el período anterior es 0.736
- La probabilidad estar afiliado a un sindicato en el año 1984 dado que no estaba afiliado en el período anterior es 0.090
- La probabilidad estar afiliado a un sindicato en el año 1985 dado que estaba afiliado en el período anterior es 0.680
- La probabilidad estar afiliado a un sindicato en el año 1985 dado que no estaba afiliado en el período anterior es 0.067
- La probabilidad estar afiliado a un sindicato en el año 1986 dado que estaba afiliado en el período anterior es 0.687
- La probabilidad estar afiliado a un sindicato en el año 1986 dado que no estaba afiliado en el período anterior es 0.069
- La probabilidad estar afiliado a un sindicato en el año 1987 dado que estaba afiliado en el período anterior es 0.788
- La probabilidad estar afiliado a un sindicato en el año 1987 dado que no estaba afiliado en el período anterior es 0.121

### c)

Estime un modelo de efectos no observables dinámico. Use el modelo Probit de efectos aleatorios incluyendo $union_{i,80}$ como una variable explicativa adicional. Luego, promedie las probabilidades estimadas a lo largo de $union_{i,80}$ para obtener la probabilidad promedio de estar afiliado a un sindicato en el año 1987 dado que estaba afiliado en el período anterior.

**Solution:** Se nos solicita computar:

$$
N^{-1}\sum_{i=1}^{N}
\left\{
\Phi\left[
\frac{\hat{\psi} + \hat{\rho} + \hat{\xi} union_{i,80} + \hat{\delta}_{87}}{(1+\hat{\sigma}_a^2)^{1/2}}
\right]
\right\}
$$

La probabilidad promedio de estar afiliado a un sindicato en el año 1987 dado que estaba afiliado en el año previo es igual a 0.397.
