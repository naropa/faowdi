// Runs regressions on user-selected variables for all countries and stores results in files named reg_COUNTRYCODE (for each country) and allregs (for all countries).
// Requires -parmest- stata package

// Set variables to include in regression (dependent variable first), comma-space separated (important!)
local vars = "Meat, sp_rur_totl, Vegetal_Products"

local varsnocommas = subinstr(`""`vars'""',",","",.) // remove commas from string
local varss = `varsnocommas' // for some reason varsnocommas is not working in place of varss

set more off

// Run regressions and save results in individual country files named reg_COUNTRYCODE

clear
use "$filespath/countrymap"
levelsof FAOcc, local(countrycodevals)
clear
foreach k of local countrycodevals {

    // check if data exists for each country
    capture confirm file "$filespath/all_`k'.dta"
    if _rc == 0 {
        use "$filespath/all_`k'"
        keep `varss'
        // check if sufficient observations for regression
        if _N > 1  & missing(`vars') != 1 {
            //statsby _b _se _N, clear: reg `varss'
            parmby "reg `varss'", norestore
            gen FAOcc = `k'
            save "$filespath/reg_`k'", replace
            clear
        }
        else {
            display "country_`k' skipped becasue insufficient observations to perform regression."
            capture rm "$filespath/reg_`k'"
        }
    }
    else {
        display "country_`k' skipped because file all_`k' didn't exist..."
        capture rm "$filespath/reg_`k'"
    }
    clear
}

// Build file with all results

touch "$filespath/allregs", replace
use "$filespath/allregs"
foreach k of local countrycodevals {

    capture confirm file "$filespath/reg_`k'.dta"
    if _rc == 0 {
        append using "$filespath/reg_`k'"
        save "$filespath/allregs", replace
    }
    else {
        display "skipping country `k' because missing reg file..."
    }
}

// Copy regression results files to each country group folder, and create allregs file for each country group

clear
insheet using "$faopath/codes/$faogroups"
levelsof countrygroupcode, local(groupcode)

foreach i of local groupcode {

    touch "$filespath/`i'/allregs", replace
    preserve
    keep if countrygroupcode == `i'
    levelsof countrycode, local(countrycodevals)
    foreach j of local countrycodevals {

        capture confirm file "$filespath/reg_`j'.dta"
        if _rc == 0 {
            cp "$filespath/reg_`j'.dta" "$filespath/`i'/", replace
            clear
            use "$filespath/`i'/allregs"
            append using "$filespath/`i'/reg_`j'"
            save "$filespath/`i'/allregs", replace
        }
        else {
            display "The file reg_`j'.dta doesn't exist..."
            capture rm "$filespath/`i'/reg_`j'.dta"
        }
    }
    restore
}
clear
