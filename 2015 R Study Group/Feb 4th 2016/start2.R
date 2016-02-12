#install.packages("dplyr")
#install.packages("reshape2")
#install.packages("rpart")
#install.packages("rpart.plot")
#install.packages("caTools")
#install.packages("ggplot2")
#install.packages("ROCR")    

# Read in data
train <- read.csv("train.csv")
test <- read.csv("test.csv")

# Look at the structure
str(train)
str(test)

# Check missing values
sum(is.na(train))
sum(is.na(test))

# Look at some of the variables  
sort(table(train$Cabin), decreasing = T)[1:5]

# Read in data and change variable types
train <- read.csv("train.csv", stringsAsFactors = F, na.strings = c("NA",""))
test <- read.csv("test.csv", stringsAsFactors = F, na.strings = c("NA",""))
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

# using simple validation set approach go select model   

# set up search values
cp.range <- 1:50*0.001
maxdepth.range <- 3:6
# set up empty vector to store validation results/parameters
accuracy <- cp.col <- depth.col <- vector()

# nested loop to try possible combinations of parameter values
for (i in 1:length(cp.range)){
    for (j in 1:length(maxdepth.range)){
        model <- rpart(Survived ~ Age + Sex + Pclass + SibSp + Parch + Fare + Embarked, 
                       data = training, 
                       control = rpart.control(cp = cp.range[i], 
                                               maxdepth = maxdepth.range[j]),
                       method = "class")
        pred <- predict(model, validation, type = "class")
        t <- table(pred, validation$Survived)
        accuracy <- c(accuracy, sum(diag(t))/sum(t))
        cp.col <- c(cp.col, cp.range[i])
        depth.col <- c(depth.col, maxdepth.range[j])
    }
}

# plot the validation results
pdf <- cbind.data.frame(cp.col, depth.col, accuracy)
pdf$depth.col <- as.factor(pdf$depth.col)
library(ggplot2)
ggplot(data = pdf, aes(x = cp.col, y = accuracy, color = depth.col)) + geom_line(size = 2)

# fit the tree using optimized hyper-parameters
tree <- rpart(Survived ~ Age + Sex + Pclass + SibSp + Parch + Fare + Embarked, 
              data = train, 
              control = rpart.control(cp = 0.005, maxdepth = 4),
              method = "class")

# plot the tree
prp(tree)

# using train(sample) data to see classifiaction results
library(ROCR)

train.pred <- predict(tree, train)[,1]

pred <- prediction(train.pred, train$Survived)

table(train.pred >= 0.5, train$Survived)[c("TRUE", "FALSE"),]

pref <- performance(pred, "tpr", "fpr")

plot(pref)
abline(0,1,lty = 2)

performance(pred, "auc")

performance(pred, "f")

# make prediction on test dataset and create submission file
prediction <- predict(tree, test, type = "class")
submit <- cbind.data.frame(test$PassengerId, prediction)
names(submit) <- c("PassengerId", "Survived")
write.csv(submit, "tunedTree.csv", row.names = F)