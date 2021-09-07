% deskew selected files

clear; clc; close all;

folder = '/net/10.117.38.184/scratch/Gokul/GU_PrivateRepository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/Gokul/GU_Repository';
addpath(genpath(folder));

folder = '/net/10.117.38.184/scratch/George/MATLAB_Files';
addpath(genpath(folder));


% find the name of the computer
[ret, name] = system('hostname');

if regexp(name, 'tkv1')
    c = 1;
elseif regexp(name, 'tkv2')
    c = 2;
elseif regexp(name, 'tkv3')
    c = 3;
elseif regexp(name, 'tkv4')
    c = 4;
elseif regexp(name, 'tkv5')
    c = 5;
elseif regexp(name, 'tkv6')
    c = 6;
elseif regexp(name, 'tkv7')
    c = 7;
elseif regexp(name, 'tkv8')
    c = 8;
end

% ExCheck = ones(1,100);
% for ii = 2:length(ExCheck)
%     ExCheck(ii) = c + 8*(ii-1);
% end
% 
% ExCheck

%% find the latest Ex folder in scratch

sinkFol = '/net/10.117.38.184/scratch/Alex/20200917_p5_p55_sCMOS_Alex';
d = dir(sinkFol);
% [acqFol] = findAcquistionFolder(ExNum,dirSource, foundAcq);

%%
% find which Ex to Deskew
while true
    % find which Ex
    ExCheck = c;
    
    % get the directory of the ExFolder
    str = sprintf('Ex%02d_',ExCheck);
    fprintf('%s finding where Ex%2d is taking place...\n',name, ExCheck)
    while true
        acqFolder = [sinkFol filesep '**' filesep str '*'];
        d = dir(acqFolder);
        if ~isempty(d)
            fprintf('%s Ex%2d Found...\n',name, ExCheck)
            deskewFolder = [d(1).folder filesep d(1).name];
            break
        else
            fprintf('%s Wait 60 sec...\n',name, ExCheck)
        end
        pause(60)
    end
    
    % get the metadata
    Meta = AutoDS_readtxt_temp(deskewFolder);

    
    % wait until the next folder is found
    str = sprintf('Ex%02d_',ExCheck+1);
    fprintf('%s finding where Ex%2d is taking place...\n',name, ExCheck+1)
    while true
        acqFolderr = [sinkFol filesep '**' filesep str '*'];
        d = dir(acqFolderr);
        if ~isempty(d)
            fprintf('%s Ex%2d Found, Deskew Ex%2d...\n',name, ExCheck+1, ExCheck)
            break
        else
            fprintf('%s Wait 60 sec...\n',name, ExCheck+1)
        end
        pause(60)
    end
    
   
    
    % run the deskew
    runDS(deskewFolder,Meta)
    
    % Update which folder to find
    ExCheck = c + 8;
end
