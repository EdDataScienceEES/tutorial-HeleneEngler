#Stepwise regression Analysis Tutorial 
## by Helene Engler 

#Loading required R packages ----
library(tidyverse)  # Data manipulation and visualization
library(ggplot2)    # Data visualisation 
library(lme4)       # Linear Models 
library(janitor)    # Data cleaning
library(olsrr)      # Stepwise regression analsysis

##Install necessary packages
#install.packages("tidyverse")
#install.packages("ggplot2")
#install.packages("lme4")
#install.packages("janitor")
#install.packages("olsrr")

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

### Log transforming data, to achieve normal distribution
traits <-  traits %>%
  mutate(log.ht = log(height))

#### Check log distribtuion 
hist(traits$log.ht, breaks = 10) # close to normal 

#### Plot Histogram with ggplot2
ggplot(traits, aes(x=log.ht)) + 
  geom_histogram(bins = 30)     

### Shapiro test 
shapiro.test(traits$log.ht)       # p < 0.05 indicates non-normal distribuion
# but usually linear models are not too sensitive, we will push on and look at the residuals
# to determine if assumptions have been met 

# Linear model creation ----
## Null model 
model.null <- lm(log.ht ~ 1, data=traits)

## Simple univariate model
model.1 <- lm(log.ht ~ temp, data=traits)

### Check predcitive power 
AIC(model.null, model.1)

### Check if assumptions are met 
resid1 <-  resid(model.1)
plot(resid1)                # Equal variance, no observable patterns
plot(model.1)               # Model assumptions are met, some outliers, 
                            # but none outside Cook´s distance (residuls vs leverage)
shapiro.test(resid1)        # p > 0.05, normally distributed residuals

#### Add on to the model
model.2 <- lm(log.ht ~ temp + rain, data=traits) # Include rain
AIC(model.null, model.1, model.2)                # Addition of rain improves model

model.3 <- lm(log.ht ~ temp + rain + alt, data=traits) # Include altitude
AIC(model.null, model.1, model.3, model.4)             # Altitude does not improve model fit, discard

model.4 <- lm(log.ht ~ temp + rain + hemisphere, data=traits) # Include hemisphere
AIC(model.null, model.1, model.3, model.4)                    # Hemisphere improves model 

# Stepwise regression analysis ----
## Define null model
null.model <- lm(log.ht ~ 1, data=traits)

## Define model with all predictors that may influence the dependent variable
step.model <- lm(log.ht ~ alt + temp + rain + LAI + NPP + hemisphere, data=traits)
#all <- lm(log.ht ~ ., data=traits) --> this way all variables will be checked
# here there are a lot, many more than 2 cathegories (not possible), 
# it takes a long time to compute too many variables

### SRA with olsrr package
SRA <-ols_step_all_possible(step.model)
SRA
plot(SRA)

#### to compare AIC
ols_step_best_subset(step.model)


### Forward selection process 
forward <- step(null.model, direction='forward', scope=formula(all), trace=0)
### Backward selection process 
backward <- step(null.model, direction='backward', scope=formula(all), trace=0)
### Forward & Backward selection process 
both <- step(null.model, direction='both', scope=formula(all), trace=0)
