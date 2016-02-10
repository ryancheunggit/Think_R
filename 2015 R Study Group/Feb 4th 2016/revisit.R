#install.packages("dplyr")
#install.packages("reshape2")
#install.packages("rpart")
#install.packages("rpart.plot")
#install.packages("caTools")

# Read in data
train <- read.csv("train.csv", stringsAsFactors = F, na.strings = c("NA",""))
test <- read.csv("test.csv", stringsAsFactors = F, na.strings = c("NA",""))

# processing the data
ntrain <- nrow(train)
ntest <- nrow(test)
label <- train$Survived
train$Survived <- NULL
full <- rbind.data.frame(train, test)

train$Embarked <- factor(train$Embarked)
test$Embarked <- factor(test$Embarked)
train$Pclass <- factor(train$Pclass)
test$Pclass <- factor(test$Pclass)
train$Sex <- factor(train$Sex)
test$Sex <- factor(test$Sex)
train$Survived <- factor(train$Survived, levels = c(1,0))

# Look at the structure again
str(train)
str(test)

# some exploratory analysis   

# Check the label 
round(table(train$Survived)/nrow(train),4)*100

# lady first?
round(table(train$Sex,train$Survived)/rowSums(table(train$Sex,train$Survived)),4)*100

# save the children?
round(table(train$Age < 18, train$Survived)/rowSums(table(train$Age < 18, train$Survived)),4)*100

# by gender and child summary
library(dplyr)
library(reshape2)
train$child <- train$Age < 18
by_gender_child <- group_by(train, Sex, child)
summary_by_gender_child <- summarise(by_gender_child, 
                                     surviveRate = round(sum(as.numeric(as.character(Survived)))/n(),2) * 100)
melted_summary <- melt(summary_by_gender_child, id.vars = c("Sex", "child"))
casted_summary <- dcast(melted_summary, Sex~child)
names(casted_summary)[2:4] <- c("Adult", "Child", "Unknown")
casted_summary
train$child <- NULL

barplot(as.matrix(casted_summary[,2:4]), beside = T, col = c("red", "blue"))
legend("topright", c("female", "male"), pch = 15, col = c("red", "blue"))

# by gender and class
by_gender_class <- group_by(train, Sex, Pclass)
summary_by_gender_class <- summarise(by_gender_class, 
                                     surviveRate = round(sum(as.numeric(as.character(Survived)))/n(),2) * 100)
melted_summary <- melt(summary_by_gender_class, id.vars = c("Sex", "Pclass"))
casted_summary <- dcast(melted_summary, Sex~Pclass)
names(casted_summary)[2:4] <- c("Upper", "Middle", "Lower")
casted_summary

barplot(as.matrix(casted_summary[,2:4]), beside = T, col = c("red", "blue"))
legend("topright", c("female", "male"), pch = 15, col = c("red", "blue"))

# =================================================================
# 
# Do some exploratory analysis on your own, see what you can find
#
# =================================================================

# decision tree model
library(rpart)
library(rpart.plot)
tree <- rpart(Survived ~ Age + Sex + Pclass, 
              data = train, 
              control = rpart.control(cp = 0.01, maxdepth = 3),
              method = "class")
prp(tree)

# validation approach to test your model
library(caTools)
set.seed(1106)
split <- sample.split(train$Survived, 0.7)
training <- train[split == T, ]
validation <- train[split == F, ]
nrow(training)
nrow(validation)
tree <- rpart(Survived ~ Age + Sex + Pclass, 
              data = training, 
              control = rpart.control(cp = 0.01, maxdepth = 3),
              method = "class")

prp(tree)

pred.train <- predict(tree, training, type = "class")
table(pred.train, training$Survived)
(367+133)/nrow(training)
pred.valid <- predict(tree, validation, type = "class")
table(pred.valid, validation$Survived)
(155+51)/nrow(validation)

# try some different hyper parameter values
tree <- rpart(Survived ~ Age + Sex + Pclass, 
              data = training, 
              control = rpart.control(cp = 0.001, maxdepth = 5),
              method = "class")

prp(tree)

pred.train <- predict(tree, training, type = "class")
table(pred.train, training$Survived)
(339+182)/nrow(training)
pred.valid <- predict(tree, validation, type = "class")
table(pred.valid, validation$Survived)
(148+68)/nrow(validation)

# =================================================================
# 
# Try alter the formula, cp and maxdepth to see by yourself
#
# =================================================================

# make prediction on test set for submiting on Kaggle  
tree <- rpart(Survived ~ Age + Sex + Pclass, 
              data = train, 
              control = rpart.control(cp = 0.001, maxdepth = 5),
              method = "class")
prediction <- predict(tree, test, type = "class")
submit <- cbind.data.frame(test$PassengerId, prediction)
names(submit) <- c("PassengerId", "Survived")
write.csv(submit, "startSubmission.csv", row.names = F)

# =================================================================
# 
# Change the above values to the best combinations you found and see 
# your result after on Kaggle.
#
# =================================================================