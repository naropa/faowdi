// Merge faostat and wdi data

clear
use "$filespath/countrymap"
levelsof FAOcc, local(countrycodevals)
clear

set more off
foreach k of local countrycodevals {

    capture confirm file "$filespath/fao_`k'.dta"
    local fao = _rc
    capture confirm file "$filespath/wdi_`k'.dta"
    local wdi = _rc
    if `fao'==0 & `wdi'==0 {
        use "$filespath/fao_`k'"
        merge 1:1 year using "$filespath/wdi_`k'"
        sort year
        keep if _merge == 3 // only keep years that contained data in both faostat and wdi
        drop _merge
        save "$filespath/all_`k'", replace
        clear
    }
    else {
        display "Regarding country `k'..."
        display "The existence of file fao_`k'.dta is `fao'."
        display "The existence of file wdi_`k'.dta is `wdi'."
    }

}
