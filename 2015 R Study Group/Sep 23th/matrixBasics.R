# create a matrix
M <- matrix(1:9, nrow = 3, ncol = 3)
M

M <- matrix(1:9,3,3, byrow = TRUE)
M

# element wise operations with matrix
3 * M

set.seed(0306)
A = matrix(round(runif(9,1,10),0), 3,3)
A

M
A
M*A

# matrix matrix multiplication
M %*% A

# identity matrix
I <- diag(c(1,1,1))
A %*% I 
A

# matrix and vector dot porduct
#  A   dot   x   =    b
# 3X3       3X1      3X1
dim(A)
x = c(2,1,3)
b = A %*% x
b

# matrix inverse
solve(A)

# transpose a matrix or vector
A
t(A)

x
t(x)
t(t(x))

# solving system of linear equations
solve(A,b)
x

solve(A,I)
solve(A)
A
round(A %*% solve(A),0.0001)