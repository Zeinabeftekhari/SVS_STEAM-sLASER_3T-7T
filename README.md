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
5) Figure_4.R: Metabolite Concentrations
    - The R script for Figure 4 creates detailed scatterplots to compare metabolite concentrations across two MRI sequences (sLASER and STEAM) at two different field strengths (3T and 7T). The script reads data from a CSV file, filters it accordingly,
      and generates four distinct plots. These plots are then combined into a single figure to facilitate easy comparison between the different sequences and field strengths.
6) Figure_5.py: ICC and CV Heatmaps
    - The Figure 5 script generates heatmaps to visualize the Intraclass Correlation Coefficient (ICC) and Coefficient of Variation (CV) for the same MRI sequences and field strengths. It reads data from a CSV file, applies custom colormaps, and
      produces a series of heatmaps that compare ICC and CV values across various metabolites and voxel locations. This visualization aids in understanding the reliability and variability of the data.

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
