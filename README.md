# SVS_STEAM-sLASER_3T-7T
## This is the code for paper named "Reliability and Reproducibility of Metabolites Quantification Measured in the Human Brain at 3 T and 7 T". 

### Zeinab Eftekhari and Thomas Shaw 2024
This repository contains a set of R and bash scripts designed to process, transform, and analyze metabolite data stored in CSV files. The scripts primarily focus on converting wide format data to long format, calculating statistical measures, and managing the data for further analysis.

## Repository Structure

1) CV.R: 
    - This script calculates the coefficient of variation (CV) for different combinations of experimental variables such as sequence, field, location, and metabolite. It reads in pre-processed data, filters outliers, and outputs both individual subject CVs and mean CVs across all subjects.
2) mean_std.R: 
    - This script calculates the mean and standard deviation of metabolite values (e.g., CRLB, tCr, tissue) for each subject and then summarizes these statistics across all subjects. The results are saved in separate CSV files.
3) wide_to_long_format.R: 
    - This script transforms wide format CSV files into long format. It identifies the appropriate column names based on file patterns, reshapes the data, and saves the long format files. It also includes functionality to combine these long format files into a single dataset.
4) registration.sh: 
    - A shell script included for registering or organizing the second session GM and WM segmentations together 

## Usage

1) Wide to Long Format Transformation:
	- Run the wide_to_long_format.R script to transform your wide format CSV files into long format. The script will save the long format files in the same directory as the original wide format files.
2.	Coefficient of Variation Calculation:
	- Use the CV.R script to calculate the coefficient of variation (CV) for each combination of experimental variables. The script outputs two CSV files: one containing the CVs for individual subjects and another with the mean CVs across all subjects.
3.	Mean and Standard Deviation Calculation: 
    - Run the mean_std.R script to compute the mean and standard deviation for each subject and summarize these statistics across all subjects. The results will be saved in specified CSV files.

###  Directory Structure

1) All CSV files should be placed in the appropriate directory, as specified in the scripts (/path/to/wide-format/ should be replaced with the actual path).
2) Processed data and output files will be saved in the same directory as the original data unless otherwise specified in the scripts.

### Requirements

1) R: Ensure you have R installed on your system. 
2) R Packages: The scripts use the dplyr, tidyverse, and purrr packages. You can install these packages using the following command in R:

    ```
    install.packages(c("dplyr", "tidyverse", "purrr"))
    ```
3) ANTs and ANTSRegistration plus fsl or similar for binarising masks. 
4) SLaser and STEAM is run through Osprey 
