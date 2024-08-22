#20240822
#ZE and TBS - CV calculation for metabolites
# This script processes metabolite data to calculate the mean and standard deviation for various experimental variables.
# The script performs the following steps:
#
# 1. Load the necessary library for data manipulation.
# 2. Read the input CSV file containing the raw data.
# 3. Calculate the mean and standard deviation of CRLB, tCr, and tissue values for each unique combination of 
#    subject, sequence, field, location, and metabolite. These results are stored in a 'subject mean' table.
# 4. Save the 'subject mean' table to a specified CSV file.
# 5. Calculate the overall mean and standard deviation across all subjects for each unique combination of sequence, 
#    field, location, and metabolite. These results are stored in a 'mean and standard deviation' table.
# 6. Save the 'mean and standard deviation' table to a specified CSV file.

# Load necessary library
library(dplyr)

# Load and process data
data <- read.csv("/path/to/csv")

# Calculate mean and standard deviation for each combination of subject, sequence, field, location, and metabolite
subject_mean_table <- data %>%
  group_by(sequence, field, location, sub, metabolite) %>%
  summarise(
    meanValue_CRLB = mean(CRLB, na.rm = TRUE),
    stdValue_CRLB = sd(CRLB, na.rm = TRUE),
    meanValue_tCr = mean(tCr, na.rm = TRUE),
    stdValue_tCr = sd(tCr, na.rm = TRUE),
    meanValue_tissue = mean(tissue, na.rm = TRUE),
    stdValue_tissue = sd(tissue, na.rm = TRUE),
    .groups = 'drop'
  )

# Save the subject mean table
write.csv(subject_mean_table, "/path/to/csv", row.names = FALSE)

# Calculate overall mean and standard deviation across all subjects
mean_std_data <- subject_mean_table %>%
  group_by(sequence, field, location, metabolite) %>%
  summarise(
    mean_CRLB = mean(meanValue_CRLB, na.rm = TRUE),
    std_CRLB = sd(meanValue_CRLB, na.rm = TRUE),
    mean_tCr = mean(meanValue_tCr, na.rm = TRUE),
    std_tCr = sd(meanValue_tCr, na.rm = TRUE),
    mean_tissue = mean(meanValue_tissue, na.rm = TRUE),
    std_tissue = sd(meanValue_tissue, na.rm = TRUE),
    .groups = 'drop'
  )

# Save the mean and standard deviation data
write.csv(mean_std_data, "/path/to/csv", row.names = FALSE)
