```{r}

# R program to illustrate an array
 
# creating a vector 
vector1 <- c("A", "B", "C", dim = 1)
# declaring a character array 
uni_array <- array(vector1)
 
# creating another vector
vector <- c(1:12)
# declaring 2 numeric multi-dimensional
# array with size 2x3 
multi_array <- array(c(1:12), dim = c(2, 3, 2))
multi_array <- array(c(1:12), dim = c(2, 6))
class(multi_array)


library(data.table)
library(dplyr)

dt <- data.frame(
  list(1:5)
)
dt <- data.frame(
  c(1:5)
)



vc2 <- 1:12
names(vc2) <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l")

vc2[["a"]]


dt1 <- data.frame(x=1:5, y=6:10)
dt2 <- data.frame(x=1:5, y=6:10)

names(dt1) <- c("a", "b")

x <- matrix(1:12, nrow=3)
colnames(x) <- c("a", "b", "c", "d")
rownames(x) <- c("x", "y", "z")


x
x["a"]
x[["b"]]

names(dt1)

dt1_2 <- c(dt1, dt2)
length(dt1_2)
list(dt1, dt2)


c(x=1:2, y=3:4)


class(NA)

#/*--------------------------------*/
#' ## Matrix
#/*--------------------------------*/
mat <- matrix(1:12, nrow=3)
rownames(mat) <- c("row1", "row2", "row3")
colnames(mat) <- c("col1", "col2", "col3", "col4")

mat[, c("col1", "col2")]
mat[["col1"]]

#/*--------------------------------*/
#' ## Data Frame
#/*--------------------------------*/
yield_data <- 
  data.frame(
    Nitrogen = c(200, 180, 300),
    Yield = c(240, 220, 230),
    State = c("Kansas", "Nebraska", "Iowas")
  )

#data.frame
yield_data[, c("Yield", "Nitrogen")]
yield_data[, c(1, 2)]

# vector
yield_data[["Yield"]] #vector
yield_data$Yield #vector
with(yield_data, Yield)

