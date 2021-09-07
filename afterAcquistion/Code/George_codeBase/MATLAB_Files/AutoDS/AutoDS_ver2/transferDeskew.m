%
%{
*For each Ex folder,
*find the tif images, add them to a queue
* if image transferred already, skip
* elseif image is not transferred
** check that >1 tif
** transfer until 1 tif left in that Ex folder, check that the last iamge
N_planes is expected, 
if expected, then transfer
else leave in the queue

once one interation of transfer is complete, move on to deskew
*in the sink folder, add every tif in the queue
* if no DS folder, create one and deskew all
* if exist DS folder, then do a match and desew what is not there

* if deskewed, check if tif file has the name ex00_OffsetApplied_blah_blah
if offsetAllied is there, then do not apply chromatic offset. 
else, apply offset to the tif that


 the DS folder, deskew the images one by one


---------------- OPTIMIZATION -------
INSTEAD OF QUEUING UP THE TIF, CHECK THE LAST ITER AND STACK THAT WERE
TRANSFERRED. ITER_N_ AND STACK_M_. CONTINUE QUEUING THE TIF FROM ITER_N+1_
AND STACK_M+1_. 

%}



function transferDeskew(dirSource, dirSink, I, B, C, transfer_flag, deskew_flag)
% global dirSource
% global dirSink
% global I
% global B
% global C
% global transfer_flag
% global deskew_flag
tic;

disp('Starting Automatic Transfer and Preprocessing...');

carriedTifs = {};

while true
    % find the Ex_directories
    if transfer_flag
%         carriedTifs = transfer(dirSource, dirSink, carriedTifs);
        transfer(dirSource, dirSink, carriedTifs)
    end
    if deskew_flag
        deskew( dirSink, I, B)    
    end
    
end


end


% function carriedTifs = transfer(dirSource, dirSink,carriedTifs)
function transfer(dirSource, dirSink,carriedTifs)

Ex_folders = findKeywordDFS(dirSource, 'Ex');

% ------- TRANSFER SETTINGS FILE ---------
%
% Transfer if settings file does not exist in the Ex folder

disp('Check if Settings file has been transferred...');

for ii = 1:length(Ex_folders)
    Ex_folder = Ex_folders{ii};
    d = dir([char(Ex_folder) filesep '*Settings.txt']);
    if ~isempty(d)
        
        % copy txt file
        slash_idx = regexp(dirSink, filesep);
        acq_folder = dirSink(slash_idx(end-1)+1:end);
        
        folder_idx = regexp(d.folder, acq_folder);
        fullsinkFol = d.folder(folder_idx:end);
        
        sinkFolSlashIdx = regexp(fullsinkFol, filesep);
        trimSinkFol = fullsinkFol(sinkFolSlashIdx(1):end);
        
        % check if it has been tranferred
        Sink_SettingsFile = [dirSink filesep trimSinkFol filesep d.name];
        
        if ~exist(Sink_SettingsFile,'file')
            
            if ~exist( [dirSink filesep trimSinkFol], 'dir')
                mkdir( [dirSink filesep trimSinkFol]);
            end
            
            copyfile([d.folder filesep d.name], [dirSink filesep trimSinkFol]);
            fprintf("Settings file transfered from %s\n\t to %s\n", [d.folder filesep d.name], [dirSink filesep trimSinkFol]);
            
        end
    end %%
    
end


disp('Settings file transfer complete');
disp(1);

% ------------ QUEUE TIF IMAGES -----------
Tifs = carriedTifs;
% go over each Ex and make a queue of the chars
for ii = 1:length(Ex_folders)
    % get the Ex folder
    Ex_folder = Ex_folders{ii};
    
    % dont deskew settings file images -- you can change this
    if isempty(regexpi(char(Ex_folder),'LLSCalib'))

        d = dir([char(Ex_folder) filesep '*.tif']);
        if ~isempty(d)
            Temp_tif = cell(length(d), 1);
            for jj = 1:length(Temp_tif)
                Temp_tif{jj} = {[d(jj).folder filesep d(jj).name]};
            end
            
            Tifs = [Tifs ; Temp_tif];
        end
    end
end

disp('All Tif images queued');

% ----CHECK IF TIF WAS TRANSFERRED, IF NOT, TRANSFER TIF  ------
carry_Tifs = {};

if ~isempty(Tifs)
fol_marker = char(Tifs{1});
slash_idx_dirSink = regexp(dirSink, filesep);
slash_idx = regexp(char(Tifs{1}), filesep);
cur_dir = fol_marker(1:slash_idx(end));

for ii = 1:length(Tifs)
    
    if ii ~= length(Tifs)
        cur_dir_idx = regexp(cur_dir, dirSink(slash_idx_dirSink(end-1):end));
        new_dir = [dirSink(1:slash_idx_dirSink(end-1)) filesep cur_dir(cur_dir_idx(end):end)];
        
        if regexp(char(Tifs{ii+1}), cur_dir) % if in the same directory, copy to sink
            
            % get the parent folder
           if ~exist(new_dir,'dir')
                mkdir(new_dir);
            end
            
            
            transfer_tif = check_transfer_tif(Tifs{ii},  new_dir);

            
            if transfer_tif
               
                copyfile(char(Tifs{ii}), new_dir);
                fprintf("Transfered %s to \n\t%s\n", char(Tifs{ii}), new_dir);
            else
                continue;
            end
          
        else
            % last stack. Check that the stack makes sense
            
            % get metadata
            Meta = getMeta2({cur_dir});
            [~,~,zplane] = size(readtiff(char(Tifs{ii})));
            if zplane == Meta.planes
                if check_transfer_tif(Tifs{ii},  new_dir)
                    copyfile(char(Tifs{ii}), new_dir);
                    fprintf("Transfered %s to \n\t%s\n", char(Tifs{ii}), new_dir);
                    %                 else
                    %                     continue;
                end
            else
                carry_Tifs = {carry_Tifs; Tifs{ii}};
            end
            
            if  ii ~= length(Tifs) || ii +1 ~= length(Tifs)
                fol_marker = char(Tifs{ii+1});
                slash_idx = regexp(char(Tifs{ii+1}), filesep);
                cur_dir = fol_marker(1:slash_idx(end));
            end
            disp(3)
        end
    else
        % get metadata
        Meta = getMeta2({cur_dir});
        [~,~,zplane] = size(readtiff(char(Tifs{ii})));
        if zplane == Meta.planes
            if check_transfer_tif(Tifs{ii},  new_dir)
                copyfile(char(Tifs{ii}), new_dir);
                fprintf("Transfered %s to \n\t%s\n", char(Tifs{ii}), new_dir);
%             else 
%                 continue;
            end
        else
%             carry_Tifs = {carryTifs; Tifs{ii}};
        end
    end
    
end
end
carry_Tifs;
disp('All Tif has been transferred')

disp('Pause for 1 min....');
pause(60);
toc;


end

function deskew(dirSink, I, B)

deskewTif = {};

Ex_folders = findKeywordDFS(dirSink, 'Ex');

%check if zplane info is correct
add_splane_FolName2(Ex_folders)

% PART 1
% transfer the tif into its approproate channel
% Use the deskew


% PART 2
% for each Tif, Transferred Tif, make them into a queue
% for each tif, trasfer them into the appropriate ch-folder.
% when the tif is transferred, deskew that tif

Ex_folders = findKeywordDFS(dirSink, 'Ex');
addChannels(Ex_folders)
chdir= getChdir(Ex_folders);
% change the tifname if iter1 to iter001
changeIter(chdir)

Ex_folders = findKeywordDFS(dirSink, 'Ex');
for ii = 1:length(Ex_folders)
    Ex_folder = Ex_folders{ii};
    % check if 3D acquisition
    if ~check3D(Ex_folder)
        disp('Acq is not 3D');
        continue;
    end
  
    % check if DS already run
    if DSCheck(Ex_folder)
        
        % get the data strcutre
        [data] = AutoGU_loadConditionData3D(Ex_folder);
        deskewData(data,...
            'sCMOSCameraFlip', false,... % Is there camera flip? sample moving left-right, then false. Up-down then true
            'Overwrite', false,... % usually false, want to overwrite the previous data?
            'crop', false,... % used to limit the FOV from original size to the cropped size
            'LLFFCorrection', I.doIllum,...
            'LSImageChannels',I,... % illum correction structure
            'BkImageChannels', B) % background correction structure); % lattice light flat field correction (aka illumination correction)
        
    end
end


disp(2)

end
function  transfer_tif = check_transfer_tif(Tifs,  new_dir)

% Check that the file has yet to be transferred
% if no file in the newdir
Source_tifdir = char(Tifs);
tif_name_idx = regexpi(Source_tifdir, filesep);
tif_name = Source_tifdir(tif_name_idx(end)+1:end);
Sink_raw_Tifdir = [new_dir filesep tif_name ];

% if no tif files in the ch folder
% check channel and cam

cam = regexpi(tif_name, 'Cam(\w)', 'match');
ch = regexpi(tif_name, '(\d+)?nm', 'match');
chanName = ['ch' char(ch{1}) char(cam{1})];
Sink_chan_Tifdir = [new_dir filesep chanName filesep tif_name];

if ~exist(Sink_raw_Tifdir,'file') &&  ~exist(Sink_chan_Tifdir,'file')
    transfer_tif = true;
else
    transfer_tif = false;
end


end

function transfer2(dirSource, dirSink,carriedTifs)


end




function bool = DSCheck(Ex_folder)

bool = true;
end