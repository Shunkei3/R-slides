#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| autorun: true
library(openintro)
dim(nycflights)
#
#
#
#| autorun: true
# Load nycflights13 package and get flights data`
library(nycflights13)
data(flights, package = "nycflights13")

# Remove rows with missing values (just for convenience)
flights <- na.omit(flights)
# Check the class of object
class(flights)
#
#
#
#
#
#
#
#
#| autorun: true
# Load data.table package
library(data.table)
setDT(flights) # same as, flights <- as.data.table(flights)
# Now, flights is a data.table object.
class(flights)
```
#
#
#
#
#
#
#
#
#
#
#
#
#
#| eval: false
# Don't run
DT[i, j, by]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
flights[carrier == "AA",]
```
#
#
#
#
#
#
#
#
#
# 1. Subset rows where carrier is "AA" and month is 1 (January)

# 2. Subset rows where carrier is "AA" and origin is all the airports except "JFK"

# 3. Subset rows where delay in departure is les than 0 or delay in departure is les than 0. (Hint: use | for "or" condition)

#
#
#
#
#
#
# 1. Subset rows where carrier is "AA" and month is 1 (January)
flights[carrier == "AA" & month == 1,]

# 2. Subset rows where carrier is "AA" and origin is all the airports except "JFK"
flights[carrier == "AA" & origin != "JFK",]

# 3. Subset rows where delay in departure is les than 0 or delay in departure is les than 0. (Hint: use | for "or" condition)
flights[dep_delay < 0 | arr_delay < 0,]
```
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# --- Select dep_time column as vector --- #
flights[, dep_time]
# --- Select dep_time column as data.table --- #
flights[, list(dep_time)]
# or
flights[, .(dep_time)]
# or you can also select a column in the data.frame way
flights[, "dep_time"]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# --- Select dep_time and arr_time as data.table --- #
flights[, .(dep_time, arr_time)]

# --- Deselect columns using - or ! --- #
flights[, !c("dep_time", "arr_time")]
# or
# flights[, -c("dep_time", "arr_time")]
```
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# count the number of trips with total delay < 0
flights[, sum((arr_delay + dep_delay) < 0)]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
flights[origin == "JFK" & month == 6L, .N]
# NOTE: `.N` is a special variable that holds the number of rows in the current group.
# So, this code is equivalent to:
# nrow(flights[origin == "JFK" & month == 6L,])
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
flights[origin == "JFK" & month == 6L, .(Count = .N, avg_dep_delay = mean(dep_delay))]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# You can write your code here
#
#
#
#
#
#
flights[origin == "JFK" & month == 8L, .(m_arr = mean(arr_delay), m_dep = mean(dep_delay))]
```
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
flights[, total_delay := dep_delay + arr_delay]
#
#
#
#
#
#
#
#
#
#
#
#
#
#| autorun: true
#| 
flights[, `:=`(
  total_delay = arr_delay + dep_delay,
  speed = distance/air_time
  )]
#
#
#
#
#
#
#
#
#| eval: false

# This code does not work
flights[, `:=`(
  total_delay = arr_delay + dep_delay,
  delay_rate = total_delay/air_time,
]
# the problem in the code above is that newly defined variable `total_dely` is reffered in the same [] expression.

# Instead do this 
flights[, total_delay := arr_delay + dep_delay]
flights[, delay_rate := total_delay/air_time]
```
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| autorun: true

# Before updating
head(flights[month == 4, .(month, total_delay)], 3)
```
#
#
#
#
#
#| autorun: true

flights2 <- copy(flights)[month == 4, total_delay := total_delay + 10]

head(flights2[month == 4, .(month, arr_delay)], 3)
```
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# You can write your code here

#
#
#
#
#
#| autorun: true
flights[, speed := distance / air_time]

# take a look at the head of the data
head(flights[, .(speed)])
```
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| eval: false
DT[, .(new_column = function(column)), by = .(group_variable)]
#
#
#
#
#
#
#
flights[, .(.N), by = .(origin)]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
flights[, .(avg_dep_delay = mean(dep_delay), avg_arr_delay = mean(arr_delay)), by = .(carrier, origin)]
#
#
#
#
#
#
#
#
#
#
#
#
#
flights[carrier == "AA", .N, by = .(origin)]
#
#
#
#
#
#
#
#
#
#
#
#
flights[carrier == "AA", .N, by = .(origin, month)] %>% head()
#
#
#
#
#
#
#
#
#
#
#
#
#
# You can write your code here

#
#
#
#
#
#
#
#
# You can write your code here

#
#
#
#
#
#
#
#
#
flights[,.(
  n_flights = .N,
  avg_dep_delay = mean(dep_delay),
  avg_arr_delay = mean(arr_delay)
), by = .(month, carrier)]
#
#
#
#
#
#
#
#
#
#
# --- Define season --- #
flights[,season := fcase(
  month %in% c(12, 1, 2), "Winter",
  month %in% c(3, 4, 5), "Spring",
  month %in% c(6, 7, 8), "Summer",
  default = "Fall" #otherwise, "Fall`"
)]

# --- Summarize by season and carrier --- #
flights[, .(
  total_flights = .N,
  avg_dep_delay = mean(dep_delay, na.rm = TRUE),
  avg_arr_delay = mean(arr_delay, na.rm = TRUE)
), by = .(season, carrier)]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| echo: false

library(data.table)
library(dplyr)

yield_data_long <- 
  data.table(
    state = c("Kansas", "Nebraska", "Iowa", "Illinois") %>% rep(each = 2),
      year = c(2019, 2020) %>% rep(4),
      yield = c(200, 240, 210, 220, 220, 230, 190, 150),
      rainfall = c(14, 15, 15, 16, 20, 21, 24, 15)
  )

yield_data_long
#
#
#
#
#
#
#
#
#
#
#
#| echo: false
yield_data_wide <- 
  dcast(yield_data_long, state ~ year, value.var = c("yield", "rainfall"))

yield_data_wide
```
#
#
#
#
#
#
#
#
#
#
#
#
yield_data_long <- 
  data.table(
    state = c("Kansas", "Nebraska", "Iowa", "Illinois") %>% rep(each = 2),
      year = c(2019, 2020) %>% rep(4),
      yield = c(200, 240, 210, 220, 220, 230, 190, 150),
      rainfall = c(14, 15, 15, 16, 20, 21, 24, 15)
  )
#
#
#
#
#
#
#
#
#
#| eval: false
dcast(data, LHS ~ RHS , value.var = c("var1", "var2"))
```
#
#
#
#
#
#
#
#
#
#
#| autorun: true
dcast(yield_data_long, state ~ year , value.var = c("yield", "rainfall"))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| autorun: true

# Let's use iris data
data(iris)
head(iris)
#
#
#
#
#
#
#
#
#
#
#
#
#
flights_mini <- 
  flights[,head(.SD, 1), by = month] %>% 
  .[, .(carrier, month, dep_delay, arr_delay)]

# take a look at the data
head(flights_mini)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| autorun: true
# Get airlines data from `nycflights13` package
data(airlines, package = "nycflights13")
setDT(airlines)

head(airlines)
#
#
#
#
#
#
#
flights_merged <- airlines[flights, on = "carrier"]

# Check whether `name` column is added to `flights` data
head(flights_merged)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
x = 1:10
fcase(
	x < 5L, 1L,
	x > 5L, 3L
)
#
#
#
#
#
#
# --- Define season --- #
flights[,season := fcase(
  month %in% c(12, 1, 2), "Winter",
  month %in% c(3, 4, 5), "Spring",
  month %in% c(6, 7, 8), "Summer",
  default = "Fall" #otherwise, "Fall`"
)]
#
#
#
#
#
#
#
#
#| autorun: true
library(dplyr)

#
#
#
#
#
#
#
#
#
#
#
flights[dep_delay == max(dep_delay), .(carrier)]
#
#
#
#
#
msp_feb_flights <- flights[dest=="MSP" & month==2L]
nrow(msp_feb_flights)
#
#
#
#
#
#
#
msp_feb_flights[,.(
  median = median(arr_delay),
  IQR = quantile(arr_delay, 0.75) - quantile(arr_delay, 0.25),
  n_flights = .N
  ), by = carrier]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# first three columns
select_cols <- c("year", "month", "day")
flights[ , select_cols, with = FALSE]
flights[ , ..select_cols]

# flights[,year:day]
#
#
#
#
#
flights_df <- as.data.frame(flights)
  with(
    flights, 
     mean(arr_delay + dep_delay)
  )

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| autorun: true

# Don't worry about this code. It just creates a small data.table object.
flights_mini <- 
  flights[,head(.SD, 2), by = month] %>% 
  .[, .(year, month, dep_delay, arr_delay)]

head(flights_mini)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
flights_mini[, print(.SD), by = month]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
flights[carrier == "AA", .(.N), by = .(origin, month)] %>% head()
#
#
#
#
#

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
