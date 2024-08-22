#!/bin/bash
#22/06/2024
#Zeinab Eftekhari and Dr. Thomas Shaw

# register the second time point scout to first time point T1W, thne move the mask to the same space for calcualting dice overlap

ml ants
eval-seg-path=/path/to/EvaluateSegmentation
mask_path="/path/to/steam_slaser_3t_7t/dice_overlap"
bids_math="/path/to/bids/
subjects=("sub-XXX")
#insert subject names above

locations=("ll" "ul")
#Upper limb and lower limb

fields=("3T" "7T")

segmentations=("WM" "GM")

# Loop through the subject directories for registration
for subject in "${subjects[@]}"; do
    for field in "${fields[@]}"; do
		antsRegistrationSyNQuick.sh -d 3 -m ${bids_path}/${subject}/ses-02-${field}/anat/${subject}_ses-02-${field}_acq-SCOUT.nii.gz \
        -f ${bids_path}/${subject}/ses-01-${field}/anat/${subject}_${field}_acq-T1W.nii.gz \
        -n BSpline \
        -o ${bids_pat}/${subject}/${subject}_${field}_ses02_scout_to_ses01_T1w_
  	done
done

# Loop through the subject directories for segmentation
for subject in "${subjects[@]}"; do
    for field in "${fields[@]}"; do
        for location in "${locations[@]}"; do
            for segmentation in "${segmentations[@]}"; do
                antsApplyTransforms -d 3 \
                -i ${mask_path}/${subject}/${subject}_ses02_${location}_mask_${segmentation}_${field}.nii.gz \
                -r ${mask_path}/${subject}_ses01_${location}_mask_${segmentation}_${field}.nii.gz \
                -t ${mask_path}/${subject}_${field}_ses02_scout_to_ses01_T1w0GenericAffine.mat \
                -o ${mask_path}/${subject}_ses02_${location}_mask_${segmentation}_${field}_new.nii.gz \
                -n GenericLabel
            done
        done
    done
done


# Loop through the subject directories for segmentation
for subject in "${subjects[@]}"; do
    for field in "${fields[@]}"; do
        for location in "${locations[@]}"; do
            for segmentation in "${segmentations[@]}"; do
		        ${eval-seg-path} groundtruthPath segmentPath -unit voxel DICE  >> .csv
            done
        done
    done
done
 


