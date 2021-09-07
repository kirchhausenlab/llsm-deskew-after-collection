function deskewImage(tif)

load('/nfs/scratch/George/MATLAB_Files/Optimization/optimizationData.mat')
I.doIllum = false;
C.doChroma = false;

% get the parent folder
dirEx = getdirSource(tif);

% get the metadata
% Meta = getMeta2_AO(dirEx);

% should output 1 channel, input of dirSource, all in one data structure
dataCompiled = AutoSLURM_GU_loadConditionData3D(dirEx);

% tables of all the tif images, relaational database
dataTable = Unwrap_loadConditionData(dataCompiled);

data=getOneImage(dataTable, tif);

dirSink = dirEx;
preprocess4(data, dirSink, I, B, C)

end


function d = getdirSource(tif)

while tif(end) == filesep
    tif(end) = '';
end

idx = max(regexp(tif, filesep));
d = tif(1:idx);

end

function data=getOneImage(dataTable, tif)
data = '';
for ii = 1:length(dataTable)
    if strcmp(tif, char(dataTable(ii).framePaths))

        data = dataTable(ii);
        break
    end
    
end
assert(~isempty(data))
end
