
% function carriedTifs = transfer(dirSource, dirSink,carriedTifs)
function transferAcquisition(dirSource, dirSink,keyword)

Ex_folders = findKeywordDFS(dirSource, keyword);


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
        
        folder_idx = regexp(d(1).folder, acq_folder);
        fullsinkFol = d(1).folder(folder_idx:end);
        
        sinkFolSlashIdx = regexp(fullsinkFol, filesep);
        trimSinkFol = fullsinkFol(sinkFolSlashIdx(1):end);
        
        % check if it has been tranferred
        Sink_SettingsFile = [dirSink filesep trimSinkFol filesep d(1).name];
        
        if ~exist(Sink_SettingsFile,'file')
            
            if ~exist( [dirSink filesep trimSinkFol], 'dir')
                mkdir( [dirSink filesep trimSinkFol]);
            end
            
            copyfile([d(1).folder filesep d(1).name], [dirSink filesep trimSinkFol]);
            fprintf("Settings file transfered from %s\n\t to %s\n", [d(1).folder filesep d(1).name], [dirSink filesep trimSinkFol]);
            
        end
    end %%
    
end


pause(1) % pause a second to finish transferring
disp('Settings file transfer complete');
disp(1);

% ------------ QUEUE TIF IMAGES -----------
carriedTifs = {};
Tifs = carriedTifs;

% source folder, queue images
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
% If not the last stack of images, transfer


carry_Tifs = {};

if ~isempty(Tifs)
    fol_marker = char(Tifs{1});
    slash_idx_dirSink = regexp(dirSink, filesep);
    slash_idx = regexp(char(Tifs{1}), filesep);
    cur_dir = fol_marker(1:slash_idx(end));
    Meta = getMeta2({cur_dir});
    Nch = length(Meta.chan);

    
    for ii = 1:length(Tifs)
        cur_dir_idx = regexp(cur_dir, dirSink(slash_idx_dirSink(end-1):end));
        new_dir = [dirSink(1:slash_idx_dirSink(end-1)) filesep cur_dir(cur_dir_idx(end):end)];
        
        % if tif not transferred (char(Tifs{ii}), new_dir)
        tif_idx = max(regexpi(char(Tifs{ii}), filesep));
        TT = char(Tifs{ii});
        tif_name = TT(tif_idx:end);
        
%         exist(
        
        
        % check last set of stack
        if ii ~= length(Tifs) && Nch < length(Tifs)

            
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
                % last set of stacks. Check that the zplane makes sense
                
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
            mark = 1;
            while mark
                Meta = getMeta2({cur_dir});
                [~,~,zplane] = size(readtiff(char(Tifs{ii})));
                if zplane == Meta.planes
                    if check_transfer_tif(Tifs{ii},  new_dir)
                        copyfile(char(Tifs{ii}), new_dir);
                        fprintf("Transfered %s to \n\t%s\n", char(Tifs{ii}), new_dir);
                        mark=0;
                    else
                        mark=0;
                    end
                else
                    secc = ceil(Meta.planes*max(Meta.texp)*length(Meta.chan));
                     fprintf('Waiting %1.2f secs for acquisition\n', secc);
                     pause(secc)
                     
                    %             carry_Tifs = {carryTifs; Tifs{ii}};
                end
            end
        end
        
    end
end
carry_Tifs;
disp('All Tif has been transferred')

% disp('Pause for 1 min....');
% pause(60);
% toc;


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
if isempty(cam)
    cam = {'CamA'};
end
ch = regexpi(tif_name, '(\d+)?nm', 'match');
chanName = ['ch' char(ch{1}) char(cam{1})];
Sink_chan_Tifdir = [new_dir filesep chanName filesep tif_name];

if ~exist(Sink_raw_Tifdir,'file') &&  ~exist(Sink_chan_Tifdir,'file')
    transfer_tif = true;
else
    transfer_tif = false;
end


end