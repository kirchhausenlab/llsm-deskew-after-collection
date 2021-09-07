%% FInd the name of the folder, make the same folder into the destiantion folder, make the ch___nmCam_



function GU_sort3Dfiles_George_inputOrganize_v3_AutoDS(dirSource, Meta)

madeFolder = false;
while(~madeFolder)

%col1 = 488. col2 = 560, col3 = 642
% Find which channels are being used \
foldersMade = 0;
for ii = 1:size(Meta.camSave,2) % col
    str = Meta.chan(ii); % chane name, 488, 560,...
    for jj = 1:size(Meta.camSave,1) % row
        if (Meta.camSave(jj,ii))
            if (jj==1)
                camName = 'A';
            else 
                camName = 'B';
            end
            
            folderName = strcat('ch',num2str(str),'nmCam', camName);
            dirName = [dirSource filesep folderName];
            if ~exist(dirName,'dir')
                mkdir(char(dirName));
                fprintf('ch%snmCam%s folder created\n', num2str(str),camName);
                foldersMade = foldersMade + 1;
            elseif exist(dirName,'dir')
                fprintf('ch%snmCam%s already exists\n', num2str(str),camName);
                foldersMade = foldersMade + 1;
            end
            
        end
        
    end    
end

if ( foldersMade == length(Meta.chan))
    madeFolder=true;
end










% 
% filterTypeCounter = 0;
% for k = 1:numel(Meta.chan)
%     
%     tic
%     rt = [dirSource];
%     cd(rt)
%     
%     % Edited, KGO 062518
% %     fprintf('source: %s\n\t has %d channels\n',data(k).source,numel(data(k).channels));
% %     source = data(k).source;
%     expression = {'405' '488' '560' '592' '642' };
%     expressionExist = zeros(1,length(expression));
%     expressionCamera = {'CamA','CamB'};
%     % Find which las1ers
%     matchStr = regexpi(source, expression, 'match');
%     
%     counter =1;
%     for i2= 1:length(matchStr)
%         if ~isempty(matchStr{i2})
%            usedMatchStr{counter} = matchStr{i2}{1};
%            counter = counter + 1
%         end
%         if length(matchStr) == counter
%             error('Msg from Function: No channels detected. Check FOLDER name - should have channels ie 488, 560,...');
%         end
%     end
%     matchStr = usedMatchStr;
%     
%     
%     for ii = 1:length(matchStr)
%         chan_str = char(matchStr{ii});
%         str = sprintf('*%snm*.tif', chan_str);
%         stackFiles = dir([rt str]);
%         for jj = 1:numel(stackFiles)
%             cam = regexpi([rt stackFiles(jj).name], expressionCamera, 'match');
%             if ~isempty(char(cam{1}))
%                 if char(cam{1}) == 'CamA'
%                     camName = 'CamA';
%                 end
%                 
%             elseif ~isempty(char(cam{2}))
%                 if char(cam{2}) == 'CamB'
%                     camName = 'CamB';
%                 end
%             else
%                 if filterTypeCounter == 0
%                     filterType = input('2 Color or 3 color filter? Enter 2 or 3: ');
%                     if filterType == 3 || filterType == 2
%                         
%                     else
%                         error('Must enter 2 or 3');
%                     end
%                 end
%                 
%                 if filterType == 3
%                     if numel(string(matchStr{ii}) == '488') || numel(string(matchStr{ii}) == '642') || numel(string(matchStr{ii}) == '405')
%                         camName = 'camA';
%                     else
%                         camName = 'camB';
%                     end
%                 else
%                     if numel(string(matchStr{ii}) == '560') || numel(string(matchStr{ii}) == '592') || numel(string(matchStr{ii}) == '642')
%                         camName = 'camA';
%                     else
%                         camName = 'camB';
%                     end
%                 end
%             end
%             
%             
%             folderName = strcat('ch',char(matchStr{ii}),'nm', camName);
%             if ~isempty(folderName)
%                 if ~exist(folderName,'dir')
%                     mkdir(char(folderName));
%                     fprintf('%snm%s folder created\n',char(matchStr{ii}),camName);
%                 end
%                 
%                 movefile([rt stackFiles(jj).name],[rt char(folderName) filesep])  %% Change here
%             end
%             
%         end
%     end
    
end

end
