##Stepwise regression Analysis 
#Loading required R packages

library(tidyverse) #data manipulation and visualization
library(caret) #machine learning workflow
library(leaps) #computing stepwise regression
library(ggplot2) #data visualisation 
library(dplyr)

setwd("/Users/HeleneEngler/University/R/tutorial-HeleneEngler")
mtcars<-mtcars
ggplot(mtcars, aes(x=mpg)) + geom_histogram()

mtcars$mpg_log <- mutate(log(mpg))
  

ggplot(mtcars, aes(x=mpg_log)) + geom_histogram()

bp <- read.csv("Inputs/bloodpress1.csv", header = TRUE, sep = ".")
str(bp)
bp %>% separate("Pt	BP	Age	Weight	BSA	Dur	Pulse	Stress", c("Pt", "BP"))
             
#col_names = "BP", "Age", "Weight", "BSA",
               "Dur", "Pulse", "Stress")
spec(bp)





