24/1/2024
#Zeinab Eftekhari and Dr. Thomas Shaw
#This is a script for showing ICC and CV as heatmap


import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.colors import LinearSegmentedColormap

# Read data from CSV file
data_df = pd.read_csv("path/to/csv")

# Define custom colormap for ICC
def custom_icc_colormap():
    cmap_colors = [(0.843, 0.098, 0.224), ((1, 0.8, 0.4)), (0.101, 0.604, 0.314)]  # Red to Yellow to Green
    return LinearSegmentedColormap.from_list("custom_icc_colormap", cmap_colors)

# Define custom colormap for CV
def custom_cv_colormap():
    cmap_colors = [(0.101, 0.604, 0.314), ((1, 0.8, 0.4)), (0.843, 0.098, 0.224)]  # Green to Yellow to Red
    return LinearSegmentedColormap.from_list("custom_cv_colormap", cmap_colors)

# Plotting
plt.figure(figsize=(20, 10), dpi=100)  # Adjust figure size to accommodate 4 columns and 2 rows

for i, (sequence, field_strength) in enumerate(data_df[['sequences', 'field_strengths']].drop_duplicates().values):
    # Plot ICC heatmap in the top row
    plt.subplot(2, 4, i + 1)  # Top row: indices 1 to 4
    subset_icc = data_df[(data_df['sequences'] == sequence) & (data_df['field_strengths'] == field_strength)]
    heatmap_data_icc = subset_icc.pivot_table(values='ICC', index='Metabolite', columns='voxel_locations')
    sns.heatmap(heatmap_data_icc, annot=True, cmap=custom_icc_colormap(), fmt=".1f", linewidths=0.5, vmin=-1, vmax=1,
                annot_kws={"size": 15})  # Increase the font size of annotations
    plt.title(f"{sequence} - {field_strength} (ICC)")
    plt.xlabel("Voxel Location")
    plt.ylabel("Metabolites")
    plt.yticks(rotation=0)  # Rotate y-axis labels horizontally

    # Plot CV heatmap in the bottom row
    plt.subplot(2, 4, i + 5)  # Bottom row: indices 5 to 8
    subset_cv = data_df[(data_df['sequences'] == sequence) & (data_df['field_strengths'] == field_strength)]
    heatmap_data_cv = subset_cv.pivot_table(values='CV', index='Metabolite', columns='voxel_locations')
    sns.heatmap(heatmap_data_cv, annot=True, cmap=custom_cv_colormap(), fmt=".1f", linewidths=0.5, vmin=0, vmax=20,
                annot_kws={"size": 15})  # Increase the font size of annotations
    plt.title(f"{sequence} - {field_strength} (CV)")
    plt.xlabel("Voxel Location")
    plt.ylabel("Metabolites")
    plt.yticks(rotation=0)  # Rotate y-axis labels horizontally

plt.tight_layout()
plt.show()
