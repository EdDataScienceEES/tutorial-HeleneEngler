##Stepwise regression Analysis 
#Loading required R packages

library(tidyverse) #data manipulation and visualization
library(caret) #machine learning workflow
library(leaps) #computing stepwise regression
library(ggplot2) #data visualisation 
library(dplyr)
library(olsrr)
#install.packages("olsrr")
#install.packages("leaps")
#install.packages("lcaret")

setwd("/Users/HeleneEngler/University/R/tutorial-HeleneEngler")
mtcars<-mtcars

#ols_step_all_possible(model, ...)
# S3 method for ols_step_all_possible
model <- lm(mpg ~ ., data = mtcars)
k <- ols_step_all_possible(model)
k

# plot
plot(k)

# use the fitplus package to detrmine distribution!!!
