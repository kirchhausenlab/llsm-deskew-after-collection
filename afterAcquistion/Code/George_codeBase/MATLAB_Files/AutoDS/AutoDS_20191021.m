function AutoDS_20191021(Meta,S)
numTransfered = 0;
numDSed = 0;
numInFolder = -1; % inside dirSource
numTotal = Meta.stacks * length(Meta.chan);


while (true)
    tic
%     pause(max(ceil(Meta.texp)+5)/1000*numel(Meta.chan)*Meta.planes*1.2  + Meta.waitTime);
    toc
    % transfer the files
    % DS the transfered files
    tifLocation = [S.dirSource, filesep '*tif'];
    tifFiles = dir(tifLocation);
%     tifSamplesToBeTransf = tifFiles.name; Doesnt contail
    tifSamplesToBeTransfered = cell(length(tifFiles),1);
    for ii = 1:length(tifFiles)
        tifSamplesToBeTransfered{ii}= tifFiles(ii).name;
    end
    fprintf('Transfering %d tif files\n', length(tifFiles));
    
    
%     for ii = 1:length(tifSamplesToBeTransfered)
        TransferAndDSTiff(tifSamplesToBeTransfered, S, Meta);
%     end
    numDSed = numDSed + numel(tifSamplesToBeTransfered);
    numInFolder = length(dir(S.dirSource)) -2;
    
    ChecktifFiles = dir(tifLocation);
    if (numDSed == numTotal || isempty(ChecktifFiles) ) % settings file to chans
        fprintf('%d files of %d files DS completed',numDSed,numTotal  );
        break
    end
    
end



end
