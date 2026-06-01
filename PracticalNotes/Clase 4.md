# Clase 4 - Datos de Panel 2025

**Fecha:** 12 de abril de 2025

> Notas de clase provisorias y en revisión. Cualquier duda: iaralening@gmail.com

La clase de hoy consta en trabajar sobre los ejercicios 2 y 3 del PS2.

En este problem set abandonamos la estimación por POLS por considerar que el modelo es del estilo

\[
y_{it} = x_{it}\beta + u_{it} + c_i.
\]

Llamamos a \(c_i\) heterogeneidad no observada. Al ser un efecto no observado y constante en el tiempo, la estimación por POLS tendría problemas de endogeneidad.

Ahora estimaremos por métodos que consideren nuestro modelo. Tendremos dos alternativas según cómo pensemos que nuestras variables explicativas y la heterogeneidad inobservable se relacionan:

- **Efecto Aleatorio:** es lo mismo a decir que no se relacionan las variables.
- **Efecto Fijo:** existe correlación distinta de cero.

## Random Effects

Al no haber relación entre \(x_{it}\) y \(c_i\), podemos construir un **error compuesto**:

\[
v_{it} = c_i + u_{it}.
\]

Para la estimación utilizamos FGLS (ver Slides 1 de las clases teóricas para entender esto en mayor detalle).

\[
\widehat{\Omega} = \widehat{\sigma}_c^2 J_T J_T' + \widehat{\sigma}_u^2 I_T.
\]

El correspondiente estimador de interés será de la forma

\[
\widehat{\beta}_{RE}
=
\left(\sum_{i=1}^{N} X_i'\widehat{\Omega}^{-1}X_i\right)^{-1}
\left(\sum_{i=1}^{N} X_i'\widehat{\Omega}^{-1}Y_i\right).
\]

Y la forma de la varianza que ya vieron en las slides.

## Fixed Effects

Este modelo asume que

\[
\operatorname{cov}(c_i, x_{it}) \neq 0,
\]

de esto se desprende que

\[
E(v_i \mid X_i) \neq 0,
\]

es decir, una o más variables explicativas están correlacionadas con el error compuesto, por lo que la estimación por RE daría como resultado estimaciones inconsistentes.

Para la estimación por FE:

- Pagamos el costo de no poder incluir términos constantes en el tiempo (observables) como variables explicativas.
- Tenemos que transformar el modelo para perder \(c_i\). Hay distintas transformaciones posibles:

1. **Within:** se promedia la ecuación en el tiempo, se obtienen las medias temporales. Notar que la media temporal de la variable constante en el tiempo es fija (no varía cuando cambia \(t\)). Se resta miembro a miembro la media temporal. Se estima la ecuación transformada por OLS. Se debe hacer el ajuste de los grados de libertad de los errores estándar para que la inferencia sea válida (si no, son más pequeños que los verdaderos).

2. **Modelo con variables binarias:** podemos intentar estimar \(c_i\). Para ello incluyo una dummy que se active para cada observación del corte transversal. El estimador de la varianza de este modelo es correcto (no necesita corrección de los GL). **Problema:** los estimadores de \(c_i\), aunque insesgados, no son consistentes.

3. **First Differences:** restamos miembro a miembro al modelo su rezago. Como \(c_i\) es constante, "desaparece".

Todos los casos requieren de **exogeneidad estricta en los errores idiosincráticos**, es decir, en el error del modelo original. En muchos casos esto implicará exogeneidad contemporánea en los errores del modelo transformado.

**OJO con el uso de Stata:** cuando hacemos manualmente la transformación within tenemos que ajustar los grados de libertad manualmente para llegar a conclusiones correctas. Cuando usamos `xtreg, fe`, Stata ya lo ajusta por nosotros. Más info sobre este ajuste en el siguiente link:

<https://www.stata.com/support/faqs/statistics/intercept-in-fixed-effects-model/>

## Two ways fixed effect

Especificación que se desprende del estimador de efectos fijos. Considera que existen dos tipos de efectos constantes:

1. **Efecto fijo en el corte transversal:** valor que no cambia entre las \(i\)'s del modelo, \(c_i\).
2. **Efecto fijo en el tiempo:** controla por efectos idiosincráticos para todos los individuos para diferentes momentos del tiempo. Ejemplos podrían ser si el PIB creció ese año, la temperatura promedio en la región, las precipitaciones, etc.

## Aclaraciones sobre el ejercicio 1

En clases anteriores (en particular en el ej. 1 del PS2) usamos la regresión de POLS clustereando por id. Aclaremos un poco sobre lo que estamos haciendo acá:

Cuando construyo la matriz de varianzas y covarianzas, la estructura es del tipo \(\operatorname{var}\_id.t\):

\[
\begin{array}{c|cccc}
& u_{11} & u_{12} & u_{21} & u_{22} \\
\hline
u_{11} & \operatorname{var}(u_{11}) & \operatorname{cov}(u_{11},u_{12}) & \operatorname{cov}(u_{11},u_{21}) & \operatorname{cov}(u_{11},u_{22}) \\
u_{12} & \operatorname{cov}(u_{12},u_{11}) & \operatorname{var}(u_{12}) & \operatorname{cov}(u_{12},u_{21}) & \operatorname{cov}(u_{12},u_{22}) \\
u_{21} & \operatorname{cov}(u_{21},u_{11}) & \operatorname{cov}(u_{21},u_{12}) & \operatorname{var}(u_{21}) & \operatorname{cov}(u_{21},u_{22}) \\
u_{22} & \operatorname{cov}(u_{22},u_{11}) & \operatorname{cov}(u_{22},u_{12}) & \operatorname{cov}(u_{22},u_{21}) & \operatorname{var}(u_{22})
\end{array}
\]

Se pueden ir construyendo "bloquecitos" por cada \(id\). Si no uso clusters y asumo ausencia de correlación serial, la matriz sería de este estilo:

\[
\begin{array}{c|cccc}
& u_{11} & u_{12} & u_{21} & u_{22} \\
\hline
u_{11} & \operatorname{var}(u_{11}) & 0 & 0 & 0 \\
u_{12} & 0 & \operatorname{var}(u_{12}) & 0 & 0 \\
u_{21} & 0 & 0 & \operatorname{var}(u_{21}) & 0 \\
u_{22} & 0 & 0 & 0 & \operatorname{var}(u_{22})
\end{array}
\]

Ahora, si asumo que existe correlación serial asociada a la heterogeneidad no observada, la matriz de VCOV es del estilo:

\[
\begin{array}{c|cccc}
& u_{11} & u_{12} & u_{21} & u_{22} \\
\hline
u_{11} & \sigma_1^2 & \gamma_{12} & 0 & 0 \\
u_{12} & \gamma_{21} & \sigma_1^2 & 0 & 0 \\
u_{21} & 0 & 0 & \sigma_2^2 & \gamma_{21} \\
u_{22} & 0 & 0 & \gamma_{21} & \sigma_2^2
\end{array}
\]

Cuando añado `, vce(clusterid)` en el comando `reg`, estoy indicando que

\[
\gamma_{i1} = \gamma_{1i} \neq 0
\]

para cada \(i\) del corte transversal.

## Ejercicio 2

Utilice la base de datos provista `murder.dta`. La base de datos es una muestra longitudinal de estados de EE.UU., para los años 1987, 1990 y 1993.

### a)

Estime por OLS el efecto de las ejecuciones (\(x\)) sobre la tasa de homicidios (*murder rates*, \(m\)) controlando por desempleo (\(u\)) y año:

\[
m_{i,t} = \alpha + \beta_1 x_{i,t} + \beta_2 u_{i,t} + \beta_{90}d90_t + \beta_{93}d93_t + \nu_{i,t}.
\]

Note que se omitió la dummy temporal para el año 1987. Interprete los resultados.

**Comentarios.** Primero, se omite \(d87\) para evitar multicolinealidad perfecta, igual que en econometría.

Buenas prácticas: no interpretar coeficientes que no sean estadísticamente significativos. Interpretar como lo que es: un cero, un no efecto de la variable explicativa sobre la explicada.

### d)

Estime por FD el modelo:

\[
m_{i,t} = \alpha + \beta_1 x_{i,t} + \beta_2 u_{i,t} + \beta_{90}d90_t + \beta_{93}d93_t + \varepsilon_{i,t} + c_i.
\]

Acerca de este inciso, primero siempre que estimemos un modelo con FD la regresión sobre el modelo transformado no debe incluir constante. Luego, si corremos el modelo tomando la primera diferencia a las dummies temporales nos va a salir error en Stata. Para entender el problema (y construir las variables correctamente a mano), pensemos que para una unidad del corte transversal tendremos:

| id | t  | d90 | d93 |
|---:|---:|----:|----:|
| 1  | 87 | 0   | 0   |
| 1  | 90 | 1   | 0   |
| 1  | 93 | 0   | 1   |

¿Qué implica en este contexto la primera diferencia de las dummies de los años? Tomemos al año 90 como ejemplo. Eso implica tomar la columna `d90` de la base:

\[
\begin{aligned}
87: \quad & d90_{87} - d90_{\text{pre87}} = 0 - . = . \\
90: \quad & d90_{90} - d90_{87} = 1 - 0 = 1 \\
93: \quad & d90_{93} - d90_{90} = 0 - 1 = -1.
\end{aligned}
\]

Ahora tomando la columna `d93` tendremos:

\[
\begin{aligned}
87: \quad & d93_{87} - d93_{\text{pre87}} = 0 - . = . \\
90: \quad & d93_{90} - d93_{87} = 0 - 0 = 0 \\
93: \quad & d93_{93} - d93_{90} = 1 - 0 = 1.
\end{aligned}
\]

Las construimos a mano como mostramos en el do-file.

### e)

Brinde un ejemplo bajo el cual la variable de ejecuciones no sería estrictamente exógena.

Las decisiones de política podrían generar problemas de causalidad simultánea, donde se exigieran penas más duras (mayor cantidad de ejecuciones o penas de muerte) por ver un aumento en la cantidad de asesinatos cada 100.000 habitantes. De esta forma la variable explicativa en la ecuación original sería la dependiente en la nueva ecuación de política y la dependiente en el modelo original ahora pasaría a ser explicativa. Esto rompe la exogeneidad estricta. Recuerden que se trata de exogeneidad de los errores del modelo original y de las variables explicativas con \(c_i\).

### f) Test de Hausman

Bajo \(H_0\) no hay correlación serial, tanto RE como FE son consistentes. El p-valor asociado es muy grande porque el denominador del estadístico es muy pequeño (tiende a cero), por lo que las estimaciones por ambos métodos no son significativamente distintas (\(\widehat{\beta}_{FE} - \widehat{\beta}_{RE}\) está en el numerador).

Un par de consideraciones adicionales: el test de Hausman no considera la constante de los modelos en su cómputo. Wooldridge nos advierte, además, que no podemos incluir variables constantes en el tiempo en el test, generan problema de singularidad en la matriz de VCOV asintótica. **En el test de Hausman solo podemos incluir variables que exhiban variabilidad en el corte transversal y en el tiempo.**

---

# Notas de transcripción y consistencia

- El archivo original tiene texto digital y fue corroborado contra render/OCR visual. La extracción automática confundía algunos símbolos, especialmente en ecuaciones; la versión de arriba usa la notación econométrica consistente con las clases anteriores: \(y_{it}\), \(x_{it}\), \(u_{it}\), \(c_i\), \(\widehat{\Omega}\), \(I_T\), \(J_T\), FE/RE/FD.
- El propio documento dice **"Clase 4 - Datos de Panel 2025"** y fecha **12 de abril de 2025**. Lo transcribí así. Si este set está mezclado con materiales 2026, conviene marcarlo como fuente digital 2025 usada para contraste, no como evidencia manuscrita directa de 2026.
- En la sección del **test de Hausman**, el texto dice "Bajo \(H_0\) no hay correlación serial". Conceptualmente, para el Hausman FE vs RE lo esperable sería "bajo \(H_0\), no hay correlación entre \(c_i\) y los regresores / RE es consistente". Dejé la frase de la nota en la transcripción, pero la marcaría como posible error conceptual/redaccional del apunte.
- En el inciso d), el PDF renderiza la ecuación con un símbolo de error poco claro antes de \(i,t\). Se normalizó como \(\varepsilon_{i,t}\), consistente con el modelo de panel \(m_{i,t}=\dots+\varepsilon_{i,t}+c_i\).

# Mapeo contra el mapa de prácticas 2023

Mapa 2023 relevante:

- **P03 -> PS2:** ex1, ex2
- **P04 -> PS2:** ex3, ex4

Diagnóstico para este set:

- La nota se presenta como **Clase 4** y dice explícitamente que trabaja sobre **PS2 ejercicios 2 y 3**.
- El contenido visible cubre claramente:
  - repaso de RE/FE/FD;
  - aclaraciones sobre **PS2 Ej. 1** y clusters;
  - **PS2 Ej. 2**, base `murder.dta`, incisos a), d), e), f);
  - test de Hausman.
- No aparece en estas 5 páginas un desarrollo claro de **PS2 Ej. 4**. Tampoco aparece un encabezado explícito de **Ejercicio 3**, aunque el texto inicial dice que se trabajaría sobre ejercicios 2 y 3.

Conclusión provisoria: este set **no calza perfectamente** con el mapa 2023 si lo tratamos como P04 puro. Parece más bien una clase de cierre/continuación de **PS2 Ej. 2** con posible entrada o referencia a Ej. 3, pero no evidencia completa de PS2 ex3-ex4. Si esta fuente es efectivamente 2025, no la usaría todavía para reorganizar fuerte el mapa 2026; la usaría como evidencia de que el ritmo puede ser más lento o de que el documento está incompleto respecto del contenido anunciado.
