*-------------------------------------
* Runs complete program
*-------------------------------------
*-------------------------------------
* Program setup
*-------------------------------------
version 13
set more off
clear all
set linesize 80
*-------------------------------------

do params
do countrymap
do fao_getdata
do wdi_getdata
do mergefiles
do faogroups
