
### Tutorial Aims

#### <a href="Tutorial Introduction"> 1. Tutorial Introduction </a>
##### <a href="Learning Outcomes"> Learning Outcomes </a>
##### <a href="Requiremed Skills"> Requiremed Skills </a>

#### <a href="From linear models to hierarchical regression analysis"> 2. From linear models to hierarchical regression analysis </a>

#### <a href="Hierarchical Regression Analysis"> 3. Hierarchical Regression Analysis </a>
##### <a href="3.1 Setting a hypothesis"> 3.1 Setting a hypothesis </a>
##### <a href="3.2 Checking assumptions"> 3.2 Checking assumptions </a>
##### <a href="3.3 Selection Approach "> 3.3 Selection Approach </a>
##### <a href="3.4 Model Creation "> 3.4 Model Creation </a>

#### <a href="# Stepwise regression analysis "> 4. Stepwise regression analysis </a>

#### <a href="Stepwise regression analysis"> 5. Stepwise regression analysis </a>
#### <a href="7.1 MASS package "> 5.1 MASS package </a>
#### <a href="7.2 olsrr package "> 5.2 olsrr package </a>

#### <a href="HRA and SRA: Advantages and Drawbacks"> 6. HRA and SRA: Advantages and Drawbacks </a>

#### <a href="Challenge"> 7. Challenge </a>

#### <a href="Additional Materials"> 8. Additional Materials </a>

#### <a href="References"> 9. References </a>

---------------------------
<a name="1. Introduction"></a>
## 1. Introduction
This tutorial is designed for R users who want to learn how to use **hierarchical and stepwise regression analysis**, to **identify significant and powerful predictors** influencing your explanatory variable from a bigger number of potential variables. 

<a name="Learning Outcomes"></a>
### Learning Outcomes 
**1. Understand what Multiple Regression is.**  
**2. Learn what Hierarchical Regression Analysis is and when to use it.**   
**3. Step-by-step introduction how to perform a Hierarchical Regression Analysis.**  
**4. Learn what Stepwise Regression Analysis is and when to use it.**  
**4. Compute a simple Stepwise Regression Analysis.**  
**5. Advantages and Drawbacks of Hierarchical and Stepwise Regression Analysis, when to use them and when not to.**   

<a name="Required Skills"></a>
### Required Skills 
To complete this tutorial some basic knowledge about building statistical models and using R is required. If you have no experience with using R and the basics of data manipulation and visualisation yet, please familiarize yourself with the program first, to get the most out of the tutorial. You can have a look at the relevant [Coding Club tutorials](https://ourcodingclub.github.io/tutorials.html) linked to these topics. You should also be comfortable with performing and evaluating simple statistical tests, such as [ANOVA](https://ourcodingclub.github.io/tutorials/anova/) and [linear modelling in R](https://ourcodingclub.github.io/tutorials/model-design/), before attempting these slightly more advanced statistical tests. 

> **_NOTE:_** *All the material you need to complete this tutorial can be downloaded from [this repository](https://github.com/ourcodingclub/CC-anova). Click on `Code` / `Download ZIP`and downloand and unzip the folder, or clone the repository to your R studio.*

<a name="2. From linear models to hierarchical regression analysis"></a>
## 2. From linear models to hierarchical regression analysis
The relationship between a dependent (or response) variable and an independent variable (also called 'predictors', 'covariates', 'explanatory variables' or 'features') can be estimated/modelled with regression analysis. Linear regression is used to find a linear line which fits the most data points according to a specific mathematical criterion. This can be help us understand and predict the behaviour of complex systems or analyse observational and experimental data.

However, linear models only describe the relationship between one dependent and one independent variable. This can be especially limiting in environmental systems, where most processes or observations are influenced by a variety of different factors. This is where multiple regression comes in: **multiple linear regressions** can give a line of best fit to predict the relationship of a dependent and multiple independent variables. 
While this allows the exploration of many factors that may influence a dependent variable, such models can become increasingly more complex, as more and more explanatory variables are added. When [interactions]() or [polynomials]() are included, things can become exceedingly. Thus it is important to identify the parameters which actually influence the dependent variable and make a significant statistical contribution to our model.
While this selection process should always be based on **scientific reasoning** and an **understanding of the theory of the systems** studied, there are statistical methods that can help us with the selection process based on statistical criteria: Once a sensible subset of parameters has been narrowed down, hierarchical regression analysis (HRA), can be used to compare successive regression models and to determine the significance that each one has above and beyond the others. This tutorial will explore how the basic HRR process can be conducted in R. 

> **_NOTE:_** *Do not confuse hierarchical regression analysis with hierarchical modelling. Hierarchical modelling is a type of “multi-level modeling” which is a used to model data with a nested structure. [This website] explains the differences between hierarchical regression and modelling very well if you are still having trouble separating them.*

<a name="3. Hierarchical Regression Analysis "></a>
## 3. Hierarchical Regression Analysis 

<a name="3.1 Setting a hypothesis "></a>
### 3.1 Setting a hypothesis  
Determining a research question and setting a hypothesis before the statistical analysis of your data is always imperative for good science. Because HRA is used to find the best subset of predictors it is usually advisable to set a non-directional, rather than a directional hypothesis (also called experimental hypothesis). 

> **_NOTE:_** *directional hypothesis: 
Non-directional hypothesis:*

In this tutorial we will use a data on plant traits collected around the world. You can download the data from [this github repository]() and import it into a new R script. 
A bit of preliminary analysis shows that the plant traits data set contains 36 observations for 178 different plant species. 

```
# Load Data ----
traits <- read.csv("plant_traits.csv")

# Explore Data Frame (df) ----
head(traits)
str(traits)
nrow(traits)
ncol(traits)
```

Our **research goal** is to identify the best predictors for plant height out of the 35 possible predictor variables included in the data set. A non-directional **hypothesis** (or study intention) could be frased as: *The best subset of parameters influencing/ predicting plant height will be identified.*

<a name="3.2 Checking assumptions"></a>
### 3.2 Checking assumptions  
As mentioned above, HRA is based on linear regression and thus has to conform to the assumptions of linear regression. 
These assumptions are: 
1)	**Linearity**: The relationship between the response and explanatory variables is linear. 
2)	**Homoscedacity**: The variance in the residuals (or amount of error in the model) is similar at each point across the model (also called constant variance).  
3)	**Normality**: The data is normally distributed. 
4)	**No Multi-collinearity**: The predictor variables are not too highly correlated with each other. 
5)	**Absence of outliers**: There are no outliers that influence the relationship excessively.  

It is important to check if these assumptions apply to our data before you start modelling, as well as after we have run the model, in the residuals. 

So lets check the distribution of our dependent variable, plant height, with a histogram. 
```
# Check data distribution
## Plot Histogram in basic R 
hist(traits$height, breaks = 10) # non normal distribution, right skew
```
<p align="center">
  <img src="https://user-images.githubusercontent.com/91228202/145286937-c6a575be-5c3f-4a1c-82d9-846114322ffe.png" />
<p align="center"> *Figure 1. Distribution of plant height(m).* </p>

We can see that the data is not normally distributed, but strongly right skewed. To deal with this we can log the data, which removes oftentimes skewdness (if you want to know more about what log transformation does to your data and why it removes a skew, you can read the paper by Feng at al. 2014 in the [resources folder]()). 

```
# Log transforming data, to achieve normal distribution
traits <-  traits %>%
  mutate(log.ht = log(height))   #create new collum with log[height]

# Check log distribtuion 
hist(traits$log.ht, breaks = 10) # close to normal
```
<p align="center"><img src="https://user-images.githubusercontent.com/91228202/145290312-9a44c8b6-deba-4920-9198-26513ce34dfe.png" />
<p align="center"> *Figure 2. Distribution of log[plant height(m)].* </p>

While the data still does not look perfectly normally distributed it should be fine for modelling. Perfect normal distributions are rare in environmental data and linear models are not that sensitive to slight abnormalities in distribution. However, it is important to check the residuals of the model we will build, to be able to prove the validity of your statistical method. 

> **_NOTE:_** *If you are not familiar with the different types of distributions, have a look at this [website](https://www.itl.nist.gov/div898/handbook/eda/section3/eda366.htm) or this [CC turotial](https://ourcodingclub.github.io/tutorials/modelling/).* 

<a name="3.3 Selection Approach"></a>
### 3.3 Selection Approach 
Models can be compared using a range of different criteria, such as R2, AIC, AICc, BIC or others. It is important to consider your data and the goal of your model when choosing a selection criterion. measure of fit

----
**Selection Criteria**  

**R-squared (R2)** *quantifies the  amount of variation in the dependent variable that can be explained by independent variables in a regression model. It is calculated as: 
<img width="211" alt="image" src="https://user-images.githubusercontent.com/91228202/145270140-be4306be-a75a-41fb-9761-482c654c1bf5.png"> </center> 
Usually a higher R2 is better, as it indicates a higher degree of variation is explained by the model. R2 only works for simple linear models. For multiple regression, where several independent variables are used, the **adjusted R-squared** should be used, as the R2 does not penalize overfitting and keeps increasing with every additional parameter. The adjusted R2 is able to deal with multiple parameters and will not increase if an additional parameter does not add predictive power.  
Drawbacks of R2 values include that it does not indicate bias in predictions and is susceptible to overfitting and data mining. It always needs to be examined in combination with residual plots! 
To learn more about the adjusted R2 and how to use it, you can read [this blogpost]( https://statisticsbyjim.com/regression/interpret-adjusted-r-squared-predicted-r-squared-regression/).*

**Akaike information criterion (AIC)** *can be used to determine the relative predictive power and goodness of model fit though an estimation of error. Its value indicates the quality of a model relative to other models in a set. A smaller AIC is usually better, however an AIC value cannot be considered out of context. The AIC value alone does not give an indication of the model quality, but is only useful when compared to related models. It estimated the amount of information lost from a model and includes trade-offs between goodness of fit  and the simplicity of the model. Thus, one of the great benefits of the AIC is that it penalizes overfitting and the addition of more parameters. 
For models with small sample sizes the AIC often selects models with too many parameters (overfitting). Thus the **AICc**, which is an AIC with a correction for small sample sizes, should be used when modelling small sample sizes. It invokes a greater penalty than AIC for each additional parameter estimated, which offers greater ‘protection’ against overfitting.* 

**Bayesian information criterion (BIC)** *is calculated similarly to the AIC. To decide which of the two to use we can generally ask what is our goal for model selection:* 
-	*Find the model that gives the best prediction (without assuming that any of the models are correct) use AIC*  
-	*Find the **true model**, with the assumptions that fit reality closest, use BIC (there is of course the question: what is true and how do we define the reality we are looking for, but let´s not get into this)*
----

It is often good practice to include both the AIC and the BIC into your model selection process and compare their evaluation of the model. However for simplicities sake we will use the AIC, which is easily computed and interpreted in R and includes a penalisation for **overparameterization**. 

<a name="3.4 Model Creation"></a>
### 3.4 Model Creation 
#### Null Model
A null model (also called intercept only model) is the simplest possible model. It should always be the first model in a HRA, especially when using the AIC. It can be used as a baseline to test if the change in predictive power through the addition of an explanatory variable is significantly different from zero: 

```
## Null model 
model.null <- lm(log.ht ~ 1, data=traits)
```
#### Add variables  
Let´s start with a simple model using only one parameter. The manual addition of parameters has to be based on scientific, ecological reasoning: What variable is most likely to influence plant height? Temperature and rain are very likely to have a significant impact on plant height. So the first addition is temperature: 

```
# Simple univariate model
model.1 <- lm(log.ht ~ temp, data=traits)
```
This first model delineates the influence of temperature on plant height.  
Before we can go on to add more parameters, we should check if the assumptions of a linear regression have been met in this simple model. This can be done using the `resid()` and the `plot()` function. 

```
# Check if assumptions are met 
resid1 <-  resid(model.1)
plot(resid1)                # Equal variance, no observable patterns
plot(model.1)               # Model assumptions are met, some outliers, 
                            # but none outside Cook´s distance (residuls vs leverage)
shapiro.test(resid1)        # p > 0.05, normally distributed residuals
```
The QQ-plot shows that the residuals are relatively normally distributed, as the majority of data points fall along the straight plotted line. 
The degree of unequal variance (heteroscedacity) present is shown in the scale-location plot. While the red line is slightly bend and not perfectly straight, the heteroscedactiy present is not big enough to assume equal variance is not met. In the residuals vs leverage plot influential outliers are identified. While there are several present, none fall outside of Cook´s distance, which would mean they have to be removed, due to their disproportioal impact. The fitted vs residual plot again shows small non-linear trends, but the majority of th residuals are following a linear pattern. 
To test the normality of the residuals a Shapiro-Wills test may be performed. This can be a bit confusing, because contrary to the p value in a t-test, this test is `significant´ (indicative of a normal distribution) if p > 0.05. This is the case for the residuals of our model and confirms a normal distribution.  

> **_NOTE:_** *Usually the interpretation of residuals is described in a lot less detail. In a paper or report you would just say: The residuals were normally distributed. However, they can be quite tricky to understand. This [website](https://rpubs.com/iabrady/residual-analysis)shows some good examples and explains the interpretation of residuals nicely.*

Now we can compare ´model.1´ to the null model, to see if the addition of temperature made a significant improvement to the models predictive power and if it is worth keeping in the model: 

```
# Check predcitive power 
AIC(model.null, model.1)
```
This returns the AIC of the null model and `model.1`.
```
> AIC(model.null, model.1)
           df      AIC
model.null  2 719.5867
model.1     3 671.2654
```
The AIC of `model.1` is smaller than that of the null model, so we can keep temperature and add more parameters: 

```
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
```
> **_NOTE_**: *While it is generally better to keep the number of predictors as low as possible to avoid overfitting, a general rule to determine the maximum number of predictors used is the `rule of ten´: you should have at least 10 times as many data points as parameters you are trying to estimate.*  

After we have build all the models we want to evaluate, we check their AIC to determine which parameters should be kept and do not add to the power of the model. 

```
> AIC(model.null, model.1, model.3, model.4, model.5, model.6, model.7, model.8)                
           df      AIC
model.null  2 719.5867
model.1     3 671.2654
model.3     5 659.8009
model.4     5 636.9401
model.5     5 639.2953
model.6     5 658.7810
model.7     5 658.0234
model.8     9 642.9715

Warning message:
In AIC.default(model.null, model.1, model.3, model.4, model.5, model.6,  :
  models are not all fitted to the same number of observations
```

Thus we have determined model.4 is has the best model fit.  
> **_NOTE:_** *When comparing models be careful to make sure the same number of observations is used for each parameters (this will avoid the warning message that shows up), as some data sets have N/A values. To avoid this it can be helpful to clean your data first. This [CC tutorial](https://ourcodingclub.github.io/tutorials/data-manip-efficient/) teaches you how to do that.* 

Now we can check the residuals again to see if it meet the assumptions of linear regression. 
```
# Check residuals 
resid4 <-  resid(model.4)
plot(resid1)                # Equal variance, no observable patterns
plot(model.4)               # Model assumptions are met, some outliers (e.g.6,96,146)
                            # but none outside Cook´s distance (residuls vs leverage)
shapiro.test(resid4)        # p>0.05 = normal distribution
```
They do! 

#### Conclusion 
Based on the HRA we have performed, the best subset of parameters to predict plant height are temperature, rain and Leaf area index.

However, we have not checked all possible variations. As we have a big number of parameters, checking all possible combinations can take quite a long time. To make things faster we can use an automated computation process, that checks the models for us, step by step: **Stepwise Regression Analysis**

<a name="4. Stepwise regression analysis"></a>
## 4. Stepwise regression analysis 
<p align="center"><img src="https://c.tenor.com/l9JLon0fufoAAAAC/funny-aerobics.gif" width="500" height="400" /></p>

While in HRA you decide what terms to enter at which stage, stepwise regression analysis (SRA) is an automated process in which the program enters and discards terms based on the criterion you selected (e.g. R2, AIC, BIC). 

There are many packages that can perform SRA in R. We will use ´ls_step from the ´olsrr´ package. 

The requirements for SRA are the same as for HRA. Thus the data distribution and residuals have to be checked! 

First we define the model we want to evaluate. To include all parameters into the model it may be constructed like this: 

```
all <- lm(log.ht ~ ., data=traits)
```
However, the plant traits data set includes parameters that are not of ecological importance, such as the person taking the measurements, and categorical parameters. While these can be included into regression models, this is a bit more complex and we will focus on continuous variables.  
Thus a subset of variables to be tested can be defined: 

```
step.model <- lm(log.ht ~ alt + temp + rain + LAI + NPP + hemisphere + isotherm, data=traits)
```
We can feed this model into the stepwise function we have selected now: 

<a name="4.1 MASS package"></a>
### 4.1 MASS package
SRA can be performed forwards and backwards. **Forward** selection is a *bottom-up* approach where you start with no predictors and search through the single-variable models and then add variables, until we find the best model. **Backward** selection is the opposite approach. All predictors are included into the model and the predictors with the least statistical significance are dropped until the model with the lowest AIC is found. 

> **_NOTE:_** *Forward stepwise selection is usually more suitable when the number of variables is bigger than the sample size.*

Most R SRA packages include a function for `both´, where selection carried out in both directions. This is what we will use here. 
Including ´trace = TRUE´ prints out all the steps that R performs. 

```
step_traits <- stepAIC(step.model, trace = TRUE, direction= "both")
```
The SRA comes to the same conclusion as we did. 

<a name="4.1 olsrr package"></a>
### 4.1 olsrr package
Using the olsrr package is even more simple. It includes several functions for SRA, we will use ` ols_step_best_subset()´ which compares models based on their AIC and is also bi-directional. 

```
SRA <- ols_step_best_subset(step.model)
SRA
```
We can visualise the change in AIC for each step with the ´plot()´ function. 
```
plot(SRA)
```
<p align="center"><img src="https://user-images.githubusercontent.com/91228202/145302803-7b022b17-3eca-4274-9c01-db322c0441ce.png" />
<p align="center"> *Figure 3. Stepwise Regression Analysis to determine best subset for plant height.* </p>

After computing a SRA the residuals of the resulting model have to be checked and you should always consider the output in the light of you knowledge of the studies background. 

<a name="5. HRA and SRA: Advantages and Drawbacks"></a>
## 5. HRA and SRA: Advantages and Drawbacks 

HRA has the advantage that you decide, based on scientific reasoning which parameters to include at what stage. However, if there is a large subset of parameters, this is can be quite time consuming. SRA simplifies the process and provides the ability to manage large amounts of potential predictor variables, fine-tuning the model to choose the best predictor variables from the available options. The process of SRA can be used to gain information about the quality of the predictor, even if the end result is not used for modelling. 
While SRA is one of the most common methods used in ecological and environmental studies, is has many drawbacks and in recent years there has been a call to abandon the method altogether (Wittingham et al., 2006). 
Some of the drawbacks of SRA (Wittingham et al., 2006) that should be considered when you are evaluating your results are: 
-	Parameter bias: parameter selection is based on testing whether parameters are significantly different from zero, this can lead to biases in parameters, over-fitting and incorrect significance tests. 
-	Algorithm impacts: the algorithm used (forward selection, backward elimination or stepwise), the order of parameter entry (or deletion), and the number of candidate parameters, can all affect the selected model.  
-	Collinearity:  cannot deal with intercorrelation of variables. Collinearity may lead to the program to disregard significant parameters
-	Best  model selection: SRA aims to select the single best model, which is often not possible. Several viable options may exist 
-	The use of p-values, F and Chi-squared tests and R2 values in SRA is problematic and may not present the actual statistical significance of parameters. 

Thus, SRA should only be used cautiously! 
However, it is easily computed (now that you know how to) and may provide some supplementary insights into the data you are exploring. 

<a name="6. Challenge"></a>
## 6. Challenge
If you haven’t had enough of HRA and SRA yet, you can try yourself at a data set from the [World Data Bank]() and find the best parameters to predict life expectancy. The data set, a starter script and solutions can be found in the linked [Github repository](). 

<a name="7. Supplementary material "></a>
## 7. Supplementary material 
**Supplementary material and links can be found in the [Github repository](https://github.com/EdDataScienceEES/tutorial-HeleneEngler) linked to this tutorial. **  

If you have any thoughts or questions, please contact me at m.helene.engler@ed.sms.ac.uk. 

<a name="8. References"></a>
## 8. References
WHITTINGHAM, M.J., STEPHENS, P.A., BRADBURY, R.B. and FRECKLETON, R.P. (2006), Why do we still use stepwise modelling in ecology and behaviour?. Journal of Animal Ecology, 75: 1182-1189. https://doi.org/10.1111/j.1365-2656.2006.01141.x

Feng, C., Wang, H., Lu, N., Chen, T., He, H., Lu, Y., & Tu, X. M. (2014). Log-transformation and its implications for data analysis. Shanghai archives of psychiatry, 26(2), 105–109. https://doi.org/10.3969/j.issn.1002-0829.2014.02.009


