# Ryan Zhang Sep 24 2015
# basic data types
# character
name <- c("Amber", "Baffulo", "Crush", "Downey", "Eureka")
class(name)
is.character(name)
# numeric
age <- c(23,22,25,26,29)
class(age)
is.numeric(age)
is.character(age)
# logical
married <- c(T,F,T,T,T)
class(married)
is.logical(married)
# factor
education <- c("BS","BS","MS","PHD","MS")
class(education)
education
education <- as.factor(education)
class(education)
education
levels(education)
education <- ordered(education)
education
education <- ordered(education, levels = c("PHD","MS","BS"))
education

# subsetting vectors
name[1]
name[1:3]
name[c(1,3)]
name[-2]
name[-c(2,4)]

# some randomly generated numbers
heights <- rnorm(5, 175,4)
weights <- rnorm(5, 150, 10)

# data frame
df <- data.frame(name, age, married, education, heights, weights, stringsAsFactors = F)
df
str(df)
head(df)
summary(df)

# substting a dataframe
df[1]
class(df[1])
df["name"]
class(df["name"])
df$name
class(df$name)
df[,1]
class(df[,1])

df[c(1,3)]
df[1:3]
df[T]
df[c(T,F)]

df[1:2,]
df[c(T,F),]
df[1:3,1:3]

# column names in a vector
names(df)
class(names(df))
names(df)[1]
names(df)[1] <- "Name/Nom"
df

df$age
df$Name/Nom

df$"Name/Nom"

# also default row name is the number
row.names(df)

row.names(df) <- c(2,1,3,4,5)
df

# linear regression model
lm.model <- lm(weights~heights, df)
summary(lm.model)
anova(lm.model)
plot(lm.model)

# estimated conditional means... or predicted value for sample data
lm.model$fitted.values

# make predictions
predict(lm.model, data.frame(heights = rnorm(9,177,3)))

