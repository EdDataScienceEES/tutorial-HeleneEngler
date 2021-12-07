##Stepwise regression Analysis 
#Loading required R packages

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
library(stats)
#install.packages("stats")
#install.packages("MASS")
#install.packages("olsrr")
#install.packages("leaps")
#install.packages("lcaret")

# Set your Working Directory 
setwd("/Users/HeleneEngler/University/R/tutorial-HeleneEngler")

# Load Data ----
traits <- read.csv("plant_traits.csv")

# Explore Data Frame (df)
str(traits)

# Check data distribution ----
## Plot Histogram in basic R 
hist(traits$height, breaks = 10) # non normal distribution, right skew 

### Log transforming data 
traits <-  traits %>%
  mutate(log.ht = log(height))
hist(traits$log.ht, breaks = 10) 

## Plot Histogram with ggplot2
ggplot(traits, aes(x=log.ht)) + 
  geom_histogram(bins = 30)      # Plotted this way distribution looks less normal

### Shapiro test 
shapiro.test(traits$log.ht)       # p < 0.05 indicates non-normal distribuion

# Linear model creation ----
## Null model 
model.null <- lm(log.ht ~ 1, data=traits)

## Simplest model
model.1 <- lm(log.ht ~ temp, data=traits)
### Check predcitive power 
AIC(model.null, model.1)

#### Add on 
model.2 <- lm(log.ht ~ temp + rain, data=traits) # Include rain
AIC(model.null, model.1, model.2)                # Addition of rain improves model

model.3 <- lm(log.ht ~ temp + rain + alt, data=traits) # Include altitude
AIC(model.null, model.1, model.3, model.4)             # Altitude does not improve model fit, discard

model.4 <- lm(log.ht ~ temp + rain + hemisphere, data=traits) # Include hemisphere
AIC(model.null, model.1, model.3, model.4)                    # Hemisphere improves model 

# Stepwise regression analysis ----
## Define null model
null.model <- lm(log.ht ~ 1, data=traits)
## Define model with all predictors
all <- lm(log.ht ~ ., data=traits)
forward <- step(null.model, direction='forward', scope=formula(all), trace=0)

# View results of forward stepwise regression
forward$anova
str(traits)
step.model <- lm(log.ht ~ alt + temp + rain + LAI + NPP + hemisphere, data=traits)
SRA <-ols_step_all_possible(step.model)

SRA
plot(SRA)
ols_step_best_subset(step.model)



