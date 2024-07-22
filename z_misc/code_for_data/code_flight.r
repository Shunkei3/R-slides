library(here)
library(rio)
library(data.table)
library(dplyr)


# /*===========================================*/
#'=  flight =
# /*===========================================*/
# input <- if (file.exists("flights14.csv")) {
#    "flights14.csv"
# } else {
#   "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv"
# }

# flights <- import(input)
# flights <- na.omit(flights)

flights <- 
  nycflights13::flights %>%
  na.omit() %>%
  as.data.frame()

# setDT(flights)
# flights[dest=="MSP", ]

# flights_mini <-
#     dplyr::distinct(flights, month, day, .keep_all = TRUE) %>%
#     dplyr::filter(day %in% c(1, 2)) %>%
#     dplyr::arrange(month) %>%
#     dplyr::select(year, month, day, dep_time, dep_delay, arr_time, arr_delay, air_time, origin)


# === Save as .csv === #
write.csv(flights, here("Data/flight.csv"))

# === Save as .dta === #
library(haven)
write_dta(flights, here("Data/flight.dta"))

# === Save as .xlsx === #
library(writexl)
write_xlsx(flights, here("Data/flight.xlsx"))


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
#'=  Exercise problems =
# /*===========================================*/

# === Step 1: Load data === #
# flights <- readRDS("Data/flight.rds")
# the data is created with the following code:
flights <- nycflights13::flights
flights <-  na.omit(flights)
flights <-  as.data.frame(flights)
names(flights)
# === Part 2: subset data === #
# define the columns to select
select_cols <- c("year", "month", "day", "dep_delay", "arr_delay", "dest", "carrier")
flights_mn <- flights[flights$dest == "MSP", select_cols]


# === Part 3 === #
# the most basic approach is 
flights_mn$total_delay <- flights_mn$dep_delay + flights_mn$arr_delay
flights_mn$delay_type <- 
  ifelse(flights_mn$total_delay>30, "delay_more_30", "others")

# alternatively, you can use within() function like this:
flights_mn <- within(
  flights_mn, {
    total_delay <- dep_delay + arr_delay
    delay_type <- ifelse(flights_mn$total_delay>30, "delay_more_30", "others")
  }
)

# === Part 4 === #
flights_mn_delay_count <- table(flights_mn$carrier, flights_mn$delay_type)
# same as
flights_mn_delay_count <- with(flights_mn, table(carrier, delay_type))
# translate the table to data.frame class to make it easier to manipulate
flights_mn_delay_count <- as.data.frame.matrix(flights_mn_delay_count)


# === Part 5 === #
# I will only show the code using within() function
flights_mn_delay_count <- within(
  flights_mn_delay_count,
  {
    total_flights <- others + delay_more_30
    prop_more_30 <- delay_more_30 / total_flights
  }
)
flights_mn_delay_count


