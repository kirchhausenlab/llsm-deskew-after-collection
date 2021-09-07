# LLSM - Deskew after collection

## Pos-processing to fix lateral offset between 488nm and 642nm channels

Briefly, although 488nm (green) and 642nm (red) images are being recordedin the same camera, there is a lateral offset between this two channels. The following produre is not integrated, and requires some manula steps.

### 1. Manually copy the files in scratch.

### 2. Calculate the lateral shift

To adjust this shift, we use a matlab code called `image_translate.m`. The shift is expected to be constant in time an won't need to be measured daily.
Line 1-30 are commented, and are used to calculate the shift, using as input the tif files for the tetraspec bead in the 488nm channel and 642nm. The code calculates the shift in X and Y direction (dx and dy).

### 3. Apply the lateral shift

Line 32-54 allow tro apply the shift to all images in the,and save the shifted files in a in a different fol you input the folder of the Ex to be corrected (translated by dx and dy). For this procedure one needs to run the script as a funcion.


