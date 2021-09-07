
%{

First get the metadata of how many stacks are taken and the channels
For each stack in the file, organize it into different folders
Once they are organized into folders, run the DS with the parameters (Illum
correction, camflip etc)


Copy files to a destination folder
Find the illumination files
Find the chromatic offset files

% -------- 10/23/19 -------
First get the deskew input info
locate the LLSM experiment folder and the Destination folder

* start the while loop
(1) find the folder where the acquisition is taking place
(2) get the settings file in that folder, copy and sent it to the dest
(3) get the metadata for the folder, make separated files in the
destination folder
(4) for each file that has yet to be copied to the destination file, copy
the file into the destination folder (ch__nmCam_), make a DS folder, run
deskew with the appropriate inputs (illum, cam offset)
(5) once deskew is done, apply chromatic offset
(6) repeat (4) until it reaches the number of expected stacks
(7) repeat (1) until the experiment is completed. 

%}

clear; clc; close all;
tic

% % Step1 get the metadata
% dirSource = 'Z:\20200924_p5_p55_sCMOS_Gu'; % lattice drive directory
% dirSink = 'V:\Gustavo'; % where you want to store the files

dirSource = 'Z:\20201119_p5_p55_sCMOS_Gu';
dirSink = 'V:\Gustavo';

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
[I] = AutoDS_getTif(dirSource); % I.dir, I.tif
S.I = I;
% S.C = C;
% S.PSF = Tot;

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
ExNum = 1;
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
