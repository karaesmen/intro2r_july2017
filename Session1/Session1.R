
## R Objects

### Assigning R objects

# Save information as an R object with the greater than 
# sign followed by a minus, e.g, an arrow: `<-`

foo <- 42
foo

# When you create an R object, you'll see it appear in your **Environment pane**

### Common R workflow
foo <- round(3.1415) + 1 
foo
factorial(foo)


## Because if you don't save the output in a variable, 
## you would only output it to the console. And can't use it as an input for the next function.

round(3.1415) + 1 


## Data Structures ##

### Vectors
# Concatenate multiple elements into a one dimensional array.
# Create with the `c()` function.

vec <- c(1, 2, 3, 10, 100)
vec

### Matrices

# Multiple elements stored in a two dimensional array.
# Create with the `matrix()` function

mat <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2)
mat

### Math: element-wise

vec
vec + 4
vec * 4
vec * vec

## Data types (classes) ##

### Numeric
# Any number, no quotes.
# Appropriate for math.

1+ 1
3000000
class(0.00001)


### Character

# Any symbols surrounded by quotes.
# Appropriate for words, variable names, messages, any text.

"hello"
class("hello")

# Check the number of characters in a character element.
nchar("hello")

# Merge two character elements into one with `paste()`
paste("hello", "world")

### Logical
# `TRUE` (or just `T`) or `FALSE` (or just `F`)
# R's form of binary data. Useful for logical tests.

3< 4
class(TRUE)
class(T)
class(FALSE)
class(F)


### Factor

# R's form of categorical data. Saved as an integer with a set of labels (e.g. levels).
vec2 <- c("a", "b","b", "c", "d", "a") # vec2 is a character vector
fac <- factor(vec2) #now fac is factor
class(fac)
fac

# One can easily change the "labels" e.g. `levels` of a factor
# Let's change `a` to `apple` and `d` to `dragonfruit`
fac
levels(fac)
levels(fac) <- c("apple", "b", "c", "dragonfruit")
fac


### Classes and Data Structures

# Vector and matrices cannot have different class elements. 
# For example a vector cannot contain a character, a number or a logical all at the same time. 
# Therefore if there are **any** characters, all other elements of the vector are coerced to character class. 

v1 <- c("R", 1, TRUE)
class(v1)
v1


# If the vector contains numeric and logical elements, 
# all will coerce to numeric, where `TRUE` equals to `1` and `FALSE` equals to `0`.

v2 <- c(1, TRUE)
class(v2)
v2



# List and data frames generalize vectors and matrices to allow multiple types of data.

### List
# A list is a one dimensional group of R objects.
# Create lists with `list()`

lst <- list(1, "R", TRUE) 
class(lst)
lst


# The elements of a list can be anything. 
# Even vectors, matrices, data frames or other lists.

list(c(1, 2), TRUE, c("a", "b", "c"), matrix(c(1:10), nrow = 2))


### Data frame

# A data frame is a two dimensional group of R objects.
# Each column in a data frame can be a different type (class).
# (But the elements of a column cannot be of different type.)

df <- data.frame( c(1, 2, 3),  #this one is numeric
                  c("R","S","T"), # this one is character
                  c(TRUE, FALSE, TRUE)) #this one is logical
class(df)
df


### Names

# You can name the elements of a vector, list, or data frame when you create them.


#vector
nvec <- c(one = 1, two = 2, three = 3)
nvec

# list
nlst <- list(one = 1, 
             two = 2,
             many = c(3, 4, 5))

nlst

# data frame
ndf <- data.frame(numbers = c(1, 2, 3),
                  letters = c("R","S","T"),
                  logic = c(TRUE, FALSE, TRUE))


# You can also see and set the names with names. (Similar to `levels()`, do you remember that one?)

names(nvec)
names(nvec) <- c("uno", "dos", "tres") 
nvec

# Once you have the names set up, you can call columns of a data frame or elements of a vector or a list very easily.

# vector
nvec["uno"]

# list -- attention to double brackets
nlst[["many"]]
# or
nlst$many

# data frame
ndf["numbers"]
# or
ndf$numbers

