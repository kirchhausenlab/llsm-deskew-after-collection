function TransferAndDSTiff(tifSamplesToBeTransfered, S, Meta)
Meta;
expression = {'405nm' '488nm' '560nm' '592nm' '642nm'};
idx = zeros(1,length(expression));


for ii = 1:length(tifSamplesToBeTransfered)
    % ---------------------Move tif to Destiantion folder-------------------------------------
    % find destination folder
    idxRaw = regexpi(tifSamplesToBeTransfered{ii}, expression, 'match');
    idx = zeros(1,length(expression));
    for jj = 1:length(idxRaw)
        if (~isempty(idxRaw{jj}))
            idx(jj)= 1;
        end
    end
    expIdx = find(idx == 1);
    % Find the folder that you will transfer to
    folName = sprintf('ch%s*', expression{expIdx});
    folderNames = [S.dirSource filesep folName];
    folDestinationRaw = dir(folderNames);
    folDestination = folDestinationRaw.name;
    % move the file into the destination folder
    
    
    movefile([S.dirSource filesep tifSamplesToBeTransfered{ii}] ,[S.dirSource filesep folDestination])
    S.toBeDSed = [S.dirSource filesep folDestination filesep tifSamplesToBeTransfered{ii}];
    S.chan = expression{expIdx(1)};
    S.dz = Meta.ds * sind(31.5);
    S.ds = Meta.ds;
    S.pixSize = 0.104;
    S.zmotion = Meta.zmotion;
    S.sink =  [S.dirSource filesep folDestination filesep 'DS'];
    S.name = tifSamplesToBeTransfered{ii};
    i = strfind(S.dirSource,'\');
    S.folderName = S.dirSource(i(end)+1:end);
    
    % ------------------------ Make destination folder ----------
     if ~exist([S.dirSink filesep S.folderName] , 'dir')
       mkdir([S.dirSink filesep S.folderName])
    end
    
    
    % ------------------------- Deskew ------------------------------
    % if DS folder not present, then make one
    folDS = [S.dirSource filesep folDestination filesep 'DS'];
    if ~exist(folDS,'dir')
        mkdir(char(folDS));
    end    %Deskew the image
    AutoDS_deskewFile20191021(folDS, S)
   
    fprintf('%s DSed',S.name);
    %NEED TO ADD ILLUMINATION CORRECTION INFO
    
    
    


end



end
