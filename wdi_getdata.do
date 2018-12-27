// Gets WDI data from world bank and formats it for combining with FAOSTAT data.

// Get data for user-selected countries and indicators/topics
clear
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
set more off
foreach i of local countrycodevals {
    keep if FAOcc == `i'
    save "$filespath/wdi_`i'", replace
    restore, preserve
}
clear
