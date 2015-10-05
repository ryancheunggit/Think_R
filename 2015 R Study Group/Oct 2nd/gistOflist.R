# gist of list

# vector can only store data of the same type

v <- c("what", 1, T)
v

# list can store data of different types
l <- list("what", 1, T)
l

# subset a list
l[1]
class(l[1])
l[[1]]
class(l[[1]])

# add names to list
names(l)
names(l) <- c("word", "frequency", "used")
l

# subset a list using name
l["word"]
class(l["word"])
l["word"][1]
class(l["word"][1])
l["word"][[1]]
class(l["word"][[1]])

# structure of the list
str(l)

# what is this...
df <- list(name = c("amy", "bob", "cry"),
           age = c(10,5,6),
           boy = c(F,T,F))

df
str(df)

df2 <- data.frame(name = c("amy", "bob", "cry"),
           age = c(10,5,6),
           boy = c(F,T,F))

str(df2)

df2

