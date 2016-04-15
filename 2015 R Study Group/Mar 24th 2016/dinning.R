# load library
library(igraph)
# load dinning table graph data
setwd("D:/Study/Network Science/igraph Deomos")
dinning <- read.graph("dinning.gml", format = "gml")
# the edge list of the graph
str(dinning)
# the adjacency matrix of the graph
as_adjacency_matrix(dinning)
# plot the graph
set.seed(0306)
plot.igraph(dinning,  edge.arrow.width = 0, layout=layout_with_dh)
# degree distributions
table(degree(dinning, mode = "out"))
hist(degree(dinning, mode = "in"), border = F, col = "black")
which.max(degree(dinning))
## every one name two person she wanted to sit with 
## girl number 9 is the most popular girl
## who is she?
vertex.attributes(dinning)$label[9]
# communities detection via betweeness clustering
groups <- cluster_edge_betweenness(dinning)
# see the small communities within this small network
groups$membership
# re-plot with convex hull representing communities
set.seed(0306)
plot.igraph(dinning, mark.groups = groups,  edge.arrow.width = 0.1, layout=layout_with_dh)
# strongly connected components
components <- components(dinning, mode = c("strong"))
components
