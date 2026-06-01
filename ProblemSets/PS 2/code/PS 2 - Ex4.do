/* Datos en Panel  - UTDT - PS 2 - Ejercicio 4

Profesor: Martín González-Rozada
Ayudante: Iara Lening

* Basado en soluciones de Fiona Franco Churruarin.
*/


clear all
set more off

cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS2\data"
use wagepan, clear

describe

* Declaro el panel
xtset nr year

** a)

*POLS
reg lwage d81-d87		
eststo POLS

*RE
xtreg lwage d81-d87, re
eststo RE

*FE
xtreg lwage d81-d87, fe
eststo FE

*FD
reg D.lwage D.(d81-d87), nocons
eststo FD

*Resultados
estout 

esttab POLS RE FE FD, se star(* 0.10 ** 0.05 *** 0.01) ///
	rename(D.d81 d81 D.d82 d82 D.d83 d83 D.d84 d84 D.d85 d85 D.d86 d86 D.d87 d87) ///
	title("Variable dependiente: lwage") ///
	mtitle("POLS" "RE" "FE" "FD")

eststo clear


** b)
reg lwage d81-d87 educ black hisp		
eststo POLS
xtreg lwage d81-d87 educ black hisp, re
eststo RE
xtreg lwage d81-d87 educ black hisp, fe
eststo FE

esttab POLS RE FE, se star(* 0.10 ** 0.05 *** 0.01) ///
	rename(D.d81 d81 D.d82 d82 D.d83 d83 D.d84 d84 D.d85 d85 D.d86 d86 D.d87 d87) ///
	title("Variable dependiente: lwage") ///
	mtitle("POLS" "RE" "FE")

eststo clear


** c)
reg lwage d81-d87 educ black hisp		
outreg, store(t1) se noautosumm
xtreg lwage d81-d87 educ black hisp, re
outreg, merge(t1) se noautosumm


** d)
reg lwage d81-d87 educ black hisp, vce(cluster nr)
outreg, store(t1) se noautosumm

** e)
xtreg lwage d81-d87 educ black hisp, re robust
outreg, merge(t1) se noautosumm
