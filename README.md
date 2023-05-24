# Data-Science-1-Project
My Data Science 1 final project done at UW-Plattevile in Spring 2022

## Goal of the project
This project was done as my final project in Data Science 1. The goal of the project was to take the skills learned during the semester and apply them to a dataset of our choosing. The dataset of choice was information on the summiting success rate for Mt. Rainier found on [Kaggle][kag-link]. This dataset was chosen for my interest in hiking and because it had features available to perform various basic regression machine learning algorithms. The project was a collaborative effort between me and another member of my class.

## First Rendition/Submitted Version
This first version is the one that me and my group member presented on.  

### Skills Used:
- Data Cleaning & Feature Creation
- Exploratory Data Analysis
- Regression Modeling
- Basic Machine Learning

### Data Cleaning
1. Merged the 2 provided datasets on date
1. Created a feature that calculates percentage of successes
1. Dropped success percentages if they exceeded 100%
1. Created new categorical variables for analysis
    1. Coded Success to a pass/fail. 50% and greater are a pass
    1. Coded wind speed to either low, medium, or high  


### Exporatory Data Analysis
Initially we look at basic histograms and statistics for all quantitative variables. An example can be seen below:  

![TempAvg](https://github.com/cvanallen/Data-Science-1-Project/assets/100979971/2a98d2bc-a084-45f3-986c-103e006e34d9)  

We also created basic bar plots to get counts of coded variables such as wind speed. Additionally with categorical variables we compared them to quatitative to see any trends. Similarly the process was carried out with the quantitative variables to see how they effect the variable we want to predict, success percentage/success code.  

![WindSpeedBox](https://github.com/cvanallen/Data-Science-1-Project/assets/100979971/4c7cd749-8b19-4ba1-8222-017d615f07e1)  
![HumiditySuccess](https://github.com/cvanallen/Data-Science-1-Project/assets/100979971/2e56f087-d6f0-4118-bc74-4185628df5a2)  

### Modeling
For this project we had only looked at basic linear regression and k-nearest neighbors during the semester, so those were the tools available for us. Using the base lm() function in R we created a linear model to predict success percentage based on the basic weather variables of wind speed and direction, temperature, humidity, and solar radiation. Similarly we used the same variables in a k-nearest neighbors model.  

Both models did not perform the best, with the linear regression model performing very poorly due to the large number of success percentage values of 0% and 100%. The k-nearest neighbors modle performed poorly as well, but better than the regression model. The k-nearest neighbors model was able to predict about 65% of the values correctly.

### Conclusions
For the first version of this project it was a good learning experience of things we could improve on. For the linear regression model we could have implemented bootstrapping to account for the large values at the extreme ends. For the k-nearest neighbors model there was not much we could do because at this point we did not know how to tune the models for better performance.

## My Review of the 2022 Version
As part of a rework I wanted to review my code from the first version and find issues and things I could fix in a newer version after completing all my coursework in Spring 2023. Below is a list of things I thought were good, bad, and my future plans:  

### Things I Liked:
- The creation of new variables was good
- Use of boxplots was informative for categorical vs quantitative
- Histograms were okay, could be improved  

### Things I Didn't Like:
- Everything got merged into a single dataframe rather than some of the features
- Loose code created dataframes that were unused
- Plot provided for linear model are hard to understand if you have no background in statistics
- The confusion matrix provided by the k-nearest neighbors function was hard to read  

### Future Plans:
- Try to refine linear model with bootstrapping
- Look for models other than k-nearest neighbors
- Look at the effect of date and time on variables
- Better visualizations
- Provide more information overall  

## Refined Version (Post Graduation 2023)  
Taking the skills I learned through other classes and skills I learned in my free time, I wanted to take the suggestions and comments and try and improve the project. Using skills learned in Data Science 2, various math and statistics classes, and a class on Data Science Ethics I sought to compile a version I would be proud of.

### Skills Used:
- Data Cleaning & Feature Creation
- Exploratory Data Analysis
- Regression Modeling
- Basic Machine Learning Methods
- Feature Selection Methods
- Dimensionality Reduction Methods  

### Data Cleaning & Feature Creation
The process was very similar to the first project. This version however took the data cleaning process and split it, along with functions and the main file, into multiple files for easy reading. This version also used less categorical variables than the first version with only variables made on the success and fail rate, and the day of the week. The data cleaning process also creates a new .csv file so that the cleaning process isn't carried out every time the code is run.  

### Exploratory Data Analysis
This time around in the data analysis process I wanted to look at different visualization types. I wanted to create a better visualization for the wind direction variable using a function found on [stack overflow][windrose-link].  
<br>
![windrose](https://github.com/cvanallen/Data-Science-1-Project/assets/100979971/1b9c24a8-7fff-48a3-aa6e-97a2425090b7)  

Additionally I wanted to create normal probability plots to assess the normaility of the quanitative data rather than using histograms.  
![Probplot](https://github.com/cvanallen/Data-Science-1-Project/assets/100979971/d8fd64f0-61c7-4fb4-8bc1-c0d29dbb8c1f)  

When looking at day there didn't appear to be any big correlations aside from the fact that Mondays and Tuesdays did not perform as well.  
![DayPlot](https://github.com/cvanallen/Data-Science-1-Project/assets/100979971/a6fb7d12-bbcd-49ac-9c53-23475693040f)  

Finally, I looked at scatterplots for the variables, temperature in this case, to see how they play an effect on the success of climbers.  
![Temp](https://github.com/cvanallen/Data-Science-1-Project/assets/100979971/b780430c-ce83-414f-bc98-34ee23280ef9)
<br>
![Temp2](https://github.com/cvanallen/Data-Science-1-Project/assets/100979971/10ffbc57-7024-4113-a5d1-98762f8f16c4)  

### Linear Modeling  
Like the first version I wanted to create a baseline linear regression model to see how the features perform at prediction. Like the last model it did not perform as well as it could. Even when the addition of bootstrapping to the model, the results did not improve either.  

### Dimensionality Reduction
When looking at the clusterplot created from all the variables it is clear to see that there are no 2 sperate groups for above and below 50% success rate, meaning the data will be harder to predict on overall.  
<br>
![Cluster](https://github.com/cvanallen/Data-Science-1-Project/assets/100979971/e6305728-1510-4348-bc71-89f822980e6f)  
<br>

After using the linear model and bootstrapping I decided to take the model and put it through a stepwise function to select the best variables in both the forward and backward directions. After doing so I looked at the results and they were about as good as the original linear model. This leads me to conclude that a simple regression model will not be enough to predict.  

### Random Forest  
After the first version of the project I wanted to look for other machine learning algorithms to apply. I decided to use a random forest method to try and predict. Overall the results of the random forest were about the same as the original k-nearest neighbors model giving a prediction rate of 70% for the testing set.

## Final Thoughts and Conclusion  
I believe that the second version that I made was a definite improvement to the process. Although the results were similar, I believe that the sataset that I chose was not the best. Given the small number of data points (~500), there is no way currently to use the methods I did to get a better result. In the future I may revist the problem and look at using python and more complex models like catboost to find a better solution.  



[kag-link]: https://www.kaggle.com/datasets/codersree/mount-rainier-weather-and-climbing-data
[windrose-link]: https://stackoverflow.com/questions/17266780/wind-rose-with-ggplot-r
