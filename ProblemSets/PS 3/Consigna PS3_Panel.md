# Universidad Torcuato Di Tella

**Master en Economía y Econometría**  
**2021**

**Datos de Panel**  
**Problem Set 3: Modelos de Panel Dinámicos**

## 1.

Considere la base de datos `mod_abdata.dta` que fue utilizada por Arellano y Bond en su famoso paper de 1991. Se trata de un panel de 140 empresas británicas encuestadas anualmente entre 1976 y 1984. El panel original no es balanceado, pero la versión para este ejercicio se trata de un panel balanceado de empresas con observaciones para exactamente 6 años entre 1977 y 1982. La variable que identifica la empresa es *id* y la variable que identifica el tiempo es *year*. La variable $n$ es el empleo de la empresa. Luego, considere un modelo muy simplificado del siguiente tipo:

$$
\ln n_{it} = \rho \ln n_{it-1} + \varepsilon_{it}
$$

$$
\varepsilon_{it} = c_i + \nu_{it}
$$

$$
E[c_i] = E[\nu_{it}] = E[c_i \nu_{it}] = 0
$$

donde $n_{it}$ es el empleo de la empresa $i$ en el año $t$.

### a)

Estime el modelo por OLS. ¿Qué sesgo esperaría encontrar y por qué?

### b)

Estime el modelo usando efectos fijos (FE). ¿Permite la transformación *within* eliminar el sesgo de paneles dinámicos?

### c)

Considere una transformación de diferencias finitas de primer orden del modelo. ¿Continúa siendo la variable dependiente rezagada potencialmente endógena?

### d)

Implemente el estimador de Anderson-Hsiao a partir del comando *ivregress* en Stata.

### e)

Ahora, obtenga la estimación GMM de $\rho$ utilizando todos los instrumentos posibles en niveles para el modelo en primeras diferencias. Para ello utilice el comando *xtabond2*.

### f)

Obtenga la estimación de GMM de $\rho$ utilizando todos los instrumentos posibles en niveles para el modelo en primeras diferencias e $\Delta y_{it-1}$ como instrumento para el modelo en niveles.

### g)

Repita las estimaciones de los incisos e) y f) incluyendo efectos fijos de tiempo.

## 2.

En este ejercicio se ilustrará el hecho de que los estimadores de Arellano-Bond y de Blundell-Bond pueden extenderse en forma directa a modelos que incluyan regresores estrictamente exógenos y regresores secuencialmente exógenos.

En su paper original, Arellano y Bond modelaron el empleo de las empresas ($n$) utilizando un modelo de ajuste parcial para reflejar los costos de contratación y despido, incluyendo dos rezagos de la variable empleo. Otras variables incluidas fueron el nivel salarial actual y el rezagado ($w$), el stock de capital actual, rezagado una y dos veces ($k$) y la producción agregada actual, rezagada una y dos veces en el sector de la empresa ($ys$). Todas las variables se expresan en logaritmos. También se incluye un conjunto de variables *dummy* de tiempo.

### a)

Estime el modelo por OLS. Compute los errores estándar robustos a heterocedasticidad y correlación serial.

### b)

Estime el modelo por FE. Compute los errores estándar robustos a heterocedasticidad y correlación serial.

### c)

Implemente el estimador de Anderson-Hsiao usando $n_{it-2}$ como instrumento.

### d)

Estime la ecuación de empleo usando el estimador de Arellano-Bond. Asuma que la única endogeneidad presente es en el rezago de la variable dependiente.

### e)

Ahora, considere como hicieron Blundell y Bond (1998) que los salarios y el stock de capital no deben tomarse como estrictamente exógenos en este contexto (como se hizo en los modelos anteriores). Reestime el modelo usando el estimador de A-B y considerando a los salarios y el stock de capital como regresores secuencialmente exógenos.

### f)

Adicionalmente, Blundell y Bond (1998) eliminan de su modelo los rezagos más largos (de dos períodos) del empleo y el capital, y prescinden del nivel de producto agregado sectorial. Considerando esta cuestión, compute el estimador de Blundell-Bond.

## 3.

Cuando hay muchos instrumentos, surgen dos problemas principales:

- Sobreestimación (*overfitting*) de la variable endógena
- Mala estimación de la matriz de pesos $W$

En estos casos, se proponen las siguientes soluciones:

### a)

Probar diferentes especificaciones de IV recortando el número de rezagos en la matriz de instrumentos $\mathbf{Z}$.

### b)

Colapsar/combinar instrumentos. Se modifica la matriz de instrumentos para el individuo $i$:

$$
Z_i =
\begin{bmatrix}
y_{i1} & 0 & 0 & \cdots \\
y_{i1} & y_{i2} & 0 & \cdots \\
y_{i3} & y_{i2} & y_{i1} & \cdots \\
\vdots & \vdots & \vdots & \ddots
\end{bmatrix}
$$

Si el modelo funciona debería dar resultados similares con distintos instrumentos.

Retome el ejercicio 2.e) para ver una aplicación de esta cuestión. Estime el modelo de empleo restringiendo el máximo rezago a 3 y 4 períodos. Por último, estime el modelo colapsando instrumentos. Analice si los resultados obtenidos son robustos.

## 4.

Considere nuevamente el modelo del primer ejercicio. Obtenga el estimador LSDVC propuesto por Kiviet (1995) a partir del comando *xtlsdvc*. Luego, estime la matriz de varianzas y covarianzas de los coeficientes de Kiviet siguiendo el procedimiento explicado en clase.
