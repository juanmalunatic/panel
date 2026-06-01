# Universidad Torcuato Di Tella

## Maestría en Economía y Econometría

**2022**

---

# Datos de Panel

## Problem Set 4

## Modelos Lineales en Paneles Desbalanceados

---

1. Utilice la base de datos “keane.dta” la cual contiene el historial de empleo y escolaridad de una muestra de hombres para los años 1981 a 1987. Luego, considere la siguiente ecuación de salarios:

$$
\ln(wage_{it}) = \beta_0 + \beta_1 exper_{it} + \beta_2 educ_{it} + c_i + u_{it}, \quad t = 1, 2, \ldots, T
\tag{1}
$$

   donde $\ln(wage_{it})$ es el logaritmo del salario por hora, $exper_{it}$ son los años de experiencia en el mercado laboral y $educ_{it}$ son los años de escolaridad. Responda las siguientes preguntas:

   a) Estime la ecuación usando efectos fijos. ¿Cuál es el sesgo potencial en este contexto?

   **Solution:** En este contexto de efectos fijos la selección muestral por truncamiento incidental es un problema si la selección está relacionada con los errores idiosincráticos de la ecuación de interés, $u_{it}$. En este sentido, si pensamos que efectivamente lo anterior se cumple y que estamos observando los salarios “más altos” (los mejores salarios que se ofrecieron) entonces el truncamiento tendría como consecuencia una sobreestimación de los retornos a la educación.

   b) Implemente el contraste de sesgo de selección propuesto por Wooldridge (1995) bajo el enfoque de Mundlak (1978).

   c) Implemente el contraste de sesgo de selección propuesto por Wooldridge (1995) bajo el enfoque de Chamberlain (1980).

   **Solution:** La hipótesis nula en ambos contrastes de hipótesis establece que la inversa del cociente de Mills estimada no debería ser estadísticamente significativa en nuestro modelo si no hay problemas de selección de la muestra. Sin embargo, en ambos casos encontramos evidencia en favor de rechazar la hipótesis nula.

2. Considerando nuevamente la ecuación de salarios del ejercicio previo, realice los siguientes procedimientos:

   a) Estime el modelo por Wooldridge (1995) bajo el enfoque de Chamberlain (1980).

   b) Estime el modelo por Wooldridge (1995) bajo el enfoque de Mundlak (1978).

   c) Comente sobre los errores estándar de las estimaciones anteriores.

   d) Estime los errores estándar vía bootstrapping.

   e) Estime los errores estándar analíticos (varianza asintótica).
