/* Datos en Panel  - UTDT - PS 3 - Ejercicio 2

Profesor: Martín González-Rozada
Ayudante: Iara Lening

Basado en soluciones de Carlos Brutomeso

*/

clear all
set more off

*ssc install xtabond2, all replace
cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS3"

use data/mod_abdata

** Declaramos el panel
xtset id year


** a) POLS c/ errores estándar robustos 
reg n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*, vce(cluster id)
outreg, store(t1) keep(nL1) se noautosumm

** b) FE c/ errores estándar robustos 
xtreg n nL1 nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*, fe vce(cluster id)
outreg, merge(t1) keep(nL1) se noautosumm

** c) A-H
ivregress 2sls D.n (D.nL1= nL2) D.(nL2 w wL1 k kL1 kL2 ys ysL1 ysL2 yr*)
outreg, merge(t1) keep(D.nL1) se noautosumm

** d) A-B one-step GMM
xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.n) iv(w L.w L(0/2).(k ys) yr*) nolevel robust 	// robust es como vce(cluster id) en la estimacion one-step. En two-step realiza la correccion de Windmeijer
outreg, merge(t1) keep(L.n) se noautosumm

*A-B two-step GMM
xtabond2 n L.n L2.n w L.w L(0/2).(k ys) yr*, gmm(L.n) iv(w L.w L(0/2).(k ys) yr*) nolevel twostep
outreg, merge(t1) keep(L.n) se noautosumm

** e) A-B one-step GMM
xtabond2 n L(1/2).n L(0/1).w L(0/2).(k ys) yr*, gmm(L.(n w k)) iv(L(0/2).ys yr*) nolevel robust
outreg, merge(t1) keep(L.n) se noautosumm

*A-B two-step GMM
xtabond2 n L(1/2).n L(0/1).w L(0/2).(k ys) yr*, gmm(L.(n w k)) iv(L(0/2).ys yr*) nolevel twostep
outreg, merge(t1) keep(L.n) se noautosumm

** f) B-B two-step GMM
xtabond2 n L.n L(0/1).(w k) yr*, gmmstyle(L.(n w k)) ivstyle(yr*, equation(level)) twostep // Indicamos aquí con la subopción equation(level) que las dummies de año sólo deben considerarse instrumentos en la ecuación en niveles
outreg, merge(t1) keep(L.n) se noautosumm