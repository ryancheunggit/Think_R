# 算术计算
2 + 2

4 - 2

4 * 16

72 / 24

5 ^ 3

# 变量和赋值
a <- ((2+16)^2 - 324)/12
 
a

# 函数
sqrt(4)

b <- sqrt(4)

b

# 向量
c(172, 178, 174, 181, 169)

heights <- c(172, 178, 174, 181, 169)

heights / 2.54

weights <- vector()

# auto completion
weights <- c(weights, 54)

weights <- c(weights, c(54,59,55,49))

sum(heights)

length(heights)

# class
class(heights)

# facotr
class(c("A","A","C","B","A","C"))

ranks <- as.factor(c("A","A","C","B","A","C")) 

ranks

# help document
?factor()

# ordered factors
ranks <- ordered(ranks)

ranks

ranks <- ordered(ranks, levels = c("C","B","A"))

ranks


# environment
ls()

# remove variables to free up memory
rm(a)

rm(list = ls())