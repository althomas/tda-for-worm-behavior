# Analyze aging data with landscapes of patches
# Iryna Kuz, Alex Elchesen, Ashleigh Thomas*
# *althomas41@gmail.com
# August 2020

library(tdatools)
library(tictoc)
library(viridis)
source("./source/clean_NaNs.R")
source("./source/persistence_utilities.R")
source("./source/sliding_window_embedding.R")
source("./source/subsample_patches.R")

############################################
############################################

start_time <- proc.time()

# load config parameters
source("./config.R")
save_computations <- TRUE
save_file_location <- save_patch_computation_location 
filename_base <- saved_patch_filename_base
data_file_location <- save_curated_data_location
save_filename <- sprintf("%s.RData", filename_base)


print(sprintf("Number of files to process: %i",length(data_filenames)))
print(sprintf("nframes=%i patch_length=%i window_length=%i", nframes, patch_length, window_length))

PDs <- list()
for (i in 1: length(data_filenames)){
  tic()
  print(sprintf("Processing file %i: %s %s", i, classes[class_index[i]], filename_bases[[i]]))
  # data preprocessing (remove NaNs)
  if (nframes == 0 || !exists("nframes")){
    raw_data <- read.csv(file=paste0(data_file_location,data_filenames[[i]]), header=FALSE)
  } else {
    raw_data <- read.csv(file=paste0(data_file_location,data_filenames[[i]]), header=FALSE, nrows=nframes)
  }
  raw_data <- clean_NaNs(raw_data)
  # subsample patches, compute landscapes for each patch
  patches <- subsample_patches(patch_length, raw_data)
  npatches <- length(patches)
  PDs[[i]] <- list()             #list of persistence diagrams for each patch
  print(sprintf("    %i patches of size %i; file size %i", npatches, patch_length, nrow(raw_data)))
  for (j in 1:npatches){
    # print(sprintf("processing patch %i", j))
    sliding_window <- sliding_window_embedding(patches[[j]], window_length)
    pd <- diagram(as.matrix(sliding_window),'point-cloud', dim_max = 1)
    PDs[[i]][[j]] <- pd
  }
  print(sprintf("    computations time for %s:", data_filenames[[i]]))
  toc()
}

print(sprintf("total computation time for %i files:", length(data_filenames)))
end_time <- proc.time()
computation_time <- end_time-start_time
print(computation_time)

# save data
if (save_computations){
  README_computation <- sprintf("persistence computations; nsamples=%i, nframes=%i, patch length=%i, window length=%i", length(data_filenames), nframes, patch_length, window_length)
  diagram_computation_filepath <- paste0(save_file_location, save_filename)
  save(PDs, 
       patch_length, window_length, nframes, 
       data_file_location, data_filenames, thetaMean_filenames, 
       classes, class_index, filename_bases, 
       samples, nsamples, nclasses, samples_per_class, 
       pca_basis_file, 
       README_computation, computation_time, 
       README_config, data_type, data_tag, 
    file=paste0(save_file_location,save_filename))
  print(sprintf("finished computations saved to %s", diagram_computation_filepath))
}
