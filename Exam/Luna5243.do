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

global RUN_E2   0
global RUN_E3   1


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

if $RUN_E1_A {
	// Reproducibilidad
	set seed $THE_SEED
	di as text "!!! ---------- 1A -------------- !!! "
	
	// Frame aparte para arrancar de cero
	capture frame drop E1A_DATA
	frame create E1A_DATA
	frame change E1A_DATA
	
	// Setup del panel y simus
	local S = 500
	local N = 200
	local T = 6
	local NT = `N' * `T'
	
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
		
		/*
		// DGP base: AR(1) + endogeneidad, Hausman manual
		quietly hausman_manual_pair ///
			y_it x1_it x2_it
		matrix haus_man[`s',1]   = r(reject_raw) // Sin corregir
		matrix haus_man_c[`s',1] = r(reject_cor) // Corregido
		*/

		// DGP base: AR(1) + endogeneidad, Hausman de Stata
		quietly hausman_stata_pair ///
			y_it x1_it x2_it
		matrix haus_sta[`s',1]   = r(reject_raw)
		matrix haus_sta_c[`s',1] = r(reject_cor)

		/*
		// Alt1: rho = 0, pero endogeneidad. Hausman de Stata
		quietly hausman_stata_pair /// 
			yalt1_it x1_it x2_it
		matrix haus_al1[`s',1]   = r(reject_raw)
		matrix haus_al1_c[`s',1] = r(reject_cor)
		*/

		// Alt2: rho = 0 y exogeneidad respecto de c_i. Hausman de Stata
		quietly hausman_stata_pair ///  
			yalt2_it x1alt_it x2_it
		matrix haus_al2[`s',1]   = r(reject_raw)
		matrix haus_al2_c[`s',1] = r(reject_cor)
		
		// Inciso 5
		bysort id: egen mean_x1 = mean(x1_it) // calculamos las medias
		bysort id: egen mean_x2 = mean(x2_it)
        xtreg y_it x1_it x2_it mean_x1 mean_x2, re  // RE con medias como regres.
		test mean_x1 mean_x2
		matrix mundlak[`s',1] = (r(p) < 0.05)	
		
		
	}
	}
	
	// Se usa el truco de la práctica para manejar los resultados en un dataframe
	frame create E1A_RESULTS
	frame change E1A_RESULTS
	
	
	// TO-DO remove: Versión vieja con todos los Hausmans
	/*
	matrix results = b1h_ols, b2h_ols, b1h_re, b2h_re, b1h_fe, b2h_fe, ///
					 se1_fe_conv, se2_fe_conv, se1_fe_rc, se2_fe_rc, ///
					 haus_man,   haus_sta,   haus_al1,   haus_al2, ///
					 haus_man_c, haus_sta_c, haus_al1_c, haus_al2_c, ///
					 mundlak
					 

	matrix colnames results = b1_ols b2_ols b1_re b2_re b1_fe b2_fe ///
							  se1_fe_conv se2_fe_conv se1_fe_rc se2_fe_rc ///
							  haus_man   haus_sta   haus_alt1   haus_alt2 ///
							  haus_man_c haus_sta_c haus_alt1_c haus_alt2_c ///
							  mundlak

	svmat double results, names(col)
	*/
	
	matrix results = b1h_ols, b2h_ols, b1h_re, b2h_re, b1h_fe, b2h_fe, ///
					 se1_fe_conv, se2_fe_conv, se1_fe_rc, se2_fe_rc, ///
					 haus_sta, haus_al2, haus_sta_c, haus_al2_c, ///
					 mundlak

	matrix colnames results = b1_ols b2_ols b1_re b2_re b1_fe b2_fe ///
							  se1_fe_conv se2_fe_conv se1_fe_rc se2_fe_rc ///
							  haus_base_raw haus_size_raw ///
							  haus_base_cor haus_size_cor ///
							  mundlak

	svmat double results, names(col)
	
	// --------------------------------------------------
	// Tabla final: beta1
	// Media, desvio estandar Monte Carlo y RMSE
	// --------------------------------------------------

	gen sqerr_b1_ols = (b1_ols - `beta1')^2
	gen sqerr_b1_re  = (b1_re  - `beta1')^2
	gen sqerr_b1_fe  = (b1_fe  - `beta1')^2

	matrix TAB_B1 = J(3,3,.)
	matrix rownames TAB_B1 = POLS RE FE
	matrix colnames TAB_B1 = mean sd rmse

	local r = 1
	foreach est in ols re fe {
		quietly summarize b1_`est'
		matrix TAB_B1[`r',1] = r(mean)
		matrix TAB_B1[`r',2] = r(sd)

		quietly summarize sqerr_b1_`est'
		matrix TAB_B1[`r',3] = sqrt(r(mean))

		local r = `r' + 1
	}

	di as text "== beta1: media, SD Monte Carlo, RMSE =="
	matrix list TAB_B1, format(%12.4f)
	
	
	// --------------------------------------------------
	// Tabla final: beta2
	// Media, desvio estandar Monte Carlo y RMSE
	// --------------------------------------------------

	gen sqerr_b2_ols = (b2_ols - `beta2')^2
	gen sqerr_b2_re  = (b2_re  - `beta2')^2
	gen sqerr_b2_fe  = (b2_fe  - `beta2')^2

	matrix TAB_B2 = J(3,3,.)
	matrix rownames TAB_B2 = POLS RE FE
	matrix colnames TAB_B2 = mean sd rmse

	local r = 1
	foreach est in ols re fe {
		quietly summarize b2_`est'
		matrix TAB_B2[`r',1] = r(mean)
		matrix TAB_B2[`r',2] = r(sd)

		quietly summarize sqerr_b2_`est'
		matrix TAB_B2[`r',3] = sqrt(r(mean))

		local r = `r' + 1
	}

	di as text "== beta2: media, SD Monte Carlo, RMSE =="
	matrix list TAB_B2, format(%12.4f)
	
	// --------------------------------------------------
	// Comparacion de errores estandar FE
	// --------------------------------------------------

	matrix TAB_SE_FE = J(2,5,.)
	matrix rownames TAB_SE_FE = beta1 beta2
	matrix colnames TAB_SE_FE = MC_sd mean_SE_conv mean_SE_cluster ratio_conv ratio_cluster

	// beta1
	quietly summarize b1_fe
	local mc_sd = r(sd)

	quietly summarize se1_fe_conv
	local se_conv = r(mean)

	quietly summarize se1_fe_rc
	local se_cl = r(mean)

	matrix TAB_SE_FE[1,1] = `mc_sd'
	matrix TAB_SE_FE[1,2] = `se_conv'
	matrix TAB_SE_FE[1,3] = `se_cl'
	matrix TAB_SE_FE[1,4] = `se_conv' / `mc_sd'
	matrix TAB_SE_FE[1,5] = `se_cl' / `mc_sd'

	// beta2
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
	
	
	// --------------------------------------------------
	// Hausman: potencia y tamaño empirico
	// --------------------------------------------------

	matrix TAB_HAUS = J(4,2,.)
	matrix rownames TAB_HAUS = base_raw base_sigmamore size_raw size_sigmamore
	matrix colnames TAB_HAUS = rejection_rate valid_N

	quietly summarize haus_base_raw
	matrix TAB_HAUS[1,1] = r(mean)
	matrix TAB_HAUS[1,2] = r(N)

	quietly summarize haus_base_cor
	matrix TAB_HAUS[2,1] = r(mean)
	matrix TAB_HAUS[2,2] = r(N)

	quietly summarize haus_size_raw
	matrix TAB_HAUS[3,1] = r(mean)
	matrix TAB_HAUS[3,2] = r(N)

	quietly summarize haus_size_cor
	matrix TAB_HAUS[4,1] = r(mean)
	matrix TAB_HAUS[4,2] = r(N)

	di as text "== Hausman: potencia y tamaño empirico =="
	matrix list TAB_HAUS, format(%12.4f)
	
	// --------------------------------------------------
	// Mundlak: potencia comparada con Hausman
	// --------------------------------------------------

	matrix TAB_POWER = J(2,2,.)
	matrix rownames TAB_POWER = Hausman_sigmamore Mundlak
	matrix colnames TAB_POWER = rejection_rate valid_N

	quietly summarize haus_base_cor
	matrix TAB_POWER[1,1] = r(mean)
	matrix TAB_POWER[1,2] = r(N)

	quietly summarize mundlak
	matrix TAB_POWER[2,1] = r(mean)
	matrix TAB_POWER[2,2] = r(N)

	di as text "== Potencia: Hausman vs Mundlak =="
	matrix list TAB_POWER, format(%12.4f)
	
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
	
	/* TO-DO remove
	// Hausman sin corregir: tasas de rechazo entre simulaciones válidas
	tabstat haus_man haus_sta haus_alt1 haus_alt2, ///
        statistics(mean count) ///
        columns(statistics) ///
        format(%12.4f) ///
        varwidth(18)
	
	// Hausman corregido: tasas de rechazo entre simulaciones válidas	
	tabstat haus_man_c haus_sta_c haus_alt1_c haus_alt2_c, ///
        statistics(mean count) ///
        columns(statistics) ///
        format(%12.4f) ///
        varwidth(18)
	*/
	
	// Hausman sin corregir: tasas de rechazo entre simulaciones válidas
	tabstat haus_base_raw haus_size_raw, ///
        statistics(mean count) ///
        columns(statistics) ///
        format(%12.4f) ///
        varwidth(18)
	
	// Hausman corregido: tasas de rechazo entre simulaciones válidas	
	tabstat haus_base_cor haus_size_cor, ///
        statistics(mean count) ///
        columns(statistics) ///
        format(%12.4f) ///
        varwidth(18)
		
	tabstat mundlak, ///
		statistics(mean count) ///
		columns(statistics) ///
		format(%12.4f) ///
		varwidth(18)
		
    //frame change E1A_DATA

}

if $RUN_E1_B {
	// Reproducibilidad
	set seed $THE_SEED
	di as text "!!! ---------- 1B -------------- !!! "
	
	// Frame aparte para arrancar de cero
	capture frame drop E1B_DATA
	frame create E1B_DATA
	frame change E1B_DATA
	
	// Tres setups
	local S = 300
	local TAMS = 3 // 3 configs de tamanios muestrales
	
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

	set obs `S'
	svmat double results, names(col)


	// --------------------------------------------------
	// Tabla 1B.7: beta1
	// Media, SD Monte Carlo y RMSE para POLS, RE y FE
	// bajo las tres combinaciones (N,T)
	// --------------------------------------------------

	matrix TAB_E1B_B1 = J(9,3,.)
	matrix rownames TAB_E1B_B1 = ///
		POLS_n50t4 POLS_n200t6 POLS_n500t10 ///
		RE_n50t4   RE_n200t6   RE_n500t10 ///
		FE_n50t4   FE_n200t6   FE_n500t10

	matrix colnames TAB_E1B_B1 = mean sd rmse

	local r = 1
	foreach est in ols re fe {
		foreach tam in n50t4 n200t6 n500t10 {

			gen sqerr_b1_`est'_`tam' = (b1_`est'_`tam' - `beta1')^2

			quietly summarize b1_`est'_`tam'
			matrix TAB_E1B_B1[`r',1] = r(mean)
			matrix TAB_E1B_B1[`r',2] = r(sd)

			quietly summarize sqerr_b1_`est'_`tam'
			matrix TAB_E1B_B1[`r',3] = sqrt(r(mean))

			local r = `r' + 1
		}
	}

	di as text "== E1B.7: beta1, media, SD Monte Carlo y RMSE =="
	matrix list TAB_E1B_B1, format(%12.4f)


	// --------------------------------------------------
	// Tabla 1B.6: comparación FE
	// SE convencionales vs cluster por tamaño muestral
	// --------------------------------------------------

	matrix TAB_E1B_SE_FE = J(6,6,.)
	matrix rownames TAB_E1B_SE_FE = ///
		beta1_n50t4 beta1_n200t6 beta1_n500t10 ///
		beta2_n50t4 beta2_n200t6 beta2_n500t10

	matrix colnames TAB_E1B_SE_FE = ///
		MC_sd mean_SE_conv mean_SE_cluster ///
		ratio_conv_MC ratio_cluster_MC ratio_conv_cluster

	local r = 1
	foreach b in 1 2 {
		foreach tam in n50t4 n200t6 n500t10 {

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
			matrix TAB_E1B_SE_FE[`r',5] = `se_cl' / `mc_sd'
			matrix TAB_E1B_SE_FE[`r',6] = `se_conv' / `se_cl'

			local r = `r' + 1
		}
	}

	di as text "== E1B.6: FE, comparación SE convencionales vs cluster =="
	matrix list TAB_E1B_SE_FE, format(%12.4f)


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
	local Slit = 100  // Numero reducido de simulaciones para ver fallo

	// Handle para usar postfile para los resultados de cada loop
	tempname e3h
	tempfile e3raw

	// TO-DO: hay dos escenarios ...
	// TO-DO: llenar acá bien cuando sepa qué hace todo
	// TO-DO: scenario \in {full, base, mnar}
	// TO-DO: estimator \in {WRE_full, CF_attr}
	// rep: simulación actual de MonteCarlo

	// (1) escenarios y repeticiones
	// (2) estimadores
	// (3) almacenar tests
	// (4) diagnostico de attrition
	// (5) test inciso 7
	// (6) estimación "degenerada" numéricamente

	postfile `e3h' ///
		str12 scenario ///                                   (1)
		str24 estimator int rep ///
		double delta_hat rho_hat xi_hat psi_hat sigu_hat /// (2)		
		double p_joint5 p_pool1 ///                          (3)
		double obs_share y_share ///                         (4)
		double phat_coef phat_y0 phat_y1 ///                 (5)
		byte fail ///                                        (6)
		using `e3raw', replace

	// Setup del panel
	clear
	local Tfull = `T' + 1      // hay que tener un periodo 0 para la condición inicial
	set obs `=`NL' * `Tfull''
	egen id   = seq(), block(`Tfull')
	egen time = seq(), from(0) to(`T')
	xtset id time
	
	// Check temporal
	assert _N == 2100
	assert inrange(id,1,300)
	assert inrange(time,0,6)
	isid id time

	bysort id: assert _N == 7

	list id time in 1/21, sepby(id)

	* Aquí irán los Chunks 1 a 7

	postclose `e3h'

	* Aquí irán los Chunks 8 a 10
}
di as text "== EJERCICIO 3: fin =="
end


/********************************************************************
Control de flujo
********************************************************************/

cls

quietly {
    if $RUN_E1_A == 1 | $RUN_E1_B == 1 {
        noisily EJERCICIO_1
    }

    if $RUN_E2 {
        noisily EJERCICIO_2
    }

    if $RUN_E3 {
        noisily EJERCICIO_3
    }
}

log close