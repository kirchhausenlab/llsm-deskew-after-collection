
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

% To dos
% make code to deskew chromatic offset and total PSF before doing regular deskew
%



function KGO_AUTODS_20191104(dirSource, folSink, S, exNum)

ExNum = exNum;
foundFol = 0;
foundAcq = 0;
numDSed = 0;
str2 = sprintf('Ex');

A = struct; % Acquisition

while (true)
    % find the acquisiton folder
    [acqFol] = findAcquistionFolder(ExNum,dirSource, foundAcq);
    
    % get Meta data
    % (1) Find the settings file in that folder
    % (2) Make CS_num_ Folder
    % (3) Make Ex_num_ folder
    % (4) copy settings file to the sink
    % (5) make ch_lamda_Cam_A?B_ folder
    Meta = AutoDS_readtxt(acqFol, folSink,ExNum, dirSource);
    
    % Transfer files to the Sink and start the DS
    % When the function is returned, the DS for the Ex is complete. 
%     copyFilesAndDSToSink(Meta,S);
%      copyFilesAndDSToSink_temp(Meta,S);
     copyFilesAndDSToSink(Meta,S);
     disp(1)
     if length(Meta.dirChan) > 1
     
     applyChromaOffset(Meta);
     disp(2)
     disp('Chroamtic offset applied');
     end
     
     

    
%     if ExNum == 0
%         % update chromatic offset
%         S = updateChroma(S);
%     end
    




























ExNum = ExNum + 1;
    
    
    
    
%     disp('Finding where acquisiton is taking place...');
%     str = sprintf('Ex%02d_',ExNum);
%     files = dir([dirSource filesep '**\' str '*']);
%     
%     if (~isempty(files) && foundFol == 0)
%         str_time = timeStr;
%         fprintf('%s \t %s found %s \n',str_time, str, files(1).folder);
%         % copy settings file to the sink
%         acqFol=[files(1).folder filesep files(1).name];
%         % get Metadata
%         fprintf('Searching for txt file for %s\n', str);
%         Meta = AutoDS_readtxt(acqFol, folSink);
%         foundFol = 1;
%     end
%     
    % copy the existing tiff into the sink, organiza the location by ch
    % if the first stack, wait until stack i+1.
%     % if the last stack, wait 1.2*acqui_time
%     % -----
%     % A = struct containing tif transfered files
%     
%     while (true) 
%         A = CopyTifToSink(A, dirAcq, folSink)
%     
%     
%     
%     break; % for now, delete when protptype is ready
%     if (numDSed == length(Meta.chan) * Meta.stacks)
%         disp('All files transfered and DSed');
%         break
%     end
%     % copy directoryFolders into the sink, 
%     % make organized folders in the sink
%         
%     % copy the files into the sink, keep track of what you transfered
%     % (structures)
%     
%     % For copied one, DS and apply chroma offset
%     
%     
%     c = c + 1;
end


end
