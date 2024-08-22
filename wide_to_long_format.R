library(tidyverse)

# Define the directory where your wide format CSV files are located
directory <- "C:/Users/uqzeftek/Desktop/CSV_wide/"

# Define a function to transform wide format CSV files to long format
process_csv <- function(file) {
  # Read the wide format CSV data
  data <- read.csv(file)
  
  # Extract the base name of the file (e.g., "slaser_3t_CRLB.csv")
  base_name <- basename(file)
  
  # Determine the values_to based on the file name
  if (grepl("tissue", base_name)) {
    values_to <- "tissue"
  } else if (grepl("CRLB", base_name)) {
    values_to <- "CRLB"
  } else if (grepl("tCr", base_name)) {
    values_to <- "tCr"
  } else {
    stop("Unrecognized file name pattern")
  }
  
  # Get metabolite names from column 6 to the end
  col_names <- colnames(data)[6:ncol(data)]
  
  # Reshape the data into long format
  long_data <- data %>%
    pivot_longer(
      cols = all_of(col_names),  # Select columns by name
      names_to = "metabolite",    # The name of the new column that will hold the metabolite names
      values_to = values_to       # The name of the new column that will hold the values
    )
  
  # Create a new file name for the long format CSV
  new_file_name <- gsub("_wf_", "_lf_", base_name)
  new_file_path <- file.path(directory, new_file_name)
  
  # Save the result to a CSV file
  write.csv(long_data, new_file_path, row.names = FALSE)
}

# List all wide format CSV files in the directory
csv_files <- list.files(path = directory, pattern = "*.csv", full.names = TRUE)

# Apply the function to each CSV file
purrr::walk(csv_files, process_csv)

# Define a function to combine long format CSV files into one wide format file
combine_long_format_files <- function(crlb_file, tcr_file, tissue_file, output_file) {
  # Read in the long format CSV files
  crlb_data <- read.csv(crlb_file) %>% rename(CRLB = CRLB)
  tcr_data <- read.csv(tcr_file) %>% rename(tCr = tCr)
  tissue_data <- read.csv(tissue_file) %>% rename(tissue = tissue)
  
  # Merge the data on the first 6 columns
  combined_data <- crlb_data %>%
    full_join(tcr_data, by = c("sequence", "field", "location", "sub", "session", "metabolite")) %>%
    full_join(tissue_data, by = c("sequence", "field", "location", "sub", "session", "metabolite"))
  
  # Write the combined data to a new CSV file
  write.csv(combined_data, output_file, row.names = FALSE)
}

# Define file paths and output file names for combining long format files
file_paths <- list(
  steam_3t = list(
    crlb = "C:/Users/uqzeftek/Desktop/CSV_wide/steam_3t_lf_CRLB.csv",
    tcr = "C:/Users/uqzeftek/Desktop/CSV_wide/steam_3t_lf_tCr.csv",
    tissue = "C:/Users/uqzeftek/Desktop/CSV_wide/steam_3t_lf_tissue.csv",
    output = "C:/Users/uqzeftek/Desktop/CSV_wide/steam_3t_combined.csv"
  ),
  slaser_3t = list(
    crlb = "C:/Users/uqzeftek/Desktop/CSV_wide/slaser_3t_lf_CRLB.csv",
    tcr = "C:/Users/uqzeftek/Desktop/CSV_wide/slaser_3t_lf_tCr.csv",
    tissue = "C:/Users/uqzeftek/Desktop/CSV_wide/slaser_3t_lf_tissue.csv",
    output = "C:/Users/uqzeftek/Desktop/CSV_wide/slaser_3t_combined.csv"
  ),
  steam_7t = list(
    crlb = "C:/Users/uqzeftek/Desktop/CSV_wide/steam_7t_lf_CRLB.csv",
    tcr = "C:/Users/uqzeftek/Desktop/CSV_wide/steam_7t_lf_tCr.csv",
    tissue = "C:/Users/uqzeftek/Desktop/CSV_wide/steam_7t_lf_tissue.csv",
    output = "C:/Users/uqzeftek/Desktop/CSV_wide/steam_7t_combined.csv"
  ),
  slaser_7t = list(
    crlb = "C:/Users/uqzeftek/Desktop/CSV_wide/slaser_7t_lf_CRLB.csv",
    tcr = "C:/Users/uqzeftek/Desktop/CSV_wide/slaser_7t_lf_tCr.csv",
    tissue = "C:/Users/uqzeftek/Desktop/CSV_wide/slaser_7t_lf_tissue.csv",
    output = "C:/Users/uqzeftek/Desktop/CSV_wide/slaser_7t_combined.csv"
  )
)

# Apply the function to all file paths
for (key in names(file_paths)) {
  combine_long_format_files(
    file_paths[[key]]$crlb,
    file_paths[[key]]$tcr,
    file_paths[[key]]$tissue,
    file_paths[[key]]$output
  )
}

# Define a function to combine all combined CSV files into one
combine_all_files <- function(file_paths, output_file) {
  # Read each CSV file and store in a list
  data_list <- lapply(file_paths, read.csv)
  
  # Combine all data frames into one by stacking rows
  combined_data <- bind_rows(data_list)
  
  # Write the combined data to a new CSV file
  write.csv(combined_data, output_file, row.names = FALSE)
}

# Define file paths for the combined CSV files
combined_files <- c(
  "C:/Users/uqzeftek/Desktop/CSV_wide/steam_3t_combined.csv",
  "C:/Users/uqzeftek/Desktop/CSV_wide/slaser_3t_combined.csv",
  "C:/Users/uqzeftek/Desktop/CSV_wide/steam_7t_combined.csv",
  "C:/Users/uqzeftek/Desktop/CSV_wide/slaser_7t_combined.csv"
)

# Define the output file path
final_output_file <- "C:/Users/uqzeftek/Desktop/CSV_wide/long_format.csv"

# Combine all CSV files and save to the output file
combine_all_files(combined_files, final_output_file)
