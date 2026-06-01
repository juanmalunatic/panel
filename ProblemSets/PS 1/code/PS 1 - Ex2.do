/* Datos en Panel 2023 - UTDT - PS 1 - Ejercicio 2

Profesor: Martín González-Rozada
Ayudante: Iara Lening

* Basado en soluciones de Fiona Franco Churruarin.
*/

** Motivacion - Aplicacion de modelo heteroscedastico por grupos.

clear all
set more off

cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS1\data"
use greene97.dta, clear
des

/*
Dataset: greene97 - Datos para 6 compañias aereas.

Funcion de costos:
ln cost = b1 + b2 ln(output) + b3 loadfactor + b4 ln(fuel price) + d2 firm2 + d3 firm3 + d4 firm4 + d5 firm5 + e
*/

** a) Estimar la ecuacion de costos por POLS

gen lnc = ln(c)
gen lnq = ln(q)
gen lnpf = ln(pf)

reg lnc lnq lf lnpf i.id
outreg, store(t1) se


** b1) FGLS. Groupwise Heteroscedasticity.
/* Como las varianzas son desconocidas, usaremos FGLS siguiendo las siguientes alternativas:
1)  Estimar el modelo calculando el estimador necesario para la varianza especifica de la compañia aerea a traves de los residuos de OLS
2) Usar el modelo de heteroscedasticidad multiplicativa de Harvey - Procedimiento en 2 etapas.
*/

** Opcion 1: Calculamos el estimador de la varianza a partir de los residuos de OLS

* Regresion OLS
reg lnc lnq lf lnpf i.id
* Residuos
predict e, resid		// obtengo vector de residuos

* Genero subvectores específicos por grupo de los residuos de OLS

local a1=1
local a2=15
forvalues i=1/6{
	mkmat e in `a1'/`a2', matrix(e`i')
	local a1=`a1'+15	// actualizo los elementos del vector e que guardo en ei
	local a2=`a2'+15
}

* O sea automatizamos:
/*
mkmat e in 1/15, matrix(e1)
mkmat e in 16/30, matrix(e2)
etc.
*/


* Check
matrix list e6
list e in 76/90

* Computo estimadores de la varianzas específicas de cada grupo (aerolinea) = e*e/t	
forvalues i=1/6{
	matrix sigma`i' = e`i''*e`i'/15
	matrix list sigma`i'
	scalar sigma`i' = sigma`i'[1,1]
}

* Computamos los pesos para luego computar el estimador de FGLS
gen w = .
replace w = sigma1 in 1/15
replace w = sigma2 in 16/30
replace w = sigma3 in 31/45
replace w = sigma4 in 46/60
replace w = sigma5 in 61/75
replace w = sigma6 in 76/90

reg lnc lnq lf lnpf i.id [aw=1/w]		// FGLS
outreg, merge(t1) se		// guardo los resultados


** Opcion 2: FGLS. Groupwise Heteroscedasticity. Harvey (1976).
/*
This method will produce an inconsistent estimator of γ1 = ln(σ^2),
but the inconsistency can be corrected just by adding 1.2704 to the value obtained.
*/

* A "mano"
gen ln_e2=log(e*e)	// creo ln(residuos al cuadrado)
reg ln_e2 i.id		// regresion por OLS 
predict ln_v
gen v = exp(ln_v)	// pesos FGLS
reg lnc lnq lf lnpf i.id [aw=1/v]		// FGLS

outreg, merge(t1) se	// inciso c)


* Usando comando 'hetregress'
hetregress lnc lnq lf lnpf i.id, twostep het(i.id)

