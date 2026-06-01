/* Datos en Panel 2025 - UTDT - PS 0 - Ejercicio 1

Profesor: Martín González-Rozada
Ayudante: Iara Lening

* Basado en Cameron y Trivedi (2009) - Capitulo 3
* Basado en soluciones de Fiona Franco Churruarin.
*/

/*Ejercicio 1.
En este ejercicio consideramos un modelo de regresion:
ltotexp_i = b0 + b1 suppins_i + b2 phylim_i + b3 actlim_i + b4 totchr_i + b5 age + b6 female_i + b7 income_i + u_i, con i =1,..,N-K

Nos piden:
a) Usar la base de datos mus03data para :
- estimar la ecuación por OLS, usando comandos de matrices. 
- reportar los errores estandar de OLS
- estadisticos t asociados
*/

* Inicializamos el codigo.
clear all
set more off

/*clear all and clear * 
are synonyms.  They remove all data, value labels, matrices, scalars, constraints, clusters, stored results, frames, sersets, and Mata functions and objects from memory.  They also close all open files and postfiles, clear the class system, close any open Graph windows and dialog boxes, drop all programs from memory, and reset all timers to zero.
*/

/*set more off 
tells Stata to run the commands continuously without worrying about the capacity of the Results window to display the results. Otherwise Stata will pause each time the screen is full, unless we keep hitting --more-- at the bottom of the Results window.
*/

** Indicamos el directorio
cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS0\ps0_data"

** Cargamos la base de datos
use ".\mus03data.dta", clear 

/*use ., clear 
specifies that it is okay to replace the data in memory, even though the current data have not
been saved to disk.
*/

* Veamos de que se tratan las variables.
describe totexp ltotexp suppins phylim actlim totchr age female income

* Veamos como se estructura el corte transversal
summarize ltotexp suppins phylim actlim totchr age female income


***********
*** OLS ***
***********

help matrix
help matrix_functions
help mkmat
*mkmat > Create matrix from variables
*svmat > Create variables from matrix

*Ejemplo:
matrix define A = J(3,2,0)	//Estamos creando una matriz llamada A que tiene 3 filas, 2 columnas y esta completada con ceros en todas las posiciones
matrix list A 
matrix define B = [1,2\3,4]
matrix list B

/* Sugerencia Cameron & Trivedi - A.1.6
"Most estimators, such as the OLS estimator (X'X)^(-1)X'y, require the computation of matrix cross products. We strongly recommend that you do not put your data into Stata matrices. Stata has accumulation commands that compute cross products from variables and return the results in Stata matrices." 
*/

** Ver la siguiente documentacion acerca de operadores de acumulacion
help matrix accum

* Hay que tener mucho cuidado con los valores faltantes
* Frames: 

* Vemos el frame actual
frame 
* Vemos el directorio con todos los frames creados
frames dir
* Creamos un frame nuevo vacio con create
frame create regression_results 

* Creamos un frame que es copia de uno que ya existe con copy
frame copy default no_missing_y

frames dir

* Switcheamos al frame que vamos a modificar para eliminar missing data.
frame change no_missing_y
*frame change default

* Eliminamos los missings que identificamos antes.
keep if totexp>0 

* Generamos las matrices.
matrix accum XTX = suppins phylim actlim totchr age female income		// incluye constante
matrix list XTX

* Para generar X'y en realidad usamos yTX por la forma en la que funciona vecaccum, y despues la transponemos cuando hagamos la cuenta. El comando acumula la primera variable que escribimos contra el resto de variables que escribamos después. La variable que queremos "acumular" es la dependiente.
  
matrix vecaccum yTX = ltotexp suppins phylim actlim totchr age female income // incluye constante

matrix list yTX


** Finalmente, generamos el vector de estimadores.
matrix b = invsym(XTX)*(yTX)'		// Computamos b=(X'X)^(-1) * X'Y
matrix list b

** Alternativa: Ignorar los missing.

cap 
capture gen ones = 1
mkmat ltotexp, matrix(ybis)
mkmat suppins phylim actlim totchr age female income ones, matrix(Xbis)
matrix bbis = invsym(Xbis'*Xbis)*Xbis'*ybis
matrix list bbis

*
frame change default
frame change no_missing_y

** Computamos matriz de varianzas y covarianzas de los coeficientes (s2 * inv(XTX))

scalar K = rowsof(XTX)
scalar N = _N

scalar list 

matrix accum yTy = ltotexp, noconstant
matrix eTe = yTy - b'*XTX'*b
matrix s2 = eTe/(N-K)		// c.aux.: e'e=(Y-Xb)'(Y-Xb)=Y'Y-b'(X'X)b
matrix V = s2*invsym(XTX)
matrix list V
matrix Vcoef = vecdiag(V)'	// Vector con la diagonal de V
matrix list Vcoef			// Varianzas de los coeficientes

** Una vez que obtenemos b y V, computamos SEs y t-statistics 


/* ¡Advertencia!
Stata provides no facility for element-by-element division and also no easy way to take the element-by-element square root of a matrix.
*/

* Extraemos los valores de la matrix de varianzas/cov.
matrix Vdiag = diag(Vcoef)
matrix list Vdiag

matrix invVdiag = invsym(Vdiag)
matrix list invVdiag

matrix chol_invVdiag = cholesky(invVdiag)
matrix list chol_invVdiag

* Generamos el SE directamente en forma 1/SE
matrix seinv = vecdiag(chol_invVdiag)'
matrix list seinv

*matrix seinv = (vecdiag(cholesky(invsym(diag(vecdiag(V))))))'	//lo que hicimos en un solo paso

* Producto elemento a elemento para dividir los beta por los SE: Hadamard

matrix t = hadamard(b,seinv)	//hadamard(M,N): a matrix whose i, j element is M[i,j]*N[i,j]
matrix list t 

*  Finalmente - Los Stand. Error. Igual que recien, pero sin invertir.
matrix se = (vecdiag(cholesky(diag(vecdiag(V)))))'
matrix list se

* Juntemos todo en una matrix.
matrix results = b, se, t
matrix colnames results = coeff sterror tstat
matrix list results

* Check usando el comando "regress"
reg ltotexp suppins phylim actlim totchr age female income	//check


** Tests
test totchr=0	//test -- Test linear hypotheses after estimation
test (suppins=0) (phylim=0) (actlim=0) (totchr=0) (age=0) (female=0) (income=0)
*test suppins phylim actlim totchr age female income

** Calculando a mano: 

* Grados de libertad 
scalar df1 = K-1 
scalar df2 = N-K

* Test F de signficatividad global, usando el R2
scalar Ftest = (e(r2)/df1) / ((1-e(r2))/df2)
scalar pval_F = 1-F(df1, df2, Ftest)

scalar list Ftest 
scalar list pval_F

* Calculo el R2
matrix accum yTy_dev = ltotexp, deviations nocons
matrix R2 = J(1,1,1) - (eTe * invsym(yTy_dev))
matrix Ftest_mat = (R2/df1) * invsym((1-R2)/df2)
matrix list Ftest_mat //verifico que da bien 


* Guardamos los resultados en un frame nuevo y calculamos p-valor de cada t
frame regression_results: svmat results, names(matcol)
frame change regression_results
cap drop pvals_t
gen pvals_t = 2*(1-t(df2,abs(resultststat)))

frame no_missing_y: reg ltotexp suppins phylim actlim totchr age female income
list

