# Shell script that takes input .spe files from confocal and converts to .tif using ImageJ

# Change directory to ImageJ
cd ~/Documents/ImageJ


# Run LSMtoTIFF.ijm macro
ImageJ -batch LSMtoTIFF.ijm


# Run tif2dax.m function on .tiff files
cd ~/Documents/Q-FISH-toolbox


# Change working directory
"C:\Program Files\MATLAB\R2014b\bin\matlab.exe" -nodisplay -nosplash -nodesktop -r "run('C:\Users\TweedleDee\Documents\Q-FISH-toolbox\tif2dax.m');exit;"
