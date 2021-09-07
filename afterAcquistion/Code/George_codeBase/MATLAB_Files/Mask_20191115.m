

clear; clc; close all;
% dirr = 'X:\20190130_p5_p55_sCMOS_Kangmin_SUM\CS1_NUP205\TimeSeries\Ex01_560nm_500mW_z2p0_bleach200st\ch560nmCamA\ex01_CamA_ch0_stack0000_560nm_0000000msec_0013418179msecAbs.tif';
dirr = 'Z:\George\NUP_Intensity\20191006_Final\20191115_Mask\NUP205\20190130_CS1_Ex02\tif';
d = dir('Z:\George\NUP_Intensity\20191006_Final\20191115_Mask\NUP205\20190130_CS1_Ex02\tif\*tif');

%%
i=7;
% im = double(readtiff(['X:\20190130_p5_p55_sCMOS_Kangmin_SUM\CS1_NUP205\TimeSeries\Ex01_560nm_500mW_z2p0_bleach200st\ch560nmCamA\DS\\ex01_CamA_ch0_stack0010_560nm_0001050msec_0014419056msecAbs_copy.tif']));
name = 'crop_ex02_Iter_0_CamA_ch0_stack0000_560nm_0000000msec_0015446708msecAbs.tif';
im = double(readtiff([dirr filesep name ]));
m = zeros(size(im));
[mout,~] = manualSegmentationTweakGUI(im,m);
%%
imagesc(mout(:,:,19));
name = d(i).name(1:end-4);
save('crop_ex05ts1_CamA_ch0_stack0010_560nm_0000000msec_0032896700msecAbs')



%%

frames = zeros(1,size(mout,3));

for ii = 1:(size(mout,3))
            frames(1,ii) = ii;

    if max(max(mout(:,:,ii))) == 1
        frames(2,ii) = 1;
    end
end
M = struct;
cc = 1;
for jj = 1:(size(mout,3))
    if frames(2,jj) == 1
       M(cc).mout_squeeze = mout(:,:,jj);
       M(cc).frameNum = jj;
       M(cc).original_frames = frames;
       cc = cc +1;

    end
end
disp('ran');
