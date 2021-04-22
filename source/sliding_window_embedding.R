# Ashleigh Thomas
# althomas41@gmail.com
# 2020

sliding_window_embedding <- function(input_data, window_length){
  
  #initialize data frame for sliding window embedding
  window_row_names <- vector()
  for (i in 1:window_length){
    window_row_names <- c(window_row_names,names(input_data))
  }
  sliding_window <- data.frame(matrix(ncol = length(window_row_names), nrow = 0))
  colnames(sliding_window) <- window_row_names
  
  #put data into sliding window embedding data frame
  for (j in 1:(nrow(input_data)-window_length+1)){
    new_data <- vector()
    for (i in 0:(window_length-1)){
      new_data <- c(new_data, input_data[j+i,])
    }
    names(new_data) <- names(sliding_window) #cant copy in without matching column names
    sliding_window <- rbind(sliding_window, new_data)
  }
  return(sliding_window)
}
