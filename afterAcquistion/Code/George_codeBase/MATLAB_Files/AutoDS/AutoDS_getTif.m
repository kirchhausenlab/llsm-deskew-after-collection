% Get the directory of where illumination, chromatic offset, and total
% PSFs. Also get the name (.tif).
%
% struct .tif
% struct .dir 

function [I,C,PSF] = AutoDS_getTif(folSink)

% find the LLSCalibration folder
d = getdir(folSink);
for ii = 1:length(d)
    marker = regexp(d(ii).name, 'LLSCalib', 'once');
    folCalib = d(ii).name;
    if (~isempty(marker))
        break
    end
end

folCalib = 'noDichroics\LLSCalibrations';
% ------------ finding illum files -----------------

dirCalib = [folSink filesep folCalib];
dcalib = getdir(dirCalib);
marker = 0;
for ii = 1:length(dcalib)
    marker = regexp(dcalib(ii).name, 'illum', 'once');
    folIllum = dcalib(ii).name;
    if (~isempty(marker))
        break
    end
end
dirIllum = [dirCalib filesep folIllum filesep '*.tif'];
dIllum = dir(dirIllum);
I.dir = dIllum(1).folder;

%%% Original %%%%%%%%%%%%%%%%%%

marker =0;
counter = 1;
for ii = 1:length(dIllum)
    marker = regexp(dIllum(ii).name, '.tif', 'once');
    if (~isempty(marker))
        I.tif{counter,1} = dIllum(ii).name;
        counter = counter + 1;
    end
end

%%% lnigirO %%%%%%%%%%%%%%%%%%

% % % % % %%%%%%% Modified, find illumination file for each channel%%%%
% % % % % Cam = {'CamA','CamB'};
% % % % % Chan = {'405','488','560','592','642'};
% % % % % I.chan = cell(length(Cam), length(Chan));
% % % % % for kk = 1:length(dIllum)
% % % % %     Illum = dIllum(kk).name;
% % % % %     for ii = 1:length(Cam)
% % % % %         for jj = 1:length(Chan)
% % % % %             expr_cam =  ['_' char(Cam(ii)) '_'];
% % % % %             expr_chan =  ['_' char(Chan(jj)) 'nm_'];
% % % % %             flag_cam = regexpi(Illum, expr_cam);
% % % % %             flag_chan = regexpi(Illum, expr_chan);
% % % % %             
% % % % %             if ~isempty(flag_cam) && ~isempty(flag_chan)
% % % % %                 I.chan{ii,jj} = Illum;
% % % % %             end
% % % % %             
% % % % %         end
% % % % %     end
% % % % %     
% % % % % end
% % % % % 
% % % % % %%%%%%% lnnahc hcae rof elif noitanimulli dnif ,deifidoM %%%%


% % % % % % % % % ------------ finding chroma files -----------------
% % % % % % % % marker = 0;
% % % % % % % % for ii = 1:length(dcalib)
% % % % % % % %     marker = regexp(dcalib(ii).name, 'chroma', 'once');
% % % % % % % %     folChroma = dcalib(ii).name;
% % % % % % % %     if (~isempty(marker))
% % % % % % % %         break
% % % % % % % %     end
% % % % % % % % end
% % % % % % % % 
% % % % % % % % dirChroma = [dirCalib filesep folChroma];
% % % % % % % % dChroma = getdir(dirChroma);
% % % % % % % % 
% % % % % % % % % 1. check if there are files in the directory.
% % % % % % % % %   If no files found file, choose a folder that has the chromatic offsets
% % % % % % % % % 2. If there are folders (Ex00_lambda_z0p2), check that the annotations
% % % % % % % % % are correct
% % % % % % % % % 3. T
% % % % % % % % % check if it is directory, and check if there is a DS already done
% % % % % % % % % if not done, Deskew the image, crop the image and save
% % % % % % % % 
% % % % % % % % % if isempty(dChroma)
% % % % % % % % %     % choose a file for chromatic offset
% % % % % % % % %     chromDir = uigetdir(pwd, 'No files found in LLSCalib/Chroma. Choose a folder to base the chroma offset:');
% % % % % % % % %     if ~chromDir
% % % % % % % % %         disp('No chromatic offset folders selected. CO will not be applied.');
% % % % % % % % %     end
% % % % % % % % %     
% % % % % % % % % else % if there are files in dChroma
% % % % % % % % %     
% % % % % % % % %     % Organize the folders into channels
% % % % % % % % %     Chroma_Ex_folders = findKeywordDFS(
% % % % % % % % %     %
% % % % % % % % %     
% % % % % % % % % end
% % % % % % % % 
% % % % % % % % 
% % % % % % % % 
% % % % % % % % 
% % % % % % % % marker =0;
% % % % % % % % counter = 1;
% % % % % % % % for ii = 1:length(dChroma)
% % % % % % % %     marker = regexp(dChroma(ii).name, '.tif', 'once');
% % % % % % % %     if (~isempty(marker))
% % % % % % % %         C.tif{counter,1} = dChroma(ii).name;
% % % % % % % %         counter = counter + 1;
% % % % % % % %     end
% % % % % % % % end
% % % % % % % % C.dir = dChroma(1).folder;
% % % % % % % % % ------------ finding totalPSF files -----------------
% % % % % % % % 
% % % % % % % % marker =0;
% % % % % % % % counter = 1;
% % % % % % % % for ii = 1:length(dcalib)
% % % % % % % %     marker = regexp(dcalib(ii).name, 'totalPSF.tif', 'once');
% % % % % % % %     if (~isempty(marker))
% % % % % % % %         PSF.tif{counter,1} = dcalib(ii).name;
% % % % % % % %         counter = counter + 1;
% % % % % % % %     end
% % % % % % % % end
% % % % % % % % PSF.dir = dcalib(1).folder;
% % % % % % % % 
% % % % % % % % str = timeStr;
% % % % % % % % fprintf('%s \t illum, chroma, totalPSF tif loaded\n',str);

end
