# Clase 9 — Modelos con variable dependiente binaria

> Transcripción de notas manuscritas.  
> Fuente: `Clase 9.pdf`.  
> Nota de transcripción: el documento contiene 5 páginas; la página 5 está en blanco. Se respetó la notación manuscrita en la medida de lo posible. Donde había pasos algebraicos implícitos, se mantuvo la estructura original y se aclaró mínimamente la lectura.

---

## Ejercicio 1

Vamos a trabajar con una base de afiliación sindical.

No olvidar mostrar: `educ` no tiene variabilidad *within*.

Foco de hoy: variable dependiente dummy.

¿Cómo podemos estimar en panel la probabilidad de que una variable sea igual a 1 condicional en ciertas variables explicativas continuas?

\[
P(y_{it}=1\mid x_{it})
\]

---

### a) Modelo de Probabilidad Lineal

\[
P(union_{it}=1\mid educ_{it})=\beta_0+\beta_1 educ_{it}
\]

No hay ninguna restricción a que los valores estimados

\[
\hat{\beta}_0+\hat{\beta}_1 educ_{it}
\]

estén entre 0 y 1.

Pensemos en el impacto de un año adicional de educación en la probabilidad de afiliarse. El **efecto marginal** es:

\[
\frac{\partial P(union=1\mid educ)}{\partial educ}=\beta_1
\]

Entonces el efecto es constante.

**Contra:** el modelo, por construcción, tiene heterocedasticidad (ver slides de clase). Entonces sí o sí: estimación robusta o bootstrap.

---

### b) Pooled Probit

Si usamos pooled Probit:

\[
P(union_{it}=1\mid educ_{it})=\Phi(\beta_0+\beta_1 educ_{it})
\]

El efecto marginal es:

\[
\frac{\partial P(union_{it}=1\mid educ_{it})}{\partial educ_{it}}
=
\beta_1\phi(\beta_0+\beta_1 educ_{it})
\]

**Ojo:** diferencia entre la salida de Stata y el efecto marginal.

Si suponemos que los errores no son esféricos, usamos estimación robusta.

---

### c) Versión Logit

\[
P(union_{it}=1\mid educ_{it})
=
\Lambda(\beta_0+\beta_1 educ_{it})
=
\frac{e^{\beta_0+\beta_1 educ_{it}}}{1+e^{\beta_0+\beta_1 educ_{it}}}
\]

Derivando respecto de \(educ_{it}\):

\[
\frac{\partial P(union_{it}=1\mid educ_{it})}{\partial educ_{it}}
=
\frac{
\beta_1 e^{\beta_0+\beta_1 educ_{it}}
(1+e^{\beta_0+\beta_1 educ_{it}})
-
e^{\beta_0+\beta_1 educ_{it}}
\beta_1 e^{\beta_0+\beta_1 educ_{it}}
}{
(1+e^{\beta_0+\beta_1 educ_{it}})^2
}
\]

\[
=
\frac{
\beta_1 e^{\beta_0+\beta_1 educ_{it}}
}{
(1+e^{\beta_0+\beta_1 educ_{it}})^2
}
\]

\[
=
\frac{\beta_1\Lambda(\beta_0+\beta_1 educ_{it})}{1+e^{\beta_0+\beta_1 educ_{it}}}
\]

Como

\[
1-\Lambda(\beta_0+\beta_1 educ_{it})
=
1-
\frac{e^{\beta_0+\beta_1 educ_{it}}}{1+e^{\beta_0+\beta_1 educ_{it}}}
\]

\[
=
\frac{1+e^{\beta_0+\beta_1 educ_{it}}-e^{\beta_0+\beta_1 educ_{it}}}
{1+e^{\beta_0+\beta_1 educ_{it}}}
\]

\[
=
\frac{1}{1+e^{\beta_0+\beta_1 educ_{it}}}
\]

Entonces:

\[
\frac{\partial P(union_{it}=1\mid educ_{it})}{\partial educ_{it}}
=
\beta_1
\Lambda(\beta_0+\beta_1 educ_{it})
\left[
1-\Lambda(\beta_0+\beta_1 educ_{it})
\right]
\]

\[
= g(\beta_0,\beta_1)
\]

El signo del efecto marginal es el signo de \(\beta_1\).

---

### Error estándar del efecto marginal

¿Qué pasa con el error estándar que pide Stata del efecto marginal?

Lo calcula como una función que relaciona funciones de forma no lineal. Entonces tengo que aplicar método delta. Stata lo hace automáticamente.

\[
V\left(
\frac{\widehat{\partial P(union_{it}=1\mid educ_{it})}}{\partial educ_{it}}
\right)
=
\frac{\partial \hat g}{\partial \hat\beta'}
\widehat{V}(\hat\beta)
\frac{\partial \hat g}{\partial \hat\beta}
\]

donde \(\hat g\) es una función derivable.

Lo que sale de la regresión Logit/Probit se recupera con post-estimation.

\(g\) es una función que depende de \(\beta_0\) y \(\beta_1\), y vamos a tener vectores de derivadas parciales (gradiente).

Como:

\[
g(\cdot)=\beta_1\Lambda(1-\Lambda)
\]

tenemos:

\[
\frac{\partial g(\cdot)}{\partial \beta_1}
=
\Lambda(1-\Lambda)
+
\beta_1
\left[
\Lambda'(1-\Lambda)educ_{it}
-
\Lambda\Lambda'educ_{it}
\right]
\]

\[
=
\Lambda(1-\Lambda)
+
\beta_1
\left[
(1-\Lambda)-\Lambda
\right]\Lambda' educ_{it}
\]

\[
=
\Lambda(1-\Lambda)
+
\beta_1
\left[
1-2\Lambda
\right]\Lambda' educ_{it}
\]

En términos estimados:

\[
\frac{\partial \hat g(\cdot)}{\partial \beta_1}
=
\hat\Lambda(1-\hat\Lambda)
+
\hat\beta_1
\left[
1-2\hat\Lambda
\right]\hat\Lambda' educ_{it}
\]

Tengo que seleccionar en qué valor lo evalúo, con `atmeans`.

Por otro lado:

\[
\frac{\partial g(\cdot)}{\partial \beta_0}
=
\beta_1
\left[
(1-\Lambda)-\Lambda
\right]\Lambda'
\]

\[
\frac{\partial \hat g(\cdot)}{\partial \beta_0}
=
\hat\beta_1
\left[
1-2\hat\Lambda
\right]\hat\Lambda'
\]

Además:

\[
\Lambda'=\Lambda(1-\Lambda)
\]

(lo pueden chequear).

En el código voy a tener que armar una matriz con estos dos componentes.

---

### d) Probit con efectos aleatorios

Ahora Probit con efectos aleatorios. Hay heterogeneidad no observada:

\[
P(union_{it}=1\mid educ_{it},c_i)
=
\Phi(\beta_0+\beta_1 educ_{it}+c_i)
\]

Efecto parcial:

\[
\frac{
\partial P(union_{it}=1\mid educ_{it},c_i)
}{
\partial educ_{it}
}
=
\beta_1\phi(\beta_0+\beta_1 educ_{it}+c_i)
\]

**Problema:** no sé qué es \(c_i\), y le voy a asignar valores para conocer el efecto marginal.

**Soluciones:** en Stata puedo calcular el efecto marginal en \(c_i=0\). Además, esto está en el supuesto de que:

\[
c_i\mid x_i \sim N(0,\sigma_c^2)
\]

Entonces estaría evaluado en su media.

Referencia en la nota: Cap. 18 de Cameron y Trivedi, tabla 18.1, donde se resuelven los códigos en Stata para estimaciones de los 4 modelos.

---

### e) Logit con heterogeneidad no observada

\[
P(union_{it}=1\mid educ_{it},c_i)
=
\Lambda(\beta_0+\beta_1 educ_{it}+c_i)
\]

Modelo Logit con heterogeneidad no observada.

Va a volver a depender de \(c_i\). Voy a tener que asignar valor a \(c_i\) para computar \(\Lambda(\cdot)\).

---

### f) Efectos fijos

Ahora estimamos por efectos fijos. Stata lo omite. ¿Por qué?

Porque educación no varía en el tiempo:

\[
educ_{it}=educ_i\quad \forall t
\]

Cuando hago la transformación *within*, pierdo \(\beta_0\) y \(c_i\) (es normal), y también la única variable explicativa.

Referencia en la nota: Cap. 11 de *Econometric Analysis of Panel Data* (Baltagi), explicación de FE con variables dependientes binarias.

---

## Ejercicio 2

### a) Efecto de una variable explicativa rezagada

El efecto del cambio cuando la variable explicativa es el rezago de la dependiente (dinámico) es el cambio en la probabilidad de estar afiliado hoy dado que ayer lo estaba versus que ayer no lo estaba:

\[
P(union_{it}=1\mid union_{it-1}=1)
-
P(union_{it}=1\mid union_{it-1}=0)
\]

### b) Agregar variables explicativas

Si agrego variables explicativas, agrego escenarios posibles: combinaciones de las variables en las que condicione.

---

## Notas de consistencia y mapeo

- El set corresponde claramente a modelos con variable dependiente binaria en panel.
- El contenido visible cubre:
  - Modelo de Probabilidad Lineal.
  - Pooled Probit.
  - Logit.
  - Efectos marginales y método delta.
  - Probit/Logit con heterogeneidad no observada.
  - Efectos fijos con variable explicativa sin variación *within*.
  - Inicio del ejercicio dinámico con \(union_{it-1}\).
- La página 5 del PDF está en blanco.
- Respecto del mapa 2023, este set parece corresponder a **PS5: Ejercicio 1** y arranque de **Ejercicio 2**, más que a una continuación de PS4.
