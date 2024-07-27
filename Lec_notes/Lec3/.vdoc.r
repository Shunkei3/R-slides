#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
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

# /*===== Load package =====*/
library(ggplot2)
library(dplyr)
library(data.table)

#/*--------------------------------*/
#' ## Scatter plot
#/*--------------------------------*/
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
#
#| label: demo3
#| autorun: true
#| echo: false

#/*--------------------------------*/
#' ## Density plot
#/*--------------------------------*/
data(gapminder, package="gapminder")

ggplot(data=gapminder, aes(x=lifeExp, fill=continent)) +
    geom_density(alpha=0.5) +
    labs(
      title = "Density plot of life expectancy by continent",
      x = "Life expectancy",
      y = "Density"
    ) +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5))
#
#
#
#
#
#| label: demo4
#| autorun: true
#| echo: false

gapminder %>%
  filter(country %in% c("United States", "China", "India", "United Kingdom")) %>%
  ggplot(aes(x = year, y = lifeExp, color = country))+
  geom_line()+
  labs(
    title = "Life Expectancy in Selected Countries",
    x = "Year", y = "Life Expectancy"
  )+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))
#
#
#
#
#| label: demo5
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
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "2"

# Create a canvas for the plot
ggplot(data = airquality) 
```
#
#
#
#
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "4"
#| 
# Create a canvas for the plot
ggplot(data = airquality) + 
  # Add x-axis
  aes(x = Wind)
```
#
#
#
#
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "6"

# Create a canvas for the plot
ggplot(data = airquality) + 
  # Add x-axis
  aes(x = Wind) +
  # Add y-axis 
  aes(y = Ozone) 
```
#
#
#
#
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "8"

# Create a canvas for the plot
ggplot(data = airquality) + 
  # Add x-axis
  aes(x = Wind) + 
  # Add y-axis
  aes(y = Ozone) +
  # Add a scatter plot
  geom_point() 
```
#
#
#
#
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "10"
# Create a canvas for the plot
ggplot(data = airquality) + 
  # Add x-axis
  aes(x = Wind) +
  # Add y-axis
  aes(y = Ozone) + 
  # Add a scatter plot
  geom_point() +
  # Add a regression line
  geom_smooth(method = "lm") 
```
#
#
#
#
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "12"

# Create a canvas for the plot
ggplot(data = airquality) + 
  # Add x-axis
  aes(x = Wind) +
  # Add y-axis
  aes(y = Ozone) + 
  # Add a scatter plot
  geom_point() +
  # Add a regression line
  geom_smooth(method = "lm") +
  # Change x-axis label
  labs(x = "Wind Speed (mph)")
```
#
#
#
#
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "14"

# Create a canvas for the plot
ggplot(data = airquality) + 
  # Add x-axis
  aes(x = Wind) +
  # Add y-axis
  aes(y = Ozone) + 
  # Add a scatter plot
  geom_point() +
  # Add a regression line
  geom_smooth(method = "lm") +
  # Change x-axis label
  labs(x = "Wind Speed (mph)") +
  # Change y-axis label
  labs(y = "Ozone (ppb)") 
```
#
#
#
#
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "16,17,18,19"

# Create a canvas for the plot
ggplot(data = airquality) + 
  # Add x-axis
  aes(x = Wind) +
  # Add y-axis
  aes(y = Ozone) + 
  # Add a scatter plot
  geom_point() +
  # Add a regression line
  geom_smooth(method = "lm") +
  # Change x-axis label
  labs(x = "Wind Speed (mph)") +
  # Change y-axis label
  labs(y = "Ozone (ppb)") +
  # Add title and subtitle
  labs(
    title = "Relationship between ozone and wind speed in New York",
    subtitle = "May to September 1973"
  )
```
#
#
#
#
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "21"

# Create a canvas for the plot
ggplot(data = airquality) + 
  # Add x-axis
  aes(x = Wind) +
  # Add y-axis
  aes(y = Ozone) + 
  # Add a scatter plot
  geom_point() +
  # Add a regression line
  geom_smooth(method = "lm") +
  # Change x-axis label
  labs(x = "Wind Speed (mph)") +
  # Change y-axis label
  labs(y = "Ozone (ppb)") +
  # Add title and subtitle
  labs(
    title = "Relationship between ozone and wind speed in New York",
    subtitle = "May to September 1973"
  ) +
  # Add caption
  labs(caption = "Data source:")
```
#
#
#
#
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "23"

# Create a canvas for the plot
ggplot(data = airquality) + 
  # Add x-axis
  aes(x = Wind) +
  # Add y-axis
  aes(y = Ozone) + 
  # Add a scatter plot
  geom_point() +
  # Add a regression line
  geom_smooth(method = "lm") +
  # Change x-axis label
  labs(x = "Wind Speed (mph)") +
  # Change y-axis label
  labs(y = "Ozone (ppb)") +
  # Add title and subtitle
  labs(
    title = "Relationship between ozone and wind speed in New York",
    subtitle = "May to September 1973"
  ) +
  # Add caption
  labs(caption = "Data source:") +
  # Set the theme
  theme_bw() 
```
#
#
#
#
#| autorun: true
#| warning: false
#| output-location: column
#| fig-width: 6
#| fig-height: 4
#| code-line-numbers: "25,26,27,28"

# Create a canvas for the plot
ggplot(data = airquality) + 
  # Add x-axis
  aes(x = Wind) +
  # Add y-axis
  aes(y = Ozone) + 
  # Add a scatter plot
  geom_point() +
  # Add a regression line
  geom_smooth(method = "lm") +
  # Change x-axis label
  labs(x = "Wind Speed (mph)") +
  # Change y-axis label
  labs(y = "Ozone (ppb)") +
  # Add title and subtitle
  labs(
    title = "Relationship between ozone and wind speed in New York",
    subtitle = "May to September 1973"
  ) +
  # Add caption
  labs(caption = "Data source:") +
  # Set the theme
  theme_bw() +
  # Set the title and subtitle position
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
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
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
?airquality
head(airquality)
#
#
#
#
#
#
#
#
#
#| label: basics
#| autorun: true
#| echo: false
#| fig-width: 5
#| fig-height: 4

ggplot(airquality)+
  geom_point(aes(x = Temp, y = Ozone))
#
#
#
#
#
#
#
#
#
#
#
#
#
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
#| echo: false
#| fig-width: 5
#| fig-height: 4

ggplot(airquality)+
  geom_point(aes(x = Temp, y = Ozone))
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
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
