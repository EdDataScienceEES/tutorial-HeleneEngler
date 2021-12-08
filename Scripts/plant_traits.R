# Multiple Regression Analysis Tutorial 
## by Helene Engler 

# Learning outcomes:
## Learn how to perform Hierarchical Regression Analysis 
## Learn how to perform Stepwise Regression Analysis 

#Loading required R packages ----
library(tidyverse)  # Data manipulation and visualization
library(ggplot2)    # Data visualisation 
library(lme4)       # Linear Models 
library(janitor)    # Data cleaning
library(olsrr)      # Stepwise regression analsysis
library(MASS)       # Stepwise regression analsysis

##Install necessary packages
#install.packages("tidyverse")
#install.packages("ggplot2")
#install.packages("lme4")
#install.packages("janitor")
#install.packages("olsrr")
#install.packages("MASS")

# Set your Working Directory 
setwd("/Users/HeleneEngler/University/R/tutorial-HeleneEngler")

# Load Data ----
traits <- read.csv("plant_traits.csv")

# Explore Data Frame (df) ----
head(traits)
str(traits)
nrow(traits)
ncol(traits)

## Check data distribution
### Plot Histogram in basic R 
hist(traits$height, breaks = 10) # non normal distribution, right skew 

# Log transforming data, to achieve normal distribution
traits <-  traits %>%
  mutate(log.ht = log(height))

# Check log distribtuion 
hist(traits$log.ht, breaks = 10) # close to normal 

# Plot Histogram with ggplot2
ggplot(traits, aes(x=log.ht)) + 
  geom_histogram(bins = 30)     

# Shapiro test 
shapiro.test(traits$log.ht)       # p < 0.05 indicates non-normal distribuion
## but usually linear models are not too sensitive, we will push on and look at the residuals
## to determine if assumptions have been met 

# Linear model creation ----
# Null model 
model.null <- lm(log.ht ~ 1, data=traits)

# Simple univariate model
model.1 <- lm(log.ht ~ temp, data=traits)

# Check predcitive power 
AIC(model.null, model.1)

# Check if assumptions are met 
resid1 <-  resid(model.1)
plot(resid1)                # Equal variance, no observable patterns
plot(model.1)               # Model assumptions are met, some outliers, 
                            # but none outside Cook´s distance (residuls vs leverage)
shapiro.test(resid1)        # p > 0.05, normally distributed residuals

# Add on to the model
model.2 <- lm(log.ht ~ temp + rain, data=traits)                # Include rain
model.3 <- lm(log.ht ~ temp + rain + alt, data=traits)          # Include altitude
model.4 <- lm(log.ht ~ temp + rain + LAI, data=traits)          # Include LAI
model.5 <- lm(log.ht ~ temp + rain + NPP, data=traits)          # Include NPP
model.6 <- lm(log.ht ~ temp + rain + hemisphere, data=traits)   # Include hemisphere
model.7 <- lm(log.ht ~ temp + rain + isotherm, data=traits)     # Include isotherm
model.8 <- lm(log.ht ~ temp + rain + hemisphere + LAI + alt + NPP + isotherm, data=traits) # Include all
##...

AIC(model.null, model.1, model.3, model.4, model.5, model.6, model.7, model.8)                

# Check residuals 
resid4 <-  resid(model.4)
plot(resid1)                # Equal variance, no observable patterns
plot(model.4)               # Model assumptions are met, some outliers (e.g.6,96,146)
                            # but none outside Cook´s distance (residuls vs leverage)
shapiro.test(resid4)        # p>0.05 = normal distribution 


# Stepwise regression analysis ----

# Define model with all predictors that may influence the dependent variable
step.model <- lm(log.ht ~ alt + temp + rain + LAI + NPP + hemisphere + isotherm, data=traits)
## all <- lm(log.ht ~ ., data=traits) --> this way all variables will be checked
## The plant trait data set includes a number of parameters with little ecological value 
## e.g. sort number, those are unceseary to include
## Having a lot of parameters also takes a long time to compute 

# SRA with MASS package 
step_traits <- stepAIC(step.model, trace = TRUE, direction= "both")    # both directions
# step_traits_b <- stepAIC(step.model, trace = TRUE, direction= "backward") # backward selection
# step_traits_f <- stepAIC(step.model, trace = TRUE, direction= "forward") # forward selection
## only works with the 'all model' 

# SRA with olsrr package
SRA <- ols_step_best_subset(step.model)
SRA
plot(SRA)
