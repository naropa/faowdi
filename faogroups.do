*-------------------------------------
* Copy program outputted files to folders for each country group
*-------------------------------------
*-------------------------------------
* Program setup
*-------------------------------------
version 13
set more off
clear all
set linesize 80
*-------------------------------------

insheet using "$faopath/codes/$faogroups"
levelsof countrygroupcode, local(groupcode)

foreach i of local groupcode {
    capture mkdir "$filespath/`i'" // ignore error if directory exists
    preserve
    keep if countrygroupcode == `i'
    keep countrycode country
    duplicates drop
    levelsof countrycode, local(countrycodevals)
    foreach j of local countrycodevals {
        capture confirm file "$filespath/all_`j'.dta"
        if _rc == 0 {
            cp "$filespath/all_`j'.dta" "$filespath/`i'/", replace            
        }
        else {
            display "The file all_`j'.dta doesn't exist..."
        }
    }
    restore
}

// make files showing included and excluded countries
foreach i of local groupcode {
    preserve
    keep if countrygroupcode == `i'
    keep countrycode country countrygroup
    duplicates drop

    save "$filespath/`i'/group_all", replace
    touch "$filespath/`i'/included", replace
    touch "$filespath/`i'/excluded", replace
    levelsof countrycode, local(countrycodevals)

    foreach j of local countrycodevals {
        clear
        use "$filespath/`i'/group_all"
        capture confirm file "$filespath/all_`j'.dta"
        if _rc == 0 {
            keep if countrycode == `j'
            tempfile country_`j'
            save "`country_`j''"
            clear
            use "$filespath/`i'/included"
            append using "`country_`j''"
            save "$filespath/`i'/included", replace
        }
        else {
            keep if countrycode == `j'
            tempfile country_`j'
            save "`country_`j''"
            clear
            use "$filespath/`i'/excluded"
            append using "`country_`j''"
            save "$filespath/`i'/excluded", replace
        }
    }
    clear
    restore
}
clear
