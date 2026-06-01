*Code for calculating the asymptotic variance of Wooldridge (1995) estimator
*under the Mundlak approach.


*Original Code Author: Anastasia Semykina
*In 'Estimating Panel Data Models in the Presence of Endogeneity and Selection' (with Jeffrey M. Wooldridge),
*Journal of Econometrics 157, August 2010, pp. 375-380.

*Modified by Carlos Brutomeso (April 2021). 
/*Any errors that the code may contain are my responsibility. */

****************************************************************************
* THIS PROGRAM SHOULD BE APPLIED ON A BALANCED PANEL, WHERE THE SELECTION
* INDICATOR IS ALWAYS OBSERVED, BUT THE DEPENDENT VARIABLE IN THE PRIMARY
* EQUATION MAY HAVE MISSING VALUES
*
****************************************************************************
* THE PROGRAM BELOW ASSUMES THAT THERE ARE NEITHER VARIABLES WHOSE NAMES
* START WITH T, t, mean, g, lam
* NOR VARIABLES NAMED cons, ehat, sample, num, obs, countid IN THE DATA SET
*
* IF THIS DOES NOT HOLD, THEN EITHER THE CORRESPONDING VARIABLES
* SHOULD BE RENAMED OR THE PROGRAM SHOULD BE CHANGED ACCORDINGLY
****************************************************************************
* IN local COMMANDS BELOW, <description> NEEDS TO BE REPLACED WITH THE
* CORRESPONDING VARIABLE NAMES
*
* TIME MEANS OF THE INSTRUMENTS AND TIME DUMMIES SHOULD BE OMITTED (!!!)
* FROM THE VARIABLE LISTS; THESE VARIABLES WILL BE CREATED BY THE PROGRAM
****************************************************************************
* V2 IS THE NAME FOR THE VARIANCE-COVARIANCE MATRIX CORRECTED FOR
* THE FIRST-STEP ESTIMATION
****************************************************************************
* THE PROGRAM PERFORMS SEVERAL CHECKS (COMPUTING BETA AND ROBUST VAR-COV
* MATRIX AND COMPARING THOSE WITH THE ESTMATES OBTAINED USING BUILT-IN
* STATA COMMANDS); THESE CAN BE USED TO VERIFY THAT PROGRAM WORKS CORRECTLY
*
* IF CORRECTED STANDARD ERRORS ARE UNREASONABLY LARGE, IT MAY BE USEFUL
* TO RUN THE FIRST-STEP PROBIT REGRESSIONS SEPARATELY AND MAKE SURE THAT
* THOSE ARE ALL RIGHT (FOR EXAMPLE, THAT NO VARIABLES ARE DROPPED FROM
* PROBIT REGRESSIONS BECAUSE OF PERFECT COLLINEARITY)
****************************************************************************


clear
set mem 80m
set matsize 600

set more off

cd "C:\Users\iaral\OneDrive - Universidad Torcuato Di Tella\Clases\Datos_de_Panel\PS4"
u data\keane

global id "id"			//<cross-section unit identifier>;
global year "year"		//<time identifier>;

global y1 "lwage"		//<dependent variable in the primary equation>;
global y2 "obswage"		//<selection indicator>;

global x "exper educ"	//<explanatory variables in the primary equation>;

global h "exper educ"	//<explanatory variables in the selection equation>;



*IF THE CONDITIONS ABOVE ARE MET, NOTHING NEEDS TO BE CHANGED BELOW THIS LINE

*****************************************************************************;

egen obs=sum($y2), by($id)	// number of obs. per cross-section unit with non-zero wage

qui sum $year
replace $year=$year-r(min)+1
scalar tmax=r(max)-r(min)+1		// total number of periods: reescala los períodos para que comiencen en 1, nos va a facilitar la creacion de las dummies temporales (evita los valores -1 que vimos en practicas pasadas)


*GENERATE TIME DUMMIES; year va de 1 a 7, arranco en 2 para evitar multicolinealidad

local i=2
 while `i'<=tmax {
 qui gen T`i'=($year==`i')
local i=`i'+1
}


*GENERATE TIME MEANS FOR REGRESSORS IN THE SELECTION EQUATION;

local j = 0
 foreach var of varlist $h {
 qui egen mean`var' = mean(`var'), by($id)
local j = `j'+1
}
  
scalar L2=`j'		// NUMBER OF EXPLANATORY VARIABLES IN SELECTION EQ = 2*L2+1 UNDER THE MUNDLAK APPROACH

  local j = 0
     foreach var of varlist $x {
  local j = `j'+1
  }

scalar K=`j'	//numero de regresores en la ecuación principal

*En nuestro ejemplo L2=K porque tengo solamente exper y educ en la ec de selección y la de interés
	

*GENERATE INVERSE MILLS RATIO FOR EACH T;

gen lambda=.

qui probit $y2 $h mean* 	// POOLED PROBIT - aca es donde el codigo asume que no hay ninguna variable que comience su nombre con mean, si tuvieras variables de este tipo tendrias añadidos regresores que no tendrian que estar

predict xb, xb
qui replace lambda=normalden(xb)/normal(xb) if $y2==1
drop xb


*GENERATE INTERACTION TERMS FOR LAMBDA;

local i=2
 while `i'<=tmax {
 qui gen lam`i'=T`i'*lambda
local i=`i'+1
}


***********PROCEDURE 4.2 (CORRECTION)***************;

reg $y1 $x lam* mean* if $y2==1  
qui gen sample=e(sample)	// CHECK FOR $y2: me genera una dummy con valor 1 si forma parte de mi muestra, si es parte del N de mi regresion


*OBTAIN COEFFICIENTS FOR LAMBDA TERMS FROM THE REGRESSION;

scalar gamma1=_b[lambda]
di gamma1

local i=2
 while `i'<=tmax {
 scalar gamma`i'=_b[lam`i']+gamma1
 di gamma`i'
local i=`i'+1
}

*WE ESTIMATE THE EQUATION: reg y1 x lam* mean* ;

*REPLICATE THIS RESULT USING MATRICES;


*****************************************************************;
* W IS A MATRIX OF THE SECOND-STAGE REGRESSORS
*****************************************************************;

*NOTE: # vars in W = K+L2+T+1;	(UNDER THE MUNDLAK APPROACH!)

*****************************************************************;
gen cons=1

mat accum WTW=$x lam* mean* cons, nocons
mat vecaccum yTW=$y1 $x lam* mean* cons, nocons
mat BETA=inv(WTW)*yTW'

********************************************************************;
* MATRIx BETA SHOULD BE IDENTICAL TO THE VECTOR OF THE COEFFICIENTS
* OBTAINED USING THE BUILT-IN STATA COMMAND, THIS IS JUST A CHECK
********************************************************************;

reg $y1 $x lam* mean* if sample==1
predict ehat, res

replace ehat=ehat*sample

mat list BETA


*REPLICATE VARIANCE MATRIX USING MATRICES;

mat accum EE=ehat if sample==1, nocons
mat V1=EE*inv(WTW)/(e(N)-K-L2-tmax-1)

qui reg $y1 $x lam* mean* if sample==1
outreg, store(t1) se sdec(3) noautosumm
mat V=e(V)
mat VCE=V[1..5,1..5]
mat VCE1=V1[1..5,1..5]


********************************************************************;
* MATRICES VCE AND VCE1 SHOULD BE IDENTICAL, THIS IS JUST A CHECK
********************************************************************;

matrix list VCE
matrix list VCE1



***	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	***
***	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	***
***																***
***  OBTAIN STD ERRORS CORRECTED FOR THE FIRST-STEP ESTIMATION  ***
***																***
***	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	***
***	*	*	*	*	*	*	*	*	*	*	*	*	*	*	*	***

/* NOTHING NEW SO FAR (!!)  

NOW WE WANT TO COMPUTE: AVAR = A^{-1}*B*A^{-1}/N

*/

* 

mat A=WTW

*****************************************************************;
* DEFINE NEW varli1, WHICH IS THE LIST OF THE EXPLANATORY VARIABLES USED 
* AT THE 2nd STAGE
*
* varli2 WILL BE THE LIST OF INTERACTION TERMS
* (W*<residuals from the second-stage regression>)
*****************************************************************;
*Armemos ahora la matriz B

**Primero armemos los \hat{q}
*Volvemos a definir las variables que van del lado derecho de la ec de interes
global varli1 $x lam* mean* cons
global varli2

*Para cada indiivduo sumo a traves del tiempo sit wit y eit
*Mwit eit -> interaccion de las variables explicativas de la ec de la segunda etapa con los residuos de la segunda etapa


* COMPUTE qi's
  local j = 1
     foreach w of varlist $varli1 {
     qui gen weh`w'=`w'*ehat
     qui egen q`w' = sum(weh`w'), by($id)	// Remark. 'ehat' has been set to zero when wage is unobservable
     global varli2 $varli2 q`w'
  local j = `j'+1
  }

/*
Hasta aca tuve todas las variables de la base, incluyendo las que la ec de seleccion es =0 (las que no observo el wage). Ahora vamos a buscar crear una variable que indique solo las filas de la base donde tengo info del salario
*/
  *Ordenamos por id y año
sort $id $year
*Para generar la lista numerada por id: toma valor 1 en cada t=1 por id
by $id: gen num=_n

gen countid=(num==1) if obs>=1 //si observo el salario (obs>=1) entonces genera una variable que vale 1 para la primera observacion temporal por id, sino vale 0. Con esto descarto a los que no tengo info de salarios en NINGUN periodo
sum countid		
scalar g=r(sum)			// SCALAR g BELOW IS THE NUMBER OF INDIVIDUALS IN THE SELECTED SAMPLE

mat accum WEEW=$varli2 if num==1, nocons	//armo una matriz que va a ser q*q, es el mismo listado de variables que antes, solo para los que tengo info de salarios
mat list WEEW			// matrix dimension: (K+L2+tmax+1) x (K+L2+tmax+1)
disp rowsof(WEEW)	
disp colsof(WEEW)

*CHECK
preserve
keep id year q* num
keep if num==1
mkmat q*, matrix(q)
mat WEEW2 = q'*q
mat list WEEW2		//tiene que ser igual a WEEW
restore

mat TERM1 = WEEW	//la llamamos como dijimos en el apunte

*****************************************************************;
* varli1 BELOW DEFINES THE LIST OF THE VARIABLES USED AS
* REGRESSORS AT THE 1st STAGE (PROBIT)
* varli3 AND varli4 ARE EMPTY FOR NOW AND WILL BE USED LATER
*****************************************************************;

*Pasamos a los otros terminos. Para eso armamos D y ri


global varli1 $h mean* cons

global varli3
global varli4

mat H=I(1+2*L2)		// HESSIAN MATRIX UNDER THE MUNDLAK APPROACH (!!)



**Loop a traves de los periodos
	*0. Corremos el probit
	*1. Generamos la matriz hessiana que me va a ayudar a computar la matrix ri
	*2. Generamos una variable temporal para computar la matriz score (derivada primera de la log verosimilitud)
	*3. Interacción entre el coeficiente de las dummies de tiempo y el coeficiente de la inversa del Coef. de Mills
	
local i=1
 while `i'<=tmax {
 di "Year="`i'
 **0**
 qui probit $y2 $h mean* 
 predict xb, xb
 mat H=e(V)	
 **1**
 local j=`i'-1
 **2**
 qui gen tempvar1=normalden(xb)/normal(xb) if $y2==1&$year==`i'
 qui replace tempvar1=-normalden(xb)/(1-normal(xb)) if $y2==0&$year==`i'
 assert lambda==tempvar1 if $y2==1&$year==`i'
 **3**
	  foreach var of varlist $varli1 {
	  qui cap gen g`var' = 0 if $y2==1		// VARIABLES TO COMPUTE MATRIX D
	  qui replace  g`var'= -lambda*(lambda+xb)*gamma`i'*`var' if $y2==1&$year==`i'

	  qui cap gen sc`var' = .	// VARIABLES FOR SCORE
	  qui replace  sc`var'= tempvar1*`var' if $year==`i'	//interacción entre tempvar1 con las variables para computar el score

	  }

drop xb tempvar*
local i=`i'+1
}
global varli3 $varli3 g* 	//variables que necesito para computar la matriz D
global varli4 $varli4 sc*	//variables que necesito para computar la matriz score

** Si no observo el salario, a las variables de esa lista les asigno un 0
foreach var of varlist $y1 $x lam* mean* $h cons {
qui replace  `var'=`var'*sample
}

* COMPUTE MATRIX D
mkmat g* if $y2==1, matrix(G)
mkmat $x lam* mean* cons if $y2==1, matrix(W)
mat D = W'*G	// matrix dimension: (K+L2+tmax+1) x (K+L2+1)  (UNDER THE MUNDLAK APPROACH)

mat accum Daux = $x lam* mean* cons g* if $y2==1, nocons
mat D2 = Daux[1..K+L2+tmax+1, K+L2+tmax+1+1.. .]
mat list D		// CHECK!
mat list D2


*Recordar! ri es inf del Hessiano * función score del log de la función de verosimilitud del probit estimado para las observaciones

* COMPUTE D*ri*ri'*D'
mat accum SS=$varli4 if num==1&obs>=1, nocons
mat TERM4 = D*H*SS*H*D'


* H viene a ser lo que llamamos ri 
mat accum TEMP=$varli2 $varli4 if num==1, nocons
mat WES=TEMP[1..K+L2+tmax+1,K+L2+tmax+2...]
mat TERM2=WES*H*D'

*
mat B=TERM1-TERM2-TERM2'+TERM4

mat V2=inv(A)*B*inv(A)
mat VCE2=V2[1..5,1..5]	//me quedo con las primeras 5 filas y 5 columnas de la matriz

*PART OF THE V-C MATRIX FROM STATA;
matrix list VCE

*PART OF THE V-C MATRIX COMPUTED BY THE PROGRAM;
matrix list VCE1

*PART OF THE ROBUST V-C MATRIX THAT TAKES INTO ACCOUNT THE FIRST-STEP ESTIMATION;
matrix list VCE2

matrix b=BETA'

ereturn post b V2
ereturn display
outreg, merge(t1) se sdec(3) noautosumm

