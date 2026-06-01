# Clase 6

## Problem Set 3 - Clase 6

Del ejercicio 1 nos quedamos como conclusión que, en paneles dinámicos, POLS sobreestima el valor de $\rho$ y que en modelos de FE eliminamos la heterogeneidad no observada, pero subestimamos el valor de $\rho$ por el sesgo de Nickell.

Además, Anderson-Hsiao (AH) instrumenta con el segundo lag y es el primer estimador consistente, **pero** no el más eficiente. Arellano-Bond agrega más lags —todos los disponibles— y es un estimador de MC2E. Va a ser más eficiente, **pero** puede haber problemas en el caso de instrumentos débiles o cuando $\rho \to 1$.

Blundell-Bond (BB) plantea un **system GMM**, donde tenemos:

- la ecuación en diferencias, instrumentada con los niveles;
- la ecuación en niveles, instrumentada con las diferencias.

En Stata, todos son variantes de `xtabond2`.

Algo que no hablamos: incluir **time dummies**. Ayudan a que se sostenga el supuesto de no correlación entre individuos. Este supuesto lo necesitan los test de autocorrelación y para obtener estimaciones robustas.

---

## Ejercicio 2

Modelo de panel dinámico con variables exógenas:

$$
y_{it}=\alpha y_{i,t-1}+x_{it}\beta+\mu_i+v_{it},
$$

con

$$
\varepsilon_{it}=\mu_i+v_{it},
$$

más variables exógenas.

Supuestos:

$$
E(\mu_i)=E(v_{it})=E(\mu_i v_{it})=0.
$$

En este ejercicio:

$$
\begin{aligned}
n_{it}
&=\rho_1 n_{i,t-1}+\rho_2 n_{i,t-2}
+\beta_0 w_{it}+\beta_1 w_{i,t-1}+\beta_2 w_{i,t-2} \\
&\quad +\theta_0 k_{it}+\theta_1 k_{i,t-1}+\theta_2 k_{i,t-2}
+\gamma_0 ys_{it}+\gamma_1 ys_{i,t-1}+\gamma_2 ys_{i,t-2} \\
&\quad +\sum_{t=77}^{84}\delta_t d_t+\mu_i+v_{it}.
\end{aligned}
$$

Partimos de que todos, menos los rezagos de $n_i$, son exógenos.

### a) Estimación OLS robusta

Estimación OLS robusta: lo vimos en el ejercicio 1, hay sesgo de paneles dinámicos.

Pensémoslo en este contexto:

$$
1976 \to 1984.
$$

Por ejemplo, en 1980 hay un shock negativo sobre el empleo de la empresa $i$:

$$
1980 \to \text{shock negativo a }n_{i,80}
\Rightarrow \downarrow n_{i,81}
\Rightarrow \downarrow n_{i,82}
\Rightarrow \cdots
$$

Pero si POLS no considera que hay un $c_i$ que afecta a esa firma en todos los periodos, ¿qué va a estimar $\hat\rho_{POLS}$?

Esquema de la nota:

$$
\downarrow n_{i,80}
\;\Rightarrow\;
\downarrow n_{i,81}
\;\Rightarrow\;
\downarrow n_{i,82}
\;\Rightarrow\;\cdots
$$

con $c_i$ afectando en cada periodo.

Conclusión de la nota: estoy sobreestimando el impacto del rezago del empleo.

### b) Estimación FE

$$
FE \Rightarrow \text{aplico la transformación within}
\Rightarrow \hat\rho_{FE}\text{ subestima el verdadero valor.}
$$

Ojo con los valores de las dummies temporales; ya lo vimos en PS2.

### c) Anderson-Hsiao

$$
AH
$$

Spoiler: no le va a ir tan bien a $\hat\rho_{AH}$.

Recuerden que

$$
|\hat\delta|<1
$$

es la condición de estabilidad —lo vimos en series de tiempo—. Acá esto no va a valer. El desvío estándar va a ser muy alto.

### d) Arellano-Bond

$$
AB
$$

Asumiendo endogeneidad solo por $n_{i,t-1}$ y $n_{i,t-2}$ —las demás variables que agregamos son exógenas—.

Pregunta de la nota:

> ¿Tiene sentido pensar que el salario y el stock de capital son exógenos? ¿O tiene sentido pensar que se relacionan con el error compuesto?

La nota sugiere:

$$
c_i \Rightarrow \text{management}
$$

Entonces aparece la pregunta:

> ¿Cómo incluimos variables no estrictamente exógenas?

---

## Ejercicio 3

Cuando incorporamos muchos instrumentos, los errores estándar se sesgan hacia abajo lo suficiente como para hacer inútil la estimación two-step de GMM.

No hay mucha evidencia/acuerdos sobre cuántos instrumentos son muchos.

Modelo:

$$
\begin{aligned}
\Delta n_{it}
&=\rho_1\Delta n_{i,t-1}+\rho_2\Delta n_{i,t-2}
+\beta_0\Delta w_{it}+\beta_1\Delta w_{i,t-1} \\
&\quad +\theta_0\Delta k_{it}+\theta_1\Delta k_{i,t-1}+\theta_2\Delta k_{i,t-2}
+\Delta v_{it}.
\end{aligned}
$$

Lo instrumento —por AB— solo con lags 2 a 3. Ojo con el código.

El lag 2 es ir un periodo para atrás, es decir, ir de $n_{i,t-1}$ a $n_{i,t-2}$.

Ojo porque si no nos vamos mucho para atrás en el tiempo y perdemos los lags “más cercanos”, que podrían ser los que más “información” contienen —los más relevantes—.

### Collapse

“Collapse” = colapsar. Podemos pensarlo como agrupar los instrumentos.

Construye un instrumento para cada variable y para cada lag, **no** uno por periodo, variable y lag como es sin la opción `collapse`.

Entonces:

$$
\text{collapse} \Rightarrow \text{agrupa por periodo temporal.}
$$

En nuestras pequeñas muestras, estima el sesgo de múltiples instrumentos / overfitting.

BOCA: achica el sistema que hay que solucionar en el problema de minimización en la primera etapa de MC2E para que valga la exogeneidad de los instrumentos.

---

## Ejercicio 4

### LSDV

$$
LSDV \Rightarrow \text{tipo de estimación de efecto fijo.}
$$

En panel no dinámico, el “problema” es que es incómoda la lectura de la salida, porque agrega una dummy por cada unidad de corte transversal.

En panel dinámico, aparece el mismo problema que en los demás estimadores de FE:

$$
\text{sesgo de Nickell.}
$$

Lo estima Kiviet (1995) “up to a certain extent”: queda una partecita que tiende a $0$.

Kiviet toma estimación LSDV y corrige con el sesgo. Entonces “soluciona” efectos fijos y sesgo de paneles dinámicos. Lo prueba con simulaciones de Monte Carlo.

Se llama estimación:

$$
LSDVC
$$

es decir, LSDV corrected.

### Recorte de slide: Kiviet (1995)

**Teorema 1 (Kiviet, 1995, pp. 64)**

$$
\begin{aligned}
E(\hat\delta_{FE}-\delta)
&= -\sigma_u^2\bar D^{-1}
\Bigg(
\frac{N}{T}(J_T'CJ_T)
\left[2q-\bar W'Q_{NT}\bar W\bar D^{-1}q\right] \\
&\quad +\operatorname{tr}\left\{\bar W'(I_N\otimes Q_T C Q_T)\bar W\bar D^{-1}\right\}q \\
&\quad +\bar W'(I_N\otimes Q_T C C Q_T)\bar W\bar D^{-1}q
+\sigma_u^2Nq'\bar W'\bar D^{-1}q \\
&\quad \times
\left[
\frac{N}{T}(J_T'CJ_T)\operatorname{tr}\{C'Q_TC\}
+2\operatorname{tr}\{C'Q_TCQ_TC\}
\right]
\Bigg) \\
&\quad +O_p(N^{-1}T^{-3/2}) \\
&= \text{Sesgo}_{Kiviet}+O_p(N^{-1}T^{-3/2}).
\end{aligned}
$$

Donde:

$$
\bar D
=\bar W'Q_{NT}\bar W
+\sigma_u^2N\operatorname{tr}\{C'Q_TC\}qq',
$$

$$
Q_{NT}\bar W=E(Q_{NT}W),
$$

$$
q=(1,0,\ldots,0)',
\qquad
\delta'=(\gamma,\beta')'.
$$

La matriz $C$ tiene la forma:

$$
C=
\begin{bmatrix}
0 & 0 & \cdots & \cdots & \cdots & \cdots & 0 \\
1 & 0 & \cdots & \cdots & \cdots & \cdots & 0 \\
\gamma & 1 & 0 & \cdots & \cdots & \cdots & 0 \\
\gamma^2 & \gamma & 1 & 0 & \cdots & \cdots & 0 \\
\vdots & \vdots & \vdots & \vdots & \vdots & \vdots & \vdots \\
\gamma^{T-2} & \cdots & \cdots & \cdots & \gamma & 1 & 0
\end{bmatrix}.
$$

- El único parámetro desconocido en $C$ es $\gamma$.
- Kiviet sugiere reemplazarlo con la estimación de IV de Anderson-Hsiao.
- Para el modelo $AR(1)$, Anderson y Hsiao (1982) aplican diferencias finitas para eliminar $c_i$.

$$
\Delta y_{it}=\rho\Delta y_{i,t-1}+\Delta u_{it},
\qquad t>2.
$$

Anotación manuscrita al costado: también podríamos estimar por AB y BB.

### ¿Cómo hacer inferencia?

#### Alternativa 1

Hay que construir a mano la matriz de VCOV.

1. Calcular los residuos del modelo.
2. Estimar $\hat\sigma_u^2$ y ajustar grados de libertad.
3. Usar:

$$
\operatorname{Var}(\hat\delta_{LSDVC})
=\hat\sigma_u^2\left(\sum_{i=1}^N Z_i'Z_i\right)^{-1}.
$$

#### Alternativa 2

Bootstrapear:

```stata
vce(bootstrap)
```

opción `vcov(#)` en Stata.

---

## Notas de lectura / posibles ambigüedades

- En el inciso c) del ejercicio 2, la condición de estabilidad aparece escrita como $|\hat\delta|<1$. Por contexto de panel dinámico/AR, podría estar refiriéndose al coeficiente autorregresivo; mantuve la notación visible.
- En el modelo del ejercicio 3 transcribí solo las variables visibles en la línea manuscrita: rezagos de $n$, diferencias de $w$, diferencias de $k$ y $\Delta v_{it}$.
- En el recorte de Kiviet, la fórmula se transcribió desde el fragmento digital visible; mantuve la estructura y notación del recorte.

---

## Mapeo provisional contra el mapa 2023

Estas notas corresponden claramente a **PS3: cierre del ejercicio 1 + ejercicios 2, 3 y 4**.

Encajan muy bien con el mapa 2023:

> P06 -> PS3: cierre ex1 + ex2, ex3, ex4

La clase retoma explícitamente las conclusiones del ejercicio 1 de paneles dinámicos —POLS, FE, Nickell, Anderson-Hsiao, Arellano-Bond y Blundell-Bond— y luego pasa por los ejercicios 2, 3 y 4. La etiqueta de 2023 se mantiene muy sólida.
