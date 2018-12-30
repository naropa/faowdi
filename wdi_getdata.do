*-------------------------------------
* Get WDI data from World Bank and format it for combining with FAOSTAT data
*-------------------------------------
*-------------------------------------
* Program setup
*-------------------------------------
version 13
set more off
clear all
set linesize 80
*-------------------------------------

// Get data for user-selected countries and indicators/topics
wbopendata, language(en - English) country() topics($wdi_tc) indicator() clear long

// Add FAO countrycodes
rename countrycode WDIcc
merge m:1 iso2code using "$filespath/countrymap"
drop if _merge != 3
drop if iso2code == ""
drop _merge
sort FAOcc year
save "$filespath/wdidata", replace

// Save individual country files
levelsof FAOcc, local(countrycodevals)
preserve
foreach i of local countrycodevals {
    keep if FAOcc == `i'
    save "$filespath/wdi_`i'", replace
    restore, preserve
}
clear
