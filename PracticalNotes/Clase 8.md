# Clase 8 - PS4 parte 2 - Ejercicio 2

> Transcripción a partir de notas manuscritas. Se preserva la notación del manuscrito y se regulariza mínimamente la sintaxis LaTeX para que sea consistente con las notas anteriores de PS4/Wooldridge.

---

## Repaso de la clase pasada

Ecuación de interés:

$$
y_1 = x_1\beta_1 + u_1.
$$

Ecuación de selección:

$$
y_2 = \mathbf{1}\left[x\delta_2 + v_2 > 0\right].
$$

- Si $y_2 = 1$, observo $y_1$; si no, no.
- $x$ e $y_2$ siempre los observo.
- $u_1$ y $v_2$ son independientes de $x$ y normales de media cero.
- 

$$
E(u_1\mid v_2) = \gamma_1 v_2.
$$

Si

$$
\gamma_1 = 0,
$$

no hay problema:

$$
E(y_1\mid x, v_2) = x_1\beta_1.
$$

Los errores están incorrelacionados: lo que explica que $y_2 = 1$ o $y_2 = 0$, más allá de mis variables $x$, y lo que explica que observe $y_1$, más allá de $x$, no correlacionan.

Si

$$
\gamma_1 \neq 0,
$$

entonces

$$
E(y_1\mid x, v_2) = x_1\beta_1 + E(u_1\mid v_2).
$$

Hay un impacto de la ecuación de selección en la ecuación de interés. Si lo ignoro, genero un problema de sesgo por variables omitidas, y por lo tanto inconsistencia.

En esto nos complicamos la clase pasada: vimos el método de Wooldridge con el enfoque de Mundlak o Chamberlain para estimar vía Probit la ecuación de selección con más o menos variables, construir la inversa del coeficiente de Mills e incorporarla en la ecuación de interés para testear la significatividad de $\gamma_1$.

---

## Estimación de $\hat\beta$ bajo enfoque de Mundlak

Enfoque de Mundlak $\Rightarrow$ computamos menos grados de libertad.

Modelo:

$$
y_{it} = x_{it}\beta + c_i + u_{it}, \tag{1}
$$

$$
s_{it} = \mathbf{1}\left[\eta_0 + \bar{x}_i\eta + x_{it}\delta + v_{it} > 0\right]. \tag{2}
$$

- Tomo (2), estimo por Probit y genero la inversa del coeficiente de Mills.
- Hago POLS sobre (1), transformada según Mundlak: variables en nivel, medias temporales e inversa del coeficiente de Mills. Entonces tengo un coeficiente estimado para cada año.

La ecuación estimada queda de la forma:

$$
y_{it} = x_{it}\beta + \bar{x}_i\eta + \delta_t\hat\lambda_{it}.
$$

Esto rompe la matriz de varianzas y covarianzas. La varianza va a estar formada por:

1. el componente usual,

$$
\sigma^2(X'X)^{-1},
$$

en términos de econometría de corte transversal; y

2. un segundo término adicional por la influencia de la estimación del primer paso en el segundo.

---

## ¿Cómo hacemos esto?

### 1. Bootstrap

De tu muestra calculas los $\hat\beta$. Tomas esa muestra y haces $n$ remuestreos con reposición. Para cada submuestra vuelves a calcular los $\hat\beta$. Haces esto la cantidad de veces que quieras. De tu lista de $\hat\beta$ bootstrappeados puedes calcular el error estándar y demás:

$$
\widehat{se}(\hat\beta)_{boot}
=
\sqrt{\operatorname{Var}\left(\hat\beta_{(1)},\hat\beta_{(2)},\ldots\right)}.
$$

Si es tan fácil, ¿por qué vamos a ver otra alternativa? Porque sólo funciona para individuos iid. Si hay sesgo de selección, la muestra ya no es aleatoria: hay un factor que está en el término de error de la ecuación de selección y de la ecuación de interés, y que determina que algunos individuos tengan datos completos y otros no.

### 2. Cálculo de varianza asintótica

Slide 31 de los teóricos:

$$
\operatorname{Avar}(\hat\theta)
=
\hat A^{-1}\hat B\hat A^{-1}/N.
$$

Esto lo tenemos que asumir. Vamos paso a paso y lo traducimos al código. Ya tenemos los puntos a) y b).

Primero:

$$
\hat A
=
\sum_i\sum_t s_{it}\hat w_{it}'\hat w_{it},
$$

con

$$
\hat w_{it}
=
\left(1,\bar{x}_i,x_{it},0,\ldots,0,\hat\lambda_{it},0,\ldots,0\right).
$$

Es como un $X'X$ de MCO porque es el producto de mis variables explicativas. Sólo que ahora tengo que agregar una indicadora para detectar que tengo la información disponible.

Luego:

$$
\hat B
=
N^{-1}\sum_{i=1}^N \hat p_i\hat p_i'.
$$

con

$$
\hat p_i = \hat q_i - \hat D\hat r_i.
$$

El término $\hat r_i$ es menos la inversa del Hessiano promedio multiplicada por la función score que sale del log de la función de verosimilitud del Probit.

También:

$$
\hat D
=
N^{-1}\sum_{i=1}^N\sum_{t=1}^T
s_{it}\hat w_{it}'\hat\theta\,G_{it}.
$$

donde

$$
G_{it}
=
\begin{bmatrix}
0 & \cdots & 0\\
0 & \cdots & z_{it}
\end{bmatrix},
\qquad
z_{it} = (0,\ldots,\lambda_{it}h_t).
$$

Esta es una matriz que armo para que se vaya activando y desactivando a medida que voy sumando sobre los $t$ e $i$.

Pensar en econometría o en la primera parte de datos de panel: en FGLS, $\hat\Omega$ era un ponderador. Acá estamos armando lo mismo, sólo que con la complicación adicional de que uno de los componentes de la matriz ya viene de una estimación, y esa estimación es un Probit.

Definimos:

$$
\hat q_i
=
\sum_{t=1}^T s_{it}\hat w_{it}\hat e_{it},
$$

con residuos de la segunda etapa:

$$
\hat e_{it} = y_{it} - \hat w_{it}\hat\theta.
$$

Esto es aproximadamente como $X_i'\hat u_i$.

Volviendo a $\hat B$:

$$
\hat B
=
N^{-1}\sum_{i=1}^N \hat p_i\hat p_i'
$$

$$
=
N^{-1}\sum_{i=1}^N
\left(\hat q_i - \hat D\hat r_i\right)
\left(\hat q_i - \hat D\hat r_i\right)'
$$

$$
=
N^{-1}\sum_{i=1}^N
\left[
\hat q_i\hat q_i'
+
\hat D\hat r_i\hat r_i'\hat D'
-
\hat q_i\hat r_i'\hat D'
-
\hat D\hat r_i\hat q_i'
\right].
$$

En el código aparecen estos términos como:

- término 1: $\hat q_i\hat q_i'$;
- término 4: $\hat D\hat r_i\hat r_i'\hat D'$;
- término 2: $\hat q_i\hat r_i'\hat D'$;
- término $2'$: $\hat D\hat r_i\hat q_i'$.

En el caso usual, cuando todo funciona bien:

$$
E(X'\hat u\hat u'X)
=
X'E(\hat u\hat u')X
=
\sigma^2(X'X).
$$

Entonces normalmente tendría sólo un término, y la varianza asintótica sería:

$$
\operatorname{Avar}(\hat\theta)
=
\hat A^{-1}\hat B\hat A^{-1}
=
(X'X)^{-1}\sigma^2(X'X)(X'X)^{-1}
=
\sigma^2(X'X)^{-1}.
$$

Esta es la varianza usual cuando todo funciona bien, como en los primeros temas de datos de panel.

---

# Mapeo preliminar contra el mapa 2023

- **Contenido visible:** continuación de PS4, ejercicio 2, con repaso del modelo de selección, enfoque de Mundlak, inversa de Mills, bootstrap y varianza asintótica corregida por el primer paso Probit.
- **Match con mapa 2023:** coincide con la primera parte de `P08 -> PS4: ex2 varianza analítica`.
- **Diagnóstico:** en estas notas no aparece todavía PS5. Entonces, si este PDF es la totalidad de la clase 8, el mapeo 2026 visible sería más estrecho que el mapa 2023: `Clase 8 -> PS4 Ej. 2, varianza/bootstrap`. Si hay otra parte de clase o notas complementarias, podría aparecer allí PS5 Ej. 1(a-c).
