library(tidyverse)
library(lubridate)
library(DataExplorer)
library(gmodels)
# library(caret)
library(class)

weather <- read_csv("Rainier_Weather.csv")
climb <- read_csv("climbing_statistics.csv")

climb$Date <- mdy(climb$Date)
weather$Date <- mdy(weather$Date)

climb <- climb %>% group_by(Date, Route) %>% 
  summarise_each(funs(sum)) %>% mutate(`Success Percentage` = Succeeded/Attempted)

fullmerge <- left_join(weather, climb, by = "Date")

fullmerge <- fullmerge %>% filter(!is.na(Route))

fullmerge <- fullmerge %>% drop_columns(2)

fullmerge <- fullmerge %>% filter(`Success Percentage` <= 1)

fullmerge <- fullmerge %>% mutate(Pass = case_when(`Success Percentage` <= 0.50 ~ "Fail",
                                                    TRUE ~ "Pass"))

fullmerge$Pass <- factor(fullmerge$Pass,levels=c("Pass","Fail"),labels = c("Pass","Fail"))

climb2 <- climb[c(1,3:5)] %>% group_by(Date) %>% 
  summarise_each(funs(sum)) %>% mutate(Pass = Succeeded/Attempted)

fullmerge <- fullmerge %>% 
  mutate(CatWindSpeed = case_when(`Wind Speed Daily AVG` < 20 ~ "Low",
                                  `Wind Speed Daily AVG` < 40 ~ "Medium",
                                  TRUE ~ "High"))

merged <- left_join(x = weather, y = climb2, by = "Date")

fullmerge <- as.data.frame(fullmerge)

# Quantitative Values

summary(fullmerge$`Temperature AVG`)
fullmerge %>% ggplot(aes(x= `Temperature AVG`)) + geom_histogram()

summary(fullmerge$`Relative Humidity AVG`)
fullmerge %>% ggplot(aes(x = `Relative Humidity AVG`)) + geom_histogram()

summary(mullmerge$`Success Percentage`)
fullmerge %>% ggplot(aes(x = `Success Percentage`)) + geom_histogram()

# Qualitative

fullmerge %>% ggplot(aes(x = CatWindSpeed)) + geom_bar()
table(fullmerge$CatWindSpeed)

# Quant-Quant

fullmerge %>% ggplot(aes(x = `Relative Humidity AVG`, y = `Temperature AVG`)) + geom_point()
fullmerge %>% ggplot(aes(x = `Success Percentage`, y = `Temperature AVG`)) + geom_point()
fullmerge %>% ggplot(aes(x = `Success Percentage`, y = `Relative Humidity AVG`)) + geom_point()

# Quant - Cat

fullmerge %>% ggplot(aes(x = CatWindSpeed, y = `Temperature AVG`)) + geom_boxplot()
fullmerge %>% ggplot(aes(x = CatWindSpeed, y = `Relative Humidity AVG`)) + geom_boxplot()

# Linear Model
mod1 <- lm(`Success Percentage` ~ (`Relative Humidity AVG` + `Temperature AVG` + `Wind Speed Daily AVG` + `Solare Radiation AVG`), data = fullmerge)
summary(mod1)
# plot(mod1)
plot(mod1, which = 1)
plot(mod1, which = 2)
plot(mod1, which = 3)
plot(mod1, which = 4)
plot(mod1, which = 5)
plot(mod1, which = 6)

normalize <- function(x) {
  return((x-min(x))/(max(x)-min(x)))
}

fullmerge_n <- as.data.frame(lapply(fullmerge[c(3:4, 6)],normalize))

# kNN
fullmerge.train <- fullmerge_n[1:331,]
fullmerge.test <- fullmerge_n[332:481,]

fullmerge.train.labels <- fullmerge[1:331,11]
fullmerge.test.labels <- fullmerge[332:481,11]

fullmerge.pred <- knn(train = fullmerge.train, test = fullmerge.test, cl = fullmerge.train.labels, k = 21)

summary(fullmerge.pred)

CrossTable(x=fullmerge.test.labels, y=fullmerge.pred,  prop.chisq = FALSE)

