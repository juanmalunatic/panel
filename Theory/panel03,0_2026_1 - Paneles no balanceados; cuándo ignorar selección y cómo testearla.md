# Econometría de Datos de Panel

Maestrías en Economía y Econometría  
Lecture 3

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026

---

## Agenda

1. Sesgo de Selección: “Attrition” y Truncamiento Incidental
   - Cuándo Podemos Ignorar el Sesgo de Selección?
   - Contrastes por Sesgo de Selección
   - Corrección del Sesgo de Selección Muestral: Truncamiento Incidental
   - Procedimiento de Wooldridge
   - Procedimiento de Rochina-Barrachina
   - Corrección del Sesgo de Selección Muestral: Attrition
2. Sesgo de Selección y Endogeneidad

---

## Agenda

1. Sesgo de Selección: “Attrition” y Truncamiento Incidental
   - Cuándo Podemos Ignorar el Sesgo de Selección?
   - Contrastes por Sesgo de Selección
   - Corrección del Sesgo de Selección Muestral: Truncamiento Incidental
   - Procedimiento de Wooldridge
   - Procedimiento de Rochina-Barrachina
   - Corrección del Sesgo de Selección Muestral: Attrition
2. Sesgo de Selección y Endogeneidad

---

## Paneles No Balanceados

Muchas veces, los datos que tenemos tienen la característica de que algunas observaciones de series temporales no están disponibles para algunas observaciones de corte transversal.

Cuando esto ocurre, decimos que tenemos paneles no balanceados.

Los paneles no balanceados pueden surgir por varias razones.

Primero, por diseño de la muestra. Por ejemplo, el procedimiento puede simplemente rotar algunas de las observaciones de corte transversal de acuerdo a una regla específica (paneles rotativos).

Un problema más complicado surge cuando algunas unidades de corte transversal eligen salirse del panel (attrition).

Un problema diferente es cuando las unidades no desaparecen del panel pero ciertas variables no son observadas por al menos algunos períodos temporales (truncamiento incidental).

---

## Paneles No Balanceados

Cualquiera de estos casos puede presentar potencialmente un problema de sesgo de selección muestral.

Si la decisión de rotar las unidades de corte transversal no se hace aleatoriamente, ó si hay no respuesta relacionada con la variable a explicar, tendremos un problema de sesgo en la muestra.

De la misma manera, si la attrition se basa en factores sistemáticamente relacionados con la variable a explicar, entonces tendremos un problema de sesgo de selección.

Por último, si la variable a explicar solo se observa para algunos valores determinados por el comportamiento de alguna otra variable, entonces, potencialmente habrá sesgo de selección.

---

## Paneles No Balanceados

Comenzaremos analizando los supuestos bajo los cuales, el estimador usual de FE es consistente en paneles desbalanceados.

Considere el siguiente modelo de componentes no observados,

$$
y_{it} = x_{it}\beta + c_i + u_{it}, \quad t = 1,2,\ldots,T
\tag{1}
$$

donde $x_{it}$ es $1 \times K$ y $\beta$ es $K \times 1$, y $\operatorname{Cov}(x_{it}, c_i) \neq 0$. Asumimos que hay disponibles $N$ observaciones de corte transversal y que la teoría asintótica relevante es con $N \longrightarrow \infty$.

Considere el caso en el que algunos períodos temporales no se encuentran disponibles para algunas unidades de corte transversal. Piense en $t=1$ como el primer período temporal para el que existen datos para toda la población y en $t=T$ como el último período temporal.

---

## Paneles No Balanceados

Para una selección al azar $i$ desde la población, sea $s_i \equiv (s_{i1},s_{i2},\ldots,s_{iT})'$ el vector $T \times 1$ de indicadores de selección: $s_{it}=1$ si $(x_{it}; y_{it})$ es observado, y cero en otro caso.

Podemos tratar a $(x_i; y_i; s_i): i=1;2;\ldots;N$ como una muestra aleatoria de la población; los indicadores de selección nos dicen qué períodos temporales se observan para cada $i$.

Podemos encontrar fácilmente supuestos bajo los cuales el estimador de efectos fijos en el panel no balanceado es consistente. Para eso escribamos el estimador como,

$$
\hat{\beta}
=
\left(
N^{-1}\sum_{i=1}^{N}\sum_{t=1}^{T}s_{it}\ddot{x}_{it}'\ddot{x}_{it}
\right)^{-1}
\left(
N^{-1}\sum_{i=1}^{N}\sum_{t=1}^{T}s_{it}\ddot{x}_{it}'\ddot{y}_{it}
\right)
$$

$$
= \beta +
\left(
N^{-1}\sum_{i=1}^{N}\sum_{t=1}^{T}s_{it}\ddot{x}_{it}'\ddot{x}_{it}
\right)^{-1}
\left(
N^{-1}\sum_{i=1}^{N}\sum_{t=1}^{T}s_{it}\ddot{x}_{it}'u_{it}
\right)
\tag{2}
$$

---

## Paneles No Balanceados

Donde

$$
\ddot{x}_{it}=x_{it}-\frac{1}{T_i}\sum_{r=1}^{T}s_{ir}x_{ir};
\qquad
\ddot{y}_{it}=y_{it}-\frac{1}{T_i}\sum_{r=1}^{T}s_{ir}y_{ir}
$$

and

$$
T_i = \sum_{r=1}^{T}s_{ir}.
$$

Esto es, $T_i$ es el número de períodos temporales observados para la unidad de corte transversal $i$, y aplicamos la transformación de FE sobre los períodos temporales disponibles.

Como se desprende de la ecuación anterior, el estimador de efectos fijos en paneles desbalanceados será consistente siempre que: $E(s_{it}\ddot{x}_{it}'u_{it})=0$, $\forall t$.

Como $\ddot{x}_{it}$ depende de todos los elementos en $x_i$ y $s_i$, necesitamos alguna forma de exogeneidad estricta.

**Supuesto FEUP.1:**

(a) $E(u_{it}|x_i;s_i;c_i)=0$, $t=1;2;\ldots;T$;

(b) $\sum_{t=1}^{T}E(s_{it}\ddot{x}_{it}'\ddot{x}_{it})$ no es singular; y

(c) $E(u_i u_i'|x_i;s_i;c_i)=\sigma_u^2 I_T$.

Bajo el Supuesto FEUP.1 (a), $E(s_{it}\ddot{x}_{it}'u_{it})=0$ usando la ley de expectativas iteradas.

---

## Paneles No Balanceados

FEUP.1 (b) es la condición de rango usual para identificar el estimador de FE después de tomar en cuenta el indicador de selección.

Estos primeros dos supuestos aseguran la consistencia del estimador de efectos fijos en paneles desbalanceados.

En el caso de paneles rotativos aleatorios, ó en el caso de que la no respuesta sea aleatoria y en cualquier otro caso en el que el mecanismo de selección sea completamente aleatorio, si es independiente de $(u_i; x_i; c_i)$, en cuyo caso el Supuesto FEUP.1 (a) se cumple bajo el supuesto estándar de efectos fijos en paneles completos $E(u_{it}|x_i;c_i)=0$ $\forall t$.

En este caso, los supuestos naturales sobre el modelo poblacional implican consistencia y normalidad asintótica en paneles no balanceados.

---

## Paneles No Balanceados

Note que FEUP.1(a) no asume nada acerca de la relación entre $s_i$ y $(x_i,c_i)$.

Por lo tanto, si pensamos que el mecanismo de selección en todos los períodos temporales está correlacionado con $c_i$ ó $x_i$, pero $u_{it}$ es independiente en media de $s_i$, dado $(x_i,c_i)$ para todo $t$, entonces FE en el panel no balanceado es consistente y asintóticamente normal.

Lo que FEUP.1(a) descarta es correlación entre $s_i$, y $u_{it}$.

Si adicionamos el supuesto FEUP.1(c), los procedimiento de inferencia estándar de FE son válidos. En particular bajo FEUP.1 (a) y FEUP.1 (c),

$$
\operatorname{Var}\left(\sum_{t=1}^{T}s_{it}\ddot{x}_{it}'u_{it}\right)
=
\sigma_u^2\left[\sum_{t=1}^{T}E(s_{it}\ddot{x}_{it}'\ddot{x}_{it})\right]
$$

---

## Paneles No Balanceados

Por lo tanto, la varianza asintótica del estimador de efectos fijos se puede estimar con:

$$
\hat{\sigma}_u^2
\left(
\sum_{i=1}^{N}\sum_{t=1}^{T}s_{it}\ddot{x}_{it}'\ddot{x}_{it}
\right)^{-1}
$$

El estimador $\hat{\sigma}_u^2$ se puede obtener con,

$$
\hat{\sigma}_u^2
=
\left[\sum_{i=1}^{N}(T_i-1)\right]^{-1}
\sum_{i=1}^{N}\sum_{t=1}^{T}s_{it}\hat{u}_{it}^{2}
$$

donde $\hat{u}_{it}$ son los residuos de la estimación por efectos fijos.

Los programas que resuelven datos de panel no balanceados (Stata, EViews etc.) corrigen por grados de libertad restando $K$ de $\sum_{i=1}^{N}(T_i-1)$. Se sigue que todos los estadísticos usuales de efectos fijos calculados en un panel no balanceado son válidos.

---

## Paneles No Balanceados

Relajar el Supuesto FEUP.1 (c) es fácil: solo se aplica la estimación robusta de la matriz de varianzas y covarianzas al panel desbalanceado.

Estos resultados implican que el sesgo de selección muestral en el contexto del modelo de FE es un problema sólo si el mecanismo de selección está relacionado con los errores idiosincráticos, $u_{it}$.

Por lo tanto, cualquier test de selección muestral solo tiene que contrastar este supuesto.

La consistencia del estimador de efectos aleatorios (en paneles balanceados o no balanceados) requiere un supuesto adicional, $E(c_i|x_i,s_i)=E(c_i)$. Una limitación importante de este supuesto es que descarta que la selección pueda depender de la heterogeneidad no observada $c_i$.

---

## Agenda

1. Sesgo de Selección: “Attrition” y Truncamiento Incidental
   - Cuándo Podemos Ignorar el Sesgo de Selección?
   - Contrastes por Sesgo de Selección
   - Corrección del Sesgo de Selección Muestral: Truncamiento Incidental
   - Procedimiento de Wooldridge
   - Procedimiento de Rochina-Barrachina
   - Corrección del Sesgo de Selección Muestral: Attrition
2. Sesgo de Selección y Endogeneidad

---

## Paneles No Balanceados: Inferencia

Un contraste de hipótesis simple fue desarrollado por Nijman y Verbeek (1992): adicione el indicador de selección rezagado, $s_{i,t-1}$, a la ecuación.

Estime el modelo usando efectos fijos (sobre el panel desbalanceado), y haga un contraste $t$ (haciéndolo completamente robusto) para chequear si $s_{i,t-1}$ es estadísticamente relevante.

Bajo la hipótesis nula, $u_{it}$ no está correlacionado con $s_{ir}$ para todo $r$, y entonces el indicador de selección en el período temporal anterior no debiera ser relevante en la ecuación del período $t$. (Incidentalemente, nunca tendría sentido poner $s_{it}$ en la ecuación del período $t$ porque $s_{it}=1$ para todo $i$ y $t$ en la sub-muestra seleccionada.)

---

## Paneles No Balanceados: Inferencia

Poner $s_{i,t-1}$ no funciona si $s_{i,t-1}$ es uno siempre que $s_{it}$ es uno porque entonces no hay variación en $s_{i,t-1}$ en la muestra seleccionada. Este es el caso de los problemas de attrition donde, digamos, una persona solo puede aparecer en el período $t$ si el o ella aparecieron en $t-1$.

Una alternativa es incluir un adelanto del indicador de selección, $s_{i,t+1}$. Para las observaciones $i$ que están en la muestra todos los períodos, $s_{i,t+1}$ siempre es uno. Pero para los que se van de la muestra (attriters), $s_{i,t+1}$ cambia de uno a cero justo en el período anterior a salirse del panel.

---

## Paneles No Balanceados: Ejemplo Attrition

Los datos de la Tabla 1 corresponden a producto en millones de kilovatios-horas y el costo total de generación de energía en millones de dólares para diez firmas observadas durante 4 años.

**Descripción funcional de la tabla:** la tabla ilustra un panel no balanceado por *attrition*: algunas firmas dejan de ser observadas en los períodos finales, de modo que las celdas aparecen como `n.a.` desde cierto momento en adelante.

### Tabla 1

| Firma | Variable | $t=1$ | $t=2$ | $t=3$ | $t=4$ |
|---:|---|---:|---:|---:|---:|
| $i=1$ | Costo | 3 | 4 | 5 | 6 |
|  | Producto | 214 | 419 | 588 | 1025 |
| $i=2$ | Costo | 4 | 6 | 8 | n.a. |
|  | Producto | 696 | 811 | 1640 | n.a. |
| $i=3$ | Costo | 19 | 26 | 32 | n.a. |
|  | Producto | 3202 | 4802 | 5821 | n.a. |
| $i=4$ | Costo | 35 | 51 | 61 | n.a. |
|  | Producto | 5668 | 7612 | 10206 | n.a. |
| $i=5$ | Costo | 33 | 40 | n.a. | n.a. |
|  | Producto | 6000 | 8222 | n.a. | n.a. |

---

## Paneles No Balanceados: Ejemplo Attrition

### Tabla 1 (Cont.)

| Firma | Variable | $t=1$ | $t=2$ | $t=3$ | $t=4$ |
|---:|---|---:|---:|---:|---:|
| $i=6$ | Costo | 73 | 99 | n.a. | n.a. |
|  | Producto | 11796 | 15551 | n.a. | n.a. |
| $i=7$ | Costo | 80 | 106 | n.a. | n.a. |
|  | Producto | 11803 | 15558 | n.a. | n.a. |
| $i=8$ | Costo | 95 | n.a. | n.a. | n.a. |
|  | Producto | 11818 | n.a. | n.a. | n.a. |
| $i=9$ | Costo | 116 | 142 | n.a. | n.a. |
|  | Producto | 11839 | 15594 | n.a. | n.a. |
| $i=10$ | Costo | 144 | n.a. | n.a. | n.a. |
|  | Producto | 11867 | n.a. | n.a. | n.a. |

---

## Paneles No Balanceados: Ejemplo Attrition

Base de datos para implementar el test de Nijman-Verbeek,

**Descripción funcional de la tabla:** esta tabla reestructura los datos anteriores en formato largo para correr una regresión de efectos fijos. La columna $s(i,t+1)$ marca si la firma seguirá observada en el período siguiente; sirve para implementar el contraste de attrition usando el adelanto del indicador de selección.

| Firma | Tiempo | Costo | Producto | $s(i,t+1)$ |
|---:|---:|---:|---:|---:|
| 1 | 1 | 3.154 | 214 | 1 |
| 1 | 2 | 4.271 | 419 | 1 |
| 1 | 3 | 4.584 | 588 | 1 |
| 2 | 1 | 3.859 | 696 | 1 |
| 2 | 2 | 5.535 | 811 | 1 |
| 2 | 3 | 8.127 | 1640 | 0 |
| 3 | 1 | 19.035 | 3202 | 1 |
| 3 | 2 | 26.041 | 4802 | 1 |
| 3 | 3 | 32.444 | 5821 | 0 |
| 4 | 1 | 35.229 | 5668 | 1 |
| 4 | 2 | 51.111 | 7612 | 1 |
| 4 | 3 | 61.045 | 10206 | 0 |
| 5 | 1 | 33.154 | 6000 | 1 |
| 5 | 2 | 40.044 | 8222 | 0 |
| 6 | 1 | 73.05 | 11796 | 1 |
| $\vdots$ | $\vdots$ | $\vdots$ | $\vdots$ | $\vdots$ |

---

## Paneles No Balanceados: Ejemplo Attrition

En Stata,

```stata
gen lncit=ln(cost)
gen lnyit=ln(output)
iis firm
tis time
areg lncit lnyit sit1, absorb(firm) robust
outreg using attrition1, 3aster
type attrition1.out
```

|  | lncit |
|---|---:|
| lnyit | 0.540 |
|  | (3.94)*** |
| $s(i,t+1)$ | -0.116 |
|  | (1.97)* |
| Constant | -1.040 |
|  | (0.88) |
| Observations | 22 |
| R-squared | 0.99 |

Robust $t$ statistics in parentheses.  
\* significant at 10%; \*\*\* significant at 1%

---

## Paneles No Balanceados: Inferencia

Para los problemas de truncamiento incidental tiene sentido extender el test de Heckman (1976) al contexto de datos de panel con heterogeneidad no observada. Esto es hecho por Wooldridge (1995). Escribamos la ecuación de interés como

$$
y_{it}=x_{it}\beta+c_i+u_{it}, \quad t=1,2,\ldots,T
\tag{3}
$$

Heckit

Inicialmente supongamos que $y_{it}$ se observa solo si el indicador de selección, $s_{it}$, es uno.

Suponga que, para cada $t$, $s_{it}$ está determinado por la ecuación probit

$$
s_{it}=1[\eta_0+\bar{x}_i\eta+x_{it}\delta+v_{it}>0], \quad v_{it}|x_i \sim \operatorname{Normal}(0,1)
\tag{4}
$$

El mecanismo de selección descripto en la ecuación (4) no necesita estar correctamente especificado para obtener un buen contraste (vea Wooldridge, 1995).

---

## Paneles No Balanceados: Inferencia

Bajo la hipótesis nula del test, en el Supuesto FEUP.1 (a) (con los cambios notacionales obvios), la inversa del cociente de Mills obtenida de la estimación del modelo probit no debiera ser estadísticamente relevante en la ecuación estimada por efectos fijos

Sea $\hat{\lambda}_{it}$ la inversa del cociente de Mills estimada en la ecuación (4) por pooled probit a través de $i$ y $t$. Entonces, un contraste válido de la hipótesis nula es un estadístico $t$ (robusto ante la presencia de heterocedasticidad y correlación serial) sobre el coeficiente de $\ddot{\hat{\lambda}}_{it}=\hat{\lambda}_{it}-T_i^{-1}\sum_{r=1}^{T}s_{ir}\hat{\lambda}_{ir}$ en la estimación de FE usando solo aquellas observaciones para las que $s_{it}=1$,

$$
\ddot{y}_{it}=\ddot{x}_{it}\beta+\rho_{\lambda}\ddot{\hat{\lambda}}_{it}+error_{it}
$$

Wooldridge (1995) muestra formalmente que la estimación probit del primer paso no afecta la distribución asintótica del estadístico $t$ bajo $H_0: \rho = 0$ en la última ecuación.

---

## Paneles No Balanceados: Ejemplo Truncamiento Incidental

Mismos datos que en la Tabla 1, pero...

**Descripción funcional de la tabla:** esta tabla mantiene la estructura general del ejemplo anterior, pero cambia el patrón de datos faltantes para ilustrar *truncamiento incidental*: algunas observaciones de costo son no observadas mientras que el producto sí aparece para esos períodos, de modo que el panel no se pierde necesariamente por salida definitiva de la firma.

| Firma | Variable | $t=1$ | $t=2$ | $t=3$ | $t=4$ |
|---:|---|---:|---:|---:|---:|
| $i=1$ | Costo | 3 | 4 | 5 | 6 |
|  | Producto | 214 | 419 | 588 | 1025 |
| $i=2$ | Costo | 4 | 6 | 8 | n.a. |
|  | Producto | 696 | 811 | 1640 | 2506 |
| $i=3$ | Costo | 19 | 26 | 32 | n.a. |
|  | Producto | 3202 | 4802 | 5821 | 9275 |
| $i=4$ | Costo | 35 | 51 | 61 | n.a. |
|  | Producto | 5668 | 7612 | 10206 | 13702 |
| $i=5$ | Costo | 33 | 40 | n.a. | n.a. |
|  | Producto | 6000 | 8222 | n.a. | 10004 |
| $\vdots$ | $\vdots$ | $\vdots$ | $\vdots$ | $\vdots$ | $\vdots$ |

---

## Paneles No Balanceados: Truncamiento Incidental

En Stata:

```stata
sort firm time
by firm: egen lnyit=mean(lnyit)
probit sit lnyit lnyit
predict sitf, xb
gen lambdait=normden(sitf)/norm(sitf)
areg lncit lnyit lambdait, absorb(firm) robust
outreg using itrunc, 3aster
type itrunc.out
```

|  | lncit |
|---|---:|
| lnyit | 0.521 |
|  | (4.33)*** |
| $\hat{\lambda}_{it}$ | 0.140 |
|  | (1.66) |
| Constant | -1.012 |
|  | (1.02) |
| Observations | 23 |
| R-squared | 0.99 |

Robust $t$ statistics in parentheses.  
\*\*\* significant at 1%, $\hat{\lambda}_{it}$ significant at 13%
