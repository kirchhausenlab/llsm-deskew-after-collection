# LLSM - Deskew after collection

## Pos-processing to fix lateral offset between 488nm and 642nm channels
Although 488nm (green) and 642nm (red) images are being recorded by the same camera, there is a lateral offset between these two channels. The produre still needs integrated, and it requires some manual steps for the time being.

### 1. Manually copy the files in scratch
The code will create a dummy folder in scratch contaning the raw files without shift, such folder needs to be disregarded during processing.

### 2. Calculate the lateral shift

To adjust this shift, use `image_translate.m`. The values to input as sigma need to be evaluated with `GU_estimateSigma3D.m`. The shift is expected to be constant in time and won't need to be evaluated on a daily basis.
Lines 1-30 are commented, and are used to calculate the shift, using as input the tif files for the tetraspec bead in the 488nm channel and 642nm. The code calculates the shift in X and Y direction (dx and dy).

### 3. Apply the lateral shift

Lines 32-54 allow to apply the shift to all images in thefolder, and save the un-shifted files in a in a different folder. One needs to input the folder *Ex* to be corrected (translated by dx and dy). For this procedure one needs to run the script as a funcion.

### 4. Apply chromatic offset, flat field correction and deskew

Run `currentDeskew_20210622.m`, inserting the experiment number manually.
