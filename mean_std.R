# Load necessary library
library(dplyr)

# Load and process data
data <- read.csv("C:/Users/uqzeftek/Desktop/CSV_wide/long_format_outlier_removed.csv")

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
write.csv(subject_mean_table, "C:/Users/uqzeftek/Desktop/CSV_wide/subject_mean.csv", row.names = FALSE)

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
write.csv(mean_std_data, "C:/Users/uqzeftek/Desktop/CSV_wide/final_mean_std.csv", row.names = FALSE)
