#20240822
#ZE and TBS - CV calculation for metabolites
# This script processes metabolite data to remove outliers and calculate the coefficient of variation (CV)
# for different combinations of experimental variables (metabolites, sequences, fields, and locations).
# The CV is a measure of relative variability, calculated as the ratio of the standard deviation to the mean, 
# expressed as a percentage. The script follows these main steps:
# 
# 1. Load the necessary libraries for data manipulation.
# 2. Define the file paths for the input and output CSV files.
# 3. Read the input CSV file and filter out rows where the CRLB (Cramér-Rao Lower Bound) exceeds 50.
# 4. Write the filtered data to a new CSV file.
# 5. Load the filtered data and extract relevant columns.
# 6. Identify unique metabolites, sequences, fields, locations, and subjects present in the dataset.
# 7. Calculate the CV for each subject based on the different combinations of metabolite, sequence, field, and location,
#    and store these values in a 'subject CV' table.
# 8. Calculate the mean CV across all subjects for each combination of experimental variables and store these in a 'mean CV' table.
# 9. Save the 'subject CV' table and the 'mean CV' table as separate CSV files.

# Load necessary libraries
library(dplyr)
library(tidyr)


# Define the path to the input and output files
input_file <- ""
output_file <- ""

# Read the input CSV file
data_outlier <- read.csv(input_file)

# Filter out rows where CRLB is greater than 50
filtered_data <- data_outlier %>%
  filter(CRLB <= 50)

# Write the filtered data to a new CSV file
write.csv(filtered_data, output_file, row.names = FALSE)


# Load outlier removed data from the CSV file to calcualte subject CV and mean CV
data <- read.csv("")

# Extract relevant columns
sequence <- data$sequence
field <- data$field
location <- data$location
sub <- data$sub
session <- data$session
metabolite <- data$metabolite
value_tCr <- data$tCr
value_tissue <- data$tissue

# Find unique metabolites, sequences, fields, locations, and subjects
unique_metabolites <- unique(metabolite)
unique_sequences <- unique(sequence)
unique_fields <- unique(field)
unique_locations <- unique(location)
unique_subs <- unique(sub)

# Create empty data frames to store results
subject_CV_table <- data.frame()
mean_CV_table <- data.frame()

# Loop over each combination of metabolite, sequence, field, and location
for (met in unique_metabolites) {
  for (seq in unique_sequences) {
    for (fie in unique_fields) {
      for (loc in unique_locations) {
        
        # Initialize vectors to collect CV values for all subjects
        all_CV_tCr <- numeric()
        all_CV_tissue <- numeric()
        
        for (subj in unique_subs) {
          # Filter data for the specific sub, sequence, field, location, and metabolite
          filtered_data <- data %>%
            filter(sub == subj,
                   sequence == seq,
                   location == loc,
                   field == fie,
                   metabolite == met)
          
          filtered_data_tCr <- filtered_data$tCr
          filtered_data_tissue <- filtered_data$tissue
          
          # Calculate mean and standard deviation
          meanValue_tCr <- mean(filtered_data_tCr, na.rm = TRUE)
          stdValue_tCr <- sd(filtered_data_tCr, na.rm = TRUE)
          meanValue_tissue <- mean(filtered_data_tissue, na.rm = TRUE)
          stdValue_tissue <- sd(filtered_data_tissue, na.rm = TRUE)
          
          # Calculate coefficient of variation for each subject based on two sessions
          CV_tCr <- ifelse(meanValue_tCr != 0, (stdValue_tCr / meanValue_tCr) * 100, NA)
          CV_tissue <- ifelse(meanValue_tissue != 0, (stdValue_tissue / meanValue_tissue) * 100, NA)
          
          # Collect the CV values
          all_CV_tCr <- c(all_CV_tCr, CV_tCr)
          all_CV_tissue <- c(all_CV_tissue, CV_tissue)
          
          # Add a new row to the subject CV table
          new_row_subject <- data.frame(
            Subject = subj,
            Metabolite = met,
            Sequence = seq,
            Location = loc,
            Field = fie,
            CV_tCr = CV_tCr,
            CV_tissue = CV_tissue
          )
          
          subject_CV_table <- rbind(subject_CV_table, new_row_subject)
        }
        
        # Calculate the mean CV across all subjects for the current combination
        mean_CV_tCr <- mean(all_CV_tCr, na.rm = TRUE)
        mean_CV_tissue <- mean(all_CV_tissue, na.rm = TRUE)
        
        # Add a new row to the mean CV table
        new_row_mean <- data.frame(
          Metabolite = met,
          Sequence = seq,
          Location = loc,
          Field = fie,
          Mean_CV_tCr = mean_CV_tCr,
          Mean_CV_tissue = mean_CV_tissue
        )
        
        mean_CV_table <- rbind(mean_CV_table, new_row_mean)
      }
    }
  }
}

# Save the subject CV table to a CSV file
write.csv(subject_CV_table, "/path/to/file", row.names = FALSE)

# Save the mean CV table to a CSV file
write.csv(mean_CV_table, "/path/to/file", row.names = FALSE)
