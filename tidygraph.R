

# Network Plots with other packages ---------------------------------------

packages = c('igraph', 'tidygraph', 'ggraph', 'visNetwork', 'lubridate', 'tidyverse')

for(p in packages){library
  if(!require(p, character.only = T)){
    install.packages(p)
  }
  library(p, character.only = T)
}


# Data Wrangling ----------------------------------------------------------

setwd("E:/Desktop/Network Analysis")
nodes <- read.csv("InputFileNodes.csv")
edges <- read.csv("InputFileEdges.csv")


# Creating Graph using tidygraph ------------------------------------------

graph1 <- tbl_graph(nodes = nodes, edges = edges, directed = TRUE)


# Plotting a basic network graph ------------------------------------------

g <- ggraph(graph1, layout = "nicely") + 
  geom_edge_link(aes(color = 'grey50')) +
  geom_node_point(aes(color = type.label, size = 3))

g + theme_graph(background = 'grey10', text_colour = 'white')
