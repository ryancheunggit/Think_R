# load library
library(igraph)

# generate preferential attachment networks with different number of nodes 
# also try to vary the preferential attachment exponent 
set.seed(0306)
pagraph <- aging.prefatt.game(100, 1, 0)
hist(degree(pagraph), border= F, col = 'black')

pagraph <- aging.prefatt.game(200, 1, 0)
hist(degree(pagraph), border= F, col = 'black')

pagraph <- aging.prefatt.game(300, 1, 0)
hist(degree(pagraph), border= F, col = 'black')

pagraph <- aging.prefatt.game(500, 1, 0)
hist(degree(pagraph), border= F, col = 'black')

ergraph <- erdos.renyi.game(1000, 0.02)
hist(degree(ergraph), border = F, col = "black")
ergraph.density <- density(degree(ergraph))
plot(ergraph.density$x, ergraph.density$y, type = "l")


pagraph <- aging.prefatt.game(1000, 1, 0)
hist(degree(pagraph), border= F, col = 'black')
pagraph.density <- density(degree(pagraph))
plot(pagraph.density$x, pagraph.density$y, type = "l")


## the degree distribution is exponential distribution
pagraph <- aging.prefatt.game(200, 1, 0)
plot.igraph(pagraph, vertex.size = degree(pagraph), vertex.label = NA, edge.arrow.width = 0, layout=layout_with_dh)
groups <- cluster_edge_betweenness(pagraph)
plot.igraph(pagraph, vertex.size = degree(pagraph), mark.groups = groups, vertex.label = NA, edge.arrow.width = 0, layout=layout_with_dh)

