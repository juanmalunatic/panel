# Clase 7 - Datos de Panel 2026

> Nota: el documento original figura como “Clase 7 - Datos de Panel 2025”, pero para este trabajo se lo trata como material subido/usado en la edición 2026.

La clase de hoy consta en trabajar sobre el ejercicio 1 y el ejercicio 2 (a y b) del PS4.

---

## Paneles no balanceados

Hasta ahora teníamos una muestra aleatoria y completa. Vamos a levantar el último supuesto.

Problemas que causan paneles desbalanceados:

- **Paneles rotativos:** hay una regla para la entrada y salida del panel. Ejemplo: EPH 2:2:2: dos trimestres seguidos se encuesta, se descansa dos trimestres seguidos y se vuelve a encuestar dos trimestres seguidos.
- **Attrition:** pérdida de unidades por “voluntad” del encuestado. Problema importante para microeconometría.
- **Truncamiento incidental:** variables no observadas por algunos períodos temporales. Extensión de Heckman de econometría, ahora aplicada a panel.

Va a generar sesgo de selección muestral siempre y cuando las causas estén sistemáticamente relacionadas con las variables explicativas.

Conversar relación entre paneles rotativos y attrition.

### Wooldridge (1995)

> We cover two cases that arise in practice. The first is when the selection variable is partially observed. The leading application of this case is to labor studies where the regression equation is, say, a wage equation, and selection depends on whether or not individuals are working. If a person is working, then her/his hours are recorded, and selection is determined by nonzero hours worked. The other case is the more widely applicable one, where only a binary selection indicator is observed. One might expect that more flexibility is available in the first case because more information is known, and we also show here that this is the case.

En el ejercicio de hoy trabajamos con una base de salarios con información de los trabajadores. El problema es que no vamos a tener datos de salarios para todos porque no todos trabajan. Las personas para las que tengo el dato de salario pertenecen a un tipo de persona más específico: las que deciden trabajar. Hay un componente que explica la decisión de trabajar que no estoy incluyendo en la ecuación y eso genera sesgo de variables omitidas.

---

## Repaso de Microeconometría 1: diferencia entre variable censurada y truncada

Imposibilidad de observar un determinado rango de valores de las variables. Esto implica que hay una variable latente, $y^*$, la verdadera variable a la que no puedo acceder, y por otro lado la variable que sí observo, $y$.

### Variable censurada

Threshold por encima/debajo del cual el verdadero valor de la variable latente no es conocido.

Esto es, si $L$ es el valor del umbral y la variable dependiente está censurada por debajo, entonces para todos los valores donde

$$
y^* \leq L
$$

en la base observamos

$$
y = L.
$$

La variable latente no es observada para cierto rango de valores. Las variables independientes las observo completamente, sin ningún tipo de censura.

Esto lleva a que, de hacer un plot, se vea una mayor concentración de puntos sobre el valor de censura, $L$, cuando debieran estar por debajo de este. Para la estimación de este tipo de información una de las herramientas es el modelo Tobit.

#### Ejemplo de variable censurada por declaración de los individuos en la muestra

Supongamos que estamos estudiando el gasto mensual en alcohol de una muestra de individuos. La variable de interés es el gasto mensual en pesos, pero muchas personas no reportan ningún gasto simplemente porque no consumen alcohol o no admiten hacerlo. Entonces, en los datos observamos:

$$
Y_i = 0
$$

si la persona no gasta nada, ya sea porque realmente no consume o porque no declara el gasto, y

$$
Y_i > 0
$$

si hay un gasto positivo observado.

En este caso, la variable “gasto en alcohol” está censurada por abajo en cero, porque no se observan los valores negativos.

#### Ejemplo de variable censurada por disponibilidad de información en la base que tenemos

Supongamos que estamos analizando la duración del desempleo en semanas. En una encuesta, se le pregunta a cada persona cuánto tiempo ha estado desempleada. Sin embargo, el diseño del estudio impone un límite: las personas que llevan más de 52 semanas desempleadas se registran como “52+”, es decir, no se observa la duración exacta más allá de ese punto.

En este caso, la variable “duración del desempleo” está censurada por arriba en 52 semanas, ya que no se conocen los valores verdaderos para quienes llevan más de un año desempleados. La data la veríamos de la siguiente manera:

| ID | Semanas reales | Semanas observadas |
|---:|---:|---:|
| 1 | 10 | 10 |
| 2 | 47 | 47 |
| 3 | 62 | 52+ |
| 4 | 38 | 38 |
| 5 | 55 | 52+ |
| 6 | 12 | 12 |
| 7 | 26 | 26 |
| 8 | 70 | 52+ |
| 9 | 6 | 6 |
| 10 | 45 | 45 |

### Variable truncada

Cuando la variable se encuentra truncada no se cuenta con información de la variable latente, más allá del valor de truncamiento $L$, pero tampoco de las variables independientes para estos valores de la variable latente. Por lo tanto, en el caso del truncamiento no se cuenta con estas observaciones.

Tanto la censura como el truncamiento pueden ser por arriba, por abajo o por ambas a la vez.

No hay sampling aleatorio de la población. En la tabla de arriba no veríamos las filas correspondientes a $id = 3, 5, 8$.

**Truncamiento incidental:** algunas variables se observan sólo si otras variables toman valores particulares. Solemos poder hacer el random sampling, pero vamos a tener faltantes en variables importantes y no vamos a tener información en el outcome.

Si tengo un dataset con gente, y veo el salario sólo para aquellos que trabajan, para estudiantes o desempleados no veo el salario.

Ecuación del salario y la parte relacionada con self-selection. Esta ecuación depende fuertemente de la decisión de un individuo de trabajar o no trabajar. Lo importante es que al caracterizar la ecuación del salario tenemos que tener en cuenta que las personas no son asignadas a trabajar aleatoriamente.

**IMPORTANTE:** definir la población de interés/objetivo.

Idea:

```text
Muestreo iid
(aleatorio)

Responden todos
X iid

Algunos no responden
Potencial sesgo de selección muestral
```

---

# Ejercicio 1

Utilice la base `keane.dta`, la cual contiene el historial de empleo y escolaridad de una muestra de hombres para los años 1981 a 1987. Luego, considere la siguiente ecuación de salarios:

$$
\ln(wage_{it}) = \beta_0 + \beta_1 exper_{it} + \beta_2 educ_{it} + c_i + u_{it}, \qquad t = 1,2,\ldots,T
$$

donde $\ln(wage_{it})$ es el logaritmo del salario por hora, $exper_{it}$ son los años de experiencia en el mercado laboral y $educ_{it}$ son los años de escolaridad.

## a) Estime la ecuación usando efectos fijos. ¿Cuál es el sesgo potencial en este contexto?

Partiendo del modelo

$$
y_{it} = x_{it}\beta + c_i + u_{it},
$$

el modelo FE nos permite cualquier relación entre $c_i$ y las variables explicativas.

Procedimiento:

1. Aplicamos transformación within.
2. Estimamos el modelo transformado por POLS.

Consideración: nueva forma del modelo transformado con sumas completas:

$$
\hat\beta =
\left(
N^{-1}\sum_{i=1}^N \sum_{t=1}^T s_{it}\ddot{x}_{it}'\ddot{x}_{it}
\right)^{-1}
\left(
N^{-1}\sum_{i=1}^N \sum_{t=1}^T s_{it}\ddot{x}_{it}'\ddot{y}_{it}
\right).
$$

Supuestos necesarios para FE en modelos truncados:

1. Exogeneidad estricta en el modelo que trabajamos ahora —nada nuevo, lo mismo que FE de siempre pero aplicado a nuestro contexto—:

$$
E(u_{it}\mid s_{it}, x_{it}, c_i) = 0 \qquad \forall t.
$$

2. No singularidad:

$$
\sum_{t=1}^T E\left(s_{it}\ddot{x}_{it}'\ddot{x}_{it}\right)
\quad \text{no singular.}
$$

3. Homocedasticidad y ausencia de correlación serial en los errores idiosincráticos:

$$
E(u_i'u_i\mid s_{it}, x_{it}, c_i) = \sigma^2 I_T.
$$

También podríamos calcular estimaciones robustas (Wooldridge, 1995); no es necesario el supuesto de homocedasticidad y ausencia de correlación serial.

El sesgo de selección muestral en el contexto del modelo de FE es un problema sólo si el mecanismo de selección está relacionado con los errores idiosincráticos, $u_{it}$.

### Conclusión

Si pensamos que en este modelo hay correlación entre que yo observe el salario y los errores —o sea, con todo lo que no puse explícitamente como variable explicativa— entonces me tengo que hacer la pregunta:

> ¿Hay algo que explícitamente no esté incluyendo en la ecuación que afecte el observar o no el salario de una persona?

Si la respuesta es sí, si no lo consideras entonces tenés una sobre/subestimación: sesgo hacia arriba/abajo.

¿Y en este modelo? El salario puede depender de:

- habilidad;
- género;
- raza o etnia;
- la decisión de trabajar.

La decisión de trabajar se ve afectada por factores que influyen en el salario de forma directa: trabajar $\leftrightarrow$ decisión de trabajar. Puedo pensar que observo los salarios más altos porque compensa la pérdida de mis 8 horas de ocio.

¿Esto implica que sólo podemos estimar por FE? **No.**

¿Podríamos estimar por RE? **Sí.**

¿Qué pasa si no estamos seguros de que exista un verdadero problema de truncamiento incidental? Tenemos tests/contrastes por sesgo de selección.

---

## b) Implemente el contraste de sesgo de selección propuesto por Wooldridge (1995) bajo el enfoque de Mundlak (1978)

Hay dos contrastes: Mundlak y Chamberlain. La diferencia está en las variables que incluyen en lo que será el primer paso. La base de ambos va a ser la extensión para panel propuesta por Wooldridge del modelo de Heckman. Lo detallamos a continuación.

El modelo del ejercicio:

$$
\ln(wage_{it}) = \beta_0 + \beta_1 exper_{it} + \beta_2 educ_{it} + c_i + u_{it}.
$$

Versión simple, similar a la de las slides:

$$
y_1 = x_1\beta_1 + u_1,
$$

$$
y_2 = \mathbf{1}[x\delta_2 + v_2 > 0].
$$

$(x,y_2)$ las observamos siempre. $y_1$ sólo la observo cuando $y_2 = 1$.

Supuestos:

$$
(u_1, v_2) \perp x,
$$

$$
v_2 \sim N(0,1),
$$

$$
E(u_1\mid v_2) = \gamma_1 v_2.
$$

Notemos que:

$$
E(y_1\mid x,v_2) = x_1\beta_1 + \gamma_1 v_2.
$$

Cuando $\gamma_1 = 0$, $(u_1,v_2)$ son incorrelacionados; no hay problema de sesgo de selección:

$$
E(y_1\mid x,v_2) = x_1\beta_1.
$$

Cuando $\gamma_1 \neq 0$, la ecuación con truncamiento incidental depende de la ecuación de selección, i.e. hay efectivamente truncamiento incidental.

$$
E(y_1\mid x, y_2 = 1) = x_1\beta_1 + \gamma_1 E(v_2\mid x, y_2 = 1),
$$

$$
E(y_1\mid x, y_2 = 1) = x_1\beta_1 + \gamma_1 h(x,y_2).
$$

¿Qué es esa función de $x,y_2$? Para responderlo primero pensemos: ¿qué es $y_2$? Es una dummy de la que siempre puedo tener información; por ejemplo, siempre puedo preguntar “¿Usted trabaja?” y traducirlo a una binaria. Funciona como una indicadora de cuándo voy a observar la primera ecuación, $y_1$.

Entonces,

$$
h(x,y_2) = h(x,1),
$$

me interesa cuando observe la variable $y_1$, que es mi interés en estimar.

$$
h(x,1) = E[v_2\mid v_2 > -x\delta_2]
= \text{inversa del coeficiente de Mills}.
$$

Bajo los supuestos de este modelo:

- $E(y_1\mid x,v_2)$, el salario condicional a que observamos el salario, depende no sólo de las variables observadas, sino también de un término que es la interacción entre $\gamma_1$ con la inversa del coeficiente de Mills.
- Cuando estimamos por FE estamos **omitiendo ese término de la derecha**.
- Podemos pensar en la presencia de sesgo de selección como un problema de variables omitidas.

Encontramos una forma de medir este sesgo de selección en la ecuación de interés. Falta ver cómo estimamos $\gamma_1$ para ver si es estadísticamente significativo o no.

Va a ser por una estimación de dos etapas:

1. Estimar un probit de la segunda ecuación y obtener la inversa del coeficiente de Mills.
2. Estimar la ecuación robusta de $y_1$ en las variables independientes y el coeficiente de Mills por FE, con la transformación within.
3. Analizar si el coeficiente estimado de la inversa del coeficiente de Mills es estadísticamente distinto de cero o no.
4. Si $\hat\gamma_1 = 0$, entonces no hay problema de sesgo de selección.
5. Si $\hat\gamma_1 \neq 0$, entonces hay sesgo de selección y la estimación la vemos la semana que viene.

Problema 2: ¿qué variables incorporamos en la primera etapa? Depende del enfoque que tomemos.

### Contraste de Mundlak

Ecuación de interés:

$$
y_{it} = x_{it}\beta + c_i + u_{it}. \tag{1}
$$

Y una ecuación de selección:

$$
s_{it} = \mathbf{1}\left[\eta_0 + \bar{x}_i\eta + x_{it}\delta + v_{it} > 0\right]. \tag{2}
$$

---

## c) Implemente el contraste de sesgo de selección propuesto por Wooldridge (1995) bajo el enfoque de Chamberlain (1980)

### Contraste de Chamberlain

Idem toda la intro del punto anterior. Ahora la ecuación del primer paso va a incluir:

$$
s_{it} = \mathbf{1}\left[\eta_0 + x_{it}\delta + x_{i,81}\eta_{81} + x_{i,82}\eta_{82} + x_{i,83}\eta_{83} + v_{it} > 0\right]. \tag{3}
$$

---

# Ejercicio 2 - Estimación por Wooldridge: corrección del sesgo de selección muestral

La corrección es relativamente similar al test:

1. Pooled probit.
2. POLS.

Sin embargo, hay que ser cuidadoso. Para que los estimadores sean consistentes debemos agregar supuestos de linealidad a los valores esperados de $u_{it}$ y $c_i$ dados $x_i$ y $v_{it}$:

1. La ecuación de selección está dada por la mencionada en el inciso anterior.
2. 

$$
E(u_{it}\mid x_i, v_{it}) = E(u_{it}\mid v_{it}) = \rho_u v_{it}, \qquad t = 1,\ldots,T.
$$

3. 

$$
E(c_i\mid x_i, v_{it}) = L(c_i\mid 1,\bar{x}_i,v_{it}),
$$

 donde $L(\cdot)$ es el operador proyección lineal.

El supuesto (c) implica que $c_i$ depende linealmente de $x_i$ sólo a través del promedio temporal:

$$
E(c_i\mid \bar{x}_i,v_{it}) = \pi_0 + \bar{x}_i\pi + \phi v_{it}. \tag{14}
$$

Tomando esperanzas condicionales en la ecuación de interés:

$$
\begin{aligned}
E(y_{it}\mid x_i,v_{it})
&= x_{it}\beta + E(c_i\mid x_i,v_{it}) + E(u_{it}\mid x_i,v_{it}) \\
&= x_{it}\beta + \pi_0 + \bar{x}_i\pi + \phi v_{it} + \rho v_{it} \\
&= x_{it}\beta + \bar{x}_i\pi + \gamma v_{it}.
\end{aligned} \tag{15}
$$

Luego, condicionando en $s_{it}=1$:

$$
\begin{aligned}
E(y_{it}\mid x_i,s_{it}=1)
&= \pi_0 + x_{it}\beta + \bar{x}_i\pi + \gamma E(v_{it}\mid x_i,s_{it}=1) \\
&= \pi_0 + x_{it}\beta + \bar{x}_i\pi + \gamma E(v_{it}\mid x_i, v_{it}>-\pi_0-\bar{x}_i\pi-x_{it}\delta) \\
&= x_{it}\beta + \bar{x}_i\pi + \gamma\lambda(x_{it},\bar{x}_i).
\end{aligned} \tag{16}
$$

La última ecuación nos lleva al siguiente procedimiento a partir del cual podemos estimar $\beta$ de forma consistente:

1. Primero, estimar la ecuación de selección por pooled probit a través de $i$ y $t$ y luego estimar la inversa del cociente de Mills, $\hat\lambda_{it}$, para todo $i$ y $t$:

$$
\hat\lambda_{it}
=
\frac{\phi(x_{it}\hat\delta + \bar{x}_i\hat\pi + \hat\pi_0)}
{\Phi(x_{it}\hat\delta + \bar{x}_i\hat\pi + \hat\pi_0)}, \tag{17}
$$

 donde $\phi(\cdot)$ y $\Phi(\cdot)$ son la densidad y la distribución acumulada de la normal estándar, respectivamente.

2. Estimar por POLS:

$$
y_{it}
\quad \text{sobre} \quad
x_{it},\ \bar{x}_i,\ d_1\hat\lambda_{it},\ d_2\hat\lambda_{it},\ldots, d_T\hat\lambda_{it},
\qquad \forall s_{it}=1. \tag{18}
$$

Si se piensa que $\gamma$ en la ecuación de la esperanza condicional de $y_{it}$ es constante a través del tiempo, entonces hay que incluir solamente $\hat\lambda_{it}$ en la ecuación del segundo paso.

## Con respecto a los errores

Si las pruebas por sesgo de selección estimaban la segunda etapa robusta es porque hay problemas en la matriz de varianzas y covarianzas. La varianza asintótica de los estimadores de la segunda etapa debe ser corregida por la heterocedasticidad inducida por el hecho de que $\hat\lambda_{it}$ es un estimador de la variable generada.

Estas correcciones pueden realizarse utilizando las fórmulas que aparecen en Wooldridge (1995). Alternativamente, se pueden estimar los errores estándar vía bootstrap. Más sobre esto la clase que viene.

---

# Mapeo preliminar contra el mapa 2023

- **Contenido visible:** PS4, ejercicio 1 completo y ejercicio 2 incisos a) y b), con paneles no balanceados, attrition, truncamiento incidental, test de sesgo de selección de Wooldridge bajo Mundlak y Chamberlain, y comienzo de corrección del sesgo de selección muestral.
- **Match con mapa 2023:** encaja fuertemente con `P07 -> PS4: ex1 + ex2 hasta bootstrap/comentarios`.
- **Diagnóstico:** la paridad 2026-2023 se sostiene en esta clase. La clase termina justamente anticipando bootstrap/errores para la clase siguiente, lo cual conecta naturalmente con el mapa 2023 de `P08 -> PS4 ex2 varianza analítica; PS5 ex1(a-c)`.
