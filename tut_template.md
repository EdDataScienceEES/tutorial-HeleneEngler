![AdobeStock_102891724-658317-edited](https://user-images.githubusercontent.com/91228202/145046505-2f0455c5-51ae-4aba-8a35-8f6d6b25f396.jpeg)</center>

### Tutorial Aims

#### <a href="From linear models to hierarchical regression analysis"> 1. From linear models to hierarchical regression analysis</a>

#### <a href="Hierarchial Regression Analysis - What is it?"> 2. Hierarchial Regression Analysis - What is it? </a>

#### <a href="When to use HRA?"> 3. When to use HRA? </a>

#### <a href="When to use HRA?"> 4. When to use HRA? </a>
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

At the beginning of your tutorial you can ask people to open `RStudio`, create a new script by clicking on `File/ New File/ R Script` set the working directory and load some packages, for example `ggplot2` and `dplyr`. You can surround package names, functions, actions ("File/ New...") and small chunks of code with backticks, which defines them as inline code blocks and makes them stand out among the text, e.g. `ggplot2`.

When you have a larger chunk of code, you can paste the whole code in the `Markdown` document and add three backticks on the line before the code chunks starts and on the line after the code chunks ends. After the three backticks that go before your code chunk starts, you can specify in which language the code is written, in our case `R`.

To find the backticks on your keyboard, look towards the top left corner on a Windows computer, perhaps just above `Tab` and before the number one key. On a Mac, look around the left `Shift` key. You can also just copy the backticks from below.

```r
# Set the working directory
setwd("your_filepath")

# Load packages
library(ggplot2)
library(dplyr)
```

<a name="section2"></a>

## 2. The second section

You can add more text and code, e.g.

```r
# Create fake data
x_dat <- rnorm(n = 100, mean = 5, sd = 2)  # x data
y_dat <- rnorm(n = 100, mean = 10, sd = 0.2)  # y data
xy <- data.frame(x_dat, y_dat)  # combine into data frame
```

Here you can add some more text if you wish.

```r
xy_fil <- xy %>%  # Create object with the contents of `xy`
	filter(x_dat < 7.5)  # Keep rows where `x_dat` is less than 7.5
```

And finally, plot the data:

```r
ggplot(data = xy_fil, aes(x = x_dat, y = y_dat)) +  # Select the data to use
	geom_point() +  # Draw scatter points
	geom_smooth(method = "loess")  # Draw a loess curve
```

At this point it would be a good idea to include an image of what the plot is meant to look like so students can check they've done it right. Replace `IMAGE_NAME.png` with your own image file:

<center> <img src="{{ site.baseurl }}/IMAGE_NAME.png" alt="Img" style="width: 800px;"/> </center>

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
