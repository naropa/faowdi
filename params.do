*-------------------------------------
* Sets global macro values used by the program
*-------------------------------------
*-------------------------------------
* Program setup
*-------------------------------------
version 13
set more off
clear all
set linesize 80
*-------------------------------------

/*****************FAOSTAT ELEMENT, ITEM, AND COUNTRY CODES*****************/

// Choose element code (single selection).
global ec = 674 // protein g/capita/day
//global ec = 5510 // production quantity (tonnes)

// Choose item codes (multiple selections ok). 
//global ic = "" // all items
global ic ="2901,2903,2941,2943" // user selected items
//global ic = "1726,1735"

// Choose country codes (multiple selections ok). No aggregates allowed.  Aggregates all dropped later in order to harmonize with wdi data.
global cc = "" // all countries
//global cc = "3,7"

/******************WDI INDICATORS OR TOPICS*******************/

// Choose topic code
global wdi_tc = "1"

//OR

// Choose indicators

/*******************FILE AND FOLDER PATHS*********************/

// Choose a datafile located in $faopath
// Only use normalized data files exactly as they are provided by FAOSTAT.
global datafile "FoodBalanceSheets_E_All_Data_(Normalized).csv"
//global datafile "Production_Crops_E_All_Data_(Normalized).csv"

// File names for code files located in $faocodespath
global faogroups "countrygroups.csv"
global faocountries "countries.csv"

// Folder path for files created by this program
global filespath "files"

// Directory path for original data files from FAOSTAT
global faopath "FAO_data"

// Directory path for FAO code files
global faocodespath "$faopath/codes"
