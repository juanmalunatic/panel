/* Datos en Panel  - UTDT - PS 2 - Ejercicio 1

Profesor: Martín González-Rozada
Ayudante: Iara Lening

* Basado en soluciones de Fiona Franco Churruarin e Iara Lening

*/

clear all
set more off

cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS1\data"

use cornwell, clear

** Declaramos el panel
xtset county year
xtdes

** PS1 - POLS - Corramos la regresión por POLS y almacenemosla para comprar con resultados posteriores
reg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc ib81.year, vce(cluster county)
reg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87, vce(cluster county)
est store POLS

*Ahora si, resolvemos por punto: 
** a) Construyo variables que contengan las medias individuales de las variables del modelo
by county: egen meanlcrmrte = mean(lcrmrte)

* Usando 'for any' repito el mismo procedimiento para todas las variables
global xlist = "lprbarr lprbconv lprbpris lavgsen lpolpc d82 d83 d84 d85 d86 d87"
for any $xlist: by county: egen meanX= mean(X)

** b) Transformacion 'within' + Estimacion del modelo transformado
gen withinlcrmrte = lcrmrte-meanlcrmrte			//primer paso, quitar la media temporal a cada variable
for any $xlist: gen withinX= X-meanX

reg withinlcrmrte withinlprbarr withinlprbconv withinlprbpris withinlavgsen withinlpolpc withind82-withind87, nocons
est store WITHIN

** d) FE
xtreg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87, fe
est store FE

*Corremos el modelo robusto para que nos de la mat de vcov correcta
xtreg lcrmrte lprbarr lprbconv lprbpris lavgsen lpolpc d82-d87, fe vce(cluster county)	//Stata nos agrega una constante para que podamos hacer inferencia sobre el modelo original
est store FEC
/* Interpretacion del intercepto en FE con xtreg

https://www.stata.com/support/faqs/statistics/intercept-in-fixed-effects-model/
*/

** e) FD

* Alternativa 1 (creo las variables a "mano") 
gen dlcrmrte = lcrmrte-L1.lcrmrte
for any $xlist: gen dX= X-L1.X
reg dlcrmrte dlprbarr dlprbconv dlprbpris dlavgsen dlpolpc dd82-dd87, nocons

* Alternativa 2
reg D.lcrmrte D.lprbarr D.lprbconv D.lprbpris D.lavgsen D.lpolpc D.d82 D.d83 D.d84 D.d85 D.d86 D.d87, nocons
est store FD


** Todos los resultados
*ssc install esttout

esttab POLS WITHIN FE FEC FD, se star(* 0.10 ** 0.05 *** 0.01) ///
	rename(D.lprbarr lprbarr D.lprbconv lprbconv D.lprbpris lprbpris D.lavgsen lavgsen D.lpolpc lpolpc D.d82 d82 D.d83 d83 D.d84 d84 D.d85 d85 D.d86 d86 D.d87 d87 82.year d82 83.year d83 84.year d84 85.year d85 86.year d86 87.year d87) ///
	title("Comparxción de estimadores para datos de panel lineales") ///
	mtitle("POLS" "WITHIN" "FE" "FE Clustered ""FD")
	
esttab POLS FE FD using .\tabl\Ex1.csv, se star(* 0.10 ** 0.05 *** 0.01) ///
	rename(D.lprbarr lprbarr D.lprbconv lprbconv D.lprbpris lprbpris D.lavgsen lavgsen D.lpolpc lpolpc D.d82 d82 D.d83 d83 D.d84 d84 D.d85 d85 D.d86 d86 D.d87 d87 82.year d82 83.year d83 84.year d84 85.year d85 86.year d86 87.year d87) ///
	title("Comparación de estimadores para datos de panel lineales") ///
	mtitle("POLS" "FE" "FD")