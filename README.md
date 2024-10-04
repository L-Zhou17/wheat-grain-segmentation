# wheat-grain-segmentation

This project generates synthetic images of wheat seeds and the groundtruth for seed instance segmentation. 
Usage:
Step 1 - Please unzip the file 'Wheat-Base' at first.  
Step 2 - Run the 'WheatImageGen.m' script to generate the datasets for model training and validation. (Here, the annotation format required by YoloV8-segment is provided.)  
Step 3 - Please use the synthetic datasets for instance segmentation model training.  
Step 4 - Finally, users could evaluate the performances of the models by a real wheat seed image dataset (images and the coresponding labels are included in the file 'Wheat-real.zip').
* The script 'mAP50_eval.m' was provided for mAP and mIoU calculation.
