% clear; clc; close all;
%
% dir = 'V:\George\AutoDS';
% settingsFile = 'ex02_Settings.txt';
% f = fopen([dir filesep settingsFile])
% b = fscanf(f,'%s')

%%
function Meta = AutoDS_readtxt2
clear; clc; close all;

Meta = struct; % metadata
Meta.chan = 0;
Meta.aotf = 0;
Meta.texp =0;
Meta.zmotion = '';


dir = 'V:\George\AutoDS';
settingsFile = 'ex02_Settings.txt';
f = fopen([dir filesep settingsFile]);
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
    
    Meta = getChanAOTFtexp(Meta, tline, numChanPhr);
    Meta = getZmotion(Meta,tline); 
    
    
    
    tline = fgetl(f);
    line = line + 1;
end


%{

10/3 added while loop, added which laser is being used

10/4 add other metadata
ROIr
ROIds
ds
dz
zAniso
Camflip
Plane number z
Z-motion
Exptime         added   1007199     getChanAOTFtexp
S plane
datetime
AOTF            added   100719      getChanAOTFtexpgetChanAOTFtexp
chan                                getChanAOTFtexp
stacks







Make code to find the settings file,
load the coditions into metadata
Start DS using the metadata

%}



