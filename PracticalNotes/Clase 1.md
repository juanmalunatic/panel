# Clase 1

> Fuente: notas manuscritas 2026, 2 páginas. Transcripción revisada visualmente desde el PDF renderizado. Mantengo la notación de la clase en forma limpia con LaTeX; cuando una línea parece ser abreviada o potencialmente imprecisa, la marco al final en “Notas de revisión”.

## Página 1

\(\beta\) es ir apilando y armando el vector de \(\beta\) con las variables independientes de la regresión.

\[
\beta=
\begin{pmatrix}
\beta_0\\
\beta_1\\
\beta_2\\
\beta_3\\
\beta_4\\
\beta_5\\
\beta_6\\
\beta_7
\end{pmatrix}
\]

\[
\dim(\beta)=8\times 1
\]

\[
\hat\beta=(X'X)^{-1}X'y
\]

\[
X \text{ es de } n\times k, \qquad k=8, \qquad y \text{ es de } n\times 1
\]

Está formada por 8 variables, con una primera columna de 1s para considerar la constante:

\[
X=\left[
\mathbf{1}_{n\times 1}\quad
\text{suppins}_{n\times 1}\quad
\text{phylim}_{n\times 1}\quad
\text{actlim}_{n\times 1}\quad
\text{totchr}_{n\times 1}\quad
\text{age}_{n\times 1}\quad
\text{fem}_{n\times 1}\quad
\text{income}_{n\times 1}
\right]
\]

## Métrica

\[
\operatorname{var}(\hat\beta)=\sigma_u^2(X'X)^{-1}
\qquad
\text{(bajo los supuestos usuales de GM)}
\]

\(\sigma_u^2\) es desconocida \(\rightarrow\) usamos lo mejorcito que tenemos:

\[
s^2=\frac{SRC}{n-k}
\]

Ahora en Stata tenemos que construir \(SRC\):

\[
SRC=\sum_i (y_i-\hat y_i)^2=\sum_i e_i^2=e'e
\]

\[
=(y-\hat y)'(y-\hat y)=(y-X\hat\beta)'(y-X\hat\beta)
\]

Tomándolo en forma matricial:

\[
\begin{pmatrix}
x_{11} & x_{12} & \cdots & x_{1k}\\
\vdots & \vdots & \ddots & \vdots\\
x_{n1} & x_{n2} & \cdots & x_{nk}
\end{pmatrix}
\begin{pmatrix}
\hat\beta_0\\
\hat\beta_1\\
\vdots
\end{pmatrix}
\]

\[
=(y'-\hat\beta'X')(y-X\hat\beta)
\]

\[
=y'y-\hat\beta'X'y-y'X\hat\beta+\hat\beta'X'X\hat\beta
\]

Trabajemos con otras expresiones:

\[
e=y-\hat y \Rightarrow y=e+\hat y
\]

\[
X'y=X'(e+\hat y)
\]

\[
=X'(X\hat\beta+e)=X'X\hat\beta+X'e
\]

Si recordamos lo que vimos en Econometría:

\[
X'e=0
\]

CPO del problema de minimización original.

\[
y'X=(e'+\hat y')X
\]

\[
=e'X+\hat\beta'X'X=(X'e)'+\hat\beta'X'X
\]

Como \((X'e)'=0\), nos queda lo mismo que antes.

\[
SRC=y'y-\hat\beta'X'X\hat\beta-\hat\beta'X'X\hat\beta+\hat\beta'X'X\hat\beta
\]

Cancelando:

\[
SRC=y'y-\hat\beta'X'X\hat\beta
\]

## Página 2

Ahora el estadístico \(t\):

\[
t=\frac{\hat\beta}{se(\hat\beta)}
\]

\[
se(\hat\beta)=\sqrt{\frac{SRC}{n-k}}
\]

En Stata vamos a tener que extraer manualmente la posición que necesitamos de la raíz de las varianzas. Entonces vamos a usar la descomposición de Cholesky:

\[
\Omega=PP'=
\begin{bmatrix}
\sqrt{w_1} & 0 & \cdots\\
0 & \sqrt{w_2} & \\
\vdots & & \ddots
\end{bmatrix}
\begin{bmatrix}
\sqrt{w_1} & 0 & \cdots\\
0 & \sqrt{w_2} & \\
\vdots & & \ddots
\end{bmatrix}
\]

De esta matriz sí puedo extraer los elementos que necesito.

## Chequeo de consistencia / mapeo 2026 vs. 2023

- **Contenido detectado:** repaso de MCO/OLS en forma matricial, construcción manual de \(SRC\), varianza de \(\hat\beta\), error estándar, estadístico \(t\), y uso de Cholesky para extraer raíces/elementos necesarios en Stata.
- **Match probable con mapa 2023:** `P01 -> PS0`, especialmente la parte inicial de álgebra matricial y armado manual de cantidades de regresión.
- **No hay evidencia aquí de PS1 o posteriores.** Este set está claramente en la zona de arranque del curso/práctica.
- **Reorganización sugerida:** mantener como `Clase 1 / P01 -> PS0: MCO matricial, SRC, varianza, SE/t y Cholesky en Stata`.
- **Paridad 2026-2023:** por ahora, este primer set apoya que 2026 empezó de forma compatible con el ritmo de 2023.

## Notas de revisión

- La variable final de la matriz \(X\) se lee como `income` con confianza alta por contexto y por la forma manuscrita.
- La línea manuscrita `se(\hat\beta)=sqrt(SRC/(n-k))` parece abreviar la parte escalar \(s=\sqrt{SRC/(n-k)}\). Para un coeficiente específico, bajo la fórmula usual de GM/MCO, el error estándar completo sería:

\[
se(\hat\beta_j)=\sqrt{s^2\left[(X'X)^{-1}\right]_{jj}}
\]

No corregí la transcripción principal porque en la nota manuscrita aparece abreviado, pero conviene marcarlo para estudiar.
