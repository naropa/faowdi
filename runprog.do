*-------------------------------------
* Runs complete program
*-------------------------------------
*-------------------------------------
* Program setup
*-------------------------------------
version 13
set more off
clear all
capture log close
capture mkdir log
log using log/proglog, replace
*-------------------------------------

do params
do countrymap
do fao_getdata
do wdi_getdata
do mergefiles
do faogroups

log close
