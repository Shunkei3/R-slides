#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
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
# Load flights data from nycflights13 package.
flights <- nycflights13::flights
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
#
#| autorun: true
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
#
#
#| autorun: true
yield_data_wide <- dcast(yield_data_long, state ~ year , value.var = c("yield", "rainfall"))
yield_data_wide
#
#
#
#
#
#
#
#
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
melt(data, id.var = c("id_var1", "id_var2"), measure.vars = c("var1", "var2"))
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
# yield columns
col_yields <- paste0("yield_", 2019:2020)
# rainfall columns
col_rainfalls <- paste0("rainfall_", 2019:2020)

yield_data_long_2 <- 
  melt(
    yield_data_wide, 
    id.vars = "state", 
    measure.vars = list(col_yields, col_rainfalls), 
    value.name = c("yield", "rainfall")
  )

yield_data_long_2

# If you are familiar with regular expressions, you can do:
# melt(yield_data_wide, id.vars = "state", measure.vars = patterns("^yield", "^rainfall"), value.name = c("yield", "rainfall"))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# --- using long-form --- #
yield_data_long[,.(
  avg_yield = mean(yield),
  avg_rainfall = mean(rainfall)
  ), by = .(state)]

# --- using wide-form --- #
yield_data_wide[,`:=`(
  avg_yield = sum(yield_2019 + yield_2020)/2,
  avg_rainfall = sum(rainfall_2019 + rainfall_2020)/2
)]
yield_data_wide[,.(state, avg_yield, avg_rainfall)]
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# === create long_dt (run this code) === #
yield_data_wide <- dcast(yield_data_long, state ~ year, value.var = c("yield", "rainfall"))
long_data <- melt(yield_data_wide, id.var = "state")
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
# First, I would create two columns: `year` and `type` (to denote year or rainfall) by splitting the `variable` column of long_data.
# use `tstrsplit()` function to split the variable column by "_"
long_data[, c("type", "year") := tstrsplit(variable, "_", fixed = TRUE)]

# Now, I don't need the variable column. So, remove it.
long_data[, variable := NULL]


# Finally, I would cast the data to the original long form.
dcast(long_data, state + year ~ type, value.var = "value")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
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
# Merge data2 to data1 keeping all rows from data1
merge(x, y, by = "key_column", all.x = TRUE)
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
#| autorun: true
# --- Yield data --- #
yield_data <- 
  data.table(
    state = c("Nebraska", "Iowa", "Minnesota", "Illinois", "Kansas"),
    yield = runif(n = 5, min = 180, max = 280)
  )
```
#
#
#
#
#
#| autorun: true
# --- Weather data --- #
weather_data <-
  data.table(
    state = c("Iowa", "Minnesota", "Nebraska", "Illinois", "Wisconsin"),
    total_precip = runif(5, min = 10, max = 20)
  )
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
yield_weather_data <- merge(yield_data, weather_data, by = "state", all.x = TRUE)
# check the merged data
yield_weather_data
#
#
#
#
#
#
weather_yield_data <- merge(weather_data, yield_data , by = "state", all.x = TRUE)
# check the merged data
weather_yield_data
#
#
#
#
#
#
#
#
weather_yield_data_all <- merge(weather_data, yield_data , by = "state", all = TRUE)
# check the merged data
weather_yield_data_all
#
#
#
#
#
#
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
airlines <- nycflights13::airlines
head(airlines)
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
flights_merged <- merge(flights, airlines, by = "carrier", all.x = TRUE)

# using dplyr, this is equivalent to
# flights_merged <- left_join(flights, airlines, by = "carrier")
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
yield_data <- 
  data.table(
    state = rep(c("Iowa", "Minnesota", "Illinois", "Kansas", "Wisconsin"), each = 2),
    year = rep(2010:2011, times = 5),
    yield = runif(n = 10, min = 180, max = 280)
  )

weather_data <- 
  data.table(
    state = rep(c("Iowa", "Minnesota", "Illinois", "Kansas", "Ohio"), each = 4),
    year = rep(2010:2013, times = 5),
    total_precip = runif(20, min = 10, max = 20)
  )
#
#
#
#
#
#
#
# you can write your code here
#
#
#
#
#
#
#
yield_weather_data <- merge(yield_data, weather_data, by = c("state", "year"), all.x = TRUE)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
flights <- nycflights13::flights # Load flights data from nycflights13
flights_dt <- as.data.table(flights) # change the data to data.table class 
flights_mini <- flights_dt[,.(year, month, origin, dest, carrier, air_time, dep_delay, arr_delay)] # select some columns
flights_mini <- na.omit(flights_mini) # remove rows with missing values
#
#
#
#
#
#
#
#
#
flights_mini <- na.omit(data.table(nycflights13::flights)[,.(year, month, origin, dest, carrier, air_time, dep_delay, arr_delay)])
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
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
fun1(input1) 
```
#
#
#| eval: false
input1 %>% fun1()
#
#
#
#
#
#| eval: false
output1 <- fun1(input1)
output2 <- fun2(output1)
```
#
#
#| eval: false
output2 <- fun1(input1) %>% fun2()
#
#
#
#
#
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
fun(x1, x2, x3)
#
#
#
#
#| eval: false
z %>% fun(x2, x3)
#
#
#
#
#
#| eval: false
fun(z, x2, x3)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Let's use this function (Don't worry about )
print_three_words <- function(x, y, z) paste(c(x, y, z),collapse = " ")
# For example, this function print three words with space between them
print_three_words(x="I", y="love", z="R")

# pass the input to the first argument
"I" %>% print_three_words(x=., y="love", z="R")

# pass the input to the second argument
"love" %>% print_three_words(x="I", y=., z="R")

# pass the input to the third argument
"R" %>% print_three_words(x="I", y="love", z=.)
#
#
#
#
#
#
#
#
#
#
#
#
#
#| auto-run: true
flights <- nycflights13::flights #load flights datas
flights_dt <- as.data.table(flights)  # to data.table class
flights_mini <- flights_dt[,.(year, month, origin, dest, carrier, air_time, dep_delay, arr_delay)] #select some columns
flights_mini <- na.omit(flights_mini) #remove rows with missing values
#
#
#
#
#| auto-run: true
library(dplyr)

flights_mini <- 
  nycflights13::flights %>% #load flights data
  as.data.table(.) %>% # to data.table class
  .[,.(year, month, origin, dest, carrier, air_time, dep_delay, arr_delay)] %>% #select some columns
  na.omit(.) #remove rows with missing values
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
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
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
