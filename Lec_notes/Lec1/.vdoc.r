#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# This is an example of R code chunk you will see in this slide deck.
print("Let's get started!")

1 + 1
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# assign value 1 to an object called "x" 
x <- 1
# see what's inside object "x"
x

# assign the result of a product to an objecte called "y"
y <- 2*3

# store sum of x and y in z
z <- x + y
# see what's inside object "z"
z
# take z, add 1, and store result back in z
z <- z + 1
# Now, the value stored in z is updated.
z

# use z as an input of square root function
sqrt(z)
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
# For example, this is not allowed. You will see an error.
1_test <- 1:3

# Intead, you can do this.
test_1 <- 1:3
test_1
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
class(5.2)
class(2L)
class(TRUE)

is.integer(5.2)
is.integer(2L)
#
#
#
#
#
#
#
#
#
#
#
#
#
#
test_chr <- "5.2"
class(test_chr)

# convert to numeric
test_num <- as.numeric(test_chr)
test_num
class(test_num)

# convert from numeric to character type
as.character(test_num)

# conver from numeric to factor type
as.factor(test_num)
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
#--- true or false ---#
5 == 5
5 != 4
5 > 4
5 >= 4
5 < 4
5 <= 4

5 == 5 &  5 != 4
5 == 5 &  5 < 4
5 == 5 | 5 < 4
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# Empty vector
c()

# Create a numeric vector
x <- c(1, 2, 3) # equivalent to seq(1, 5) and 
x

# Combine another numeric vector and x
y <- c(x, c(4, 5))

# Create a character vector
z <- c("a", "b", "c")

# See what happens when you combine numeric and character vector
c(x, z)
# All the numeric values are converted to characters!
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# === Positional indexing === #
# Create a numeric vector 
x <- seq(from = 1, to = 5, by = 2)
x

# Get 2nd element of x
index_vec <- 2
x[index_vec] # or simply you can do x[2]

# Get 1st and 3rd element of x
index_vec <- c(1, 3)
x[index_vec] # or simply you can do x[c(1, 3)]

# Get the last element of x without knowing the length of x.
x[length(x)]
#
#
#
#
#
#
#
# === Named indexing === #
# Create a numeric vector with names
y <- c(x=1, y=2, z=3)
y 

index_vec <- "x"
y[index_vec] # or simply y["x"]
#
#
#
#
#
#
#
#
#
#
#
#
# Create a numeric vector 
x <- c(5, -8, 2, -1)

# === For example, let's get the positive elements === #
# create a logical vector 
y <- x > 0
# Let's see what's inside y
y

# subset the data
x[y] #Or you can simply do x[x>0]
#
#
#
#
#
#
#
#
#
#
#
x <- 1:5

# Assign names to each of the elements
names(x) <- c("a", "b", "c", "d", "e")
x

# Replace a specific element to another value
x["a"] <- 100
x
#
#
#
#
#
#
#
# Run this code:
set.seed(3746)
x <- runif(n = 30, min = 0, max = 1)
#
#
#
#
#
#
#
#
#
#| include: false
#| eval: false

set.seed(3746)
x <- runif(n = 30, min = 0, max = 1)

# 1.1
x[c(10,15)]
x[x > 0.5]
x[c(10,15)] <- 0
x[x > 0.9] <- 1
sum(x > 0.6)
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
# Create a numeric matrix
m_num <- matrix(1:6, nrow = 3)
m_num

# use dim() to see the dimension of the matrix
dim(m_num)

# Create a matrix of characters
m_chr <- matrix(c("a", "b" , "c", "d", "e", "f"), nrow = 3)
m_chr
#
#
#
#
#
vec_a <- 1:4
vec_b <- 4:7

mat1 <- cbind(vec_a, vec_b)
mat1

mat2 <- rbind(vec_a, vec_b)
mat2
#
#
#
#
#
#
#
#
#
# Create a matrix of numbers
m_num <- matrix(1:6, nrow = 3)
m_num

# Get the element in the 1st row and 2nd column
m_num[1, 2]

# Modify a specific element
m_num[1, 2] <- 100
m_num
#
#
#
#
#
# Create a matrix of numbers
m_num <- matrix(1:6, nrow = 3)

# Add column names
colnames(m_num) <- c("A", "B")
m_num
# Add row names
rownames(m_num) <- c("a", "b", "c")
m_num
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
# create a data.frame 
yield_data <- 
  data.frame(
    Nitrogen = c(200, 180, 300),
    Yield = c(240, 220, 230),
    State = c("Kansas", "Nebraska", "Iowas")
  )
yield_data
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
yield_data <- 
  data.frame(
    Nitrogen = c(200, 180, 300),
    Yield = c(240, 220, 230),
    State = c("Kansas", "Nebraska", "Iowas")
  )
yield_data

# Get the elements in the 1st row 
yield_data[1, ]

# Get the elements in the 1st column
yield_data[ , 1]

# Get the element in the 1st row and 2nd column
yield_data[1, 2]

# Or you can use the column name
yield_data[1, "Yield"]

# Find a state whose yield is more than 225
yield_data[yield_data$Yield > 225, ]
#
#
#
#
#
yield_data <- 
  data.frame(
    Nitrogen = c(200, 180, 300),
    Yield = c(240, 220, 230),
    State = c("Kansas", "Nebraska", "Iowas")
  )

# column names
names(yield_data) #or colnames(yield_data)

# Change the column names to lower case
names(yield_data) <- tolower(names(yield_data))
yield_data
```
#
#
#
#
#
#
#
#
list_a <- list(1, 2, "3", 4)
list_a
#
#
#
#
#
#
# Create a numeric vector 
vec_a <- 1:4
# Create a 
# Create a data.frame
yield_data <- 
  data.frame(
    Nitrogen = c(200, 180, 300),
    Yield = c(240, 220, 230),
    State = c("Kansas", "Nebraska", "Iowas")
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
#
#
#
#
#
#
#
#
#
#
#--- addition ---#
2 + 3
#--- subtraction ---#
6 - 2
#--- multiplications ---#
6 * 2
#--- exponentiation ---#
2 ^ 3
#--- division ---#
6 / 2
#--- remainder ---#
9 %% 4
#--- quotient ---#
9 %/% 4
#
#
#
#
#
#
a <- c(1, 3, 2)
b <- c(5, 7, 6)

# --- Addition --- #
a + 1
a + b

# --- Substraction --- #
a - 1
b - a

# --- Multiplication --- #
a*2
a*b
#
#
#
#
#
#
#
#
mat_a <- matrix(1:4, nrow = 2)
mat_b <- matrix(4:7, nrow = 2)


#--- Matrix Addition and Substraction ---#
mat_a + mat_b
mat_b - mat_a

# --- Matrix Multiplication using %*% operator --- #
mat_a %*% mat_b

# --- Matrix Transpose --- #
t(mat_a)
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
#
#
#
#
#
#
#
#
#
#
#
#
#
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
# this code only works in my local machine
flight_dt <- readRDS(file = "/Users/shunkeikakimoto/Dropbox/git/R_summer_2024/Data/flight.rds")
#
#
#
#
#
#
#
#
#
#
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
# On your Rsdutio, run the following code
getwd() #wd stands for working directory
# In my case, this returns my home directory: "/Users/shunkeikakimoto"
#
#
#
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
setwd("/Users/shunkeikakimoto/Dropbox/git/R_summer_2024/Data")
#
#
#
#
#
#| eval: false
flight_dt <- readRDS(file = "flight.rds")
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
