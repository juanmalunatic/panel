/* Datos en Panel  - UTDT - PS 3 - Ejercicio 3

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


** e) A-B one-step GMM
xtabond2 n L(1/2).n L(0/1).w L(0/2).(k ys) yr*, gmm(L.(n w k)) iv(L(0/2).ys yr*) nolevel robust
outreg, store(t1) keep(L.n) se noautosumm

* A-B one-step GMM con lags 2 a 3
xtabond2 n L(1/2).n L(0/1).w L(0/2).(k ys) yr*, gmm(L.(n w k), lag(1 2)) iv(L(0/2).ys yr*) nolevel robust
outreg, merge(t1) keep(L.n) se noautosumm

* A-B one-step GMM con lags 2 a 4
xtabond2 n L(1/2).n L(0/1).w L(0/2).(k ys) yr*, gmm(L.(n w k), lag(1 3)) iv(L(0/2).ys yr*) nolevel robust
outreg, merge(t1) keep(L.n) se noautosumm

* A-B one-step GMM con instrumentos colapsados
xtabond2 n L(1/2).n L(0/1).w L(0/2).(k ys) yr*, gmm(L.(n w k), collapse) iv(L(0/2).ys yr*) nolevel robust
outreg, merge(t1) keep(L.n) se noautosumm



** A-B two-step GMM
xtabond2 n L(1/2).n L(0/1).w L(0/2).(k ys) yr*, gmm(L.(n w k)) iv(L(0/2).ys yr*) nolevel twostep
outreg, merge(t1) keep(L.n) se noautosumm

* A-B two-step GMM con lags 2 a 3
xtabond2 n L(1/2).n L(0/1).w L(0/2).(k ys) yr*, gmm(L.(n w k), lag(1 2)) iv(L(0/2).ys yr*) nolevel twostep
outreg, merge(t1) keep(L.n) se noautosumm

* A-B two-step GMM con lags 2 a 4
xtabond2 n L(1/2).n L(0/1).w L(0/2).(k ys) yr*, gmm(L.(n w k), lag(1 3)) iv(L(0/2).ys yr*) nolevel twostep
outreg, merge(t1) keep(L.n) se noautosumm

* A-B two-step GMM con instrumentos colapsados 
xtabond2 n L(1/2).n L(0/1).w L(0/2).(k ys) yr*, gmm(L.(n w k), collapse) iv(L(0/2).ys yr*) nolevel twostep
outreg, merge(t1) keep(L.n) se noautosumm