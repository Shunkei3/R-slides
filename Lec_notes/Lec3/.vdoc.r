#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: demo1
#| autorun: true
#| echo: false


library(ggplot2)
library(dplyr)
library(data.table)


ggplot(data = airquality, aes(x = Ozone, y = Temp)) +
  geom_point() +
  labs(title = "Ozone (ppb) and temperature (degrees F) in New York, May to September 1973.") +
  geom_smooth(method = "lm") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))
#
#
#
#
#
#
#| label: demo2
#| autorun: true
#| echo: false

#/*--------------------------------*/
#' ## Box plot
#/*--------------------------------*/
PlantGrowth %>%
  as.data.table() %>%
  .[, group := fcase(
    group == "ctrl", "Control",
    group == "trt1", "Treatment 1",
    group == "trt2", "Treatment 2"
  )] %>%
  ggplot(data = ., aes(x = group, y = weight)) +
  geom_boxplot(fill = "blue", alpha =0.5) +
  labs(
    title = "Box plot of weight of plants by group",
    x = "Group",
    y = "Weight"
  ) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))


# ggplot(data = airquality, aes(x = factor(Month), y = Temp)) +
#   geom_boxplot() +
#   theme_bw() +
#   labs(
#     title = "Box plot of temperature (degrees F) in New York, May to September 1973",
#     x = "Month",
#     y = "Temperature"
#   ) +
#   theme(plot.title = element_text(hjust = 0.5))
#
#
#
#
#| autorun: true
#| echo: false

airquality %>%
  as.data.table() %>%
  melt(
    data = .,
    id.vars = c("Month", "Day", "Ozone")
  ) %>%
  ggplot(., aes(x = value, y = Ozone))+
  geom_point()+
  facet_wrap(~variable, scales = "free", ncol = 2)+
  geom_smooth() + 
  labs(
    title = "Relationship between ozone and weather conditions in New York, May to September 1973",
    x = "", y = "Ozone"
  ) +
  theme(plot.title = element_text(hjust = 0.5))
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
install.packages('ggplot2')
#
#
#
#
#
library(ggplot2)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| label: taste
#| autorun: true
#| output-location: column
#| scro

ggplot(data = airquality) + # Create a canvas for the plot
  aes(x = Wind) + # Add x-axis
  aes(y = Ozone) + # Add y-axis
  # Add a scatter plot
  geom_point() + 
  # Add a regression line
  geom_smooth(method = "lm") + 
  # Add x label
  xlab("Wind Speed (mph)") + 
  # Add y label
  ylab("Ozone (ppb)") + 
  # Add title
  labs(title = "Ozone (ppb) and wind speed (mph) in New York, May to September 1973") + 
  # Add caption
  labs(caption = "The data were obtained from the New York State Department of Conservation (ozone data) and the National Weather Service (meteorological data).") + 
  # Set the theme
  theme_bw() + 
  # Set the title position
  theme(plot.title = element_text(hjust = 0.5))
#
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
#| output-location: column
#| code-line-numbers: "1"

ggplot(data = airquality)
#
#
#
#
#
#| autorun: true
#| output-location: column

ggplot(data = airquality)+
  aes(x = Wind)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Example 

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# === Part 1 === #
yield_dt <- readRDS("Data/corn_yield_dt.rds")

# === Part 2 === #
yield_dt <- 
  as.data.table(yield_dt) %>% 
  setnames("value", "yield")

# === Part 3 === #
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
