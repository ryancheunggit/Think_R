# a quick review on the apply() function

m <- matrix(1:9, nrow = 3, byrow = T)
m
apply(m, # matrix 
      1, # apply function to each row,
      mean # the function to be applied to each row
)

apply(m, # matrix 
      2, # apply function to each row,
      sum # the function to be applied to each row
)

apply(m, # matrix 
      1, # apply function to each row,
      function(row){# the function to be applied to each row
          return(sum(row^2))
      } 
)


# Recommendation System

## Utility Matrix: the ratings from a set of customers on a set of items

### some dummy data
UtilityMatrix <- cbind.data.frame(Avatar = c(1  , NA , 0.2, NA ),
                                   LOTR1 = c(NA , 0.5, NA , 0.1),
                                 Matrix1 = c(0.2, NA , 1  , NA ),
                                Pirates1 = c(NA , 0.3, NA , 0.4))
row.names(UtilityMatrix) <- c("Alice", "Bob", "Carol", "David")

UtilityMatrix <- as.matrix(UtilityMatrix)

UtilityMatrix
### Key problem: how to fill the NAs in the utility matrix   
### More important problem: what NAs are likely to be high in value     

## Content based Method  

### Need a feature set for each of the items, and their scores    
AvatarF <- c("Action", "Adventure", "Fantasy", "Sci-Fi", "21CenturyFox")
LOTR1F <- c("Adventure", "Drama", "Fantasy", "NewLine")
Matrix1F <- c("Action", "Sci-Fi", "WarnerBros")
Pirates1F <- c("Action", "Adventure", "Fantasy", "WaltDisney")
features <- unique(c(AvatarF, LOTR1F, Matrix1F, Pirates1F))
features

itemProfiles <- t(
    apply(
        rbind(AvatarF, LOTR1F, Matrix1F, Pirates1F), # each row a feature set
        1, # apply function by row
        function(row){ # an anonymous function get scores
            # the score now is simply 1 or 0
            return(as.numeric(features %in% row))}
        )
    )

colnames(itemProfiles) <- features

itemProfiles

### Need a similarity measure, can use cosine similarity
cosSim <- function(v1, v2){
    return((v1 %*% v2)/norm(v1,type = "2")/norm(v2,type = "2"))
}

itemSimilarities <- 
    apply(itemProfiles, 1, function(rowO){
        return(apply(
                itemProfiles, 
                1, 
                function(rowI){
                    return(cosSim(rowO, rowI))
                    }))
        })

itemSimilarities
UtilityMatrix
### What movie would you recommend to Alice, Bob, Carol and David?

### User Profiles: simply the weighted average of rated item profiles for each user
userProfiles <- t(apply(UtilityMatrix, 1, function(row){
    preference <- rep(0, length(features))
    numRated <- 0
    for (i in 1:length(row)){
        if (!is.na(row[i])){
            numRated <- numRated + 1
            preference <- preference + row[i] * itemProfiles[i,]
        }
    }
    return(preference/numRated)
    }
))

userProfiles

### Make prediction based on similarity between user profile and item profile
Prediction <- t(apply(userProfiles, 1, function(user){
    return(apply(itemProfiles, 1, function(item){
        return(cosSim(user, item))
    }))
}))

Prediction <- round(Prediction, 4)
UtilityMatrix

### a helper function to show the rankings based on prediction
predictedRankings <- function(prediction){
    t(apply(prediction, 1, function(row){
        return(names(sort(row, decreasing = T)))
    }))
}

predictedRankings(Prediction)


## Collaborative Filtering   

### two approaches here (1) user x user (2) item x item
### (1) user x user 
### similarity between users based on Utility matrix

### need to center first
centeredUtilityMatrix <- t(apply(UtilityMatrix, 1, function(row){return(row - mean(row, na.rm = T))}))

### use 0 to replace NAs
centeredUtilityMatrix[is.na(centeredUtilityMatrix)] <- 0

userSimilarity <- apply(centeredUtilityMatrix, 1, function(user1){
    apply(centeredUtilityMatrix, 1, function(user2){
        return(cosSim(user1, user2))
    })
})

userSimilarity

### generate user x user collaborative filtering predictions
userUserPrediction <- vector()

for (i in 1:nrow(userSimilarity)){
    top2 <- sort(userSimilarity[i, -i], decreasing = T)[1:2]
    userUserPrediction <- rbind(userUserPrediction,
                                colSums(centeredUtilityMatrix[names(top2),]/2, na.rm = T))
}

userUserPrediction <- as.matrix(userUserPrediction)
rownames(userUserPrediction) <- rownames(UtilityMatrix)

### remember to plug back in known ratings 
for (i in 1:nrow(userUserPrediction)){
    for (j in 1:ncol(userUserPrediction)){
        if (centeredUtilityMatrix[i, j] != 0){
            userUserPrediction[i,j] <- centeredUtilityMatrix[i, j]
        }
    }
}

userUserPrediction <- round(userUserPrediction, 4)

### compare with content based predictions
predictedRankings(userUserPrediction)
predictedRankings(Prediction)

### (2) item x item 
### similarity between items based on transposed Utility matrix

TcenteredUtilityMatrix <- t(apply(t(UtilityMatrix), 1, function(row){return(row - mean(row, na.rm = T))}))
TcenteredUtilityMatrix[is.na(TcenteredUtilityMatrix)] <- 0

itemSimilarity <- apply(TcenteredUtilityMatrix, 1, function(item1){
    apply(TcenteredUtilityMatrix, 1, function(item2){
        return(cosSim(item1, item2))
    })
})

itemSimilarity

### generate user x user collaborative filtering predictions
itemItemPrediction <- vector()
for (i in 1:nrow(itemSimilarity)){
    top2 <- sort(itemSimilarity[i, -i], decreasing = T)[1:2]
    itemItemPrediction <- rbind(itemItemPrediction,
                                colSums(TcenteredUtilityMatrix[names(top2),]/2, na.rm = T))
}


itemItemPrediction <- as.matrix(itemItemPrediction)
rownames(itemItemPrediction) <- rownames(TcenteredUtilityMatrix)

for (i in 1:nrow(itemItemPrediction)){
    for (j in 1:ncol(itemItemPrediction)){
        if (TcenteredUtilityMatrix[i, j] != 0){
            itemItemPrediction[i,j] <- TcenteredUtilityMatrix[i, j]
        }
    }
}

itemItemPrediction <- round(t(itemItemPrediction),4)

itemItemPrediction

### compare the results of recommendations
predictedRankings(Prediction)
predictedRankings(userUserPrediction)
predictedRankings(itemItemPrediction)
