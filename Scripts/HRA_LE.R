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
#install.packages("MASS")
#install.packages("olsrr")
#install.packages("leaps")
#install.packages("lcaret")

# Set your Working Directory 
setwd("/Users/HeleneEngler/University/R/tutorial-HeleneEngler")

# Load Data ----
LED <- read.csv("Inputs/LifeExpectancyData.csv")

do.call(rbind.data.frame, LED1)
as.data.frame(LED)

# Explore Data Frame (df)
str(LED15)

# Clean df 
LED15 <- LED %>%   
  clean_names() %>%         #clean df names (replace . with _, remove capitalisation)
  filter(year == 2015)      #keep most recent values to make df more managable

# Check data distribution ----
## Plot Histogram in basic R 
hist(LED15$life_expectancy, breaks = 10) # Slight left skew, but close to normal 
## OR
## Plot Histogram with ggplot2
ggplot(LED15, aes(x=life_expectancy)) + 
  geom_histogram(bins = 30)             # Plotted this way distribution looks less normal

### Shapiro test 
shapiro.test(LED15$life_expectancy)     # p < 0.05 indicates non-normal distribuion

#### Log transforming data 
LED_15 <-  LED15 %>%
  mutate(le_log = log(life_expectancy))

#LED15_log <- mutate(LED15, le_log = log(life_expectancy) )

##### Recheck distribution 
ggplot(LED_15, aes(x=le_log)) + 
  geom_histogram(bins = 30)
shapiro.test(LED_15$le_log)

# Linear model creation ----
## Null model 
model.null <- lm(le_log ~ 1, data=LED_15)

##Simplest model possible 
model.1 <- lm(le_log ~ adult_mortality, data=LED_15)

resid1 <-  resid(model.1)
plot(resid1)
plot(model.1)
shapiro.test(resid1)
bartlett.test(life_expectancy ~ adult_mortality, data=LED15)

##Next parameter 
model.2 <- lm(le_log ~ adult_mortality + measles, data=LED_15)

anova(model.null, model.1, model.2)
AIC(model.null, model.1, model.2)
BIC(model.null, model.1, model.2)

### Next parameter
model.2 <- lm(le_log ~ adult_mortality + population, data=LED_15)

resid <- residuals.lm(model.1)
plot(resid)


# Stepwise regression analysis ----
str(LED15)

LED15_SRA <- LED15 %>%
  select(-country, -status)

model <- lm(life_expectancy ~ ., data = LED15_SRA)
k <- ols_step_all_possible(model)


b <- stepAIC(model, direction = "forward", trace = FALSE)
anova(k)
AIC(k)
quine.stp <- stepAIC(LED15)
quine.stp$anova

library(BIEN)


