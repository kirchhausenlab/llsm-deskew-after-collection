
function fullSourceImgs =  getAcquiredTifs(d_tif, OnlyDeskewFirstStack)

% organize tif into cell
% find the lastest abs Time

% transfer until imgN-1 by channels based on abstime

% save the images to a struct

% ---------------------------------------------
clear fullSourceImgs
clear candidateImgs

fullSourceImgs(length(d_tif)) = struct();
candidateImgs(length(d_tif)) = struct();

for ii = 1:length(d_tif)
    
%     % save the metadata
%     
    
    % if you only have one stack to be deskewed
    if OnlyDeskewFirstStack(ii) 
        fullSourceImgs(ii).tif = [d_tif(ii).dir(1).folder filesep d_tif(ii).dir(1).name];
        
    else % if have multiple to deskew on the fly
        
        % get the msecAbs, transfer everything except the last stack
        maxTime = -1;
        imgs_dir = cell(1,length(d_tif(ii).dir));
        imgs_name = imgs_dir;
        bytes = imgs_dir;
        
        % ---  organize the images into a cell ----
        for jj = 1:length(d_tif(ii).dir)
            imgs_dir{jj} = [d_tif(ii).dir(jj).folder filesep d_tif(ii).dir(jj).name];
            imgs_name{jj} = [d_tif(ii).dir(jj).name];
            bytes{jj} = d_tif(ii).dir(jj).bytes;
            candidateTime = regexp(char(imgs_dir{jj}), '((?<=_)\d+(?=msecAbs))','match','once');
            if str2double(candidateTime) > maxTime
                maxTime = candidateTime;
            end
            
        end
        
        % ----- import N-1 images ----
        for jj=1:length(imgs_dir)
            % if the tif is not the last-acquired image, store the value
            if isempty(regexp(char(imgs_dir{jj}), maxTime, 'match'))
                if isempty(fieldnames(fullSourceImgs(ii)))
                    fullSourceImgs(ii).name = {imgs_name{jj}};
                    fullSourceImgs(ii).tif = {imgs_dir{jj}};
                    fullSourceImgs(ii).bytes =  bytes{jj};
                else
                    fullSourceImgs(ii).name(end+1) = {imgs_name{jj}};
                    fullSourceImgs(ii).tif(end+1) = {imgs_dir{jj}};
                    fullSourceImgs(ii).bytes(end+1) = bytes{jj};
                end
                
            else % N-1 images
                if isempty(fieldnames(candidateImgs(ii)))
                    candidateImgs(ii).name = {imgs_name{jj}};
                    candidateImgs(ii).tif = {imgs_dir{jj}};
                    candidateImgs(ii).bytes =  bytes{jj};
                else
                    candidateImgs(ii).name(end+1) = {imgs_name{jj}};
                    candidateImgs(ii).tif(end+1) = {imgs_dir{jj}};
                    candidateImgs(ii).bytes(end+1) = bytes{jj};
                end
            end
        end
        
        % ---- check if the last image is ready to go ----
        
        % check the size of the file, make sure they have the same bytes
        bytesCheck = (min(fullSourceImgs(ii).bytes));
        for jj=1:length(candidateImgs(ii).bytes)
            if  candidateImgs(ii).bytes(jj) >= bytesCheck
                if isempty(fieldnames(fullSourceImgs(ii)))
                    fullSourceImgs(ii).name = candidateImgs(ii).name(jj);
                    fullSourceImgs(ii).tif = candidateImgs(ii).tif(jj);
                    fullSourceImgs(ii).bytes = candidateImgs(ii).bytes(jj);
                else
                    fullSourceImgs(ii).name(end+1) =  candidateImgs(ii).name(jj);
                    fullSourceImgs(ii).tif(end+1) = candidateImgs(ii).tif(jj);
                    fullSourceImgs(ii).bytes(end+1) = candidateImgs(ii).bytes(jj);
                end
                candidateImgs(ii).name(jj) = {''};
                candidateImgs(ii).tif(jj) = {''};
                candidateImgs(ii).bytes(jj) = -1;

            end
        end
        
        % check if all images are fulltifs 
        %    - if not scripting, then info should be in the metadata
        %    - if scripting, then one must manually terminate. 
        %         the number of iterations are not saved in the settings
        %         file
        if ~d_tif(ii).meta.scripting
             fullSourceImgs(ii).completed = length(fullSourceImgs(ii).tif) == d_tif(ii).meta.stacks;
        else
            fullSourceImgs(ii).completed = 'Cannot tell from settings file. Scripting used.';
        end
        
       fullSourceImgs(ii).meta = d_tif(ii).meta;
       fullSourceImgs(ii).source = d_tif(ii).source;
        
    end
%     currentStackNumber = floor(length(d_tif(ii).dir) / length(d_tif(ii).meta.chan));
  
end


end
