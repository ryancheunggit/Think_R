# PortfolioExample
Ryan  
September 10, 2015  

MA610 + MA611 ish, sort of? 

# Portfolio Problem
We are managing a portfolio of three risky asset(Let's say Microsoft, Coke Cola and Starbucks), and trying to minimize the risk.

## Load relevant packages

```r
library(PerformanceAnalytics)
library(zoo)
library(tseries)
```

## Get history adjusted closing price from yahoo

```r
get_price <- function(stock){
        get.hist.quote(instrument=stock,
                    start="2010-01-01",end="2015-08-31",
                    quote="AdjClose",provider="yahoo",
                    origin="1970-01-01",
                    compression="m", 
                    retclass="zoo", 
                    quiet=TRUE)
}
SBUX_prices <- get_price('sbux')
MSFT_prices <- get_price('msft')
COKE_prices <- get_price('coke')

index(SBUX_prices) <- as.yearmon(index(SBUX_prices))
index(MSFT_prices) <- as.yearmon(index(MSFT_prices))
index(COKE_prices) <- as.yearmon(index(COKE_prices))
```

## Calculating returns

```r
all_prices = merge(MSFT_prices, COKE_prices, SBUX_prices)
head(all_prices)
```

```
##          AdjClose.MSFT_prices AdjClose.COKE_prices AdjClose.SBUX_prices
## Jan 2010             24.21383             46.30931             10.04807
## Feb 2010             24.75006             51.31770             10.56453
## Mar 2010             25.28529             54.09337             11.19167
## Apr 2010             26.36438             50.79207             12.02984
## May 2010             22.37297             46.09480             11.98816
## Jun 2010             19.95356             44.39033             11.25192
```

```r
colnames(all_prices) <- c("MSFT", "COKE", "SBUX")
simple_returns <- diff(all_prices)/lag(all_prices, k=-1);
head(simple_returns)
```

```
##                 MSFT        COKE        SBUX
## Feb 2010  0.02214578  0.10815068  0.05139974
## Mar 2010  0.02162544  0.05408803  0.05936268
## Apr 2010  0.04267667 -0.06102966  0.07489175
## May 2010 -0.15139436 -0.09248044 -0.00346422
## Jun 2010 -0.10813949 -0.03697745 -0.06141375
## Jul 2010  0.12168623  0.07679465  0.02263382
```

## Plot

```r
chart.Bar(simple_returns, legend.loc="bottom", main=" ")
```

![](Portfolio_files/figure-html/chunck4-1.png) 

```r
chart.CumReturns(simple_returns, wealth.index = T, legend.loc="topleft", main = "Future Value of $1 invested")
```

![](Portfolio_files/figure-html/chunck4-2.png) 

## using mean and sd to make investment decision(CER model?)
$$R_i \sim iid N(\mu_i, \sigma_i^2)$$
$$cov(R_i,R_j) = \sigma_{ij}$$



```r
return_matrix <- coredata(simple_returns)
mu_hat_annual <- apply(return_matrix, 2, mean)*12
cov_mat_annual <- cov(return_matrix)*12
```

## Portfolio return
+ $R_{p,x} = x_AR_A + x_BR_B + x_CR_C$
+ $\mu_{p,x} = \mathbb{E}[R_{p,x}] = x_A\mu_A + x_B\mu_B + x_C\mu_C$
+ $\sigma_{p,x}^2 = x_A^2\sigma_A^2 + x_B^2\sigma_B^2 + x_B^2\sigma_B^2 + 2x_Ax_B\sigma_{AB} + 2x_Bx_C\sigma_{BC} + 2x_Ax_C\sigma_{AC}$

With the condition that the proportions sum up to 1
$$x_A+x_B+x_C = 1$$

In matrix notation
$$\mu_{p,x} =   {\bf x}'{\bf \mu}$$
$$\sigma_{p,x}^2 = var({\bf x}'{\bf \mu}) = {\bf x}'{\bf \Sigma x}$$
$${\bf x}'{\bf 1}=1$$

## Optimization Problem
$$\min_{x_A,x_B,x_C} \sigma_{p,m}^2 = x_A^2\sigma_A^2 + x_B^2\sigma_B^2 + x_B^2\sigma_B^2 + 2x_Ax_B\sigma_{AB} + 2x_Bx_C\sigma{BC} + 2x_Ax_C\sigma_{AC}$$
$$s.t. \qquad x_A+x_B+x_C = 1$$

Again in Matrix Notation
$$\min_{{\bf x}} {\bf x}'{\bf \Sigma x}$$
$$s.t. \qquad {\bf x}'{\bf 1} = 1$$

## Solve using Quadratic Programming
Setting up the problem

```r
top.mat = cbind(2*cov_mat_annual, rep(1,3))
bot.vec = c(rep(1,3),0)
Am.mat = rbind(top.mat, bot.vec)
b.vec = c(rep(0,3),1)
z.m.mat = solve(Am.mat) %*%  b.vec
x.vec = z.m.mat[1:3,1]
x.vec
```

```
##      MSFT      COKE      SBUX 
## 0.3298210 0.2846464 0.3855326
```

```r
mu.gmin = as.numeric(crossprod(x.vec, mu_hat_annual))
mu.gmin
```

```
## [1] 0.2397456
```




