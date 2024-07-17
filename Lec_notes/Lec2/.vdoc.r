#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
library(data.table)
#
#
#
#
#
#
#
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
setDT(flights) # same as, flights <- as.data.table(flights)
# Now, flights is a data.table object.
class(flights)
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
# Subset rows where carrier is "AA" (American Airlines)
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
#
# Subset rows where carrier is "AA" and month is 1 (January)
flights[carrier == "AA" & month == 1,]

# Subset rows where carrier is "AA" and origin is all the airports except "JFK"
flights[carrier == "AA" & origin != "JFK",]
#
#
#
#
#
#
#
#
#
#
# --- Select dep_time column as vector` --- #
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
# --- Select dep_time and arr_time as data.table --- #
flights[, .(dep_time, arr_time)]

# --- Deselect columns using - or ! --- #
flights[, !c("dep_time", "arr_time")]
# flights[, -c("dep_time", "arr_time")]
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
# what is the average total delay?
flights[, mean(arr_delay + dep_delay)]
#
#
#
#
#
#
  within(
    flights, 
    Q <- Cost/Num
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
#
#
#
#
#
#
#
#
#
#
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
