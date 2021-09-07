function BKImage = getBKImage(Meta, c)
cam = Meta.camSave(:,c);
idx = find(cam == 1);
disp("Selecting BKIm");
if (idx == 1)
fprintf("Found ch%d, cameraA\n", Meta.chan(c));

    BKImage = 'V:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif';
elseif (idx == 2)
fprintf("Found ch%d, cameraB\n", Meta.chan(c));

    BKImage = 'V:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamBDC.tif';
    
else
        fprintf("camera Not A or B. BK image for Cam A used\n");

    BKImage = 'V:\Wesley\Ex01_sCMOSdarkCurrent_z0p1\avgCamADC.tif';
    
    
end


end
