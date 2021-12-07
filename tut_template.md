![AdobeStock_102891724-658317-edited](https://user-images.githubusercontent.com/91228202/145046505-2f0455c5-51ae-4aba-8a35-8f6d6b25f396.jpeg)</center>

### Tutorial Aims

#### <a href="From linear models to hierarchical regression analysis"> 1. From linear models to hierarchical regression analysis</a>

#### <a href="When to use HRA?"> 2. When to use HRA? </a>
##### <a href="Setting a Research question"> - Setting a Research question </a>
##### <a href="Requirements/Assumptions"> - Requirements </a>

#### <a href="Model Selection"> 5. Model Selection </a>
##### <a href="Comparison Criteria"> - Comparison Criteria </a>
##### <a href="Forewards & Backwards"> - Forewards & Backwards </a>
##### <a href="Evaluating your results "> - Evaluating your results  </a>

#### <a href="When to use HRA?"> 6. When to use HRA? </a>

#### <a href="Stepwise regression analysis"> 7. Stepwise regression analysis </a>

#### <a href="HRA and SRA: Benefits and Drawbacks"> 8. HRA and SRA: Benefits and Drawbacks </a>

#### <a href="Additonal Code: Visualizing Predictions"> 9. Additonal Code: Visualizing Predictions </a>

#### <a href="Challenge"> 10. Challenge </a>

---------------------------
This tutorial is designed for R users who want to learn how to use **hierarchical and stepwise regression analysis**, to **identify significant and powerful predictors** influencing your explanatory variable from a bigger number of potential variables. 

To complete this tutorial some basic knowledge about building statistical models and using R is required. If you have no experience with using R and the basics of data manipulation and visualisation yet, please familiarize yourself with the program first, to get the most out of the tutorial. You can have a look at the relevant [Coding Club tutorials](https://ourcodingclub.github.io/tutorials.html) linked to these topics. You should also be comfortable with performing and evaluating simple statistical tests, such as [ANOVA](https://ourcodingclub.github.io/tutorials/anova/) and [linear modelling in R](https://ourcodingclub.github.io/tutorials/model-design/), before attempting these slightly more advanced statistical tests. 

{% capture callout %}
All the files you need to complete this tutorial can be downloaded from [this repository](https://github.com/ourcodingclub/CC-anova). Click on `Code/Download ZIP` and unzip the folder, or clone the repository to your own GitHub account.
{% endcapture %}
{% include callout.html content=callout colour = alert %}

<a name="1. From linear models to hierarchical regression analysis"></a>

## 1. From linear models to hierarchical regression analysis
The relationship between a dependent (or response) variable and an independent variable (also called 'predictors', 'covariates', 'explanatory variables' or 'features') can be estimated/modelled with regression analysis. Linear regression is used to find a linear line which fits the most data points according to a specific mathematical criterion.
Such linear regressions have significant limits, not only because the predictions can only be made in a linear fashion, but most importantly it can only fit data sets with one dependent and one independent variable. This is where multiple regression comes in: with linear regression a linear line of best fit can be used to predict the relationship of a dependent and multiple independent variables. Such regression variables can become increasingly more complex, and often convoluted, as more and more explanatory variables are added. 
Furthermore, they can become exceedingly convoluted when things such as polynomials and interactions are explored. 
Thus it is important to identify the parameters wich actually influence the dependent variable and make a significant statistical contribution to our model. This selection process shuld always be based on scientific reasoning and an understanding of the theory of the system studied. But once a sensible subset of parameters has been narrowed down, hierarchical regression analysis (HRA), can be used to compare successive regression models and to determine the significance that each one has above and beyond the others. This tutorial will explore how the basic HLR process can be conducted in R

(not to be confused with hierarchical modelling, which is a used to delineate the relationship of nested explanatory data and a response variable)

**Enoutgh theory for now, lets start coding!**  

<a name="2. When to use HRA?"></a>
## 2. Hierarchical regression analysis
You can open a new R script, set your working direcory and load the libraries we will need:

```
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
```
We will use a data on plant traits collected around the world: 

```
# Load Data ----
traits <- read.csv("plant_traits.csv")

# Explore Data Frame (df) ----
head(traits)
str(traits)
nrow(traits)
ncol(traits)
```
Our goal is to identify the best predictors for plant height out of the 35 possible predictor variables included in the data set. 

```
*This data has already been cleaned and is in long format. If you are using your own data and need to do that check out this tutorial on data manipulation.*
```

<a name="Setting a Research question"></a>
### Setting a Research question 
Setting a hypothesis before the statistical analysis of your data is always imperative for good science. Because HRA is used to find the best subset of predictors it is usually advisable to set a non-directional, rather than a directional hypothesis (also called experimental hypothesis). Using the plant data as an example, a non-directional hypothesis or research question could be: The best subset of parameters influencing/ predicting plant height will be identified. 

<a name="Requirements/Assumptions"></a>
### Requirements/Assumptions

## HRA Step by Step
Once a subset of predictors has been identified through scientific reasoning, several approaches may be used: 
Bottom up or top down 

Text Box 
Bottom up= starting with the simplest possible version and adding more and more complexity
Top down = starting with a model including all parameters and dropping parameters until the model fit does not improve further

### Selection criteria 
Models can be compared using a range of different criteria, such as R2, AIC, AICc, BIC or others 
When comparing models the data has to have the same number of data points 
Text Box
-	AIC / AICc 
-	R2 
-	BIC

Here we will use AIC (why) 

### Step 1: Null Model 
A null model (also called intercept only model) is the simplest possible model. It should be step before adding any other predictive terms, as a baseline to test if the change in predictive power through the addition of an explanatory variable is significantly dignificantly different from zero: 

```
## Null model 
model.null <- lm(log.ht ~ 1, data=traits)
```
### Step 2: Add variables  
Lets start with a simple model using only one parameter. The manual addition of parameters has to be based on scientific, ecological reasoning.  
What variable is most likely to influence plant height? Temperature and rain are very likely to have a significant impact on plant height. So lets start by adding temperature: 

```
## Simple univariate model
model.1 <- lm(log.ht ~ temp, data=traits)
```
So our first model delineates the influence of temperature on plant height.  
First lets check if the assumptions have been met:
*Note: If you don’t know how to analysie residual plots check out this website, which gives a pretty good explanation of how to interpret the 4 residual plots*

```
### Check if assumptions are met 
resid1 <-  resid(model.1)
plot(resid1)                # Equal variance, no observable patterns
plot(model.1)               # Model assumptions are met, some outliers, 
                            # but none outside Cook´s distance (residuls vs leverage)
shapiro.test(resid1)        # p > 0.05, normally distributed residuals
```

The residuals are relatively normally distributed, there seems to be no obvious heteroscedacity or obnoxious outliers that absolutely have to be removed 

Now we can compare ´model.1´ to the null model, to see if the addition of temperature made a significant improvement to the models predictive power and if it is worth keeping in the model: 

```
### Check predcitive power 
AIC(model.null, model.1)
```
The AIC of ´model.1´ is smaller than that of the null model, so we can keep temperature and add more parameters: 

```
#### Add on to the model
model.2 <- lm(log.ht ~ temp + rain, data=traits) # Include rain
AIC(model.null, model.1, model.2)                # Addition of rain improves model

model.3 <- lm(log.ht ~ temp + rain + alt, data=traits) # Include altitude
AIC(model.null, model.1, model.3, model.4)             # Altitude does not improve model fit, discard
```
After each addition we should recheck the AIC to determine if the parameter is a useful addition or if it should be excluded. As you can see the addition of altitude increases the AIC and it is therefore discarded from the model. 

model.4 <- lm(log.ht ~ temp + rain + hemisphere, data=traits) # Include hemisphere
AIC(model.null, model.1, model.3, model.4)                    # Hemisphere improves model

As we have a big number of parameters, checking all possible combinations can take quite a long time. Thus we can use an automated computation process, that checks the models for us, step by step: **Stepwise Regression Analysis**

Stepwise regression analysis 
In hierarchical regression you decide which terms to enter at what stage, basing your decision on substantive knowledge and statistical expertise.
In stepwise, you let the computer decide which terms to enter at what stage, telling it to base its decision on some criterion such as increase in 𝑅2R2, AIC, BIC and so on.
When to use which? Use hierarchical regression when you have knowledge of the field in which you are building a model. As for stepwise... well, I am tempted to say "don't use it". If you must use an automated procedure, you should use one that penalizes models for complexity, such as LASSO or LAR. The problems of stepwise have been discussed here many times, searching for stepwise should find lots of posts.


<a name="section1"></a>

## 3. The third section

More text, code and images.

This is the end of the tutorial. Summarise what the student has learned, possibly even with a list of learning outcomes. In this tutorial we learned:

##### - how to generate fake bivariate data
##### - how to create a scatterplot in ggplot2
##### - some of the different plot methods in ggplot2

We can also provide some useful links, include a contact form and a way to send feedback.

For more on `ggplot2`, read the official <a href="https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf" target="_blank">ggplot2 cheatsheet</a>.

Everything below this is footer material - text and links that appears at the end of all of your tutorials.

<hr>
<hr>

#### Check out our <a href="https://ourcodingclub.github.io/links/" target="_blank">Useful links</a> page where you can find loads of guides and cheatsheets.

#### If you have any questions about completing this tutorial, please contact us on ourcodingclub@gmail.com

#### <a href="INSERT_SURVEY_LINK" target="_blank">We would love to hear your feedback on the tutorial, whether you did it in the classroom or online!</a>

<ul class="social-icons">
	<li>
		<h3>
			<a href="https://twitter.com/our_codingclub" target="_blank">&nbsp;Follow our coding adventures on Twitter! <i class="fa fa-twitter"></i></a>
		</h3>
	</li>
</ul>

### &nbsp;&nbsp;Subscribe to our mailing list:
<div class="container">
	<div class="block">
        <!-- subscribe form start -->
		<div class="form-group">
			<form action="https://getsimpleform.com/messages?form_api_token=de1ba2f2f947822946fb6e835437ec78" method="post">
			<div class="form-group">
				<input type='text' class="form-control" name='Email' placeholder="Email" required/>
			</div>
			<div>
                        	<button class="btn btn-default" type='submit'>Subscribe</button>
                    	</div>
                	</form>
		</div>
	</div>
</div>
