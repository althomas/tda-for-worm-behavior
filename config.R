# configuration file for compute_persistence.R
# Ashleigh Thomas 
# althomas41@gmail.com
# Jan 2021

################################## 
####### CHOOSE PARAMETERS ####### 
# heuristic: choose window length to be similar to one period of a quasi-periodic feature of interest
# heuristic: choose patch length to be on the order of 10 times the window length
window_length <- 5
patch_length <- 100 # when 0, take one patch of all data
nframes <- 500      # when 0, take all data in each file
################################## 
################################## 


saved_persistence_computation_folder <- "./computations/" # where to save persistence computations
saved_persistence_filename_base <- sprintf("viscosity_persistence_n%i_p%i_w%i_%s", nframes, patch_length, window_length, format(Sys.time(), format = "%F_%R"))

data_type = "viscosity"
data_tag <- sprintf("visc-%04i-%i-%02i",nframes,patch_length,window_length)
README_config <- sprintf("viscosity data persistence computations. number of frames=%i, patch length=%i, window length=%i.", nframes, patch_length, window_length)

# classes <- c("0.5%\ methylcellulose","1%\ methylcellulose","2%\ methylcellulose","3%\ methylcellulose")
classes <- c("0.5%","1%","2%","3%") # identifiers for classes (used in plot titles)
class_index<- c(rep(1,10), rep(2,10), rep(3,10), rep(4,10)) # indicates the class of each sample

################################## 
###### INPUT DATA FILEPATHS ######
data_folder <- "./data/environment/" # folder containing data to input in compute_diagrams.R
samples <- list( # identifier for each sample (used in plot titles)
  "08262017_worm_1_1",
  "08262017_worm_7_2",
  "08282017_worm_14_1",
  "08282017_worm_9_2",
  "08282017_worm_9_4",
  "08052017_worm_4_8",
  "08262017_worm_1_2",
  "08282017_worm_10_3",
  "08282017_worm_14_3",
  "08282017_worm_9_3",
  
  "08062017_worm_2_4",
  "08302017_worm_1_2",
  "08302017_worm_2_2",
  "08302017_worm_3_1",
  "08302017_worm_8_1",
  "08282017_worm_9_4",
  "08302017_worm_1_4",
  "08302017_worm_2_3",
  "08302017_worm_7_2",
  "08302017_worm_9_1",
  
  "08272017_worm_1_3",
  "08282017_worm_10_4",
  "08302017_worm_3_2",
  "08302017_worm_6_2",
  "08302017_worm_6_4",
  "08282017_worm_10_1",
  "08282017_worm_2_4",
  "08302017_worm_3_4",
  "08302017_worm_6_3",
  "09012017_worm_7_2",
  
  "08122017_2_worm_1_1",
  "08312017_worm_3_3",
  "09012017_worm_1_3",
  "09032017_worm_2_3",
  "09032017_worm_5_2", 
  "08282017_worm_2_3",
  "08312017_worm_6_1",
  "09032017_worm_2_2",
  "09032017_worm_5_1",
  "09032017_worm_5_3"
)


data_filenames <- list() # relative paths from data_folder to each sample's data file. 
filename_bases<-samples
for (i in 1:length(samples)){
  data_filenames[i] <- paste0(classes[class_index[i]],"\ methylcellulose/",samples[i],"/",samples[i],"_Basicmtr_eigenprojections.csv")
}
################################## 
################################## 

nsamples <- length(samples) # number of samples
nclasses <- length(classes) # number of classes
samples_per_class <- as.data.frame(table(class_index))[,2] # number of samples in each class
