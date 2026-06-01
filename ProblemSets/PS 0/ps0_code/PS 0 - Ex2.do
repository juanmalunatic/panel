/* Datos en Panel 2025 - UTDT - PS 0 - Ejercicio 2

Profesor: Martín González-Rozada
Ayudante: Iara Lening

* Basado en soluciones de Fiona Franco Churruarin.
*/

clear all
set more off

cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS0\ps0_data"
use mus08psidextract.dta, clear

describe	
summarize

order id t, first
sort id t


/*
Describe, summarize and tabulate no distinguen variaciones cross-section y en el tiempo.
Para ello utilizamos comandos especiales para paneles:

- xtdescribe: extent to which panel is unbalanced
- xtsum: separate within (over time) and between (over individuals) variation
- xttrans: transition frequencies for discrete data
- xtline: time series plot for each individual on one chart
- xtdata: scatterplots for within and between variation.
*/

** Declare data to be panel data
browse			// xt commands require data to be in long form.
xtset id t		// PSID wage data 1976-82 on 595 individuals. Strongly Balanced.

xtdescribe

sum lwage ed exp exp2 wks
xtsum id t lwage ed exp exp2 wks

xttrans ind

xtline lwage if id<10	// plot para los primeros 9 individuos


** Otro ejemplo
clear
webuse nlswork     		// unbalanced
describe
xtset idcode year		// declaro el panel 
xtdescribe				// vemos los patrones más frecuentes
xtsum birth_yr race 	// resumen de las variables


****************************************************
***********		 Wide to long form	  	************
****************************************************

use .\data\pigweights.dta, clear	//data is in wide form
help reshape long

*Convert data from wide to long form 
reshape long weight, i(id) j(t)


ssc install gtools

display "$S_TIME"
use pigweights.dta, clear	//data is in wide form
expand 10000
drop id 
gen id = _n 
reshape long weight, i(id) j(t)
display "$S_TIME"  
use pigweights.dta, clear	//data is in wide form
expand 10000
drop id 
gen id = _n 
greshape long weight, i(id) j(t)
display "$S_TIME"


****************************************************
********* Crear panel para simulaciones ************
****************************************************

clear all 
set more off

set seed 2022	//hace replicable los resultados

local NT = 5000			// cant. total de observaciones
local T = 10			// cantidad de periodos (time var)
local N = `NT'/`T'		// cantidad de individuos (panel var)
disp `N'
set obs `NT'

** Usamos el comando seq() para generar una secuencia de valores desde f() hasta t(), que se repitan b() veces. 
egen id = seq(), f(1) t(`N') b(`T')

** Usamos el comando seq() para generar una secuencia de valores desde f() hasta t(), todas consecutivas. Útil para la variable "t" *  
egen t = seq(), f(1) t(`T')

** Preparamos las variables para las simulaciones
gen xit = rnormal()
gen uit = rnormal()
gen yit = 1 + xit + uit

** Declaramos el panel
xtset id t

xtdes
xtsum

** Pool OLS (POLS)
reg yit xit
