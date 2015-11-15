d <- read.csv(file.choose(), stringsAsFactors = F)

library(rpart)
library(rpart.plot)

names(d)

str(d)
d$index <- NULL
d$gender <- factor(d$gender)
d$student <- factor(d$student)
d$married <- factor(d$married)
d$ethnicity <- factor(d$ethnicity)

str(d)
library(leaps)
backwardRegression = regsubsets(income~. + limit * rating + limit * cards + limit * age +
                                      limit * education + limit * gender + limit * student + 
                                      limit * married + limit * ethnicity + limit * balance +
                                      rating * cards + rating * age + rating * education + 
                                      rating * gender + rating * student + rating * married +
                                      rating * ethnicity + rating * balance + cards * age + 
                                      cards * education + cards * gender + cards * student + 
                                      cards * married + cards * ethnicity + cards * balance +
                                      age * education + age * gender + age * student + 
                                      age * married + age * ethnicity + age * balance +
                                      education * gender + education * student + education * married +
                                      education * ethnicity + education * balance +
                                      gender * student + gender * married +
                                      gender * ethnicity + gender * balance +
                                      education * married +
                                      education * ethnicity + education * balance +
                                      married * ethnicity + married * balance +
                                      ethnicity * balance
                                  ,nvmax=62,data=d, method="backward")

plot(backwardRegression,scale="adjr2")

which.max(summary(backwardRegression)$adjr2)

s = summary(backwardRegression)
s$which[25,]

m <- lm(income~rating + cards + age + education + married + balance + limit*rating + limit:cards
        + limit * gender + limit * married + limit * balance + rating * age + rating * student + 
        rating * ethnicity + rating * balance + cards * gender + cards * student + age * education+
        age * student + age * married + age * ethnicity + education * student + education * ethnicity+ 
        gender * balance + gender * ethnicity, data = d)

summary(m)


which.max(summary(backwardRegression)$adjr2)
max(summary(backwardRegression)$adjr2)
