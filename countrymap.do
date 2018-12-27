/***************
Creates a one-to-one country mapping for FAO and WDI country codes.
****************/

tempfile faocountries
insheet using "$faocodespath/$faocountries"
keep countrycode country iso2code
rename countrycode FAOcc
rename country FAOcountry
drop if iso2code == ""
duplicates drop
drop if FAOcc == 206 // Drop "Sudan (former)" in order to have a one-to-one mapping between FAO country code and ISO2 code
// Check for duplicates in countrycode
//bysort FAOcc: gen ccdupflag = cond(_N==1,0,_n)
// Check for duplicates in iso2code
//bysort iso2code: gen iso2dupflag = cond(_N==1,0,_n)
save `faocountries', replace

clear

/* Test if WDI data has a one-to-one relationship between countrycode and iso2code

tempfile wdicountries
wbopendata, language(en - English) country() topics($wdi_tc) indicator() clear long
keep countryname countrycode iso2code
rename countryname WDIcountry
rename countrycode WDIcc
drop if iso2code == ""
duplicates drop
// Check for duplicates in countrycode
//bysort WDIcc: gen ccdupflag = cond(_N==1,0,_n)
// Check for duplicates in iso2code
//bysort iso2code: gen iso2dupflag = cond(_N==1,0,_n)
save `wdicountries', replace

clear
use `faocountries'
merge 1:1 iso2code using `wdicountries'

*/

use `faocountries'
save "$filespath/countrymap", replace

