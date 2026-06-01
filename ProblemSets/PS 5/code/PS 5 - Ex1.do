/* Datos de Panel  - UTDT - PS 5 - Ejercicio 1

Profesor: Martín González-Rozada
Ayudante: Carlos Brutomeso

*/

clear all
set more off

cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS5"
u data\wagepan
des
summarize

xtset nr year
xtsum educ	// esta variable no varía en el tiempo


* a) Modelo de probabilidad lineal
reg union educ
reg union educ, vce(cluster nr)
estimates store POLS


* b) Pooled Probit
probit union educ
probit union educ, vce(cluster nr)	//los st. err. habituales son aproximadamente la mitad de los rob. std. err.
margins, dydx(educ) atmeans post
est sto PPROBIT

dprobit union educ, vce(cluster nr)	// alternativa al comando margins


* c) Pooled Logit
logit union educ
logit union educ, vce(cluster nr)	//los st. err. habituales son aproximadamente la mitad de los rob. std. err.
margins, dydx(educ) atmeans post
est sto PLOGIT

/* Delta Method */
do deltamethod

dlogit2 union educ, vce(cluster nr)	// alternativa al comando margins


* Resumen de efectos parciales promedios hasta el momento
est table POLS PPROBIT PLOGIT, se keep(educ)



* d) Modelo Probit de efectos aleatorios
xtprobit union educ, re
margins, dydx(educ) atmeans predict(pu0) post
est sto REPROBIT

qui sum educ
global educmean = r(mean)
qui xtprobit union educ, re
disp _b[educ]*normalden(_b[_cons]+_b[educ]*$educmean)	//check


* e) Modelo Logit de efectos aleatorios
xtlogit union educ, re
margins, dydx(educ) atmeans predict(pu0) post
est sto RELOGIT

qui xtlogit union educ, re
disp _b[educ]*exp(_b[_cons]+_b[educ]*$educmean)/(1+exp(_b[_cons]+_b[educ]*$educmean))^(2)		//check


* f) Modelo Logit de efectos fijos
xtlogit union educ, fe
margins, dydx(educ) atmeans predict(pu0) post
est sto FELOGIT


* Resumen de efectos parciales estimados d)-f)
est table REPROBIT RELOGIT FELOGIT, se keep(educ)



* g) Pooled Probit bajo enfoque Chamberlain-Mundlak
egen meanmarriedi = mean(married), by(nr)

sum educ if black==1&married==1
global g1= r(mean) 
sum meanmarriedi if black==1&married==1
global g2 = r(mean)

probit union educ black married meanmarriedi, vce(cluster nr)
margins, dydx(educ) at(educ=$g1 black=1 married=1 meanmarriedi=$g2) post

qui probit union educ black married meanmarriedi, vce(cluster nr)
disp _b[educ]*normalden(_b[_cons]+_b[educ]*$g1+_b[black]+_b[married]+_b[meanmarriedi]*$g2)		//check





