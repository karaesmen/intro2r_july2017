
library(tidyverse)


### IMPORTANT !!! ###
# change the path to your directory
setwd("~/Google Drive/RLadiesColumbus/RIntro/RIntroductionWorkshop_July2017/Session5/")


# `mpg` data
#` ggplot2` dataset, you need to first load `tidyverse` or `ggplot2`       
# Fuel economy data from 1999 and 2008 for 38 popular models of car

library(tidyverse)
?mpg
head(mpg,3)
mpg$class[1:20]

# Data Visualization with `ggplot`: Barplots
# `geom_bar` is designed to make it easy to create bar charts that show **counts**
g <- ggplot(mpg, aes(class))
# Number of cars in each class:
g + geom_bar()

## Stacked 

g + geom_bar(aes(fill = drv))

## Side by side
g + geom_bar(aes(fill = drv), position = "dodge")

g + geom_bar(aes(fill = drv),position = position_dodge(width = 0.4))


## Visualizing data points or mean as barplot
df <- data.frame(trt = c("a", "b", "c"), outcome = c(2.3, 1.9, 3.2))
df

ggplot(df, aes(trt, outcome)) +
geom_col()

# You can also change colors easily

ggplot(df, aes(trt, outcome)) +
geom_col(fill="steelblue")

ggplot(df, aes(trt, outcome)) +
geom_col(aes(fill=trt))


## `geom_bar()` with continuous data
ggplot(iris, aes(Sepal.Length)) + geom_bar()

# Data Visualization with `ggplot`: Histograms

ggplot(iris, aes(Sepal.Length)) + geom_histogram(binwidth = 0.2)

ggplot(iris, aes(Sepal.Length, fill=Species)) + 
geom_histogram(binwidth = 0.5)

ggplot(iris, aes(Sepal.Length, fill=Species)) + 
geom_histogram(binwidth = 0.5, alpha=0.4)

ggplot(iris, aes(Sepal.Length, fill=Species)) + 
geom_histogram(binwidth = 0.5, position = "identity", alpha=0.4)


# Data Visualization with `ggplot`: Boxplots


# Example `ToothGrowth` dataset

head(ToothGrowth)
?ToothGrowth

gb <- ToothGrowth %>% 
unite(regimen, -len, sep= "_") %>% 
ggplot(data=., aes(regimen, len)) +
geom_boxplot(aes(color=regimen))

# 
# Are you confused with this code?    
# We could get the exact same result with the following:
ToothGrowth$regimen <- paste(ToothGrowth$supp, ToothGrowth$dose, sep="_")

gb <- ggplot(data=ToothGrowth, aes(regimen, len)) +
geom_boxplot(aes(color=regimen))
gb

# Bonus: `geom_dotplot`

set.seed(2211) # get the same random variables from the normal distribution
df <- data.frame(x= paste0("time",sort(rep(1:4, 25))), 
y= c(rnorm(25, 0, 2), 
rnorm(25, 1, 2), 
rnorm(25, 2, 2), 
rnorm(25, 3, 2)))
head(df)

# look at distribution of y
ggplot(data=df, aes(y)) + geom_histogram(binwidth = 1)

# look at distribution of x
ggplot(data=df, aes(x)) + geom_bar()

# now lets look with dotplot
ggplot(data=df, aes(x, y)) +
geom_dotplot(binaxis="y", 
binwidth = 0.5, 
stackdir = "centerwhole")

## Your turn
# Change the `binwidth` to `0.1`, `0.5`, `1` one by one. 
# Then change the `stackdir` to "up" (default), "down", "center", "centerwhole".

# What's happening?

## Let's go back to ToothGrowth data and apply `geom_dotplot`

gb + geom_dotplot(binwidth = 0.5,
aes(fill = regimen),
alpha = 0.3,
binaxis = "y", 
stackdir = "center")


# Writing custom functions in R

# Now I would like to write my own custom functions to compute some of the statistics.    
# For that I will use the `function()` function. For example, I would like to define a function called `add5mult3mean` that    
# 
# > 1. Takes a numeric vector    
# > 2. Adds 5 to all of its elements    
# > 3. Multiplies with 3   
# > 4. And finally gives the mean of this modified vector   

add5mult3mean <- function(x) {
  mean((x+5)*3)
  # comment1
  # comment 2
  }

myVec <- 1:10
add5mult3mean(myVec)

# or
mean((myVec+5)*3)


# You can name the argument whatever you want as long as it's consistent throughout your function.    
# So the following would again give me the same:

add5mult3mean <- function(a_numeric_vector) mean((a_numeric_vector+5)*3)
add5mult3mean(myVec)


You can add as many arguments as you want and use objects in your environment.

irisChopper <- function(breaks){
chopped.iris <- data.frame(cat.Sep.Len = cut(iris$Sepal.Length, breaks = breaks),
cat.Sep.Wid = cut(iris$Sepal.Width, breaks = breaks),
cat.Pet.Len = cut(iris$Petal.Length, breaks = breaks),
cat.Pet.Wid = cut(iris$Petal.Width, breaks = breaks),
iris$Species)
head(chopped.iris)
}

irisChopper(10)
irisChopper(0:10)


# Now lets get back to our functions to calculate some statistics. 
# Function `sem()` computes the standard error of the mean for a numeric vector. Similarly, `ci95` function computes the mean confidence interval of the numeric vector given.

# here I am defining a function 
# that would compute the standard error of the mean
sem <- function(x) sd(x)/sqrt(length(x))

# here I am defining a function 
# that would compute the CI95.
# am computing this with t-distribution 
# since I don't know the population standard deviation and
# my sample size for each treatment group is less than 30 --- a general rule
# qt() function is the t-distribution quantile function. 
# It basically give the t-statistic value for the quantile given
ci95 <- function(x)  qt(0.975,df=length(x)-1)*sd(x)/sqrt(length(x))
```

# If you run these commands, you'll see that you have defined functions in your environment.    
# 
# Now let's apply these to our data using `dplyr` functions. 
# 
## Compute stats for `ToothGrowth`

tg.stats <- ToothGrowth %>% 
group_by(supp, dose) %>% # group by 
summarise(., 
mean.len = mean(len),  # mean
sd.len = sd(len),      # sd
se.len = sem(len),     # sem
ci95.len = ci95(len),  # ci95
n = length(len)) %>%   # count
right_join(ToothGrowth)

# Here I am using the pipe `%>%` and functions `group_by()`, `summarise()`, `right_join()` from the `dplyr` package. Let's not get into details now, but very briefly this is what I am doing:     
# 
# 1. `ToothGrowth %>%` I am piping the `ToothGrowth` data in the function that comes up next. This way I can keep piping things to other functions.    
# - `x %>% f(y)` is the same as `f(x, y)`      
# - `y %>% f(x, ., z)` is the same as `f(x, y, z )`   
# 
# 2. `group_by(supp, dose)`: Grouping it based on its `supp` and `dose` columns.    
# 
# 3. `summarize(...)`: Computing the statistics for every `len` observation in the respective `supp` and `dose` group. Statistics I compute are:     
# -`sd`    
# -`sem`    
# -`ci95`     
# `length` (this isn't really a statistic is just the count of the observation in each group)     
# 
# 5. right_join(ToothGrowth)I am appending the summary statistics to the original data    
# 
# Now this is how `tg.stats` look

tg.stats

## Point and Line graphs

Step by step:   

### 1. Just plot mean tooth length as data points


ggplot(tg.stats, aes(x=dose, y=mean.len, colour=supp)) + 
geom_point(aes(x=dose, y= mean.len), size=4, shape=18) 


# Oh you're wondering about the shapes? We'll come to that...

### 2. Add the error bars: Show confidence intervals

iris %>% summarise(mean(Sepal.Length:Petal.Width))



ggplot(tg.stats, aes(x=dose, y=mean.len, colour=supp)) + 
geom_point(aes(x=dose, y= mean.len), size=4, shape=18) +
geom_errorbar(aes(ymin=mean.len-ci95.len, ymax=mean.len+ci95.len), width=.1)


### 3. Add lines


ggplot(tg.stats, aes(x=dose, y=mean.len, colour=supp)) + 
geom_point(aes(x=dose, y= mean.len), size=4, shape=18) +
geom_errorbar(aes(ymin=mean.len-ci95.len, ymax=mean.len+ci95.len), width=.1) +
geom_line() 


### 4. Add original data points


ggplot(tg.stats, aes(x=dose, y=mean.len, colour=supp)) + 
geom_point(aes(x=dose, y= mean.len), size=4, shape=18) +
geom_errorbar(aes(ymin=mean.len-ci95.len, ymax=mean.len+ci95.len), width=.1) +
geom_line() + 
geom_point(aes(x=dose, y=len, fill=supp), alpha=0.4, size=1.5)


# Customizing graphs with `ggplot2`

## 1. Change titles and set scale limits

Modify axis, legend, and plot labels see [Reference ggplot2: Scale](http://ggplot2.tidyverse.org/reference/index.html#section-scales) 


ggplot(tg.stats, aes(x=dose, y=mean.len, colour=supp)) + 
geom_point(aes(x=dose, y= mean.len), size=4, shape=18) +
geom_errorbar(aes(ymin=mean.len-ci95.len, ymax=mean.len+ci95.len), width=.1) +
geom_line() + 
geom_point(aes(x=dose, y=len, fill=supp), alpha=0.3, size=1.5) +

# Here I add the titles I want    
labs(x="Supplement Dose",
y="Tooth Length",
title= "The Effect of Vitamin C on Tooth Growth in Guinea Pigs",
subtitle= "Comparing delivery methods: Orange Juice vs Ascorbic Acid",
caption = "Based on the data from R")


## Define the limits of axes


ggplot(tg.stats, aes(x=dose, y=mean.len, colour=supp)) + 
geom_point(aes(x=dose, y= mean.len), size=4, shape=18) +
geom_errorbar(aes(ymin=mean.len-ci95.len, ymax=mean.len+ci95.len), width=.1) +
geom_line() + 
geom_point(aes(x=dose, y=len, fill=supp), alpha=0.3, size=1.5) +

# Here I add the titles I want    
labs(x="Supplement Dose",
y="Tooth Length",
title= "The Effect of Vitamin C on Tooth Growth in Guinea Pigs",
subtitle= "Comparing delivery methods: Orange Juice vs Ascorbic Acid",
caption = "Based on the data from R") +

# Change x and y axes limits
xlim(0, 3) +
ylim(0, 60)
```


## 2. Change legend title


ggplot(tg.stats, aes(x=dose, y=mean.len, colour=supp)) + 
geom_point(aes(x=dose, y= mean.len), size=4, shape=18) +
geom_errorbar(aes(ymin=mean.len-ci95.len, ymax=mean.len+ci95.len), width=.1) +
geom_line() + 
geom_point(aes(x=dose, y=len, fill=supp), alpha=0.3, size=1.5) +

# Here I add the titles I want    
labs(x="Supplement Dose",
y="Tooth Length",
title= "The Effect of Vitamin C on Tooth Growth in Guinea Pigs",
subtitle= "Comparing delivery methods: Orange Juice vs Ascorbic Acid",
caption = "Based on the data from R") +

# Change the legend
guides(colour=guide_legend("Supplement"), fill=guide_legend("Supplement"))


## 3. Jitter points

pd <- position_dodge(0.1)

# my plot is getting very long, I'll assign it
tgp <- ggplot(tg.stats, aes(x=dose, y=mean.len, colour=supp)) + 
geom_point(aes(x=dose, y= mean.len), size=4, shape=18, position=pd) +
geom_errorbar(aes(ymin=mean.len-ci95.len, ymax=mean.len+ci95.len), width=.1, position=pd) +
geom_line(position=pd) + 
geom_point(aes(x=dose, y=len, fill=supp), alpha=0.3, size=1.5, position=pd) +


# Here I add the titles I want    
labs(x="Supplement Dose",
y="Tooth Length",
title= "The Effect of Vitamin C on Tooth Growth in Guinea Pigs",
subtitle= "Comparing delivery methods: Orange Juice vs Ascorbic Acid",
caption = "Based on the data from R") +

# Change the legend
guides(colour=guide_legend("Supplement"), fill=guide_legend("Supplement"))

tgp


## 4. Themes

Theme allows to make `cosmetic` changes


tgp + theme_bw()
tgp + theme_minimal()



## 5. Shapes

![](http://sape.inf.usi.ch/sites/default/files/ggplot2-shape-identity.png)


