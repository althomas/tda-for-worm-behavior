# tda-for-worm-behavior

**Repo is under construction and will be finished by end of April**

By Ashleigh Thomas, Alex Elchesen, Iryna Hartsock, Peter Bubenik

Analyze videos of *C. elegans* behavior using persistent homology techniques as outlined in https://arxiv.org/abs/2102.09380. 


## Dependencies
tda-tools by Jose Bouza https://github.com/jjbouza/tda-tools


## Usage
1. Symlink `config.R` to desired config file in `config` folder. In that config file, set window length, patch length, and number of frames as desired. Also include the filepaths for the input data, which is a 100-dimensional time series of angles. 

2. Run `compute_diagrams.R`. This does the heavy computations and can run for hours depending on parameter choice. 
        
    A file with the computed diagrams will be saved in the `computations` folder. 

3. Run chunks of `analyze_diagrams.Rmd`, using the output file from `compute_diagrams.R` as input. There are a few processing chunks and after that, each chunk gives a different aspect of analysis. 


## Getting and Preprocessing Data
1. Original video data collected by Kathleen Bates can be found here: https://www.youtube.com/playlist?list=PL5pzQyEKVlEjcmBWn9IVFivLJ4nqKKWC8.  

3. Download the code from this paper https://elifesciences.org/articles/17227 at figshare https://figshare.com/s/3ac08fbfec9ae3d5a531.  

5. Use the above code to extract 100-dimensional angle data for the skeletons of each sample into csv files.  

7. Add the filepaths to the csv files to a config file. Now you can run the tda-for-worm-behavior code on that data. 


## License
Apache License 2.0
