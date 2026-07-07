# Datos de Panel

Maestría en Economía y Maestría en Econometría

# Examen Final

Primer Trimestre 2026

Fecha de entrega: 16 de Julio de 2026

## Instrucciones para la entrega

La entrega debe incluir dos archivos. Un do file de Stata (u otro programa o lenguaje similar) con los comandos utilizados para responder las preguntas y un archivo PDF con su respuesta a cada pregunta.

Para el presente trabajo está permitido la utilización de Inteligencia Artificial, la misma es una herramienta válida para ayudarles con la construcción del código solicitado. El enfoque de este trabajo, como hemos conversado a lo largo de la cursada, se encuentra en la correcta comprensión e interpretación económica y econométrica del ejercicio.

Resulta importante aclarar, también, que la Inteligencia Artificial comete errores. De esta forma, de utilizar la IA les solicitamos entregar un anexo que contenga todas las conversaciones con la IA (con timestamps), marcando dónde la IA se equivocó o dio un consejo subóptimo y cómo lo corrigió.

Específicamente en cada ejercicio donde se haya utilizado la IA responda:

¿Identificó al menos un error de la IA?

¿Corrigió alguna especificación?

¿Rechazó alguna sugerencia con justificación econométrica?

# Ejercicio 1: Pruebas de Especificación, Hausman y Errores Estándar Robustos

Considere el siguiente modelo de efectos no observables con heterogeneidad individual:

$$
y_{jt}=\beta_0+\beta_1x_{1jt}+\beta_2x_{2jt}+c_j+u_{jt}, \qquad j=1,\ldots,N;\ t=1,\ldots,T
$$

donde los verdaderos parámetros son $\beta_0=1$, $\beta_1=0{,}6$, $\beta_2=-0{,}4$. El proceso generador de datos (DGP) es el siguiente:

- $c_j \sim N(0,\sigma_c^2)$, con $\sigma_c^2=4$.
- $u_{jt}=\rho u_{j,t-1}+\varepsilon_{jt}$, con $\rho=0{,}6$ y $\varepsilon_{jt}\sim N(0,1)$.
- $x_{1jt}=0{,}5c_j+v_{1jt}$, con $v_{1jt}\sim N(0,2)$ (endógeno respecto de $c_j$).
- $x_{2jt}\sim N(0,3)$ independiente de $c_j$ y $u_{jt}$.

## Parte A: Tamaño de muestra $N=200$, $T=6$

Genere 2000 simulaciones.

1. Estime el modelo por Pool OLS (POLS). Para cada simulación, reporte la media, desvío estándar y RMSE de $\hat{\beta}_1$ y $\hat{\beta}_2$. Explique analíticamente por qué POLS es o no consistente dado el DGP.

2. Estime por Efectos Aleatorios (FGLS–RE). Repita el análisis. ¿Es RE consistente? Justifique.

3. Estime por Efectos Fijos (Within). Repita el análisis. ¿Cuál es la consecuencia de la correlación serial en $u_{jt}$ sobre la inferencia en FE? Compute los errores estándar robustos a correlación serial y heterocedasticidad (cluster a nivel $j$) y compárelos con los errores estándar convencionales de FE.

4. Para cada simulación, implemente el test de Hausman (RE vs FE). Reporte el tamaño empírico del test cuando $\rho=0$ y la potencia del test en el DGP base. Use nivel de significancia del 5 %.

5. Implemente el test de Mundlak como alternativa al test de Hausman: incluya en el modelo RE las medias individuales $\bar{x}_{1j}$ y $\bar{x}_{2j}$ como regresores adicionales y testee si sus coeficientes son conjuntamente cero. Compare la potencia de este test con la del test de Hausman clásico.

## Parte B: Comparación de tamaños muestrales

6. Repita el punto 3 (FE con errores robustos) para $N=50$, $T=4$ y $N=500$, $T=10$. Discuta cómo cambia el sesgo relativo entre errores estándar convencionales y robustos a medida que $N$ y $T$ crecen. ¿Para qué combinación $(N,T)$ la diferencia es más crítica en la práctica?

7. Elabore una tabla resumen comparando media, desvío estándar y RMSE de $\hat{\beta}_1$ para los estimadores POLS, RE y FE bajo las tres combinaciones $(N,T)$. Explique los patrones observados en función de la teoría asintótica del curso.

# Ejercicio 2: Paneles Dinámicos — Sesgo de Nickell, Arellano–Bond y Blundell–Bond

Considere el siguiente panel dinámico AR(1) con efecto individual no observable:

$$
y_{jt}=\alpha y_{j,t-1}+\beta x_{jt}+c_j+u_{jt}, \qquad j=1,\ldots,N;\ t=1,\ldots,T+10.
$$

El DGP es:

- $c_j \sim IN(0,1)$, $u_{jt}\sim IN(0,1)$, $y_{j0}=0$.
- Se descartan las primeras 10 observaciones (burn-in), de modo que el tamaño efectivo es $NT$.
- $x_{jt}=0{,}8x_{j,t-1}+v_{jt}$, con $v_{jt}\sim N(0,0{,}9)$ (regresor estrictamente exógeno).

## Parte A: Análisis del sesgo de Nickell y comparación de estimadores

Para cada escenario, realice 1000 simulaciones y estime $\alpha$ usando LSDV (FE), Arellano–Bond GMM1 (AB-GMM1), Arellano–Bond GMM2 (AB-GMM2), Blundell–Bond GMM1 (BB-GMM1), Anderson–Hsiao (AH) y Kiviet.

| Escenario | $\alpha$ | $N$ | $T$ |
|---|---:|---:|---:|
| A | 0.5 | 30 | 10 |
| B | 0.5 | 100 | 10 |
| C | 0.8 | 30 | 7 |
| D | 0.92 | 100 | 4 |

Para cada estimador y escenario, reporte media, desvío estándar, RMSE de $\hat{\alpha}$ y tamaño del test $H_0:\alpha=\alpha_0$ al 5 %.

## Parte B: Condiciones de momentos, instrumentos débiles y validez

1. Para el escenario D ($\alpha=0{,}92$, $N=100$, $T=4$), analice el problema de instrumentos débiles en Arellano–Bond. Calcule el correlograma empírico entre $\Delta y_{j,t-1}$ y sus instrumentos $y_{j,t-2}$. ¿Cómo afecta la cercanía de $\alpha$ a la unidad la relevancia de estos instrumentos? Compare con BB-GMM1.

2. Derive analíticamente el sesgo aproximado de Nickell:

$$
E\left(\hat{\alpha}^{LSDV}-\alpha\right)\approx -\frac{1+\alpha}{T-1}.
$$

Verifique empíricamente esta fórmula en los escenarios A y C. ¿El sesgo desaparece cuando $N\to\infty$ para $T$ fijo? Explique.

3. Para BB-GMM2, implemente el test de Sargan–Hansen de sobreidentificación en el escenario B. Reporte el tamaño empírico del test y discuta bajo qué condiciones tendría baja potencia.

4. Compare los seis estimadores en términos de sesgo, varianza, RMSE y viabilidad práctica. ¿Cuál recomendaría en cada escenario y por qué?

# Ejercicio 3: Modelos de Respuesta Binaria con Efectos No Observables y Selección Muestral

## 3.1 DGP: Modelo Probit dinámico con efectos no observables

$$
y^*_{jt}=\psi+z_{jt}\delta+\rho y_{j,t-1}+\xi_0y_{j0}+Z_j\xi+a_j+e_{jt},
$$

$$
y_{jt}=1[y^*_{jt}>0], \qquad e_{jt}\sim N(0,1).
$$

Con:

- $a_j=\psi+\xi_0y_{j0}+Z_j\xi+v_j$, con $v_j\sim N(0,\sigma_a^2)$ y $\sigma_a^2=1$.
- $z_{jt}\sim N(0,1)$ independiente de $a_j$ y $e_{jt'}$.
- Parámetros verdaderos: $\psi=-0{,}5$, $\delta=0{,}8$, $\rho=0{,}4$, $\xi=0{,}3$, $\xi_0=0{,}5$.
- $y_{j0}\sim \operatorname{Bernoulli}(0{,}4)$.
- $N=300$, $T=6$.

## 3.2 DGP: Mecanismo de attrition

La observación $(j,t)$ es retenida si

$$
s_{jt}=1[\gamma_0+\gamma_1y_{j,t-1}+\gamma_2z_{jt}+w_j+\omega_{jt}>0],
$$

donde:

- $w_j\sim N(0,0{,}5)$.
- $\omega_{jt}\sim N(0,1)$.
- $\gamma_0=1{,}2$, $\gamma_1=0{,}6$, $\gamma_2=-0{,}3$.
- Una vez que $s_{jt}=0$, la unidad abandona el panel permanentemente.
- $s_{j1}=1$ para todo $j$.

## 3.3 Consignas

5. Estimación Probit RE (Wooldridge): estime el modelo usando el procedimiento de Wooldridge (2005) sobre la muestra completa (sin attrition). Reporte media, desvío estándar y RMSE de los estimadores de $\delta$, $\rho$ y $\xi$ a partir de 500 simulaciones. ¿Es consistente?

6. Utilice únicamente las observaciones con $s_{jt}=1$ para estimar el modelo. Compare los resultados con el punto anterior. ¿La attrition genera sesgo? Argumente cuándo ignorarla es válido y cuándo no.

7. Implemente un test de attrition incorporando un estimado de

$$
P(s_{j,t+1}=1\mid y_{jt},z_{jt},y_{j0},Z_j)
$$

como regresor adicional en el modelo de Wooldridge. Testee si su coeficiente es cero. Reporte tamaño empírico y potencia.

8. Implemente el procedimiento de Rochina–Barrachina para corregir el sesgo de selección. Describa los pasos computacionales, incorpórelos al código y compare el sesgo residual del estimador corregido con el estimador sin corrección.

# Instrucciones de Entrega

1. Usar una seed fija: los últimos 4 dígitos del Documento de Identidad. Repórtelo.
2. Presentar tablas de resultados, gráficos pertinentes y discusión teórica.
3. El código debe estar comentado adecuadamente.
4. Los archivos a entregar deben llamarse `ApellidoSEED.pdf` y `ApellidoSEED.[do/r/py/m]`.
5. Fecha límite: 16/07/2026.
