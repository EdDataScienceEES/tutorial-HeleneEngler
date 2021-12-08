#Challenge Script 
## SRA using life expecancy data

library(tidyverse)  #Data manipulation and visualization
library(caret)      #Machine learning workflow
library(leaps)      #Computing stepwise regression
library(ggplot2)    #Data visualisation 
library(dplyr)      #Data manipulation and visualization
library(lme4)       #Linear Models 
library(janitor)    #Data cleaning
library(olsrr)
library(devtools)
library(MASS)       #StepAIC
#install.packages("MASS")
#install.packages("olsrr")
#install.packages("leaps")
#install.packages("lcaret")

# Set your Working Directory 
setwd("/Users/HeleneEngler/University/R/tutorial-HeleneEngler")

# Load Data ----
LED <- read.csv("Inputs/LifeExpectancyData.csv")

#do.call(rbind.data.frame, LED1) #if imported as list
#as.data.frame(LED)              #if imported as list

# Explore Data Frame (df)
str(LED15)

# Clean df 
LED15 <- LED %>%   
  clean_names() %>%         #clean df names (replace . with _, remove capitalisation)
  filter(year == 2015)      #keep most recent values to make df more managable

# Check data distribution ----

# Plot Histogram in basic R 
hist(LED15$life_expectancy, breaks = 10) # Slight left skew, but close to normal 
## OR
#Plot Histogram with ggplot2
ggplot(LED15, aes(x=life_expectancy)) + 
  geom_histogram(bins = 30)             # Plotted this way distribution looks less normal

# Shapiro test 
shapiro.test(LED15$life_expectancy)     # p < 0.05 indicates non-normal distribuion

#Log transforming data 
LED_15 <-  LED15 %>%
  mutate(le_log = log(life_expectancy))

#LED15_log <- mutate(LED15, le_log = log(life_expectancy) )

# Recheck distribution 
ggplot(LED_15, aes(x=le_log)) + 
  geom_histogram(bins = 30)
shapiro.test(LED_15$le_log)

# SRA
# Null model 
model.null <- lm(le_log ~ 1, data=LED_15)

#MASS package 
step_model <- lm(le_log ~ ., data=LED_15)
step_life_expct <- stepAIC(step.model, trace = TRUE, direction= "both") 

# SRA with olsrr package
SRA <- ols_step_best_subset(step.model)
SRA
plot(SRA)


