# Universidad Torcuato Di Tella

**Maestría en Economía y Econometría**  
**2022**

# Datos de Panel

## Problem Set 0

### Repaso OLS, GLS & FGLS

### Lectura y resumen de datos de panel en Stata

1. Considere el siguiente modelo de regresión:

$$
\text{ltotexp}_i = \beta_0 + \beta_1 \text{suppins}_i + \beta_2 \text{phylim}_i + \beta_3 \text{actlim}_i + \beta_4 \text{totchr}_i + \beta_5 \text{age}_i + \beta_6 \text{female}_i + \beta_7 \text{income}_i + u_i,
$$

$$
i = 1, \ldots, N
$$

   a) Use la base de datos `mus03data.dta`, la cual contiene datos de corte transversal de gastos médicos, para estimar la ecuación por OLS usando comandos de matrices en Stata. Adicionalmente, reporte los errores estándar usuales de OLS y los estadísticos $t$ asociados.

   b) Utilice el comando `regress` para verificar los resultados obtenidos.

   c) Implemente un test de significatividad individual para `totchr`.

   d) Implemente un test de significatividad conjunta para todas las variables del modelo, excluyendo el intercepto.

2. En este ejercicio vamos a aprender cómo setear los datos como panel en Stata y cómo generar estadísticas descriptivas del panel. Adicionalmente, veremos cómo convertir los datos de wide form a long form y cómo generar un panel para simulaciones.

   a) Utilice la base `mus08psidextract.dta` y describa la base de datos de la manera usual y como un panel.

   b) Utilice la base `pigweights.dta`. Los datos se encuentran en formato wide. Utilice el comando `reshape` para llevarlos a formato long. Luego, describa la base de la misma forma que en el inciso (a).

   c) Genere un panel de 5000 observaciones con 10 períodos temporales y 500 unidades en el corte transversal. El panel debe estar en formato long. Genere observaciones de $x_{it} \sim N(0,1)$, $u_{it} \sim N(0,1)$ y además $y_{it} = 1 + x_{it} + u_{it}$. Estime por POLS.

3. Considere el siguiente modelo:

$$
y_i = \beta_1 + \beta_2 x_{2i} + \beta_3 x_{3i} + u_i,
$$

$$
i = 1, \ldots, N
$$

$$
u_i = \sqrt{\exp(-1 + 0{,}2 \cdot x_{2i})} \cdot \varepsilon_i,
$$

$$
i = 1, \ldots, N
$$

con $\beta_1 = 1$, $\beta_2 = 1$, $\beta_3 = 1$, $x_2 \sim N(0,25)$, $x_3 \sim N(0,25)$ y $\varepsilon \sim N(0,25)$. Luego, el error $u$ es heterocedástico con una varianza condicional igual a $25 \cdot \exp(-1 + 0{,}2 \cdot x_2)$.

   a) Genere 1000 muestras de $N=10$ observaciones a partir del modelo presentado. Para cada muestra estime por OLS, GLS y FGLS los parámetros del modelo y realice un test de hipótesis para contrastar que $H_0 : \beta_3 = 1$. Reporte tamaño del test al $1\%$. Adicionalmente, reporte la media, mediana y desvío estándar de las estimaciones de $\beta_1$, $\beta_2$ y $\beta_3$.

   b) Repita el punto anterior con $N$ igual a 20, 30, 100, 200 y 500.

   c) Describa detalladamente las propiedades de muestra finita de FGLS de acuerdo a lo que observó de los puntos anteriores.
