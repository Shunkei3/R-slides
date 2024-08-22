---
title: "Day4: Regression Analysis and Reporting Results"
subtitle: "Department of Applied Economics, University of Minnesota"
author: "Shunkei Kakimoto"
format: 
  revealjs:
    self-contained: false
    slide-number: c/t
    width: 1600
    height: 900
    theme: 
      - default 
      - ../slide_style/styles.scss
    fontsize: 1.5em
    callout-icon: false
    scrollable: true
    code-overflow: wrap
    echo: true
    eval: true
    cache: false
    warning: false
    message: false
    multiplex: true
    code-link: true
    title-slide-attributes:
      data-background-color: "#447099"
    fig-dpi: 400
    chalkboard: true
    preview-links: true
webr:
  packages: ["data.table", "ggplot2", "dplyr", "modelsummary", "AER", "wooldridge"]
  cell-options:
    editor-font-scale: 0.8
filters:
  - webr
---



## Recap {.center}

So far, we have learned...

+ The basic types of data structures in R, and how to create and manipulate them.
+ Data wrangling with `data.table` package.
+ Data visualization with `ggplot2` package.

With the tools we learned so far, you can do a lot of tasks for descriptive data analysis!

Once you have a good understanding of the data, you can move on to the next step: econometric analysis!

## {.center}

### Learning Objectives

Today's goal is to:

+ create a descriptive summary table for the data.
+ use `lm` function to estimate a regression model and report the results with publication-ready summary tables.
+ understand how to create a report document (html and PDF) with Quarto. 

<br>

:::{.fragment .center}
### Reference {.center}
+ `modelsummary` package [See [here](https://modelsummary.com/) for the package documentation]
:::


## Notes {.center}

+ Today's lecture is an introduction to basic regression analysis with R.

+ The more advanced R functions such as `feols()` function from `fixest` package for fixed effects models and `glm()` function for generalized linear models will be covered in the Econometric class (APEC 8211-8214).
  + But the basic syntax are the same. So, you can easily apply the knowledge you learn today to the more advanced functions.

<br>

<!-- ::: {.callout-note}
+ Personally, I always use `feols()` function from `fixest` package whenever I run a regression model in R. 
+ But I will teach the basics first, so I will use the built-in `lm()` function today.
::: -->



## Today's outline: {.center}

1. [Introduction to Regression analysis with R](#introduction-to-regression-analysis-with-r)
2. [Create a summary table](#create-summary-tables)
   1. [Introduction to `modelsummary` package](#modelsummary-package-introduction)
   2. [`modelsummary()` function to report regression results](#modelsummary-function-introduction)
   3. [`modelsummary()` function: Customization](#modelsummary-function-customization)
   4. [`datasummary()` function to report descriptive statistics](#datasummary-function-introduction)
   


# Introduction to Regression analysis with R {#introduction-to-regression-analysis-with-r}

---



::: {.cell autorun='true'}

:::




## Before We Start

We will use the `CPS1988` dataset from the `AER` package. It's a cross-section dataset originating from the March 1988 Current Population Survey by the US Census Bureau. For further information, see `?CPS1988` after loading the package.

Run the following code: 
```{webr-r}
#| autorun: true
library(AER)
data(CPS1988)

# I prefer to convert the data to data.table. 
setDT(CPS1988)

# For practice, I converted some factor variables into character variables.
CPS1988[,`:=`(
  ethnicity = as.character(ethnicity),
  region = as.character(region),
  parttime = as.character(parttime)
)]
```










## Introduction to Regression Analysis with R

<!-- start: Introduction to lm() function -->
:::{.panel-tabset}
### Basics of lm()

The most basic function to estimate a linear regression model in R is the `lm` function from `stats` package, which is a built-in R package.

<br>

Suppose we have a regression model of the form:
$$Y = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + e$$

<br>

With the `lm` function, we can estimate the above model as follows:


::: {.cell}

```{.r .cell-code}
# Example R-code
lm(formula = Y ~ X1 + X2, data = dataset)
```
:::



<br>

::: {.callout-note}
+ In the first argument of the `lm` function, you specify the formula of the regression model.
+ The intercept is included by default. So, you don't need to include it in the formula.
+ `~` splits the left side and right side in a formula.  
:::

::: {.notes}
+ There are many ways to estimate a regression model in R. 
+ The basic one is to use the `lm` function.
:::


### Example 

Let's estimate the following model with the `CPS1988` data:

$$wage = \beta_0 + \beta_1 education + \beta_2 experience + e$$

<br>

```{webr-r}
# Your turn. What is the code? What does the output look like? Can you find any other information other than the estimated coefficients?

reg <- # write your code here
```

:::{.notes}
+ The output looks so simple. 
+ But the the output of `lm` function contains a lot of information other than the estimated coefficients.
+ See `names()` (or `ls()`). Or you can see the information stored in the 
:::

### Summary Results

To see the summary of the regression results, use the `summary` function.

```{webr-r}
reg <- lm(formula= wage ~ education + experience, data = CPS1988)
reg_summary <- summary(reg)
```


### Extracting Information

The results from `lm()` and `summary()` contain a lot of information (In your Rstudio, you can check them on the Environment pane). 

```{webr-r}
# See the objects stored in the results of lm() function. 
ls(reg)
# See the objects stored inside the result of summary() function
ls(reg_summary)
```


[You can access any information stored in  object via the `$` operator.]{style="color: blue"}

::: {.panel-tabset}

### Example 1: Extract the fitted values

```{webr-r}
fitted_values <- reg$fitted.values
```

### Example 2: The coefficient estimates

```{webr-r}
coef_estimates <- reg$coefficients
# or you can use the `coef` function (from the same package for `lm` function)
# coef_estimates <- coef(reg)
```

###  Example 3: The coefficient estimates with standard errors and t-statistics. 

```{webr-r}
tbl_coef_estimates <- reg_summary$coefficients
```

:::

### Your Turn

Let's get the value of the standard error of the coefficient estimate of `education`.


```{webr-r}
# You can write your code here.

```

<!-- end: Introduction to lm() function -->
:::


## Regression with Various Functional Forms

### Basics

+ To include interaction terms and quadratic terms in the formula in `lm()` function, use the `I()` function.
+ For log transformation, use the `log()` function in the formula. 
+ Or you define a new variable with the transformed variable and include it in the formula.


**Example:**

To estimate: 
$$log(wage) = \beta_0 + \beta_1 education + \beta_2 experience + \beta3 experience ^2 + e$$

```{webr-r}
lm(log(wage) ~ education + experience + I(experience^2), data = CPS1988) %>%
  summary()
```


## Categorical Variables

<!-- start panel: categorical -->
::: {.panel-tabset}

### Basics

What if we want to include a categorical variable (e.g., `region`, `parttime`, `ethnicity`) in the regression model? 


`lm()` function is smart enough to convert the categorical variable into dummy variables without any additional coding.

+ Even the variables you want to use as dummy variables are character type, `lm()` function automatically coerced it into a factor variable. 



### Examples
<!-- start panel: example -->
:::{.panel-tabset}

### Two categories

What if we want to include a dummy variable that takes 1 if `parttime` is yes, otherwise 0?

The model is as follows:
$$
log(wage) = \beta_0  + \beta_1 education + \beta_2 experience + \beta_3 experience^2 + \beta_4 d_{parttime, yes} + e
$$


```{webr-r}
lm(log(wage) ~ education + experience + I(experience^2) + parttime, data = CPS1988) %>%
  summary()
```


### More than Two Categories

What if we want to include dummy variables for each `region`?

```{webr-r}
# 
CPS1988[region := relevel(region, ref = "south")]

cps_region <- lm(log(wage) ~ ethnicity + education + experience + I(experience^2) + region, data = CPS1988) %>%
  summary()
```

<!-- end panel: example -->
:::


### Set the Base Group

By default, R picks the first group in the alphabetical order for the base group.

You can use `relevel()` function (a built-in R function) to set the base group of the categorical variable.

**Syntax:**


::: {.cell}

```{.r .cell-code}
relevel(factor_variable, ref = "base_group")
```
:::



<br>

**Example:**

Let's compare the two regression results: 

+ use `parttime==yes` as the base group
+ use `parttime==no` as the base group

```{webr-r}
# 1. Use the group with parttime==no as the base group (default)
CPS1988[, parttime := relevel(as.factor(parttime), ref = "no")]
# check 
unique(CPS1988$parttime)

lm(log(wage) ~ ethnicity + education + experience + I(experience^2) + parttime, data = CPS1988) %>%
  summary(.) %>%
  .$coefficients

# 2. Use the group with parttime==Yes as the base group
CPS1988[, parttime := relevel(as.factor(parttime), ref = "yes")]

# check 
unique(CPS1988$parttime)

lm(log(wage) ~ ethnicity + education + experience + I(experience^2) + parttime, data = CPS1988) %>%
  summary() %>%
  .$coefficients
```

<!-- end panel: categorical -->
:::

## Prediction

To do prediction with the estimated model on a new dataset, you can use the `predict` function (built-in R function).

**Syntax**



::: {.cell}

```{.r .cell-code}
predict(lm_object, newdata = new_dataset)
```
:::




**Example**

```{webr-r}
reg <- lm(log(wage) ~ experience + I(experience^2), data = CPS1988)

new_data <- 
  data.table(
    experience = seq(from = 10, to = max(CPS1988$experience), by = 0.5)
  )

new_data[, predicted_wage := predict(reg, newdata = new_data)]

# visualize the predicted values
ggplot(new_data) +
  geom_point(aes(x = experience, y = predicted_wage), color = "blue") +
  theme_bw()
```


## Key Points {.center}

You should at least know these key points:

+ the basic usage of `lm()` and `summary()` function.
+ how to retrieve the information stored in the outputs of `lm()` and `summary()` functions. 
+ how to include log-transformed variable, interaction terms and quadratic terms in the formula of `lm()` function.
+ how to include categorical variables in the formula of `lm()` function, and how to set the base group.
+ how to do prediction with the estimated model on a new dataset.

That's it!


# Create Publication-Ready Summary Tables {#create-summary-tables}

## Before Starting {.center}

+ After running some regression models, ultimately you want to report the results in a neat table.

+ Usually, we report the regression results in a formatted document like the Rmarkdown or Quarto document (html or PDF).

+ So, let's practice how to create a summary table for your analysis results in the Quarto document!

+ From the course website, on the Day 4 page under "Lecture Slides" download and open the document file ["practice_modelsummary_html.qmd"](https://shunkei3.github.io/R-2024-Summer/contents/day4.html). 


## Introduction to `modelsummary` package {#modelsummary-package-introduction}

:::{.panel-tabset}
### Intro
[`modelsummary` package](https://modelsummary.com/) lets you create a nice summary table to report the descriptive statistics of the data and the regression results.

We focus on two functions in the `modelsummary` package:

+ `datasummary()`: to create a summary table for the descriptive statistics of the data.
+ `modelsummary()`: to create a summary table for the regression results.


<!-- Features:

+ present your regression results side by side in the same table.
+ easy to replace the standard errors with the robust ones. 
+ easy to customize the appearance of table.
+ the table can be exported to various formats such as HTML, PDF, and Word. -->

Check the [documentation](https://modelsummary.com/) for more details.

<br>

::: {.callout-note}
+ There is another package called `stargazer` that can create a summary table, but it is not maintained anymore. So, I recommend using `modelsummary` package.
+ `modelsummary` package is compatible with 
:::


### Example

:::{.columns}

:::{.column width="50%"}

### Descriptive Statistics


::: {#tbl-ex1-datasummary .cell tbl-cap='Example of Summary Statistics'}
::: {.cell-output-display}

```{=html}
<div id="vmsnqmrvpk" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#vmsnqmrvpk table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#vmsnqmrvpk thead, #vmsnqmrvpk tbody, #vmsnqmrvpk tfoot, #vmsnqmrvpk tr, #vmsnqmrvpk td, #vmsnqmrvpk th {
  border-style: none;
}

#vmsnqmrvpk p {
  margin: 0;
  padding: 0;
}

#vmsnqmrvpk .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#vmsnqmrvpk .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#vmsnqmrvpk .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#vmsnqmrvpk .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#vmsnqmrvpk .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#vmsnqmrvpk .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vmsnqmrvpk .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#vmsnqmrvpk .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#vmsnqmrvpk .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#vmsnqmrvpk .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#vmsnqmrvpk .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#vmsnqmrvpk .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#vmsnqmrvpk .gt_spanner_row {
  border-bottom-style: hidden;
}

#vmsnqmrvpk .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#vmsnqmrvpk .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#vmsnqmrvpk .gt_from_md > :first-child {
  margin-top: 0;
}

#vmsnqmrvpk .gt_from_md > :last-child {
  margin-bottom: 0;
}

#vmsnqmrvpk .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#vmsnqmrvpk .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#vmsnqmrvpk .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#vmsnqmrvpk .gt_row_group_first td {
  border-top-width: 2px;
}

#vmsnqmrvpk .gt_row_group_first th {
  border-top-width: 2px;
}

#vmsnqmrvpk .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#vmsnqmrvpk .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#vmsnqmrvpk .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#vmsnqmrvpk .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vmsnqmrvpk .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#vmsnqmrvpk .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#vmsnqmrvpk .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#vmsnqmrvpk .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#vmsnqmrvpk .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#vmsnqmrvpk .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#vmsnqmrvpk .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#vmsnqmrvpk .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#vmsnqmrvpk .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#vmsnqmrvpk .gt_left {
  text-align: left;
}

#vmsnqmrvpk .gt_center {
  text-align: center;
}

#vmsnqmrvpk .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#vmsnqmrvpk .gt_font_normal {
  font-weight: normal;
}

#vmsnqmrvpk .gt_font_bold {
  font-weight: bold;
}

#vmsnqmrvpk .gt_font_italic {
  font-style: italic;
}

#vmsnqmrvpk .gt_super {
  font-size: 65%;
}

#vmsnqmrvpk .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#vmsnqmrvpk .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#vmsnqmrvpk .gt_indent_1 {
  text-indent: 5px;
}

#vmsnqmrvpk .gt_indent_2 {
  text-indent: 10px;
}

#vmsnqmrvpk .gt_indent_3 {
  text-indent: 15px;
}

#vmsnqmrvpk .gt_indent_4 {
  text-indent: 20px;
}

#vmsnqmrvpk .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Min">Min</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Max">Max</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">Wage</td>
<td headers="Mean" class="gt_row gt_right">603.73</td>
<td headers="SD" class="gt_row gt_right">453.55</td>
<td headers="Min" class="gt_row gt_right">50.05</td>
<td headers="Max" class="gt_row gt_right">18777.20</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Education</td>
<td headers="Mean" class="gt_row gt_right">13.07</td>
<td headers="SD" class="gt_row gt_right">2.90</td>
<td headers="Min" class="gt_row gt_right">0.00</td>
<td headers="Max" class="gt_row gt_right">18.00</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience</td>
<td headers="Mean" class="gt_row gt_right">18.20</td>
<td headers="SD" class="gt_row gt_right">13.08</td>
<td headers="Min" class="gt_row gt_right">-4.00</td>
<td headers="Max" class="gt_row gt_right">63.00</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::



:::

:::{.column width="50%"}
### Regression Summary Table



::: {#tbl-ex2-datasummary .cell tbl-cap='Example regression results'}
::: {.cell-output-display}

```{=html}
<div id="itewcyjfmi" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#itewcyjfmi table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#itewcyjfmi thead, #itewcyjfmi tbody, #itewcyjfmi tfoot, #itewcyjfmi tr, #itewcyjfmi td, #itewcyjfmi th {
  border-style: none;
}

#itewcyjfmi p {
  margin: 0;
  padding: 0;
}

#itewcyjfmi .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#itewcyjfmi .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#itewcyjfmi .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#itewcyjfmi .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#itewcyjfmi .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#itewcyjfmi .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#itewcyjfmi .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#itewcyjfmi .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#itewcyjfmi .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#itewcyjfmi .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#itewcyjfmi .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#itewcyjfmi .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#itewcyjfmi .gt_spanner_row {
  border-bottom-style: hidden;
}

#itewcyjfmi .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#itewcyjfmi .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#itewcyjfmi .gt_from_md > :first-child {
  margin-top: 0;
}

#itewcyjfmi .gt_from_md > :last-child {
  margin-bottom: 0;
}

#itewcyjfmi .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#itewcyjfmi .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#itewcyjfmi .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#itewcyjfmi .gt_row_group_first td {
  border-top-width: 2px;
}

#itewcyjfmi .gt_row_group_first th {
  border-top-width: 2px;
}

#itewcyjfmi .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#itewcyjfmi .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#itewcyjfmi .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#itewcyjfmi .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#itewcyjfmi .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#itewcyjfmi .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#itewcyjfmi .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#itewcyjfmi .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#itewcyjfmi .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#itewcyjfmi .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#itewcyjfmi .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#itewcyjfmi .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#itewcyjfmi .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#itewcyjfmi .gt_left {
  text-align: left;
}

#itewcyjfmi .gt_center {
  text-align: center;
}

#itewcyjfmi .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#itewcyjfmi .gt_font_normal {
  font-weight: normal;
}

#itewcyjfmi .gt_font_bold {
  font-weight: bold;
}

#itewcyjfmi .gt_font_italic {
  font-style: italic;
}

#itewcyjfmi .gt_super {
  font-size: 65%;
}

#itewcyjfmi .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#itewcyjfmi .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#itewcyjfmi .gt_indent_1 {
  text-indent: 5px;
}

#itewcyjfmi .gt_indent_2 {
  text-indent: 10px;
}

#itewcyjfmi .gt_indent_3 {
  text-indent: 15px;
}

#itewcyjfmi .gt_indent_4 {
  text-indent: 20px;
}

#itewcyjfmi .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 1">OLS 1</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 2">OLS 2</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 3">OLS 3</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">Education</td>
<td headers="OLS 1" class="gt_row gt_center">0.076***</td>
<td headers="OLS 2" class="gt_row gt_center">0.087***</td>
<td headers="OLS 3" class="gt_row gt_center">0.086***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.001)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td>
<td headers="OLS 3" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">0.078***</td>
<td headers="OLS 3" class="gt_row gt_center">0.077***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td>
<td headers="OLS 3" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience squared</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">-0.001***</td>
<td headers="OLS 3" class="gt_row gt_center">-0.001***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">(0.000)</td>
<td headers="OLS 3" class="gt_row gt_center">(0.000)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">White</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center"></td>
<td headers="OLS 3" class="gt_row gt_center">-0.243***</td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 1" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 2" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 3" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.013)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="OLS 1" class="gt_row gt_center">28155</td>
<td headers="OLS 2" class="gt_row gt_center">28155</td>
<td headers="OLS 3" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td>
<td headers="OLS 3" class="gt_row gt_center">0.335</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td>
<td headers="OLS 3" class="gt_row gt_center">0.335</td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="4">* p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td>
    </tr>
    <tr>
      <td class="gt_sourcenote" colspan="4">Std. Errors in parentheses</td>
    </tr>
  </tfoot>
  
</table>
</div>
```

:::
:::


:::

:::

:::


## modelsummary() function to report regression results {#modelsummary-function-introduction}
<!-- start panel: `modelsummary()` function -->
:::{.panel-tabset}

### Basics

The very basic argument of the `modelsummary()` function is the `models` argument, which takes **a list of regression models** you want to report in the table.

```r
# --- 1. Estimate regression models --- #
lm1 <- lm(y ~ x1, data = dataset)
lm2 <- lm(y ~ x1 + x2, data = dataset)
lm3 <- lm(y ~ x1 + x2 + x3, data = dataset)

# --- 2. Then, provide those a list of lm objects in the "models" argument  --- #
modelsummary(models=list(lm1, lm2, lm3))
```


### Default Appearance
:::{.columns}
:::{.column width="50%"}
**Example**



::: {.cell}

```{.r .cell-code}
reg1 <- lm(log(wage) ~ education, data = CPS1988)
reg2 <- lm(log(wage) ~ education + experience + I(experience^2), data = CPS1988)

modelsummary(models=list(reg1, reg2))
```
:::


:::

:::{.column width="50%"}



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="sihylicowh" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#sihylicowh table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#sihylicowh thead, #sihylicowh tbody, #sihylicowh tfoot, #sihylicowh tr, #sihylicowh td, #sihylicowh th {
  border-style: none;
}

#sihylicowh p {
  margin: 0;
  padding: 0;
}

#sihylicowh .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#sihylicowh .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#sihylicowh .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#sihylicowh .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#sihylicowh .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#sihylicowh .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#sihylicowh .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#sihylicowh .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#sihylicowh .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#sihylicowh .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#sihylicowh .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#sihylicowh .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#sihylicowh .gt_spanner_row {
  border-bottom-style: hidden;
}

#sihylicowh .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#sihylicowh .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#sihylicowh .gt_from_md > :first-child {
  margin-top: 0;
}

#sihylicowh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#sihylicowh .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#sihylicowh .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#sihylicowh .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#sihylicowh .gt_row_group_first td {
  border-top-width: 2px;
}

#sihylicowh .gt_row_group_first th {
  border-top-width: 2px;
}

#sihylicowh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#sihylicowh .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#sihylicowh .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#sihylicowh .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#sihylicowh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#sihylicowh .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#sihylicowh .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#sihylicowh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#sihylicowh .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#sihylicowh .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#sihylicowh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#sihylicowh .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#sihylicowh .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#sihylicowh .gt_left {
  text-align: left;
}

#sihylicowh .gt_center {
  text-align: center;
}

#sihylicowh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#sihylicowh .gt_font_normal {
  font-weight: normal;
}

#sihylicowh .gt_font_bold {
  font-weight: bold;
}

#sihylicowh .gt_font_italic {
  font-style: italic;
}

#sihylicowh .gt_super {
  font-size: 65%;
}

#sihylicowh .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#sihylicowh .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#sihylicowh .gt_indent_1 {
  text-indent: 5px;
}

#sihylicowh .gt_indent_2 {
  text-indent: 10px;
}

#sihylicowh .gt_indent_3 {
  text-indent: 15px;
}

#sihylicowh .gt_indent_4 {
  text-indent: 20px;
}

#sihylicowh .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="(1)">(1)</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="(2)">(2)</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">(Intercept)</td>
<td headers="(1)" class="gt_row gt_center">5.178</td>
<td headers="(2)" class="gt_row gt_center">4.278</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="(1)" class="gt_row gt_center">(0.019)</td>
<td headers="(2)" class="gt_row gt_center">(0.019)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">education</td>
<td headers="(1)" class="gt_row gt_center">0.076</td>
<td headers="(2)" class="gt_row gt_center">0.087</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="(1)" class="gt_row gt_center">(0.001)</td>
<td headers="(2)" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">experience</td>
<td headers="(1)" class="gt_row gt_center"></td>
<td headers="(2)" class="gt_row gt_center">0.078</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="(1)" class="gt_row gt_center"></td>
<td headers="(2)" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">I(experience^2)</td>
<td headers="(1)" class="gt_row gt_center"></td>
<td headers="(2)" class="gt_row gt_center">-0.001</td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="(1)" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="(2)" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.000)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="(1)" class="gt_row gt_center">28155</td>
<td headers="(2)" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="(1)" class="gt_row gt_center">0.095</td>
<td headers="(2)" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="(1)" class="gt_row gt_center">0.095</td>
<td headers="(2)" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">AIC</td>
<td headers="(1)" class="gt_row gt_center">405753.0</td>
<td headers="(2)" class="gt_row gt_center">397432.7</td></tr>
    <tr><td headers=" " class="gt_row gt_left">BIC</td>
<td headers="(1)" class="gt_row gt_center">405777.7</td>
<td headers="(2)" class="gt_row gt_center">397473.9</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Log.Lik.</td>
<td headers="(1)" class="gt_row gt_center">-29139.853</td>
<td headers="(2)" class="gt_row gt_center">-24977.715</td></tr>
    <tr><td headers=" " class="gt_row gt_left">F</td>
<td headers="(1)" class="gt_row gt_center">2941.787</td>
<td headers="(2)" class="gt_row gt_center">4545.929</td></tr>
    <tr><td headers=" " class="gt_row gt_left">RMSE</td>
<td headers="(1)" class="gt_row gt_center">0.68</td>
<td headers="(2)" class="gt_row gt_center">0.59</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::


:::
:::
<!-- end panel: `modelsummary()` function -->
:::


## modelsummary() function: Customization {#modelsummary-function-customization}

:::{.panel-tabset}

### List of Options

The default table is okay. But you can customize the appearance of the table. Here, I listed the bare minimum of options you might want to know (There are lots of other options!).

+ `models`: you can change the name of the models
+ `coef_map`: to reorder coefficient rows and change their labels
+ `stars`: to change the significance stars
+ `vcov`: to replace the standard errors with the robust ones (we will see this later)
+ `gof_map`: to define which model statistics to display
+ `gof_omit`: to define which model statistics to omit from the default selection of model statistics
+ `notes`: to add notes at the bottom of the table
+ `fmt`: change the format of numbers

<br>

::: {.callout-note}
+ See `?modelsummary` for more details or see [this](https://modelsummary.com/reference/modelsummary.html).
+ Also check the vignette of the function from [here](https://modelsummary.com/vignettes/modelsummary.html).
:::

### models

By naming the models when you make a list of regression models, you can change the name of the models in the table.

**Example**

:::{.columns}
:::{.column width="50%"}


::: {.cell}

```{.r .cell-code  code-line-numbers="4"}
reg1 <- lm(log(wage) ~ education, data = CPS1988)
reg2 <- lm(log(wage) ~ education + experience + I(experience^2), data = CPS1988)

ls_regs <- list("OLS 1" = reg1, "OLS 2" = reg2)

modelsummary(models = ls_models)
```
:::


:::
:::{.column width="50%"}


::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="eilhjouwdc" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#eilhjouwdc table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#eilhjouwdc thead, #eilhjouwdc tbody, #eilhjouwdc tfoot, #eilhjouwdc tr, #eilhjouwdc td, #eilhjouwdc th {
  border-style: none;
}

#eilhjouwdc p {
  margin: 0;
  padding: 0;
}

#eilhjouwdc .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#eilhjouwdc .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#eilhjouwdc .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#eilhjouwdc .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#eilhjouwdc .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#eilhjouwdc .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#eilhjouwdc .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#eilhjouwdc .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#eilhjouwdc .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#eilhjouwdc .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#eilhjouwdc .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#eilhjouwdc .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#eilhjouwdc .gt_spanner_row {
  border-bottom-style: hidden;
}

#eilhjouwdc .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#eilhjouwdc .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#eilhjouwdc .gt_from_md > :first-child {
  margin-top: 0;
}

#eilhjouwdc .gt_from_md > :last-child {
  margin-bottom: 0;
}

#eilhjouwdc .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#eilhjouwdc .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#eilhjouwdc .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#eilhjouwdc .gt_row_group_first td {
  border-top-width: 2px;
}

#eilhjouwdc .gt_row_group_first th {
  border-top-width: 2px;
}

#eilhjouwdc .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#eilhjouwdc .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#eilhjouwdc .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#eilhjouwdc .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#eilhjouwdc .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#eilhjouwdc .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#eilhjouwdc .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#eilhjouwdc .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#eilhjouwdc .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#eilhjouwdc .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#eilhjouwdc .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#eilhjouwdc .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#eilhjouwdc .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#eilhjouwdc .gt_left {
  text-align: left;
}

#eilhjouwdc .gt_center {
  text-align: center;
}

#eilhjouwdc .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#eilhjouwdc .gt_font_normal {
  font-weight: normal;
}

#eilhjouwdc .gt_font_bold {
  font-weight: bold;
}

#eilhjouwdc .gt_font_italic {
  font-style: italic;
}

#eilhjouwdc .gt_super {
  font-size: 65%;
}

#eilhjouwdc .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#eilhjouwdc .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#eilhjouwdc .gt_indent_1 {
  text-indent: 5px;
}

#eilhjouwdc .gt_indent_2 {
  text-indent: 10px;
}

#eilhjouwdc .gt_indent_3 {
  text-indent: 15px;
}

#eilhjouwdc .gt_indent_4 {
  text-indent: 20px;
}

#eilhjouwdc .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 1">OLS 1</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 2">OLS 2</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">(Intercept)</td>
<td headers="OLS 1" class="gt_row gt_center">5.178</td>
<td headers="OLS 2" class="gt_row gt_center">4.278</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.019)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.019)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">education</td>
<td headers="OLS 1" class="gt_row gt_center">0.076</td>
<td headers="OLS 2" class="gt_row gt_center">0.087</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.001)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">experience</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">0.078</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">I(experience^2)</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">-0.001</td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 1" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 2" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.000)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="OLS 1" class="gt_row gt_center">28155</td>
<td headers="OLS 2" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">AIC</td>
<td headers="OLS 1" class="gt_row gt_center">405753.0</td>
<td headers="OLS 2" class="gt_row gt_center">397432.7</td></tr>
    <tr><td headers=" " class="gt_row gt_left">BIC</td>
<td headers="OLS 1" class="gt_row gt_center">405777.7</td>
<td headers="OLS 2" class="gt_row gt_center">397473.9</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Log.Lik.</td>
<td headers="OLS 1" class="gt_row gt_center">-29139.853</td>
<td headers="OLS 2" class="gt_row gt_center">-24977.715</td></tr>
    <tr><td headers=" " class="gt_row gt_left">F</td>
<td headers="OLS 1" class="gt_row gt_center">2941.787</td>
<td headers="OLS 2" class="gt_row gt_center">4545.929</td></tr>
    <tr><td headers=" " class="gt_row gt_left">RMSE</td>
<td headers="OLS 1" class="gt_row gt_center">0.68</td>
<td headers="OLS 2" class="gt_row gt_center">0.59</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::


:::
:::

### coef_map

`coef_map` argument lets you subset, rename, and reorder coefficients. In the argument, you specify a named or unnamed character vector. If named vector is supplied, its values are used as the new names of the variable. 


**Example**

In this example, I renamed the variables and moved the `intercept` row to the bottom row.

:::{.columns}
:::{.column width="50%"}


::: {.cell}

```{.r .cell-code  code-line-numbers="8-12"}
modelsummary(
  models =  list("OLS 1" = reg1, "OLS 2" = reg2),
  coef_map = c(
    "education" = "Education", 
    "experience" = "Experience", 
    "I(experience^2)" = "Experience squared",
    "(Intercept)" = "Intercept"
    )
  )
```
:::


:::

:::{.column width="50%"}


::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="kznubyewpt" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#kznubyewpt table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#kznubyewpt thead, #kznubyewpt tbody, #kznubyewpt tfoot, #kznubyewpt tr, #kznubyewpt td, #kznubyewpt th {
  border-style: none;
}

#kznubyewpt p {
  margin: 0;
  padding: 0;
}

#kznubyewpt .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#kznubyewpt .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#kznubyewpt .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#kznubyewpt .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#kznubyewpt .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kznubyewpt .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kznubyewpt .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kznubyewpt .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#kznubyewpt .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#kznubyewpt .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#kznubyewpt .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#kznubyewpt .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#kznubyewpt .gt_spanner_row {
  border-bottom-style: hidden;
}

#kznubyewpt .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#kznubyewpt .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#kznubyewpt .gt_from_md > :first-child {
  margin-top: 0;
}

#kznubyewpt .gt_from_md > :last-child {
  margin-bottom: 0;
}

#kznubyewpt .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#kznubyewpt .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#kznubyewpt .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#kznubyewpt .gt_row_group_first td {
  border-top-width: 2px;
}

#kznubyewpt .gt_row_group_first th {
  border-top-width: 2px;
}

#kznubyewpt .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kznubyewpt .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#kznubyewpt .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#kznubyewpt .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kznubyewpt .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kznubyewpt .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#kznubyewpt .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#kznubyewpt .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#kznubyewpt .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kznubyewpt .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kznubyewpt .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kznubyewpt .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kznubyewpt .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kznubyewpt .gt_left {
  text-align: left;
}

#kznubyewpt .gt_center {
  text-align: center;
}

#kznubyewpt .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#kznubyewpt .gt_font_normal {
  font-weight: normal;
}

#kznubyewpt .gt_font_bold {
  font-weight: bold;
}

#kznubyewpt .gt_font_italic {
  font-style: italic;
}

#kznubyewpt .gt_super {
  font-size: 65%;
}

#kznubyewpt .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#kznubyewpt .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#kznubyewpt .gt_indent_1 {
  text-indent: 5px;
}

#kznubyewpt .gt_indent_2 {
  text-indent: 10px;
}

#kznubyewpt .gt_indent_3 {
  text-indent: 15px;
}

#kznubyewpt .gt_indent_4 {
  text-indent: 20px;
}

#kznubyewpt .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 1">OLS 1</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 2">OLS 2</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">Education</td>
<td headers="OLS 1" class="gt_row gt_center">0.076</td>
<td headers="OLS 2" class="gt_row gt_center">0.087</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.001)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">0.078</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience squared</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">-0.001</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">(0.000)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Intercept</td>
<td headers="OLS 1" class="gt_row gt_center">5.178</td>
<td headers="OLS 2" class="gt_row gt_center">4.278</td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 1" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.019)</td>
<td headers="OLS 2" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.019)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="OLS 1" class="gt_row gt_center">28155</td>
<td headers="OLS 2" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">AIC</td>
<td headers="OLS 1" class="gt_row gt_center">405753.0</td>
<td headers="OLS 2" class="gt_row gt_center">397432.7</td></tr>
    <tr><td headers=" " class="gt_row gt_left">BIC</td>
<td headers="OLS 1" class="gt_row gt_center">405777.7</td>
<td headers="OLS 2" class="gt_row gt_center">397473.9</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Log.Lik.</td>
<td headers="OLS 1" class="gt_row gt_center">-29139.853</td>
<td headers="OLS 2" class="gt_row gt_center">-24977.715</td></tr>
    <tr><td headers=" " class="gt_row gt_left">F</td>
<td headers="OLS 1" class="gt_row gt_center">2941.787</td>
<td headers="OLS 2" class="gt_row gt_center">4545.929</td></tr>
    <tr><td headers=" " class="gt_row gt_left">RMSE</td>
<td headers="OLS 1" class="gt_row gt_center">0.68</td>
<td headers="OLS 2" class="gt_row gt_center">0.59</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::


:::
:::

### stars

`stars = TRUE` shows the significance stars in the table (Try it!). 

If you don't like it, you can modify significance levels and markers by specifying a named numeric vector (e.g., `stars  =  c("*" = .05, "**" = .01, "***" = .001)`).


**Example**

:::{.columns}
:::{.column width="50%"}


::: {.cell}

```{.r .cell-code  code-line-numbers="13"}
modelsummary(
  models = list("OLS 1" = reg1, "OLS 2" = reg2),
  coef_map = c(
    "education" = "Education", 
    "experience" = "Experience", 
    "I(experience^2)" = "Experience squared",
    "(Intercept)" = "Intercept"
    ),
  stars  =  c("*" = .05, "**" = .01, "***" = .001), 
  )
```
:::


:::
:::{.column width="50%"}


::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="prpcfrfgyy" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#prpcfrfgyy table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#prpcfrfgyy thead, #prpcfrfgyy tbody, #prpcfrfgyy tfoot, #prpcfrfgyy tr, #prpcfrfgyy td, #prpcfrfgyy th {
  border-style: none;
}

#prpcfrfgyy p {
  margin: 0;
  padding: 0;
}

#prpcfrfgyy .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#prpcfrfgyy .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#prpcfrfgyy .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#prpcfrfgyy .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#prpcfrfgyy .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#prpcfrfgyy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#prpcfrfgyy .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#prpcfrfgyy .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#prpcfrfgyy .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#prpcfrfgyy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#prpcfrfgyy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#prpcfrfgyy .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#prpcfrfgyy .gt_spanner_row {
  border-bottom-style: hidden;
}

#prpcfrfgyy .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#prpcfrfgyy .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#prpcfrfgyy .gt_from_md > :first-child {
  margin-top: 0;
}

#prpcfrfgyy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#prpcfrfgyy .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#prpcfrfgyy .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#prpcfrfgyy .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#prpcfrfgyy .gt_row_group_first td {
  border-top-width: 2px;
}

#prpcfrfgyy .gt_row_group_first th {
  border-top-width: 2px;
}

#prpcfrfgyy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#prpcfrfgyy .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#prpcfrfgyy .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#prpcfrfgyy .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#prpcfrfgyy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#prpcfrfgyy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#prpcfrfgyy .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#prpcfrfgyy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#prpcfrfgyy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#prpcfrfgyy .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#prpcfrfgyy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#prpcfrfgyy .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#prpcfrfgyy .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#prpcfrfgyy .gt_left {
  text-align: left;
}

#prpcfrfgyy .gt_center {
  text-align: center;
}

#prpcfrfgyy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#prpcfrfgyy .gt_font_normal {
  font-weight: normal;
}

#prpcfrfgyy .gt_font_bold {
  font-weight: bold;
}

#prpcfrfgyy .gt_font_italic {
  font-style: italic;
}

#prpcfrfgyy .gt_super {
  font-size: 65%;
}

#prpcfrfgyy .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#prpcfrfgyy .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#prpcfrfgyy .gt_indent_1 {
  text-indent: 5px;
}

#prpcfrfgyy .gt_indent_2 {
  text-indent: 10px;
}

#prpcfrfgyy .gt_indent_3 {
  text-indent: 15px;
}

#prpcfrfgyy .gt_indent_4 {
  text-indent: 20px;
}

#prpcfrfgyy .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 1">OLS 1</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 2">OLS 2</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">Education</td>
<td headers="OLS 1" class="gt_row gt_center">0.076***</td>
<td headers="OLS 2" class="gt_row gt_center">0.087***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.001)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">0.078***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience squared</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">-0.001***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">(0.000)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Intercept</td>
<td headers="OLS 1" class="gt_row gt_center">5.178***</td>
<td headers="OLS 2" class="gt_row gt_center">4.278***</td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 1" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.019)</td>
<td headers="OLS 2" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.019)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="OLS 1" class="gt_row gt_center">28155</td>
<td headers="OLS 2" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">AIC</td>
<td headers="OLS 1" class="gt_row gt_center">405753.0</td>
<td headers="OLS 2" class="gt_row gt_center">397432.7</td></tr>
    <tr><td headers=" " class="gt_row gt_left">BIC</td>
<td headers="OLS 1" class="gt_row gt_center">405777.7</td>
<td headers="OLS 2" class="gt_row gt_center">397473.9</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Log.Lik.</td>
<td headers="OLS 1" class="gt_row gt_center">-29139.853</td>
<td headers="OLS 2" class="gt_row gt_center">-24977.715</td></tr>
    <tr><td headers=" " class="gt_row gt_left">F</td>
<td headers="OLS 1" class="gt_row gt_center">2941.787</td>
<td headers="OLS 2" class="gt_row gt_center">4545.929</td></tr>
    <tr><td headers=" " class="gt_row gt_left">RMSE</td>
<td headers="OLS 1" class="gt_row gt_center">0.68</td>
<td headers="OLS 2" class="gt_row gt_center">0.59</td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="3">* p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td>
    </tr>
  </tfoot>
  
</table>
</div>
```

:::
:::


:::
:::

###  vcov
<!-- start panel: vcov -->

:::{.panel-tabset}

### Basics

`vcov` argument let you replace the non-robust standard errors (default) with the robust one. Here are some options to use the `vcov` argument (see [this](https://modelsummary.com/vignettes/modelsummary.html#vcov) more options).

<br>

:::{.columns}
:::{.column width="50%"}
**option 1**: Supply a list of named variance-covariance matrices:

```r
vcov_reg1 <- vcovHC(reg1, type = "HC1")
vcov_reg2 <- vcovHC(reg2, type = "HC1")

modelsummary(
  models = list("OLS 1" = reg1, "OLS 2" = reg2), 
  vcov = list(vcov_reg1, vcov_reg2)
  )
```
:::

:::{.column width="50%"}
**option 2**: Supply a name or a list of names of variance-covariance estimators (e.g, "HC0", "HC1", "HC2", "HC3", ""HAC"").

```r
modelsummary(
  models = list("OLS 1" = reg1, "OLS 2" = reg2), 
  vcov = "HC1"
  )
```
In this case, HC1 estimator is used for all the models. 
:::
:::

<br>

::: {.callout-note}
By default, `modelsummary()` calculates the robust variance-covariance matrix using the `sandwich` package (`sandwich::vcovHC`, `sandwich::vcovCL`).
:::

### Preparation

First, let's get the heteroscedasticity robust variance-covariance matrix for the regression models.



::: {.cell}

```{.r .cell-code}
reg3 <- lm(log(wage) ~ parttime + ethnicity, data = CPS1988)
reg4 <- lm(log(wage) ~ parttime, data = CPS1988)

# Heteroscedasticity Robust standard errors
library(sandwich)
vcov_reg3 <- vcovHC(reg3, type = "HC1")
vcov_reg4 <- vcovHC(reg4, type = "HC1")
```
:::



### Report robust-standard errors
:::{.columns}

:::{.column width="50%"}

**Before**



::: {.cell}

```{.r .cell-code}
modelsummary(
  models = list("OLS 1" = reg3, "OLS 2" = reg4),
  stars  =  c("*" = .05, "**" = .01, "***" = .001)
  )
```
:::

::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="nvrttyezfl" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#nvrttyezfl table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#nvrttyezfl thead, #nvrttyezfl tbody, #nvrttyezfl tfoot, #nvrttyezfl tr, #nvrttyezfl td, #nvrttyezfl th {
  border-style: none;
}

#nvrttyezfl p {
  margin: 0;
  padding: 0;
}

#nvrttyezfl .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#nvrttyezfl .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#nvrttyezfl .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#nvrttyezfl .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#nvrttyezfl .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nvrttyezfl .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nvrttyezfl .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#nvrttyezfl .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#nvrttyezfl .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#nvrttyezfl .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#nvrttyezfl .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#nvrttyezfl .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#nvrttyezfl .gt_spanner_row {
  border-bottom-style: hidden;
}

#nvrttyezfl .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#nvrttyezfl .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#nvrttyezfl .gt_from_md > :first-child {
  margin-top: 0;
}

#nvrttyezfl .gt_from_md > :last-child {
  margin-bottom: 0;
}

#nvrttyezfl .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#nvrttyezfl .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#nvrttyezfl .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#nvrttyezfl .gt_row_group_first td {
  border-top-width: 2px;
}

#nvrttyezfl .gt_row_group_first th {
  border-top-width: 2px;
}

#nvrttyezfl .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nvrttyezfl .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#nvrttyezfl .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#nvrttyezfl .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nvrttyezfl .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#nvrttyezfl .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#nvrttyezfl .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#nvrttyezfl .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#nvrttyezfl .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#nvrttyezfl .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nvrttyezfl .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nvrttyezfl .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#nvrttyezfl .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#nvrttyezfl .gt_left {
  text-align: left;
}

#nvrttyezfl .gt_center {
  text-align: center;
}

#nvrttyezfl .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#nvrttyezfl .gt_font_normal {
  font-weight: normal;
}

#nvrttyezfl .gt_font_bold {
  font-weight: bold;
}

#nvrttyezfl .gt_font_italic {
  font-style: italic;
}

#nvrttyezfl .gt_super {
  font-size: 65%;
}

#nvrttyezfl .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#nvrttyezfl .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#nvrttyezfl .gt_indent_1 {
  text-indent: 5px;
}

#nvrttyezfl .gt_indent_2 {
  text-indent: 10px;
}

#nvrttyezfl .gt_indent_3 {
  text-indent: 15px;
}

#nvrttyezfl .gt_indent_4 {
  text-indent: 20px;
}

#nvrttyezfl .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 1">OLS 1</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 2">OLS 2</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">(Intercept)</td>
<td headers="OLS 1" class="gt_row gt_center">6.009***</td>
<td headers="OLS 2" class="gt_row gt_center">6.274***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.013)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.004)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">parttimeyes</td>
<td headers="OLS 1" class="gt_row gt_center">-1.152***</td>
<td headers="OLS 2" class="gt_row gt_center">-1.157***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.013)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.013)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">ethnicitycauc</td>
<td headers="OLS 1" class="gt_row gt_center">0.287***</td>
<td headers="OLS 2" class="gt_row gt_center"></td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 1" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.014)</td>
<td headers="OLS 2" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="OLS 1" class="gt_row gt_center">28155</td>
<td headers="OLS 2" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="OLS 1" class="gt_row gt_center">0.225</td>
<td headers="OLS 2" class="gt_row gt_center">0.213</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="OLS 1" class="gt_row gt_center">0.225</td>
<td headers="OLS 2" class="gt_row gt_center">0.213</td></tr>
    <tr><td headers=" " class="gt_row gt_left">AIC</td>
<td headers="OLS 1" class="gt_row gt_center">401377.8</td>
<td headers="OLS 2" class="gt_row gt_center">401799.2</td></tr>
    <tr><td headers=" " class="gt_row gt_left">BIC</td>
<td headers="OLS 1" class="gt_row gt_center">401410.8</td>
<td headers="OLS 2" class="gt_row gt_center">401823.9</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Log.Lik.</td>
<td headers="OLS 1" class="gt_row gt_center">-26951.287</td>
<td headers="OLS 2" class="gt_row gt_center">-27162.944</td></tr>
    <tr><td headers=" " class="gt_row gt_left">F</td>
<td headers="OLS 1" class="gt_row gt_center">4085.846</td>
<td headers="OLS 2" class="gt_row gt_center">7629.916</td></tr>
    <tr><td headers=" " class="gt_row gt_left">RMSE</td>
<td headers="OLS 1" class="gt_row gt_center">0.63</td>
<td headers="OLS 2" class="gt_row gt_center">0.63</td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="3">* p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td>
    </tr>
  </tfoot>
  
</table>
</div>
```

:::
:::


:::


:::{.column width="50%"}
**VCOV swapped**



::: {.cell}

```{.r .cell-code}
modelsummary(
  models = list("OLS 1" = reg3, "OLS 2" = reg4),
  stars  =  c("*" = .05, "**" = .01, "***" = .001), 
  vcov = list(vcov_reg3, vcov_reg4)
  )
```
:::

::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="uicmkjwyiy" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#uicmkjwyiy table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#uicmkjwyiy thead, #uicmkjwyiy tbody, #uicmkjwyiy tfoot, #uicmkjwyiy tr, #uicmkjwyiy td, #uicmkjwyiy th {
  border-style: none;
}

#uicmkjwyiy p {
  margin: 0;
  padding: 0;
}

#uicmkjwyiy .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#uicmkjwyiy .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#uicmkjwyiy .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#uicmkjwyiy .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#uicmkjwyiy .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#uicmkjwyiy .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uicmkjwyiy .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#uicmkjwyiy .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#uicmkjwyiy .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#uicmkjwyiy .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#uicmkjwyiy .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#uicmkjwyiy .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#uicmkjwyiy .gt_spanner_row {
  border-bottom-style: hidden;
}

#uicmkjwyiy .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#uicmkjwyiy .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#uicmkjwyiy .gt_from_md > :first-child {
  margin-top: 0;
}

#uicmkjwyiy .gt_from_md > :last-child {
  margin-bottom: 0;
}

#uicmkjwyiy .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#uicmkjwyiy .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#uicmkjwyiy .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#uicmkjwyiy .gt_row_group_first td {
  border-top-width: 2px;
}

#uicmkjwyiy .gt_row_group_first th {
  border-top-width: 2px;
}

#uicmkjwyiy .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#uicmkjwyiy .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#uicmkjwyiy .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#uicmkjwyiy .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uicmkjwyiy .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#uicmkjwyiy .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#uicmkjwyiy .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#uicmkjwyiy .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#uicmkjwyiy .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uicmkjwyiy .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#uicmkjwyiy .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#uicmkjwyiy .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#uicmkjwyiy .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#uicmkjwyiy .gt_left {
  text-align: left;
}

#uicmkjwyiy .gt_center {
  text-align: center;
}

#uicmkjwyiy .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#uicmkjwyiy .gt_font_normal {
  font-weight: normal;
}

#uicmkjwyiy .gt_font_bold {
  font-weight: bold;
}

#uicmkjwyiy .gt_font_italic {
  font-style: italic;
}

#uicmkjwyiy .gt_super {
  font-size: 65%;
}

#uicmkjwyiy .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#uicmkjwyiy .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#uicmkjwyiy .gt_indent_1 {
  text-indent: 5px;
}

#uicmkjwyiy .gt_indent_2 {
  text-indent: 10px;
}

#uicmkjwyiy .gt_indent_3 {
  text-indent: 15px;
}

#uicmkjwyiy .gt_indent_4 {
  text-indent: 20px;
}

#uicmkjwyiy .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 1">OLS 1</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 2">OLS 2</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">(Intercept)</td>
<td headers="OLS 1" class="gt_row gt_center">6.009***</td>
<td headers="OLS 2" class="gt_row gt_center">6.274***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.013)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.004)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">parttimeyes</td>
<td headers="OLS 1" class="gt_row gt_center">-1.152***</td>
<td headers="OLS 2" class="gt_row gt_center">-1.157***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.015)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.015)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">ethnicitycauc</td>
<td headers="OLS 1" class="gt_row gt_center">0.287***</td>
<td headers="OLS 2" class="gt_row gt_center"></td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 1" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.013)</td>
<td headers="OLS 2" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="OLS 1" class="gt_row gt_center">28155</td>
<td headers="OLS 2" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="OLS 1" class="gt_row gt_center">0.225</td>
<td headers="OLS 2" class="gt_row gt_center">0.213</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="OLS 1" class="gt_row gt_center">0.225</td>
<td headers="OLS 2" class="gt_row gt_center">0.213</td></tr>
    <tr><td headers=" " class="gt_row gt_left">AIC</td>
<td headers="OLS 1" class="gt_row gt_center">401377.8</td>
<td headers="OLS 2" class="gt_row gt_center">401799.2</td></tr>
    <tr><td headers=" " class="gt_row gt_left">BIC</td>
<td headers="OLS 1" class="gt_row gt_center">401410.8</td>
<td headers="OLS 2" class="gt_row gt_center">401823.9</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Log.Lik.</td>
<td headers="OLS 1" class="gt_row gt_center">-26951.287</td>
<td headers="OLS 2" class="gt_row gt_center">-27162.944</td></tr>
    <tr><td headers=" " class="gt_row gt_left">RMSE</td>
<td headers="OLS 1" class="gt_row gt_center">0.63</td>
<td headers="OLS 2" class="gt_row gt_center">0.63</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Std.Errors</td>
<td headers="OLS 1" class="gt_row gt_center">Custom</td>
<td headers="OLS 2" class="gt_row gt_center">Custom</td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="3">* p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td>
    </tr>
  </tfoot>
  
</table>
</div>
```

:::

::: {.cell-output-display}

```{=html}
<div id="unsamnrlit" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#unsamnrlit table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#unsamnrlit thead, #unsamnrlit tbody, #unsamnrlit tfoot, #unsamnrlit tr, #unsamnrlit td, #unsamnrlit th {
  border-style: none;
}

#unsamnrlit p {
  margin: 0;
  padding: 0;
}

#unsamnrlit .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#unsamnrlit .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#unsamnrlit .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#unsamnrlit .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#unsamnrlit .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#unsamnrlit .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#unsamnrlit .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#unsamnrlit .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#unsamnrlit .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#unsamnrlit .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#unsamnrlit .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#unsamnrlit .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#unsamnrlit .gt_spanner_row {
  border-bottom-style: hidden;
}

#unsamnrlit .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#unsamnrlit .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#unsamnrlit .gt_from_md > :first-child {
  margin-top: 0;
}

#unsamnrlit .gt_from_md > :last-child {
  margin-bottom: 0;
}

#unsamnrlit .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#unsamnrlit .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#unsamnrlit .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#unsamnrlit .gt_row_group_first td {
  border-top-width: 2px;
}

#unsamnrlit .gt_row_group_first th {
  border-top-width: 2px;
}

#unsamnrlit .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#unsamnrlit .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#unsamnrlit .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#unsamnrlit .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#unsamnrlit .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#unsamnrlit .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#unsamnrlit .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#unsamnrlit .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#unsamnrlit .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#unsamnrlit .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#unsamnrlit .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#unsamnrlit .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#unsamnrlit .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#unsamnrlit .gt_left {
  text-align: left;
}

#unsamnrlit .gt_center {
  text-align: center;
}

#unsamnrlit .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#unsamnrlit .gt_font_normal {
  font-weight: normal;
}

#unsamnrlit .gt_font_bold {
  font-weight: bold;
}

#unsamnrlit .gt_font_italic {
  font-style: italic;
}

#unsamnrlit .gt_super {
  font-size: 65%;
}

#unsamnrlit .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#unsamnrlit .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#unsamnrlit .gt_indent_1 {
  text-indent: 5px;
}

#unsamnrlit .gt_indent_2 {
  text-indent: 10px;
}

#unsamnrlit .gt_indent_3 {
  text-indent: 15px;
}

#unsamnrlit .gt_indent_4 {
  text-indent: 20px;
}

#unsamnrlit .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 1">OLS 1</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 2">OLS 2</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">(Intercept)</td>
<td headers="OLS 1" class="gt_row gt_center">6.009***</td>
<td headers="OLS 2" class="gt_row gt_center">6.274***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.013)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.004)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">parttimeyes</td>
<td headers="OLS 1" class="gt_row gt_center">-1.152***</td>
<td headers="OLS 2" class="gt_row gt_center">-1.157***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.015)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.015)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">ethnicitycauc</td>
<td headers="OLS 1" class="gt_row gt_center">0.287***</td>
<td headers="OLS 2" class="gt_row gt_center"></td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 1" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.013)</td>
<td headers="OLS 2" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="OLS 1" class="gt_row gt_center">28155</td>
<td headers="OLS 2" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="OLS 1" class="gt_row gt_center">0.225</td>
<td headers="OLS 2" class="gt_row gt_center">0.213</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="OLS 1" class="gt_row gt_center">0.225</td>
<td headers="OLS 2" class="gt_row gt_center">0.213</td></tr>
    <tr><td headers=" " class="gt_row gt_left">AIC</td>
<td headers="OLS 1" class="gt_row gt_center">401377.8</td>
<td headers="OLS 2" class="gt_row gt_center">401799.2</td></tr>
    <tr><td headers=" " class="gt_row gt_left">BIC</td>
<td headers="OLS 1" class="gt_row gt_center">401410.8</td>
<td headers="OLS 2" class="gt_row gt_center">401823.9</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Log.Lik.</td>
<td headers="OLS 1" class="gt_row gt_center">-26951.287</td>
<td headers="OLS 2" class="gt_row gt_center">-27162.944</td></tr>
    <tr><td headers=" " class="gt_row gt_left">F</td>
<td headers="OLS 1" class="gt_row gt_center">3398.751</td>
<td headers="OLS 2" class="gt_row gt_center">6256.864</td></tr>
    <tr><td headers=" " class="gt_row gt_left">RMSE</td>
<td headers="OLS 1" class="gt_row gt_center">0.63</td>
<td headers="OLS 2" class="gt_row gt_center">0.63</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Std.Errors</td>
<td headers="OLS 1" class="gt_row gt_center">HC2</td>
<td headers="OLS 2" class="gt_row gt_center">HC2</td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="3">* p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td>
    </tr>
  </tfoot>
  
</table>
</div>
```

:::
:::


:::
:::

<!-- end panel: vcov -->
:::

### coef_omit

`coef_omit` lets you omit coefficient rows from the default selections. In the argument, you specify a vector of names or row number of variables you want to omit from the table.

+ e.g., `coef_omit = c(2,3,5)`  omits the second, third, and fifth coefficients.

**Example**

Let's remove the intercept from the table.

:::{.columns}
:::{.column width="50%"}


::: {.cell}

```{.r .cell-code  code-line-numbers="13"}
modelsummary(
  models = list("OLS 1" = reg1, "OLS 2" = reg2),
  coef_map = c(
    "education" = "Education", 
    "experience" = "Experience", 
    "I(experience^2)" = "Experience squared",
    "(Intercept)" = "Intercept"
    ),
  stars  =  c("*" = .05, "**" = .01, "***" = .001),
  coef_omit = 1
  )
```
:::


:::
:::{.column width="50%"}


::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="aqmwvdqwjs" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#aqmwvdqwjs table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#aqmwvdqwjs thead, #aqmwvdqwjs tbody, #aqmwvdqwjs tfoot, #aqmwvdqwjs tr, #aqmwvdqwjs td, #aqmwvdqwjs th {
  border-style: none;
}

#aqmwvdqwjs p {
  margin: 0;
  padding: 0;
}

#aqmwvdqwjs .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#aqmwvdqwjs .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#aqmwvdqwjs .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#aqmwvdqwjs .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#aqmwvdqwjs .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#aqmwvdqwjs .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#aqmwvdqwjs .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#aqmwvdqwjs .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#aqmwvdqwjs .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#aqmwvdqwjs .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#aqmwvdqwjs .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#aqmwvdqwjs .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#aqmwvdqwjs .gt_spanner_row {
  border-bottom-style: hidden;
}

#aqmwvdqwjs .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#aqmwvdqwjs .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#aqmwvdqwjs .gt_from_md > :first-child {
  margin-top: 0;
}

#aqmwvdqwjs .gt_from_md > :last-child {
  margin-bottom: 0;
}

#aqmwvdqwjs .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#aqmwvdqwjs .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#aqmwvdqwjs .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#aqmwvdqwjs .gt_row_group_first td {
  border-top-width: 2px;
}

#aqmwvdqwjs .gt_row_group_first th {
  border-top-width: 2px;
}

#aqmwvdqwjs .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#aqmwvdqwjs .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#aqmwvdqwjs .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#aqmwvdqwjs .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#aqmwvdqwjs .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#aqmwvdqwjs .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#aqmwvdqwjs .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#aqmwvdqwjs .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#aqmwvdqwjs .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#aqmwvdqwjs .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#aqmwvdqwjs .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#aqmwvdqwjs .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#aqmwvdqwjs .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#aqmwvdqwjs .gt_left {
  text-align: left;
}

#aqmwvdqwjs .gt_center {
  text-align: center;
}

#aqmwvdqwjs .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#aqmwvdqwjs .gt_font_normal {
  font-weight: normal;
}

#aqmwvdqwjs .gt_font_bold {
  font-weight: bold;
}

#aqmwvdqwjs .gt_font_italic {
  font-style: italic;
}

#aqmwvdqwjs .gt_super {
  font-size: 65%;
}

#aqmwvdqwjs .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#aqmwvdqwjs .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#aqmwvdqwjs .gt_indent_1 {
  text-indent: 5px;
}

#aqmwvdqwjs .gt_indent_2 {
  text-indent: 10px;
}

#aqmwvdqwjs .gt_indent_3 {
  text-indent: 15px;
}

#aqmwvdqwjs .gt_indent_4 {
  text-indent: 20px;
}

#aqmwvdqwjs .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 1">OLS 1</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 2">OLS 2</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">Education</td>
<td headers="OLS 1" class="gt_row gt_center">0.076***</td>
<td headers="OLS 2" class="gt_row gt_center">0.087***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.001)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">0.078***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience squared</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">-0.001***</td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 1" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 2" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.000)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="OLS 1" class="gt_row gt_center">28155</td>
<td headers="OLS 2" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">AIC</td>
<td headers="OLS 1" class="gt_row gt_center">405753.0</td>
<td headers="OLS 2" class="gt_row gt_center">397432.7</td></tr>
    <tr><td headers=" " class="gt_row gt_left">BIC</td>
<td headers="OLS 1" class="gt_row gt_center">405777.7</td>
<td headers="OLS 2" class="gt_row gt_center">397473.9</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Log.Lik.</td>
<td headers="OLS 1" class="gt_row gt_center">-29139.853</td>
<td headers="OLS 2" class="gt_row gt_center">-24977.715</td></tr>
    <tr><td headers=" " class="gt_row gt_left">F</td>
<td headers="OLS 1" class="gt_row gt_center">2941.787</td>
<td headers="OLS 2" class="gt_row gt_center">4545.929</td></tr>
    <tr><td headers=" " class="gt_row gt_left">RMSE</td>
<td headers="OLS 1" class="gt_row gt_center">0.68</td>
<td headers="OLS 2" class="gt_row gt_center">0.59</td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="3">* p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td>
    </tr>
  </tfoot>
  
</table>
</div>
```

:::
:::


:::
:::


### gof_map and gof_omit

By default, the `modelsummary()` function reports lots of model statistics (e.g., $R^2$, $AIC$, $BIC$). You can select or omit the model statistics by specifying the `gof_map` and `gof_omit` arguments.

+ You can see the list of model statistics in `modelsummary()` by running `modelsummary::gof_map`
<br>

**Example**

For example, let's select only the number of observations, $R^2$, and adjusted $R^2$ using the `gof_map` argument.

:::{.columns}
:::{.column width="50%"}


::: {.cell}

```{.r .cell-code  code-line-numbers="13"}
modelsummary(
  models = list("OLS 1" = reg1, "OLS 2" = reg2),
  coef_map = c(
    "education" = "Education", 
    "experience" = "Experience", 
    "I(experience^2)" = "Experience squared"
    ),
  stars  =  c("*" = .05, "**" = .01, "***" = .001),
  gof_map = c("nobs", "r.squared",  "adj.r.squared", "logLik")
  )
```
:::


:::
:::{.column width="50%"}


::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="yyebuuvrgh" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#yyebuuvrgh table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#yyebuuvrgh thead, #yyebuuvrgh tbody, #yyebuuvrgh tfoot, #yyebuuvrgh tr, #yyebuuvrgh td, #yyebuuvrgh th {
  border-style: none;
}

#yyebuuvrgh p {
  margin: 0;
  padding: 0;
}

#yyebuuvrgh .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#yyebuuvrgh .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#yyebuuvrgh .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#yyebuuvrgh .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#yyebuuvrgh .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#yyebuuvrgh .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#yyebuuvrgh .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#yyebuuvrgh .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#yyebuuvrgh .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#yyebuuvrgh .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#yyebuuvrgh .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#yyebuuvrgh .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#yyebuuvrgh .gt_spanner_row {
  border-bottom-style: hidden;
}

#yyebuuvrgh .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#yyebuuvrgh .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#yyebuuvrgh .gt_from_md > :first-child {
  margin-top: 0;
}

#yyebuuvrgh .gt_from_md > :last-child {
  margin-bottom: 0;
}

#yyebuuvrgh .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#yyebuuvrgh .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#yyebuuvrgh .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#yyebuuvrgh .gt_row_group_first td {
  border-top-width: 2px;
}

#yyebuuvrgh .gt_row_group_first th {
  border-top-width: 2px;
}

#yyebuuvrgh .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#yyebuuvrgh .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#yyebuuvrgh .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#yyebuuvrgh .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#yyebuuvrgh .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#yyebuuvrgh .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#yyebuuvrgh .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#yyebuuvrgh .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#yyebuuvrgh .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#yyebuuvrgh .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#yyebuuvrgh .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#yyebuuvrgh .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#yyebuuvrgh .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#yyebuuvrgh .gt_left {
  text-align: left;
}

#yyebuuvrgh .gt_center {
  text-align: center;
}

#yyebuuvrgh .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#yyebuuvrgh .gt_font_normal {
  font-weight: normal;
}

#yyebuuvrgh .gt_font_bold {
  font-weight: bold;
}

#yyebuuvrgh .gt_font_italic {
  font-style: italic;
}

#yyebuuvrgh .gt_super {
  font-size: 65%;
}

#yyebuuvrgh .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#yyebuuvrgh .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#yyebuuvrgh .gt_indent_1 {
  text-indent: 5px;
}

#yyebuuvrgh .gt_indent_2 {
  text-indent: 10px;
}

#yyebuuvrgh .gt_indent_3 {
  text-indent: 15px;
}

#yyebuuvrgh .gt_indent_4 {
  text-indent: 20px;
}

#yyebuuvrgh .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 1">OLS 1</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 2">OLS 2</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">Education</td>
<td headers="OLS 1" class="gt_row gt_center">0.076***</td>
<td headers="OLS 2" class="gt_row gt_center">0.087***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.001)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">0.078***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">(0.001)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience squared</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">-0.001***</td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 1" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 2" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.000)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="OLS 1" class="gt_row gt_center">28155</td>
<td headers="OLS 2" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="3">* p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td>
    </tr>
  </tfoot>
  
</table>
</div>
```

:::
:::


:::
:::

### others

+ `notes` lets you add notes at the bottom of the table.
+ `fmt` lets you change the format of numbers in the table.

**Example**

For example, let's select only the number of observations, $R^2$, and adjusted $R^2$ using the `gof_map` argument.

:::{.columns}
:::{.column width="50%"}
```r
modelsummary(
  models = list("OLS 1" = reg1, "OLS 2" = reg2),
  coef_map = c(
    "education" = "Education", 
    "experience" = "Experience", 
    "I(experience^2)" = "Experience squared"
    ),
  stars  =  c("*" = .05, "**" = .01, "***" = .001),
  gof_map = c("nobs", "r.squared",  "adj.r.squared"),
  notes = list("Std. Errors in parentheses"),
  fmt = 2 #report the numbers with 2 decimal points
  )
```
:::
:::{.column width="50%"}


::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="pgsndqzosg" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#pgsndqzosg table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#pgsndqzosg thead, #pgsndqzosg tbody, #pgsndqzosg tfoot, #pgsndqzosg tr, #pgsndqzosg td, #pgsndqzosg th {
  border-style: none;
}

#pgsndqzosg p {
  margin: 0;
  padding: 0;
}

#pgsndqzosg .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#pgsndqzosg .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#pgsndqzosg .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#pgsndqzosg .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#pgsndqzosg .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#pgsndqzosg .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pgsndqzosg .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#pgsndqzosg .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#pgsndqzosg .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#pgsndqzosg .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#pgsndqzosg .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#pgsndqzosg .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#pgsndqzosg .gt_spanner_row {
  border-bottom-style: hidden;
}

#pgsndqzosg .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#pgsndqzosg .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#pgsndqzosg .gt_from_md > :first-child {
  margin-top: 0;
}

#pgsndqzosg .gt_from_md > :last-child {
  margin-bottom: 0;
}

#pgsndqzosg .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#pgsndqzosg .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#pgsndqzosg .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#pgsndqzosg .gt_row_group_first td {
  border-top-width: 2px;
}

#pgsndqzosg .gt_row_group_first th {
  border-top-width: 2px;
}

#pgsndqzosg .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pgsndqzosg .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#pgsndqzosg .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#pgsndqzosg .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pgsndqzosg .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pgsndqzosg .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#pgsndqzosg .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#pgsndqzosg .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#pgsndqzosg .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pgsndqzosg .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#pgsndqzosg .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#pgsndqzosg .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#pgsndqzosg .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#pgsndqzosg .gt_left {
  text-align: left;
}

#pgsndqzosg .gt_center {
  text-align: center;
}

#pgsndqzosg .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#pgsndqzosg .gt_font_normal {
  font-weight: normal;
}

#pgsndqzosg .gt_font_bold {
  font-weight: bold;
}

#pgsndqzosg .gt_font_italic {
  font-style: italic;
}

#pgsndqzosg .gt_super {
  font-size: 65%;
}

#pgsndqzosg .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#pgsndqzosg .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#pgsndqzosg .gt_indent_1 {
  text-indent: 5px;
}

#pgsndqzosg .gt_indent_2 {
  text-indent: 10px;
}

#pgsndqzosg .gt_indent_3 {
  text-indent: 15px;
}

#pgsndqzosg .gt_indent_4 {
  text-indent: 20px;
}

#pgsndqzosg .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 1">OLS 1</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="OLS 2">OLS 2</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">Education</td>
<td headers="OLS 1" class="gt_row gt_center">0.08***</td>
<td headers="OLS 2" class="gt_row gt_center">0.09***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center">(0.00)</td>
<td headers="OLS 2" class="gt_row gt_center">(0.00)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">0.08***</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">(0.00)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Experience squared</td>
<td headers="OLS 1" class="gt_row gt_center"></td>
<td headers="OLS 2" class="gt_row gt_center">0.00***</td></tr>
    <tr><td headers=" " class="gt_row gt_left" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 1" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;"></td>
<td headers="OLS 2" class="gt_row gt_center" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: #000000;">(0.00)</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Num.Obs.</td>
<td headers="OLS 1" class="gt_row gt_center">28155</td>
<td headers="OLS 2" class="gt_row gt_center">28155</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
    <tr><td headers=" " class="gt_row gt_left">R2 Adj.</td>
<td headers="OLS 1" class="gt_row gt_center">0.095</td>
<td headers="OLS 2" class="gt_row gt_center">0.326</td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="3">* p &lt; 0.05, ** p &lt; 0.01, *** p &lt; 0.001</td>
    </tr>
    <tr>
      <td class="gt_sourcenote" colspan="3">Std. Errors in parentheses</td>
    </tr>
  </tfoot>
  
</table>
</div>
```

:::
:::


:::
:::

:::


## datasummary() function to report descriptive statistics  {#datasummary-function-introduction}

`modelsummary` package has another function called `datasummary()`  that can create a summary table for the descriptive statistics of the data.

<br>

**Example**

:::{.columns}
:::{.column width="50%"}
```r
datasummary(
  formula = 
    (`Metropolitan area` = smsa) * ( 
      wage + education + experience
    ) ~ 
    ethnicity * (Mean + SD),
  data = CPS1988
  )
```
:::

:::{.column width="50%"}


::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="kngxglbavm" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#kngxglbavm table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#kngxglbavm thead, #kngxglbavm tbody, #kngxglbavm tfoot, #kngxglbavm tr, #kngxglbavm td, #kngxglbavm th {
  border-style: none;
}

#kngxglbavm p {
  margin: 0;
  padding: 0;
}

#kngxglbavm .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#kngxglbavm .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#kngxglbavm .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#kngxglbavm .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#kngxglbavm .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kngxglbavm .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kngxglbavm .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kngxglbavm .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#kngxglbavm .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#kngxglbavm .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#kngxglbavm .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#kngxglbavm .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#kngxglbavm .gt_spanner_row {
  border-bottom-style: hidden;
}

#kngxglbavm .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#kngxglbavm .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#kngxglbavm .gt_from_md > :first-child {
  margin-top: 0;
}

#kngxglbavm .gt_from_md > :last-child {
  margin-bottom: 0;
}

#kngxglbavm .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#kngxglbavm .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#kngxglbavm .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#kngxglbavm .gt_row_group_first td {
  border-top-width: 2px;
}

#kngxglbavm .gt_row_group_first th {
  border-top-width: 2px;
}

#kngxglbavm .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kngxglbavm .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#kngxglbavm .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#kngxglbavm .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kngxglbavm .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kngxglbavm .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#kngxglbavm .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#kngxglbavm .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#kngxglbavm .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kngxglbavm .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kngxglbavm .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kngxglbavm .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kngxglbavm .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kngxglbavm .gt_left {
  text-align: left;
}

#kngxglbavm .gt_center {
  text-align: center;
}

#kngxglbavm .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#kngxglbavm .gt_font_normal {
  font-weight: normal;
}

#kngxglbavm .gt_font_bold {
  font-weight: bold;
}

#kngxglbavm .gt_font_italic {
  font-style: italic;
}

#kngxglbavm .gt_super {
  font-size: 65%;
}

#kngxglbavm .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#kngxglbavm .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#kngxglbavm .gt_indent_1 {
  text-indent: 5px;
}

#kngxglbavm .gt_indent_2 {
  text-indent: 10px;
}

#kngxglbavm .gt_indent_3 {
  text-indent: 15px;
}

#kngxglbavm .gt_indent_4 {
  text-indent: 20px;
}

#kngxglbavm .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Metropolitan area">Metropolitan area</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=" "> </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="afam    ">
        <span class="gt_column_spanner">afam    </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="cauc    ">
        <span class="gt_column_spanner">cauc    </span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean ">Mean </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD ">SD </th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Metropolitan area" class="gt_row gt_left">no</td>
<td headers=" " class="gt_row gt_left">wage</td>
<td headers="Mean" class="gt_row gt_right">337.42</td>
<td headers="SD" class="gt_row gt_right">214.57</td>
<td headers="Mean " class="gt_row gt_right">527.31</td>
<td headers="SD " class="gt_row gt_right">419.65</td></tr>
    <tr><td headers="Metropolitan area" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">education</td>
<td headers="Mean" class="gt_row gt_right">11.47</td>
<td headers="SD" class="gt_row gt_right">2.78</td>
<td headers="Mean " class="gt_row gt_right">12.71</td>
<td headers="SD " class="gt_row gt_right">2.69</td></tr>
    <tr><td headers="Metropolitan area" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">experience</td>
<td headers="Mean" class="gt_row gt_right">19.69</td>
<td headers="SD" class="gt_row gt_right">13.87</td>
<td headers="Mean " class="gt_row gt_right">19.05</td>
<td headers="SD " class="gt_row gt_right">13.13</td></tr>
    <tr><td headers="Metropolitan area" class="gt_row gt_left">yes</td>
<td headers=" " class="gt_row gt_left">wage</td>
<td headers="Mean" class="gt_row gt_right">470.38</td>
<td headers="SD" class="gt_row gt_right">324.97</td>
<td headers="Mean " class="gt_row gt_right">649.39</td>
<td headers="SD " class="gt_row gt_right">471.05</td></tr>
    <tr><td headers="Metropolitan area" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">education</td>
<td headers="Mean" class="gt_row gt_right">12.51</td>
<td headers="SD" class="gt_row gt_right">2.73</td>
<td headers="Mean " class="gt_row gt_right">13.28</td>
<td headers="SD " class="gt_row gt_right">2.96</td></tr>
    <tr><td headers="Metropolitan area" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">experience</td>
<td headers="Mean" class="gt_row gt_right">18.54</td>
<td headers="SD" class="gt_row gt_right">13.43</td>
<td headers="Mean " class="gt_row gt_right">17.83</td>
<td headers="SD " class="gt_row gt_right">12.99</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::


:::
:::


## datasummary() function: Introduction

<!-- start panel: datasummary() -->
:::{.panel-tabset}

### Basics

`datasummary()` function creates a summary table for the descriptive statistics of the data.

**Syntax**

```r
datasummary(
  formula = rows ~ columns,
  data = dataset
  )
```

<br>

::: {.callout-note}
+ Just like `lm`, `formula` takes a two-side formula devided by `~`.
+ The left-hand (right-hand) side of the formula describes the rows (columns).
:::

Let's see how it works with an example.

### Example

```r
datasummary(
  formula = wage + education + experience ~ Mean + SD,
  data = CPS1988
  )
```

<br>



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="kutmmrsvbv" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#kutmmrsvbv table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#kutmmrsvbv thead, #kutmmrsvbv tbody, #kutmmrsvbv tfoot, #kutmmrsvbv tr, #kutmmrsvbv td, #kutmmrsvbv th {
  border-style: none;
}

#kutmmrsvbv p {
  margin: 0;
  padding: 0;
}

#kutmmrsvbv .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#kutmmrsvbv .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#kutmmrsvbv .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#kutmmrsvbv .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#kutmmrsvbv .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kutmmrsvbv .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kutmmrsvbv .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#kutmmrsvbv .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#kutmmrsvbv .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#kutmmrsvbv .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#kutmmrsvbv .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#kutmmrsvbv .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#kutmmrsvbv .gt_spanner_row {
  border-bottom-style: hidden;
}

#kutmmrsvbv .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#kutmmrsvbv .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#kutmmrsvbv .gt_from_md > :first-child {
  margin-top: 0;
}

#kutmmrsvbv .gt_from_md > :last-child {
  margin-bottom: 0;
}

#kutmmrsvbv .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#kutmmrsvbv .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#kutmmrsvbv .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#kutmmrsvbv .gt_row_group_first td {
  border-top-width: 2px;
}

#kutmmrsvbv .gt_row_group_first th {
  border-top-width: 2px;
}

#kutmmrsvbv .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kutmmrsvbv .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#kutmmrsvbv .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#kutmmrsvbv .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kutmmrsvbv .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#kutmmrsvbv .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#kutmmrsvbv .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#kutmmrsvbv .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#kutmmrsvbv .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#kutmmrsvbv .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kutmmrsvbv .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kutmmrsvbv .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#kutmmrsvbv .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#kutmmrsvbv .gt_left {
  text-align: left;
}

#kutmmrsvbv .gt_center {
  text-align: center;
}

#kutmmrsvbv .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#kutmmrsvbv .gt_font_normal {
  font-weight: normal;
}

#kutmmrsvbv .gt_font_bold {
  font-weight: bold;
}

#kutmmrsvbv .gt_font_italic {
  font-style: italic;
}

#kutmmrsvbv .gt_super {
  font-size: 65%;
}

#kutmmrsvbv .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#kutmmrsvbv .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#kutmmrsvbv .gt_indent_1 {
  text-indent: 5px;
}

#kutmmrsvbv .gt_indent_2 {
  text-indent: 10px;
}

#kutmmrsvbv .gt_indent_3 {
  text-indent: 15px;
}

#kutmmrsvbv .gt_indent_4 {
  text-indent: 20px;
}

#kutmmrsvbv .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">wage</td>
<td headers="Mean" class="gt_row gt_right">603.73</td>
<td headers="SD" class="gt_row gt_right">453.55</td></tr>
    <tr><td headers=" " class="gt_row gt_left">education</td>
<td headers="Mean" class="gt_row gt_right">13.07</td>
<td headers="SD" class="gt_row gt_right">2.90</td></tr>
    <tr><td headers=" " class="gt_row gt_left">experience</td>
<td headers="Mean" class="gt_row gt_right">18.20</td>
<td headers="SD" class="gt_row gt_right">13.08</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::



<br>

::: {.callout-note}
+ Use `+` to include more rows and columns.
+ The `modelsummary` package offers multiple summary functions of its own:
  + `Mean`, `SD`, `Median`, `Min`, `Max`, `P0`, `P25`, `P50`, `P75`, `P100`, `Histogram`
+ `NA` values are automatically stripped before the computation proceeds. So you don't need to worry about it.
:::

### All()

In the `formula` argument, you can use `All()` function to create a summary table for all the numeric variables in the dataset.


```r
datasummary(
  formula = All(CPS1988)~ Mean + SD,
  data = CPS1988
  )
```

<br>



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="zururylrza" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#zururylrza table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#zururylrza thead, #zururylrza tbody, #zururylrza tfoot, #zururylrza tr, #zururylrza td, #zururylrza th {
  border-style: none;
}

#zururylrza p {
  margin: 0;
  padding: 0;
}

#zururylrza .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#zururylrza .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#zururylrza .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#zururylrza .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#zururylrza .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#zururylrza .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zururylrza .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#zururylrza .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#zururylrza .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#zururylrza .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#zururylrza .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#zururylrza .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#zururylrza .gt_spanner_row {
  border-bottom-style: hidden;
}

#zururylrza .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#zururylrza .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#zururylrza .gt_from_md > :first-child {
  margin-top: 0;
}

#zururylrza .gt_from_md > :last-child {
  margin-bottom: 0;
}

#zururylrza .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#zururylrza .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#zururylrza .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#zururylrza .gt_row_group_first td {
  border-top-width: 2px;
}

#zururylrza .gt_row_group_first th {
  border-top-width: 2px;
}

#zururylrza .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#zururylrza .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#zururylrza .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#zururylrza .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zururylrza .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#zururylrza .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#zururylrza .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#zururylrza .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#zururylrza .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#zururylrza .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#zururylrza .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#zururylrza .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#zururylrza .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#zururylrza .gt_left {
  text-align: left;
}

#zururylrza .gt_center {
  text-align: center;
}

#zururylrza .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#zururylrza .gt_font_normal {
  font-weight: normal;
}

#zururylrza .gt_font_bold {
  font-weight: bold;
}

#zururylrza .gt_font_italic {
  font-style: italic;
}

#zururylrza .gt_super {
  font-size: 65%;
}

#zururylrza .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#zururylrza .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#zururylrza .gt_indent_1 {
  text-indent: 5px;
}

#zururylrza .gt_indent_2 {
  text-indent: 10px;
}

#zururylrza .gt_indent_3 {
  text-indent: 15px;
}

#zururylrza .gt_indent_4 {
  text-indent: 20px;
}

#zururylrza .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">wage</td>
<td headers="Mean" class="gt_row gt_right">603.73</td>
<td headers="SD" class="gt_row gt_right">453.55</td></tr>
    <tr><td headers=" " class="gt_row gt_left">education</td>
<td headers="Mean" class="gt_row gt_right">13.07</td>
<td headers="SD" class="gt_row gt_right">2.90</td></tr>
    <tr><td headers=" " class="gt_row gt_left">experience</td>
<td headers="Mean" class="gt_row gt_right">18.20</td>
<td headers="SD" class="gt_row gt_right">13.08</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::




### Your Turn

```r
datasummary(
  formula = wage + education + experience ~ mean + SD,
  data = CPS1988
  )
```

<br>



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="rcbwrvytzb" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#rcbwrvytzb table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#rcbwrvytzb thead, #rcbwrvytzb tbody, #rcbwrvytzb tfoot, #rcbwrvytzb tr, #rcbwrvytzb td, #rcbwrvytzb th {
  border-style: none;
}

#rcbwrvytzb p {
  margin: 0;
  padding: 0;
}

#rcbwrvytzb .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#rcbwrvytzb .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#rcbwrvytzb .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#rcbwrvytzb .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#rcbwrvytzb .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rcbwrvytzb .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rcbwrvytzb .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#rcbwrvytzb .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#rcbwrvytzb .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#rcbwrvytzb .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#rcbwrvytzb .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#rcbwrvytzb .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#rcbwrvytzb .gt_spanner_row {
  border-bottom-style: hidden;
}

#rcbwrvytzb .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#rcbwrvytzb .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#rcbwrvytzb .gt_from_md > :first-child {
  margin-top: 0;
}

#rcbwrvytzb .gt_from_md > :last-child {
  margin-bottom: 0;
}

#rcbwrvytzb .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#rcbwrvytzb .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#rcbwrvytzb .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#rcbwrvytzb .gt_row_group_first td {
  border-top-width: 2px;
}

#rcbwrvytzb .gt_row_group_first th {
  border-top-width: 2px;
}

#rcbwrvytzb .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rcbwrvytzb .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#rcbwrvytzb .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#rcbwrvytzb .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rcbwrvytzb .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#rcbwrvytzb .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#rcbwrvytzb .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#rcbwrvytzb .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#rcbwrvytzb .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#rcbwrvytzb .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rcbwrvytzb .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#rcbwrvytzb .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#rcbwrvytzb .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#rcbwrvytzb .gt_left {
  text-align: left;
}

#rcbwrvytzb .gt_center {
  text-align: center;
}

#rcbwrvytzb .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#rcbwrvytzb .gt_font_normal {
  font-weight: normal;
}

#rcbwrvytzb .gt_font_bold {
  font-weight: bold;
}

#rcbwrvytzb .gt_font_italic {
  font-style: italic;
}

#rcbwrvytzb .gt_super {
  font-size: 65%;
}

#rcbwrvytzb .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#rcbwrvytzb .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#rcbwrvytzb .gt_indent_1 {
  text-indent: 5px;
}

#rcbwrvytzb .gt_indent_2 {
  text-indent: 10px;
}

#rcbwrvytzb .gt_indent_3 {
  text-indent: 15px;
}

#rcbwrvytzb .gt_indent_4 {
  text-indent: 20px;
}

#rcbwrvytzb .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean">mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">wage</td>
<td headers="mean" class="gt_row gt_right">603.73</td>
<td headers="SD" class="gt_row gt_right">453.55</td></tr>
    <tr><td headers=" " class="gt_row gt_left">education</td>
<td headers="mean" class="gt_row gt_right">13.07</td>
<td headers="SD" class="gt_row gt_right">2.90</td></tr>
    <tr><td headers=" " class="gt_row gt_left">experience</td>
<td headers="mean" class="gt_row gt_right">18.20</td>
<td headers="SD" class="gt_row gt_right">13.08</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::



<br>


::: {.callout-tip}
## Play with the datasummary() function:

+ Exchange the rows and columns in the formula and see how the table looks.

+ Add other statistics or variables to the formula and see how the table looks.
:::

<!-- end panel: datasummary() -->
:::


## datasummary() Function: Further Tuning

<!-- start panel -->
:::{.panel-tabset}

### Nesting with `*` operator

`datasummary` can nest variables and statistics inside categorical variables using the `*` symbol. For example, you can display separate means and SD's for each value of `ethnicity`.


<br>

**Example 1: Nested rows**

```r
datasummary(
  formula =  ethnicity * (wage + education + experience) ~ mean + SD,
  data = CPS1988
  )
```

<br>



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="ceqfaeuyoa" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#ceqfaeuyoa table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#ceqfaeuyoa thead, #ceqfaeuyoa tbody, #ceqfaeuyoa tfoot, #ceqfaeuyoa tr, #ceqfaeuyoa td, #ceqfaeuyoa th {
  border-style: none;
}

#ceqfaeuyoa p {
  margin: 0;
  padding: 0;
}

#ceqfaeuyoa .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ceqfaeuyoa .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#ceqfaeuyoa .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ceqfaeuyoa .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ceqfaeuyoa .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ceqfaeuyoa .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ceqfaeuyoa .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ceqfaeuyoa .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ceqfaeuyoa .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ceqfaeuyoa .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ceqfaeuyoa .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ceqfaeuyoa .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ceqfaeuyoa .gt_spanner_row {
  border-bottom-style: hidden;
}

#ceqfaeuyoa .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#ceqfaeuyoa .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ceqfaeuyoa .gt_from_md > :first-child {
  margin-top: 0;
}

#ceqfaeuyoa .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ceqfaeuyoa .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ceqfaeuyoa .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#ceqfaeuyoa .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#ceqfaeuyoa .gt_row_group_first td {
  border-top-width: 2px;
}

#ceqfaeuyoa .gt_row_group_first th {
  border-top-width: 2px;
}

#ceqfaeuyoa .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ceqfaeuyoa .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ceqfaeuyoa .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ceqfaeuyoa .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ceqfaeuyoa .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ceqfaeuyoa .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ceqfaeuyoa .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#ceqfaeuyoa .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ceqfaeuyoa .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ceqfaeuyoa .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ceqfaeuyoa .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ceqfaeuyoa .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ceqfaeuyoa .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ceqfaeuyoa .gt_left {
  text-align: left;
}

#ceqfaeuyoa .gt_center {
  text-align: center;
}

#ceqfaeuyoa .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ceqfaeuyoa .gt_font_normal {
  font-weight: normal;
}

#ceqfaeuyoa .gt_font_bold {
  font-weight: bold;
}

#ceqfaeuyoa .gt_font_italic {
  font-style: italic;
}

#ceqfaeuyoa .gt_super {
  font-size: 65%;
}

#ceqfaeuyoa .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#ceqfaeuyoa .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ceqfaeuyoa .gt_indent_1 {
  text-indent: 5px;
}

#ceqfaeuyoa .gt_indent_2 {
  text-indent: 10px;
}

#ceqfaeuyoa .gt_indent_3 {
  text-indent: 15px;
}

#ceqfaeuyoa .gt_indent_4 {
  text-indent: 20px;
}

#ceqfaeuyoa .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="ethnicity">ethnicity</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean">mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="ethnicity" class="gt_row gt_left">afam</td>
<td headers=" " class="gt_row gt_left">wage</td>
<td headers="mean" class="gt_row gt_right">446.85</td>
<td headers="SD" class="gt_row gt_right">312.44</td></tr>
    <tr><td headers="ethnicity" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">education</td>
<td headers="mean" class="gt_row gt_right">12.33</td>
<td headers="SD" class="gt_row gt_right">2.77</td></tr>
    <tr><td headers="ethnicity" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">experience</td>
<td headers="mean" class="gt_row gt_right">18.74</td>
<td headers="SD" class="gt_row gt_right">13.51</td></tr>
    <tr><td headers="ethnicity" class="gt_row gt_left">cauc</td>
<td headers=" " class="gt_row gt_left">wage</td>
<td headers="mean" class="gt_row gt_right">617.23</td>
<td headers="SD" class="gt_row gt_right">461.21</td></tr>
    <tr><td headers="ethnicity" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">education</td>
<td headers="mean" class="gt_row gt_right">13.13</td>
<td headers="SD" class="gt_row gt_right">2.90</td></tr>
    <tr><td headers="ethnicity" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">experience</td>
<td headers="mean" class="gt_row gt_right">18.15</td>
<td headers="SD" class="gt_row gt_right">13.04</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::



<br>

**Example 2: Nested columns**

```r
datasummary(
  formula = wage + education + experience ~ ethnicity * (mean + SD),
  data = CPS1988
  )
```

<br>



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="hissprezrb" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#hissprezrb table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#hissprezrb thead, #hissprezrb tbody, #hissprezrb tfoot, #hissprezrb tr, #hissprezrb td, #hissprezrb th {
  border-style: none;
}

#hissprezrb p {
  margin: 0;
  padding: 0;
}

#hissprezrb .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#hissprezrb .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#hissprezrb .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#hissprezrb .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#hissprezrb .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hissprezrb .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hissprezrb .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#hissprezrb .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#hissprezrb .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#hissprezrb .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#hissprezrb .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#hissprezrb .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#hissprezrb .gt_spanner_row {
  border-bottom-style: hidden;
}

#hissprezrb .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#hissprezrb .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#hissprezrb .gt_from_md > :first-child {
  margin-top: 0;
}

#hissprezrb .gt_from_md > :last-child {
  margin-bottom: 0;
}

#hissprezrb .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#hissprezrb .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#hissprezrb .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#hissprezrb .gt_row_group_first td {
  border-top-width: 2px;
}

#hissprezrb .gt_row_group_first th {
  border-top-width: 2px;
}

#hissprezrb .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hissprezrb .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#hissprezrb .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#hissprezrb .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hissprezrb .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#hissprezrb .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#hissprezrb .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#hissprezrb .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#hissprezrb .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#hissprezrb .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hissprezrb .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hissprezrb .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#hissprezrb .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#hissprezrb .gt_left {
  text-align: left;
}

#hissprezrb .gt_center {
  text-align: center;
}

#hissprezrb .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#hissprezrb .gt_font_normal {
  font-weight: normal;
}

#hissprezrb .gt_font_bold {
  font-weight: bold;
}

#hissprezrb .gt_font_italic {
  font-style: italic;
}

#hissprezrb .gt_super {
  font-size: 65%;
}

#hissprezrb .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#hissprezrb .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#hissprezrb .gt_indent_1 {
  text-indent: 5px;
}

#hissprezrb .gt_indent_2 {
  text-indent: 10px;
}

#hissprezrb .gt_indent_3 {
  text-indent: 15px;
}

#hissprezrb .gt_indent_4 {
  text-indent: 20px;
}

#hissprezrb .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=" "> </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="afam    ">
        <span class="gt_column_spanner">afam    </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="cauc    ">
        <span class="gt_column_spanner">cauc    </span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean">mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean ">mean </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD ">SD </th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">wage</td>
<td headers="mean" class="gt_row gt_right">446.85</td>
<td headers="SD" class="gt_row gt_right">312.44</td>
<td headers="mean " class="gt_row gt_right">617.23</td>
<td headers="SD " class="gt_row gt_right">461.21</td></tr>
    <tr><td headers=" " class="gt_row gt_left">education</td>
<td headers="mean" class="gt_row gt_right">12.33</td>
<td headers="SD" class="gt_row gt_right">2.77</td>
<td headers="mean " class="gt_row gt_right">13.13</td>
<td headers="SD " class="gt_row gt_right">2.90</td></tr>
    <tr><td headers=" " class="gt_row gt_left">experience</td>
<td headers="mean" class="gt_row gt_right">18.74</td>
<td headers="SD" class="gt_row gt_right">13.51</td>
<td headers="mean " class="gt_row gt_right">18.15</td>
<td headers="SD " class="gt_row gt_right">13.04</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::





### Multiple Nests

You can nest variables and statistics inside multiple categorical variables using the `*` symbol.


::: {.callout-note}
+ The order in which terms enter the formula determines the order in which labels are displayed.
:::

<br>

**Example**

```r
datasummary(
  formula = wage + education + experience ~ region * ethnicity * (mean + SD),
  data = CPS1988
  )
```

<br>



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="avozzelrth" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#avozzelrth table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#avozzelrth thead, #avozzelrth tbody, #avozzelrth tfoot, #avozzelrth tr, #avozzelrth td, #avozzelrth th {
  border-style: none;
}

#avozzelrth p {
  margin: 0;
  padding: 0;
}

#avozzelrth .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#avozzelrth .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#avozzelrth .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#avozzelrth .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#avozzelrth .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#avozzelrth .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#avozzelrth .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#avozzelrth .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#avozzelrth .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#avozzelrth .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#avozzelrth .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#avozzelrth .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#avozzelrth .gt_spanner_row {
  border-bottom-style: hidden;
}

#avozzelrth .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#avozzelrth .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#avozzelrth .gt_from_md > :first-child {
  margin-top: 0;
}

#avozzelrth .gt_from_md > :last-child {
  margin-bottom: 0;
}

#avozzelrth .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#avozzelrth .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#avozzelrth .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#avozzelrth .gt_row_group_first td {
  border-top-width: 2px;
}

#avozzelrth .gt_row_group_first th {
  border-top-width: 2px;
}

#avozzelrth .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#avozzelrth .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#avozzelrth .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#avozzelrth .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#avozzelrth .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#avozzelrth .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#avozzelrth .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#avozzelrth .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#avozzelrth .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#avozzelrth .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#avozzelrth .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#avozzelrth .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#avozzelrth .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#avozzelrth .gt_left {
  text-align: left;
}

#avozzelrth .gt_center {
  text-align: center;
}

#avozzelrth .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#avozzelrth .gt_font_normal {
  font-weight: normal;
}

#avozzelrth .gt_font_bold {
  font-weight: bold;
}

#avozzelrth .gt_font_italic {
  font-style: italic;
}

#avozzelrth .gt_super {
  font-size: 65%;
}

#avozzelrth .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#avozzelrth .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#avozzelrth .gt_indent_1 {
  text-indent: 5px;
}

#avozzelrth .gt_indent_2 {
  text-indent: 10px;
}

#avozzelrth .gt_indent_3 {
  text-indent: 15px;
}

#avozzelrth .gt_indent_4 {
  text-indent: 20px;
}

#avozzelrth .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="1" scope="col" id></th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="4" scope="colgroup" id="midwest      ">
        <span class="gt_column_spanner">midwest      </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="4" scope="colgroup" id="northeast      ">
        <span class="gt_column_spanner">northeast      </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="4" scope="colgroup" id="south      ">
        <span class="gt_column_spanner">south      </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="4" scope="colgroup" id="west      ">
        <span class="gt_column_spanner">west      </span>
      </th>
    </tr>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=" "> </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="afam    ">
        <span class="gt_column_spanner">afam    </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="cauc    ">
        <span class="gt_column_spanner">cauc    </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="afam     ">
        <span class="gt_column_spanner">afam     </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="cauc     ">
        <span class="gt_column_spanner">cauc     </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="afam      ">
        <span class="gt_column_spanner">afam      </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="cauc      ">
        <span class="gt_column_spanner">cauc      </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="afam       ">
        <span class="gt_column_spanner">afam       </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="cauc       ">
        <span class="gt_column_spanner">cauc       </span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean">mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean ">mean </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD ">SD </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean  ">mean  </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD  ">SD  </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean   ">mean   </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD   ">SD   </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean    ">mean    </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD    ">SD    </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean     ">mean     </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD     ">SD     </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean      ">mean      </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD      ">SD      </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean       ">mean       </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD       ">SD       </th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">wage</td>
<td headers="mean" class="gt_row gt_right">458.32</td>
<td headers="SD" class="gt_row gt_right">312.58</td>
<td headers="mean " class="gt_row gt_right">613.19</td>
<td headers="SD " class="gt_row gt_right">450.94</td>
<td headers="mean  " class="gt_row gt_right">505.58</td>
<td headers="SD  " class="gt_row gt_right">342.00</td>
<td headers="mean   " class="gt_row gt_right">663.04</td>
<td headers="SD   " class="gt_row gt_right">438.30</td>
<td headers="mean    " class="gt_row gt_right">416.01</td>
<td headers="SD    " class="gt_row gt_right">293.52</td>
<td headers="mean     " class="gt_row gt_right">582.93</td>
<td headers="SD     " class="gt_row gt_right">487.13</td>
<td headers="mean      " class="gt_row gt_right">518.20</td>
<td headers="SD      " class="gt_row gt_right">346.94</td>
<td headers="mean       " class="gt_row gt_right">617.96</td>
<td headers="SD       " class="gt_row gt_right">457.77</td></tr>
    <tr><td headers=" " class="gt_row gt_left">education</td>
<td headers="mean" class="gt_row gt_right">12.53</td>
<td headers="SD" class="gt_row gt_right">2.62</td>
<td headers="mean " class="gt_row gt_right">13.29</td>
<td headers="SD " class="gt_row gt_right">2.52</td>
<td headers="mean  " class="gt_row gt_right">12.28</td>
<td headers="SD  " class="gt_row gt_right">2.75</td>
<td headers="mean   " class="gt_row gt_right">13.32</td>
<td headers="SD   " class="gt_row gt_right">2.77</td>
<td headers="mean    " class="gt_row gt_right">12.15</td>
<td headers="SD    " class="gt_row gt_right">2.84</td>
<td headers="mean     " class="gt_row gt_right">12.91</td>
<td headers="SD     " class="gt_row gt_right">3.08</td>
<td headers="mean      " class="gt_row gt_right">13.22</td>
<td headers="SD      " class="gt_row gt_right">2.38</td>
<td headers="mean       " class="gt_row gt_right">13.05</td>
<td headers="SD       " class="gt_row gt_right">3.16</td></tr>
    <tr><td headers=" " class="gt_row gt_left">experience</td>
<td headers="mean" class="gt_row gt_right">18.53</td>
<td headers="SD" class="gt_row gt_right">13.92</td>
<td headers="mean " class="gt_row gt_right">17.78</td>
<td headers="SD " class="gt_row gt_right">12.90</td>
<td headers="mean  " class="gt_row gt_right">20.73</td>
<td headers="SD  " class="gt_row gt_right">14.32</td>
<td headers="mean   " class="gt_row gt_right">18.69</td>
<td headers="SD   " class="gt_row gt_right">13.49</td>
<td headers="mean    " class="gt_row gt_right">18.52</td>
<td headers="SD    " class="gt_row gt_right">13.22</td>
<td headers="mean     " class="gt_row gt_right">18.41</td>
<td headers="SD     " class="gt_row gt_right">13.20</td>
<td headers="mean      " class="gt_row gt_right">16.89</td>
<td headers="SD      " class="gt_row gt_right">12.72</td>
<td headers="mean       " class="gt_row gt_right">17.70</td>
<td headers="SD       " class="gt_row gt_right">12.48</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::





### Renaming the Variables with `=`
<!-- start panel:renaming -->

By default, variable and statistics names are used as the labels in the table. You can rename the default labels with the following syntax: `(label = variable/statistic)`.

<br>

**Example**

Before renaming:

```r
datasummary(
  formula = wage + education ~ ethnicity * (mean + SD),
  data = CPS1988
)
```



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="cphpiuhtok" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#cphpiuhtok table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#cphpiuhtok thead, #cphpiuhtok tbody, #cphpiuhtok tfoot, #cphpiuhtok tr, #cphpiuhtok td, #cphpiuhtok th {
  border-style: none;
}

#cphpiuhtok p {
  margin: 0;
  padding: 0;
}

#cphpiuhtok .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#cphpiuhtok .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#cphpiuhtok .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#cphpiuhtok .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#cphpiuhtok .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#cphpiuhtok .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cphpiuhtok .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#cphpiuhtok .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#cphpiuhtok .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#cphpiuhtok .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#cphpiuhtok .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#cphpiuhtok .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#cphpiuhtok .gt_spanner_row {
  border-bottom-style: hidden;
}

#cphpiuhtok .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#cphpiuhtok .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#cphpiuhtok .gt_from_md > :first-child {
  margin-top: 0;
}

#cphpiuhtok .gt_from_md > :last-child {
  margin-bottom: 0;
}

#cphpiuhtok .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#cphpiuhtok .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#cphpiuhtok .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#cphpiuhtok .gt_row_group_first td {
  border-top-width: 2px;
}

#cphpiuhtok .gt_row_group_first th {
  border-top-width: 2px;
}

#cphpiuhtok .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#cphpiuhtok .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#cphpiuhtok .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#cphpiuhtok .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cphpiuhtok .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#cphpiuhtok .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#cphpiuhtok .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#cphpiuhtok .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#cphpiuhtok .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#cphpiuhtok .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#cphpiuhtok .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#cphpiuhtok .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#cphpiuhtok .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#cphpiuhtok .gt_left {
  text-align: left;
}

#cphpiuhtok .gt_center {
  text-align: center;
}

#cphpiuhtok .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#cphpiuhtok .gt_font_normal {
  font-weight: normal;
}

#cphpiuhtok .gt_font_bold {
  font-weight: bold;
}

#cphpiuhtok .gt_font_italic {
  font-style: italic;
}

#cphpiuhtok .gt_super {
  font-size: 65%;
}

#cphpiuhtok .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#cphpiuhtok .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#cphpiuhtok .gt_indent_1 {
  text-indent: 5px;
}

#cphpiuhtok .gt_indent_2 {
  text-indent: 10px;
}

#cphpiuhtok .gt_indent_3 {
  text-indent: 15px;
}

#cphpiuhtok .gt_indent_4 {
  text-indent: 20px;
}

#cphpiuhtok .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=" "> </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="afam    ">
        <span class="gt_column_spanner">afam    </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="cauc    ">
        <span class="gt_column_spanner">cauc    </span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean">mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean ">mean </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD ">SD </th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">wage</td>
<td headers="mean" class="gt_row gt_right">446.85</td>
<td headers="SD" class="gt_row gt_right">312.44</td>
<td headers="mean " class="gt_row gt_right">617.23</td>
<td headers="SD " class="gt_row gt_right">461.21</td></tr>
    <tr><td headers=" " class="gt_row gt_left">education</td>
<td headers="mean" class="gt_row gt_right">12.33</td>
<td headers="SD" class="gt_row gt_right">2.77</td>
<td headers="mean " class="gt_row gt_right">13.13</td>
<td headers="SD " class="gt_row gt_right">2.90</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::



<br>

After renaming:

```r
datasummary(
  formula = (`Wage (in dollars per week)` = wage) + (`Years of Education` = education) ~ ethnicity * (mean + (`Std.Dev` = SD)),
  data = CPS1988
)
```



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="ueelbiacao" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#ueelbiacao table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#ueelbiacao thead, #ueelbiacao tbody, #ueelbiacao tfoot, #ueelbiacao tr, #ueelbiacao td, #ueelbiacao th {
  border-style: none;
}

#ueelbiacao p {
  margin: 0;
  padding: 0;
}

#ueelbiacao .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ueelbiacao .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#ueelbiacao .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ueelbiacao .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ueelbiacao .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ueelbiacao .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ueelbiacao .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ueelbiacao .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ueelbiacao .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ueelbiacao .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ueelbiacao .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ueelbiacao .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ueelbiacao .gt_spanner_row {
  border-bottom-style: hidden;
}

#ueelbiacao .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#ueelbiacao .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ueelbiacao .gt_from_md > :first-child {
  margin-top: 0;
}

#ueelbiacao .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ueelbiacao .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ueelbiacao .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#ueelbiacao .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#ueelbiacao .gt_row_group_first td {
  border-top-width: 2px;
}

#ueelbiacao .gt_row_group_first th {
  border-top-width: 2px;
}

#ueelbiacao .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ueelbiacao .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ueelbiacao .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ueelbiacao .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ueelbiacao .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ueelbiacao .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ueelbiacao .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#ueelbiacao .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ueelbiacao .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ueelbiacao .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ueelbiacao .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ueelbiacao .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ueelbiacao .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ueelbiacao .gt_left {
  text-align: left;
}

#ueelbiacao .gt_center {
  text-align: center;
}

#ueelbiacao .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ueelbiacao .gt_font_normal {
  font-weight: normal;
}

#ueelbiacao .gt_font_bold {
  font-weight: bold;
}

#ueelbiacao .gt_font_italic {
  font-style: italic;
}

#ueelbiacao .gt_super {
  font-size: 65%;
}

#ueelbiacao .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#ueelbiacao .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ueelbiacao .gt_indent_1 {
  text-indent: 5px;
}

#ueelbiacao .gt_indent_2 {
  text-indent: 10px;
}

#ueelbiacao .gt_indent_3 {
  text-indent: 15px;
}

#ueelbiacao .gt_indent_4 {
  text-indent: 20px;
}

#ueelbiacao .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=" "> </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="afam    ">
        <span class="gt_column_spanner">afam    </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="cauc    ">
        <span class="gt_column_spanner">cauc    </span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean">mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Std.Dev">Std.Dev</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="mean ">mean </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Std.Dev ">Std.Dev </th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">Wage (in dollars per week)</td>
<td headers="mean" class="gt_row gt_right">446.85</td>
<td headers="Std.Dev" class="gt_row gt_right">312.44</td>
<td headers="mean " class="gt_row gt_right">617.23</td>
<td headers="Std.Dev " class="gt_row gt_right">461.21</td></tr>
    <tr><td headers=" " class="gt_row gt_left">Years of Education</td>
<td headers="mean" class="gt_row gt_right">12.33</td>
<td headers="Std.Dev" class="gt_row gt_right">2.77</td>
<td headers="mean " class="gt_row gt_right">13.13</td>
<td headers="Std.Dev " class="gt_row gt_right">2.90</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::



::: {.callout-caution}
+ In R, ``` `` ``` is used to define a variable name with spaces or special characters such as the parentheses symbol `()`.
:::


### Your Turn

:::{.panel-tabset}

### Data

For this exercise problem, we use `CPSSW3` dataset from the `AER` package. The `CPSSW3` dataset provides trends (from 1992 to 2004) in hourly earnings in the US of working college graduates aged 25–34 (in 2004 USD).




::: {.cell}

```{.r .cell-code}
library(AER)
data("CPSSW9204")
head(CPSSW9204)
```

::: {.cell-output .cell-output-stdout}

```
  year  earnings     degree gender age
1 1992 11.188810   bachelor   male  29
2 1992 10.000000   bachelor   male  33
3 1992  5.769231 highschool   male  30
4 1992  1.562500 highschool   male  32
5 1992 14.957260   bachelor   male  31
6 1992  8.660096   bachelor female  26
```


:::
:::




### Problem

Let's create the following tables:

<br>

**Table 1**



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="dpctorniyn" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#dpctorniyn table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#dpctorniyn thead, #dpctorniyn tbody, #dpctorniyn tfoot, #dpctorniyn tr, #dpctorniyn td, #dpctorniyn th {
  border-style: none;
}

#dpctorniyn p {
  margin: 0;
  padding: 0;
}

#dpctorniyn .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#dpctorniyn .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#dpctorniyn .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#dpctorniyn .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#dpctorniyn .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dpctorniyn .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dpctorniyn .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#dpctorniyn .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#dpctorniyn .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#dpctorniyn .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#dpctorniyn .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#dpctorniyn .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#dpctorniyn .gt_spanner_row {
  border-bottom-style: hidden;
}

#dpctorniyn .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#dpctorniyn .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#dpctorniyn .gt_from_md > :first-child {
  margin-top: 0;
}

#dpctorniyn .gt_from_md > :last-child {
  margin-bottom: 0;
}

#dpctorniyn .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#dpctorniyn .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#dpctorniyn .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#dpctorniyn .gt_row_group_first td {
  border-top-width: 2px;
}

#dpctorniyn .gt_row_group_first th {
  border-top-width: 2px;
}

#dpctorniyn .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dpctorniyn .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#dpctorniyn .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#dpctorniyn .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dpctorniyn .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#dpctorniyn .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#dpctorniyn .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#dpctorniyn .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#dpctorniyn .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#dpctorniyn .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dpctorniyn .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dpctorniyn .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#dpctorniyn .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#dpctorniyn .gt_left {
  text-align: left;
}

#dpctorniyn .gt_center {
  text-align: center;
}

#dpctorniyn .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#dpctorniyn .gt_font_normal {
  font-weight: normal;
}

#dpctorniyn .gt_font_bold {
  font-weight: bold;
}

#dpctorniyn .gt_font_italic {
  font-style: italic;
}

#dpctorniyn .gt_super {
  font-size: 65%;
}

#dpctorniyn .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#dpctorniyn .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#dpctorniyn .gt_indent_1 {
  text-indent: 5px;
}

#dpctorniyn .gt_indent_2 {
  text-indent: 10px;
}

#dpctorniyn .gt_indent_3 {
  text-indent: 15px;
}

#dpctorniyn .gt_indent_4 {
  text-indent: 20px;
}

#dpctorniyn .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="year">year</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=" "> </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="male    ">
        <span class="gt_column_spanner">male    </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="female    ">
        <span class="gt_column_spanner">female    </span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD">SD</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean ">Mean </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="SD ">SD </th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="year" class="gt_row gt_left">1992</td>
<td headers=" " class="gt_row gt_left">earnings</td>
<td headers="Mean" class="gt_row gt_right">12.38</td>
<td headers="SD" class="gt_row gt_right">5.88</td>
<td headers="Mean " class="gt_row gt_right">10.61</td>
<td headers="SD " class="gt_row gt_right">4.92</td></tr>
    <tr><td headers="year" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">age</td>
<td headers="Mean" class="gt_row gt_right">29.74</td>
<td headers="SD" class="gt_row gt_right">2.81</td>
<td headers="Mean " class="gt_row gt_right">29.67</td>
<td headers="SD " class="gt_row gt_right">2.81</td></tr>
    <tr><td headers="year" class="gt_row gt_left">2004</td>
<td headers=" " class="gt_row gt_left">earnings</td>
<td headers="Mean" class="gt_row gt_right">17.77</td>
<td headers="SD" class="gt_row gt_right">9.30</td>
<td headers="Mean " class="gt_row gt_right">15.36</td>
<td headers="SD " class="gt_row gt_right">7.71</td></tr>
    <tr><td headers="year" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">age</td>
<td headers="Mean" class="gt_row gt_right">29.82</td>
<td headers="SD" class="gt_row gt_right">2.86</td>
<td headers="Mean " class="gt_row gt_right">29.67</td>
<td headers="SD " class="gt_row gt_right">2.93</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::



<br>

**Table 2: Rename some labels in Table 1**



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="pcvevhmpyv" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#pcvevhmpyv table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#pcvevhmpyv thead, #pcvevhmpyv tbody, #pcvevhmpyv tfoot, #pcvevhmpyv tr, #pcvevhmpyv td, #pcvevhmpyv th {
  border-style: none;
}

#pcvevhmpyv p {
  margin: 0;
  padding: 0;
}

#pcvevhmpyv .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#pcvevhmpyv .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#pcvevhmpyv .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#pcvevhmpyv .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#pcvevhmpyv .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#pcvevhmpyv .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pcvevhmpyv .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#pcvevhmpyv .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#pcvevhmpyv .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#pcvevhmpyv .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#pcvevhmpyv .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#pcvevhmpyv .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#pcvevhmpyv .gt_spanner_row {
  border-bottom-style: hidden;
}

#pcvevhmpyv .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#pcvevhmpyv .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#pcvevhmpyv .gt_from_md > :first-child {
  margin-top: 0;
}

#pcvevhmpyv .gt_from_md > :last-child {
  margin-bottom: 0;
}

#pcvevhmpyv .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#pcvevhmpyv .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#pcvevhmpyv .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#pcvevhmpyv .gt_row_group_first td {
  border-top-width: 2px;
}

#pcvevhmpyv .gt_row_group_first th {
  border-top-width: 2px;
}

#pcvevhmpyv .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pcvevhmpyv .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#pcvevhmpyv .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#pcvevhmpyv .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pcvevhmpyv .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#pcvevhmpyv .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#pcvevhmpyv .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#pcvevhmpyv .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#pcvevhmpyv .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#pcvevhmpyv .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#pcvevhmpyv .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#pcvevhmpyv .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#pcvevhmpyv .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#pcvevhmpyv .gt_left {
  text-align: left;
}

#pcvevhmpyv .gt_center {
  text-align: center;
}

#pcvevhmpyv .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#pcvevhmpyv .gt_font_normal {
  font-weight: normal;
}

#pcvevhmpyv .gt_font_bold {
  font-weight: bold;
}

#pcvevhmpyv .gt_font_italic {
  font-style: italic;
}

#pcvevhmpyv .gt_super {
  font-size: 65%;
}

#pcvevhmpyv .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#pcvevhmpyv .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#pcvevhmpyv .gt_indent_1 {
  text-indent: 5px;
}

#pcvevhmpyv .gt_indent_2 {
  text-indent: 10px;
}

#pcvevhmpyv .gt_indent_3 {
  text-indent: 15px;
}

#pcvevhmpyv .gt_indent_4 {
  text-indent: 20px;
}

#pcvevhmpyv .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id="Year">Year</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=" "> </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="male    ">
        <span class="gt_column_spanner">male    </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="female    ">
        <span class="gt_column_spanner">female    </span>
      </th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Std.Dev">Std.Dev</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean ">Mean </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Std.Dev ">Std.Dev </th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Year" class="gt_row gt_left">1992</td>
<td headers=" " class="gt_row gt_left">Avg. hourly earnings</td>
<td headers="Mean" class="gt_row gt_right">12.38</td>
<td headers="Std.Dev" class="gt_row gt_right">5.88</td>
<td headers="Mean " class="gt_row gt_right">10.61</td>
<td headers="Std.Dev " class="gt_row gt_right">4.92</td></tr>
    <tr><td headers="Year" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">Age</td>
<td headers="Mean" class="gt_row gt_right">29.74</td>
<td headers="Std.Dev" class="gt_row gt_right">2.81</td>
<td headers="Mean " class="gt_row gt_right">29.67</td>
<td headers="Std.Dev " class="gt_row gt_right">2.81</td></tr>
    <tr><td headers="Year" class="gt_row gt_left">2004</td>
<td headers=" " class="gt_row gt_left">Avg. hourly earnings</td>
<td headers="Mean" class="gt_row gt_right">17.77</td>
<td headers="Std.Dev" class="gt_row gt_right">9.30</td>
<td headers="Mean " class="gt_row gt_right">15.36</td>
<td headers="Std.Dev " class="gt_row gt_right">7.71</td></tr>
    <tr><td headers="Year" class="gt_row gt_left"></td>
<td headers=" " class="gt_row gt_left">Age</td>
<td headers="Mean" class="gt_row gt_right">29.82</td>
<td headers="Std.Dev" class="gt_row gt_right">2.86</td>
<td headers="Mean " class="gt_row gt_right">29.67</td>
<td headers="Std.Dev " class="gt_row gt_right">2.93</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::


<!-- end panel -->
:::
:::

# Appendix: Other Functions of the modelsummary Package



## datasummary_skim

:::{.panel-tabset}
### Basics

`datasummary_skim()` with the `type = categorical` option might be helpful to  quickly generate a summary table for categorical variables:

<br>

**Syntax**

```r
datasummary_skim(data = dataset, type = "categorical")
```


### Example


::: {.cell}

```{.r .cell-code}
datasummary_skim(data = CPS1988[,.(ethnicity, smsa, region, parttime)], type = "categorical")
```
:::



<br>



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="gomoxsvefp" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#gomoxsvefp table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#gomoxsvefp thead, #gomoxsvefp tbody, #gomoxsvefp tfoot, #gomoxsvefp tr, #gomoxsvefp td, #gomoxsvefp th {
  border-style: none;
}

#gomoxsvefp p {
  margin: 0;
  padding: 0;
}

#gomoxsvefp .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#gomoxsvefp .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#gomoxsvefp .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#gomoxsvefp .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#gomoxsvefp .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#gomoxsvefp .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#gomoxsvefp .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#gomoxsvefp .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#gomoxsvefp .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#gomoxsvefp .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#gomoxsvefp .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#gomoxsvefp .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#gomoxsvefp .gt_spanner_row {
  border-bottom-style: hidden;
}

#gomoxsvefp .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#gomoxsvefp .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#gomoxsvefp .gt_from_md > :first-child {
  margin-top: 0;
}

#gomoxsvefp .gt_from_md > :last-child {
  margin-bottom: 0;
}

#gomoxsvefp .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#gomoxsvefp .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#gomoxsvefp .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#gomoxsvefp .gt_row_group_first td {
  border-top-width: 2px;
}

#gomoxsvefp .gt_row_group_first th {
  border-top-width: 2px;
}

#gomoxsvefp .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#gomoxsvefp .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#gomoxsvefp .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#gomoxsvefp .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#gomoxsvefp .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#gomoxsvefp .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#gomoxsvefp .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#gomoxsvefp .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#gomoxsvefp .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#gomoxsvefp .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#gomoxsvefp .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#gomoxsvefp .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#gomoxsvefp .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#gomoxsvefp .gt_left {
  text-align: left;
}

#gomoxsvefp .gt_center {
  text-align: center;
}

#gomoxsvefp .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#gomoxsvefp .gt_font_normal {
  font-weight: normal;
}

#gomoxsvefp .gt_font_bold {
  font-weight: bold;
}

#gomoxsvefp .gt_font_italic {
  font-style: italic;
}

#gomoxsvefp .gt_super {
  font-size: 65%;
}

#gomoxsvefp .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#gomoxsvefp .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#gomoxsvefp .gt_indent_1 {
  text-indent: 5px;
}

#gomoxsvefp .gt_indent_2 {
  text-indent: 10px;
}

#gomoxsvefp .gt_indent_3 {
  text-indent: 15px;
}

#gomoxsvefp .gt_indent_4 {
  text-indent: 20px;
}

#gomoxsvefp .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="  ">  </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="N">N</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="%">%</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">ethnicity</td>
<td headers="  " class="gt_row gt_left">afam</td>
<td headers="N" class="gt_row gt_right">2232</td>
<td headers="%" class="gt_row gt_right">7.9</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="  " class="gt_row gt_left">cauc</td>
<td headers="N" class="gt_row gt_right">25923</td>
<td headers="%" class="gt_row gt_right">92.1</td></tr>
    <tr><td headers=" " class="gt_row gt_left">smsa</td>
<td headers="  " class="gt_row gt_left">no</td>
<td headers="N" class="gt_row gt_right">7223</td>
<td headers="%" class="gt_row gt_right">25.7</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="  " class="gt_row gt_left">yes</td>
<td headers="N" class="gt_row gt_right">20932</td>
<td headers="%" class="gt_row gt_right">74.3</td></tr>
    <tr><td headers=" " class="gt_row gt_left">region</td>
<td headers="  " class="gt_row gt_left">midwest</td>
<td headers="N" class="gt_row gt_right">6863</td>
<td headers="%" class="gt_row gt_right">24.4</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="  " class="gt_row gt_left">northeast</td>
<td headers="N" class="gt_row gt_right">6441</td>
<td headers="%" class="gt_row gt_right">22.9</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="  " class="gt_row gt_left">south</td>
<td headers="N" class="gt_row gt_right">8760</td>
<td headers="%" class="gt_row gt_right">31.1</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="  " class="gt_row gt_left">west</td>
<td headers="N" class="gt_row gt_right">6091</td>
<td headers="%" class="gt_row gt_right">21.6</td></tr>
    <tr><td headers=" " class="gt_row gt_left">parttime</td>
<td headers="  " class="gt_row gt_left">no</td>
<td headers="N" class="gt_row gt_right">25631</td>
<td headers="%" class="gt_row gt_right">91.0</td></tr>
    <tr><td headers=" " class="gt_row gt_left"></td>
<td headers="  " class="gt_row gt_left">yes</td>
<td headers="N" class="gt_row gt_right">2524</td>
<td headers="%" class="gt_row gt_right">9.0</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::


:::


## datasummary_balance

:::{.panel-tabset}

### Basics

`datasummary_balance()` function creates balance tables with summary statistics for different subsets of the data (e.g., control and treatment groups). 

<br>

**Syntax**

```r
datasummary_balance(
  formula = variables to summarize ~ group_variable,
  data = dataset
  )
```


### Example


::: {.cell}

```{.r .cell-code}
datasummary_balance(
  formula = wage + education + experience ~ ethnicity,
  data = CPS1988,
  dinm_statistic = "std.error" # or "p.value"
)
```
:::



<br>



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="uujrtgunln" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#uujrtgunln table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#uujrtgunln thead, #uujrtgunln tbody, #uujrtgunln tfoot, #uujrtgunln tr, #uujrtgunln td, #uujrtgunln th {
  border-style: none;
}

#uujrtgunln p {
  margin: 0;
  padding: 0;
}

#uujrtgunln .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#uujrtgunln .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#uujrtgunln .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#uujrtgunln .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#uujrtgunln .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#uujrtgunln .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uujrtgunln .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#uujrtgunln .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#uujrtgunln .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#uujrtgunln .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#uujrtgunln .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#uujrtgunln .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#uujrtgunln .gt_spanner_row {
  border-bottom-style: hidden;
}

#uujrtgunln .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#uujrtgunln .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#uujrtgunln .gt_from_md > :first-child {
  margin-top: 0;
}

#uujrtgunln .gt_from_md > :last-child {
  margin-bottom: 0;
}

#uujrtgunln .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#uujrtgunln .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#uujrtgunln .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#uujrtgunln .gt_row_group_first td {
  border-top-width: 2px;
}

#uujrtgunln .gt_row_group_first th {
  border-top-width: 2px;
}

#uujrtgunln .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#uujrtgunln .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#uujrtgunln .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#uujrtgunln .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uujrtgunln .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#uujrtgunln .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#uujrtgunln .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#uujrtgunln .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#uujrtgunln .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#uujrtgunln .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#uujrtgunln .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#uujrtgunln .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#uujrtgunln .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#uujrtgunln .gt_left {
  text-align: left;
}

#uujrtgunln .gt_center {
  text-align: center;
}

#uujrtgunln .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#uujrtgunln .gt_font_normal {
  font-weight: normal;
}

#uujrtgunln .gt_font_bold {
  font-weight: bold;
}

#uujrtgunln .gt_font_italic {
  font-style: italic;
}

#uujrtgunln .gt_super {
  font-size: 65%;
}

#uujrtgunln .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#uujrtgunln .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#uujrtgunln .gt_indent_1 {
  text-indent: 5px;
}

#uujrtgunln .gt_indent_2 {
  text-indent: 10px;
}

#uujrtgunln .gt_indent_3 {
  text-indent: 15px;
}

#uujrtgunln .gt_indent_4 {
  text-indent: 20px;
}

#uujrtgunln .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings gt_spanner_row">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1" scope="col" id=" "> </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="afam (N=2232)    ">
        <span class="gt_column_spanner">afam (N=2232)    </span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="2" scope="colgroup" id="cauc (N=25923)    ">
        <span class="gt_column_spanner">cauc (N=25923)    </span>
      </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" scope="col" id="Diff. in Means">Diff. in Means</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="2" colspan="1" scope="col" id="Std. Error">Std. Error</th>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean">Mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Std. Dev.">Std. Dev.</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Mean ">Mean </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Std. Dev. ">Std. Dev. </th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">wage</td>
<td headers="Mean" class="gt_row gt_right">446.9</td>
<td headers="Std. Dev." class="gt_row gt_right">312.4</td>
<td headers="Mean " class="gt_row gt_right">617.2</td>
<td headers="Std. Dev. " class="gt_row gt_right">461.2</td>
<td headers="Diff. in Means" class="gt_row gt_right">170.4</td>
<td headers="Std. Error" class="gt_row gt_right">7.2</td></tr>
    <tr><td headers=" " class="gt_row gt_left">education</td>
<td headers="Mean" class="gt_row gt_right">12.3</td>
<td headers="Std. Dev." class="gt_row gt_right">2.8</td>
<td headers="Mean " class="gt_row gt_right">13.1</td>
<td headers="Std. Dev. " class="gt_row gt_right">2.9</td>
<td headers="Diff. in Means" class="gt_row gt_right">0.8</td>
<td headers="Std. Error" class="gt_row gt_right">0.1</td></tr>
    <tr><td headers=" " class="gt_row gt_left">experience</td>
<td headers="Mean" class="gt_row gt_right">18.7</td>
<td headers="Std. Dev." class="gt_row gt_right">13.5</td>
<td headers="Mean " class="gt_row gt_right">18.2</td>
<td headers="Std. Dev. " class="gt_row gt_right">13.0</td>
<td headers="Diff. in Means" class="gt_row gt_right">-0.6</td>
<td headers="Std. Error" class="gt_row gt_right">0.3</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::



:::


## datasummary_correlation

:::{.panel-tabset}

### Basics

`datasummary_correlation()` function creates a correlation table. It automatically identifies all the numeric variables, and calculates the correlation between each of those variables (You don't need to select the numeric variables manually!).

<br>

**Syntax**

```r
datasummary_correlation(data = dataset)
```


### Example


::: {.cell}

```{.r .cell-code}
datasummary_correlation(data = CPS1988)
```
:::



<br>



::: {.cell}
::: {.cell-output-display}

```{=html}
<div id="ukiswvhegj" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#ukiswvhegj table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

#ukiswvhegj thead, #ukiswvhegj tbody, #ukiswvhegj tfoot, #ukiswvhegj tr, #ukiswvhegj td, #ukiswvhegj th {
  border-style: none;
}

#ukiswvhegj p {
  margin: 0;
  padding: 0;
}

#ukiswvhegj .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ukiswvhegj .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#ukiswvhegj .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ukiswvhegj .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ukiswvhegj .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ukiswvhegj .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ukiswvhegj .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ukiswvhegj .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ukiswvhegj .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ukiswvhegj .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ukiswvhegj .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ukiswvhegj .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ukiswvhegj .gt_spanner_row {
  border-bottom-style: hidden;
}

#ukiswvhegj .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#ukiswvhegj .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ukiswvhegj .gt_from_md > :first-child {
  margin-top: 0;
}

#ukiswvhegj .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ukiswvhegj .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ukiswvhegj .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#ukiswvhegj .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#ukiswvhegj .gt_row_group_first td {
  border-top-width: 2px;
}

#ukiswvhegj .gt_row_group_first th {
  border-top-width: 2px;
}

#ukiswvhegj .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ukiswvhegj .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ukiswvhegj .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ukiswvhegj .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ukiswvhegj .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ukiswvhegj .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ukiswvhegj .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}

#ukiswvhegj .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ukiswvhegj .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ukiswvhegj .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ukiswvhegj .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ukiswvhegj .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ukiswvhegj .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ukiswvhegj .gt_left {
  text-align: left;
}

#ukiswvhegj .gt_center {
  text-align: center;
}

#ukiswvhegj .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ukiswvhegj .gt_font_normal {
  font-weight: normal;
}

#ukiswvhegj .gt_font_bold {
  font-weight: bold;
}

#ukiswvhegj .gt_font_italic {
  font-style: italic;
}

#ukiswvhegj .gt_super {
  font-size: 65%;
}

#ukiswvhegj .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}

#ukiswvhegj .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ukiswvhegj .gt_indent_1 {
  text-indent: 5px;
}

#ukiswvhegj .gt_indent_2 {
  text-indent: 10px;
}

#ukiswvhegj .gt_indent_3 {
  text-indent: 15px;
}

#ukiswvhegj .gt_indent_4 {
  text-indent: 20px;
}

#ukiswvhegj .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=" "> </th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="wage">wage</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="education">education</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="experience">experience</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers=" " class="gt_row gt_left">wage</td>
<td headers="wage" class="gt_row gt_right">1</td>
<td headers="education" class="gt_row gt_right">.</td>
<td headers="experience" class="gt_row gt_right">.</td></tr>
    <tr><td headers=" " class="gt_row gt_left">education</td>
<td headers="wage" class="gt_row gt_right">.30</td>
<td headers="education" class="gt_row gt_right">1</td>
<td headers="experience" class="gt_row gt_right">.</td></tr>
    <tr><td headers=" " class="gt_row gt_left">experience</td>
<td headers="wage" class="gt_row gt_right">.19</td>
<td headers="education" class="gt_row gt_right">-.29</td>
<td headers="experience" class="gt_row gt_right">1</td></tr>
  </tbody>
  
  
</table>
</div>
```

:::
:::


:::


# Exercise Problems {.center}

You can find [today's exercise problems](https://shunkei3.github.io/R-2024-Summer/contents/day4.html) for Day 4 on the course website.
