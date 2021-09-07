%{
Check that all files in dirSource is in dirSink
Make sure that the folders are aligned (if we have a text file in a
subfolder, say /CS1_whatever/sometext.txt, then also in dirSink, there should be
/CS1_whatever/sometext.txt

We use depth first search to get this done

%}

function recursivelyDuplicate(dirSource, dirSink_duplicate)

% iterate for all dirSink_duplicate. If there are files not in the sink,
% then transfer
for ii=1:length(dirSink_duplicate)
   currentDirSink = char(dirSink_duplicate{ii});
   copyDFS(dirSource, currentDirSink)
end


end

function copyDFS(dirSource, currentDirSink)

% first check that the subfolder names are the same
assert(checkSubfolderName(dirSource, currentDirSink))

% check all non-folders inside and copy to to the sink
fprintf('\n\nChecking...\n\tSource:\t%s\n\tSink:\t%s\n',dirSource, currentDirSink)
copyFiles(dirSource, currentDirSink)

% recurse into the new folder and repeat and null


end


function copyFiles(dirSource, currentDirSink)

% get the files and check if it is in the folder

% get all files without "." and '..'
d_source = ddir(dirSource);
d_sink = ddir(currentDirSink);

% if the d_source and d_source are not empty
if ~isempty(d_source) || ~isempty(d_sink)
% % convert structure fields into cell array
% cell_source = extractfield(d_source, 'name');
cell_sink = extractfield(d_sink, 'name');

% check if 1. the element is a folder, 2. check if it is in the sink
% if none of the above is true, then transfer to the sink
% if it is a folder, then call copyDFS.

    for ii = 1: length(d_source)
        
        % Check if the elements in d_source is in the sink
        currentSourceDir = [d_source(ii).folder filesep d_source(ii).name];
        
        % if the element (file, folder) is not in the sink
        if ~ismember(d_source(ii).name, cell_sink)
            
            % if it is a folder, then just transfer
            if d_source(ii).isdir
                copyfile(currentSourceDir, currentDirSink)
            else % if it is a file, check if the element is in the ch__nmCam_ folder
                d_sink_chan = ddir([currentDirSink ]);
                
                % keep counter of the number of channels there is in the folder
                numChanInFolder = 0;
                numChanMismatch = 0;
                
                for jj = 1:length(d_sink_chan)
                    
                    % if the file is not in the 'ch(\w+)nm.*(Cam[AB])' folder. Ex.
                    % ch488nmCamA, then transfer. Else do nothing (it is in the
                    % channel folder)
                    parent_candidate_d_sink_chan = d_sink_chan(jj);
                    file_name = d_source(ii).name;
                    
                    % if the current d_sink_chan follows '((?<=/ch)\d+(?=nm))',
                    % then add counter
                    expression = 'ch(\w+)nm.*(Cam[AB])';
                    
                    % if the current folder is a channel folder
                    if ~isempty(regexp(parent_candidate_d_sink_chan.name, expression,'ONCE'))
                        numChanInFolder = numChanInFolder + 1;
                        
                        % check that the files are not in the ch__Cam__ folder
                        if ~checkFileInChCamFolder2(file_name, parent_candidate_d_sink_chan)
                            numChanMismatch = numChanMismatch + 1;
                            
                        end
                    end
                    
                end
                
                % if the file_name is not in any of the ch___nmCam_ folder,
                % then transfer
                if numChanInFolder == numChanMismatch
                    % if it is not in the channel folder, then tranfer to
                    % the sink
                    
                    fprintf('\tCopying:\n\t\tSource: %s\n\t\tSink:\t%s\n', currentSourceDir, currentDirSink)
                    copyfile(currentSourceDir, currentDirSink);
                end
            end
            
        else
            % if the element is a file that is in the sink, just ignore
            
            % if the element is a folder that is in the sink, then check the contents inside the
            % folder
            if d_source(ii).isdir
                nextDirSink = [currentDirSink filesep d_source(ii).name];
                copyDFS(currentSourceDir, nextDirSink)
            end
        end
        
    end
end

end

function bool = checkFileInChCamFolder2(file_name, parent_candidate_d_sink_chan)
d = ddir([parent_candidate_d_sink_chan.folder filesep parent_candidate_d_sink_chan.name]);
allFilesFolders = extractfield(d,'name');


bool = ismember(file_name, allFilesFolders);
% if ~ismember(file_name, allFilesFolders)
%     bool = false;
% else
%     bool = true;
% end


end

function bool = checkFileInChCamFolder(file_name, parent_candidate_d_sink_chan)

%  1. ierate over the subfolders of candidate_d_sink_chan and check if it is the format '((?<=/ch)\d+(?=nm))'
%  2. if the above is true, then check if the file name is inside

% initially set the return value to false
bool = false;

candidate_d_sink_chan = ddir([parent_candidate_d_sink_chan.folder filesep parent_candidate_d_sink_chan.name]);

for ii = 1:length(candidate_d_sink_chan)
    current_candidate_d_sink_chan = candidate_d_sink_chan(ii);
    channelFolderBool = regexp(current_candidate_d_sink_chan.name, 'ch(\w+)nm.*(Cam[AB])','ONCE');
    
    % if the candidate folder is in the '((?<=/ch)\d+(?=nm))' format, then
    % check that the file is inside
    if ~isempty(channelFolderBool)
        current_subfolder_d_sink_chan = ddir([current_candidate_d_sink_chan.folder filesep current_candidate_d_sink_chan.name]);
        
        % iterate over the elements inside the
        % current_subfolder_d_sink_chan, check if the name is the same
        for jj = 1:length(current_subfolder_d_sink_chan)
            if strcmp(current_subfolder_d_sink_chan(jj).name, file_name)
                bool = true;
            end
        end
        
    end
    
end

end




function d = ddir(directory)
d = dir(directory);
d=d(~ismember({d.name},{'.','..'}));

end

function bool = checkSubfolderName(dirSource, currentDirSink)

% condition 1. Check that the extentions are the same
% condition 2. If the name is /raw or /processed, check the sub-subfolder

% first, get rid of the filesep at the end of the name
% ex. whatever/subfolder1/// becomes whatever/subfolder1

dirSource = deleteEndFilesep(dirSource);
currentDirSink = deleteEndFilesep(currentDirSink);

% Check conditon 1. and 2. in this function
try
    checkFolderStructureAlignment(dirSource, currentDirSink)
    bool = true;
catch
    bool = false;
end


end



function checkFolderStructureAlignment(dirSource, currentDirSink)


% find the filesep locations
filesep_loc_dirSource = regexp(dirSource, filesep);
filesep_loc_currentDirSink = regexp(currentDirSink, filesep);

try % condition 1.
    % check that the subfolders have the same name
    assert(strcmp(dirSource(filesep_loc_dirSource(end):end), currentDirSink(filesep_loc_currentDirSink(end):end)))
    
catch
    try % condition 2. 
        % check /raw or /processed
        if strcmp('/processed', currentDirSink(filesep_loc_currentDirSink(end):end)) || strcmp('/raw', currentDirSink(filesep_loc_currentDirSink(end):end)) 
            assert(strcmp(dirSource(filesep_loc_dirSource(end):end), currentDirSink(filesep_loc_currentDirSink(end-1):filesep_loc_currentDirSink(end)-1)))
        else
            assert(false)
        end
    catch
        assert(false)
    end
end

end

function trimmedDir = deleteEndFilesep(rawDir)
while strcmp(filesep, rawDir(end))
    rawDir(end) = '';
end
trimmedDir = rawDir;

end
