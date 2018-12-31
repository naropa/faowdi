*-------------------------------------
* Import FAOSTAT data and extract user-selected countries, items, and element
*-------------------------------------
*-------------------------------------
* Program setup
*-------------------------------------
version 13
set more off
clear all
set linesize 80
*-------------------------------------

// Import dataset downloaded from FAOSTAT, add ISO2 code, and drop all aggregate country groups
insheet using "$faopath/$datafile"
rename areacode     FAOcc
rename area         FAOcountry
merge m:1 FAOcc using "$filespath/countrymap" // add ISO2 code
keep if _merge == 3 // drop aggregate data for country groups
drop _merge
save "$filespath/fao_main_noaggs", replace

// Create a file for each user-selected country (all countries if none selected) restricted to the user-selected element and items

// Restrict to user country selection
if "$cc" != "" {
    keep if inlist(FAOcc,$cc) 
}

levelsof FAOcc, local(countrycodevals)
clear
foreach k of local countrycodevals {
    use "$filespath/fao_main_noaggs"
    keep if FAOcc == `k'
    // Restrict to user element selection
    keep if elementcode==$ec
    // Restrict to user item selection
    if "$ic" != "" {
        keep if inlist(itemcode,$ic)
    }
    // Check if any data for user-selected items.  If yes, proceed.  If no, print a message and skip to next country.
    if _N != 0 {
        levelsof itemcode, local(itemcodevals)
        preserve
        // Rename the "value" variable to the item name and savea a separate file for each user-selected item
        foreach i of local itemcodevals {
            keep if itemcode == `i'
            local newvar = strtoname(item[1])
            rename value `newvar'
            keep year `newvar'
            tempfile `k'_`i'
            save ``k'_`i'', replace
            restore, preserve
        }
        // Merges the above files into a single file with each column a user-selected item
        keep year
        duplicates drop
        foreach i of local itemcodevals {
            merge 1:1 year using ``k'_`i''
            drop _merge
        }
        save "$filespath/fao_`k'", replace
        restore
        clear
    }
    else {
        display "No data for user item selection in country code `k'.  Skipping to next country."
        clear
    }
}
