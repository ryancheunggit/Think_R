# load library
library(igraph)

# load lada's facebook network
setwd("D:/Study/Network Science/igraph Deomos")
ladaNetwork <- read.graph("LadaFacebookAnon.gml", format = "gml")


# see degree distribution
hist(degree(ladaNetwork), border = F, col = "black")

# commnuity detection    
groups <- cluster_edge_betweenness(ladaNetwork, directed = T, modularity = T, merges = T)

groups$membership

V(ladaNetwork)$color <- groups$membership + 1

# plot the network using tcltk
tkplot(graph = ladaNetwork,
       layout = layout.kamada.kawai,
       canvas.width = 600,
       canvas.height= 600,
       vertex.size=5,
       vertex.label=NA,
       edge.curved=T)   

# what are the attributes of nodes
names(vertex.attributes(ladaNetwork))

# anyone have better way to see the information about nodes please let me know  
whoIs <- function(index){
    sapply(vertex.attributes(ladaNetwork), function(attribute){return (attribute[index])})    
} 

# who is the most popular person in lada's network   
which.max(degree(ladaNetwork))

whoIs(301)

# what is the largest communities in lada's network
which.max(table(groups$membership))

# who are they?  Umich colleagues?
t(mapply(whoIs, which(groups$membership == 36)))

# what about the second largest communities? research collaborators
sort(table(groups$membership), decreasing = T)[2]
t(mapply(whoIs, which(groups$membership == 37)))

# what about the third largest communities? lada did undergraduate at Caltech
sort(table(groups$membership), decreasing = T)[3]
t(mapply(whoIs, which(groups$membership == 39)))
