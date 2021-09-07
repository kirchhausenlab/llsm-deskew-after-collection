function Meta = getMeta2_AO(Ex_directory)

fprintf('Fetching metadata from \n\t%s\n',char(Ex_directory))
% disp(Ex_directory)
if ischar(Ex_directory)
    Ex_directory = cellstr(Ex_directory);
end

Meta(length(Ex_directory)) = struct(); % metadata
% 405, 488, 560, 592, 642, 

for ii = 1:length(Ex_directory)
    Meta(ii).name = '';
    Meta(ii).date = '';
%     Meta(ii).twait = 0;
   
    Meta(ii).chan = 0;
    Meta(ii).aotf = 0;
    Meta(ii).texp =0;
    Meta(ii).tcycle = 0;
    Meta(ii).ds = -1; 
    Meta(ii).planes = 0; %s or z-axis plane Number
    Meta(ii).stacks = 0;
    Meta(ii).roi = [0,0];
    Meta(ii).zmotion = '';
    Meta(ii).camflip = false;
    Meta(ii).scripting = false;
    Meta(ii).sourcedir = Ex_directory{ii};
    Meta(ii).camSave = zeros(2,5);
    Meta(ii).cam = '';
    
    Meta(ii).scope = 'llsm';
   
    
    % get settings file info
    settingsSource = [char(Ex_directory{ii}) filesep '*Settings*'];
    txtFile = dir(settingsSource);
    % set Meta name to Ex01, Ex02, ... ExNM
    
    
    if isempty(txtFile)
        c =char(Ex_directory{ii});
        idx_slash = regexp(c, filesep);
        str = sprintf('No setting file found %s ',char(c));
        error(str);
    end
    Meta(ii).name = txtFile(end).name(1:4);
    
    % check if scripting were used 
    if ~isempty(regexp(txtFile(end).name, '_Iter_','match'))
        Meta(ii).scripting = true;
    end
    
    % check which cameras were used
    flag_cam = regexpi(char(Ex_directory{ii}), 'EMCCD');
    if flag_cam
        Meta(ii).cam = 'EMCCD';
    else
        Meta(ii).cam = 'sCMOS';
    end
    
    
    % fprintf('Settings file found: \t %s\n', txtFile.name);
    settingsFile = txtFile(end).name; %'ex02_Settings.txt';
    f = fopen([char(Ex_directory{ii}) filesep settingsFile]);
    tline = fgetl(f);
    % %
    % find number of channels using this phrase
    numChanPhr = 'Excitation Filter';
    numChan = 0;
    
    % find which channels are used using this phrase in the lines of numChanPhr
    lamda = {'405','488','560','592','642'};
    lamdad = [405, 488, 560, 592, 642];
    
    file = settingsFile;
    line = 1;
    
    while ischar(tline)
        % get scope info (llsm or AO?)
        Meta(ii) = getScope(Meta(ii), tline);
        
        Meta(ii) = getChanAOTFtexp(Meta(ii), tline, numChanPhr,lamda,numChan);
        Meta(ii) = getZmotion(Meta(ii),tline);
        
        Meta(ii) = getdsspn(Meta(ii),tline);
        Meta(ii) = getDate(Meta(ii), tline);
        Meta(ii) = getStacks(Meta(ii), tline);
        Meta(ii) = getROI(Meta(ii), tline);
        Meta(ii) = getcamflip(Meta(ii), tline); % boolean
        Meta(ii) = gettcycle(Meta(ii), tline);
        Meta(ii) = getCamSave(Meta(ii), tline); % array
        %    488 560 642
        % A: [1,  0,  1;
        % B:  0,  1,  0];
        % means 488, 642 saved at cam A, 560 saved at cam B
        
        
        tline = fgetl(f);
        line = line + 1;
    end
    
    
    
    
end


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
end