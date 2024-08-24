#22/1/2024
#Zeinab Eftekhari and Dr. Thomas Shaw

# Load the required library
library(ggplot2)

# Read the CSV file
data <- read.csv("path/to/csv")
participant_colors <- c("#fcc5c0", "#fa9fb5", "#f768a1", "#c51b8a", "#7a0177")

library(ggplot2)
library(dplyr)
library(patchwork)

filtered_data <- filter(data, fieldStrength == "7t" & sequence == "slaser")

# Create a new factor variable for x-axis ordering
filtered_data <- filtered_data %>%
  mutate(ordering = interaction(metabolitesName, sessions, lex.order = TRUE))


# Create the scatterplot with y-axis limits for sLASER, 7T
plot <- ggplot(filtered_data, aes(x = ordering, y = TissCorrWaterScaled, shape = voxelLocation, color = ptp, group = interaction(metabolitesName, ptp, metabolitesName, voxelLocation))) +
  geom_point(position = position_dodge(width = 0.8), size = 4) +
  geom_line(aes(group = interaction(metabolitesName, ptp, metabolitesName, voxelLocation)), position = position_dodge(width = 0.8)) +
  scale_color_manual(values = participant_colors) +
  scale_shape_manual(values = c("Lowerlimb" = 8, "Upperlimb" = 17)) +
  labs( y = "Metabolite Concentrations", title = "sLASER,7T") +
  ylim(0, 25) +  # Set y-axis limits
  theme(
    plot.title = element_text(size = 15), 
    axis.title.y = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    legend.title = element_blank(),
    legend.text = element_blank()  )

filtered_data1 <- filter(data, fieldStrength == "3t" & sequence == "slaser")

# Create a new factor variable for x-axis ordering
filtered_data1 <- filtered_data1 %>%
  mutate(ordering = interaction(metabolitesName, sessions, lex.order = TRUE))

# Apply the same adjustment for the other plots
plot1 <- ggplot(filtered_data1, aes(x = ordering, y = TissCorrWaterScaled, shape = voxelLocation, color = ptp, group = interaction(metabolitesName, ptp, metabolitesName, voxelLocation))) +
  geom_point(position = position_dodge(width = 0.8), size = 4) +
  geom_line(aes(group = interaction(metabolitesName, ptp, metabolitesName, voxelLocation)), position = position_dodge(width = 0.8)) +
  scale_color_manual(values = participant_colors) +
  scale_shape_manual(values = c("Lowerlimb" = 8, "Upperlimb" = 17)) +
  labs( y = "Metabolite Concentrations", title = "sLASER,3T") +
  ylim(0, 25) +  # Set y-axis limits
  theme(
    plot.title = element_text(size = 15), 
    axis.title.y = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)  )

filtered_data2 <- filter(data, fieldStrength == "7t" & sequence == "steam")

# Create a new factor variable for x-axis ordering
filtered_data2 <- filtered_data2 %>%
  mutate(ordering = interaction(metabolitesName, sessions, lex.order = TRUE))

plot2 <- ggplot(filtered_data2, aes(x = ordering, y = TissCorrWaterScaled, shape = voxelLocation, color = ptp, group = interaction(metabolitesName, ptp, metabolitesName, voxelLocation))) +
  geom_point(position = position_dodge(width = 0.8), size = 4) +
  geom_line(aes(group = interaction(metabolitesName, ptp, metabolitesName, voxelLocation)), position = position_dodge(width = 0.8)) +
  scale_color_manual(values = participant_colors) +
  scale_shape_manual(values = c("Lowerlimb" = 8, "Upperlimb" = 17)) +
  labs( y = "Metabolite Concentrations", title = "STEAM,7T") +
  ylim(0, 25) +  # Set y-axis limits
  theme(
    plot.title = element_text(size = 15), 
    axis.title.y = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)  )

filtered_data3 <- filter(data, fieldStrength == "3t" & sequence == "steam")

# Create a new factor variable for x-axis ordering
filtered_data3 <- filtered_data3 %>%
  mutate(ordering = interaction(metabolitesName, sessions, lex.order = TRUE))

plot3 <- ggplot(filtered_data3, aes(x = ordering, y = TissCorrWaterScaled, shape = voxelLocation, color = ptp, group = interaction(metabolitesName, ptp, metabolitesName, voxelLocation))) +
  geom_point(position = position_dodge(width = 0.8), size = 4) +
  geom_line(aes(group = interaction(metabolitesName, ptp, metabolitesName, voxelLocation)), position = position_dodge(width = 0.8)) +
  scale_color_manual(values = participant_colors) +
  scale_shape_manual(values = c("Lowerlimb" = 8, "Upperlimb" = 17)) +
  labs( y = "Metabolite Concentrations", title = "STEAM,3T") +
  ylim(0, 25) +  # Set y-axis limits
  theme(
    plot.title = element_text(size = 15), 
    axis.title.y = element_text(size = 12),
    axis.text.y = element_text(size = 12),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)  )

# Combine the plots
combined_plot <- plot + plot1 + plot2 + plot3 + plot_layout(ncol = 1, nrow = 4) 
print(combined_plot)
