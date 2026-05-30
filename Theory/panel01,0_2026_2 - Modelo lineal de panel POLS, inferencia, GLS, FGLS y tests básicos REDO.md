# Modelos de Datos de Panel Lineales

**Fuente:** `panel01,0_2026_2 - Modelo lineal de panel POLS, inferencia, GLS, FGLS y tests básicos.pdf`

> Nota de transcripción: se omiten los pies de página repetidos de las diapositivas. No se detectaron imágenes o figuras sustantivas en este bloque; el contenido relevante son texto, supuestos, derivaciones y ecuaciones.

---

## Slide 11 / 104 — Modelos de Datos de Panel Lineales

**Supuestos:** se dispone de una muestra aleatoria de la población. Esto es, tenemos observaciones de **corte transversal**

$$
\{(X_j, y_j) : j = 1, 2, \ldots, N\}
$$

que son independientes e idénticamente distribuidas.

$X_j$ es una matriz $T \times K$ que incluye como primera columna un vector $T \times 1$ de unos e $y_j$ es un vector $T \times 1$.

El modelo lineal multivariante para una muestra aleatoria de la población puede escribirse como:

$$
y_{jt} = x_{jt}\beta + u_{jt}, \qquad j = 1,2,\ldots,N; \quad t = 1,2,\ldots,T
\tag{1}
$$

$$
y_j = X_j\beta + u_j, \qquad j = 1,2,\ldots,N
\tag{2}
$$

donde $\beta$ es el vector, $K \times 1$, de parámetros a estimar y $u_j$ es un vector $T \times 1$ de errores no observables.

---

## Slide 12 / 104 — Modelos de Datos de Panel Lineales

Dado el modelo planteado en (2), la pregunta relevante es cuáles son los supuestos que se necesitan para poder estimar $\beta$ consistentemente.

Una posibilidad es asumir que $x_{jt}$ y $u_{jt}$ son ortogonales en sentido condicional:

$$
E(u_{jt} \mid x_{jt}) = 0, \qquad t = 1,2,\ldots,T
\tag{3}
$$

Esta relación recibe el nombre de **exogeneidad contemporánea** de $x_{jt}$.

Es importante distinguir el supuesto de la ecuación (3) del más fuerte:

$$
E(u_{jt} \mid x_{j1}, x_{j2}, \ldots, x_{jT}) = 0, \qquad t = 1,2,\ldots,T
\tag{4}
$$

denominado **exogeneidad estricta** de las variables explicativas, ya que implica que $u_{jt}$ no está correlacionado con las variables explicativas en **ninguno** de los períodos temporales.

La estimación consistente de $\beta$ depende crucialmente de si se asume (3) o (4).

---

## Slide 13 / 104 — Modelos de Datos de Panel Lineales

En general, para poder estimar $\beta$ en (2) en forma consistente por OLS necesitamos:

**Supuesto 1:**

$$
E(X_j'u_j) = 0.
$$

El supuesto 1 implica que $E(u_j)=0$.

En el caso de datos de panel:

$$
X_j'u_j = \sum_{t=1}^{T} x_{jt}'u_{jt},
$$

por lo tanto una condición natural para que el supuesto 1 se satisfaga es:

$$
E(x_{jt}'u_{jt}) = 0, \qquad t = 1,2,\ldots,T.
$$

Note que la ecuación anterior **no** impone exogeneidad estricta.

Bajo el supuesto 1, el vector $\beta$ satisface:

$$
E[X_j'(y_j - X_j\beta)] = 0
$$

$$
E(X_j'X_j)\beta = E(X_j'y_j)
\tag{5}
$$

Para poder estimar $\beta$ necesitamos asumir que es el único vector $K \times 1$ que satisface (5).

---

## Slide 14 / 104 — Modelos de Datos de Panel Lineales

**Supuesto 2.**

$$
A \equiv E(X_j'X_j)
$$

es una matriz no aleatoria y no singular. Es decir,

$$
\operatorname{Rango}[E(X_j'X_j)] = K.
$$

Bajo los supuestos 1 y 2 podemos escribir:

$$
\beta = [E(X_j'X_j)]^{-1}E(X_j'y_j)
\tag{6}
$$

El principio de analogía sugiere estimar $\beta$ con el análogo muestral de (6):

$$
\hat\beta =
\left(
\frac{1}{N}\sum_{j=1}^{N} X_j'X_j
\right)^{-1}
\left(
\frac{1}{N}\sum_{j=1}^{N} X_j'y_j
\right)
\tag{7}
$$

Note que en la ecuación anterior:

$$
\sum_{j=1}^{N} X_j'X_j
= \sum_{j=1}^{N}\sum_{t=1}^{T} x_{jt}'x_{jt}
$$

$$
\sum_{j=1}^{N} X_j'y_j
= \sum_{j=1}^{N}\sum_{t=1}^{T} x_{jt}'y_{jt}.
$$

---

## Slide 15 / 104 — Modelos de Datos de Panel Lineales

$$
\hat\beta =
\left(
\frac{1}{N}\sum_{j=1}^{N}\sum_{t=1}^{T} x_{jt}'x_{jt}
\right)^{-1}
\left(
\frac{1}{N}\sum_{j=1}^{N}\sum_{t=1}^{T} x_{jt}'y_{jt}
\right)
\tag{8}
$$

$$
= \beta +
\left(
\frac{1}{N}\sum_{j=1}^{N}\sum_{t=1}^{T} x_{jt}'x_{jt}
\right)^{-1}
\left(
\frac{1}{N}\sum_{j=1}^{N}\sum_{t=1}^{T} x_{jt}'u_{jt}
\right)
$$

$$
\xrightarrow{p}
\beta +
\left(
E\sum_{t=1}^{T} x_{jt}'x_{jt}
\right)^{-1}
\left(
E\sum_{t=1}^{T} x_{jt}'u_{jt}
\right)
$$

$$
\xrightarrow{p}
\beta + A^{-1}\times 0.
$$

El término $A^{-1}$ se obtiene por el supuesto 2 y el término $0$ por el supuesto 1.

La ecuación (8) recibe el nombre de **Pool OLS**.

---

## Slide 16 / 104 — Modelos de Datos de Panel Lineales

Para realizar inferencia estadística lo único que necesitamos es la varianza asintótica del estimador.

De la derivación anterior:

$$
\sqrt{N}(\hat\beta - \beta)
=
\left(
\frac{1}{N}\sum_{j=1}^{N}\sum_{t=1}^{T} x_{jt}'x_{jt}
\right)^{-1}
\left(
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}\sum_{t=1}^{T} x_{jt}'u_{jt}
\right)
\tag{9}
$$

Como por el supuesto 1,

$$
E\left(\sum_{t=1}^{T}x_{jt}'u_{jt}\right)=0,
$$

lo único que necesitamos asumir para aplicar el CLT es:

$$
E\left(\sum_{t=1}^{T} x_{jt}'u_{jt}u_{jt}'x_{jt}\right) < \infty.
$$

Con este supuesto adicional el CLT implica que:

$$
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}\sum_{t=1}^{T} x_{jt}'u_{jt}
\xrightarrow{d}
\operatorname{Normal}(0,B),
$$

donde:

$$
B \equiv
E\left(\sum_{t=1}^{T}x_{jt}'u_{jt}u_{jt}'x_{jt}\right)
= \operatorname{Var}\left(\sum_{t=1}^{T}x_{jt}'u_{jt}\right).
$$

---

## Slide 17 / 104 — Modelos de Datos de Panel Lineales

Por lo tanto, usando el supuesto 2 junto con el resultado anterior en (9), tenemos:

$$
\sqrt{N}(\hat\beta - \beta)
\xrightarrow{d}
A^{-1}\operatorname{Normal}(0,B)
\xrightarrow{d}
\operatorname{Normal}(0,A^{-1}BA^{-1})
\tag{10}
$$

Por lo tanto, la varianza asintótica del estimador de $\beta$ es:

$$
\operatorname{AVar}(\hat\beta) = A^{-1}BA^{-1}/N.
\tag{11}
$$

Para realizar inferencia estadística necesitamos una estimación consistente de esta varianza asintótica:

$$
\hat A = \frac{1}{N}\sum_{j=1}^{N}\sum_{t=1}^{T}x_{jt}'x_{jt}.
$$

---

## Slide 18 / 104 — Modelos de Datos de Panel Lineales

Usando el principio de analogía, se puede obtener una estimación consistente de $B$ como:

$$
\hat B
= \frac{1}{N}\sum_{j=1}^{N}\sum_{t=1}^{T}x_{jt}'u_{jt}u_{jt}'x_{jt}
\xrightarrow{p} B.
$$

En la estimación anterior no conocemos los errores y por lo tanto deben ser reemplazados por los residuos del modelo. Esto es:

$$
\hat B
= \frac{1}{N}\sum_{j=1}^{N}\sum_{t=1}^{T}x_{jt}'\hat u_{jt}\hat u_{jt}'x_{jt}
\xrightarrow{p} B.
$$

Ahora, la última convergencia debe probarse. Note que:

$$
\hat B = \frac{1}{N}\sum_{j=1}^{N}X_j'\hat u_j\hat u_j'X_j
\qquad \text{y} \qquad
\hat u_j = y_j - X_j\hat\beta = u_j - X_j(\hat\beta-\beta).
$$

---

## Slide 19 / 104 — Modelos de Datos de Panel Lineales

Entonces,

$$
\begin{aligned}
\hat B
&= \frac{1}{N}\sum_{j=1}^{N}X_j'
[u_j - X_j(\hat\beta-\beta)]
[u_j - X_j(\hat\beta-\beta)]'X_j \\
&= \frac{1}{N}\sum_{j=1}^{N}X_j'u_ju_j'X_j
+ \frac{1}{N}\sum_{j=1}^{N}X_j'X_j(\hat\beta-\beta)(\hat\beta-\beta)'X_j'X_j \\
&\quad + \frac{1}{N}\sum_{j=1}^{N}X_j'u_j(\hat\beta-\beta)'X_j'X_j
+ \frac{1}{N}\sum_{j=1}^{N}X_j'X_j(\hat\beta-\beta)u_j'X_j
\tag{12}
\end{aligned}
$$

$$
\xrightarrow{p} B + o_p(1) + o_p(1) + o_p(1).
$$

---

## Slide 20 / 104 — Modelos de Datos de Panel Lineales

Por lo tanto,

$$
\operatorname{AVar}[\sqrt{N}(\hat\beta - \beta)]
$$

puede estimarse consistentemente con:

$$
\hat A^{-1}\hat B\hat A^{-1}.
$$

Y la varianza asintótica de $\hat\beta$ se estima con:

$$
\hat V
=
\left(\sum_{j=1}^{N}X_j'X_j\right)^{-1}
\left(\sum_{j=1}^{N}X_j'\hat u_j\hat u_j'X_j\right)
\left(\sum_{j=1}^{N}X_j'X_j\right)^{-1}
\tag{13}
$$

**Remark 1.** Bajo los supuestos 1 y 2 se puede realizar inferencia estadística sobre $\beta$ porque $\hat\beta$ se distribuye con una distribución normal con media $\beta$ y matriz de varianzas y covarianzas dada por la ecuación (13).

**Remark 2.** La raíz cuadrada de los elementos de la diagonal principal de (13) se reportan usualmente como los errores estándar asintóticos de los estimadores.

---

## Slide 21 / 104 — Modelos de Datos de Panel Lineales

**Remark 3.** El cociente $t$,

$$
\frac{\hat\beta_j}{\operatorname{se}(\hat\beta_j)},
$$

tiene distribución normal bajo la hipótesis nula:

$$
H_0 : \beta_j = 0.
$$

Usualmente estos estadísticos son tratados siguiendo una distribución $t$-Student con $N \times T - K$ grados de libertad, que es una aproximación asintóticamente válida.

**Remark 4.** La ecuación (13) es válida sin haber hecho ningún supuesto sobre el momento de orden dos de los errores.

El Remark 4 implica que la matriz $T \times T$ de varianzas y covarianzas de los errores no está restringida de ninguna manera, i.e.

$$
\Omega = E(u_ju_j').
$$

$\Omega$ no restringida permite cualquier tipo de correlación serial y varianzas de los disturbios que varíen en el tiempo.

Inferencia sobre múltiples hipótesis puede realizarse utilizando el estadístico de Wald.

---

## Slide 22 / 104 — Modelos de Datos de Panel Lineales

El estadístico robusto de Wald para contrastar la hipótesis nula:

$$
H_0 : R\beta = r,
$$

donde $R$ es $Q \times K$ con rango $Q$ y $r$ es $Q \times 1$, sigue la expresión usual:

$$
W = (R\hat\beta - r)'[R\hat V R']^{-1}(R\hat\beta-r)
\xrightarrow{d} \chi_Q^2.
\tag{14}
$$

El test de Wald permite contrastar cualquier hipótesis sobre $\beta$ sin tener que asumir homocedasticidad ni independencia serial de los errores.

Para aplicar los estadísticos usuales de OLS para la estimación pool, necesitamos asumir homocedasticidad y ausencia de correlación serial en el tiempo. Las formas más débiles de estos supuestos son:

**Supuesto 3:**

(a)

$$
E(u_{jt}^2x_{jt}'x_{jt}) = \sigma^2 E(x_{jt}'x_{jt}),
\qquad t=1,2,\ldots,T
$$

y

$$
\sigma^2 = E(u_{jt}^2) \quad \text{para todo } t.
$$

(b)

$$
E(u_{jt}u_{js}x_{jt}'x_{js}) = 0,
\qquad t \neq s, \quad t,s = 1,2,\ldots,T.
$$

---

## Slide 23 / 104 — Modelos de Datos de Panel Lineales

El supuesto 3 implica que:

$$
B \equiv E\left(\sum_{t=1}^{T}x_{jt}'u_{jt}u_{jt}'x_{jt}\right)
= \sigma^2 E\left(\sum_{t=1}^{T}x_{jt}'x_{jt}\right)
= \sigma^2 A.
$$

Y por lo tanto,

$$
\operatorname{AVar}(\hat\beta) = \sigma^2 A/N.
$$

El estimador apropiado es entonces:

$$
\hat V = \widehat{\operatorname{AVar}}(\hat\beta)
= \hat\sigma^2
\left(
\sum_{j=1}^{N}\sum_{t=1}^{T}x_{jt}'x_{jt}
\right)^{-1}
\tag{15}
$$

En la ecuación anterior, $\hat\sigma^2$ es el estimador usual de la varianza de los errores del modelo estimado por Pool OLS.

Si el supuesto 3 se satisface, los estadísticos $t$ y $F$ son válidos.

Si el supuesto 3 no se satisface, una alternativa a OLS es mínimos cuadrados generalizados (GLS).

---

## Slide 24 / 104 — Modelos de Datos de Panel Lineales

Para poder establecer la consistencia de GLS necesitamos reforzar el supuesto 1.

**Supuesto 1'.**

$$
E(X_j \otimes u_j) = 0.
$$

Esto es, cada elemento de $u_j$ no está correlacionado con cada elemento de $X_j$.

Una condición suficiente para que se cumpla el supuesto 1' es:

$$
E(u_j \mid X_j) = 0.
$$

En lugar del supuesto 2, necesitamos:

**Supuesto 2'.** $\Omega$ es positiva definida y $E(X_j'\Omega^{-1}X_j)$ no es singular.

Pre-multiplicando el modelo (2) por $\Omega^{-1/2}$ tenemos:

$$
\Omega^{-1/2}y_j = \Omega^{-1/2}X_j\beta + \Omega^{-1/2}u_j
$$

$$
y_j^* = X_j^*\beta + u_j^*
\tag{16}
$$

Ahora:

$$
E(u_j^*u_j^{*'}) = I_T.
$$

---

## Slide 25 / 104 — Modelos de Datos de Panel Lineales

Aplicando OLS a (16) obtenemos:

$$
\tilde\beta
=
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j^{*'}X_j^*
\right)^{-1}
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j^{*'}y_j^*
\right)
$$

$$
=
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}X_j
\right)^{-1}
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}y_j
\right)
\tag{17}
$$

$$
=
\beta +
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}X_j
\right)^{-1}
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}u_j
\right)
\tag{18}
$$

Por la ley de los grandes números (WLLN):

$$
\left(\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}X_j\right)
\xrightarrow{p}
E(X_j'\Omega^{-1}X_j) \equiv A.
$$

---

## Slide 26 / 104 — Modelos de Datos de Panel Lineales

Ahora, por el supuesto 2' y el Lema 4 (teorema de Slutsky), tenemos que:

$$
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}X_j
\right)^{-1}
\xrightarrow{p} A^{-1}.
$$

Por la ley de los grandes números (WLLN):

$$
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}u_j
\right)
\xrightarrow{p}
E(X_j'\Omega^{-1}u_j).
$$

Bajo el supuesto 1':

$$
E(X_j'\Omega^{-1}u_j)=0.
$$

**Proof:**

$$
\begin{aligned}
\operatorname{Vec}\left[E(X_j'\Omega^{-1}u_j)\right]
&= E[u_j' \otimes X_j']\operatorname{Vec}(\Omega^{-1}) \\
&= E[(u_j \otimes X_j)']\operatorname{Vec}(\Omega^{-1}) = 0.
\end{aligned}
$$

---

## Slide 27 / 104 — Modelos de Datos de Panel Lineales

Usando la ecuación (18), tenemos:

$$
\sqrt{N}(\tilde\beta-\beta)
=
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}X_j
\right)^{-1}
\left(
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}X_j'\Omega^{-1}u_j
\right)
\tag{19}
$$

Como vimos, por la WLLN y el supuesto 1',

$$
E(X_j'\Omega^{-1}u_j)=0.
$$

Por lo tanto, por el CLT:

$$
\left(
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}X_j'\Omega^{-1}u_j
\right)
\xrightarrow{d}
\operatorname{Normal}(0,B),
$$

where:

$$
B = E(X_j'\Omega^{-1}u_ju_j'\Omega^{-1}X_j).
$$

---

## Slide 28 / 104 — Modelos de Datos de Panel Lineales

Usando los resultados anteriores, tenemos:

$$
\sqrt{N}(\tilde\beta-\beta)
=
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}X_j
\right)^{-1}
\left(
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}X_j'\Omega^{-1}u_j
\right)
$$

$$
\xrightarrow{d} A^{-1}\operatorname{Normal}(0,B)
\xrightarrow{d} \operatorname{Normal}(0,A^{-1}BA^{-1}).
$$

Por lo tanto:

$$
\operatorname{AVar}(\tilde\beta)=A^{-1}BA^{-1}/N.
$$

Para poder estimar el modelo por GLS necesitamos conocer $\Omega$. En la práctica rara vez conocemos esta matriz y el método no puede ser utilizado empíricamente.

Sin embargo, existe un método que es asintóticamente equivalente conocido como mínimos cuadrados generalizados estimados o FGLS.

---

## Slide 29 / 104 — Modelos de Datos de Panel Lineales

En FGLS reemplazamos $\Omega$ con una estimación consistente.

En general se utiliza el siguiente procedimiento.

1. Obtenga el estimador Pool OLS de $\beta$, $\hat{\hat\beta}$, from (8).
2. Obtenga los residuos:

$$
\hat{\hat u}_j = y_j - X_j\hat{\hat\beta}.
$$

3. Estime $\Omega$ con:

$$
\tilde\Omega = \sum_{j=1}^{N}\hat{\hat u}_j\hat{\hat u}_j'.
$$

Note que:

$$
\hat{\hat u}_j = u_j - X_j(\hat{\hat\beta}-\beta),
$$

por lo tanto:

$$
\begin{aligned}
\hat{\hat u}_j\hat{\hat u}_j'
&= u_ju_j' - u_j(\hat{\hat\beta}-\beta)'X_j' - X_j(\hat{\hat\beta}-\beta)u_j' \\
&\quad + X_j(\hat{\hat\beta}-\beta)(\hat{\hat\beta}-\beta)'X_j'.
\end{aligned}
$$

---

## Slide 30 / 104 — Modelos de Datos de Panel Lineales

El segundo término del lado derecho puede escribirse como:

$$
\frac{1}{N}\sum_{j=1}^{N}
\operatorname{Vec}\left[u_j(\hat{\hat\beta}-\beta)'X_j'\right]
=
\frac{1}{N}\sum_{j=1}^{N}(X_j \otimes u_j)\operatorname{Vec}(\hat{\hat\beta}-\beta)'
$$

$$
\xrightarrow{p} E(X_j \otimes u_j) \times o_p(1).
$$

El último término del lado derecho puede escribirse como:

$$
\frac{1}{N}\sum_{j=1}^{N}
X_j(\hat{\hat\beta}-\beta)(\hat{\hat\beta}-\beta)'X_j'
$$

$$
=
\frac{1}{N}\sum_{j=1}^{N}(X_j \otimes X_j')
\operatorname{Vec}\left[(\hat{\hat\beta}-\beta)(\hat{\hat\beta}-\beta)'\right]
$$

$$
\xrightarrow{p} O_p(1) \times o_p(1).
$$

---

## Slide 31 / 104 — Modelos de Datos de Panel Lineales

Por lo tanto:

$$
\tilde\Omega = \sum_{j=1}^{N}u_ju_j' + o_p(1)
\quad \Longrightarrow \quad
\tilde\Omega \xrightarrow{p} \Omega.
\tag{20}
$$

El estimador FGLS de $\beta$ es entonces:

$$
\tilde{\hat\beta}
=
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}X_j
\right)^{-1}
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}y_j
\right)
\tag{21}
$$

$$
=
\beta +
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}X_j
\right)^{-1}
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}u_j
\right).
$$

---

## Slide 32 / 104 — Modelos de Datos de Panel Lineales

De la última expresión tenemos:

$$
\sqrt{N}(\tilde{\hat\beta}-\beta)
=
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}X_j
\right)^{-1}
\left(
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}u_j
\right).
$$

Ahora:

$$
\begin{aligned}
&\left(
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}u_j
\right)
-
\left(
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}X_j'\Omega^{-1}u_j
\right) \\
&=
\left[
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}X_j'(\tilde\Omega^{-1}-\Omega^{-1})u_j
\right] \\
&=
\left[
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}(u_j \otimes X_j)'
\right]
\operatorname{Vec}(\tilde\Omega^{-1}-\Omega^{-1})
\xrightarrow{p} O_p(1)\times o_p(1).
\end{aligned}
$$

---

## Slide 33 / 104 — Modelos de Datos de Panel Lineales

Por lo tanto:

$$
\left(
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}u_j
\right)
=
\left(
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}X_j'\Omega^{-1}u_j
\right)+o_p(1).
$$

Usando el mismo argumento:

$$
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}X_j
\right)
=
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}X_j
\right)+o_p(1).
$$

Utilizando los dos resultados anteriores tenemos que:

$$
\begin{aligned}
\sqrt{N}(\tilde{\hat\beta}-\beta)
&=
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\Omega^{-1}X_j
\right)^{-1}
\left(
\frac{1}{\sqrt{N}}\sum_{j=1}^{N}X_j'\Omega^{-1}u_j
\right)+o_p(1) \\
&= \sqrt{N}(\tilde\beta-\beta)+o_p(1)
\quad \Longrightarrow \quad
\sqrt{N}(\tilde{\hat\beta}-\tilde\beta)=o_p(1).
\end{aligned}
$$

Y ambos estimadores, GLS y FGLS, son asintóticamente equivalentes ($\sqrt{N}$ equivalentes).

---

## Slide 34 / 104 — Modelos de Datos de Panel Lineales

**Remark 5:** Empíricamente, la equivalencia asintótica de los estimadores de GLS y FGLS implica que para realizar inferencia estadística sobre $\beta$ usando FGLS, no hay que preocuparse de que $\tilde\Omega$ sea un estimador de $\Omega$.

**Resumen:** Bajo los supuestos 1' y 2',

$$
\sqrt{N}(\tilde{\hat\beta}-\beta)
\xrightarrow{d}
\operatorname{Normal}(0,A^{-1}BA^{-1}).
$$

Bajo FGLS, un estimador consistente de $A$ es:

$$
\tilde A =
\left(
\frac{1}{N}\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}X_j
\right).
$$

Un estimador consistente de $B$ es:

$$
\tilde B
= \frac{1}{N}\sum_{j=1}^{N}
X_j'\tilde\Omega^{-1}\tilde u_j\tilde u_j'\tilde\Omega^{-1}X_j,
\qquad
\tilde u_j = y_j - X_j\tilde{\hat\beta}.
$$

---

## Slide 35 / 104 — Modelos de Datos de Panel Lineales

Usando los resultados anteriores, una estimación de la varianza asintótica del estimador FGLS es:

$$
\hat V
= \widehat{\operatorname{AVar}}(\tilde{\hat\beta})
= \tilde A^{-1}\tilde B\tilde A^{-1}/N
$$

$$
=
\left(\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}X_j\right)^{-1}
\left(\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}\tilde u_j\tilde u_j'\tilde\Omega^{-1}X_j\right)
\left(\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}X_j\right)^{-1}.
\tag{22}
$$

La especificación anterior es la más general que se pueda tener en términos de los supuestos acerca de la estimación de la varianza asintótica.

**Supuesto 3'.**

$$
E(X_j'\Omega^{-1}u_ju_j'\Omega^{-1}X_j)
= E(X_j'\Omega^{-1}X_j),
\qquad \text{con } \Omega = E(u_ju_j').
$$

Bajo los supuestos 1', 2' y 3', la varianza asintótica del estimador FGLS es:

$$
\operatorname{AVar}(\tilde{\hat\beta})
= A^{-1}/N
= [E(X_j'\Omega^{-1}X_j)]^{-1}/N.
$$

---

## Slide 36 / 104 — Modelos de Datos de Panel Lineales

Uno obtiene un estimador consistente de la varianza asintótica usando un estimador consistente de $A$.

$$
\widehat{\operatorname{AVar}}(\tilde{\hat\beta})
= \hat A^{-1}/N
=
\left(
\sum_{j=1}^{N}X_j'\tilde\Omega^{-1}X_j
\right)^{-1}
\tag{23}
$$

Los errores estándar asintóticos de los coeficientes estimados se obtienen en forma usual utilizando la raíz cuadrada de la diagonal principal de (22) o de (23).

Contrastes de múltiples hipótesis pueden realizarse utilizando el estadístico de Wald definido anteriormente en la ecuación (14).

La única decisión importante es la elección de la estimación de la varianza asintótica correcta.

El estadístico de Wald estándar usa (23) mientras que el robusto utiliza (14).

---

## Slide 37 / 104 — Contraste de Correlación Serial en POLS

Supongamos correlación serial de primer orden:

$$
u_{jt} = \alpha_1u_{j,t-1} + e_{jt},
\qquad E(e_{jt}\mid X_{jt}, u_{j,t-1},\ldots)=0.
$$

**LM Test para**

$$
H_0 : \alpha_1 = 0.
$$

1. Estime por POLS:

$$
y_{jt}=x_{jt}\beta+u_{jt}
$$

   y obtenga $\hat u_{jt}$.

2. Estime por POLS:

$$
\hat u_{jt}=x_{jt}\beta+\alpha_1\hat u_{j,t-1}+e_{jt}
\qquad (ax)
$$

3. Calcule:

$$
LM = Obs \times R_{ax}^2 \sim \chi_1^2.
$$

4. Regla de decisión: si el valor-$p(LM)$ es menor que el nivel de error del test, entonces rechazar $H_0$.

El test tiene las generalizaciones usuales para correlación de mayor orden.

---

## Slide 38 / 104 — Contraste de Heterocedasticidad en POLS

Este test es válido si se asume:

$$
E(u_{jt}\mid x_{jt})=0,
\qquad t=1,2,\ldots,T.
$$

La hipótesis nula es entonces:

$$
E(u_{jt}^2\mid x_{jt}) = \sigma^2,
\qquad t=1,2,\ldots,T.
$$

Bajo $H_0$, $u_{jt}^2$ no está correlacionado con ninguna función de $x_{jt}$.

Denotemos por $h_{jt}$ a un vector de dimensión $1 \times Q$ de funciones no constantes de $x_{jt}$.

1. Estime por POLS:

$$
y_{jt}=x_{jt}\beta+u_{jt}
$$

   y obtenga $\hat u_{jt}$ y $\hat u_{jt}^2$.

2. Estime por POLS $\hat u_{jt}^2$ sobre una constante y $h_{jt}$ y obtenga el $R_{ax}^2$.

3. Calcule:

$$
LM = N \times T \times R_{ax}^2 \sim \chi_Q^2.
$$

4. Regla de decisión: si el valor-$p(LM)$ es menor que el nivel de error del test, entonces rechazar $H_0$.
