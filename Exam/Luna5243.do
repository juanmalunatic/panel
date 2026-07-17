/********************************************************************
  Universidad Torcuato di Tella
  Datos de Panel: Examen Final
  Juan Manuel Luna
  Julio 16, 2026
********************************************************************/

cd "C:\AcademicRepos\Panel\Exam"
cls
version 17
clear all
set more off

// Almaceno el seed para reproducibilidad al cambiar flags de ejecución:
// Siempre seteo el seed al iniciar un inciso / sub-inciso.
global THE_SEED = 5243
set seed $THE_SEED

capture log close
log using "Luna5243.log", replace text


/********************************************************************
Flags para correr únicamente partes de ejercicios específicos.
********************************************************************/

global RUN_E1_A 0
global RUN_E1_B 0
global RUN_E1_B6_FE_TABLE 0

global RUN_E2   0
global RUN_E3   0
global RUN_E3_7 1

/*******************************************************************************
EJERCICIO 1 - Pruebas de Especificación, Hausman y Errores Estándar Robustos
*******************************************************************************/

/* 
Modelo de efectos no observables con heterogeneidad individual
y_it = b0 + b1 x1_it + b2 x2_it + c_i + u_it  con i \in [1,...,N] y t = \in [1, ..., T]
*/
   
/******************************************************************************/

// EJ1: Prerequisitos: 

// Básicamente ejecutar el built-in de stata, con "sigmamore" como ajuste.
// Así no tengo que copiar y pegar tantas veces el mismo bloque
// y queda más legible.
capture program drop hausman_stata_pair
program define hausman_stata_pair, rclass
    version 17

	// Esperamos 3 vars de entrada: y, x1, x2 y ponemos significancia hardcoded.
    syntax varlist(min=3 numeric) [if] [in], [Alpha(real 0.05)]

	// Por default dejamos missing. Solo se reemplaza si el cálculo sale bien.
	return scalar reject_raw = .
	return scalar reject_cor = .

	// Me recomendó GPT para respetar restricciones de missing values
    marksample touse
    gettoken y xvars : varlist
    tempname fe re

	// Hacemos FE (within)
    quietly xtreg `y' `xvars' if `touse', fe
    estimates store `fe'

	// Hacemos RE
    quietly xtreg `y' `xvars' if `touse', re
    estimates store `re'

	// Hausman sin corrección.
	capture quietly hausman `fe' `re'
	if !_rc & !missing(r(p)) & !missing(r(chi2)) & r(chi2) >= 0 {
		return scalar reject_raw = (r(p) < `alpha')
	}

	// Hausman con sigmamore.
	// - sigmamore hace que ambas matrices varcov usen una estimación común de sigma2
    // - en particular, usa la varianza del estimador eficiente. En este caso, RE bajo H0.
	capture quietly hausman `fe' `re', sigmamore
	
	if !_rc & !missing(r(p)) & !missing(r(chi2)) & r(chi2) >= 0 {
		// Reemplazamos . con el resultado correcto
		return scalar reject_cor = (r(p) < `alpha')
	}

	// Como antes, se retorna 0 si no rechaza, 1 si sí, . si error numérico.
    capture estimates drop `fe' `re'
end

// Aquí implementamos lo mismo como check y herramienta pedagógica
// pero con las ecuaciones matriciales vistas en clase y el escalado
// que reporta la documentación de Stata que hace con `sigmamore'

// Fue implementado para chequear que sigmamore diera lo mismo (y da)
// pero no se usa en el flujo del programa de abajo reportado
// porque prefiero confiar en Stata :)

capture program drop hausman_manual_pair
program define hausman_manual_pair, rclass
    version 17

    syntax varlist(min=3 numeric) [if] [in], [Alpha(real 0.05)]

	// Como antes dejamos missing por default
	return scalar reject_raw = .
	return scalar reject_cor = .

    marksample touse
    gettoken y xvars : varlist

	// acá almacenamos k para permitir que hubiera otro numero de regresores
    local k : word count `xvars'

    tempname b_fe V_fe b_re V_re bdiff
	tempname Vdiff_raw Vdiff_cor V_fe_cor Vinv chi2
    tempname sig_fe sig_re h

	// FE-within y almacenamos los valores necesarios
	quietly xtreg `y' `xvars' if `touse', fe
	matrix `b_fe' = e(b)
	matrix `V_fe' = e(V)
	scalar `sig_fe' = e(sigma_e)^2
	
	// RE, ídem.
    quietly xtreg `y' `xvars' if `touse', re
	matrix `b_re' = e(b)
	matrix `V_re' = e(V)
	scalar `sig_re' = e(rmse)^2

	// Se agarran los primeros k regresores
    matrix `bdiff' = `b_fe'[1,1..`k'] - `b_re'[1,1..`k']

	// --------------------------------------------------
	// Hausman manual sin corrección
	// --------------------------------------------------

    matrix `Vdiff_raw' = `V_fe'[1..`k',1..`k'] - `V_re'[1..`k',1..`k']

	// Si no se puede invertir, queda missing
    capture matrix `Vinv' = inv(`Vdiff_raw')
	
	// Check de inversibilidad
	local ok = (_rc == 0)

	if `ok' {
		capture matrix `chi2' = `bdiff' * `Vinv' * `bdiff''
		
		// Check de producto exitoso
		local ok = (_rc == 0)
	}

	if `ok' {
		scalar `h' = `chi2'[1,1]
		if !missing(`h') & `h' >= 0 {
			// Si todo salio bien y la matriz era definida positiva
			return scalar reject_raw = (chi2tail(`k', `h') < `alpha')
		}
	}

	// --------------------------------------------------
	// Hausman manual con corrección tipo sigmamore
	// --------------------------------------------------

    // Como antes, corrección tipo sigmamore pero a mano.
	// Fuerza escala común de sigma usando la sigma del estimador eficiente, RE bajo H0.
	
	// El factor de escala que usa Stata
	matrix `V_fe_cor' = `V_fe' * (`sig_re' / `sig_fe')
	
	// Aplicandolo a la matriz
	matrix `Vdiff_cor' = `V_fe_cor'[1..`k',1..`k'] - `V_re'[1..`k',1..`k']

	// Acá exactamente los mismos sanity checks que en el programa anterior ...
	capture matrix `Vinv' = inv(`Vdiff_cor')
	local ok = (_rc == 0)

	if `ok' {
		capture matrix `chi2' = `bdiff' * `Vinv' * `bdiff''
		local ok = (_rc == 0)
	}

	if `ok' {
		scalar `h' = `chi2'[1,1]
		if !missing(`h') & `h' >= 0 {
			// ... y sobreescribo solo si llegamos hasta acá.
			return scalar reject_cor = (chi2tail(`k', `h') < `alpha')
		}
	}

	// Como en el programa built-in, se retorna 0 si no rechaza, 1 si sí, . si error numérico.
end

// EJ1: Flujo principal
capture program drop EJERCICIO_1 
program define EJERCICIO_1

version 17
di as text "== EJERCICIO 1: inicio =="

// ------------------------------------------------
// Creo timestamps para almacenar datos con fecha
// ------------------------------------------------
capture mkdir "output"
capture mkdir "output/e1"

local dnum = daily("`c(current_date)'", "DMY")
local yyyy = string(year(`dnum'), "%04.0f")
local mm   = string(month(`dnum'), "%02.0f")
local dd   = string(day(`dnum'), "%02.0f")
local hhmmss = subinstr("`c(current_time)'", ":", "", .)

local run_stamp = "`yyyy'-`mm'-`dd'_`hhmmss'"
local outdir    = "output/e1"

di as text "E1 run_stamp: `run_stamp'"

// -------------------------------------------------------------
// Configuro flags para permitir correr por separado E1.A y E1.B
// -------------------------------------------------------------
if $RUN_E1_A {

	// Reproducibilidad: Reinicio el seed para ambas partes
	set seed $THE_SEED
	di as text "!!! ---------- 1A -------------- !!! "
	
	// Frame aparte para arrancar de cero
	capture frame drop E1A_DATA
	frame create E1A_DATA
	frame change E1A_DATA
	
	// Setup del panel y simus
	local S = 2000
	local N = 200
	local T = 6
	local NT = `N' * `T'

	// Agrego el número de simulaciones al prefijo, asi se cuantas hice
	local run_prefix = "`run_stamp'__S`S'"
	di as text "E1A run_prefix: `run_prefix'"
	
	set obs `NT'
	egen id = seq(), f(1) t(`N') b(`T')
	egen time = seq(), f(1) t(`T')
	xtset id time
	
	// Setup de parametros
	local beta0 = 1 
	local beta1 = 0.6
	local beta2 = -0.4
	
	local sig2_c  = 4
	local sig2_e  = 1
	local sig2_v  = 2
	local sig2_x2 = 3
	local rho     = 0.6
	
	// Matrices para almacenar resultados
	
	matrix b1h_ols = J(`S',1,.)  // OLS
	matrix b2h_ols = J(`S',1,.)
	
	matrix b1h_re  = J(`S',1,.)  // RE
	matrix b2h_re  = J(`S',1,.)
	
	matrix b1h_fe  = J(`S',1,.)  // FE
	matrix b2h_fe  = J(`S',1,.)
	
	matrix se1_fe_conv = J(`S',1,.) // SE convencionales
	matrix se2_fe_conv = J(`S',1,.)
	
	matrix se1_fe_rc = J(`S',1,.) // SE robustos clustered
	matrix se2_fe_rc = J(`S',1,.)
	
	// Medidas de Hausman para el inciso 4
	
	// Sin corrección
	matrix haus_man = J(`S',1,.) // Hausman manual
	matrix haus_sta = J(`S',1,.) // Hausman built-in
	matrix haus_al1 = J(`S',1,.)  // rho=0 con endog.
	matrix haus_al2 = J(`S',1,.)  // rho=0 con exoge.
	
	// Con corrección
	matrix haus_man_c = J(`S',1,.) // igual que arriba pero corregidos
	matrix haus_sta_c = J(`S',1,.)
	matrix haus_al1_c = J(`S',1,.)
	matrix haus_al2_c = J(`S',1,.)
	
	matrix mundlak = J(`S',1,.) // Mundlak
	
	// Loop. s indexa simulacion
	qui {
	forvalues s=1/`S'{
		
		// Limpia todo menos la estructura del panel
		keep id time
		
		// Avisa progreso
		if floor((`s')/50)==(`s')/50 {
		noisily display "working on `s' out of `S' at $S_TIME" 
		}
		
		// --------------------------
		// Creación de variables
		// --------------------------
		
		// AI: Error del que me salvó la IA: sqrt(sig^2) en vez de sig^2 solo
		
		gen c_i = .
		forvalues i = 1/`N' {
			scalar c_i_aux = rnormal(0, sqrt(`sig2_c'))
			qui replace c_i = c_i_aux if id == `i'
		} 
		
		gen v1_it = rnormal(0, sqrt(`sig2_v'))
		gen x1_it = 0.5 * c_i + v1_it
		gen x2_it = rnormal(0, sqrt(`sig2_x2'))	
		
		// primero creo el shock del error
		gen eps_it = rnormal(0, sqrt(`sig2_e'))
		gen u_it = .
		// para t = 1, asumo u_i0 = 0, entonces u_i1 = e_i1
		replace u_it = eps_it if time == 1 
		// para t >= 2, se implementa AR(1)
		forvalues t = 2/`T' {
			replace u_it = `rho' * L.u_it + eps_it if time == `t'
		}
		gen y_it = `beta0' + `beta1' * x1_it + `beta2' * x2_it + c_i + u_it
		
		// Spoiler inciso 4 {
		// generamos vars para DGP alternativo para el tamaño empírico
		// rho = 0
		gen ualt_it = eps_it
		gen yalt1_it = `beta0' + `beta1' * x1_it + `beta2' * x2_it + c_i + ualt_it
		// rho = 0 y ademas exog
		gen x1alt_it = v1_it		
		gen yalt2_it = `beta0' + `beta1' * x1alt_it + `beta2' * x2_it + c_i + ualt_it
		// }
		
		// --------------------------
		// Estimaciones
		// --------------------------
		
		// AI: Error del que me salvó la IA: c_i incluido
		
		// Inciso 1, POLS
		reg y_it x1_it x2_it
		matrix b1h_ols[`s',1] = _b[x1_it]
		matrix b2h_ols[`s',1] = _b[x2_it]
		
		// Inciso 2, RE
		xtreg y_it x1_it x2_it, re
		matrix b1h_re[`s',1] = _b[x1_it]
		matrix b2h_re[`s',1] = _b[x2_it]

		// Inciso 3
		// FE-within
		xtreg y_it x1_it x2_it, fe
		matrix b1h_fe[`s',1] = _b[x1_it]
		matrix b2h_fe[`s',1] = _b[x2_it]
		
		matrix se1_fe_conv[`s',1] = _se[x1_it] // Almacenamos SE para comprarar
		matrix se2_fe_conv[`s',1] = _se[x2_it]
		
		// FE con cluster
		xtreg y_it x1_it x2_it, fe vce(cluster id)	
		
		matrix se1_fe_rc[`s',1] = _se[x1_it]  // Acá también
		matrix se2_fe_rc[`s',1] = _se[x2_it]
		
		// Inciso 4

		// hausman_stata_pair devuelve dos resultados:
		//  si rechaza el test "verbatim" (o da . si error numerico)
		//  si rechaza el test corregido con sigmamore

		// DGP base: AR(1) + endogeneidad, Hausman de Stata
		quietly hausman_stata_pair ///
			y_it x1_it x2_it
		matrix haus_sta[`s',1]   = r(reject_raw)
		matrix haus_sta_c[`s',1] = r(reject_cor)

		// Alt1: rho = 0, pero endogeneidad. Hausman de Stata
		// Este es el test que pide la consigna pero no es realmente tamaño empírico
		quietly hausman_stata_pair /// 
			yalt1_it x1_it x2_it
		matrix haus_al1[`s',1]   = r(reject_raw)
		matrix haus_al1_c[`s',1] = r(reject_cor)

		// Alt2: rho = 0 y exogeneidad respecto de c_i. Hausman de Stata
		// Este sí es el tamaño real del test.
		quietly hausman_stata_pair ///  
			yalt2_it x1alt_it x2_it
		matrix haus_al2[`s',1]   = r(reject_raw)
		matrix haus_al2_c[`s',1] = r(reject_cor)
		
		// Inciso 5: Según la consigna
		bysort id: egen mean_x1 = mean(x1_it) // calculamos las medias
		bysort id: egen mean_x2 = mean(x2_it)
        xtreg y_it x1_it x2_it mean_x1 mean_x2, re  // RE con medias como regres.
		test mean_x1 mean_x2
		// se almacena un 1 si se rechaza, 0 si no
		matrix mundlak[`s',1] = (r(p) < 0.05)	
		
		
	}
	}
	
	// Se usa el truco de la práctica para manejar los resultados en un dataframe
	capture frame drop E1A_RESULTS
	frame create E1A_RESULTS
	frame change E1A_RESULTS
	
	matrix results = b1h_ols, b2h_ols, b1h_re, b2h_re, b1h_fe, b2h_fe, ///
					 se1_fe_conv, se2_fe_conv, se1_fe_rc, se2_fe_rc, ///
					 haus_sta, haus_al1, haus_al2, ///
					 haus_sta_c, haus_al1_c, haus_al2_c, ///
					 mundlak

	matrix colnames results = b1_ols b2_ols b1_re b2_re b1_fe b2_fe ///
							  se1_fe_conv se2_fe_conv se1_fe_rc se2_fe_rc ///
							  haus_base_raw haus_rho0_raw haus_true_null_raw ///
							  haus_base_cor haus_rho0_cor haus_true_null_cor ///
							  mundlak

	// Creo primero las S observaciones y la variable que identifica
	// cada simulación, para que svmat no resetee las observaciones.
	set obs `S'
	gen int rep = _n
	svmat double results, names(col)

	// Una vez que está armado el dataset, lo exporto:
	// Una fila por simulación con los nombres de colnames results
	order rep
	save "`outdir'/`run_prefix'__e1_A_raw.dta", replace

	// --------------------------------------------------
	// Tabla E1A.1-E1A.3: desempeño de los estimadores
	// Ambos parámetros en una sola tabla
	// --------------------------------------------------

	// Se calculan diferencias al cuadrado para cada estimador (ols, re, fe)
	foreach est in ols re fe {
		gen sqerr_b1_`est' = (b1_`est' - `beta1')^2
		gen sqerr_b2_`est' = (b2_`est' - `beta2')^2
	}

	// Se arma la matriz para la tabla del informe
	matrix TAB_ESTIMATORS = J(6,4,.)
	matrix rownames TAB_ESTIMATORS = ///
		beta1_POLS beta1_RE beta1_FE ///
		beta2_POLS beta2_RE beta2_FE
	// La idea es mostrar beta, \hat{beta}, mean, sd, rmse para cada estimador:
	matrix colnames TAB_ESTIMATORS = true_value mean sd rmse

	local r = 1

	// Se itera cada beta
	foreach b in 1 2 {
		// Si b=1 -> beta1, si no beta2.
		local btrue = cond(`b' == 1, `beta1', `beta2')

		// Se itera cada estimador agarrando los valores
		foreach est in ols re fe {
			matrix TAB_ESTIMATORS[`r',1] = `btrue'

			// Acá se computan media y sd de b1_est
			quietly summarize b`b'_`est'
			matrix TAB_ESTIMATORS[`r',2] = r(mean)
			matrix TAB_ESTIMATORS[`r',3] = r(sd)

			// Acá el RMSE a partir de las diferencias al cuadrdo
			quietly summarize sqerr_b`b'_`est'
			matrix TAB_ESTIMATORS[`r',4] = sqrt(r(mean))

			local r = `r' + 1
		}
	}

	di as text "== E1A: desempeño de POLS, RE y FE =="
	matrix list TAB_ESTIMATORS, format(%12.4f)

	// Acá preserve guarda un snapshot del dataset
	// porque lo vamos a modificar y luego a restaurar
	preserve

		// Convierto la matriz en variables
		svmat double TAB_ESTIMATORS, names(col)

		// Formateo salida:
		// 1, 4 son b1 y b2 de POLS
		// 2, 5 son b1 y b2 de RE
		// 3, 6 son b1 y b2 de FE
		keep in 1/6
		gen str8 parameter = cond(_n <= 3, "beta1", "beta2")
		gen str8 estimator = ""
		replace estimator = "POLS" if inlist(_n, 1, 4)
		replace estimator = "RE"   if inlist(_n, 2, 5)
		replace estimator = "FE"   if inlist(_n, 3, 6)

		// Dejo solo las columnas de interés para el output
		keep parameter estimator true_value mean sd rmse
		order parameter estimator true_value mean sd rmse

		// Exporto CSV para el informe
		export delimited using "`outdir'/`run_prefix'__e1_A_estimators.csv", replace

	// restauro el dataset
	restore
	
	// --------------------------------------------------
	// Parte A3: Comparacion de errores estandar FE
	// --------------------------------------------------
	// Queremos analizar los errores convencionales
	// con los robustos por cluster

	// La idea es tener SD_montecarlo, SE_conv, SE_cluster, y sus dos ratios vs el MC_se
	// Fila 1 para b1, fila 2 para b2
	matrix TAB_SE_FE = J(2,5,.)
	matrix rownames TAB_SE_FE = beta1 beta2	
	matrix colnames TAB_SE_FE = MC_sd mean_SE_conv mean_SE_cluster ratio_conv ratio_cluster

	// beta1

	quietly summarize b1_fe 
	local mc_sd = r(sd) // SD para cada estimacion

	quietly summarize se1_fe_conv
	local se_conv = r(mean) // promedio de SE convencional

	quietly summarize se1_fe_rc
	local se_cl = r(mean)   // promedio de SE robusto

	// Almacenar donde corresponde:
	matrix TAB_SE_FE[1,1] = `mc_sd'
	matrix TAB_SE_FE[1,2] = `se_conv'
	matrix TAB_SE_FE[1,3] = `se_cl'
	matrix TAB_SE_FE[1,4] = `se_conv' / `mc_sd'  // Qué share del SD empírico ...
	matrix TAB_SE_FE[1,5] = `se_cl' / `mc_sd'    // ... tiene cada se_*

	// beta2 es idéntico en estructura
	quietly summarize b2_fe
	local mc_sd = r(sd)

	quietly summarize se2_fe_conv
	local se_conv = r(mean)

	quietly summarize se2_fe_rc
	local se_cl = r(mean)

	matrix TAB_SE_FE[2,1] = `mc_sd'
	matrix TAB_SE_FE[2,2] = `se_conv'
	matrix TAB_SE_FE[2,3] = `se_cl'
	matrix TAB_SE_FE[2,4] = `se_conv' / `mc_sd'
	matrix TAB_SE_FE[2,5] = `se_cl' / `mc_sd'

	di as text "== FE: comparacion de SE convencionales vs cluster =="
	matrix list TAB_SE_FE, format(%12.4f)
	
	// Creación de la tabla para comparar FE
	preserve
		// Pasamos la matriz a las variables
		svmat double TAB_SE_FE, names(col)

		// Me quedo con las dos filas (b1, b2) y nombramos
		keep in 1/2
		gen str8 parameter = cond(_n == 1, "beta1", "beta2")

		// Me quedo con las columnas de la tabla y ordeno
		keep parameter MC_sd mean_SE_conv mean_SE_cluster ///
			ratio_conv ratio_cluster
		order parameter MC_sd mean_SE_conv mean_SE_cluster ///
			ratio_conv ratio_cluster

		// Exporto el CSV
		export delimited using "`outdir'/`run_prefix'__e1_A_se_fe.csv", replace
	restore

	// --------------------------------------------------
	// Parte A4 - A5: Hausman y Mundlak: tamaño y potencia
	// --------------------------------------------------

	// Recordemos que ambos tests devuelven variables binarias (1 o 0) que significan rechazo
	// - hausman_stata_pair devuelve un par (X,Y) \in {0,1} x {0,1}
	//   donde X es si rechazó el "raw", Y si rechazó el corregido (sigmamore)
	// - mundlak devuelve un solo valor de rechazo

	// Creo una tabla para almacenar los resultados de los tests
	matrix TAB_TESTS = J(7,2,.)

	// Recordemos que hay tres escenarios:
	// - Base, generado con y_it x1_it x2_it, con rho=0.6 y endogeneidad.
	//   Esperamos alto rechazo: mide potencia bajo el DGP base.
	//
	// - Rho0_literal, generado con yalt1_it x1_it x2_it.
	//   Cumple literalmente rho=0, pero sigue habiendo endogeneidad con c_i.
	//   RE sigue siendo inconsistente y esperamos alto rechazo.
	//
	// - True_null, generado con yalt2_it x1alt_it x2_it.
	//   En este escenario se cumple la nula, con rho=0 y exogeneidad con c_i.
	//   Esperamos que el tamaño sea ~5%.

	// 7 filas:
	matrix rownames TAB_TESTS =       /// Escenario base:
		Hausman_raw_base              ///   "Raw" con potencial error numérico
		Hausman_sigmamore_base        ///   Con corrección, potencia
		///                            // Escenario literal rho=0:
		Hausman_raw_rho0_literal      ///   "Raw" con potencial error numérico
		Hausman_sigmamore_rho0_literal ///  Con corrección
		///                            // Escenario H0:
		Hausman_raw_true_null         ///   "Raw" con potencial error numérico
		Hausman_sigmamore_true_null   ///   Con corrección, tamaño empírico
		///                            // Escenario base:
		Mundlak_base                   //   Mundlak, sobre la base
	matrix colnames TAB_TESTS = rejection_rate valid_N

	local r = 1

	// Itero cada test
	foreach result_var in ///
		haus_base_raw haus_base_cor ///
		haus_rho0_raw haus_rho0_cor ///
		haus_true_null_raw haus_true_null_cor ///
		mundlak {

		quietly summarize `result_var'
		matrix TAB_TESTS[`r',1] = r(mean)  // Tomo la media
		matrix TAB_TESTS[`r',2] = r(N)     // Y la cantidad de filas válidas (importante para "raw")
		local r = `r' + 1
	}

	di as text "== E1A: tests de Hausman y Mundlak =="
	// Doy formato numérico
	matrix list TAB_TESTS, format(%12.4f)

	preserve
		// Paso la tabla al dataset
		svmat double TAB_TESTS, names(col)
		keep in 1/7

		// Labels adecuados
		gen str20 test = ""
		replace test = "Hausman_raw"       if inlist(_n, 1, 3, 5)
		replace test = "Hausman_sigmamore" if inlist(_n, 2, 4, 6)
		replace test = "Mundlak"           in 7

		gen str12 scenario = "base"
		replace scenario = "rho0_literal" if inlist(_n, 3, 4)
		replace scenario = "true_null"    if inlist(_n, 5, 6)

		// Ordeno y almaceno
		keep test scenario rejection_rate valid_N
		order test scenario rejection_rate valid_N
		export delimited using "`outdir'/`run_prefix'__e1_A_tests.csv", replace
	restore
	
	// TO-DO: Retirar
	
	di as text "== Diagnósticos raw == "
	
	// beta1
	tabstat b1_ols b1_re b1_fe, ///
	        statistics(mean sd) ///
			columns(statistics) ///
			format(%12.4f) ///
			varwidth(14)
	
	
	// beta2
	tabstat b2_ols b2_re b2_fe, ///
	        statistics(mean sd) ///
			columns(statistics) ///
			format(%12.4f) ///
			varwidth(14)
	
	// se1
	tabstat se1_fe_conv se1_fe_rc, ///
		statistics(mean sd) ///
		columns(statistics) ///
		format(%12.4f) ///
		varwidth(14)
	
	// se2
	tabstat se2_fe_conv se2_fe_rc, ///
		statistics(mean sd) ///
		columns(statistics) ///
		format(%12.4f) ///
		varwidth(14)
	
	// Hausman sin corregir: tasas de rechazo entre simulaciones válidas
	tabstat haus_base_raw haus_rho0_raw haus_true_null_raw, ///
        statistics(mean count) ///
        columns(statistics) ///
        format(%12.4f) ///
        varwidth(20)
	
	// Hausman corregido: tasas de rechazo entre simulaciones válidas	
	tabstat haus_base_cor haus_rho0_cor haus_true_null_cor, ///
        statistics(mean count) ///
        columns(statistics) ///
        format(%12.4f) ///
        varwidth(20)
		
	tabstat mundlak, ///
		statistics(mean count) ///
		columns(statistics) ///
		format(%12.4f) ///
		varwidth(18)
		
    //frame change E1A_DATA

}

if $RUN_E1_B {
	// Reproducibilidad: como antes, se inicia del mismo seed
	set seed $THE_SEED
	di as text "!!! ---------- 1B -------------- !!! "
	
	// Frame aparte para arrancar de cero
	capture frame drop E1B_DATA
	frame create E1B_DATA
	frame change E1B_DATA
	
	// Tres setups
	local S = 2000
	local TAMS = 3 // 3 configs de tamanios muestrales

	// Como antes, pongo S en el nombre del output
	local run_prefix = "`run_stamp'__S`S'"
	di as text "E1B run_prefix: `run_prefix'"
	
	// Matrices de almacenamiento
	matrix b1h_ols = J(`S',`TAMS',.)  // OLS
	matrix b1h_re  = J(`S',`TAMS',.)  // RE
	matrix b1h_fe  = J(`S',`TAMS',.)  // FE

	matrix b2h_ols = J(`S',`TAMS',.)  // OLS
	matrix b2h_re  = J(`S',`TAMS',.)  // RE
	matrix b2h_fe  = J(`S',`TAMS',.)  // FE

	matrix se1_fe_conv = J(`S',`TAMS',.) // SE convencionales
	matrix se2_fe_conv = J(`S',`TAMS',.)

	matrix se1_fe_rc = J(`S',`TAMS',.) // SE robustos clustered
	matrix se2_fe_rc = J(`S',`TAMS',.)
	
	// Loop principal de tamaños
	forvalues tam = 1/`TAMS'{
		
		if (`tam' == 1) {
			local N = 50
			local T = 4
		}
		else if (`tam' == 2) {
			local N = 200
			local T = 6
		}
		else if (`tam' == 3) {
			local N = 500
			local T = 10
		}
		
		local NT = `N' * `T'
		
		// Creación de panel
		clear
		set obs `NT'
		egen id = seq(), f(1) t(`N') b(`T')
		egen time = seq(), f(1) t(`T')
		xtset id time
		
		// Setup de parametros
		local beta0 = 1 
		local beta1 = 0.6
		local beta2 = -0.4
		
		local sig2_c  = 4
		local sig2_e  = 1
		local sig2_v  = 2
		local sig2_x2 = 3
		local rho     = 0.6		
		
		// Loop. s indexa simulacion
		qui {
		forvalues s=1/`S'{
			
			// Limpia todo menos la estructura del panel
			keep id time
			
			// Avisa progreso
			if floor((`s')/50)==(`s')/50 {
			noisily display "working on `s' out of `S' at $S_TIME" 
			}
			
			// --------------------------------------
			// Creación de variables: Igual que en 1A
			// --------------------------------------
			
			gen c_i = .
			forvalues i = 1/`N' {
				scalar c_i_aux = rnormal(0, sqrt(`sig2_c'))
				qui replace c_i = c_i_aux if id == `i'
			} 
			
			gen v1_it = rnormal(0, sqrt(`sig2_v'))
			gen x1_it = 0.5 * c_i + v1_it
			gen x2_it = rnormal(0, sqrt(`sig2_x2'))	
			gen eps_it = rnormal(0, sqrt(`sig2_e'))
			
			gen u_it = .
			replace u_it = eps_it if time == 1 
			forvalues t = 2/`T' {
				replace u_it = `rho' * L.u_it + eps_it if time == `t'
			}
			
			gen y_it = `beta0' + `beta1' * x1_it + `beta2' * x2_it + c_i + u_it
		
			
			// --------------------------
			// Estimaciones
			// --------------------------
			
			* POLS
			reg y_it x1_it x2_it
			matrix b1h_ols[`s',`tam'] = _b[x1_it]
			matrix b2h_ols[`s',`tam'] = _b[x2_it]
		
			* RE
			xtreg y_it x1_it x2_it, re
			matrix b1h_re[`s',`tam'] = _b[x1_it]
			matrix b2h_re[`s',`tam'] = _b[x2_it]
			
			* FE-within
			xtreg y_it x1_it x2_it, fe
			matrix b1h_fe[`s',`tam'] = _b[x1_it]
			matrix b2h_fe[`s',`tam'] = _b[x2_it]
					
			matrix se1_fe_conv[`s',`tam'] = _se[x1_it] // Almacenamos SE para comprarar
			matrix se2_fe_conv[`s',`tam'] = _se[x2_it]
			
			* FE con cluster
			xtreg y_it x1_it x2_it, fe vce(cluster id)	
			
			matrix se1_fe_rc[`s',`tam'] = _se[x1_it]  // Acá también
			matrix se2_fe_rc[`s',`tam'] = _se[x2_it]	
			
		}
		}
		
		
	}
	
	// Se usa el truco de la práctica para manejar los resultados en un dataframe
	// ==================================================
	// RESULTADOS EJERCICIO 1B
	// Usamos la misma lógica de 1A: matriz results + svmat
	// ==================================================
	capture frame drop E1B_RESULTS
	frame create E1B_RESULTS
	frame change E1B_RESULTS

	// --------------------------------------------------
	// Pasar matrices Monte Carlo a variables con svmat
	// Cada matriz es S x 3, con columnas:
	// 1 = N50T4, 2 = N200T6, 3 = N500T10
	// --------------------------------------------------

	matrix results = ///
		b1h_ols, b1h_re, b1h_fe, ///
		b2h_ols, b2h_re, b2h_fe, ///
		se1_fe_conv, se1_fe_rc, ///
		se2_fe_conv, se2_fe_rc

	matrix colnames results = ///
		b1_ols_n50t4   b1_ols_n200t6   b1_ols_n500t10 ///
		b1_re_n50t4    b1_re_n200t6    b1_re_n500t10 ///
		b1_fe_n50t4    b1_fe_n200t6    b1_fe_n500t10 ///
		b2_ols_n50t4   b2_ols_n200t6   b2_ols_n500t10 ///
		b2_re_n50t4    b2_re_n200t6    b2_re_n500t10 ///
		b2_fe_n50t4    b2_fe_n200t6    b2_fe_n500t10 ///
		se1_fe_conv_n50t4 se1_fe_conv_n200t6 se1_fe_conv_n500t10 ///
		se1_fe_rc_n50t4   se1_fe_rc_n200t6   se1_fe_rc_n500t10 ///
		se2_fe_conv_n50t4 se2_fe_conv_n200t6 se2_fe_conv_n500t10 ///
		se2_fe_rc_n50t4   se2_fe_rc_n200t6   se2_fe_rc_n500t10

	// Como en E1A, creo primero las S observaciones y la variable que identifica
	// cada simulación, para que svmat no resetee las observaciones.
	set obs `S'
	gen int rep = _n

	svmat double results, names(col)

	// Como en E1A, guardo el dataset antes de manipular para los resultados.
	// Hay una fila por simulación.
	order rep
	save "`outdir'/`run_prefix'__e1_B_raw.dta", replace


	// --------------------------------------------------
	// Tabla 1B.7: beta1
	// Media, SD Monte Carlo y RMSE para POLS, RE y FE
	// bajo las tres combinaciones (N,T)
	// --------------------------------------------------

	// Se arma la tabla para E1.B7: 9 filas para beta1
	matrix TAB_E1B_B1 = J(9,4,.)
	matrix rownames TAB_E1B_B1 = ///
		POLS_n50t4   /// POLS
		POLS_n200t6  ///
		POLS_n500t10 ///
		RE_n50t4     /// RE
		RE_n200t6    ///
		RE_n500t10   ///
		FE_n50t4     /// FE
		FE_n200t6    /// 
		FE_n500t10

	// Cuatro columnas, parametro, promedio, sd, rmse
	matrix colnames TAB_E1B_B1 = true_value mean sd rmse

	local r = 1
	foreach est in ols re fe {
		foreach tam in n50t4 n200t6 n500t10 {

			gen sqerr_b1_`est'_`tam' = (b1_`est'_`tam' - `beta1')^2
			
			matrix TAB_E1B_B1[`r',1] = `beta1' // parametro real

			quietly summarize b1_`est'_`tam'
			matrix TAB_E1B_B1[`r',2] = r(mean) // mean
			matrix TAB_E1B_B1[`r',3] = r(sd)   // sd

			quietly summarize sqerr_b1_`est'_`tam'
			matrix TAB_E1B_B1[`r',4] = sqrt(r(mean)) //rmse

			local r = `r' + 1
		}
	}

	di as text "== E1B.7: beta1, media, SD Monte Carlo y RMSE =="
	matrix list TAB_E1B_B1, format(%12.4f)

	// Una vez lista la matriz, exporto
	preserve
		// Matriz al dataset y elijo filas relevantes
		svmat double TAB_E1B_B1, names(col)
		keep in 1/9

		// Igual que antes, elegir qué filas corresponden a que
		// estimador para label
		gen str8 estimator = ""
		replace estimator = "POLS" if inrange(_n, 1, 3)
		replace estimator = "RE"   if inrange(_n, 4, 6)
		replace estimator = "FE"   if inrange(_n, 7, 9)

		// Aquí parecido:
		// Los elementos 1,4,7 son con N=50
		//               2,5,8 son con N=200 (es el N de la parte A, ilustra mejor)
		//               3,6,9 son con N=500
		gen int N = cond(inlist(_n, 1, 4, 7), 50, ///
			cond(inlist(_n, 2, 5, 8), 200, 500))

		// Misma lógica para T={4,6,10}
		gen int T = cond(inlist(_n, 1, 4, 7), 4, ///
			cond(inlist(_n, 2, 5, 8), 6, 10))

		// Elijo columnas y ordeno
		keep estimator N T true_value mean sd rmse
		order estimator N T true_value mean sd rmse

		// Finalmente exporto en el formato del informe
		export delimited using "`outdir'/`run_prefix'__e1_B_b1.csv", replace
	restore

	// --------------------------------------------------
	// Tabla 1B.6: comparación FE
	// SE convencionales vs cluster por tamaño muestral
	// Acá sí se calculan b1 y b2
	// --------------------------------------------------

	// 6 filas, 6 columnas	
	matrix TAB_E1B_SE_FE = J(6,6,.)
	matrix rownames TAB_E1B_SE_FE = ///
		///            // b   N  T
		beta1_n50t4   /// b1  50 4, etcétera
		beta1_n200t6  ///
		beta1_n500t10 ///
		beta2_n50t4   /// 
		beta2_n200t6  ///
		beta2_n500t10

	// Repito las métricas del inciso E1.A3, con ratios informativos.
	matrix colnames TAB_E1B_SE_FE = ///
		MC_sd              /// SD de Monte Carlo
		mean_SE_conv       /// SE convencional
		mean_SE_cluster    /// SE cluster
		ratio_conv_MC      /// ratio conv/MC
		ratio_cluster_MC   /// ratio clus/MC
		ratio_conv_cluster  // ratio conv/cluster

	// Ingreso valores a la tabla iterando ...
	local r = 1
	// ... betas
	foreach b in 1 2 {
	    // ... y escenarios
		foreach tam in n50t4 n200t6 n500t10 {

			// Calculo como antes.
			quietly summarize b`b'_fe_`tam'
			local mc_sd = r(sd)

			quietly summarize se`b'_fe_conv_`tam'
			local se_conv = r(mean)

			quietly summarize se`b'_fe_rc_`tam'
			local se_cl = r(mean)

			matrix TAB_E1B_SE_FE[`r',1] = `mc_sd'
			matrix TAB_E1B_SE_FE[`r',2] = `se_conv'
			matrix TAB_E1B_SE_FE[`r',3] = `se_cl'
			matrix TAB_E1B_SE_FE[`r',4] = `se_conv' / `mc_sd'
			matrix TAB_E1B_SE_FE[`r',5] = `se_cl'   / `mc_sd'
			matrix TAB_E1B_SE_FE[`r',6] = `se_conv' / `se_cl'

			local r = `r' + 1
		}
	}

	di as text "== E1B.6: FE, comparación SE convencionales vs cluster =="
	matrix list TAB_E1B_SE_FE, format(%12.4f)

	// Una vez la matriz está organizada, exporto a CSV con 
	// el mismo patrón que antes
	preserve
		svmat double TAB_E1B_SE_FE, names(col)
		keep in 1/6
		
		// Labels apropiados
		gen str8 parameter = cond(_n <= 3, "beta1", "beta2")
		gen int N = cond(inlist(_n, 1, 4), 50, ///
			cond(inlist(_n, 2, 5), 200, 500))
		gen int T = cond(inlist(_n, 1, 4), 4, ///
			cond(inlist(_n, 2, 5), 6, 10))

		// Ordenamiento
		keep parameter N T MC_sd mean_SE_conv mean_SE_cluster ///
			ratio_conv_MC ratio_cluster_MC ratio_conv_cluster
		order parameter N T MC_sd mean_SE_conv mean_SE_cluster ///
			ratio_conv_MC ratio_cluster_MC ratio_conv_cluster

		// Exportación
		export delimited using "`outdir'/`run_prefix'__e1_B_se_fe.csv", replace
	restore

	// --------------------------------------------------
	// Diagnóstico opcional: medias crudas de SE
	// --------------------------------------------------

	di as text "== Diagnostico E1B: SE FE beta1 =="
	tabstat se1_fe_conv_n50t4 se1_fe_rc_n50t4 ///
			se1_fe_conv_n200t6 se1_fe_rc_n200t6 ///
			se1_fe_conv_n500t10 se1_fe_rc_n500t10, ///
			statistics(mean sd) columns(statistics) ///
			format(%12.4f) varwidth(22)

	di as text "== Diagnostico E1B: SE FE beta2 =="
	tabstat se2_fe_conv_n50t4 se2_fe_rc_n50t4 ///
			se2_fe_conv_n200t6 se2_fe_rc_n200t6 ///
			se2_fe_conv_n500t10 se2_fe_rc_n500t10, ///
			statistics(mean sd) columns(statistics) ///
			format(%12.4f) varwidth(22)
		
    //frame change E1B_DATA
}

// Me quedó faltando esto del E1B.6, así que reuso el .dta para no re-simular
if $RUN_E1_B6_FE_TABLE {

	local S = 2000
	// Agrego el número de simulaciones al prefijo, asi se cuantas hice
	local run_prefix = "`run_stamp'__S`S'"
	di as text "E1B.6 run_prefix: `run_prefix'"

    use "output/e1/2026-07-14_193747__S2000__e1_B_raw.dta", clear

	// Estructura de salida de la otra tabla que ya tenía
    matrix TAB_E1B_FE = J(6,4,.)
    matrix colnames TAB_E1B_FE = true_value mean sd rmse
    matrix rownames TAB_E1B_FE = ///
        beta1_n50t4   ///
        beta1_n200t6  ///
        beta1_n500t10 ///
        beta2_n50t4   ///
        beta2_n200t6  ///
        beta2_n500t10

    local r = 1

	// Loop para cada estimador
    foreach b in 1 2 {

        local true = cond(`b' == 1, 0.6, -0.4)

        foreach tam in n50t4 n200t6 n500t10 {

            quietly summarize b`b'_fe_`tam'

            matrix TAB_E1B_FE[`r',1] = `true'
            matrix TAB_E1B_FE[`r',2] = r(mean)
            matrix TAB_E1B_FE[`r',3] = r(sd)

            capture drop __sqerr
            generate double __sqerr = ///
                (b`b'_fe_`tam' - `true')^2

            quietly summarize __sqerr
            matrix TAB_E1B_FE[`r',4] = sqrt(r(mean))

            drop __sqerr
            local r = `r' + 1
        }
    }

    matrix list TAB_E1B_FE, format(%12.4f)

    preserve
		// Agrego columnas al dataset y preservo las relevantes
        svmat double TAB_E1B_FE, names(col)
        keep in 1/6

		// Agrego labels relevantes
        generate str8 parameter = ///
            cond(_n <= 3, "beta1", "beta2")

        generate int N = ///
            cond(inlist(_n,1,4), 50, ///
            cond(inlist(_n,2,5), 200, 500))

        generate int T = ///
            cond(inlist(_n,1,4), 4, ///
            cond(inlist(_n,2,5), 6, 10))

        keep parameter N T true_value mean sd rmse
        order parameter N T true_value mean sd rmse
		
		export delimited using "`outdir'/`run_prefix'__e1_B_fe_summary_from_raw.csv", replace

    restore
}
di as text "== EJERCICIO 1: fin =="
end
/******************************************************************************/

/*******************************************************************************
EJERCICIO 2 - Paneles Dinámicos - Sesgo de Nickell, Arellano–Bond y Blundell–Bond
*******************************************************************************/

capture program drop EJERCICIO_2
program define EJERCICIO_2
version 17
di as text "== EJERCICIO 2: inicio =="
if $RUN_E2 {
	
	// Frame aparte para arrancar de cero
	capture frame drop E2_DATA
	frame create E2_DATA
	frame change E2_DATA


	// Parametros que no cambian
	local beta = 1 // TO-DO consultar con Iara
	local sig_c = 1
	local sig_u = 1
	local sig_v = sqrt(0.9)

	// Valores iniciales DGP
	local xi_0 = 0 // TO-DO consultar con Iara
	local yi_0 = 0

	// ------------------------------------
	// Escribir a disco resultados de E1
	// ------------------------------------

	// Numero de simulaciones
	local S = 1000

	capture mkdir "output"
	capture mkdir "output/e2"

	local dnum = daily("`c(current_date)'", "DMY")
	local yyyy = string(year(`dnum'), "%04.0f")
	local mm   = string(month(`dnum'), "%02.0f")
	local dd   = string(day(`dnum'), "%02.0f")
	local hhmmss = subinstr("`c(current_time)'", ":", "", .)

	local run_stamp  = "`yyyy'-`mm'-`dd'_`hhmmss'"
	local run_prefix = "`run_stamp'__S`S'"
	local outdir     = "output/e2"

	di as text "E2 run_prefix: `run_prefix'"

	// ------------------------------------
	// Holder de resultados E2
	// ------------------------------------
	
	// Para este ejercicio uso postfiles en vez de matrices de almacenamiento.
	// La ventaja es que puedo usar `collapse' después para los estadísticos de forma sencilla y legible.

	// [e2_results] tiene una fila para cada combinación:
	//   escenario x simulacion x estimador
	tempfile e2_results
	postfile handle ///
		str1 scenario ///
		int rep ///
		str12 estimator ///
		double alpha0 N T alpha_hat se reject fail ///
		double hansen_p sargan_p n_inst ///
		using `e2_results', replace

	// [e2_b1_corr] almacena el correlograma empirico
	tempfile e2_b1_corr
	postfile handle_b1 ///
		str1 scenario ///     // el escenario (siempre es D pero queda más legible)
		int rep ///           // se registra una fila por simulacion 
		byte lag_depth ///    // la distancia en t del instrumento a \Delta y_{i.t-1} (para T=4 es {2,3})
		double corr ///       // la correlación entre el instrumento y el delta
		using `e2_b1_corr', replace
	
	// ------------------------------------
	// Timer / progreso Monte Carlo
	// ------------------------------------

	local n_scenarios = 4
	local total_jobs = `n_scenarios' * `S'
	local progress_every = 200

	local run_t0 = clock("`c(current_date)' `c(current_time)'", "DMYhms")

	di as text "E2 progreso: total jobs = " as result `total_jobs'
	di as text "E2 progreso: reportando cada " as result `progress_every' as text " jobs"

	// Loop de escenarios
	forvalues esce = 1/4 {
		
		// Empiezo cada escenario en el mismo seed
		set seed $THE_SEED

		// Setup de parámetros de acuerdo a escenario
		if (`esce' == 1) {
			local scenario = "A" // label legible para el postfile
			local alpha = 0.5
			local N = 30
			local T = 10
		}
		 else if (`esce' == 2) {
		 	local scenario = "B"
			local alpha = 0.5
			local N = 100
			local T = 10
		}
		else if (`esce' == 3) {
			local scenario = "C"
			local alpha = 0.8
			local N = 30
			local T = 7
		}
		else if (`esce' == 4) {
			local scenario = "D"
			local alpha = 0.92
			local N = 100
			local T = 4
		}

		// ------------------------------------
		// Loop de simulaciones intra-escenario
		// ------------------------------------

		forvalues simu = 1/`S' {
			// -------------
			// Panel setup
			// -------------
			
			// Limpio la data del panel anterior
			clear

			// Primero declaro el panel "full" para usar operadores built-in cómodos
			// Agregamos los periodos extra (los de burn-in que luego se remueven)
			local T_full = `T' + 10
			local T_full_plus1 = `T_full' + 1
			local NT_full = `N' * `T_full_plus1'
			
			qui set obs `NT_full'
			egen id     = seq(), f(1) t(`N') b(`T_full_plus1')
			egen t_full = seq(), f(0) t(`T_full')
			qui xtset id t_full

			// -------------------------
			// Creación de variables
			// -------------------------
			qui {
				// bysort hace operaciones por grupo
				// acá "entro" a un bloque con id fijo
				// _n es el item interno. genero el valor para el primer item del bloque

				bysort id: gen c_i = rnormal(0, `sig_c') if _n == 1
				// después, copio el mismo valor a todos los otros elems del bloque
				bysort id: replace c_i = c_i[1]

				// Errores. Dejo el primero missing para no confundirme
				gen u_i = .
				replace u_i = rnormal(0, `sig_u') if t_full >= 1

				gen v_i = .
				replace v_i = rnormal(0, `sig_v') if t_full >= 1

				// Genero las bases de los recursivos, con una idea similar
				gen x_i = .
				replace x_i = `xi_0' if t_full == 0
				gen y_i = .
				replace y_i = `yi_0' if t_full == 0

				// GPT me recomendó que asegurara el sort 
				sort id t_full
				xtset id t_full

				forvalues tt = 1/`T_full' { // acá sí itero a mano
					replace x_i = 0.8 * L.x_i + v_i if t_full == `tt'
					replace y_i = `alpha' * L.y_i + `beta' * x_i + c_i + u_i if t_full == `tt'
				}

				// Acá quito B=10 periodos y reindexo t ("burn in")
				keep if t_full > 10
				gen t = t_full - 10
				xtset id t

				// Queda todo listo para usar.

				// ========================================================
				// Estimadores
				// ========================================================

				// Para cada estimador implemento el test H0: a = a0 al 5%
				// a0 es el valor real del escenario.

				// El patrón es ver si fallan la regresión o el test
				// y en ese caso almacenar NA. En caso contrario, se 
				// almacenan los estimates y si se rechazó o no el test.

				// -------------------------
				// LSDV
				// -------------------------

				capture reg y_i L.y_i x_i i.id
				if _rc {
					post handle ("`scenario'") (`simu') ("LSDV") ///
						(`alpha') (`N') (`T') (.) (.) (.) (1) ///
						(.) (.) (.)
				}
				else {
					local alpha_hat = _b[L.y_i]
					local se_lsdv = _se[L.y_i]

					capture test L.y_i = `alpha'
					if _rc {
						local reject_H0 = .
					}
					else {
						local reject_H0 = (r(p) < 0.05)
					}

					post handle ("`scenario'") (`simu') ("LSDV") ///
						(`alpha') (`N') (`T') (`alpha_hat') (`se_lsdv') (`reject_H0') (0) ///
						(.) (.) (.)
				}

				// -------------------------
				// Anderson-Hsiao
				// -------------------------

				// Uso nombres un poco más legibles para las variables
				gen dy  = D.y_i
				gen ldy = L.D.y_i
				gen dx  = D.x_i
				gen l2y = L2.y_i

				// Se instrumenta D.y_{t-1} con y_{t-2}, el instrumento AH mínimo
				// Stata incluye el regresor estrictamente exógeno como su propio instrumento
				capture ivregress 2sls dy dx (ldy = l2y), nocons

				if _rc {
					post handle ("`scenario'") (`simu') ("AH") ///
						(`alpha') (`N') (`T') (.) (.) (.) (1) ///
						(.) (.) (.)
				}
				else {
					local alpha_hat = _b[ldy]
					local se_ah = _se[ldy]

					capture test ldy = `alpha'
					if _rc {
						local reject_H0 = .
					}
					else {
						local reject_H0 = (r(p) < 0.05)
					}

					post handle ("`scenario'") (`simu') ("AH") ///
						(`alpha') (`N') (`T') (`alpha_hat') (`se_ah') (`reject_H0') (0) ///
						(.) (.) (.)
				}

				// -------------------------
				// AB-GMM1
				// -------------------------

				// Con nolevel le decimos que no es BB (i.e. que no meta la ecuación en niveles al sistema)
				capture xtabond2 y_i L.y_i x_i, gmm(L.y_i) iv(x_i) nolevel

				if _rc {
					post handle ("`scenario'") (`simu') ("AB-GMM1") ///
						(`alpha') (`N') (`T') (.) (.) (.) (1) ///
						(.) (.) (.)
				}
				else {
					local alpha_hat = _b[L.y_i]
					local se_ab1 = _se[L.y_i]

					capture test L.y_i = `alpha'
					if _rc {
						local reject_H0 = .
					}
					else {
						local reject_H0 = (r(p) < 0.05)
					}

					post handle ("`scenario'") (`simu') ("AB-GMM1") ///
    					(`alpha') (`N') (`T') (`alpha_hat') (`se_ab1') (`reject_H0') (0) ///
    					(.) (.) (.)
				}

				// -------------------------
				// AB-GMM2
				// -------------------------

				// Básicamente lo mismo pero con twostep
				// Con corrección "robust" de SE para el segundo step (lo recomienda la doc de xtabond2)
				capture xtabond2 y_i L.y_i x_i, gmm(L.y_i) iv(x_i) nolevel twostep robust

				if _rc {
					post handle ("`scenario'") (`simu') ("AB-GMM2") ///
						(`alpha') (`N') (`T') (.) (.) (.) (1) ///
						(.) (.) (.)
				}
				else {
					local alpha_hat = _b[L.y_i]
					local se_ab2 = _se[L.y_i]

					capture test L.y_i = `alpha'
					if _rc {
						local reject_H0 = .
					}
					else {
						local reject_H0 = (r(p) < 0.05)
					}

					post handle ("`scenario'") (`simu') ("AB-GMM2") ///
						(`alpha') (`N') (`T') (`alpha_hat') (`se_ab2') (`reject_H0') (0) ///
						(.) (.) (.)
				}

				// -------------------------
				// BB-GMM1
				// -------------------------

				// System GMM. Al no usar nolevel, xtabond2 agrega la ecuación en niveles.
				capture xtabond2 y_i L.y_i x_i, gmm(L.y_i) iv(x_i)

				if _rc {
					post handle ("`scenario'") (`simu') ("BB-GMM1") ///
						(`alpha') (`N') (`T') (.) (.) (.) (1) ///
						(.) (.) (.)
				}
				else {
					local alpha_hat = _b[L.y_i]
					local se_bb1 = _se[L.y_i]

					capture test L.y_i = `alpha'
					if _rc {
						local reject_H0 = .
					}
					else {
						local reject_H0 = (r(p) < 0.05)
					}

					post handle ("`scenario'") (`simu') ("BB-GMM1") ///
						(`alpha') (`N') (`T') (`alpha_hat') (`se_bb1') (`reject_H0') (0) ///
						(.) (.) (.)
				}

				// -------------------------
				// BB-GMM2
				// -------------------------

				// Two-step System GMM. Al no usar nolevel, esto es BB y no AB.
				// También se aplica la corrección de two-step de la documentación.
				capture xtabond2 y_i L.y_i x_i, gmm(L.y_i) iv(x_i) twostep robust

				if _rc {
					post handle ("`scenario'") (`simu') ("BB-GMM2") ///
						(`alpha') (`N') (`T') (.) (.) (.) (1) ///
						(.) (.) (.)
				}
				else {
					local alpha_hat = _b[L.y_i]
					local se_bb2 = _se[L.y_i]

					capture test L.y_i = `alpha'
					if _rc {
						local reject_H0 = .
					}
					else {
						local reject_H0 = (r(p) < 0.05)
					}

					local hansen_p = .
					local sargan_p = .
					local n_inst   = .

					if "`scenario'" == "B" {
						capture local hansen_p = e(hansenp)
						capture local sargan_p = e(sarganp)
						capture local n_inst   = e(j)
					}

					post handle ("`scenario'") (`simu') ("BB-GMM2") ///
						(`alpha') (`N') (`T') (`alpha_hat') (`se_bb2') (`reject_H0') (0) ///
						(`hansen_p') (`sargan_p') (`n_inst')
				}

				// -------------------------
				// Kiviet / LSDVC
				// -------------------------

				// Uso el mismo setup de la práctica (A-H como base)
				capture xtlsdvc y_i x_i, initial(ah) bias(2)

				if _rc {
					post handle ("`scenario'") (`simu') ("Kiviet") ///
						(`alpha') (`N') (`T') (.) (.) (.) (1) ///
						(.) (.) (.)
				}
				else {
					// Calculo la matriz de varcov como en la práctica ...
					matrix blsdvc = e(b)
					scalar alpha_lsdvc = blsdvc[1,1]
					scalar beta_lsdvc  = blsdvc[1,2] // solo que hay que agregar otro param

					scalar NT_kiv = e(N) // renombrar vars para no colisionar
					scalar T_kiv  = e(Tbar)
					scalar N_kiv  = e(N_g)
					scalar K_kiv  = colsof(e(b))

					gen yL1_kiv = L.y_i

					egen bar_yi   = mean(y_i), by(id)
					egen bar_yL1i = mean(yL1_kiv), by(id)
					egen bar_xi   = mean(x_i), by(id) // agregar para el reg. exógeno

					gen with_y   = y_i     - bar_yi
					gen with_yL1 = yL1_kiv - bar_yL1i
					gen with_x   = x_i     - bar_xi  // acá también

					// Ajustar los errores para incluir x
					gen u_kiv = with_y - alpha_lsdvc * with_yL1 - beta_lsdvc * with_x

					// Los otros cálculos matriciales son idénticos
					matrix accum uTu = u_kiv, noconstant
					matrix sigma2u = (uTu) / (NT_kiv - N_kiv - T_kiv - K_kiv + 1)

					matrix accum ZTZ = with_yL1 with_x, noconstant
					matrix Var_lsdvc = sigma2u * inv(ZTZ)

					// Finalmente obtener el SE
					scalar se_lsdvc = sqrt(Var_lsdvc[1,1])

					// Por ultimo implemento el t-test a mano
					scalar tstat_kiv = (alpha_lsdvc - `alpha') / se_lsdvc
					scalar pval_kiv = 2 * ttail(NT_kiv - K_kiv, abs(tstat_kiv))
					local reject_H0 = (pval_kiv < 0.05)

					post handle ("`scenario'") (`simu') ("Kiviet") ///
						(`alpha') (`N') (`T') (alpha_lsdvc) (se_lsdvc) (`reject_H0') (0) ///
						(.) (.) (.)
				}

				// =====================================================
				// Cálculos auxiliares
				// =====================================================
				
				// ---------------------------------
				// Parte B.1: Correlograma empírico
				// ---------------------------------
				if "`scenario'" == "D" {

					// Creamos las variables
					capture drop dy_lag_b1 instr_l2_b1 instr_l3_b1

					// El delta endógeno a instrumentar (\Delta y_{i.t-1})
					gen dy_lag_b1   = L.y_i - L2.y_i
					// El instrumento a distancia 2
					gen instr_l2_b1 = L2.y_i
					// El instrumento a distancia 3
					gen instr_l3_b1 = L3.y_i

					// Vacío por defecto, si no hay error numérico almaceno corr.
					local corr_l2 = .
					local corr_l3 = .

					capture quietly corr dy_lag_b1 instr_l2_b1
					if !_rc {
						local corr_l2 = r(rho)
					}

					capture quietly corr dy_lag_b1 instr_l3_b1
					if !_rc {
						local corr_l3 = r(rho)
					}

					// Guardo resultado en postfile
					post handle_b1 ("`scenario'") (`simu') (2) (`corr_l2') // distancia 2
					post handle_b1 ("`scenario'") (`simu') (3) (`corr_l3') // distancia 3
				}

				// ------------------------------------
				// Progreso / ETA
				// ------------------------------------

				local job_done = (`esce' - 1) * `S' + `simu'

				if mod(`job_done', `progress_every') == 0 | `job_done' == 1 | `job_done' == `total_jobs' {

					local now = clock("`c(current_date)' `c(current_time)'", "DMYhms")

					local elapsed_sec = (`now' - `run_t0') / 1000
					local elapsed_min = `elapsed_sec' / 60

					local avg_sec_per_job = `elapsed_sec' / `job_done'

					local jobs_left = `total_jobs' - `job_done'
					local eta_sec = `avg_sec_per_job' * `jobs_left'
					local eta_min = `eta_sec' / 60

					local pct_done = 100 * `job_done' / `total_jobs'

					noisily di as text "E2 progress: " ///
						as result `job_done' "/" `total_jobs' ///
						as text " (" as result %5.1f `pct_done' as text "%)" ///
						as text " | scenario " as result "`scenario'" ///
						as text " | simu " as result `simu' "/" `S' ///
						as text " | elapsed " as result %6.1f `elapsed_min' as text " min" ///
						as text " | avg " as result %6.2f `avg_sec_per_job' as text " sec/job" ///
						as text " | ETA " as result %6.1f `eta_min' as text " min"
				}
			}
		}
	}

	// ------------------------------------
	// Cerramos los postfiles
	// ------------------------------------

	postclose handle
	postclose handle_b1

	// Acá exporto los resultados raw de Monte Carlo
	// TO-DO entender estas lineas
	use `e2_results', clear
	save "`outdir'/`run_prefix'__e2_raw.dta", replace
	di "----------------------------------------------"
	di as text "Monte Carlo terminó. Datos exportados."
	di "----------------------------------------------"

	// TO-DO esto quitarlo, dejarlo solo para debug GPT.
	count
	tab scenario estimator
	tab estimator fail

	// [Error numérico para cada estimador]
	preserve // Snapshot del dataset MC

		// Se colapsa a los estadísticos de interés 
		collapse ///
			(mean) fail_rate = fail /// 
			(count) reps_total = fail, ///
			by(scenario estimator) // una sola fila por combinación {escenario, estimador}

		// Despliegue y exportación
		sort scenario estimator
		di as text "== E2 diagnostico: fail rates =="
		list, sepby(scenario) noobs
		export delimited using "`outdir'/`run_prefix'__e2_raw_failrates.csv", replace
	
	restore


	//export delimited using "`outdir'/`run_prefix'__e2_raw_failrates.csv", replace

	

	// ------------------------------------
	// Parte A: tabla resumen
	// ------------------------------------

	preserve
		// La idea es que calculo cuántas filas fallaron numéricamente
		// para encontrar errores de implementación / confiabilidad.

		// El patrón es agregar . para filas faltantes (es ignorado en mean, etc)
		
		// Parámetro
		gen alpha_for_stats = alpha_hat
		replace alpha_for_stats = . if fail == 1

		// Rechazos de tests
		gen reject_for_stats = reject
		replace reject_for_stats = . if fail == 1

		// Útiles para los valores que se pide reportar/analizar en B4
		gen bias_i = alpha_for_stats - alpha0
		gen sqerr_alpha = bias_i^2

		collapse ///
			(mean) mean_alpha = alpha_for_stats ///
			(mean) bias       = bias_i ///
			(sd)   sd_alpha   = alpha_for_stats ///
			(mean) rmse_aux   = sqerr_alpha ///
			(mean) size_5     = reject_for_stats ///
			(mean) fail_rate  = fail ///
			(count) reps_valid = alpha_for_stats, ///
			by(scenario estimator alpha0 N T)

		gen rmse = sqrt(rmse_aux)
		drop rmse_aux

		sort scenario estimator

		// Exportar tabla de resumen
		di as text "== E2 Parte A: resumen Monte Carlo =="
		list scenario estimator alpha0 N T mean_alpha bias sd_alpha rmse size_5 fail_rate reps_valid, ///
			sepby(scenario) noobs

		export delimited using "`outdir'/`run_prefix'__e2_A.csv", replace

	restore

	// ------------------------------------
	// Parte B1: instrumentos debiles en D
	// ------------------------------------

	preserve

		use `e2_b1_corr', clear // Uso el tempfile de correlaciones

		collapse ///
			(mean) mean_corr = corr ///      // Saco mean
			(sd)   sd_corr   = corr ///      // SD
			(count) reps_valid = corr, ///   // y simulaciones sin error numérico
			by(scenario lag_depth)           // para D.s=2 y D.s=3 (con s: rezagos)

		sort scenario lag_depth

		di as text "== E2 Parte B1: correlaciones instrumentos AB en escenario D =="
		list scenario lag_depth mean_corr sd_corr reps_valid, noobs

		export delimited using "`outdir'/`run_prefix'__e2_B1.csv", replace

	restore

	// ---------------------------------------
	// Parte B2: Nickell para escenarios A y C
	// ---------------------------------------

	preserve

		use "`outdir'/`run_prefix'__e2_raw.dta", clear // Uso el tempfile de MonteCarlo

		// Preservo solo LSDV para los escenarios de la consigna
		keep if estimator == "LSDV"
		keep if scenario == "A" | scenario == "C"
		// Remuevo los que fallaron numericamente
		keep if fail == 0

		// Cálculo del sesgo empírico (vs el parámetro del DGP)
		gen bias_i = alpha_hat - alpha0
		// Cálculo vs la fórmula de la consigna
		gen nickell_approx = -(1 + alpha0) / (T - 1)

		// Promedios entre simulaciones ...
		collapse ///
			(mean) mean_alpha = alpha_hat ///
			(mean) lsdv_bias_sim = bias_i ///                // sesgo empirico
			(first) alpha0 = alpha0 ///
			(first) T = T ///
			(first) nickell_approx = nickell_approx ///      // formula consigna
			(count) reps_valid = alpha_hat, ///              // si error numerico en LSDV no hay alpha (conteo de cuantas fueron válidas)
			  by(scenario)  // ... para cada escenario por separado

		gen diff_sim_vs_approx = lsdv_bias_sim - nickell_approx // empirico - consigna

		sort scenario

		di as text "== E2 Parte B2: Nickell analitico vs simulado =="
		list scenario alpha0 T mean_alpha lsdv_bias_sim nickell_approx diff_sim_vs_approx reps_valid, noobs

		export delimited using "`outdir'/`run_prefix'__e2_B2.csv", replace

	restore
		
	// ------------------------------------
	// Parte B3: Sargan Hansen para BB GMM2 en B
	// ------------------------------------

	preserve

		use "`outdir'/`run_prefix'__e2_raw.dta", clear // Uso el tempfile de MC

		// Me quedo solo con el escenario B + BB-GMM2 + sin errores numéricos
		keep if scenario == "B"
		keep if estimator == "BB-GMM2"
		keep if fail == 0

		// Booleanos: 1 si p < 0.05 para cada test por separado
		gen reject_hansen = hansen_p < 0.05 if !missing(hansen_p)
		gen reject_sargan = sargan_p < 0.05 if !missing(sargan_p)

		// Cálculo de tamaño empírico
		// También extras como:
		// - cantidad de estimaciones sin errores numericos para
		//     parámetro, test de hansen, test de sargan   
		//     esto sirve para evitar errores como en E1 donde 
		///    inicialmente calculaba "tamaño" sobre muchísimos missing.

		collapse ///
			(mean) hansen_size_5 = reject_hansen ///
			(mean) sargan_size_5 = reject_sargan ///
			(mean) mean_hansen_p = hansen_p ///
			(mean) mean_sargan_p = sargan_p ///
			(mean) mean_ninst    = n_inst ///
			(count) reps_valid   = alpha_hat ///
			(count) reps_hansen_valid = hansen_p ///
			(count) reps_sargan_valid = sargan_p, ///
			by(scenario estimator)

		di as text "== E2 Parte B3: Sargan Hansen BB-GMM2 escenario B =="
		list, noobs

		export delimited using "`outdir'/`run_prefix'__e2_B3.csv", replace

	restore
	
}
di as text "== EJERCICIO 2: fin =="
end



/*******************************************************************************
EJERCICIO 3 - Modelos de Respuesta Binaria con Efectos No Observables y Selección Muestral
*******************************************************************************/

capture program drop EJERCICIO_3
program define EJERCICIO_3
version 17
di as text "== EJERCICIO 3: inicio =="
if $RUN_E3 {

	// Seteo mi seed para reproducibilidad
	set seed $THE_SEED

	// Defino las constantes de tamaño
	local S  = 500  // 500 simulaciones
	local NL = 300  // 300 individuos
	local T  = 6    // observados por 6 periodos
	local ncells = `NL' * `T' // observaciones t x i posibles (sin attrition)

	// Parámetros del modelo Probit
	local psi = -0.5
	local del =  0.8
	local rho =  0.4
	local xi  =  0.3
	local xi0 =  0.5
	
	// Parámetros del mecanismo de attrition
	local g0  =  1.2
	local g1  =  0.6
	local g2  = -0.3

	// Correlación para el escenario de contraste (Punto E.7)
	local kap  = 0.7  // Corr(e_jt, omega_jt) = 0.7

	// ------------------------------------
	// Manejo de datos y archivos de salida
	// ------------------------------------

	// Creo los directorios si no existen
	capture mkdir "output"
	capture mkdir "output/e3"
	
	// Genero un timestamp como en E2
	local dnum = daily("`c(current_date)'", "DMY")
	local yyyy = string(year(`dnum'), "%04.0f")
	local mm   = string(month(`dnum'), "%02.0f")
	local dd   = string(day(`dnum'), "%02.0f")
	local hhmmss = subinstr("`c(current_time)'", ":", "", .)

	local run_stamp  = "`yyyy'-`mm'-`dd'_`hhmmss'"
	local run_prefix = "`run_stamp'__S`S'"
	local outdir     = "output/e3"

	di as text "E3 run_prefix: `run_prefix'"

	// Handle para usar postfile para los resultados de cada loop
	tempname e3h
	tempfile e3raw

	// rep: simulación actual de MonteCarlo

	// ESCENARIOS
	// full: sin attrition, se usan todas las observaciones
	// base: selección ignorable
	//       attrition + (shocks de seleccion ⟂ shocks de outcome) 
	//       Corr(ejt​,ωjt​)=0.
	// mnar: selección no ignorable
	//       attrition + (shocks de seleccion corr shocks de outcome)
	//       Corr(ejt​,ωjt​)=0.7.
	//       "mnar": missing not at random
	//          La permanencia depende de un shock (ωjt)
	//          correlacionado con el shock no observado del outcome (ejt)
	//          Por eso la seleccion no es ignorable y esperamos sesgo.

	// ESTIMADORES
	// E3.5: WRE_full: WRE sobre muestra completa
	// E3.6: WRE_attr: WRE sobre muestra con attrition para base y MNAR
	// E3.7: TO-DO: phat_literal
	// E3.8: TO-DO: RB_literal

	postfile `e3h' ///
    	str12 scenario ///                  escenario
    	str24 estimator ///                 estimador
    	int rep ///                         repeticion
    	double delta_hat rho_hat xi_hat /// parametros
    	double obs_share ///                que masa quedó post attrition \in [0,1]
        byte fail ///                       falló la estimación numérica?
    	using `e3raw', replace

	// Setup del panel
	clear
	local Tfull = `T' + 1      // hay que tener un periodo 0 para la condición inicial
	set obs `=`NL' * `Tfull''
	egen id   = seq(), block(`Tfull')
	egen time = seq(), from(0) to(`T')
	xtset id time

	// =====================================================
	// Bucle principal de Monte Carlo
	// =====================================================

	forvalues rep = 1/`S' {
		// -------------------------------
		// 1. Implementación del DGP
		// -------------------------------
		qui {
			// Borro las variables de la iteracion anterior
			cap drop y0 a_i w_i z zbar eta_e eta_w e omega_* ///
			y stay_* obs_*
			
			// Aseguro el orden del panel para las operaciones que siguen
			sort id time

			// Probit: Condición inicial. Como runiform genera un # entre 0 y 1
			// La probabilidad (runiform() < 0.4) da 1 con probabilidad 0.4
			// Esencialmente la bernoulli(0.4) pedida.
			by id: gen byte y0 = (runiform() < 0.4) if _n == 1
			// Se copia y0 para todos los T del mismo i
			by id: replace y0 = y0[1]

			// Probit: Residuo del error individual ci. Acá el mismo patrón pero con N(0,1),
			// cada i tiene el mismo error idiosincrático ai.
			by id: gen double a_i = rnormal(0,1) if _n == 1
			by id: replace a_i = a_i[1]

			// Selección: efecto individual. Mismo mecanismo: un valor a nivel i.
			by id: gen double w_i = rnormal(0,sqrt(0.5)) if _n == 1
			by id: replace w_i = w_i[1]

			// Probit: Regresor z_j ~ N(0,1). Solo para el rango t=1 a t=T
			// No hay lectura en t=0.
			gen double z = rnormal(0,1) if inrange(time,1,`T')

			// Probit: Promedio de Mundlak, Zj = \bar{z_j}
			// Se hace pre-attrition porque así después no se observen, ci las contiene
			by id: egen double zbar = mean(z)

			// ------------------------------------------------------------------
			// Shocks comunes para los escenarios base y mnar
			// Aquí la idea es generar dos shocks independientes (eta_e ⟂ eta_w)
			// ------------------------------------------------------------------
			
			// El shock e_jt del outcome (y_jt) es siempre e_jt = eta_e
			// El shock ω_jt de selección sí lo cambio de acuerdo al escenario:
			//   En el escenario attrition ignorable ("base") tengo
			//      w_jt base = eta_w 
			//        => Corr(ejt​,ωjt​)=0 porque son independientes.
			//   En el escenario attrion no ignorable ("mnar") tengo
			//      w_jt mnar = 0.7 eta_e + sqrt(1-0.7^2) eta_w
			//        => Corr(ejt​,ωjt​)=0.7 y además Var(ωjt​)=1.

			// La idea detrás de esto es compartir los mismos shocks aleatorios entre
			// ambos escenarios: si cambian los resultados entre base y mnar, sabemos que la
			// causa principal es la correlación introducida, no una muestra rara u outliers.

			// Se generan los shocks N(0,1) para cada t excepto t=0
			gen double eta_e = rnormal(0,1) if inrange(time,1,`T')
			gen double eta_w = rnormal(0,1) if inrange(time,1,`T')

			// Se sigue la especificación explicada anteriormente
			gen double e = eta_e
			gen double omega_base = eta_w
			gen double omega_mnar = ///
				`kap' * eta_e + sqrt(1 - `kap'^2) * eta_w

			// ---------------------------------------------------
			// y_jt y mecanismo de attrition absorbente
			// ---------------------------------------------------
			// Asegurar orden //TO-DO revisar si se puede quitar
			sort id time

			// Iniciamos desde la condición inicial ya generada
			gen byte y = y0 if time == 0

			// Probit: Binaria y_jt. Se itera t=1 a t=6 usando la especificación
			forvalues tt = 1/`T' {
				replace y = ( ///
					(`psi' + `del' * z  + `rho' * L.y + `xi0' * y0  + `xi'  * zbar + a_i + e ) > 0  ///
				) if time == `tt'
			}

			// Selección: Binaria s_jt / obs_t para los escenarios 'base' y 'mnar'
			// Ponemos la etiqueta de escenario a cada variable 
			foreach sc in base mnar {

				// En t=1 todos los i son observados
				gen byte stay_`sc' = 1 if time == 1

				// Desde t=2 hasta t=6 se toma una decision de permanencia usando la especificación
				replace stay_`sc' = ( ///
					( `g0' + `g1' * L.y + `g2' * z + w_i + omega_`sc' ) > 0 ///
				) if inrange(time,2,`T')

				// ------------------------------------------------------
				// Attrition absorbente: una vez afuera, no se reingresa
				// ------------------------------------------------------

				// Aquí la idea es que s_jt va a seguir generando 1 o 0 de acuerdo al shock en cada t
				// - La variable obs(t) se vuelve 0 la primera vez que s_jt lo hace
				// - La variable obs(t-1) siempre multiplica s_jt
				// Entonces una vez que obs_* es cero, así s_jt se mueva ya no reaparece el individuo i
				// obs(t) es la que usamos efectivamente para determinar si la persona está o no en un t

				// En el primer periodo sabemos que está
				gen byte obs_`sc' = 1 if time == 1
				// Desde t=2 ponderamos s_jt por obs(t-1) para no reingresarla
				forvalues tt = 2/`T' {
					replace obs_`sc' = L.obs_`sc' * stay_`sc' if time == `tt'
				}

			}

		}

		// ---------------------------------------------
		// 2. Estimadores y almacenamiento
		// ---------------------------------------------
		qui {

			// ====================================================
			// 2.1 - Inciso 5: Wooldridge RE sobre muestra completa
			// ====================================================

			// ----------------------------------------------------
			// Wooldridge RE sobre muestra completa
			// ----------------------------------------------------
			// Se excluye el t=0
			capture quietly xtprobit y L.y z y0 zbar if inrange(time,1,`T'), re

			// Almaceno en f si hubo fail en xtprobit (full).
			local fail_full = (_rc != 0)

			// Si corrió, veo convergencia y que estén los parámetros
			if !`fail_full' {
				// Si alguna de estas falla marcamos fail
				local fail_full = ///
					(e(converged) != 1) | ///
					missing( ///
						_b[z], ///
						_b[L.y], ///
						_b[y0], ///
						_b[zbar], ///
						_b[_cons], ///
						e(sigma_u) ///
					)
			}

			// Si la estimación es válida, almaceno
			if !`fail_full' {

				// Parámetros que sí se guardan en el Monte Carlo
				local delta_full = _b[z]
				local rho_full   = _b[L.y]
				local xi_full    = _b[zbar]

				// Solo se necesitan para el diagnóstico de la primera réplica
				if `rep' == 1 {
					local xi0_full  = _b[y0]
					local psi_full  = _b[_cons]
					local sigu_full = e(sigma_u)
				}

				// Fila de éxito
				post `e3h' ///
					("full") ///
					("WRE_full") ///
					(`rep') ///
					(`delta_full') ///
					(`rho_full') ///
					(`xi_full') ///
					(1) /// obs_share 100% para full
					(0)
			}
			else {
				// Si hubo error o no convergió, guardo una fila de fallo
				post `e3h' ///
					("full") ("WRE_full") (`rep') (.) (.) (.) (1) (1)
			}

			// ====================================================
			// 2.2 - Inciso 6: Wooldridge RE con attrition
			// ====================================================

			// Bucle para los dos escenarios:
			// base con Corr(e_jt, omega_jt) = 0
			// mnar con Corr(e_jt, omega_jt) = 0.7
			// sc almacena el string de escenario :)
			foreach sc in base mnar {

				// En obs_* se cuenta qué porcentaje de filas del total
				// quedan observadas en el panel entre t=1 y t=T.
				// Algo así como ¿qué tanto % del panel quedó post-attrition en total?

				// Es un promedio excluyendo t=0, como son 0 o 1 queda la share de 1s.
				quietly summarize obs_`sc' if inrange(time,1,`T'), meanonly
				local obs_share_attr = r(mean)
				local obs_share_`sc' = `obs_share_attr'

				// Mismo estimador WRE Probit, restringido a la muestra observada
				// Lo que cambia es el selector obs_* que generamos en el DGP anteriormente
				// Solo una parte del panel entra al estimador
				capture quietly xtprobit ///
					y L.y z y0 zbar if inrange(time,1,`T') & obs_`sc' == 1, re

				// Misma lógica de antes: si corrió, reviso convergencia y parámetros
				local fail_attr = (_rc != 0)
				if !`fail_attr' {
					// Si alguna lectura falla marcamos error
					local fail_attr = ///
						(e(converged) != 1) | ///
						missing( ///
							_b[z], ///
							_b[L.y], ///
							_b[y0], ///
							_b[zbar], ///
							_b[_cons], ///
							e(sigma_u) ///
						)
				}

				// Acá algo adicional: guardo el indicador con nombre de escenario
				local fail_`sc' = `fail_attr'

				// Si todo está bien
				if !`fail_attr' {

					// Estos van directos a ser posteados
					local delta_attr = _b[z]
					local rho_attr   = _b[L.y]
					local xi_attr    = _b[zbar]

					// Guardo copia con prefijo para debug
					local delta_`sc' = `delta_attr'
					local rho_`sc'   = `rho_attr'
					local xi_`sc'    = `xi_attr'

					// Fila de éxito
					post `e3h' ///
						("`sc'") ///
						("WRE_attr") ///
						(`rep') ///
						(`delta_attr') ///
						(`rho_attr') ///
						(`xi_attr') ///
						(`obs_share_attr') ///
						(0)
				}
				else {
					// Fila de fallo
					post `e3h' ///
						("`sc'") ("WRE_attr") (`rep') (.) (.) (.) (`obs_share_attr') (1)
				}
			}
		}


		// =================================================
		// 3. Diagnósticos: solo primera réplica
		// =================================================

		if `rep' == 1 {

			// -------------------------------------------------
			// 3.1 Estructura del panel
			// -------------------------------------------------

			assert _N == `NL' * `Tfull'
			assert inrange(id,1,`NL')
			assert inrange(time,0,`T')
			isid id time
			bysort id: assert _N == `Tfull'

			// -------------------------------------------------
			// 3.2 Variables individuales y shocks
			// -------------------------------------------------

			bysort id: assert y0   == y0[1]
			bysort id: assert a_i  == a_i[1]
			bysort id: assert w_i  == w_i[1]
			bysort id: assert zbar == zbar[1]

			assert missing(z)          if time == 0
			assert missing(e)          if time == 0
			assert missing(omega_base) if time == 0
			assert missing(omega_mnar) if time == 0

			summarize y0 a_i w_i z zbar e omega_base omega_mnar

			list id time y0 a_i w_i z zbar e omega_base omega_mnar ///
				if id <= 3, sepby(id)

			corr e omega_base omega_mnar ///
				if inrange(time,1,`T')

			// -------------------------------------------------
			// 3.3 Outcome y attrition
			// -------------------------------------------------

			assert y == y0 if time == 0
			assert inlist(y,0,1) if inrange(time,0,`T')

			assert stay_base == 1 if time == 1
			assert stay_mnar == 1 if time == 1
			assert obs_base  == 1 if time == 1
			assert obs_mnar  == 1 if time == 1

			// Attrition absorbente: obs nunca pasa de 0 a 1
			bysort id (time): assert ///
				obs_base <= obs_base[_n-1] ///
				if inrange(time,2,`T')

			bysort id (time): assert ///
				obs_mnar <= obs_mnar[_n-1] ///
				if inrange(time,2,`T')

			summarize obs_base obs_mnar ///
				if inrange(time,1,`T')

			tabstat obs_base obs_mnar ///
				if inrange(time,1,`T'), ///
				by(time) statistics(mean count)

			list id time y0 z zbar y ///
				stay_base obs_base stay_mnar obs_mnar ///
				if id <= 5, sepby(id)

			// -------------------------------------------------
			// 3.4 Estimador WRE_full
			// -------------------------------------------------

			display as text "== E3: WRE_full, réplica 1 =="

			if !`fail_full' {

				display as result ///
					"delta_hat = " %9.4f `delta_full'

				display as result ///
					"rho_hat   = " %9.4f `rho_full'

				display as result ///
					"xi0_hat   = " %9.4f `xi0_full'

				display as result ///
					"xi_hat    = " %9.4f `xi_full'

				display as result ///
					"psi_hat   = " %9.4f `psi_full'

				display as result ///
					"sigma_u   = " %9.4f `sigu_full'

				display as result ///
					"N celdas  = " %9.0f `ncells'
			}
			else {
				display as error ///
					"WRE_full falló en la réplica 1."
			}

			// -------------------------------------------------
			// 3.5 Estimador WRE_attr
			// -------------------------------------------------

			display as text ///
				"== E3: WRE_attr base, réplica 1 =="

			if !`fail_base' {
				display as result ///
					"delta_hat = " %9.4f `delta_base'

				display as result ///
					"rho_hat   = " %9.4f `rho_base'

				display as result ///
					"xi_hat    = " %9.4f `xi_base'

				display as result ///
					"obs_share = " %9.4f `obs_share_base'
			}
			else {
				display as error ///
					"WRE_attr base falló en la réplica 1."
			}

			display as text ///
				"== E3: WRE_attr MNAR, réplica 1 =="

			if !`fail_mnar' {
				display as result ///
					"delta_hat = " %9.4f `delta_mnar'

				display as result ///
					"rho_hat   = " %9.4f `rho_mnar'

				display as result ///
					"xi_hat    = " %9.4f `xi_mnar'

				display as result ///
					"obs_share = " %9.4f `obs_share_mnar'
			}
			else {
				display as error ///
					"WRE_attr MNAR falló en la réplica 1."
			}
		}

	} // Fin del loop Monte Carlo

	postclose `e3h'

	// --------------------------------------
	// Guardado de  resultados de MC
	// --------------------------------------
	use `e3raw', clear
	save "`outdir'/`run_prefix'__e3_raw.dta", replace

	di "----------------------------------------------"
	di as text "E3 Monte Carlo terminó. Raw exportado."
	di as text "`outdir'/`run_prefix'__e3_raw.dta"
	di "----------------------------------------------"

	// ------------------------------------
	// Diagnóstico de fallos numéricos
	// ------------------------------------

	preserve

		// Con base a la columna fail podemos ver
		collapse ///
			(mean) fail_rate = fail ///       cuantos fallaron
			(count) reps_total = fail, ///    del total
			by(scenario estimator)     //     para cada escenario x estimador

		sort scenario estimator

		di as text "== E3 diagnóstico: fail rates =="

		list, noobs

		// Exporto el CSV
		export delimited using "`outdir'/`run_prefix'__e3_raw_failrates.csv", replace

	restore

	// =================================================
	// 4. Tablas de resultados
	// =================================================

	use `e3raw', clear

	// -------------------------------------------------
	// 4.1 Inciso 5: WRE sobre muestra completa
	// -------------------------------------------------

	preserve

		// Elijo del dataset solo las estimaciones válidas del inciso 5
		keep if scenario == "full"
		keep if estimator == "WRE_full"
		keep if fail == 0

		// Errores cuadráticos contra los valores verdaderos
		gen double sqerr_delta = (delta_hat - `del')^2
		gen double sqerr_rho   = (rho_hat   - `rho')^2
		gen double sqerr_xi    = (xi_hat    - `xi')^2

		// Media, desvío estándar y MSE
		collapse ///
			(mean) ///
				mean_delta = delta_hat ///
				mean_rho   = rho_hat ///
				mean_xi    = xi_hat ///
				mse_delta  = sqerr_delta ///
				mse_rho    = sqerr_rho ///
				mse_xi     = sqerr_xi ///
			(sd) ///
				sd_delta = delta_hat ///
				sd_rho   = rho_hat ///
				sd_xi    = xi_hat, ///
			by(scenario)

		// RMSE = raíz del MSE
		gen double rmse_delta = sqrt(mse_delta)
		gen double rmse_rho   = sqrt(mse_rho)
		gen double rmse_xi    = sqrt(mse_xi)

		// Quito las variables temporales
		drop mse_delta mse_rho mse_xi

		// Ordeno y formateo para display final
		order ///
			scenario ///
			mean_delta sd_delta rmse_delta ///
			mean_rho   sd_rho   rmse_rho ///
			mean_xi    sd_xi    rmse_xi

		format mean_* sd_* rmse_* %9.4f

		di as text ///
			"== E3 Inciso 5: WRE muestra completa =="

		list, noobs

		// Exporto los datos de E3.5 a CSV
		export delimited using "`outdir'/`run_prefix'__e3_5.csv", replace

	restore


	// -------------------------------------------------
	// 4.2 Inciso 6: comparación con attrition
	// -------------------------------------------------

	preserve

		// Dejo full para comparar con el inciso anterior
		// y permito también los dos escenarios de attrition
		keep if ///
			(scenario == "full" & estimator == "WRE_full") | ///
			(inlist(scenario, "base", "mnar") & ///
			 estimator == "WRE_attr")

		// Elimino las filas fallidas
		keep if fail == 0

		// Esto es la misma estructura que la tabla anterior
		gen double sqerr_delta = (delta_hat - `del')^2
		gen double sqerr_rho   = (rho_hat   - `rho')^2
		gen double sqerr_xi    = (xi_hat    - `xi')^2

		// Mismos estadísticos...
		collapse ///
			(mean) ///
				mean_delta = delta_hat ///
				mean_rho   = rho_hat ///
				mean_xi    = xi_hat ///
				mse_delta  = sqerr_delta ///
				mse_rho    = sqerr_rho ///
				mse_xi     = sqerr_xi ///
			(sd) ///
				sd_delta = delta_hat ///
				sd_rho   = rho_hat ///
				sd_xi    = xi_hat, ///
			by(scenario) //... ahora por escenario

		// RMSE = raíz del MSE
		gen double rmse_delta = sqrt(mse_delta)
		gen double rmse_rho   = sqrt(mse_rho)
		gen double rmse_xi    = sqrt(mse_xi)

		drop mse_delta mse_rho mse_xi

		// Orden de comparación: full, base, MNAR
		// Esto es un switch más fancy: si full, 1. Si base, 2. Si no, 3.
		gen byte scenario_order = ///
			cond(scenario == "full", 1, ///
			cond(scenario == "base", 2, 3))

		sort scenario_order
		drop scenario_order

		// Igual que en el bloque anterior.

		order ///
			scenario ///
			mean_delta sd_delta rmse_delta ///
			mean_rho   sd_rho   rmse_rho ///
			mean_xi    sd_xi    rmse_xi

		format mean_* sd_* rmse_* %9.4f

		di as text ///
			"== E3 Inciso 6: comparación con attrition =="

		list, noobs

		// Exporto los datos de E3.6 a CSV
		export delimited using "`outdir'/`run_prefix'__e3_6.csv", replace

	restore

}
di as text "== EJERCICIO 3: fin =="
end


/*******************************************************************************
EJERCICIO 3.7 - Test de attrition
*******************************************************************************/

capture program drop EJERCICIO_3_7
program define EJERCICIO_3_7
version 17
di as text "== EJERCICIO 3.7: inicio =="

if $RUN_E3_7 {

	// Desde aquí hasta donde está marcado es una copia literal del DGP
	// del Ejercicio 3 base. No se comenta por brevedad.

	set seed $THE_SEED

	local S  = 500 
	local NL = 300
	local T  = 6
	local ncells = `NL' * `T'

	// Parámetros del modelo Probit
	local psi = -0.5
	local del =  0.8
	local rho =  0.4
	local xi  =  0.3
	local xi0 =  0.5
	
	// Parámetros del mecanismo de attrition
	local g0  =  1.2
	local g1  =  0.6
	local g2  = -0.3

	local kap  = 0.7  // Corr(e_jt, omega_jt) = 0.7

	// ------------------------------------
	// Manejo de datos y archivos de salida
	// ------------------------------------

	capture mkdir "output"
	capture mkdir "output/e3"
	
	local dnum = daily("`c(current_date)'", "DMY")
	local yyyy = string(year(`dnum'), "%04.0f")
	local mm   = string(month(`dnum'), "%02.0f")
	local dd   = string(day(`dnum'), "%02.0f")
	local hhmmss = subinstr("`c(current_time)'", ":", "", .)

	local run_stamp  = "`yyyy'-`mm'-`dd'_`hhmmss'"
	local run_prefix = "`run_stamp'__S`S'"
	local outdir     = "output/e3"

	di as text "E3.7 run_prefix: `run_prefix'"

	// Handle para usar postfile para los resultados de cada loop
	tempname e3h
	tempfile e3raw

	// [Acá difiere el código de E3]

	postfile `e3h' ///
		str12 scenario ///
		str12 specification ///
		int rep ///
		double delta_hat rho_hat xi_hat ///
		double phat_coef phat_p ///
		byte reject5 ///
		double obs_share ///
		int n_stage1 n_stage2 ///
		byte fail_stage1 fail_stage2 fail ///
		using `e3raw', replace

	// [Fin diferencia]
	
	clear
	local Tfull = `T' + 1
	set obs `=`NL' * `Tfull''
	egen id   = seq(), block(`Tfull')
	egen time = seq(), from(0) to(`T')
	xtset id time

	forvalues rep = 1/`S' {

		if `rep' == 1 | mod(`rep',10) == 0 | `rep' == `S' {
			display as text "E3.7: réplica `rep' de `S' — `c(current_time)'"
		}

		qui {
			cap drop y0 a_i w_i z zbar eta_e eta_w e omega_* ///
    			y stay_* obs_*
			cap drop phat_*
	
			sort id time

			by id: gen byte y0 = (runiform() < 0.4) if _n == 1
			by id: replace y0 = y0[1]
			by id: gen double a_i = rnormal(0,1) if _n == 1
			by id: replace a_i = a_i[1]
			by id: gen double w_i = rnormal(0,sqrt(0.5)) if _n == 1
			by id: replace w_i = w_i[1]
			gen double z = rnormal(0,1) if inrange(time,1,`T')
			by id: egen double zbar = mean(z)

			gen double eta_e = rnormal(0,1) if inrange(time,1,`T')
			gen double eta_w = rnormal(0,1) if inrange(time,1,`T')

			gen double e = eta_e
			gen double omega_base = eta_w
			gen double omega_mnar = ///
				`kap' * eta_e + sqrt(1 - `kap'^2) * eta_w

			sort id time
			gen byte y = y0 if time == 0
			forvalues tt = 1/`T' {
				replace y = ( ///
					(`psi' + `del' * z  + `rho' * L.y + `xi0' * y0  + `xi'  * zbar + a_i + e ) > 0  ///
				) if time == `tt'
			}

			foreach sc in base mnar {

				gen byte stay_`sc' = 1 if time == 1
				replace stay_`sc' = ( ///
					( `g0' + `g1' * L.y + `g2' * z + w_i + omega_`sc' ) > 0 ///
				) if inrange(time,2,`T')

				gen byte obs_`sc' = 1 if time == 1
				forvalues tt = 2/`T' {
					replace obs_`sc' = L.obs_`sc' * stay_`sc' if time == `tt'
				}

			}

		}

		// Acá finaliza la copia verbatim del E3

		// =====================================================
		// NUEVO E3.7 - ESTIMACIÓN Y TEST
		// =====================================================

		foreach sc in base mnar {

			quietly summarize obs_`sc' if inrange(time,1,`T'), meanonly
			local obs_share = r(mean)

			gen byte obs_next_`sc' = F.obs_`sc'

			foreach spec in timing {

				// Especificaciones alternativas de la primera etapa
				if "`spec'" == "literal" {
					local selection_rhs "y z y0 zbar"
				}
				else if "`spec'" == "timing" {
					local selection_rhs "y F.z y0 zbar"
				}

				local fail_stage1 = 0
				local fail_stage2 = 0
				local fail        = 0

				local delta_hat = .
				local rho_hat   = .
				local xi_hat    = .
				local phat_coef = .
				local phat_p    = .
				local reject5   = .
				local n_stage1  = .
				local n_stage2  = .

				// Primera etapa
				capture quietly probit obs_next_`sc' `selection_rhs' ///
					if obs_`sc' == 1 & time < `T'

				local fail_stage1 = (_rc != 0)

				if !`fail_stage1' {
					local fail_stage1 = (e(converged) != 1)
					local n_stage1 = e(N)
				}

				if !`fail_stage1' {
					capture predict double phat_`sc'_`spec' if e(sample), pr
					local fail_stage1 = (_rc != 0)
				}

				// Segunda etapa
				if !`fail_stage1' {
					capture quietly xtprobit ///
						y L.y z y0 zbar phat_`sc'_`spec' ///
						if obs_`sc' == 1, re intpoints(8)

					local fail_stage2 = (_rc != 0)

					if !`fail_stage2' {
						local fail_stage2 = (e(converged) != 1)
						local n_stage2 = e(N)
					}
				}

				if !`fail_stage1' & !`fail_stage2' {
					local delta_hat = _b[z]
					local rho_hat   = _b[L.y]
					local xi_hat    = _b[zbar]
					local phat_coef = _b[phat_`sc'_`spec']

					capture quietly test phat_`sc'_`spec' = 0
					local fail_stage2 = (_rc != 0)

					if !`fail_stage2' {
						local phat_p  = r(p)
						local reject5 = (`phat_p' < 0.05)
					}
				}

				local fail = (`fail_stage1' | `fail_stage2')

				post `e3h' ///
					("`sc'") ("`spec'") (`rep') ///
					(`delta_hat') (`rho_hat') (`xi_hat') ///
					(`phat_coef') (`phat_p') (`reject5') ///
					(`obs_share') ///
					(`n_stage1') (`n_stage2') ///
					(`fail_stage1') (`fail_stage2') (`fail')
			}
		}

		// =================================================
		// NUEVO E3.7 - DIAGNÓSTICOS DE LA PRIMERA RÉPLICA
		// =================================================

		if `rep' == 1 {

			// Revisar acá, para cada escenario:
			//
			// - distribución de la permanencia futura
			// - número de observaciones de primera etapa
			// - distribución de la probabilidad estimada
			// - resultados de primera etapa
			// - resultados del modelo aumentado de Wooldridge
			// - resultado del test
			// - fallos de convergencia o separación

		}

	} // Fin del loop Monte Carlo

	postclose `e3h'

	// Esto también es verbatim de E3, exepto los cambios marcados

	// --------------------------------------
	// Guardado de resultados de MC
	// --------------------------------------

	use `e3raw', clear
	save "`outdir'/`run_prefix'__e3_7_raw.dta", replace
	
	collapse ///
		(count) reps_total = fail ///
		(sum) failures = fail ///
		(mean) fail_rate = fail ///
		(mean) rejection_rate = reject5 ///
		(mean) mean_phat_coef = phat_coef ///
		(sd) sd_phat_coef = phat_coef, ///
		by(scenario specification)

	export delimited using "`outdir'/`run_prefix'__e3_7.csv", replace

	di "----------------------------------------------"
	di as text "E3.7 Monte Carlo terminó. Raw exportado."
	di as text "`outdir'/`run_prefix'__e3_7_raw.dta"
	di "----------------------------------------------"

	// =====================================================
	// NUEVO E3.7 - DIAGNÓSTICO DE FALLOS
	// =====================================================

	// Adaptar acá el bloque anterior de fail rates para distinguir:
	//
	// - fallo de la primera etapa
	// - fallo de la segunda etapa
	// - fallo total
	//
	// Exportar como:
	//
	// "`outdir'/`run_prefix'__e3_7_failrates.csv"

	// =====================================================
	// NUEVO E3.7 - TABLA FINAL
	// =====================================================

	// Colapsar por escenario y reportar:
	//
	// - número de simulaciones válidas
	// - media del indicador de rechazo al 5 %
	// - coeficiente medio de la probabilidad estimada
	// - desvío estándar del coeficiente
	// - tasa de fallos
	//
	// Interpretación:
	//
	// - escenario base: tamaño empírico
	// - escenario mnar: potencia
	//
	// Exportar como:
	//
	// "`outdir'/`run_prefix'__e3_7.csv"

}

di as text "== EJERCICIO 3.7: fin =="
end

/********************************************************************
Control de flujo
********************************************************************/

cls

quietly {
    if ($RUN_E1_A == 1 | $RUN_E1_B == 1 | $RUN_E1_B6_FE_TABLE == 1 ) {
        noisily EJERCICIO_1
    }

    if $RUN_E2 {
        noisily EJERCICIO_2
    }

    if $RUN_E3 {
        noisily EJERCICIO_3
    }

	if $RUN_E3_7 {
		noisily EJERCICIO_3_7	
	}
}

log close