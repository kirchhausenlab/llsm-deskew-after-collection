%{
* Input source and sink
* Fron the source, find the LLSMCalibration file
# From the source, find the illumination correction file
% ** Fron the source, find the dark current file
% From the source, find the chromatic offset file
%   If the chromatic offset is a sample scan, check if it needs to be
deskewed
%   If the chromatic offset ROI after DS is too big, crop the ROIs, and
save the tif


PLEASE ORGANIZE YOUR FOLDER AS FOLLOWS

|-LLSM D:
||-"Date_Mask_Camera_Biologist" ex. 20201112_p5_p55_sCMOS_Gustavo
|||-LLSCalibrations
||||-illum
||||-chroma
||||-darkCurrent
||||-lambdaXZPSF
|||-CS1_SampleName
||||-Ex01_lambdai_poweri_planePix ex. Ex01_488_30mW_560_642_mW_z0p2

%}

clear; clc; close all;
tic

% % Step1 get the metadata
% dirSource = 'Z:\20200924_p5_p55_sCMOS_Gu'; % lattice drive directory
% dirSink = 'V:\Gustavo'; % where you want to store the files

dirSource = 'Z:\20201113_p5_p55_sCMOS_Alex';
dirSink = 'V:\Alex';

% Copy the LLSCalibration folder to the sink
copyLLSCalib(dirsource,dirSink)

% get the illumination correction folder


%%



% want illum Correction?
S.illum = true;

% Copy source folder into the sink folder
%  This usually include everything but the acquisiton files, the
%  LLSCalibration folder
folSink = AutoDS_copyFiles(dirSource,dirSink);
makeLogFile(dirSink);

% deskew the chromatic offset beads
% deskewChroma(dirSink)

% Load the illumination, chromatic offset, total PSF info
[I,C,Tot] = AutoDS_getTif(folSink); % I.dir, I.tif
S.I = I;
S.C = C;
S.PSF = Tot;

if S.illum % if you want illumination correction
    for ii = 1:length(S.I.tif)
         LSIm = readtiff([S.I.dir, filesep, S.I.tif{ii}]);
         S.I.LSIm{ii} = LSIm;
    end
    
end
toc

% delete(gcp('nocreate'))
% myPool = parpool(11);
%%
% find where the acquistion is taking place, copy the folder into the sink.
%   regexp(data_p5_p55_biologist_

% c function find_acquisition place
% c fundtion find_settings file
% c function get metadata

% function transfer files
% function start DS


%  KGO_AUTODS_20191023b(dirSource, folSink, S)
% Find Files with "ExNN_"
ExNum = 35;
KGO_AUTODS_20191104(dirSource, folSink, S, ExNum)


toc

%%
% \\-------------------------------------------------------------------\\



% 
% 
% % Get metadata for each experiments; Needs to be run for each Exp
% Meta = AutoDS_readtxt(dirSource);
% Meta.waitTime = 0;
% 
% 
% % illumSource = 'V:\George\AutoDS\Samples\LLSCalib\illum';
% % chromaSource = 'V:\George\AutoDS\Samples\LLSCalib\chroma';
% S.dirSource = dirSource;
% S.dirSink = dirSink;
% S.I = I;
% S.C = C;
% S.PSF = Tot;
% S.bkImageFoldersCMOS = 'V:\Wesley\Ex01_sCMOSdarkCurrent_z0p1';
% S.bkImageFolderEMCCD = 'V:\Wesley\2017-05-11_Wesley_EMCCD_darkCurrent\Ex01_10MHz_19p8ms_z0p2';
% S.camFlip = Meta.camflip;
% 
% % step2, organize the files into the folder and
% % make organized folder and the dir of the files sep by channels
% 
% % GU_sort3Dfiles_George_inputOrganize_v3_AutoDS(dirSink,Meta);
% 
% % Copy everything to the destination folder
% 
% % Now organize each tif into the folder and run DS
% numStacks = Meta.stacks * numel(Meta.chan);
% 
% % move the files to the right destination and start the DS for the one that
% % was moved. 
% 
% AutoDS_20191021(Meta,S)
