# Clase 5

## Modelos con Paneles Dinámicos

- Levantamos el supuesto de exogeneidad estricta. Ahora:

$$
E\left(u_{it}\mid c_i,\ldots,x_{i,t-1},x_{it},x_{i,t+1},\ldots\right)\neq 0
$$

- Forma fácil de incorporarlo: modelo autorregresivo en panel. La variable dependiente “ingresa” como explicativa, rezagada.

- Vamos a mantener el efecto constante en el tiempo: $c_i$.

- Tomando el ej. 1:

$$
\ln n_{it}=\rho \ln n_{i,t-1}+\varepsilon_{it}
$$

donde $\varepsilon_{it}$ es el error compuesto,

$$
\varepsilon_{it}=c_i+v_{it}.
$$

### ¿Qué pasa si estimamos por OLS?

$$
\hat\rho
=
\frac{\sum_t\sum_i x y}{\sum_t\sum_i x^2}
$$

En este modelo,

$$
x=\ln n_{i,t-1},
\qquad
y=\ln n_{it}.
$$

Entonces,

$$
\hat\rho
=
\frac{\sum_t\sum_i(\ln n_{i,t-1})(\ln n_{it})}
{\sum_t\sum_i(\ln n_{i,t-1})^2}.
$$

Reemplazo por el modelo:

$$
\hat\rho
=
\frac{\sum_t\sum_i(\ln n_{i,t-1})
\left(\rho\ln n_{i,t-1}+c_i+v_{it}\right)}
{\sum_t\sum_i(\ln n_{i,t-1})^2}.
$$

Separando términos:

$$
\hat\rho
=
\rho
\frac{\sum_t\sum_i(\ln n_{i,t-1})^2}
{\sum_t\sum_i(\ln n_{i,t-1})^2}
+
\frac{\sum_t\sum_i \ln n_{i,t-1}c_i}
{\sum_t\sum_i(\ln n_{i,t-1})^2}
+
\frac{\sum_t\sum_i \ln n_{i,t-1}v_{it}}
{\sum_t\sum_i(\ln n_{i,t-1})^2}.
$$

Por lo tanto,

$$
\hat\rho = \rho + A + B.
$$

Pregunta: ¿$A$ y $B$ tienen esperanza $0$ o tenemos problemas de sesgo de mi estimador?

$$
A=
\frac{\sum_t\sum_i \ln n_{i,t-1}c_i}
{\sum_t\sum_i(\ln n_{i,t-1})^2}
\quad
\sim
\text{correlación entre la variable explicativa y la heterogeneidad no observada.}
$$

$$
B=
\frac{\sum_t\sum_i \ln n_{i,t-1}v_{it}}
{\sum_t\sum_i(\ln n_{i,t-1})^2}
$$

Como son los errores idiosincráticos del modelo original, sabemos que hay cero correlación.

$$
\operatorname{Cov}(\ln n_{i,t-1},c_i)=0
\quad\text{o no}
\quad\Rightarrow\quad
\text{sesgo de paneles dinámicos}
$$

En este caso se sobreestima a $\rho$.

Si uso MCO estoy sobreestimando el efecto de $\ln n_{i,t-1}$ sobre $\ln n_{it}$.

---

## b) Estimación con FE mediante transformación within

Ahora me pide que estime con FE con la transformación within.

Pregunta: ¿elimino el sesgo de paneles dinámicos?

Parto del modelo:

$$
\ln n_{it}
=
\rho\ln n_{i,t-1}+c_i+v_{it}
\tag{1}
$$

Tomo la media:

$$
\overline{\ln n_i}
=
\rho\,\overline{\ln n_{i,t-1}}
+
\overline{c_i}
+
\overline{v_i}
\tag{2}
$$

Restando $(1)-(2)$:

$$
\ddot{\ln n}_{it}
=
\rho\,\ddot{\ln n}_{i,t-1}
+
\ddot v_{it}.
$$

Sobre este modelo transformado aplico MCO y analizo exogeneidad.

La condición sería:

$$
E\left(\ddot{\ln n}_{i,t-1}\ddot v_{it}\right)=0.
$$

Chequeo:

$$
E\left(\ddot{\ln n}_{i,t-1}\ddot v_{it}\right)
=
E\left[
\left(\ln n_{i,t-1}-\overline{\ln n}_{i,t-1}\right)
\left(v_{it}-\overline v_i\right)
\right].
$$

Expandiendo:

$$
\begin{aligned}
E\left(\ddot{\ln n}_{i,t-1}\ddot v_{it}\right)
&=
E(\ln n_{i,t-1}v_{it})
-
E(\overline{\ln n}_{i,t-1}v_{it}) \\
&\quad
-
E(\ln n_{i,t-1}\overline v_i)
+
E(\overline{\ln n}_{i,t-1}\overline v_i).
\end{aligned}
$$

Problema: dentro de $\overline v_i$ está $v_{i,t-1}$, y tenemos que

$$
\ln n_{i,t-1}
=
\rho\ln n_{i,t-2}
+
v_{i,t-1}
+
c_i.
$$

Entonces correlacionan.

Conclusión: FE elimina una de las fuentes de inconsistencia —la que proviene de “omitir” $c_i$ en la ecuación—, pero **no** elimina el sesgo de Nickell.

$$
\gamma(\rho,T)
=
\operatorname{plim}\hat\rho^{FE}-\rho
<
0
$$

Por tanto,

$$
\hat\rho^{FE}
\quad\text{subestima al verdadero.}
$$

Juntando $A$ y $B$:

$$
\hat\rho^{FE}<\rho<\hat\rho^{OLS}.
$$

---

## c) Estimación por FD

Ahora calculo por FD.

Parto del modelo:

$$
\ln n_{it}
=
\rho\ln n_{i,t-1}
+
c_i
+
v_{it}
\tag{1}
$$

Aplico operador lag:

$$
\ln n_{i,t-1}
=
\rho\ln n_{i,t-2}
+
c_i
+
v_{i,t-1}
\tag{2}
$$

Restando $(1)-(2)$:

$$
\Delta\ln n_{it}
=
\rho\,\Delta\ln n_{i,t-1}
+
\Delta v_{it}.
$$

Esto lo estimo por OLS, pero ¿qué pasa con el sesgo adicional?

$$
E\left(\Delta\ln n_{i,t-1}\Delta v_{it}\right)
=
E\left[
\left(\ln n_{i,t-1}-\ln n_{i,t-2}\right)
\left(v_{it}-v_{i,t-1}\right)
\right].
$$

Expandiendo:

$$
\begin{aligned}
E\left(\Delta\ln n_{i,t-1}\Delta v_{it}\right)
&=
E[\ln n_{i,t-1}v_{it}]
-
E[\ln n_{i,t-1}v_{i,t-1}] \\
&\quad
-
E[\ln n_{i,t-2}v_{it}]
+
E[\ln n_{i,t-2}v_{i,t-1}].
\end{aligned}
$$

Esto es exactamente igual a lo que chequeamos en b):

$$
\ln n_{it}
=
\rho\ln n_{i,t-1}
+
c_i
+
v_{it}
$$

y

$$
\ln n_{i,t-1}
=
\rho\ln n_{i,t-2}
+
c_i
+
v_{i,t-1}.
$$

Sigue existiendo el problema de endogeneidad.

---

## d) Solución al problema de endogeneidad

Solución al problema de endogeneidad:

$$
\text{MC2E} \;|\; \text{IV}
$$

Problema: qué instrumentos elegir. Tienen que ser relevantes y exógenos.

### Anderson-Hsiao

Anderson-Hsiao nos dice qué instrumento usar: rezago en nivel en $t-2$ para la ecuación/modelo en diferencia.

Modelo en diferencias:

$$
\Delta\ln n_{it}
=
\rho\,\Delta\ln n_{i,t-1}
+
\Delta v_{it}.
$$

#### Exogeneidad

Veamos que es exógeno:

$$
\begin{aligned}
E\left(\ln n_{i,t-2}\Delta v_{it}\right)
&=
E\left[\ln n_{i,t-2}\left(v_{it}-v_{i,t-1}\right)\right] \\
&=
E(\ln n_{i,t-2}v_{it})
-
E(\ln n_{i,t-2}v_{i,t-1}) \\
&=
0.
\end{aligned}
$$

#### Relevancia

Relevancia:

$$
E\left(\ln n_{i,t-2}\Delta\ln n_{i,t-1}\right)
=
E\left[
\ln n_{i,t-2}
\left(\ln n_{i,t-1}-\ln n_{i,t-2}\right)
\right].
$$

Entonces,

$$
E\left(\ln n_{i,t-2}\Delta\ln n_{i,t-1}\right)
=
E(\ln n_{i,t-2}\ln n_{i,t-1})
-
E\left((\ln n_{i,t-2})^2\right).
$$

El primer término está asociado a

$$
\operatorname{cov}(\ln n_{i,t-2},\ln n_{i,t-1}),
$$

y el segundo a

$$
\operatorname{var}(\ln n_{i,t-2}).
$$

Recordamos que

$$
\ln n_{i,t-1}
=
\rho\ln n_{i,t-2}
+
c_i
+
v_{i,t-1}.
$$

Si el modelo está correctamente especificado, esto es distinto de cero.

Por tanto, el instrumento es exógeno y relevante, luego es válido.

La implementación la vemos en Stata.

---

## e) Arellano-Bond

Arellano-Bond va a trabajar sobre la “debilidad” de Anderson-Hsiao: va a agregar todos los rezagos disponibles como instrumentos.

Vamos a estimar por GMM.

AB es un estimador de GMM. En este tipo de estimadores partimos de saber que una condición se cumple. Por ejemplo, en IV sabemos que

$$
E(z'u)=0.
$$

De acá podemos despejar el estimador de IV, igual que como hicimos en econometría:

$$
E\left[z'(y-X\beta)\right]=0.
$$

Entonces,

$$
\hat\beta_{IV}
=
(z'X)^{-1}z'y.
$$

“Problema”, como en AB: tenemos más instrumentos que variables endógenas.

La condición

$$
E(z'u)=0
$$

tiene que valer. Si esto está formado por $z_1$ y $z_2$, ambos entran en el sistema:

$$
\begin{cases}
E(z_1'u)=0,\\
E(z_2'u)=0.
\end{cases}
$$

En simultáneo no puedo ver a qué $\beta$ se satisface exactamente para ambos casos. Entonces minimizo las distancias a ambos.

Explicación precisa: Hay que usar `xtabond2` (con inversa capaz).

De esta minimización de distancia sale la matriz ponderadora para el estimador de GMM. Suele, como vimos en todos los casos en econometría y en el PS pasado, venir de la varianza:

$$
\hat\beta_{GMM}
=
\left[
X'Z(Z'\Omega Z)^{-1}Z'X
\right]^{-1}
X'Z(Z'\Omega Z)^{-1}Z'y.
$$

Pregunta: ¿qué es $\Omega$?

Hay dos opciones:

1. Conozco

$$
\Omega=\sigma_u^2 I,
$$

entonces la uso directamente: GMM de un paso.

2. GMM de dos pasos: primero estimo residuos para armar

$$
\hat\Omega.
$$

---

## f) Blundell-Bond

BB $\Rightarrow$ **system GMM estimator**.

Usan la ecuación en diferencias instrumentada con los niveles rezagados, y la ecuación en niveles instrumentada con las diferencias rezagadas.

---

## Mapeo provisional contra el mapa 2023

Estas notas corresponden claramente a **modelos de panel dinámico**:

- abandono de exogeneidad estricta;
- modelo autorregresivo con dependiente rezagada;
- sesgo de panel dinámico / sesgo de Nickell;
- comparación entre OLS, FE y FD;
- Anderson-Hsiao;
- Arellano-Bond;
- GMM de un paso y dos pasos;
- Blundell-Bond / system GMM.

Con el mapa 2023, esto parece corresponder a **PS3, Ej. 1**. En tu mapa previo, P05 era:

> P05 -> PS3: ex1, cuentas e intuición; incompleto

Este set encaja muy bien con esa descripción: hay cuentas e intuición extensas para el Ej. 1 de paneles dinámicos, y el cierre queda bastante esquemático al llegar a GMM/System GMM.
