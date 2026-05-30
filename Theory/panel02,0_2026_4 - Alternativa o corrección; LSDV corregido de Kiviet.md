# Agenda

1. Modelos Dinámicos
   - Introducción a Modelos de Datos de Panel Dinámicos
   - El Modelo AR(1) de Efectos No Observados y el sesgo de Nickell
   - Estimación de $\rho$ Consistente: Arellano-Bond y Blundell-Bond
   - El Estimador de Arellano-Bond
   - El Estimador de Blundell-Bond
   - Extensión: Regresores Exógenos
   - Contrastes de Validez de los Instrumentos
   - Datos con Persistencia

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
56 / 61

---

# Estimación LSDV Corregida (Kiviet)

Considere el siguiente modelo de componentes no observados,

$$
y_{it} = \gamma y_{it-1} + x_{it}\beta + c_i + u_{it}, \quad i = 1, 2, \ldots, N;\ t = 1, 2, \ldots, T
\tag{3}
$$

con,

- $c_i \sim N(0, \sigma_c^2)$, $\sigma_c^2 > 0$; $u_{it} \sim N(0, \sigma_u^2)$, $\sigma_u^2 > 0$
- (i) $E(u_{it}u_{js}) = 0 \quad j \neq i$ o $t \neq s$; (ii) $E(c_i c_j) = 0 \quad j \neq i$
- (iii) $E(c_i u_{jt}) = 0 \quad \forall\ j,i,t$; (iv) $E(x'_{it}u_{js}) = 0 \quad \forall\ j,i,t,s$
- (v) $E(x'_{jt}c_i) =$ desconocida $\quad \forall\ j,i,t$
- $y_{i0}$ es una variable aleatoria con (vi) $E(y_{i0}u_{jt}) = 0 \quad \forall\ j,i,t$; (vii) $E(y_{i0}c_j) =$ desconocida $\quad \forall\ j,i$.
- (viii) $E(w_{i0}u_{jt}) = 0, \quad \forall\ j,i,t$, donde $w_{it} = y_{it} - \dfrac{1}{1-\gamma}c_i$.

Kiviet muestra que el sesgo del estimador de FE puede aproximarse con un error de tamaño $O_p(N^{-1}T^{-3/2})$.

Asuma que los supuestos (i) a (viii) y $|\gamma| < 1$ se cumplen. Entonces,

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
57 / 61

---

# Estimación LSDV Corregida (Kiviet)

**Teorema 1 (Kiviet, 1995 pp 64)**

$$
\begin{aligned}
E(\hat{\delta}_{FE} - \delta)
=&\ -\sigma_u^2 \bar{D}^{-1}\Bigg(
\frac{N}{T}(J_T'CJ_T)\left[2q - \bar{W}'Q_{NT}\bar{W}\bar{D}^{-1}q\right] \\
&\quad + \operatorname{tr}\{\bar{W}'(I_N \otimes Q_T C Q_T)\bar{W}\bar{D}^{-1}\}q \\
&\quad + \bar{W}'(I_N \otimes Q_T C Q_T)\bar{W}\bar{D}^{-1}q
+ \sigma_u^2 N q'\bar{W}'\bar{D}^{-1}q \\
&\quad \times \left[\frac{N}{T}(J_T'CJ_T)\operatorname{tr}\{C'Q_T C\} + 2\operatorname{tr}\{C'Q_T C Q_T C\}\right]
\Bigg) \\
&\quad + O_p(N^{-1}T^{-3/2}) \\
=&\ \text{Sesgo}_{\text{Kiviet}} + O_p(N^{-1}T^{-3/2})
\end{aligned}
$$

donde

$$
\bar{D} = \bar{W}'Q_{NT}\bar{W} + \sigma_u^2 N\operatorname{tr}\{C'Q_T C\}qq',
\quad Q_{NT}\bar{W} = E(Q_{NT}W);
$$

$$
q = (1\ 0\ \ldots\ 0)',
\quad \delta' = (\gamma\ \beta')
$$

y,

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
58 / 61

---

# Estimación LSDV Corregida (Kiviet)

$$
C =
\begin{bmatrix}
0 & 0 & \cdots & \cdots & \cdots & \cdots & 0 \\
1 & 0 & \cdots & \cdots & \cdots & \cdots & 0 \\
\gamma & 1 & 0 & \cdots & \cdots & \cdots & 0 \\
\gamma^2 & \gamma & 1 & 0 & \cdots & \cdots & 0 \\
\vdots & \vdots & \vdots & \vdots & \ddots & \vdots & \vdots \\
\gamma^{T-2} & \cdots & \cdots & \cdots & \gamma & 1 & 0
\end{bmatrix}
$$

El único parámetro desconocido en $C$ es $\gamma$.

Kiviet sugiere reeemplazarlo con la estimación de IV de Anderson-Hsiao.

Para el modelo $AR(1)$ Anderson y Hsiao (1982) aplican diferencias finitas para eliminar $c_i$.

$$
\Delta y_{it} = \rho \Delta y_{it-1} + \Delta u_{it}, \quad t > 2.
$$

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
59 / 61

---

# Estimación LSDV Corregida (Kiviet)

Luego, usan POLS IV con instrumentos dados por $y_{it-2}$ o $\Delta y_{it-2}$.

Note que en el período $t$, todos los elementos de $(y_{it-2}, y_{it-3}, \ldots, y_{i0})$ son instrumentos válidos porque $\Delta u_{it}$, no está correlacionada con $y_{it-h}$, $h \geq 2$.

Como el estimador de Anderson y Hsiao no usa todos los instrumentos disponibles no es completamente eficiente.

El estimador propuesto por Kiviet es entonces:

1. Estimar el modelo por el método de LSDV y obtener la estimación no consistente de $\delta$, $\hat{\delta}_{FE}$.
2. Calcular la estimación consistente como: $\hat{\delta}_{LSDVC} = \hat{\delta}_{FE} - \text{Sesgo}_{\text{Kiviet}}$.

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
60 / 61

---

# Estimación LSDV Corregida (Kiviet)

Para estimar la matriz de varianzas y covarianzas de los coeficientes de Kiviet siga los siguientes pasos:

1. Calcular $\hat{u}^{LSDVC}_i = \ddot{y}_i - \ddot{Z}_i \hat{\delta}_{LSDVC}$ donde $\ddot{Z}_i$ incluye $\ddot{y}_{it-1}$ y $\ddot{x}_{i,t}$.

2. Estime

$$
\hat{\sigma}_u^2 =
\frac{1}{NT - N - T - K + 1}
\sum_{i=1}^{N} \hat{u}^{LSDVC\prime}_i \hat{u}^{LSDVC}_i
$$

3. 

$$
\operatorname{Var}(\hat{\delta}_{LSDVC})
= \hat{\sigma}_u^2
\left(\sum_{i=1}^{N} \ddot{Z}'_i \ddot{Z}_i\right)^{-1}
$$

Martín González-Rozada (UTDT)  
Econometría de Datos de Panel  
Primer Trimestre, 2026  
61 / 61
