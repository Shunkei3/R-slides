# Example slides:
+ [quarto.pub](https://thomasmock.quarto.pub/)
  + example slide [here](https://thomasmock.quarto.pub/reports-presentations/#/title-slide)
    + [quarto-reporting/quarto-reporting.qmd](https://github.com/jthomasmock/quarto-reporting/blob/main/quarto-reporting.qmd)



# Useful websites for ideas
+ [Working with data table - EconR](http://www.econr.org/DataTable.html)
+ 

# Package:
+ Data analysis: `data.table`, `dplyr`, `tidyr`, `ggplot2`
+ Econometric analysis: `sandwich`, `plm`
+ 


# Plan: Overview
+ Day1: Introduction to R: Basic operation of R
  + To get familiar with the feature of RStudio (lecture 0)
  + To get familiar with the basic operation of R
  + To understand how to create vector, list, matrix, and data.frame in R, and how to access and modify the elements in those objects.
  + To get familiar with base R functions to do mathematical calculations.
  + To get familiar with be able to base plotting functions to visualize data.


+ Day2: Data warngling with `data.table`(and `dplyr` package)
  + To get familiar with the basic operation of `data.table` package
  + Pipes with magrittr
  + To get familar with basic skills for data wrangling


+ Day3: Data visualization with ggplot2


+ Day4: Econometric analysis with R, and Monte Calro simulation
  + conduct descriptive analysis, reporte the table
  + run regression model and report the result
  + loop functions
  + introduction to Monte Calro simulation


+ Day5: Write functions for more complicated Monte Carlo simulation
  + When should you write a function?

# Exercise problems: Idea


+ Run first difference regression
  + Point:
    + create a lag variable and take a FD

+ Ideas for Monte Calro Simulation
  + Derive pi 
  + Measurement error problem
  + (Weak) law of large numbers
  + Unbiased estimator for the population mean
  + Central limit theorem
  + Heteroskedasticity robust estimator

+ Download data from USDA-NASS using `rnassqs`




# Extra:
+ Projects (Rstudio Projects)
+ Faster veclib
+ 



---
# Plan: Day1

## To do:
  + Explore RStudio:
    + explain the layout of RStudio
    + explain the feature of R studio
    + code style:
      + "R is an 
  + Types of R objects:
    + Basic element types
    + Basic object types
  + Basic operations of R:
    + Assigning values to variables: "Everything is an object and everything has a name."
    + Basic R calculations: +, -, *, /, ^, %%, %/%
    + Base R functions: log(), abs(), sqrt(), mean(), median(), max(), min(), lm()
    + plot(), density(), hist()


## Questions:
+ list vs 

## Base functions:
+ log(), abs(), sqrt(), mean(), median(), max(), min(), lm()
+ Data frames: like a matrix but can have columns with different types
  + Create a data frame: data.frame()
  + Check and convert: is.data.frame(), as.data.frame()
  + Transpose a data frame: t()
  + Subset a data frame: my_data[row, col], subset(), attach() and detach()
  + Extend a data frame: $, cbind(), rbind()
  + Calculations with numeric data frames: rowSums(), colSums(), rowMeans(), colMeans(), apply()


## Emphasis:
+ When you don't know 
+ Imagination of the process is important!
  + Suppose that you don't know the function `median()`, how do you calculate the median of a sequence of numbers?


## Exercise problem:
+ Generate a sequence of numbers from 1 to 100 increase by 
+ create a data.frame
  + change the value of the first row to 0
  + add column names
  + add row names
  + 
+ run the following code: `r <- sample(1:5, 100, replace = TRUE)`
  + find the value of mean and SD without using `mean()` and `sd()`
  + find the median value of `r`
  + Find the index of the maximum value of a vector `x`.
  + Exclue some elements from a vector `x`

  + select elements using "or" and "and" (e.g., %in%)
  + find the NA 
  + replace NA to 0


## A list of functions:
+ c()
+ seq()
+ rep()
+ sample()
+ head()
+ unique()
+ length()
+ 

---
# Plan: Day2 - Data warngling with `data.table`(and `dplyr` package)

# To do:
  + Piping operator with magrittr
  + To get familiar with the basic operation of `data.table` package
    + select columns
    + filter rows by conditions
    + define a new variable
    + 







---
# Plan: Day3

---
# Plan: Day4

---
# Plan: Day5
