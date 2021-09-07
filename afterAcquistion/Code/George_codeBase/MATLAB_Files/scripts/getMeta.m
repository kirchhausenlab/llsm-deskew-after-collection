function M = getMeta(Ex_directories)
n = length(Ex_directories);
M(n) = struct(); % metadata
% M = struct;

for ii = 1:length(Ex_directories)
    Meta = struct;
    Meta.name = '';
    Meta.date = '';
%     Meta(ii).twait = 0;
   
    Meta.chan = 0;
    Meta.aotf = 0;
    Meta.texp =0;
    Meta.ds = -1;  
    Meta.planes = 0; %s or z-axis plane Number
    Meta.stacks = 0;
    Meta.roi = [0,0];
    Meta.zmotion = '';
    Meta.camflip = false;
    Meta.scripting = false;
    Meta.sourcedir = Ex_directories{ii};
    Meta.camSave = zeros(2,3);
   
    
    % get settings file info
    settingsSource = [char(Ex_directories{ii}) filesep '*Settings*'];
    txtFile = dir(settingsSource);
    % set Meta name to Ex01, Ex02, ... ExNM
    Meta.name = txtFile(1).name(1:4);
    
    % check if scripting were used 
    if length(txtFile) > 1
        Meta.scripting = true;
    end
    
    % fprintf('Settings file found: \t %s\n', txtFile.name);
    settingsFile = txtFile.name; %'ex02_Settings.txt';
    f = fopen([char(Ex_directories{ii}) filesep settingsFile]);
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
    
    if (rem(ii,5) == 0 && ii >0)
        fprintf('%02dth Meta obtained\n',ii)
    end
% M(ii) = struct;
for fn = fieldnames(Meta)'
    M(ii).(fn{1}) = Meta.(fn{1});
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
