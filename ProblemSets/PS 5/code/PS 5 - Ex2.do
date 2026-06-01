/* Datos de Panel  - UTDT - PS 5 - Ejercicio 2

Profesor: Martín González-Rozada
Ayudante: Carlos Brutomeso

*/

clear all
set more off

cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS5"
u data\wagepan
xtset nr year

* a) Pooled Probit
probit union l.union
probit union l.union, vce(cluster nr)	// err. std. robustos a heterocedasticidad y correlacion serial arbitraria

disp in red "La probabilidad estar afiliado a un sindicato dado que estaba afiliado en el periodo anterior es " normal(_b[_cons]+_b[l.union])
disp in red "La probabilidad estar afiliado a un sindicato dado que no estaba afiliado en el periodo anterior es " normal(_b[_cons])

* b)
probit union l.union i.year, vce(cluster nr)
probit union l.union d82-d87, vce(cluster nr)

forvalues t = 82/87{

disp in blue "Anio " `t'
disp in red "La probabilidad estar afiliado a un sindicato en el anio "19`t' " dado que estaba afiliado en el periodo anterior es " normal(_b[_cons]+_b[l.union]+_b[d`t'])
disp in red "La probabilidad estar afiliado a un sindicato en el anio "19`t' " dado que no estaba afiliado en el periodo anterior es " normal(_b[_cons]+_b[d`t'])

}

* c)
gen union80 = union if year==1980
replace union80 = union[_n-1] if year==1981
replace union80 = union[_n-2] if year==1982
replace union80 = union[_n-3] if year==1983
replace union80 = union[_n-4] if year==1984
replace union80 = union[_n-5] if year==1985
replace union80 = union[_n-6] if year==1986
replace union80 = union[_n-7] if year==1987

xtprobit union l.union union80 d82-d87, re
gen prob = normal((_b[_cons]+_b[l.union]+_b[union80]*union80+_b[d87])/sqrt(1+e(sigma_u)^2)) if year==1987
sum prob