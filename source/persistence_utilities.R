# Ashleigh Thomas
# althomas41@gmail.com
# 2020


# functions to plot and work with tda-tool's landscape and diagrams objects 
library(viridis)

# On an existing plot, draw the function corresponding to the landscape at a given depth
lines_single_landscape <- function(full_landscape, depth, color=viridis(10)[1]){
  data_array <- full_landscape$getInternal()
  mountain <- accessLevel(data_array,depth)
  lines(mountain, col=color)
}


plot_landscape <- function(landscape, y_max, y_min=0){
  data_array <- landscape$getInternal()
  plot_landscape_data_array(data_array, y_max, y_min)
}

# overloading plot_landscape so it can be used with either a landscape objects
# (which is a c++ object) or the data array within it, called the ``internal''
plot_landscape_data_array <- function(data_array, y_max, y_min=0){
  for (depth in 1:numLevels(data_array)){
    mountain <- accessLevel(data_array, depth)
    if (depth == 1) {
      if (missing(y_max)){
        plot(mountain, type='l', xlab='', ylab='', bty="n", col=viridis(1))
      } else {
        plot(mountain, type='l', xlab='', ylab='', bty="n", col=viridis(1), ylim=c(y_min,y_max))
      }
    } else {
      lines(mountain, col=viridis(10)[depth %% 10])
    }
  }
}

# returns maximum height of a landscape
get_landscape_y_max <- function(landscape){
  y_max <- 0
  data_array <- landscape$getInternal()
  mountain <- accessLevel(data_array,1)
  if (length(mountain)==2) {
    y_max <- max(y_max,mountain[2])
  } else {
    y_max <- max(mountain[,2])
  }
  return(y_max)
}


# input: list of landscapes, highest depth of landscape to include in vector
# landscape data is a collection of (x,y) points that approximate 
# the persistence landscape of some data. 
# vectorize_landscapes returns a matrix where each row is the concatenation 
# of the y values for each level (up to depth_cap) of a landscape. 
vectorize_landscapes <- function(PL_list, depth_cap=0){
  
  if (depth_cap == 0){ # no depth cap -- set to max depth over all landscapes
    max_depth <- 0
    for (i in 1:length(PL_list)){
      max_depth <- max(max_depth, dim(PL_list[[i]]$getInternal())[1])
    }
    depth_cap <- max_depth
  }
  
  vect_length <- depth_cap*dim(PL_list[[1]]$getInternal())[2]
  vect_PLs <- matrix(0, nrow=length(PL_list), ncol=vect_length)
  for (i in 1:length(PL_list)){
    if (dim(PL_list[[i]]$getInternal())[1] < depth_cap) { # fewer than depth_cap levels in this landscape
      # need the transpose because as.vector takes columns of a matrix, not rows
      temp_vec <- as.vector(t(PL_list[[i]]$getInternal()[,,2]))
      vect_PLs[i,1:length(temp_vec)] <- temp_vec
    } else {
      temp_vec <- as.vector(t(PL_list[[i]]$getInternal()[1:depth_cap,,2]))
      vect_PLs[i,] <- temp_vec
    }
  }
  return(vect_PLs)
}

# input is a vector of y values for each level of a landscape, all concatenated together, 
# plus some parameters for creating a discrete landscape. 
# output is the getInternal() of a persistence landscape: array of dim * x landscape_length x 2
vector_to_landscape_data_array <- function(vec, min_x, max_x, dx){
  
  landscape_length <- ceiling((max_x-min_x)/dx)
  x_vec <- (((1:landscape_length)-1)*dx)+min_x
  
  max_depth <- length(vec)/landscape_length
  data_array <- array(dim=c(max_depth, landscape_length, 2))
  data_array[,,2] <- matrix(vec, byrow=TRUE, ncol=landscape_length)
  data_array[,,1] <- rep(1,max_depth) %*% t(x_vec)
  
  return(data_array)
}


# computes landscape from diagram$pairs[[*]]
# returns 0 landscape if persistence diagram is empty (instead of erroring)
landscape0 <- function(pairs, degree, exact=FALSE, dx, min_x, max_x){
  if (length(pairs)==0) { # empty persistence diagram
    tdatools::landscape(matrix(0, nrow=1,ncol=2), degree=degree, exact=exact, dx=dx, min_x=min_x, max_x=max_x)
  } else {
    tdatools::landscape(pairs, degree=degree, exact=exact, dx=dx, min_x=min_x, max_x=max_x)
  }
}

# rough plot of barcode correpsonding to pairs<-diagram$pairs[[*]]
plot_barcode <- function(pairs){
  b_offset <- -0.2
  
  x_limits <- c(0,max(pairs)) # problem when max is inf?
  y_limits <- c((1+nrow(pairs))*b_offset,0)
  offset <- 0
  
  plot(0, col="white", xlim=x_limits, ylim=y_limits, yaxt='n', ann=FALSE, bty='n')
  bars <- pairs
  if (nrow(bars)>0){
    for (i in 1:nrow(bars)){
      lines(bars[i,], c(offset,offset))
      offset <- offset + b_offset
    }
  }
}

# plots persistence diagram
# input: diagram$pairs[[homology_degree]], 
# a number_homology_classes-by-2 matrix
plot_diagram <- function(pairs, dgm_max, dgm_min){
  finite_points <- matrix(pairs[pairs[,2] != Inf], ncol=2)
  infinite_points <- matrix(pairs[pairs[,2] == Inf], ncol=2)
  if (missing(dgm_min)){
    dgm_min <- min(pairs)
  }
  if (missing(dgm_max)){
    dgm_max <- max(pairs[pairs[,] != Inf])
    dgm_max <- dgm_max + 0.05*(dgm_max-dgm_min)
  }
  
  if (nrow(finite_points) > 0){
    plot(finite_points, col='blue', asp=1, xlab='', ylab='', xlim=c(dgm_min,dgm_max), ylim=c(dgm_min,dgm_max), bty='L')
  } else {
    plot(c(dgm_min,dgm_min), col='white', asp=1, xlab='', ylab='', xlim=c(dgm_min,dgm_max), ylim=c(dgm_min,dgm_max), bty='L')
  }
  points(infinite_points[,1],rep(dgm_max,nrow(infinite_points)), col='red', pch=17)
  abline(0,1)
}