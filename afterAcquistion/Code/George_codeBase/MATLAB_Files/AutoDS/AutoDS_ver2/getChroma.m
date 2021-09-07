% V:\George\Test_AutoDS\20201117_p5_p55_sCMOS_Gu\LLSCalibrations\chroma

% /net/tkfastfs/scratch/George/MATLAB_Files/AutoDS/AutoDS_ver2
function C = getChroma(dirSink, bool_doChroma)
bool_crop = false;
Cam = {'CamA','CamB'};
Chan = {'405','445','488','514','560','592','607','642'};
C.chan = cell(length(Cam), length(Chan));
C.doChroma = bool_doChroma;

keyword = 'chroma';
C_dir = findKeywordDFS(dirSink, keyword);
counter = 1;

getC = true;
while isempty(C_dir)
    % choose a file for chromatic offset
    fprintf('dirSource: %s,\nkeyword: %s\n not found. Select the folder of interest\n', dirSink, keyword)
    
    C_dir = uigetdir(dirSink);
    if ~C_dir
        disp('No Chromatic Offset folders selected. Select again.\nOtherwise you can do this later by hand');
    end
    counter = counter + 1;
    if counter > 2
        C.doChroma = false;
        break;
    end
end




%%%%%%% chromatic offset dir is found, check if deskew is needed
if C.doChroma
    % get the Ex folders
    C_dir_char = char(C_dir{1});
    Exs =  findKeywordDFS(C_dir_char, 'Ex');
    
    % check if image is 3D
    check3Dacquisition(Exs)
    Ex_directories_temp =  findKeywordDFS(C_dir_char, 'Ex');
    
    
    % Add/Edit s-plane info if you missed
%     add_splane_FolName2(Ex_directories_temp)
    Ex_directories = findExDFS(C_dir_char);
    
    % Organize into ch
    addChannels(Ex_directories)
    
    % for each Ex folders, do the deskew without the illumination
    % Correction
    for ii = 1:length(Ex_directories)
        Ex = Ex_directories{ii};
        
        if regexpi(char(Ex), 'chroma')
            
            
            % load data structure for DS input
           data = AutoGU_loadConditionData3D(Ex);
            disp(1)
            C.ds = data.dz;
            % deskew the Ex
%             satisfied = 0;
            satisfied = input('Do you want to deskew?(yes=0, no=1): ');
            while ~(satisfied == 1)
                
                deskewData(data,...
                    'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
                    'Overwrite', true,... % usually false, want to overwrite the previous data?
                    'crop', bool_crop,... % used to limit the FOV from original size to the cropped size
                    'LLFFCorrection',  false,...
                    'Crop', true);
                %             end
                
                % check the image and crop
                checkIm = readtiff(char(data.framePathsDS{1}{1}));
                imagesc(imtile(checkIm(:,:,1:end)))
                disp('*********************************');
                disp('Please check the deskewed image. Check that you only see one bead');
                fprintf('One frame of DSed image has row: %dpix, col: %dpix\n',size(checkIm,1), size(checkIm,2))
                disp('Frame is moving from left to right, up to down');
                disp('You should only see one PSF in the image, othewise, run the current code again and crop');
                disp('*********************************')
                checkNumFramesChroma(data, Ex, C)
                satisfied = input('If the montage image and the number of frames looks good, type "1", to repeat, type "0": ');
            end
            % check number of frames to be added if chromatic offset is
            % computed
            
            
            
        end
        C.dir = Ex;
        for kk = 1:length(data.framePathsDS)
            dir_Chroma = data.framePathsDS{kk};
            for ll = 1:length(Cam)
%                 for jj = 1:length(Chan)
%                     expr_cam =  ['_' char(Cam(ll)) '_'];
%                     expr_chan =  ['_' char(Chan(jj)) 'nm_'];
%                     flag_cam = regexpi(char(dir_Chroma{1}), expr_cam);
%                     flag_chan = regexpi(char(dir_Chroma{1}), expr_chan);
%                     flag_cam = 1;
%                     if ~isempty(flag_cam) && ~isempty(flag_chan)
%                         C.chan{ll,jj} = dir_Chroma{1};
%                     end
%                     
%                 end



                 for jj = 1:length(Chan)
                    expr_cam =  ['_' char(Cam(ll)) '_'];
                    expr_chan =  ['_' char(Chan(jj)) 'nm_'];
                   
                    flag_cam = regexpi(char(dir_Chroma{1}), expr_cam);
                    if isempty(flag_cam) && ll == 1 && ~regexpi(char(dir_Chroma{1}), '_CamB_')
                        flag_cam = 1;
                    end
                    flag_chan = regexpi(char(dir_Chroma{1}), expr_chan);
                    if ~isempty(flag_cam) && ~isempty(flag_chan)
%                     if ~isempty(flag_chan)
                        C.chan{ll,jj} = dir_Chroma{1};
                    end
                    
                end

            end
            
        end
        
    end
    
    disp('Chromatic offset bead Deskewed and info are loaded')
    disp('Chomatic offset complete!')
    
    

end

    
    
    
end
function checkNumFramesChroma(data,Ex, ~)
Cam = {'CamA','CamB'};
Chan = {'405','445','488','514','560','592','607','642'};

C.dir = Ex;
for kk = 1:length(data.framePathsDS)
    dir_Chroma = data.framePathsDS{kk};
    for ll = 1:length(Cam)
        for jj = 1:length(Chan)
            expr_cam =  ['_' char(Cam(ll)) '_'];
            expr_chan =  ['_' char(Chan(jj)) 'nm_'];
            flag_cam = regexpi(char(dir_Chroma{1}), expr_cam);
            if isempty(flag_cam)
                flag_cam =1;
            end
            flag_chan = regexpi(char(dir_Chroma{1}), expr_chan);
            
            if ~isempty(flag_cam) && ~isempty(flag_chan)
                C.chan{ll,jj} = dir_Chroma{1};
            end
            
        end
    end
    
end




end


