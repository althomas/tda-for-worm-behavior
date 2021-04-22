# functions for removing or replacing rows of NaNs in data
# Ashleigh Thomas
# althomas41@gmail.com
# 2020

clean_NaNs <- function(data, return_nNaNs=FALSE){
  clean_NaNs_repeat(data, return_nNaNs)
}

#Overwrite each row of NaNs with data from previous row. 
#Remove any NaNs from start of data set
#Count how many/which rows needed are overwritten
clean_NaNs_repeat <- function(data, return_nNaNs=FALSE){
  
  nNaNs <- 0
  while (anyNA(data[1,])){
    # use as.matrix else nx1 matrices revert to vectors
    data <- as.matrix(data[-c(1),])
    nNaNs <- nNaNs+1
  }
  for (i in 2:nrow(data)){
    if (anyNA(data[i,])){
      data[i,] <- data[i-1,]
      nNaNs <- nNaNs+1
    }
  }
  if (return_nNaNs) {return(list(data,nNaNs))}
  return(data)
}



remove_NaNs <- function(data){
  #Remove each row of NaNs. 
  for (i in 1:nrow(data)){
    if (anyNA(data[i,])){
      data <- data[-c(i),]
    }
  }
  return(data)
}


NaN_indices <- function(data){
  indices <- vector()
  for (i in 1:nrow(data)){
    if (anyNA(data[i,])){
      indices <- append(indices, i)
    }
  }
  return(indices)
}