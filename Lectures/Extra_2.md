# 离散概率
Ryan Zhang  

## 随机变量
+ 随机变量(Random Variable)：
    - 是一个函数
    - 对事件进行概率值的赋值
+ 离散随机变量：
    - 函数所能赋的值是可数的
+ 连续随机变量：
    - 函数所能赋的值可以是某一区间内不可数的
    
## 概率质量函数
+ 概率质量函数(Probability Mass Function,PMF):
    $$p_{X}(x)=Pr(X=x)$$
+ 累积分布函数(Cumulative Distribution Function, CDF):
    $$F_X(x)=Pr(X\leq x)$$
    
## 期望、方差和标准差
+ 期望：
    $$\mathbb{E}[X]=\mu_X\\
    =\Sigma_{i}{x_i}p_{X}(x_i)\\
    =\Sigma_{i}{x_i}Pr(X=x_i)$$
+ 方差：
    $$var(X)={\sigma_X^2}\\
    =\Sigma_{i}(x_i-\mu_X)^2p_X(x_i)\\
    =\Sigma_{i}(x_i-\mu_X)^2Pr(X=x_i)\\
    =\Sigma_ix_i^2Pr(X=x_i)-{\mu_X}^2$$
+ 标准差：
    $$SD(X)=\sqrt{(\sigma_X^2)}\\
    =\sigma_X$$

## 期望法则，期望、方差的性质
+ 期望法则：
    - $X$是一个随机变量，$g(X)$是$X$的一个函数，则：
    $$\mathbb{E}[g(X)]=\Sigma_ig(x_i)p_X(x_i)$$
+ $X$是一个随机变量，$Y=aX+b$是$X$的一个线性函数，则：
    $$\mathbb{E}[Y]=a\mathbb{E}[X]+b$$
    $$var(Y)=a^2\text{var}(X)$$

## 伯努利过程
+ 伯努利过程(Bernoulli Process):
    - 对同一实验的一系列独立试验
    - 实验只有两种结果：成功(1)或失败(0)
    - 每一次具体的试验，成功和失败的概率不变
    - 伯努利随机变量
    $$p_X{(k)}=\begin{cases}p,\qquad \qquad \text{if k = 1}\\1-p, \qquad \ \text{if k = 0}\end{cases} $$

## 二项随机变量
+ 二项随机变量(Binomial Random Variable):
    - 在一个n次试验的伯努利过程中，出现了x次成功的概率
    $$Pr(X=x)={n\choose x}p^x(1-p)^{n-x}\\
    =\frac{n!}{(n-x)!x!}p^x(1-p)^{n-x}$$
    $$\mathbb{E}[X]=\mu=np$$
    $$var(X)=\sigma^2_X=npq$$

## 二项随机变量

```r
dbinom(2,10,0.5)
```

```
## [1] 0.04394531
```

```r
factorial(10)/factorial(2)/factorial(8)*0.5^10
```

```
## [1] 0.04394531
```

## 二项随机变量

```r
pbinom(4,10,0.4)
```

```
## [1] 0.6331033
```

```r
sum(dbinom(0:4,10,0.4))
```

```
## [1] 0.6331033
```

```r
p <- 0
for (i in 0:4){p <- p + dbinom(i,10,0.4)}
p
```

```
## [1] 0.6331033
```

## 二项随机变量

```r
set.seed(123)
rbinom(20,1,0.5)
```

```
##  [1] 0 1 0 1 1 0 1 1 1 0 1 0 1 1 0 1 0 0 0 1
```

## 蒙特卡洛模拟
+ 蒙特卡洛模拟(Monte Carlo Simulation):

```r
set.seed(0306)
ps <- vector()
for (i in 1:999){
    ps <- c(ps, table(rbinom(100,1,0.5))[2]/100)
}
hist(ps, border = 0, col = "black")
```

![](Extra_2_files/figure-slidy/unnamed-chunk-4-1.png) 
