/* Datos en Panel  - UTDT - PS 3 - Ejercicio 4

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

/*
La subrutina a grandes rasgos sigue los siguientes pasos.
1. Calculamos los residuos del modelo.
2. Estimamos y ajustamos los grados de libertad.
3. Calculamos la varianza estimada según la fórmula de las slides: sigma_u^2*(Z_dieresis'*Z_dieresis)^(-1)
*/

** LSDVC (Kiviet, 1995)
xtlsdvc n yr*, initial(ah) bias(2)  //podemos agregar todas las variables que querramos
xtlsdvc n , initial(ah) bias(2)		//modelo del ejercicio 1


** Estimación matriz de varianzas y covarianzas
* Creo un escalar con la estimacion del coeficiente
matrix blsdvc = e(b) 
scalar blsdvc = blsdvc[1,1]

* Creo escalares para el numero de observaciones totales, numero de id, numero de periodos y numero de variables
scalar NT = e(N) 
scalar T = e(Tbar)
scalar N = e(N_g)
scalar K = colsof(e(b))

* Computo promedios individuales de las variables del modelo
egen bar_ni = mean(n), by(id)
egen bar_nL1i = mean(nL1), by(id)

* Transformacion within (no se olviden que es un estimador de FE)
gen with_n = n-bar_ni
gen with_nL1=nL1-bar_nL1i
gen u = with_n-blsdvc*with_nL1

* Estimacion de la varianza del termino de error
matrix accum uTu = u, noconstant
matrix sigma2u = (uTu)/(NT-N-T-K+1)  
matrix list sigma2u

* Matriz de varianzas y covarianzas

matrix accum ZTZ = with_nL1, noconstant
matrix Var_blsdvc = sigma2u*inv(ZTZ)
matrix list Var_blsdvc
scalar se_blsdvc = sqrt(Var_blsdvc[1,1])

scalar list se_blsdvc 

* t-statistic
scalar tstat = blsdvc/se_blsdvc
disp tstat
disp "El p-valor del test es "2*ttail(NT-K, tstat)	