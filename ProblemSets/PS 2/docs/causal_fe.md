# Advanced Panel Data: Interpreting FE?

Chris Conlon  
April 24, 2021  
NYU Stern

---

## Slide 2: Causal FE

Causal FE

---

## Slide 3: Recall the FE Assumptions

$$
y_{it} = x'_{it}\beta + \eta_i + \varepsilon_{it}
$$

- $\eta_i$ is a fixed effect.
- To estimate everything consistently, we need $E[\varepsilon_{it}\mid x_{it}, \eta_i] = 0$.
- Mostly this is not true. Instead usually treat $\eta_i$ as a control variable or nuisance parameter.
  - A nuisance parameter is one that we estimate but don't care about interpreting.
  - If we only care about $\beta$ then $\eta_i$ is a nuisance parameter.
- With a control or nuisance parameter we only require that

$$
E[\varepsilon_{it}\mid \eta_i] = E[\varepsilon_{it}\mid x_{it}, \eta_i]
$$

conditional mean independence.

- Once we condition on $\eta_i$ it is as if $\varepsilon_{it}$ and $x_{it}$ are uncorrelated.

---

## Slide 4: Causal FE

- We can get away with conditional mean independence if we don't care about $\eta_i$.
- But suppose that we care about $\hat{\eta}_i$?
  - Teacher FE
  - Physician/Hospital FE
  - Location/County FE
- Suppose move someone from the 10th percentile to the 90th percentile
  - This about the variance/second moment of $\eta_i$.

---

## Slide 5: Causal FE

- Now we have to really believe $E[\varepsilon_{it}\mid x_{it}, \eta_i] = 0$.
- We should worry about the conventional omitted variable bias problem.
- Suppose there exists a variable $w_{it}$ so that:

$$
y_{it} = x'_{it}\beta + w'_{it}\gamma + \eta_i + \varepsilon_{it}
$$

- Recall the conditions for OVB
  - $w_{it}$ is correlated with $x_{it}$
  - $w_{it}$ is a determinant of $y_{it}$
- New one: $w_{it}$ is correlated with $\eta_i$
  - This is easy to satisfy!
  - $w_{it}$ needs to be uncorrelated with anything about the individual $i$.

---

## Slide 6: Example: Test Scores

- Students $s$, Teachers $i$
- Want to measure effect of Teachers on Test Scores

$$
y_{is} = x'_{is}\beta + \eta_i + \varepsilon_{is}
$$

- We observe some features of students but not all of them (parent's education, household income, language spoken at home).
- We also observe some school specific variables $w_{is}$ but not all of them (district spending per pupil, % free lunch, etc.).
- But we don't observe other things (jackhammering outside the classroom, which students have disruptive home lives,etc.).
  - If the mean of those things varies across teachers $\rightarrow$ we are screwed!
  - Can't get an accurate estimate of $\eta_i$.

---

## Slide 7: Example: Test Scores

We need a better design:

- We probably need random assignment of students to teachers.
- Ideally we would be able to control for student and school unobservables.
- Might want to see many students match with many teachers.

---

## Slide 8: Example: Test Scores

Even random assignment is not enough:

$$
y_{is} = \eta_i + \varepsilon_{is}
$$

For each teacher the mean test score is:

$$
\bar{y}_i = \eta_i + \frac{1}{S_i}\sum_{s=1}^{S_i}\varepsilon_{is}
$$

- But $S_i \rightarrow \infty$ doesn't hold. So relative variance of $\eta_i$ and $\varepsilon_{is}$ matters.
- People with large $\bar{y}_i$ may mostly be lucky (small $S_i$).
- May want to apply shrinkage estimator again.

---

## Slide 9: Example: Test Scores

Even random assignment is not enough:

$$
y_{is} = \eta_i + \varepsilon_{is}
$$

For each teacher the mean test score is:

$$
\bar{y}_i = \eta_i + \frac{1}{S_i}\sum_{s=1}^{S_i}\varepsilon_{is}
$$

- But $S_i \rightarrow \infty$ doesn't hold. So relative variance of $\eta_i$ and $\varepsilon_{is}$ matters.
- People with large $\bar{y}_i$ may mostly be lucky (small $S_i$).
- May want to apply shrinkage estimator again.

---

## Slide 10: Example: Test Scores

$$
y_{ist} = x_{ist}\beta + \eta_i + \lambda_{it} + \varepsilon_{ist}
$$

where the residual component is

$$
u_{ist} = \eta_i + \lambda_{it} + \varepsilon_{ist}
$$

- Now residual $u_{ist}$ contains a teacher "quality" $\eta_i$ that we are interested in
- $\lambda_{it}$ a "classroom" or teacher-year specific deviation.
- Goal: think about a forecast of $y_{i,t+1}\mid y_t$.

---

## Slide 11: How?

Estimate $\hat{u}_{ist}$ and construct the following:

- Within classroom student variance:

$$
\hat{\sigma}^2_s = Var(u_{ist} - \bar{u}_{it})
$$

- Auto-Covariance within teacher across years/classrooms:

$$
\hat{\sigma}^2_\eta = Var(\bar{u}_{it}, \bar{u}_{i,t+k})
$$

- Classroom Variance:

$$
\hat{\sigma}^2_\lambda = Var(u_{ist}) - \hat{\sigma}^2_\eta - \hat{\sigma}^2_s
$$

- Weight each classroom by its inverse variance ($n_{it}$ is students per classroom):

$$
\bar{u}_i = \sum_t w_{it} v_{it},
\qquad
w_{it} = \frac{h_{it}}{\sum_t h_{it}},
\qquad
h_{it} = \frac{1}{Var(\bar{u}_{it}\mid \eta_i)}
= \frac{1}{\sigma^2_\lambda + \frac{\sigma^2_s}{n_{it}}}
$$

- But $\bar{u}_i$ is still not the best forecast estimate of $\eta_i$.

---

## Slide 12: How?

We want to further shrink our estimate $\bar{u}_i$ to account for the variance in our estimate:

$$
\eta_i = \bar{u}_i \times \frac{\sigma^2_\eta}{Var(\bar{u}_i)}
$$

where

$$
Var(\bar{u}_i) = \sigma^2_\eta + \left(\sum_t h_{it}\right)^{-1}
$$

- Idea: fraction of teacher variance explained by FE $\eta_i$ as opposed to $\lambda_{it}$ and student factors.
- Shrinkage factor always $\leq 1$ and smaller for less precise estimates.
- Hope: if teachers teach many students with similar scores, we have a precise estimate of $\eta_i$.

---

## Slide 13: Best Counties? (Chetty Hendren 2016 AER)

**Imagen importante:** La slide muestra una captura de un mapa interactivo de movilidad económica para la zona de New York County, NY. Los condados aparecen coloreados según cuánto cambia el ingreso esperado en la adultez para niños de familias pobres si crecen en ese condado. La escala lateral va de azul (mejores resultados) a rojo (peores resultados). Manhattan/New York County aparece destacado como muy malo para movilidad de ingresos de niños pobres; el texto inferior dice que Manhattan es peor que cerca del 93% de los condados, mejor solo que alrededor del 7%.

---

## Slide 14: Best Counties?

**Imagen importante:** Otra captura del mismo mapa de movilidad, ahora para niños de familias en el top 1%. La zona de Manhattan/New York County vuelve a aparecer destacada como extremadamente mala en términos relativos, entre los peores condados de Estados Unidos para ese grupo. La función de la imagen es mostrar que los efectos fijos geográficos pueden verse muy distintos según el punto de la distribución de ingreso de origen.

---

## Slide 15: Best Counties?

50,000 residents (and very few people move here).

**Imagen importante:** La slide muestra el mapa a nivel de condados, con Campbell County, WY resaltado. El mapa indica que Campbell County parece extremadamente bueno para movilidad de ingresos de niños pobres, entre los mejores condados de Estados Unidos. La función de la imagen es introducir el problema de interpretar rankings de efectos fijos: condados pequeños y con poca movilidad pueden aparecer como "mejores" por estimaciones imprecisas.

---

## Slide 16: Time to move to Campbell County, WY?

Less than 10% of Campbell County residents graduated college (among worst in US):

**Imagen importante:** La slide muestra una captura de estadísticas rápidas de escuelas, con indicadores como grados 9-12, número de estudiantes, student-teacher ratio, minority enrollment, graduation rate, ranking escolar, math proficiency, reading proficiency y diversity score. La función es contrastar el ranking favorable de Campbell County en el mapa de movilidad con otros indicadores educativos/sociales menos favorables, reforzando la sospecha de que el efecto fijo estimado puede estar contaminado por imprecisión o factores omitidos.

---

## Slide 17: What's going on?

Is Campbell county the land of opportunity?

- Or is it a small place that nobody moves to with very imprecisely measured FE $\gamma_i$?
- Helped that people found coal in their backyards (literally)
- If you moved there today would you still expect to do well?

This problem is endemic:

- Our "best" and "worst" teachers tend to be those who teach the fewest students.
- Presumably FE are estimated with precision that is not equal.

---

## Slide 18: Healthcare Exceptionalism: Static Reallocation

Is quality (or productivity) correlated with market share?

$$
\ln(N_h) = \beta^s_0 + \beta^s_1 q_h + \gamma^s_M + \varepsilon^s_h
$$

- $N_h$ measures market size for hospital $h$
- $\gamma^s_M$ are market FE
- $q_h$ is measure of hospital quality
- Goal: Is $\beta^s_1 > 0$ or not. $\beta^s_1 < 0$ is usually only Soviet countries or 1970's steel.
- $\beta^s_1 > 0$ means allocation towards productive firms (or just returns to scale?)

---

## Slide 19: Healthcare Exceptionalism: Dynamic Reallocation

$$
\Delta_h = \beta^d_0 + \beta^d_1 q_h + \gamma^d_M + \varepsilon^d_h
$$

$$
\Delta_h = \frac{N_{h,2010} - N_{h,2008}}{\frac{1}{2}(N_{h,2010}+N_{h,2008})}
$$

- $\beta^d_1 > 0$ means growth towards productive firms (not just returns to scale)
- Same idea but now we capture dynamics.
- Patients may still be attracted to unobservables correlated with quality.

---

## Slide 20: Healthcare Exceptionalism

**Imagen importante:** La slide contiene una tabla académica titulada como métricas de asignación estática y dinámica entre condiciones médicas. Las columnas comparan condiciones como AMI, Heart failure, Pneumonia y Hip/knee. La función de la tabla es mostrar estadísticas base de volumen hospitalario, participación en discharge y medidas de asignación de pacientes/growth a través de hospitales para distintas condiciones.

---

## Slide 21: Healthcare Exceptionalism

**Imagen importante:** La slide contiene una tabla de estadísticas resumen sobre métricas de calidad por condición médica. Distingue métricas como survival risk-adjusted, readmission risk-adjusted, procesos de cuidado y encuestas a pacientes. La función es mostrar que "calidad hospitalaria" puede medirse con varias variables, y que estas no son necesariamente equivalentes.

---

## Slide 22: Healthcare Exceptionalism

**Imagen importante:** La slide muestra una tabla de correlaciones entre distintas métricas de calidad dentro de cada condición. La función es enfatizar que distintas medidas de calidad hospitalaria pueden correlacionarse imperfectamente, de modo que la elección de $q_h$ importa para interpretar efectos fijos/productividad.

---

## Slide 23: Healthcare Exceptionalism

**Imagen importante:** La slide contiene una tabla de resultados de asignación entre condiciones, separando asignación estática y dinámica. La función es mostrar coeficientes estimados para cómo distintas métricas de calidad se relacionan con volumen de pacientes y crecimiento del volumen, comparando condiciones y medidas de calidad.

---

## Slide 24: Healthcare Exceptionalism: Production Function

Hospital Production Function:

$$
y^s_p = a_h + \sum_k \lambda_k r_{pk} + \mu x_p + \xi_p
$$

- $a_h$ is hospital productivity (a FE) and variable of interest
- $y_p$ is a patient outcome (survival-days, etc.)
- $x_p$ are (log) hospital inputs
- $r_{pk}$ are patient risk factors.
- This has interpretation as a production function. Why?

---

## Slide 25: Healthcare Exceptionalism

**Imagen importante:** La slide muestra una tabla sobre la asignación de pacientes AMI con respecto a la productividad AMI y sus componentes. La tabla separa asignación estática y dinámica y compara productividad estimada, recursos, survival risk-adjusted y medidas relacionadas. La función es conectar el concepto de productividad hospitalaria como efecto fijo con resultados empíricos de asignación.

---

## Slide 26: Healthcare Exceptionalism: EB Adjustment

**Imagen importante:** La slide muestra una tabla de sensibilidad de resultados de asignación al ajuste Empirical Bayes. Compara resultados baseline ajustados con resultados raw/no adjustment, para asignación estática y dinámica. La función es enfatizar que los efectos fijos crudos pueden estar muy contaminados por ruido de estimación y que el shrinkage/ajuste EB cambia la interpretación de rankings y coeficientes.

---

## Slide 27: Thanks!

Thanks!
