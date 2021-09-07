% make LLSM table from acquired images

% example (NUP Paper)
% https://docs.google.com/spreadsheets/d/1kqab9kVX5Li44cw3JqCJWc48982sXFkMINOHO8nuZXY/edit#gid=61518901

%% input the folder directory
clear; clc; close all;


T = initializeTable(); % output, cell 

d = '/Volumes/scratch/Gustavo/20201022_P5_P55_sCMOS_Gu';

%% get camera type

exp = {'scmos'};
c = regexpi(d, exp);
if ~isempty(c{:})
    disp('sCMOS')
else 
    disp('EMCCD');
end

    
