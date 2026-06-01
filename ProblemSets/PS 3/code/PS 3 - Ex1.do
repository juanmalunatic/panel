/* Datos en Panel  - UTDT - PS 3 - Ejercicio 1

Profesor: Martín González-Rozada
Ayudante: Carlos Brutomeso

*/

clear all
set more off

*ssc install xtabond2, all replace
cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS3"

use data\mod_abdata

** Declaramos el panel
xtset id year


** Inciso a)
reg n nL1
outreg, store(t1) se noautosumm

** Inciso b)
reg n nL1 i.id
xtreg n nL1, fe
outreg, merge(t1) se noautosumm


** Inciso d) ivregress 2sls y (endo = instr) x_exo 
ivregress 2sls D.n (D.(nL1)=nL2), nocons
outreg, merge(t1) se noautosumm

xtabond2 n nL1, iv(nL2, passthru) h(1) noleveleq 	// equivalente
/*
- Para el sistema en primeras diferencias, las columnas de ivstyle son transformadas salvo que uno especifique la subopcion 'passthru'
- La opcion h(1) especifica H = I, es decir que los errores son esfericos
*/


** Inciso e)
* One-step Difference GMM, Arellano-Bond
xtabond2 n nL1, gmm(L.n) noleveleq 					
outreg, merge(t1) se noautosumm

xtabond2 n nL1, gmm(n, laglim(2 .)) noleveleq 		// equivalente
xtabond2 n nL1, gmm(L.n, laglim(1 .)) noleveleq 	// equivalente

* Two-step Difference GMM, Arellano-Bond
xtabond2 n nL1, gmm(L.n) noleveleq twostep
outreg, merge(t1) se noautosumm


** Inciso f)
* System GMM, Blundell-Bond
xtabond2 n nL1, gmm(L.n) twostep
outreg, merge(t1) se noautosumm


xtabond2 n L.n, gmm(L.n) twostep robust 	// Correccion de Windmeijer 


** Inciso g)
reg n nL1 yr*
outreg, store(t2) se noautosumm
xtreg n nL1 yr*, fe
outreg, merge(t2) se noautosumm

*AB one-step
xtabond2 n nL1 yr*, gmm(L.n) iv(yr*) noleveleq 
outreg, merge(t2) se noautosumm

*AB two-step
xtabond2 n nL1 yr*, gmm(L.n) iv(yr*) noleveleq twostep
outreg, merge(t2) se noautosumm

*BB
xtabond2 n nL1 yr*, gmm(L.n) iv(yr*, equation(level)) twostep	//Indicamos aquí con la subopción equation(level) que las dummies de año sólo deben considerarse instrumentos en la ecuación en niveles
outreg, merge(t2) se noautosumm

