# Clase 3 — transcripción de notas manuscritas

**Materia:** Panel Data Econometrics  
**Fuente:** `Clase 3.pdf`  
**Estado de transcripción:** OCR/reconstrucción manual desde manuscrito + recorte digital.  
**Nota:** mantuve la notación del apunte lo más fielmente posible. Cuando una palabra o símbolo no era 100% legible, lo marqué como lectura probable.

---

## Página 1

# Clase 3 (PS1)

## EJ2

Trabajamos con una matriz como si fuera nuestro dataset:

| id | t | var. exc. |
|---:|---:|---:|
| 1 | 1 | $\sigma_1^2$ |
| 1 | 2 | $\sigma_1^2$ |
| $\vdots$ | $\vdots$ | $\vdots$ |
| 1 | 15 | $\sigma_1^2$ |
| 2 | 1 | $\sigma_2^2$ |
| 2 | 2 | $\sigma_2^2$ |
| $\vdots$ | $\vdots$ | $\vdots$ |
| 2 | 15 | $\sigma_2^2$ |

$$
\sigma_1^2, \sigma_2^2 \Rightarrow \text{son los casos que observamos.}
$$

Básicamente vamos a “ver” el mismo numerito repetido 15 veces para cada unidad del corte transversal.

Decimos “ver” porque no conocemos efectivamente el valor de $\sigma_i^2$ y lo tendremos que estimar por los medios que nos dice el enunciado:

1. FGLS.
2. Heterocedasticidad multiplicativa de Harvey.

---

### (1) FGLS por pesos

Procedimiento usual:

1. Regresar $y$ sobre $x$:

   $$
   y \text{ sobre } x \Rightarrow \text{obtengo } e_j \text{ (residuos)}
   $$

2. Asigno $\hat{\sigma}_j^2$ a cada firma, siguiendo el enunciado:

   $$
   \hat{\sigma}_j^2 = \frac{e_j'e_j}{n_j}
   $$

---

### (2) Heterocedasticidad multiplicativa de Harvey

Partiendo del paso (1) de FGLS, definimos:

$$
\ln(e^2) = \ln(e'e)
$$

- Por OLS estima la regresión:

  $$
  \ln(e^2) = \gamma \ln(x)
  $$

- Usa `predict` para obtener:

  $$
  \widehat{\ln(e^2)}
  $$

- Arma los `weights`.

En Stata va a haber un código que hace todos los pasos de una.

---

## PS2 — Modelos de D.P. lineales

Incorporamos la heterogeneidad no observada, $c_i$:

$$
y_{it} = x_{it}\beta + c_i + u_{it}
$$

donde:

$$
c_i \text{ no varía en el tiempo}
$$

Entonces, si no lo considero voy a tener problemas de endogeneidad.

---

## Página 2

¿Puedo tratarlo como un efecto aleatorio o es un efecto fijo? Según la respuesta a esa pregunta uso el modelo RE o FE.

$$
RE = \text{vble. aleatoria, ausencia de corr entre } x_{it} \text{ y } c_i \quad \forall t
$$

$$
FE = \text{permite } \operatorname{corr}(x_{it}, c_i) \neq 0
$$

Si lo tomo como aleatorio:

$$
\Rightarrow \text{no interactúa con } x_i
\Rightarrow \text{lo puedo meter en el error.}
$$

**Problema:** matriz de VCOV. Usamos GLS para estimar:

$$
\hat{\Omega}
=
\hat{\sigma}_c^2 J_T J_T'
+
\hat{\sigma}_u^2 I_T
$$

Si no lo tomo como aleatorio, vamos a aprender formas de “quitar” el efecto constante en el tiempo.

---

### Primera estrategia: transformación within

Les dejo la slide que lo explica:

#### Within Transformation

La transformación de FE se obtiene promediando la ecuación (38) sobre $t = 1, 2, \ldots, T$ para obtener la ecuación de corte transversal:

$$
\bar{y}_i = \bar{x}_i\beta + c_i + \bar{u}_i
\tag{39}
$$

donde:

$$
\bar{y}_i = \frac{1}{T}\sum_{t=1}^{T} y_{it},
\qquad
\bar{x}_i = \frac{1}{T}\sum_{t=1}^{T} x_{it},
\qquad
\bar{u}_i = \frac{1}{T}\sum_{t=1}^{T} u_{it}
$$

Nota manuscrita:

$$
\Rightarrow \text{ec. de la media temporal}
$$

Restando miembro a miembro (39) de (38), se obtiene:

$$
y_{it} - \bar{y}_i
=
(x_{it} - \bar{x}_i)\beta
+
u_{it} - \bar{u}_i
$$

$$
\ddot{y}_{it}
=
\ddot{x}_{it}\beta
+
\ddot{u}_{it}
\tag{40}
$$

Nota manuscrita:

$$
\Rightarrow \text{ec. de la within transformation}
$$

donde:

$$
\ddot{y}_{it} = y_{it} - \bar{y}_i,
\qquad
\ddot{x}_{it} = x_{it} - \bar{x}_i,
\qquad
\ddot{u}_{it} = u_{it} - \bar{u}_i
$$

Con $c_i$ fuera de la ecuación es lógico pensar en estimar (40) por POLS.

---

### b) Interpretación de coeficientes de la regresión within

Ojo con cómo interpreto los coeficientes de la regresión within:

$$
w lcrmrte_{it}
=
lcrmrte_{it}
-
\overline{lcrmrte}_i
$$

Ya eliminé de la observación todo lo que es fijo.

---

### c) Acerca de la estimación

1. Es consistente siempre que valga exogeneidad estricta.

2. Estimación de la varianza:

   $$
   \hat{\sigma}_{\varepsilon}^{2}
   =
   \frac{RSS}{NT - L}
   $$

La estimación consistente que vieron en clase es:

$$
\hat{\sigma}_{\varepsilon}^{2}
=
\frac{1}{N(T-1)-L}
\sum_{i=1}^{N}
\sum_{t=1}^{T}
\hat{\varepsilon}_{it}^{2}
$$

Entonces:

$$
\Rightarrow
\text{los S.E. tienden a ser pequeños comparados a los verdaderos}
$$

salvo que sea en muestra muy grande.

---

## Página 3

### d) Estimador de primera diferencia

Ahora nos pide que usemos el estimador de primera diferencia.

Tomemos el modelo original:

$$
y_{it}
=
\alpha
+
x_{it}\beta
+
\mu_i
+
\varepsilon_{it}
\tag{1}
$$

Lag del modelo:

$$
y_{i,t-1}
=
\alpha
+
x_{i,t-1}\beta
+
\mu_i
+
\varepsilon_{i,t-1}
\tag{2}
$$

Restando (2) de (1):

$$
y_{it} - y_{i,t-1}
=
\alpha - \alpha
+
x_{it}\beta
-
x_{i,t-1}\beta
+
\mu_i - \mu_i
+
\varepsilon_{it}
-
\varepsilon_{i,t-1}
$$

Por lo tanto:

$$
\Delta y_{it}
=
\beta \Delta x_{it}
+
\Delta \varepsilon_{it}
$$

---

# Chequeo de consistencia y mapeo contra el mapa 2023

## Diagnóstico de contenido

Este set contiene dos bloques claros:

1. **Cierre/continuación de PS1, Ej. 2**:
   - FGLS por pesos.
   - Estimación de varianzas específicas por firma.
   - Heterocedasticidad multiplicativa de Harvey.
   - Uso de residuos, regresión auxiliar y construcción de pesos.

2. **Arranque de PS2 — modelos lineales de datos de panel**:
   - Heterogeneidad no observada $c_i$.
   - Diferencia conceptual entre RE y FE.
   - Matriz de varianza-covarianza para RE:
     $$
     \hat{\Omega}
     =
     \hat{\sigma}_c^2 J_T J_T'
     +
     \hat{\sigma}_u^2 I_T
     $$
   - Transformación within.
   - Interpretación de coeficientes within.
   - Consistencia bajo exogeneidad estricta.
   - Estimación de $\hat{\sigma}_{\varepsilon}^{2}$.
   - Estimador de primera diferencia.

## Match probable

El mapa 2023 decía:

```text
P02 -> PS1: ex1, ex2, ex3
P03 -> PS2: ex1, ex2
```

Estas notas de 2026 sugieren:

```text
Clase 3 2026 -> PS1: ex2
Clase 3 2026 -> PS2: modelos lineales de datos de panel; likely ex1 / comienzo de ex2
```

## Lectura operativa

- La clase 3 de 2026 **no arranca puramente en PS2**: todavía cierra contenido de **PS1 Ej. 2**.
- Luego sí entra en **PS2**, con el núcleo de FE/RE, within y primera diferencia.
- Esto es muy compatible con el mapa 2023, pero muestra una pequeña diferencia de frontera:
  - En 2023, PS1 parecía concentrarse más en P02.
  - En 2026, al menos PS1 Ej. 2 aparece todavía en Clase 3.
- No veo evidencia suficiente en estas notas para afirmar que PS1 Ej. 3 haya sido cubierto acá.
- Tampoco veo todavía algo que obligue a reorganizar el mapa global; más bien conviene marcar la transición P02/P03 como porosa.

## Mapa vivo actualizado

| Notas 2026 | Contenido detectado | Match 2023 probable | Diagnóstico |
|---|---|---|---|
| Clase 1 | PS0: álgebra matricial MCO, $\hat\beta$, SRC, SE, Cholesky | P01 -> PS0 ex1/ex2/ex3 parcial | Coincide |
| Clase 2 | PS0 Ej. 3 + PS1 Ej. 1 | P01/P02 | Coincide con frontera porosa |
| Clase 3 | PS1 Ej. 2 + PS2 FE/RE/within/FD | P02/P03 | Coincide, pero PS1 se extiende un poco hacia Clase 3 |

