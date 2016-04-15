# load library
library(igraph)

# load collaboration network
setwd("D:/Study/Network Science/igraph Deomos")
network <- read.graph("netscience.gml", format = "gml")

# the size of the network
str(network)

# see degree distribution
hist(degree(network, mode = "in"), border = F, col = "black")

# community detection
groups <- cluster_edge_betweenness(network, directed = T, modularity = T, merges = T)
groups$membership

# function to dispaly infor of node
whoIs <- function(index){
    sapply(vertex.attributes(network), function(attribute){return (attribute[index])})    
} 

# who is the leader in the field   
which.max(degree(network))

whoIs(34)

# largest cluster
sort(table(groups$membership), decreasing = T)[1]
t(mapply(whoIs, which(groups$membership == 12)))
## we will call it the barabasi gang
barabasiGang <- induced_subgraph(network, v = which(groups$membership == 12))
mean_distance(barabasiGang)
mean_distance(network)

# second largest cluster
sort(table(groups$membership), decreasing = T)[2]
t(mapply(whoIs, which(groups$membership == 17)))

which.max(degree(network, v = which(groups$membership == 17)))
which(groups$membership == 17)[7]
whoIs(217)
## we will call it the Boccaletti gang
boccalettiGang <- induced_subgraph(network, v = which(groups$membership == 17))
mean_distance(boccalettiGang)

# how far away are two researcher in the network
which(vertex.attributes(network)$label == "BARABASI, A")
which(vertex.attributes(network)$label == "HAN, S")
distances(network, v = 34, to = 764)
# and through what path can we connect two researchers    
shortest_paths(network, from = 34, to = 764)
vertex.attributes(network)$label[unlist(shortest_paths(network, from = 34, to = 764)$vpath)]

# is a* barabasi done a paper with lada adamic ?
which(vertex.attributes(network)$label == "ADAMIC, L")
distances(network, v = 34, to = 8)

