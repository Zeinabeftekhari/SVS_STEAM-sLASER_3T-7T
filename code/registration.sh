#!/bin/bash
#22/06/2024
#Zeinab Eftekhari and Dr. Thomsa Shaw

# register the second time point scout to first time point T1W, then move the mask to the same space for calculating dice overlap
# Load required modules (ensure your environment uses 'ml' for loading modules)
ml fsl/6.0.6.4
ml freesurfer
ml ants

# Define paths
EvaluateSegmentation_path=/path/to/EvaluateSegmentation
mask_path="/path/to/steam_slaser_3t_7t/dice_overlap"

# Define variables
subjects=("sub-XXX")
#insert subject names above

locations=("ll" "ul")
#Upper limb and lower limb

fields=("3T" "7T")

segmentations=("WM" "GM")



# Loop through subjects, fields, locations, and segmentations
for subject in "${subjects[@]}"; do
    for field in "${fields[@]}"; do
        for location in "${locations[@]}"; do
            for segmentation in "${segmentations[@]}"; do
                
                # Apply transforms with antsApplyTransforms
                antsApplyTransforms -d 3 \
                    -i "${mask_path}/${subject}_ses02${field}${location}_${segmentation}.nii.gz" \
                    -r "${mask_path}/${subject}_ses01${field}${location}_${segmentation}.nii.gz" \
                    -t "[${mask_path}/${subject}_${field}_ses01_t1w_to_ses02_scout_0GenericAffine.mat,1]" \
                    -o "${mask_path}/${subject}_ses02${field}${location}_${segmentation}_new.nii.gz" \
                    -n GenericLabel
                
                # Binarize the images using fslmaths
                fslmaths "${mask_path}/${subject}_ses02${field}${location}_${segmentation}_new.nii.gz" -bin "${mask_path}/${subject}_ses02${field}${location}_${segmentation}_new_bin.nii.gz"
                fslmaths "${mask_path}/${subject}_ses01${field}${location}_${segmentation}.nii.gz" -bin "${mask_path}/${subject}_ses01${field}${location}_${segmentation}_bin.nii.gz"

            done
        done
    done
done

# Remove existing overall.csv if it exists
if [[ -e ${mask_path}/overall.csv ]] ; then
    rm "${mask_path}/overall.csv"
fi

# Loop through each subject to calculate Dice overlap
for subject in "${subjects[@]}"; do
    for field in "${fields[@]}"; do
        for location in "${locations[@]}"; do
            for segmentation in "${segmentations[@]}"; do
                
                # Paths for the masks to be compared
                mask_ses02="${mask_path}/${subject}_ses02${field}${location}_${segmentation}_new_bin.nii.gz"
                mask_ses01="${mask_path}/${subject}_ses01${field}${location}_${segmentation}_bin.nii.gz"
                
                # Write the header to the CSV
                echo "${subject}_${location}_${segmentation}_${field}" >> "${mask_path}/overall.csv"
                
                # Compute the Dice overlap and append results to the CSV
                ${EvaluateSegmentation_path}/EvaluateSegmentation \
                    "${mask_ses02}" "${mask_ses01}" \
                    -use DICE -xml "${mask_path}/${subject}_${location}_${segmentation}_${field}_overlap.xml" | grep -h "DICE" >> "${mask_path}/overall.csv"

            done
        done
    done
done

echo "Processing complete. Results saved to ${mask_path}/overall.csv"
