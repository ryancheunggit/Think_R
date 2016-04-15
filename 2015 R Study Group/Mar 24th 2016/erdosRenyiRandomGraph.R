# load library
library(igraph)
# generate random networks with different number of nodes but 
# the same probability to connect two different nodes in the 
# network and look at the degree distribution
set.seed(0306)
ergraph <- erdos.renyi.game(100, 0.02)
hist(degree(ergraph), border = F, col = "black")
summary(ergraph)
components(ergraph)

ergraph <- erdos.renyi.game(150, 0.02)
hist(degree(ergraph), border = F, col = "black")
summary(ergraph)
components(ergraph)

ergraph <- erdos.renyi.game(200, 0.02)
hist(degree(ergraph), border = F, col = "black")
summary(ergraph)
components(ergraph)

ergraph <- erdos.renyi.game(300, 0.02)
hist(degree(ergraph), border = F, col = "black")
summary(ergraph)
components(ergraph)


ergraph <- erdos.renyi.game(500, 0.02)
hist(degree(ergraph), border = F, col = "black")
summary(ergraph)
components(ergraph)


ergraph <- erdos.renyi.game(1000, 0.02)
hist(degree(ergraph), border = F, col = "black")
summary(ergraph)
components(ergraph)

## the degree distribution is binomial distribution
## if p is small can use poisson distribution as approximation
## if n is also larger can further use normal distribution as approximation
ergraph <- erdos.renyi.game(200, 0.02)
plot.igraph(ergraph, vertex.size = degree(ergraph), vertex.label = NA)
groups <- cluster_walktrap(ergraph)
plot.igraph(ergraph, vertex.size = degree(ergraph), mark.groups = groups, vertex.label = NA)
# not much a sub-structure within the graph, since it is a random graph 
