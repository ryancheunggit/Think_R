# Ryan Zhang
# Feb 12 2016
# zhang_ren@bentley.edu


# install.packages("caret")
# install.packages("randomForest")
# install.packages("ROCR")

# 0. load in data
train <- read.csv("train.csv", stringsAsFactors = F, na.strings = c("NA",""))
test <- read.csv("test.csv", stringsAsFactors = F, na.strings = c("NA",""))

# 1. processing the data
ntrain <- nrow(train)
ntest <- nrow(test)
label <- train$Survived
label <- factor(label, levels = c(1,0))
train$Survived <- NULL
full <- rbind.data.frame(train, test)

apply(is.na(full), 2, sum)

## filling missing values

## Embarked, I just randomly decided to do so
full[is.na(full$Embarked),]$Embarked <- "S"
str(full$Embarked)

## Fare, just one missing, using mean value to fill it
summary(full$Fare)
full[is.na(full$Fare),]$Fare <- 33.300

## Create a new feature Title, we are doing a little bit natural language processing here
full$Name

strsplit(full$Name[1], '[,.]')

full$Title<-sapply(full$Name, function(x) strsplit(x,'[.,]')[[1]][2])

full$Title<-gsub(' ','',full$Title)

table(full$Title)

full$Title[full$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
full$Title[full$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer', 'theCountess')] <- 'Lady'
full$Title[full$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
full$Title[full$Title %in% c("Col")] <- "Mr"
full$Title[full$Title %in% c("Mlle")] <- "Miss"
full$Title[full$Title %in% c("Mme")] <- "Mrs"


table(full$Title)
## Age, use a regression tree to predict missing ages. 
library(rpart)
rp <- rpart(Age~Pclass + Title + Sex + SibSp + Parch + Fare + Embarked, data = full[!is.na(full$Age),])

full[is.na(full$Age),]$Age <- predict(rp, full[is.na(full$Age),])

## Cabin, too hard to impute, we will drop it
## Ticket is also quite hard to utilize, drop it as well
full$Cabin <- NULL
full$Ticket <- NULL

## Create a new variable family size
full$FamilySize <- full$SibSp + full$Parch + 1

## Create a new variable indicating child or not
full$Child <- ifelse(full$Age < 18, 1, 0)

full$Mother <- ifelse(full$Age > 18 & full$Title != 'Miss' & full$Sex == 'female', 1, 0)

## convert variable types
full$Sex <- as.factor(full$Sex)
full$Embarked <- as.factor(full$Embarked)
full$Title <- as.factor(full$Title)
full$Child <- as.factor(full$Child)
full$Mother <- as.factor(full$Mother)

## split the full datafram back into seperate train and test sets
train <- cbind.data.frame(full[1:ntrain,], "Survived" = label)
test <- full[((ntrain + 1):nrow(full)),]

## Cross validation
library(caret)
set.seed(0306)
tuningParams <- expand.grid(.cp = c(0.00001,0.00005,0.0001,0.0005,0.001,0.005))
trainControl <- trainControl(method = "cv", number = 10)
rp.train <- train(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + 
                      FamilySize + Child + Mother, data = train, method = "rpart",
                  trControl = trainControl, tuneGrid = tuningParams)

plot(rp.train)

## Fit model and Analysis metrics

# fit the tree using optimized hyper-parameters
tree <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + 
                  FamilySize + Child + Mother, data = train, 
              control = rpart.control(cp = 0.001),
              method = "class")

# plot the tree
library(rpart.plot)
prp(tree)

# using train(sample) data to see classifiaction results
library(ROCR)

train.pred <- predict(tree, train)[,1]

pred <- prediction(train.pred, train$Survived)

table(train.pred >= 0.5, train$Survived)[c("TRUE", "FALSE"),]

pref <- performance(pred, "tpr", "fpr")

plot(pref)
abline(0,1,lty = 2)

performance(pred, "auc")@y.values

which.max(performance(pred, "f")@y.values[[1]])
performance(pred, "f")@x.values[[1]][10]

## make prediction on test dataset and create submission file

prediction <- predict(tree, test, type = "class")

submit <- cbind.data.frame(test$PassengerId, prediction)
names(submit) <- c("PassengerId", "Survived")
write.csv(submit, "CVTreeWithNewFeaturesAndImpution.csv", row.names = F)

## random forest
library(randomForest)
x <- train[, c(1:2, 4:13)]
y <- train$Survived
tuneRF(x, y, mtryStart = 1, ntreeTry = 500, stepFactor = 2)

rf <- randomForest(Survived~Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + 
                       FamilySize + Child + Mother,
                   data = train, mtry = 1, ntree = 500)

prediction <- predict(rf, test)

submit <- cbind.data.frame(test$PassengerId, prediction)
names(submit) <- c("PassengerId", "Survived")
write.csv(submit, "randomForest.csv", row.names = F)
