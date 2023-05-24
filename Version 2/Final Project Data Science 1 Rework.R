library(tidyverse)
library(lubridate)
library(clifro)
library(RColorBrewer)
library(DataExplorer)
library(sjPlot)
library(corrplot)
library(MASS)
library(cluster)
library(randomForest)
require(caTools)
library(car)
library(boot)

source("RainierFunctions.R")

set.seed(1234)

merged <- read_csv("CleanedRainier.csv")

merged$DayNum <- as.factor(merged$DayNum)
#-------------------------------------------------------------------------------
# EDA

# Basic EDA

# Windrose to analyze the wind data
plot.windrose(spd = merged$`Wind Speed Daily AVG`, dir = merged$`Wind Direction AVG`, 
              spdmin = min(merged$`Wind Speed Daily AVG`), spdmax = max(merged$`Wind Speed Daily AVG`),
              spdres = 10)

# Normal Probability Plots
qqPlot(merged$`Temperature AVG`)
qqPlot(merged$`Wind Speed Daily AVG`)
qqPlot(merged$`Wind Direction AVG`)
qqPlot(merged$`Relative Humidity AVG`)
qqPlot(merged$`Solare Radiation AVG`)

# Histograms faceted by month
merged %>%
  ggplot(aes(x = SuccessGroup, fill = SuccessGroup)) +
  geom_bar() +
  facet_wrap(~ month(Date, label = TRUE)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Successes per Month")

merged %>%
  ggplot(aes(x = SuccessGroup, fill = SuccessGroup)) +
  geom_bar() +
  facet_wrap(~ Day) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Successes vs Day")

merged %>% 
  ggplot(aes(x = `Temperature AVG`)) +
  geom_histogram() +
  facet_wrap(~ month(Date, label = TRUE)) +
  labs(title = "Average Temperature per Month")

merged %>% 
  ggplot(aes(x = `Wind Speed Daily AVG`)) +
  geom_histogram() +
  facet_wrap(~ month(Date, label = TRUE)) +
  labs(title = "Average Wind Speed per Month")

merged %>% 
  ggplot(aes(x = `Relative Humidity AVG`)) +
  geom_histogram() +
  facet_wrap(~ month(Date, label = TRUE)) +
  labs(title = "Relative Humidity per Month")

merged %>% 
  ggplot(aes(x = `Solare Radiation AVG`)) +
  geom_histogram() +
  facet_wrap(~ month(Date, label = TRUE)) +
  labs(title = "Solar Radiation per Month")

# Quant-Quant EDA

# Plotting main variables against eachother with facets on success group
merged %>% ggplot(aes(x = `Temperature AVG`, y = `Wind Speed Daily AVG`, color = SuccessGroup)) +
  geom_point() + facet_wrap(~ SuccessGroup) + labs(title = "Temperature vs Wind Speed")

merged %>% ggplot(aes(x = `Temperature AVG`, y = `Relative Humidity AVG`, color = SuccessGroup)) +
  geom_point() + facet_wrap(~ SuccessGroup) + labs(title = "Temperature vs Humidity")

merged %>% ggplot(aes(x = `Temperature AVG`, y = `Solare Radiation AVG`)) +
  geom_point() + facet_wrap(~ SuccessGroup) + labs(title = "Temperature vs Solar Radiation")

merged %>% ggplot(aes(x = `Solare Radiation AVG`, y = `Relative Humidity AVG`, color = SuccessGroup)) +
  geom_point() + facet_wrap(~ SuccessGroup) + labs(title = "Solar Radiation vs Humidity")

# Plotting variables against success percentage
merged %>% ggplot(aes(x = `Success Percentage`, y = `Wind Speed Daily AVG`)) + 
  geom_point() + geom_smooth() +
  labs(title = "Success Percentage vs Wind Speed")

merged %>% ggplot(aes(x = `Success Percentage`, y = `Wind Direction AVG`)) + 
  geom_point() + geom_smooth() +
  labs(title = "Success Percentage vs Wind Direction")

merged %>% ggplot(aes(x = `Success Percentage`, y = `Temperature AVG`)) + 
  geom_point() + geom_smooth() + 
  labs(title = "Success Percentage vs Temperature")

merged %>% ggplot(aes(x = `Success Percentage`, y = `Solare Radiation AVG`)) + 
  geom_point() + geom_smooth() +
  labs(title = "Success Percentage vs Solar Radiation")

#-------------------------------------------------------------------------------
# Basic Regression

modelSubset <- merged[,c(5:10,13)]

modelCor <- cor(modelSubset[,2:6])
corrplot(modelCor, type = "upper", method = "shade", diag = FALSE)

model <- lm(data = modelSubset, formula = `Success Percentage` ~ .)
summary(model)
plot_model(model, type = "diag", grid = TRUE)


#-------------------------------------------------------------------------------
# Bootstrapping

reps <- boot(data = modelSubset, rsq_function, R = 5000, formula = `Success Percentage` ~ .)
reps
plot(reps)

#-------------------------------------------------------------------------------
# Cluster Analysis & Feature Reduction

clustSubset <- merged[,c(6:10,13)]
clust <- kmeans(clustSubset, 2)
clusplot(clustSubset, clust$cluster, color = T)

step.model <- stepAIC(model, direction = "both", trace = FALSE)
summary(step.model)
plot_model(step.model, type = "diag", grid = TRUE)

reps.step <- boot(data = modelSubset, rsq_function, R = 5000, formula = step.model$call$formula)
reps.step
plot(reps.step)



#-------------------------------------------------------------------------------
# Random Forest

forestSubset <- merged[,c(6:11)]
forestSubset$SuccessGroup <- as.factor(forestSubset$SuccessGroup)

names(forestSubset) <- make.names(names(forestSubset))

sample <- sample.split(forestSubset$SuccessGroup, SplitRatio = .75)
train <- subset(forestSubset, sample == TRUE)
test  <- subset(forestSubset, sample == FALSE)

rf <- randomForest(formula = SuccessGroup ~ ., data = forestSubset)
rf

pred <- predict(rf, newdata=test[-6])
pred <- as.data.frame(pred)
test <- as.data.frame(test)

cm <- table(test[,6], pred[,1])
cm















