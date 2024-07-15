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






# /*===========================================*/
#'= Weather data  =
# /*===========================================*/