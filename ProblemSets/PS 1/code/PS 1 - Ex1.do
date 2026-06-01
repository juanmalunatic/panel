/* Datos en Panel 2023 - UTDT - PS 1 - Ejercicio 1

Profesor: Martín González-Rozada
Ayudante: Iara Lening

* Basado en soluciones de Fiona Franco Churruarin e Iara Lening
*/

clear all
set more off

cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS1\data"

use cornwell.dta, clear

** Declaramos el panel
xtset county year
xtdes

** Si tuviera que crear dummies de año:
* xi i.year		// Ver "help xi" para mas info.

** Summarize para entender cómo se estructura el panel 
summ lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87
xtsum lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87

** a) POLS
reg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc 
reg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87
outreg, store(t1) se	//tambien podiamos usar predict, resid


** b) Computar errores estándar robustos a heteroscedasticidad arbitraria.
reg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87, vce(cluster county)		
outreg, merge(t1) se


** c) Contraste de correlación serial.
** Seguimos el procedimiento detallado en la slide 37 de clases
reg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87 	//POLS del modelo original
predict uit, resid		//almaceno los residuos
reg uit lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87 l.uit //reg auxiliar: residuos sobre todas las variables explicativas mas los residuos laggeados, como declare el panel "l." le indica a Stata que tome el lag de la variable que aparece después del punto
local LM = e(r2)*e(N)		//armas el estadístico LM
disp in red "chi2(1) = " `LM'
disp in red "El p-valor (LM) es " 1-chi2(1,`LM') ". Se rechaza H0 a un nivel de significancia del 5%"

reg uit l.uit 	//test t asumiendo exogeneidad estricta (Wooldridge p. 199)
scalar rho = _b[L.uit]


**d) Contraste de Heterocedasticidad.
** Seguimos el procedimiento detallado en la slide 38 de clases

/* Sugerencia Wooldridge
"..it makes sense to include elements of xit in hit, and possibly squares and 
cross products of elements of xit.
*/

gen squit=uit*uit
reg squit lprbarr c.lprbarr#c.lprbarr lprbpris c.lprbpris#c.lprbpris c.lprbarr#c.lprbpris
local LM = e(r2)*e(N)
disp in red "chi2(5) = " `LM'
disp in red "El p-valor (LM) es " 1-chi2(5,`LM') ". Se rechaza H0 a un nivel de significancia del 5%"


** e) Enfoque Prais-Winsten

** A "mano" - Primero transformamos las variables usando la opcion 1 o la opcion 2.
** opcion 1**
cap gen ones = 1
global lista_var lcrmrte ones lprbarr lprbconv lprbpris lavgsen lpolpc d82 d83 d84 d85 d86 d87

foreach var of varlist $lista_var{
	gen tilde`var' = .
	replace tilde`var'=sqrt(1-rho^2)*`var' if year==81
	replace tilde`var'=`var'-rho*l.`var' if year!=81
}
list tildelcrmrte tildelprbarr tildelprbconv if _n<5


/** opcion 2 ** 
cap gen ones = 1
for any lcrmrte ones lprbarr lprbconv lprbpris lavgsen lpolpc d82 d83 d84 d85 d86 d87: gen tildeX=.
for any lcrmrte ones lprbarr lprbconv lprbpris lavgsen lpolpc d82 d83 d84 d85 d86 d87: replace tildeX=sqrt(1-rho^2)*X if year==81
for any lcrmrte ones lprbarr lprbconv lprbpris lavgsen lpolpc d82 d83 d84 d85 d86 d87: replace tildeX=X-rho*l.X if year!=81
list tildelcrmrte tildelprbarr tildelprbconv if _n<5
*/

** Luego de haber creado las variables tilde...**

reg tildelcrmrte tildelprbarr tildelprbconv tildelprbpris tildelavgsen tildelpolpc tilded82-tilded87 tildeones, nocons
outreg, store(t2) se //FGLS para correlacion serial 

* Usando comando prais
* Prais-Winsten con TwoSteps Estimates
prais lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87, twostep  
outreg, store(t3) se 

* Prais-Winsten 
prais lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87  
outreg, merge(t3) se 

** f) Computar errores estándar robustos a heteroscedasticidad arbitraria y a autocorrelacion serial arbitraria para el modelo con las variables transformadas del inciso previo.

reg tildelcrmrte tildelprbarr tildelprbconv tildelprbpris tildelavgsen tildelpolpc tilded82-tilded87 tildeone, nocons vce(cluster county)	// Ecuacion (22) - Set Slides 1
outreg, merge(t2) se



