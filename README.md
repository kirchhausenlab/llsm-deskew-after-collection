# llsm - Deskew after collection

## Pos-processing to fix lateral offset between 488nm and 642nm channels

Briefly, although 488nm (green) and 642nm (red) images are being recordedin the same camera, there is a lateral offset between this two channels.

To adjust this shift, we use a matlab code called image_translate.m (wrote byGiuseppe), where we input the tif files for the tetraspec bead in the 488nm channel and 642nm. The code calculates the shift in X and Y direction (dx and dy).

Then, you input the folder of the Ex to be corrected (translated by dx and dy).
