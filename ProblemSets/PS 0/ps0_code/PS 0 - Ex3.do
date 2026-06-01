/* Datos en Panel 2025 - UTDT - PS 0 - Ejercicio 3

Profesor: Martín González-Rozada
Ayudante: Iara Lening

* Adaptado de Cameron y Trivedi (2009) - Seccion 5.3.4
* Basado en soluciones de Fiona Franco Churruarin e Iara Lening
*/

*** Ejemplo para una muestra 
set more off
clear all
cls

set seed 2025
set obs 10			//Le aviso a Stata con cuantas filas voy a a estar trabajando

/*
Nuestro modelo es: yi=b1 + b2 x2i + b3x3i + ui
y ui=sqrt(exp(-1+0.2x2i))ei
*/

*Comienzo generando las variables siguiendo las distribuciones del enunciado
gen x2 = 5*rnormal()	//Seria lo mismo crearlas como rnormal(0,25)
gen x3 = 5*rnormal()
gen e = 5*rnormal()
gen u = sqrt(exp(-1+0.2*x2))*e
gen y = 1 + x2 + x3 + u

*También podríamos definir escalares para los betas: scalar define beta1= 1

*** OLS
reg y x2 x3
*Para las simulaciones vamos a tener que almacenar resultados de la regresion, analicemos qué y cómo almacena Stata las salidas
ereturn list
*Stata "almacena" de manera temporal dos matrices, la de coeficientes (b) y la de vcov (V), si yo quisiera almacenar el beta de la regresión podría crear un local
local b3= _b[x3] 	//De la matriz de coeficientes, guarda como local el que corresponde a x3 (también podría definir globales o escalares)
di `b3'
test (x3 = 1)	//No me interesa la hipótesis de b3=0, que es la que printea la regresión, porque YO SE (por la construcción del modelo) que el verdadero valor poblacional es 1


*** GLS
gen w=exp(-1+0.2*x2)
regress y x2 x3 [aweight=1/w]
test (x3 = 1) 

* Check
gen yy=y/sqrt(exp(-1+0.2*x2))
gen xx2=x2/sqrt(exp(-1+0.2*x2))
gen xx3=x3/sqrt(exp(-1+0.2*x2))
gen cc=1/sqrt(exp(-1+0.2*x2))

reg yy xx2 xx3 cc, nocons
test (xx3 = 1)


*** FGLS
reg y x2 x3
predict uhat, resid
gen uhatsq = uhat^2
gen luhatsq = ln(uhatsq)
reg luhatsq x2
predict lvaru, resid
gen varu=exp(lvaru)
regress y x2 x3 [aweight=1/varu]
test (x3 = 1)


********************
*** Simulaciones ***
********************

clear all
cls 

set matsize 1000
matrix P = J(1000,3,.)	// matriz donde se guardaran los p-valores 
matrix b1 = J(1000,3,.)	// matriz donde se guardaran los coeficientes b1 
matrix b2 = J(1000,3,.)	// matriz donde se guardaran los coeficientes b2
matrix b3 = J(1000,3,.)	// matriz donde se guardaran los coeficientes b3

set obs 10				// seteo el numero de observaciones

gen x2 = .
gen x3 = .
gen e = .
gen u = .
gen y = .
gen uhat = .
gen uhatsq = .
gen luhatsq = .
gen lvaru = .
gen varu = .
gen w = .

frame create pvals
frame create beta1
frame create beta2
frame create beta3

forvalues r = 1(1)1000{		//loop para el numero de replicaciones
	if floor((`r')/100)==(`r')/100 {
	noisily display "working on `r' out of 1000 at $S_TIME" 
	}
	
	qui replace x2 = 5*rnormal()
	qui replace x3 = 5*rnormal()
	qui replace e = 5*rnormal()
	qui replace u = sqrt(exp(-1+0.2*x2))*e
	qui replace y = 1 + x2 + x3 + u
	
	*** OLS
	qui reg y x2 x3
	local b1= _b[_cons]
	matrix b1[`r',1]=`b1'
	local b2= _b[x2]
	matrix b2[`r',1]=`b2'
	local b3= _b[x3]
	matrix b3[`r',1]=`b3'
	
	qui test x3 = 1
	matrix P[`r',1]=r(p)
	
	*** GLS
	qui replace w=exp(-1+0.2*x2)		//creo ponderadores
	qui regress y x2 x3 [aweight=1/w]
	local b1= _b[_cons]
	matrix b1[`r',2]=`b1'
	local b2= _b[x2]
	matrix b2[`r',2]=`b2'
	local b3= _b[x3]
	matrix b3[`r',2]=`b3'
	
	qui test x3 = 1 
	matrix P[`r',2]=r(p)
	
	*** FGLS
	qui reg y x2 x3
	qui replace uhat = y-_b[x2]*x2-_b[x3]*x3-_b[_cons]
	qui replace uhatsq = uhat^2
	qui replace luhatsq = ln(uhatsq)
	qui reg luhatsq x2
	qui replace lvaru = _b[x2]*x2+_b[_cons]
	qui replace varu=exp(lvaru)
	qui regress y x2 x3 [aweight=1/varu]
	local b1= _b[_cons]
	matrix b1[`r',3]=`b1'
	local b2= _b[x2]
	matrix b2[`r',3]=`b2'
	local b3= _b[x3]
	matrix b3[`r',3]=`b3'
	
	qui test x3 = 1
	matrix P[`r',3]=r(p)
 }
*

*Trabajo con los resultados para comparar los tres métodos


frame change pvals

svmat P			//guardo la matriz P como nuevas variables
count if P1<0.01
disp in red "OLS. El tamanio del test es "r(N)/1000

count if P2<0.01
disp in red "GLS. El tamanio del test es "r(N)/1000

count if P3<0.01
disp in red "FGLS. El tamanio del test es "r(N)/1000

* otra opcion: 

gen D1 = P1<0.01
gen D2 = P2<0.01
gen D3 = P3<0.01

summ D1 D2 D3

frame change beta1 

svmat b1
qui sum b11, det
disp in red "OLS. La media de b1 es " r(mean)
disp in red "OLS. La mediana de b1 es " r(p50)
disp in red "OLS. El desvio estandar de b1 es " r(sd)

qui sum b12, det
disp in red "GLS. La media de b1 es " r(mean)
disp in red "GLS. La mediana de b1 es " r(p50)
disp in red "GLS. El desvio estandar de b1 es " r(sd)

qui sum b13, det
disp in red "FGLS. La media de b1 es " r(mean)
disp in red "FGLS. La mediana de b1 es " r(p50)
disp in red "FGLS. El desvio estandar de b1 es " r(sd)

*** Lo mismo lo hacemos con b2 y b3

*b2
frame change beta2 

svmat b2
qui sum b21, det
disp in red "OLS. La media de b2 es " r(mean)
disp in red "OLS. La mediana de b2 es " r(p50)
disp in red "OLS. El desvio estandar de b2 es " r(sd)

qui sum b22, det
disp in red "GLS. La media de b2 es " r(mean)
disp in red "GLS. La mediana de b2 es " r(p50)
disp in red "GLS. El desvio estandar de b2 es " r(sd)

qui sum b23, det
disp in red "FGLS. La media de b2 es " r(mean)
disp in red "FGLS. La mediana de b2 es " r(p50)
disp in red "FGLS. El desvio estandar de b2 es " r(sd)


*b3
frame change beta3 

svmat b3
qui sum b31, det
disp in red "OLS. La media de b3 es " r(mean)
disp in red "OLS. La mediana de b3 es " r(p50)
disp in red "OLS. El desvio estandar de b3 es " r(sd)

qui sum b32, det
disp in red "GLS. La media de b3 es " r(mean)
disp in red "GLS. La mediana de b3 es " r(p50)
disp in red "GLS. El desvio estandar de b3 es " r(sd)

qui sum b33, det
disp in red "FGLS. La media de b3 es " r(mean)
disp in red "FGLS. La mediana de b3 es " r(p50)
disp in red "FGLS. El desvio estandar de b3 es " r(sd)

*Queda cambiar el N y volver a correr las 1000 simulaciones para ir comparando