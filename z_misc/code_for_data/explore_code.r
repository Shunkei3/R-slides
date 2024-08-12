library(dplyr)
library(data.table)
library(ggplot2)
library(here)
library(openintro)


#' Applied Econometrics with R:
#'
#' Text book (Stock & Watson): https://users.ssc.wisc.edu/~mchinn/stock-watson-econometrics-3e-lowres.pdf


# A list of data
#' 1. CPS1985 (Cross-Section Data)
#' data(CPS1985, package = "AER")
#'
#' 2. Damand for economics journal
#' https://www.zeileis.org/teaching/AER/Ch-Intro-handout.pdf
#' data("Journals", package = "AER")

# /*--------------------------------*/
#' ## Midwest demographic data
# /*--------------------------------*/
# Demographic information of midwest counties from 2000 US census

data("midwest", package = "ggplot2")
midwest <- as.data.table(midwest)



# /*--------------------------------*/
#' ## Economics Journals Subscriptions
# /*--------------------------------*/
data("Journals", package = "AER")
journal <- as.data.table(Journals)

# Data set from Stock & Watson (2007), originally collected by T. Bergstrom, on subscriptions to 180 economics journals at US libraries, for the year 2000.


# 1. Find the top 10 journals with the highest citations
journal[order(-citations), ][1:10]
# 1. Find the top 10 journals with the highest price
journal[order(-citations), ][1:10]






# /*--------------------------------*/
#' ## CPS
# /*--------------------------------*/
# data taken from Berndt (1991)
# They represent a random subsample of cross-section data originating from the May 19854 1 Introduction Current Population Survey, comprising 533 observations.
library(AER)
??AER

# data(CPS85, package="mosaicData")
# nrow(CPS85)

data(CPS1985, package = "AER")
cps <-
  as.data.table(CPS1985) %>%
  .[, log_wage := log(wage)]


ggplot() +
  geom_point(
    aes(x = age, y = log_wage),
    data = cps
  ) +
  geom_
theme_bw()



# /*--------------------------------*/
#' ## Air Quality Data
# /*--------------------------------*/
pm25 <-
  openintro::pm25_2011_durham %>%
  as.data.table() %>%
  .[, `:=`(
    year = year(date),
    month = month(date)
  )]


# airquality
# 1. Aggregate the data by month by taking the mean of each variable
airquality[, .(
  mean_pm2_5 = mean(daily_mean_pm2_5_concentration, na.rm = TRUE)
), by = .(state, county, month)]

# airquality[,
#   lapply(.SD, mean, na.rm = TRUE), by = .(Month),
#   .SDcols = c("Ozone", "Solar.R", "Wind", "Temp")]

# 2. For each month, find the Day with the highest Ozone level
high_pm25_day <-
  airquality[, .SD[daily_mean_pm2_5_concentration == max(daily_mean_pm2_5_concentration)], by = .(month)]


airquality[, daily_mean_pm2_5_concentration := .SD[daily_mean_pm2_5_concentration == max(daily_mean_pm2_5_concentration), daily_mean_pm2_5_concentration], by = .(month)]

airquality[order(-Ozone), .SD[1], by = .(month)]



# /*--------------------------------*/
#' ## Air Quality Data 2 (airquality dataset is built-in R)
# /*--------------------------------*/
?airquality
ggplot(data = airquality) +
  aes(x = Ozone) +
  aes(y = Temp) +
  geom_point() +
  geom_line() +
  geom_smooth(method = "lm") +
  xlab(" ")



airquality_long <-
  airquality %>%
  melt(
    data = .,
    id.vars = c("Month", "Day", "Ozone")
  )


ggplot(airquality_long, aes(x = value, y = Ozone)) +
  geom_point() +
  facet_wrap(~variable, scales = "free", ncol = 2) +
  geom_smooth() +
  labs(x = "Value", y = "Ozone")




# /*--------------------------------*/
#' ## Corn yield data
# /*--------------------------------*/
yield_dt <-
  readRDS(here("Data/corn_yield_dt.rds")) %>%
  as.data.table()


yield_state_dt <-
  yield_dt[, .(agg_var = mean(Value)), by = state_alpha]

ggplot(yield_state_dt) +
  geom_bar(
    aes(x = state_alpha, y = agg_var),
    stat = "identity", fill =
    ) +
  theme_bw()

yield_dt[state_alpha == "MN"] %>%
  ggplot(.) +
  geom_bar(
    aes(x = factor(year), y = Value),
    stat = "identity"
  ) +
  labs(
    title = "Tend of Corn Yield (bu/acre) in Minnesota",
    x = "Year", y = "Yield (bu/acre)"
  ) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))


ggplot(yield_dt) +
  geom_line(
    aes(x = factor(year), y = Value, group = state_alpha, color = state_alpha)
  )



# /*--------------------------------*/
#' ## Hypothetical Data
# /*--------------------------------*/
ls_states <- unique(yield_dt$state_alpha)
ls_years <- 2000:2022

y_dt <-
  CJ(
    states = ls_states,
    years = ls_years
  ) %>%
  # /*--------------------------------*/
  #' ## AER: Fatalities
  #' #/*--------------------------------*/
  data("Fatalities", package = "AER")

fata_dt <-
  as.data.table(Fatalities) %>%
  # the traffic fatality rate, measured as the number of fatalities per 10000 inhabitants
  .[, fatal_rate := fatal / pop * 10000]

unique(fata_dt$year)

fata_dt[state %in% c("mn", "il")] %>%
  ggplot(data = ., aes(x = year, y = fatal_rate, color = state)) +
  geom_line(aes(group = state))



# /*--------------------------------*/
#' ## Insurance:
# /*--------------------------------*/
# medical information and costs billed by health insurance companies in 2013, as compiled by the United States Census Bureau. Variables include age, sex, body mass index, number of children covered by health insurance, smoker status, US region, and individual medical costs billed by health insurance for 1338 individuals.


# see this:
# Chapter 3 Introduction to ggplot2
# + https://rkabacoff.github.io/datavis/IntroGGPLOT.html


url <- "https://tinyurl.com/mtktm8e5"

insurance <-
  fread(url) %>%
  as.data.table() %>%
  .[, mean_expenses := mean(expenses), by = .(smoker, sex)]

ggplot(insurance) +
  geom_histogram(
    aes(x = expenses, fill = sex)
  ) +
  geom_vline(
    aes(xintercept = mean_expenses, color = sex),
    linetype = 2
  ) +
  facet_wrap(~smoker, ncol = 1)







# /*--------------------------------*/
#' ## Life Expectancy, GDP per Capita
# /*--------------------------------*/
# install.packages("gapminder")
data(gapminder, package = "gapminder")

#' This dataset is used in the book "R for Health Data Science" by Ewen Harrison and Riinu Ots.
#' see
#' https://argoshare.is.ed.ac.uk/healthyr_book/chap04-data.html

names(gapminder)
unique(gapminder$country)


gapminder %>%
  filter(country %in% c("United States", "China", "India", "United Kingdom")) %>%
  ggplot(aes(x = year, y = lifeExp, color = country)) +
  geom_line() +
  labs(
    title = "Life Expectancy in Selected Countries",
    x = "Year", y = "Life Expectancy"
  ) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))


ggplot(small_gapminder) +
  geom_line(
    aes(x = year, y = gdpPercap, group = country, color = country)
  )


ggplot(data = gapminder, aes(x = lifeExp, fill = continent)) +
  geom_density(alpha = 0.5)


# /*--------------------------------*/
#' ## Economics: US economic time series
# /*--------------------------------*/
library(ggplot2)

# economics
# ecnomics_long






# /*--------------------------------*/
#' ##
# /*--------------------------------*/
"https://raw.githubusercontent.com/gonzalodqa/timeseries/main/temp.csv"





# /*--------------------------------*/
#' ## AER:
# /*--------------------------------*/


# /*--------------------------------*/
#' ##
# /*--------------------------------*/
# + incinerator example
# + https://cran.r-project.org/web/packages/wooldridge/vignettes/Introductory-Econometrics-Examples.html


lirbary(wooldridge)

data(hprice2)
library(data.table)
library(modelsummary)

class(hprice2)
hprice2 <- as.data.table(hprice2)



# === Descriptive Statistics === #




# === Regression Results === #
test <- lm(log(price) ~ log(nox), data = hprice2)
modelsummary(test, output = "markdown", stars = TRUE)



# --- Quick look at the data --- #
datasummary_skim(hprice2)


# --- Summary Statistics --- #
datasummary(
  price + nox + rooms + dist ~ Mean + SD + Min + Max + N,
  data = hprice2,
  output = "flextable",
  title = "Example of Summary Statistics"
)





#/*--------------------------------*/
#' ## 
#/*--------------------------------*/
library(foreign)

Panel <- read.dta("http://dss.princeton.edu/training/Panel101.dta")
