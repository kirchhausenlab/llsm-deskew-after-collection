%% Check illumination correction run time
clear
clc 
close all

tifDir = '/scratch/George/George_AutoDS_SampleData/LLSCalibrations/illum/nB_dither';
raw = 'nB_CamA_ch0_stack0000_488nm_0000000msec_0491563603msecAbs.tif';
av = 'nB_CamA_AV_ch0_stack0000_488nm_0000000msec_0491563603msecAbs.tif';
n= 100;

time_raw = zeros(1,n);
time_av = zeros(1,n);

for ii = 1:n
    t = tic;
    readtiff([tifDir filesep raw]);
    t2 = toc(t);
    time_raw(ii) = t2;
    
    t3 = tic;
    readtiff([tifDir filesep av]);
    t4 = toc(t3);
    time_av(ii) = t4;
    
end
disp(1)

%
mean(time_raw) % 4s
mean(time_av) % 0.07s



%% Chromatic offset



