# wheat-grain-segmentation

This project generates synthetic images of wheat seeds and the groundtruth for seed instance segmentation.
Please unzip the file 'Wheat-Base' at first.
Next, run the 'WheatImageGen.m' script to generate the datasets for model training and validation. (Here, the annotation format required by YoloV8-segment is provided.)
Then, please use the synthetic datasets for instance segmentation model training.
Finally, users could evaluate the performances of the models by a real wheat seed image dataset (images and the coresponding labels are included in the file 'Wheat-real.zip').
