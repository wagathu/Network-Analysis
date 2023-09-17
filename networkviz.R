


# Network Visualization ---------------------------------------------------

#  visNetwork is a powerful tool in R to help
#  us describe networks and explore the structure visually.
#  It is extremely useful for us to obtain valuable information
#  from an interactive network graph


# Importing the Packages --------------------------------------------------

library(pacman)
p_load(visNetwork, igraph, RColorBrewer, dplyr, readxl, htmlwidgets)


# Creating a sample data set ----------------------------------------------

# A nodes data.frame must include a id column. Each id
# represents the node we want to display in our graph.
# Other optional columns can also be added into our nodes
# data.frame. They can help us to distinguish nodes in our
# graph. For example, each node is a student with a unique
# assigned id, his/her name, major, and major.type.


nodes <- data.frame(
  id = 1:7,
  # id column (must be called id)
  name = c("Asher", "Bella", "Chloe", "Daniel", "Emma", "Frank", "Gabriel"),
  # student names
  major = c("CS", "CS", "CS", "STAT", "DS", "DS", "DS"),
  # CS: computer science major, STAT: statistics major, DS: data science major
  major.type = c(1, 1, 1, 2, 3, 3, 3)
) # 1: CS, 2: STAT, 3: DS
data.frame(nodes)

# An edges data.frame must include a from column and a to
# column denoting the starting node and ending node of each
# edge. We use id to represent the starting node and ending
# node. We also add a weight column on our edges data.frame
# to describe the frequency of interactions between two nodes.
# For example, in the first row, we know student 1 reached out
# to student 2 once.

edges <- data.frame(
  from = c(1, 1, 2, 3, 5, 5, 6, 7),
  to = c(2, 4, 3, 1, 4, 6, 7, 5),
  weight = c(1, 1, 1, 1, 1, 1, 1, 1)
)
data.frame(edges)


# Visualization -----------------------------------------------------------

visNetwork(nodes, edges) #Simple Network

# Advanced plot -----------------------------------------------------------

colors <-
  colorRampPalette(brewer.pal(3, "RdBu"))(3) # use three colors to distinguish students by their majors
nodes <- nodes %>%
  mutate(
    shape = "dot",
    # "shape" variable: customize shape of nodes ("dot", "square", "triangle")
    shadow = TRUE,
    # "shadow" variable: include/exclude shadow of nodes
    title = major,
    # "title" variable: tooltip (html or character), when the mouse is above
    label = name,
    # "label" variable: add labels on nodes
    size = 20,
    # "size" variable: set size of nodes
    borderWidth = 1,
    # "borderWidth" variable: set border width of nodes
    color.background = colors[major.type],
    # "color.background" variable: set color of nodes
    color.border = "blue",
    # "color.border" variable: set frame color
    color.highlight.background = "yellow",
    # "color.highlight.background" variable: set color of the selected node
    color.highlight.border = "black"
  ) # "color.highlight.border" variable: set frame color of the selected node
visNetwork(nodes, edges, width = "100%", main = "Student Interaction Network") %>% # "main" variable: add a title
  visLayout(randomSeed = 4) # give a random seed manually so that the layout will be the same every time

edges <-
  edges %>%
  mutate(width=weight*3, # "width" variable: set width of each edge
                          color="lightgrey", # "color" variable: set color of edges
                          arrows="to", # "arrows" variable: set arrow for each edge ("to", "middle", "from ")
                          smooth=TRUE) # "smooth" variable: each edge to be curved or not
visNetwork(nodes, edges, width="100%", main="Student Interaction Network") %>% 
  visLayout(randomSeed=4)

visNetwork(nodes, edges, width="100%", main="Student Interaction Network") %>%
  visLayout(layout = "layout_with_fr") %>% 
  visOptions(highlightNearest=TRUE, # degree of depth = 1
             nodesIdSelection=TRUE,
             selectedBy="major",
             manipulation=TRUE) %>%  # "manipulation" variable: add/delete nodes/edges or change edges
  visLegend()

our_network <- visNetwork(nodes, edges)
visSave(our_network, file = "E:/Desktop/Network Analysis/Student Interaction Network.html", background="white")



# Data from Kaggle --------------------------------------------------------

setwd("E:/Desktop/Network Analysis")
Inodes <- read.csv(file.choose(), as.is = TRUE)
Iedges <- read.csv(file.choose(), as.is = TRUE)

Inodes %>% 
  View()
Iedges %>% 
  View()


# Preparing the nodes -----------------------------------------------------

colors <- colorRampPalette(brewer.pal(3, "OrRd"))(3)
Inodes <- Inodes %>% 
  mutate(
  shape = "dot",
  shadow = TRUE,
  title = type.label,
  label = media,
  size = 25,
  borderwidth = 2,
  color.background = colors[media.type],
  color.highlight.background = "yellow",
  color.highlight.border = "black"
  )


# Preparing the edges -----------------------------------------------------

Iedges <- Iedges %>% 
  mutate(
    arrows = "to",
    color = "royalblue",
    smooth = TRUE
  )
our_network <- visNetwork(Inodes, Iedges, main = "The flow of News in different stations") %>% 
  visLayout(randomSeed = 5) %>% 
  visOptions(highlightNearest = TRUE,
             manipulation = TRUE,
             nodesIdSelection = TRUE) %>% 
  visLegend() |>
  visInteraction(hideEdgesOnDrag = TRUE,
                 dragNodes = TRUE,
                 dragView = TRUE,
                 navigationButtons = TRUE)

visSave(our_network, file = "E:/Desktop/Network Analysis/mediaNetwork.html", background="white")








