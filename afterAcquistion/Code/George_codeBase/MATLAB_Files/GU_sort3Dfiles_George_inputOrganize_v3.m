%%


function GU_sort3Dfiles_George_inputOrganize_v3(data)
filterTypeCounter = 0;
for k = 1:numel(data)
    
    tic
    rt = [data(k).source];
    cd(rt)
    
    % Edited, KGO 062518
    fprintf('source: %s\n\t has %d channels\n',data(k).source,numel(data(k).channels));
    source = data(k).source;
    expression = {'405' '488' '560' '592' '642' };
    expressionExist = zeros(1,length(expression));
    expressionCamera = {'CamA','CamB'};
    % Find which las1ers
    matchStr = regexpi(source, expression, 'match');
    
    counter =1;
    for i2= 1:length(matchStr)
        if ~isempty(matchStr{i2})
           usedMatchStr{counter} = matchStr{i2}{1};
           counter = counter + 1;
        end
        if length(matchStr) == counter
            error('Msg from Function: No channels detected. Check FOLDER name - should have channels ie 488, 560,...');
        end
    end
    try
        matchStr = usedMatchStr;
    catch 
        error('Msg from Function: No channels detected. Check FOLDER name - should have channels ie 488, 560,...');
    end
    
    
    for ii = 1:length(matchStr)
        chan_str = char(matchStr{ii});
        str = sprintf('*%snm*.tif', chan_str);
        stackFiles = dir([rt str]);
        for jj = 1:numel(stackFiles)
            cam = regexpi([rt stackFiles(jj).name], expressionCamera, 'match');
            if ~isempty(char(cam{1}))
                if char(cam{1}) == 'CamA'
                    camName = 'CamA';
                end
                
            elseif ~isempty(char(cam{2}))
                if char(cam{2}) == 'CamB'
                    camName = 'CamB';
                end
            else
                if filterTypeCounter == 0
                    filterType = input('2 Color or 3 color filter? Enter 2 or 3: ');
                    if filterType == 3 || filterType == 2
                        
                    else
                        error('Must enter 2 or 3');
                    end
                end
                
                if filterType == 3
                    if numel(string(matchStr{ii}) == '488') || numel(string(matchStr{ii}) == '642') || numel(string(matchStr{ii}) == '405')
                        camName = 'camA';
                    else
                        camName = 'camB';
                    end
                else
                    if numel(string(matchStr{ii}) == '560') || numel(string(matchStr{ii}) == '592') || numel(string(matchStr{ii}) == '642')
                        camName = 'camA';
                    else
                        camName = 'camB';
                    end
                end
            end
            
            
            folderName = strcat('ch',char(matchStr{ii}),'nm', camName);
            if ~isempty(folderName)
%                 if ~exist(folderName,'dir')
                if ~exist([rt filesep folderName],'dir')
                    mkdir(char(folderName));
                    fprintf('%snm%s folder created\n',char(matchStr{ii}),camName);
                end
                
                movefile([rt stackFiles(jj).name],[rt char(folderName) filesep])  %% Change here
            end
            
        end
    end
    
    
end
