
% BK
BKImage = {'/scratch/George/George_AutoDS_SampleData/LLSCalibrations/bk/bk_CamA_ch0_stack0000_592nm_0000000msec_0000959545msecAbs.tif';...
    '/scratch/George/George_AutoDS_SampleData/LLSCalibrations/bk/bk_CamB_ch0_stack0000_592nm_0000000msec_0000959545msecAbs.tif'};
BKImage_new = {'/scratch/George/George_AutoDS_SampleData/LLSCalibrations/bk/bk_CamA_AV_ch0_stack0000_592nm_0000000msec_0000959545msecAbs.tif';... 
    '/scratch/George/George_AutoDS_SampleData/LLSCalibrations/bk/bk_CamB_AV_ch0_stack0000_592nm_0000000msec_0000959545msecAbs.tif'};
for c = 1:2
    BKIm = readtiff(BKImage{c});

    ds = squeeze(mean(BKIm,3));
    
    writetiff(single(ds), [BKImage_new{c}])
end

%% Illum

BKImage = {'/scratch/George/George_AutoDS_SampleData/LLSCalibrations/illum/nB_dither/nB_CamA_ch0_stack0000_488nm_0000000msec_0491563603msecAbs.tif';...
    '/scratch/George/George_AutoDS_SampleData/LLSCalibrations/illum/nB_dither/nB_CamA_ch1_stack0000_560nm_0000000msec_0491563603msecAbs.tif'};
BKImage_new = {'/scratch/George/George_AutoDS_SampleData/LLSCalibrations/illum/nB_dither/nB_CamA_AV_ch0_stack0000_488nm_0000000msec_0491563603msecAbs.tif';... 
    '/scratch/George/George_AutoDS_SampleData/LLSCalibrations/illum/nB_dither/nB_CamA_AV_ch1_stack0000_560nm_0000000msec_0491563603msecAbs.tif'};
for c = 1:2
    BKIm = readtiff(BKImage{c});

    ds = squeeze(mean(BKIm,3));
    
    writetiff(single(ds), [BKImage_new{c}])
end