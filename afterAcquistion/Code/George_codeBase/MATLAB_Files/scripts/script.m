clear; clc; close all;

% for all folders
% locate DS folders
% locate folders with keywords "ExNM"
% find the size of each tiff file.

% directory
directory = 'Y:\datasync3';
keyword = 'Ex';
S = findAllsubFoldersKeyword(directory, keyword);

% output should have 


% 
% 
% % load all the subfolders
% d = dir('Y:\datasync3');
% dd = d([d(:).isdir]);
% dd = dd(~ismember({dd(:).name},{'.','..'}));
% % 
% 
% % structure containing all the Ex folders
% ExFolders = struct;
% DSFolders = struct;
% 
% % for each folder locate the subfolders, check if it has ExNM extention
% ExFolders = findAllExFolders(dd)


