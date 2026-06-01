/* Datos en Panel  - UTDT - PS 2 - Ejercicio 3

Profesor: Martín González-Rozada
Ayudante: Iara Lening

* Basado en soluciones de Fiona Franco Churruarin e Iara Lening
*/

clear all
set more off

global T = 10			// cantidad de periodos  `T' 
global N = 5			// cantidad de individuos 
global NT = $N * $T		// cant. total de observaciones 

global beta = 1 
global sigmamu = 1
global sigmanu = 1


*** Generamos matrices donde guardaremos resultados de las simulaciones
matrix OLS = J(1000,1,.)
matrix RE = J(1000,1,.)
matrix FE = J(1000,1,.)


*** Simulaciones
set seed 2021		// hago replicable los resultados

qui{
forvalues r=1/1000{
	*** Generamos panel 
	set obs $NT

	egen id = seq(), f(1) t($N) b($T)
	egen time = seq(), f(1) t($T)
	xtset id time
	  
	 *** Generamos variables relevantes

	gen mui = .
	forvalues i = 1/$N {
		scalar mu_aux = rnormal(0,$sigmamu)
		qui replace mui=mu_aux if id==`i'
	 } 	
	gen nuit = rnormal(0, $sigmanu)
	gen xit = rnormal(0,1)
	gen yit = $beta * xit + mui + nuit

	*** POLS 
	reg yit xit
	matrix OLS[`r',1] = _b[xit]


	*** RE 
	xtreg yit xit, re
	matrix RE[`r',1] = _b[xit]


	*** FE 
	xtreg yit xit, fe
	matrix FE[`r',1] = _b[xit]
	
	drop id time yit xit mui nuit
}
}
*



mat list OLS

** Opcional: Usar Frames si tienen Stata 16 o superior.

/* Ejemplo: 
1. Creamos un frame nuevo con frame create 
2. Lo seteamos con frame change
3. Notemos que la matrix no depende 
*/
frame create resultados_simulaciones
frame change resultados_simulaciones

*** Convertimos las matrix que teniamos a variables dentro de nuestro dataset: resultados_simulaciones
svmat OLS 
svmat RE
svmat FE

/* Podriamos generar 3 matrix que acumulen los resultados. 
O sea, una matrix para OLS/RE/FE que vaya juntando el Beta, el SD, y el ECM para los 6 niveles distintos de N. */

matrix tabla_final_OLS = J(6,3,.)
matrix tabla_final_RE  = J(6,3,.)
matrix tabla_final_FE  = J(6,3,.)


*** Computamos lo solicitado para la estimacion de OLS
sum OLS1
scalar meanbetaOLS = r(mean)
disp in red "La media de la estimacion OLS de b es " meanbetaOLS
scalar sdbetaOLS = r(sd)
disp in red "La desviacion estandar de la estimacion OLS de b es " sdbetaOLS

* Ahora, computamos el ECM de OLS:
	*1.Residuos cuadrados
	gen sq_sesgoOLS = (OLS1-$beta)^2
	*2.Nos quedamos con la media y le tomamos raiz cuadrada
	sum sq_sesgoOLS
	scalar RECM_OLS = sqrt(r(mean))
	disp in red "La raiz cuadrada del ECM de la estimacion OLS de b es " RECM_OLS

* Guardamos todo en la matrix final de OLS.
matrix tabla_final_OLS[1,1]=meanbetaOLS
matrix tabla_final_OLS[1,2]=sdbetaOLS
matrix tabla_final_OLS[1,3]=RECM_OLS
matrix list tabla_final_OLS
esttab matrix(tabla_final_OLS)

*** Computamos lo solicitado para la estimacion de RE
sum RE1
scalar meanbetaRE = r(mean)
disp in red "La media de la estimacion RE de b es " meanbetaRE
scalar sdbetaRE = r(sd)
disp in red "La desviacion estandar de la estimacion RE de b es " sdbetaRE

* Ahora, computamos el ECM de RE
gen sq_sesgoRE = (RE1-$beta)^2
sum sq_sesgoRE
scalar RECM_RE= sqrt(r(mean))
disp in red "La raiz cuadrada del ECM de la estimacion RE de b es " RECM_RE

* Guardamos todo en la matrix final de RE.
matrix tabla_final_RE[1,1]=meanbetaRE
matrix tabla_final_RE[1,2]=sdbetaRE
matrix tabla_final_RE[1,3]=RECM_RE
matrix list tabla_final_RE
esttab matrix(tabla_final_RE)


*** Computamos lo solicitado para la estimacion de FE
sum FE1
scalar meanbetaFE = r(mean)
disp in red "La media de la estimacion FE de b es " meanbetaFE
scalar sdbetaFE = r(sd)
disp in red "La desviacion estandar de la estimacion FE de b es " sdbetaFE

* Ahora, computamos el ECM de FE
gen sq_sesgoFE = (FE1-$beta)^2
sum sq_sesgoFE
scalar RECM_FE = sqrt(r(mean))
disp in red "La raiz cuadrada del ECM de la estimacion FE de b es " RECM_FE

* Guardamos todo en la matrix final de RE.
matrix tabla_final_FE[1,1]=meanbetaFE
matrix tabla_final_FE[1,2]=sdbetaFE
matrix tabla_final_FE[1,3]=RECM_FE
matrix list tabla_final_FE
esttab matrix(tabla_final_FE)

matrix list tabla_final_OLS
matrix list tabla_final_RE
matrix list tabla_final_FE