
%{

First get the metadata of how many stacks are taken and the channels
For each stack in the file, organize it into different folders
Once they are organized into folders, run the DS with the parameters (Illum
correction, camflip etc)






%}

clear; clc; close all;
% Step1 get the metadata
dirSource = 'V:\George\AutoDS\Samples\Ex18_488_300mW_560_500mW_z0p4_te197ms';
dirSink = 'V:\George\AutoDS\Samples';


illumSource = 'V:\George\AutoDS\Samples\LLSCalib\illum';
chromaSource = 'V:\George\AutoDS\Samples\LLSCalib\chroma';
S.dirSource = dirSource;
S.dirSink = dirSink;
S.illum = illumSource;
S.chromaSource = chromaSource;
S.bkImageFoldersCMOS = 'V:\Wesley\Ex01_sCMOSdarkCurrent_z0p1';
S.bkImageFolderEMCCD = 'V:\Wesley\2017-05-11_Wesley_EMCCD_darkCurrent\Ex01_10MHz_19p8ms_z0p2';

Meta = AutoDS_readtxt(dirSource);
Meta.waitTime = 0;
S.camFlip = Meta.camflip;

% step2, organize the files into the folder and
% make organized folder and the dir of the files sep by channels

GU_sort3Dfiles_George_inputOrganize_v3_AutoDS(dirSink,Meta);

% Now organize each tif into the folder and run DS
numStacks = Meta.stacks * numel(Meta.chan);

% move the files to the right destination and start the DS for the one that
% was moved. 

AutoDS_20191021(Meta,S)
