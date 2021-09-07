%% Chromatic offset analysis
% clear ; clc; close all;
function beadAnalysis = ChromaOffsetCalc(folderName, zpix)

% clear; clc;
% % - inputs - - - - - - - - - -
% % % % folderName = 'Z:\George\20180827_p55_p5_sCMOS_George_ChromaOff\2017-03-10_SLICE1_p505-p6_EMCCD_Yi-ying_SVGA_PsV-DNA_NUP_ER\chromaticShiftMeasurementObjS\ChromaAnalysis\';
% % % % zpix = 0.1; %in Objscan or DS
% - - - - - 

chan = {'405','488','560','592','642'};
d = dir(folderName);

% Find which channels are used and how many bead samples we have 
chromaBeadSamples = 0;
chromaChannels = [];
for ii = 1:size(d,1)
    if ~isnan(str2double(d(ii).name(1))) % Find the number of bead samples , 1_488, 2_488, etc...
        if str2double(d(ii).name(1)) > chromaBeadSamples
            chromaBeadSamples = str2double(d(ii).name(1));
        end
    end
    
    beadTif = regexp(d(ii).name,chan); % find which channels were used to acquire bead sample
    for jj= 1:length(beadTif)
        if ~isempty(cell2mat(beadTif(jj)))
            if isempty(chromaChannels)
                chromaChannels = str2double(chan{jj});
            else
                chromaChannels = [chromaChannels, str2double(chan{jj})];
            end
        end
    end
end
chromaChannels = unique(chromaChannels);
% Now we know (1) which channels were used to obtain chroma, (2) how many
% samples

% get the PSF info, save to a structure called [c]
c = struct; 
chromaTiffs = [];
zCentroid = [];
beads = [];
lchromaBeadSamples = 1:chromaBeadSamples;
for i2 = 1:chromaBeadSamples
    for j2 = 1:length(chromaChannels)
%         if isempty(chromaTiffs)
            chromaTiffs = sprintf('%d_%s.tif',lchromaBeadSamples(i2),string(chromaChannels(j2)))
%         else
%             chromaTiffs = {chromaTiffs, sprintf('%d_%s.tif',chromaBeadSamples(i2),chromaChannels{j2})};
%         end
        [sigmaXY, sigmaZ, XYZ, ~, ~] = GU_estimateSigma3D(folderName,chromaTiffs);
        c(i2).folderName = folderName;
        c(i2).bead(j2,:) = chromaTiffs;
        c(i2).sigmaXY(j2,1) = sigmaXY;
        c(i2).sigmaZ(j2,1) = sigmaZ;
        c(i2).centroid(j2,1) = XYZ;
    end
end



% Find every potential combination of all channels without duplicates, and
% find the centroid difference (in pix). 
nChan = length(chromaChannels);
cOff = struct;
beadCounter = 1;
counter = 1;
iter = 0;
idx = 1;

for ss = 1:(chromaBeadSamples)
    for i4 = 1:(nChan-1)
        for i5 = 1:(nChan-1-iter)
            cOff(counter).bead = sprintf('%s AND %s',c(ss).bead(beadCounter+idx-1,:), c(ss).bead(end-iter,:));
            cOff(counter).offsetPix = abs(c(ss).centroid(beadCounter+idx-1,:).z -  c(ss).centroid(end-iter,:).z);
            counter = counter + 1;
            idx = idx+1;
        end
        iter = iter + 1;
        idx = 1;
    end
    idx = 1;
    iter = 0;
end

% Organize data into a matix from a structure for easier way to look at the
% data


% cOff.bead
% cOff.offsetPix
% 
% 
%
% c(i2).folderName = folderName;
% c(i2).bead(j2,:) = chromaTiffs;
% c(i2).sigmaXY(j2,1) = sigmaXY;
% c(i2).sigmaZ(j2,1) = sigmaZ;
% c(i2).centroid(j2,1) = XYZ;

offset = (struct2cell(cOff));
count =1;
for i2 =1:(chromaBeadSamples)
    for j2 = 1:size(c(1).bead,1)
        bead(count,1:length(c(i2).bead(j2,:))) = (c(i2).bead(j2,:));
        sigmaXY(count,1) = (c(i2).sigmaXY(j2,:));
        sigmaZ(count,1) = (c(i2).sigmaZ(j2,:));
        count = count + 1;
    end
end
bead = string(bead);
sigmaXY = string(sigmaXY);
sigmaZ = string(sigmaZ);
%
cOffsetbead = strings(size(cOff));
cOffsetPix = zeros(size(cOff));
% cOffsetbead = string(cOff.bead);

for i3 = 1:size(cOff,2)
    cOffsetbead(i3) = string(cOff(i3).bead);
    cOffsetPix(i3) = (cOff(i3).offsetPix);
end




beadAnalysis = strings(length(bead)+1,6);
beadAnalysis(1,1) = 'bead_tiff';
beadAnalysis(1,2) = 'sigmaXY';
beadAnalysis(1,3) = 'sigmaZ';
beadAnalysis(1,4) = 'Bead_Samples';
beadAnalysis(1,5) = 'offset in pixels';
beadAnalysis(1,6) = 'offset in um';

beadAnalysis(2:end,1) = bead;
beadAnalysis(2:end,2) = sigmaXY;
beadAnalysis(2:end,3) = sigmaZ;

if length(bead) == 2* length(cOffsetbead)
    beadAnalysis(2:end-0.5*length(bead),4) = cOffsetbead';
    beadAnalysis(2:end-0.5*length(bead),5) =  string(cOffsetPix');
    beadAnalysis(2:end-0.5*length(bead),6) =  string(cOffsetPix'.*zpix);
else
    
    beadAnalysis(2:end,4) = cOffsetbead';
    beadAnalysis(2:end,5) = string(cOffsetPix');
    beadAnalysis(2:end,6) = string(cOffsetPix'.*zpix);
end







 








%%





% for i5 = 1:(nChan-1) % constant
%     
%     for kk = 1:length(nChan-1)
%         for j5 = 1:(nChan - 1 - iter)
%             cOff(counter).bead = sprintf('%s AND %s',c(i5).bead(beadCounter,:), c(i5).bead(end-idxCounter,:));
%             beadCounter = beadCounter + 1;
%             counter = counter + 1;
%         end
%         idxCounter = idxCounter + 1;
%         beadCounter = 1;
%         iter = iter + 1;
%     end
%     
%     
% end

% for i4 = 1:((nChan-1) * edgeWeights(nChan-1))
%     cOff{i4}.beads = sprintf(;
%     
%     
%     
%     



% for i4 = 1:(nChan-1)
%    while counter <= (nChan-iter-1)
%        cOff(idxCounter).beads = sprintf('%s AND %s',c(i4).bead(beadCounter,:), c(i4).bead(beadCounter+counter,:));
%        counter = counter + 1;
%        idxCounter = idxCounter+ 1;
%    end
%    counter = 1;
%    iter = iter+1;
%    beadCounter = beadCounter + 1;
% end
















%%
% 
% 
% % Find the index of which channels are being used from [chan]
% %  >>> Used for calling the right Chroma offset functions
% usedChan = zeros(1,length(chromaChannels));
% for i3 = 1:length(chromaChannels)
%     usedChan(i3) = find(str2double(chromaChannels{i3}) == str2double(chan));
% end
% 
% dcc = str2double(chromaChannels); %doubleChromaChan
% 

% if ~isempty(find(488 == dcc))
% end
