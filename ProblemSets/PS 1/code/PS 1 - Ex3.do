/* Datos en Panel 2023 - UTDT - PS 1 - Ejercicio 3

Profesor: Martín González-Rozada
Ayudante: Iara Lening

* Basado en soluciones de Fiona Franco Churruarin.
*/


clear all
set more off

* Si nos quedó la matrix, le pedimos que la dropee
cap matrix drop pvalorb1
cap matrix drop pvalorb2

cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS1\data"

set seed 2022	// hace replicable los resultados

local N = 500
local T = 2

local NT= `N'*`T'
set obs `NT' 		// establezco el numero de observaciones


* Creo las variables de panel y de tiempo
egen id = seq(), f(1) t(`N') b(2)
egen t = seq(), f(1) t(2)

* Preparo vectores columna donde voy a guardar los resultados de las simulaciones
matrix pvalorb1 = J(1000,1,.)		// vector donde guardare los p-valor asociados al test con h0: b1=1
matrix pvalorb2 = J(1000,1,.)		// vector donde guardare los p-valor asociados al test con h0: b1=0.8

* Preparo las variables para las simulaciones
gen yjt=.
gen xjt=.
gen ujt=.
gen resid=. 
gen sigma2=.


*** Simulaciones ***

forvalues r=1/1000{
	
		if floor((`r')/100)==(`r')/100 {
		noisily display "working on `r' out of 1000 at $S_TIME" 
		}
		
		quietly{
		replace xjt = runiform(1,20)
		replace ujt = rnormal(0,1) if t==1
		replace ujt = rnormal(0,2) if t==2
		replace yjt = 1+xjt+ujt
		
		*** FGLS *** 
		
		reg yjt xjt
		replace resid = y-_b[_cons]-_b[xjt]*xjt		// creo la serie de residuos
		
		mkmat resid if t==1, matrix(e_t1)			//me guardo los residuos para t=1 en la matriz 'e_t1'
		mkmat resid if t==2, matrix(e_t2)			//me guardo los residuos para t=2 en la matriz 'e_t2'
		
		* Computo estimadores de la varianzas específicas para cada periodo
		matrix sigma2_t1 = e_t1'*e_t1/`N'
		scalar sigma2_t1 = sigma2_t1[1,1]
		matrix sigma2_t2 = e_t2'*e_t2/`N'
		scalar sigma2_t2 = sigma2_t2[1,1]

		replace sigma2 = sigma2_t1 if t==1
		replace sigma2 = sigma2_t2 if t==2
		
		reg yjt xjt [aw=1/sigma2]
		
	* Tamaño del test > Rechazar H0 cuando H0 es verdadera	
		test xjt = 1 
	    matrix pvalorb1[`r',1]=r(p)
	* Poder del test> Rechazar H0 cuando H0 es falsa
		test xjt = 0.8 
	    matrix pvalorb2[`r',1]=r(p)
		}
}

*
		
		
svmat pvalorb1			
count if pvalorb11<0.01
disp in red "El tamanio del test es " r(N)/1000		

svmat pvalorb2			
count if pvalorb21<0.01
disp in red "El poder del test es "r(N)/1000		
