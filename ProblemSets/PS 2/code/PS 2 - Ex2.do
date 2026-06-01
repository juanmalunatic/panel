/* Datos en Panel  - UTDT - PS 2 - Ejercicio 2

Profesor: Martín González-Rozada
Ayudante: Iara Lening

* Basado en soluciones de Fiona Franco Churruarin e Iara Lening.
*/

clear all
set more off

cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS2\data"
use murder, clear

describe
sum

xtset id year	// (strongly balanced)

* (a)

*** POLS 

reg mrdrt exec unem i.year
eststo pols



* (c)

*** FE

xtreg mrdrt exec unem i.year, fe
*Todas las variables explicativas son no significativas, las dummies de los años si
eststo fe

matrix V_fe = e(V)		// guardo la matriz de covarianzas de los coeficientes para computar el Test de Hausman a "mano"
matrix b_fe = e(b)		// guardo el vector de coeficientes estimados para computar el Test de Hausman a "mano"

*Extra, qué pasaría si usaramos la transformación de variables binarias
*** LSDV

reg mrdrte exec unem i.year i.id
eststo lsdv
*Notar que los beta hat son identicos


* (d) y (f)

*** FD 
reg D.mrdrte D.exec D.unem D.d90 D.d93, nocons	// problema!

gen cd90 = .
replace cd90=1 if year==90
replace cd90=-1 if year==93
*gen cd90b = d90 - d90[_n-1] if year>87		//alternativa
gen cd93 = .
replace cd93 =0 if year==90
replace cd93=1 if year==93
*gen cd93b = d93 - d93[_n-1] if year>87		// alternativa

reg cmrdrte cexec cunem cd90 cd93, nocons
eststo fd

* A "mano" //FD 
mkmat mrdrte, matrix(y)
mkmat exec unem d90 d93, matrix(X)
matrix D = [-1,1,0\0,-1,1]
matrix DTD = D'*D
matrix  aux = I(51)#DTD		// (I kron D;D) # producto Kronecker
matrix XTX = X'*aux*X
matrix XTy = X'*aux*y
matrix bfd = invsym(XTX)*XTy
matrix list bfd


*** FDGLS
matrix DTD = D'*inv(D*D')*D
matrix IkronDTD = I(51)#DTD
matrix XTX = X'*IkronDTD*X
matrix XTy = X'*IkronDTD*y
matrix bfdgls = invsym(XTX)*XTy
matrix list bfdgls

esttab fd fe 

*** RE 

xtreg mrdrt exec unem i.year, re
eststo re

matrix V_re = e(V)
matrix b_re = e(b)

*** Test de Hausman ***

hausman fe re	// importante: primero, poner estimaciones de FE y, luego, las de RE


* Hacemos el Test de Hausman a mano *

matrix V = V_fe-V_re

* Calculo los autovalores para ver si es positiva definida. 
* Primero, eliminamos la fila de la constante y de la dummy del año 1987
*findit dm76		// install more matrix commands
*findit dm79		// install more matrix commands

matrix list V
matselrc V VAux, row(1 2 4 5) col(1 2 4 5)
mat list VAux
matrix eigenvalues r c = VAux
mat list r
mat list c
matrix det = det(VAux)		// muy cercano al cero
mat list det

* Tomamos los elementos de la matriz de varianzas y covarianzas que necesitamos

matrix VV = V[1..2,1..2]
matrix list VV
* Chequeamos los autovalores

matrix eigenvalues rn cn = VV
mat list rn
mat list cn

* Los autovalores son positivos!

matrix V_inv = inv(VV)
matrix b = b_fe-b_re
matrix bb = b[1,1..2]
matrix chisq = bb*V_inv*bb'
mat list chisq
disp in red "El p-value es" 1-chi2(2,chisq[1,1])


* Resultados

esttab pols lsdv fe fd re, se star(* 0.10 ** 0.05 *** 0.01) ///
	rename(cexec exec cunem unem cd90 d90 cd93 d93 90.year d90 93.year d93) ///
	keep(exec unem d90 d93) ///
	mtitle("POLS" "LSDV" "FE" "FD" "RE") 
	
* xtreg ..., fe vce(cluster id)

