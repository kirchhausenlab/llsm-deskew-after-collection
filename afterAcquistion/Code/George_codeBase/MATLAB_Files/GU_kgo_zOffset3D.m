function GU_kgo_zOffset3D(data, varargin)
% adjusts z-offsets for only 3D data

ip = inputParser;
ip.CaseSensitive = false;
ip.addRequired('data', @isstruct);
ip.addParamValue('zOffset', 0.5); % in microns
ip.addParamValue('RawData', true, @islogical); %
ip.addParamValue('DS', false, @islogical); %
ip.addParamValue('GPUDecon', false, @islogical); %
ip.addParamValue('Ch1', false, @islogical); %  true adds empty frames on top false on bottom
ip.addParamValue('Ch2', true, @islogical); %
ip.addParamValue('Ch3', false, @islogical); %
ip.parse(data, varargin{:});

zO = ip.Results.zOffset;
RawData = ip.Results.RawData;
DS = ip.Results.DS;
Ch = [ip.Results.Ch1 ip.Results.Ch2 ip.Results.Ch3];
GPUDecon = ip.Results.GPUDecon;

nd = numel(data);
for k = 1:nd
    tic
    nF = round(zO/data(k).pixelSize/data(k).zAniso); % # of frames to add
    for j = 1:numel(data(k).channels)
%         if exist(fullfile([data(k).channels{j},'DS\'],'ChromaticOffsetApplied.txt'),'file')
%         delete(fullfile([data(k).channels{j},'DS\'],'ChromaticOffsetApplied.txt'))
%         end
        if ~exist(fullfile([data(k).channels{j},'DS\'],'ChromaticOffsetApplied.txt'),'file') % Added KGO 1/9/19
            parfor i = 1:numel(data(k).framePaths{j})
                if RawData
                    GU_zOffset3Dframe(data(k).framePaths{j}{i}, Ch(j),nF);
                end
                if DS
                    GU_zOffset3Dframe([data(k).framePathsDS{j}{i}  ] , Ch(j),nF);
                end
                if GPUDecon
                    GU_zOffset3Dframe([data(k).framePathsDS{j}{i}  ] , Ch(j),nF);
                end
            end
        end
         save(fullfile([data(k).channels{j},'DS\'],'ChromaticOffsetApplied.txt'));  % Added KGO 1/9/19
    end
    fprintf('Completed %d of %d ',k,nd);
    toc
end