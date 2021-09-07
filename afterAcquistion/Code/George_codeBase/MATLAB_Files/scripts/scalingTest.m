% scaling tests

clear;clc;
% load('/net/tkfastfs/scratch/George/Slurm/CheckParfor/20200918_p5_p55_sCMOS_Alex/CS1_VSV_P_Halo-JF646-COV2-Vero/Ex02_642_300mW_z0p5/ex02_linux.mat');
%%

data1 = GU_loadConditionData3D;
data2 = GU_loadConditionData3D;
data3 = GU_loadConditionData3D;
data4 = GU_loadConditionData3D;
data5 = GU_loadConditionData3D;
data6 = GU_loadConditionData3D;
data7 = GU_loadConditionData3D;
data8 = GU_loadConditionData3D;
data9 = GU_loadConditionData3D;

data = [data1, data2 data3 data4 data5 data6 data7 data8 data9];

%%
clc
illumRt = '/net/tkfastfs/scratch/Alex/20201023_p5_p55_sCMOS_Alex/LLSCalibrations/illum';
illum488CamA = 'i_CamA_ch0_stack0000_488nm_0000000msec_0000262042msecAbs.tif';
illum560CamB = 'i_CamA_ch2_stack0000_642nm_0000000msec_0000262042msecAbs.tif';
illum642CamA ='i_CamB_ch1_stack0000_560nm_0000000msec_0000262042msecAbs.tif';
p = parcluster(); % should be using SlurmProfile_config
p
workers = [1,2,5,10,20,50,100,200,384];
time = zeros(length(workers), 10);
c =1;
camflip=false;
for w = 1:length(workers)
    delete(gcp('nocreate'));
    p = parcluster;
    parpool(workers(w))
    for ii = 1:10
        t = tic;
        disp('488')
        deskewData(data(w),...
            'sCMOSCameraFlip', camflip,... % Is there camera flip? sample moving left-right, then false. Up-down then true
            'Overwrite', true,... % usually false, want to overwrite the previous data?
            'crop', false,... % used to limit the FOV from original size to the cropped size
            'LLFFCorrection', true,... % lattice light flat field correction (aka illumination correction)
            'LowerLimit', 0.5,...
            'LSImageCh1', [illumRt,filesep illum488CamA],...
            'BackgroundCh1', '/scratch/Wesley/Ex01_sCMOSdarkCurrent_z0p1/avgCamADC.tif')
        time(c,ii) = toc(t);
    end
    c = c+1;
end



