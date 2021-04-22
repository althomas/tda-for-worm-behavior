# Iryna Hartsock, Alex Elchesen, Ashleigh Thomas
# althomas41@gmail.com
# 2021


subsample_patches <- function(p_length, data){
  if (p_length == 0){
    list.patches <- list()
    list.patches[[1]] <- data
    return(list.patches)
  }
  # compute number of patches
  n <- 2*floor(nrow(data)/p_length)-1  # number of patches if odd 
  if (round(nrow(data)/p_length) > floor(nrow(data)/p_length)){
    n <- n+1 # even number of patches
  }
  list.patches <- list()
  list.patches[[1]] <- data[1:(p_length),]
  if (n > 1) {
    for (i in 2:n){
      list.patches[[i]] <- data[((i-1)*p_length/2+1):((i+1)*p_length/2),]
    }
  }
  #list.patches[[n+1]] <- data[((n+1)*p_length/2+1):(nrow(data)),]  #number of patches is n+1 and the last patch is of length less than p_length
  return(list.patches)
}