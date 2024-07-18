library(here)
library(rio)



# /*===========================================*/
#'=  flight =
# /*===========================================*/
library(data.table)

input <- if (file.exists("flights14.csv")) {
   "flights14.csv"
} else {
  "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv"
}

flights <- import(input)

# === Save as .csv === #
write.csv(flights, here("Data/flight.csv"))

# === Save as .dta === #
library(haven)
write_dta(flights, here("Data/flight.dta"))

# === Save as .rds === #
saveRDS(flights, here("Data/flight.rds"))


#/*--------------------------------*/
#' ## flight data from nycflights13
#/*--------------------------------*/
data(flights, package = "nycflights13")
flights <- na.omit(flights)
setDT(flights)
flights[dest=="MSP", ]



ibrary(tidyverse)
library(openintro)
ls("package:openintro")
nycflights


# /*===========================================*/
#'= Weather data  =
# /*===========================================*/



# /*===========================================*/
#'=  USDA-NASS =
# /*===========================================*/
#' See Taro's slides
#' First, get an API key from this (https://quickstats.nass.usda.gov/api)


library(tidyUSDA)

IL_NE_ir_corn_yield <-
  tidyUSDA::getQuickstat(
    key = nass_api_key, # you need to replace it with your API key
    program = "SURVEY",
    data_item = "CORN, GRAIN, IRRIGATED - YIELD, MEASURED IN BU / ACRE",
    geographic_level = "COUNTY",
    state = c("ILLINOIS", "NEBRASKA"),
    year = as.character(2000:2005),
    geometry = TRUE
  )