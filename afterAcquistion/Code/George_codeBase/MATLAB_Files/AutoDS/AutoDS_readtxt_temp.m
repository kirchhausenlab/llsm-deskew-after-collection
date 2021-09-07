% clear; clc; close all;
%
% dir = 'V:\George\AutoDS';
% settingsFile = 'ex02_Settings.txt';
% f = fopen([dir filesep settingsFile])
% b = fscanf(f,'%s')
%{
* open the settings file, find the number of stacks
* copy the files into the destination folder in scratch
( should have GUI, copy the foldername in slice to scratch)
iterate over the number of stacks (copy files, and for each file, make a DS
tif)
* make metadata for the file

%}

%%
function Meta = AutoDS_readtxt_temp(deskewFolder)
% clear; clc; close all;
%%
Meta = struct; % metadata
Meta.date = '';
Meta.zmotion = '';

Meta.chan = 0;
Meta.aotf = 0;
Meta.texp =0;
Meta.ds = -1; % set to -1, check it it is still negative or not.
Meta.planes = 0; %s-axis plane Number
Meta.stacks = 0;
Meta.roi = [0,0];
Meta.camflip = false;
Meta.camSave = zeros(2,3);
Meta.twait = 0;
Meta.dirParent = '';
% Meta.Ex  = ExNum;


% dirr = 'V:\George\AutoDS';
% settingsFile = 'ex02_Settings.txt';
% f = fopen([dirr filesep settingsFile]);
% tline = fgetl(f);
% %
foundSettingsFile = 0;
while (~foundSettingsFile)
    settingsSource = [deskewFolder filesep '*Settings*'];
    txtFile = dir(settingsSource);
    if isempty(txtFile)
        fprintf('.');
        pause(3);
        fprintf('.');
        pause(2);
        fprintf('.\n');
        pause(2);
    else
        tstr = getTime;
%         fprintf('%s\t Found ex%02d_Settings.txt\n',tstr,ExNum);
disp('found settings file')
        foundSettingsFile=1;
    end
end


% clc;
% fprintf('Settings file found: \t %s\n', txtFile.name);
settingsFile = txtFile.name; %'ex02_Settings.txt';
f = fopen([deskewFolder filesep settingsFile]);
tline = fgetl(f);
% %
% find number of channels using this phrase
numChanPhr = 'Excitation Filter';
numChan = 0;

% find which channels are used using this phrase in the lines of numChanPhr
lamda = {'405','488','560','592','642'};
lamdad = [405, 488, 560, 592, 642];
% regexp(allChan, tline of numChanPhr

% %
%
file = settingsFile;
line = 1;
while ischar(tline)
    
    Meta = getChanAOTFtexp(Meta, tline, numChanPhr,lamda,numChan);
    Meta = getZmotion(Meta,tline);
    Meta = getdsspn(Meta,tline);
    Meta = getDate(Meta, tline);
    Meta = getStacks(Meta, tline);
    Meta = getROI(Meta, tline);
    Meta = getcamflip(Meta, tline); % boolean
    Meta = gettcycle(Meta, tline);
    Meta = getCamSave(Meta, tline); % array
    %    488 560 642
    % A: [1,  0,  1;
    % B:  0,  1,  0];
    % means 488, 642 saved at cam A, 560 saved at cam B
    
    tline = fgetl(f);
    line = line + 1;
end
str_time = timeStr;
fprintf('%s \t MetaData called: \n',str_time);

% copy settings file to the sink
idxR = regexp(txtFile.folder,filesep);

% make CSN_Sample Folder
idxCS = regexp(txtFile.folder,'CS?\d+');
idxEx = regexp(txtFile.folder,'Ex?\d+');
% Meta.dirParent = txtFile.folder(1:idxEx-1);
Meta.dirParent = deskewFolder;
% dirCS = [deskewFolder filesep txtFile.folder(idxCS: idxEx-1)];
% if ~exist(dirCS, 'dir')
%     mkdir(dirCS);
%     tstr = getTime;
%     fprintf('%s\t %sdir created\n',tstr,dirCS);
%     
%     st = dbstack;
%     % mark(name, destination)
%     mark(st, dirCS);
%     
%     
%     
% % end
% 
% % Make Ex%02d Folder
% dirEx = [dirCS filesep txtFile.folder(idxEx:end)];
% if ExNum > 0
%     if ~exist(dirEx, 'dir')
%         mkdir(dirEx)
%         tstr = getTime;
%         fprintf('%s\t %sdir created\n',tstr,dirEx);
%         st = dbstack;
%         % mark(name, destination)
%         mark(st, dirEx);
%     end
% end

% 
% % copy settings file to the destination
% curSinkFol = [folSink txtFile.folder(idxR(end-1):end)];
% curSourceFol = txtFile.folder;
% 
% Meta.dirSink = curSinkFol;
% Meta.dirSource = curSourceFol;
% 
% if ExNum > 0 % not the chroma folder -- ExNum = 0
%     if ~(exist([folSink txtFile.folder(idxR(end-1):end) filesep txtFile.name], 'file'))
%         copyfile([curSourceFol filesep txtFile.name], curSinkFol)
%     end
% end

% make separate folder (ch488nmCamA,...etc)
for ii = 1:length(Meta.chan)
    col = Meta.camSave(:,ii);
    idxCam = find(col == 1);
    if (idxCam == 1)
        strCam = 'A';
    else
        strCam = 'B';
    end
    strChan = sprintf('ch%snmCam%s',num2str(Meta.chan(ii)), strCam);
    dirChan = [deskewFolder filesep strChan];
    Meta.dirChan{ii,1} = dirChan;
    if ~exist(dirChan, 'dir')
        mkdir(dirChan)
        tstr = getTime;
        fprintf('%s\t %s created\n',tstr,dirChan);
        
        
        st = dbstack;
        mark(st, dirChan);
    end
    %     mkdir([folSink txtFile.folder(idxR(end-1):end) filesep strChan]);
end




tstr = getTime;
fprintf('%s\t Meta Obtained',tstr);
disp(Meta);



%{

10/3 added while loop, added which laser is being used

10/4 add other metadata
ROIr            added   100719      getROI
ROIds
ds              added   100719      getdsplanes
dz
zAniso
Camflip
Z-motion        added   100719      getZmotion
Exptime         added   100719      getChanAOTFtexp
S plane Num     added   100719      getdsplanes
datetime        added   100719      getDate
AOTF            added   100719      getChanAOTFtexpgetChanAOTFtexp
chan            added   100719      getChanAOTFtexp
stacks          added   100719      getStacks
camflip         added   101419      getcamflip
camSave         added   102119      getCamSave


-------- From GU_loadconditon -------------
  source
    channels
    date
    framerate
    imagesize
    movieLength
    markers
    framePaths
    maskPaths
    pixelSize
    dz
    zAniso
    angle
    objectiveScan
    reversed
    framePathsDS
    framePathsDSR
------------------------------------------------


Make code to find the settings file,
load the coditions into metadata
Start DS using the metadata

%}



