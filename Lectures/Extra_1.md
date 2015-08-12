# 概率
Ryan Zhang  

## 基础概念
+ 实验(Experiment)：
    - 实验有一个或多个不确定的结果
+ 样本空间(Sample Space):
    - 实验的样本空间包括了该实验所有可能的结果
+ 事件(Event):
    - 样本空间的一个子集，可以有一个或多个结果

## 基础概念
+ 事件(Event):
    - 样本空间的一个子集，可以有一个或多个结果
+ 穷尽(collectivly exhaustive)：
    - 如果实验的所有可能结果被若干事件包括
+ 互斥(mutually exclusive):
    - 事件之间不共享任何一个结果

## 基础概念
+ 两个事件的并(Union):
    - 记作$A \cup B$
    - 是包括$A$或$B$中所有结果的事件
+ 两个事件的交(Intersection):
    - 记作$A \cap B$
    - 是包括$A$和$B$中共有结果的事件
+ 事件的补(Complement):
    - 记作$A^C$
    - 是包括样本空间中所有不在$A$中结果的事件

## 基础概念

```r
S <- c(1,2,3,4,5,6)
A <- c(1,3,5)
B <- c(1,2,3)
C <- c(2,4,6)
union(A,B)
```

```
## [1] 1 3 5 2
```

```r
intersect(A,B)
```

```
## [1] 1 3
```

```r
setdiff(S,A)
```

```
## [1] 2 4 6
```

## 基础概念
+ 概率(Probability)：
    - 对不确定事件发生可能性的一个估计值
+ 三种类型的概率：
    - 1 主观：个人主观意见
    - 2 客观：不因判断者不同而不同
        * 经验概率(Emprical Probabilties)：依据手头数据计算出
        * 先验概率(Priori Probabilities): 根据演绎法获得

## 数数方法
+ 阶乘(Factorial):
    - 将n个对象放到n个盒子中的方法数量
    $$n!=n(n-1)(n-2)...1, \qquad 0!=1$$
+ 组合(Combination):
    - 从n个对象中抽取x个对象的方法（顺序无所谓）
    $$C^n_x = {n\choose x}=\frac{n!}{(n-x)!x!}$$
+ 排列(Permutation):
    - 从n个对象中抽取x个对象的方法（顺序有所谓）
    $$P^n_x =\frac{n!}{(n-x)!}$$

## 数数方法

```r
factorial(2)
```

```
## [1] 2
```

```r
choose(5,2)
```

```
## [1] 10
```

```r
myCombn <- function(n,x)choose(n,x)*factorial(x)
myCombn(5,2)
```

```
## [1] 20
```

```r
combn(4,2)
```

```
##      [,1] [,2] [,3] [,4] [,5] [,6]
## [1,]    1    1    1    2    2    3
## [2,]    2    3    4    3    4    4
```


## 基础概念
+ 对于任意事件A：
    $$0\leq Pr(A) \leq 1$$
+ 若一组互斥事件$A_i$是穷尽的，那么:
    $$\Sigma Pr(A_i)=1$$

## 条件概率与非条件概率
+ 非条件概率(Unconditional Probability)：
    - 事件发生的概率不受任何限定
+ 条件概率(Conditional Probability):
    - 给定一个事件(B)已经发生的前提之下，目标事件(A)发生的概率
    - 记作:
    $$Pr(A|B)$$
+ 条件概率的计算：
    $$Pr(A|B) = \frac{Pr(A\cap B)}{Pr(B)}$$

## 列联表
+ 用于表示两个定性变量之间的频率关系
    - 每一个单元表示的是一个互斥事件

## 列联表与条件概率

```r
set.seed(123)
df <- cbind.data.frame(gender = sample(c("Male","Female"),200,replace = T),
                 perference = sample(c("Big Mac", "Whopper","Doublicious"), 200, replace = T))
head(df)
```

```
##   gender  perference
## 1   Male     Big Mac
## 2 Female Doublicious
## 3   Male     Whopper
## 4 Female     Whopper
## 5 Female     Whopper
## 6   Male Doublicious
```

## 列联表与条件概率

```r
library(dplyr)
fdf <- df %>% group_by(gender,perference) %>% summarise(count = n())
head(fdf)
```

```
## Source: local data frame [6 x 3]
## Groups: gender
## 
##   gender  perference count
## 1 Female     Big Mac    33
## 2 Female Doublicious    30
## 3 Female     Whopper    34
## 4   Male     Big Mac    37
## 5   Male Doublicious    37
## 6   Male     Whopper    29
```
## 列联表与条件概率

```r
library(reshape2)
ct <- dcast(fdf, gender~perference, value.var = "count")
ctdf <- ct[,2:4]
row.names(ctdf) <- c("Female","Male")
ctdf
```

```
##        Big Mac Doublicious Whopper
## Female      33          30      34
## Male        37          37      29
```

## 列联表与条件概率
$$Pr(gender|perference)$$

```r
t(round(apply(ctdf,MARGIN = 1, function(data){data/colSums(ctdf)}),2))
```

```
##        Big Mac Doublicious Whopper
## Female    0.47        0.45    0.54
## Male      0.53        0.55    0.46
```
## 列联表与条件概率
$$Pr(perference|gender)$$

```r
round(apply(ctdf,MARGIN = 2, function(data){data/rowSums(ctdf)}),2)
```

```
##        Big Mac Doublicious Whopper
## Female    0.34        0.31    0.35
## Male      0.36        0.36    0.28
```
## 列联表与条件概率
$$Pr(perference\cap gender)$$

```r
t(apply(ctdf,MARGIN = 1, function(data){data/sum(ctdf)}))
```

```
##        Big Mac Doublicious Whopper
## Female   0.165       0.150   0.170
## Male     0.185       0.185   0.145
```

## 独立事件与非独立事件
+ 若事件$A$发生的概率不受事件$B$是否发生的影响
    $$Pr(A|B)=Pr(A)$$
    
## 概率规则
+ 补规则(The Complement Rule):
    $$Pr(A^C)=1-Pr(A)$$
+ 加规则(The Addition Rule):
    $$Pr(A\cup B)=Pr(A)+Pr(B)-Pr(A \cap B)$$
    - 若$A$互斥$B$则简化为：
    $$Pr(A\cup B)=Pr(A)+Pr(B)$$
+ 乘规则(The Multiplication Rule):
    $$Pr(A\cap B) = Pr(A)\cdot Pr(B|A)=Pr(B)\cdot Pr(A|B)$$
    - 若$A$独立于$B$则简化为：
    $$Pr(A\cap B)=Pr(A)\cdot Pr(B)$$

## 概率规则
+ 全概率规则(Total Probability Rule):
    $$Pr(A)=Pr(A\cap B)+Pr(A\cap B^C)$$
    $$Pr(A)=Pr(A|B)Pr(B)+Pr(A|B^C)Pr(B^C)$$

## 贝叶斯定律
+ 根据新信息对先验概率进行更新
    $$Pr(B|A)=\frac{Pr(A\cap B)}{Pr(A)}\\
    =\frac{Pr(A\cap B)}{Pr(A\cap B)+Pr(A\cap B^C)}\\
    =\frac{Pr(A|B)\cdot Pr(B)}{Pr(A|B)\cdot Pr(B)+Pr(A|B^C)\cdot Pr(B^C)}$$
    
## 贝叶斯定律
+ 若样本空间被分化为若干互斥事件($B_i$)所穷尽
    - 则全概率规则为：
    $$Pr(A)=Pr(A\cap B_1)+Pr(A\cap B_2)+...+Pr(A\cap B_k)\\
    =Pr(A|B_1)\cdot Pr(B_1)+Pr(A|B_2)\cdot Pr(B_2)+...+Pr(A|B_k)\cdot Pr(B_k)$$
    - 贝叶斯定律为：
    $$Pr(B_i|A)=\frac{Pr(A\cap B_i)}{Pr(A\cap B_1)+Pr(A\cap B_2)+...+Pr(A\cap B_k)}\\
    =\frac{Pr(A|B_i)\cdot Pr(B_i)}{Pr(A|B_1)\cdot Pr(B_1)+Pr(A|B_k)\cdot Pr(B_k)+...+Pr(A|B_k)\cdot Pr(B_k)}$$

