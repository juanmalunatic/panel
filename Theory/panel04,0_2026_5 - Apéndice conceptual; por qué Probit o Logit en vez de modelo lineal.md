# Corte Transversal

Una variable binaria, es una variable que solo adopta dos valores (que por convención se denotan 0 y 1).

Por ejemplo, la empresa Sony quiere saber si la venta de sus televisiones esta relacionada con el ingreso de las personas. Para esto, toma una muestra de 100 personas que en el último semestre compró un televisor y registra los valores de las siguientes variables:

$$
Y = 1 \text{ si la persona compró un televisor Sony.}
$$

$$
Y = 0 \text{ si la persona compró otra marca de TV.}
$$

Además, registra para cada persona en la muestra el valor del salario horario.

La empresa especifica la siguiente relación funcional:

$$
Y_i = \alpha + \beta X_i + \varepsilon_i; \quad i = 1, 2, ..., 100.
$$

---

# Corte Transversal

Donde $X_i$ representa el logaritmo natural del salario horario.

La idea de la firma es que si pudiera saber los valores de los parámetros del modelo entonces podría conocer si existe una asociación directa o inversa entre lo que gana la gente y la compra de sus televisores.

Como primera aproximación al tema veamos un diagrama de dispersión de las variables.

---

# Corte Transversal

Se tiene el siguiente diagrama de dispersión:

> **Descripción de la figura.** El gráfico muestra un diagrama de dispersión con $\ln(\text{salario horario})$ en el eje horizontal y una variable binaria de compra de TV Sony en el eje vertical. Las observaciones solo aparecen en dos bandas horizontales: $y = 0$ para quienes no compraron Sony y $y = 1$ para quienes sí compraron Sony. La mayor parte de los puntos está en $y = 0$ a lo largo de casi todo el rango de salarios, mientras que los pocos puntos con $y = 1$ se concentran en valores relativamente altos de $X$. La función de la figura es mostrar visualmente que la variable dependiente es binaria y que parece haber una asociación positiva entre salario y compra de televisores Sony, aunque todavía sin imponer una forma funcional de probabilidad.

---

# Corte Transversal

Observando el gráfico de dispersión la empresa piensa que si bien hay evidencia de que la gente que compra sus televisores en general está ubicada en el sector de mayores ingresos necesita mayor información para poder segmentar el mercado.

Esto es, si pudiera estimar los parámetros del modelo quizás pudiera distinguir a un nuevo cliente potencial.

Utilizando el método de mínimos cuadrados clásicos, la empresa estima el modelo y obtiene los siguientes resultados:

$$
\hat{Y}_i = 0.08 + 0.087 X_i, \quad i = 1, 2, ..., 100,
$$

con valores $t$ 3.2 y 3.4 respectivamente.

---

# Modelos de Respuesta Binaria

Esto es, existe una relación directa (positiva) entre el salario y la compra de televisores Sony como se apreciaba en el gráfico de dispersión.

> **Descripción de la figura.** La figura repite el diagrama de dispersión binario de la variable de compra contra $X$, pero ahora agrega una recta de ajuste lineal ascendente. La recta tiene pendiente positiva, capturando la asociación directa entre salario y compra, pero también muestra el problema central del modelo de probabilidad lineal: para valores bajos de $X$ la recta cae por debajo de cero, generando valores ajustados negativos para una variable que debe interpretarse como probabilidad. La función de la figura es ilustrar que aunque MCC detecta una relación positiva, la forma lineal no respeta el rango natural $[0,1]$ de una probabilidad.

---

# Corte Transversal

Como puede observarse claramente en el gráfico anterior, el problema con esta estimación es que hay muchos valores ajustados para la variable dependiente que son NEGATIVOS!

Esta es una consecuencia del método de estimación elegido, ya que MCC no contiene ninguna restricción que nos diga que la estimación de la variable dependiente siempre tiene que ser cero o uno.

El problema anterior puede re-plantearse de la siguiente manera. Cuál es la probabilidad de que una persona compre un televisor Sony, dado el valor de su salario horario?

Evidentemente, en la muestra de 100 personas es poco probable que alguien pueda responder a esa pregunta. Sin embargo, podemos observar el valor de esta probabilidad ex-post.

---

# Corte Transversal

Es decir, una persona ex-post o compró el televisor Sony (probabilidad de realización igual a uno) o no lo compró (probabilidad de realización igual a cero).

Esto significa que lo que observamos es la realización de una variable no observable (la probabilidad de compra del televisor Sony).

Observe que si la empresa pudiera conocer la probabilidad ex-ante, entonces podría segmentar el mercado con esta probabilidad.

Es decir que a nosotros nos interesa el valor de la probabilidad ex-ante. Esto es:

$$
\Pr(y_i = 1 \mid X_i)
$$

Notemos que de acuerdo al modelo especificado anteriormente tenemos:

$$
Y_i = \alpha + \beta X_i + \varepsilon_i
$$

---

# Corte Transversal

Por lo tanto tenemos que:

$$
(1) \quad E(Y_i \mid X_i) = \alpha + \beta X_i + E(\varepsilon_i \mid X_i) = \alpha + \beta X_i
$$

Además, sabemos que por definición de esperanza matemática, la esperanza matemática condicional de una variable es la suma de cada uno de los valores que adopta la variable multiplicados por su probabilidad de ocurrencia.

En este caso se tiene que:

$$
(2) \quad E(Y_i \mid X_i) = 1 * P(Y_i = 1 \mid X_i) + 0 * P(Y_i = 0 \mid X_i)
$$

$$
= P(Y_i = 1 \mid X_i)
$$

Igualando las ecuaciones (1) y (2) tenemos:

$$
(3) \quad P(Y_i = 1 \mid X_i) = \alpha + \beta X_i
$$

---

# Corte Transversal

Como puede observarse en la ecuación (3) la probabilidad condicional de que el evento $Y_i$ ocurra (en este caso la compra de la televisión Sony) dado que conocemos el valor de $X_i$ esta expresada como una relación lineal.

Debido a este hecho, los modelos de variable dependiente binaria reciben el nombre de Modelos de Probabilidad Lineal.

Dado que $Y_i$ solo puede adoptar dos valores (cero ó uno) podemos obtener la distribución de probabilidad de la variable $Y_i$ ilustrada con la siguiente tabla a continuación:

| $Y_i$ | $\Pr(Y_i \mid X_i)$ |
|---:|---:|
| $1$ | $\alpha + \beta X_i$ |
| $0$ | $1 - (\alpha + \beta X_i)$ |

---

# Corte Transversal

Dada la distribución de la variable dependiente podemos utilizar el modelo para obtener la distribución de los errores.

Esto es, como

$$
Y_i = \alpha + \beta X_i + \varepsilon_i,
$$

cuando:

$$
y_i = 1 \rightarrow \varepsilon_i = 1 - \alpha - \beta X_i
$$

y cuando

$$
y_i = 0 \rightarrow \varepsilon_i = -\alpha - \beta X_i.
$$

Por lo tanto se tiene la siguiente tabla:

| $\varepsilon_i$ | $\Pr(Y_i \mid X_i)$ |
|---:|---:|
| $1 - \alpha - \beta X_i$ | $\alpha + \beta X_i$ |
| $-\alpha - \beta X_i$ | $1 - (\alpha + \beta X_i)$ |

Cuáles son los momentos de esta distribución?

$$
E(\varepsilon_i \mid X_i) = [1 - (\alpha + \beta X_i)](\alpha + \beta X_i) - (\alpha + \beta X_i)[1 - (\alpha + \beta X_i)] = 0
$$

---

# Corte Transversal

Y por otro lado, la varianza:

$$
\operatorname{Var}(\varepsilon_i \mid X_i) = E(\varepsilon_i^2 \mid X_i) - E(\varepsilon_i \mid X_i)^2 = E(\varepsilon_i^2 \mid X_i)
$$

$$
= [1 - (\alpha + \beta X_i)] * (\alpha + \beta X_i)
$$

Entonces, cuando la variable dependiente es binaria, el modelo tiene heterocedasticidad.

Esto puede generalizarse a cualquier modelo que tenga por variable dependiente una variable categórica.

Ahora podemos resumir las características de los modelos de probabilidad lineal (MPL):

1. Estos modelos reciben este nombre porque la variable dependiente puede interpretarse como una probabilidad.
2. Los valores estimados, por el método de MCC, de la variable dependiente pueden caer fuera del rango $[0, 1]$ lo cual hace que la estimación sea pobre.
3. Los errores del modelo son heterocedásticos por lo tanto MCC nos dará estimadores ineficientes.

---

# Corte Transversal

Otro de los problemas que sufren los modelos de probabilidad lineal es el de la interpretación.

En nuestro caso particular el coeficiente $\beta$ mide cuanto afecta a la probabilidad de comprar un televisor Sony un cambio en el salario de las personas.

Económicamente uno pensaría que este efecto debiera ser pequeño para aquellos que ganan muy poco o ganan mucho y debiera ser más grande para el resto.

Sin embargo, en el MPL el efecto es constante e igual a $\beta$ lo que no coincide con lo que se desprende de la teoría económica.

Cómo podríamos resolver este problema de interpretación y los problemas estadísticos?

---

# Corte Transversal

Lo que necesitamos es una función de probabilidad que no sea lineal. Esto es:

> **Descripción de la figura.** La figura compara, sobre el mismo diagrama de dispersión binario, la recta del modelo de probabilidad lineal con una curva no lineal en forma de “S”. La recta lineal sigue teniendo pendiente constante y puede salirse del rango admisible de probabilidad, mientras que la curva sigmoide empieza cerca de cero, aumenta con mayor pendiente en la zona intermedia de $X$ y se aplana al acercarse a uno. La función de la figura es motivar el uso de funciones de distribución acumulada —como la normal en Probit o la logística en Logit— para modelar probabilidades: estas curvas restringen las predicciones al intervalo $[0,1]$ y permiten efectos marginales distintos según el nivel de $X$. La anotación $\beta$ junto a la recta enfatiza que en el modelo lineal la pendiente es constante, a diferencia de la curva no lineal.

---

# Corte Transversal

Las características de la curva de la figura anterior resuelve nuestros problemas ya que:

1. Empieza en cero y termina en uno. Esto es, solo adopta valores en el intervalo $[0, 1]$.
2. Tiene diferentes pendientes en distintos puntos. Para valores muy pequeños y muy grandes de $X_i$ la pendiente es chica y para valores intermedios de $X_i$ la pendiente es más grande.

Cualquier curva de probabilidad acumulada cumple con las características antes mencionadas.

Por lo tanto, uno puede especificar el modelo utilizando la función de probabilidad acumulada de cualquier distribución.

Las funciones más utilizadas son la distribución Normal y la distribución Logística. Back
