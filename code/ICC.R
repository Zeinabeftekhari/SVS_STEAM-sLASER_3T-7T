#24/08/2024
#Zeinab Eftekhari and Dr.Thomas Shaw

#This R script calculates the Intraclass Correlation Coefficient (ICC) for metabolite concentrations across different MRI sequences, field strengths, and voxel locations. 
#The script reads data from a CSV file, processes it by looping through unique combinations of parameters, and calculates the ICC for each combination using a two-way agreement model. 
#The results are stored in a list, converted into a data frame, and then saved as a CSV file for further analysis.


# Load the necessary packages
library(irr)
library(tidyverse)
library(heatmaply)

# Load the data from the CSV file
data <- read.csv("path/to/csv")

# Initialize a list to store the results
results <- list()

# Get unique values of parameters
metabolites <- unique(data$metabolite)
sequences <- unique(data$sequence)
fields <- unique(data$field)
locations <- unique(data$location)

# Loop through each unique combination of parameters
for (metabolite in metabolites) {
  for (sequence in sequences) {
    for (field in fields) {
      for (location in locations) {
        
        # Subset the dataframe based on the current combination of parameters
        subset <- data[data$metabolite == metabolite & data$sequence == sequence & data$field == field & data$location == location,]
        
        # Check if there are enough data points to calculate ICC
        if (nrow(subset) < 2) {
          next
        }
        
        # Reshape the data so that each session is a separate column
        subset_wide <- subset %>% 
          pivot_wider(names_from = session, values_from = metabolie_concentration)
        
        # Try to calculate the ICC
        tryCatch({
          icc <- icc(as.matrix(subset_wide[, -c(1:5)]), model = "twoway", type = "agreement")
          # Append the results to the list
          results[[paste(metabolite, sequence, field, location, sep = "__")]] <- icc$value
        }, warning = function(w) {
          # If a warning occurs, record the warning message in the results
          results[[paste(metabolite, sequence, field, location, sep = "__")]] <- as.character(w)
        })
      }
    }
  }
}

# Print the results
results

# Convert the list of results to a data frame
results_df <- data.frame(Parameter = names(results), ICC = unlist(results), stringsAsFactors = FALSE)

# Separate the combined parameter string into separate columns
results_df <- tidyr::separate(results_df, Parameter, into = c("Metabolite", "Sequence", "Field", "Location"), sep = "__")

# View the results data frame
View(results_df)
write.csv(results_df, "C:/Users/uqzeftek/Desktop/CSV_wide/ICC.csv", row.names = FALSE)
