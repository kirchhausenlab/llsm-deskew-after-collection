
% COde to run the DS
% (1) find where the acquistion is taking place by Ex__. Locate this folder
% (2) find the setting file in that folder. Update metdata, make it into a
% textfile
% (3) make an organized folder, ch(lamda)Cam(A or B)
% (4) Transfer data if there is more than (nChan * 2) tifs, to ensure no
% acquisitions that is taking place will be disturbed
% (5) DS the transfered data
% (5) Make a structure to keep in track of which tifs were transfered to
% avoid duplicates
% (6) run until nStack * nChan is reached
% (7) go back to (1)

% keep a log file of all the steps taking place



function KGO_AUTODS_20191023b(dirSource, folSink, S)

ExNum = 1;
foundFol = 0;
foundAcq = 0;
numDSed = 0;
str2 = sprintf('Ex');

A = struct; % Acquisition

while (true)
    % find the acquisiton folder
    [acqFol] = findAcquistionFolder(ExNum,dirSource, foundAcq);
    
    % get Meta data
    Meta = AutoDS_readtxt(acqFol, folSink,ExNum);
    
    
    
    disp('Finding where acquisiton is taking place...');
    str = sprintf('Ex%02d_',ExNum);
    files = dir([dirSource filesep '**\' str '*']);
    
    if (~isempty(files) && foundFol == 0)
        str_time = timeStr;
        fprintf('%s \t %s found %s \n',str_time, str, files(1).folder);
        % copy settings file to the sink
        acqFol=[files(1).folder filesep files(1).name];
        % get Metadata
        fprintf('Searching for txt file for %s\n', str);
        Meta = AutoDS_readtxt(acqFol, folSink);
        foundFol = 1;
    end
    
    % copy the existing tiff into the sink, organiza the location by ch
    % if the first stack, wait until stack i+1.
    % if the last stack, wait 1.2*acqui_time
    % -----
    % A = struct containing tif transfered files
    
    while (true) 
        A = CopyTifToSink(A, dirAcq, folSink)
    
    
    
    break; % for now, delete when protptype is ready
    if (numDSed == length(Meta.chan) * Meta.stacks)
        disp('All files transfered and DSed');
        break
    end
    % copy directoryFolders into the sink, 
    % make organized folders in the sink
        
    % copy the files into the sink, keep track of what you transfered
    % (structures)
    
    % For copied one, DS and apply chroma offset
    
    
    c = c + 1;
end


end
