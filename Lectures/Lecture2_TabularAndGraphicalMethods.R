rm(list=ls())

# this is a comment

# set working directory
setwd("D:/GithubRepos/Think_R/Lectures")

# install packages

# install.packages("xlsx")
library(xlsx)

# help on function
?read.xlsx()

# read in data 
df <- read.xlsx("HousePriceData.xlsx", sheetIndex = 1, stringsAsFactors = F)

# see the structure of the data frame
str(df)

# select element
df[1,1]

# select row
df[1,]
df["12",]


# select column
df$Price
df[,"Price"]
df[,2]

# change variable type
df$Beds <- as.factor(df$Beds)
df$Baths <- as.factor(df$Baths)

# frequency table
table(df$Beds)

ftBeds <- table(df$Beds)

ftBeds

# relative frequency table
ftBeds/length(df$Beds)

# percent relative frequency table
ftBeds/length(df$Beds)*100

# pie chart
pie(ftBeds, border = 0)

# bar plot
barplot(ftBeds, space = 0.05, border = 0, col = "blue", main = "Distribution of Number of Bedrooms ")

# histogram
hist(df$Price, border = 0, col = "blue", main = "Distribution of House Prices")

hPrice <- hist(df$Price, plot = F)

ftPrice <- hPrice$counts
names(ftPrice) <- paste(hPrice$breaks[1:5],
                        hPrice$breaks[2:6],
                        sep = "~")
ftPrice

ftPrice/length(df$Beds)

cftPrice <- cumsum(ftPrice/length(df$Beds))

# Ogive
plot(cftPrice, pch = 19, xaxt = "n")
axis(1, at = 1:5, labels = hPrice$breaks[2:6])
lines(cftPrice)

# contengincy table
# install.packages("dplyr")
library(dplyr)
df_groupby_beds <- group_by(df, Beds)
contable_Price_by_Beds <- summarise(df_groupby_beds, Price = mean(Price))
contable_Price_by_Beds

df %>%
    group_by(Baths) %>% 
    summarise(Price = mean(Price))

df %>%
    group_by(Baths, Beds) %>% 
    summarise("Price(k)" = round(mean(Price)/1000,2))