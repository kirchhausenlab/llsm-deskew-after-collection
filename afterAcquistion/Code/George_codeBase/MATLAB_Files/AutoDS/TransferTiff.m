function TransferAndDSTiff(tifSamplesToBeTransfered, dirSource, Meta)
    expression = {'405' '488' '560' '592' '642' };
    idx = zeros(1,length(expression));
for ii = 1:length(tifSamplesToBeTransfered)
    % find destination folder
    idxRaw = regexpi(tifSamplesToBeTransfered{1}, expression, 'match');
    for jj = 1:length(idxRaw)
        if (~isempty(idxRaw{jj}))
            idx(jj)= 1;
        end
    end
    expIdx = find(idx == 1);
    % Find the folder that you will transfer to
    folName = sprintf('ch%s*', expression{expIdx(1)});
    folderNames = [dirSource filesep folName];
    folDestinationRaw = dir(folderNames);
    folDestination = folDestinationRaw.name;
    
    


end



end
 source = data(k).source;
    expression = {'405' '488' '560' '592' '642' };
    expressionExist = zeros(1,length(expression));
    expressionCamera = {'CamA','CamB'};
    % Find which las1ers
    matchStr = regexpi(source, expression, 'match');