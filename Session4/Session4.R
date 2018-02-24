


## Base R visualization

# - Simplest plotting in R   
# - Not very pretty
# - Difficult to customize   
# - Not so bad if you just want to use it for quick data exploration
# 
# **Basic plot syntax:**   
# 
# `plot(x , y)` `x`: vector for x axis, `y`: vector for y axis    
# 
# See `?plot`  

x <- 1:10 
y <- 1:10
plot(x, y)


### Base R visualization: Scatterplot  with `iris`

plot(iris$Sepal.Width, iris$Sepal.Length)

### Base R visualization: Histogram with `iris`

hist(iris$Sepal.Width)

### Base R visualization: Using `par()` to plot multiple plots

par(mfrow=c(1,2))
plot(iris$Sepal.Width, iris$Sepal.Length)
hist(iris$Sepal.Width)


## `plot()` vs `ggplot()`  

plot(iris$Sepal.Width, iris$Sepal.Length)
qplot(Sepal.Width, Sepal.Length, data = iris, color = Species)

### Add layers to `ggplot()`

qplot(Sepal.Width, Sepal.Length, data = iris, color = Species)
qplot(Sepal.Width, Sepal.Length, data = iris, color = Species, shape=Species, geom=c("point", "smooth"), main="ggplot")

### And make it interactive with `ggplotly()`
qiris <- qplot(Sepal.Width, Sepal.Length, data = iris, color = Species, shape=Species, geom=c("point", "smooth"), main="ggplot")
ggplotly(qiris)

# ggplot2: Create Elegant Data Visualisations Using the Grammar of Graphics

## Installation

# The easiest way to get ggplot2 is to install the whole tidyverse:
install.packages("tidyverse")

# Alternatively, install just ggplot2:
install.packages("ggplot2")

# Don't forget to load tidyverse to your environment
library(tidyverse)

# Or just ggplot2
library(ggplot2)



# Building a ggplot from scratch with `iris`   

## Step 0: Let's remember the `iris` data 
head(iris, 3)
summary(iris)

## Step 1. Define data and aesthetics woth `aes()`

p <- ggplot(data=iris, aes(x=Sepal.Width, y=Sepal.Length))
p

## Step 2. Define plot type with `geom_`

p <- ggplot(data=iris, aes(x=Sepal.Width, y=Sepal.Length))
p + geom_point()

## Step 3. Assign more aesthetics

### Step 3.1 Add `color`

p <- ggplot(data=iris, aes(x=Sepal.Width, y=Sepal.Length))
p + geom_point(aes(color=Species))


### Step 3.2 Add `color` + `size`

p <- ggplot(data=iris, aes(x=Sepal.Width, y=Sepal.Length))
p + geom_point(aes(color=Species, size=Petal.Length))

### Step 3.3  Add `color` + `size` + `alpha` (transparency)

p <- ggplot(data=iris, aes(x=Sepal.Width, y=Sepal.Length))
p + geom_point(aes(color=Species, size=Petal.Length, alpha=Petal.Width))

### Step 3.4  Add `color` + `size` + `alpha` + `shape`

p <- ggplot(data=iris, aes(x=Sepal.Width, y=Sepal.Length))
p + geom_point(aes(color=Species, size=Petal.Length, alpha=Petal.Width, shape=Species))

## Step 4. Customize legend

p <- ggplot(data=iris, aes(x=Sepal.Width, y=Sepal.Length))
p + geom_point(aes(color=Species, size=Petal.Length, alpha=Petal.Width, shape=Species)) +
  guides( color=guide_legend(ncol = 3, byrow = TRUE), 
          size=guide_legend(ncol = 3, byrow = TRUE), 
          alpha=guide_legend(ncol = 3, byrow = TRUE))

## Step 5: Assign more `geom`: `point` + `smooth` 

p <- ggplot(data=iris, aes(x=Sepal.Width, y=Sepal.Length))
p + geom_point(aes(color=Species, size=Petal.Length, alpha=Petal.Width)) + 
  geom_smooth()


# Step 5.1: Assign more `geom`: `point` + `smooth`

p <- ggplot(data=iris, aes(x=Sepal.Width, y=Sepal.Length, color=Species))
p + geom_point(aes(size=Petal.Length, alpha=Petal.Width)) + 
  geom_smooth()

# Why did this work now?   
# Can you see the difference?

# Step 5.2: Assign more `geom`: `point` + `smooth`

p <- ggplot(data=iris, aes(x=Sepal.Width, y=Sepal.Length))
p + geom_point(aes(size=Petal.Length, alpha=Petal.Width)) + geom_smooth(aes(color=Species))

# What about this?
# What's happening here?


## Step 6: Facetting

### Step 6.0: Create a toy dataset

# Let's generate a hypothetical `iris` with some added ecosystem type and precipitation data.
# 
# - 3 types of ecosystem: Forest, Riparian, Urban
# - 2 types of precipitation: Heavy, Mild
# 
# Here I am using the `sample()` function which allows me to randomly pick variables from a vector.   
# I assign the 150 variables I want to pick with `size = 150` and `replace=TRUE` allows me to pich these variables multiple times.   
# Then I assign these to my new dataset `iris2` with column names `Ecosystem` and `Precipitation`

ecosys <- sample(c("Forest", "Riparian", "Urban"), size = 150, replace = T)
precp <- sample(c("Heavy", "Mild"), size = 150, replace = T)

iris2 <- cbind(iris, Ecosystem=ecosys, Precipitation=precp)
head(iris2)


### Step 6.1: Facet `iris2`
# Now, I would like to see how my previous graph changes for the different types of ecosystem and precipitation.    
# 
# This was the graph :    
#   
# I am not using `geom_smooth` for now because I do not have enough data points for model prediction.    
# Also I will remove the `alpha` aesthetic to make it easier for us to see.

p2 <- ggplot(data=iris2, aes(x=Sepal.Width, y=Sepal.Length, color=Species))
p2 <- p2 + geom_point(aes(size=Petal.Length)) # + geom_smooth() 
p2

# **Now I added facets!**
  
p2 + facet_grid(Ecosystem ~ Precipitation) 

# **I can customize the facets very easily!**
  
p2 + facet_grid( . ~ Precipitation) 

p2 + facet_grid(Ecosystem ~ .) 

p2 + facet_grid(Precipitation ~ .) 

# You get the idea here right?

### Step 6.2: Facet `wages2`

# You can use `facet_wrap` if you want to facet by just 1 variable but you want to organize them nicely.
# 
# **Example with `wages` data **

#' First, let's read the `wages` data in R.    
wages <- read.csv("./wages.csv", 
                  header = T, 
                  stringsAsFactors = T) 
head(wages, 3)


# Below I am turning the continous `age` varialbe into a categorical variable with `cut()` function.    
# I am also setting categorical intervals increasing by 20  years with the `breaks = seq(20, 100, by=20)` argument. 
# Then I assign this new variable to a new column called `age_cat`.   
wages <- wages %>% mutate(age_cat = cut(age, breaks = seq(20, 100, by=20)) )
head(wages, 4)

# Let's plot it

pw <- ggplot(wages, aes(x=height, y=earn)) +
geom_point(aes(size=ed), alpha=0.5)

# Now I will plot this data and facet it by age categories. 
# `facet_grid` will not be able to facet so many categories nicely. 
# So I will use `facet_wrap` to have a nice and organized plot.


pw
pw + facet_wrap(~age_cat)


# Or you can specify the rows and columns for the faceting


pw + facet_wrap(~age_cat, ncol=5)



# **Your turn** (5 mins)

Plot the `wages.csv` data like the following

pw <- ggplot(wages, aes(x=age, y=earn, color=sex))
pw + geom_point(aes(size=ed), alpha=0.5) + 
geom_smooth() +
facet_wrap(~ race)
