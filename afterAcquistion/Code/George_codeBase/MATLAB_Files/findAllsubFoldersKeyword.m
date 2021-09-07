function S = findAllsubFoldersKeyword(directory, keyword)
S = struct;
counter = 1;
% find all subfolders that has the keyword Ex
directories = getdir(directory);
for ii = 1:length(directories)
    % for each folders in DS3, find if there is a folder with the keyword
    S = findsubFolderswithKeyword(directories(ii), keyword,counter,S);
end 
    
end



function S = findsubFolderswithKeyword(di, keyword, counter,S)
if (di.isdir)
    dsubfolders =  getdir([di.folder filesep di.name]);
    if (~isempty(dsubfolders))
        for ii = 1:length(dsubfolders)
            if isempty(regexpi(dsubfolders(ii).name, keyword,'match'))
%                 disp(dsubfolders(ii))
                S = findsubFolderswithKeyword(dsubfolders(ii), keyword, counter, S);
               
                %             newSub = getdir([ dsubfolders(ii).folder, filesep dsubfolders(ii).name]);
                %
                %             if (~isempty(newSub))
                %                 for jj = 1:length(newSub)
                %                     disp([ newSub(jj).folder, filesep newSub(jj).name])
                %
                %                     findsubFolderswithKeyword(newSub(jj), keyword)
                %                 end
                %             end
                
            else % check if there are folders (channels that contain the .tif files)
                
                
                S = findchFolders(dsubfolders(ii), S);
                
                %
                %                 s = dir([ dsubfolders(ii).folder, filesep dsubfolders(ii).name, filesep, '*.tif']);
%                 if isempty(fieldnames(S)) 
%                     S = s;
%                 else 
%                     S = combineStructs(S,s);
%                     disp(length(S))
%                 end
            end
        end
    end
    
end


% make ch1, ch2 channels



end



function S = findchFolders(di, S)
channelDirectory = [di.folder filesep di.name filesep '*ch*'];
d =  getdir(channelDirectory);

if (~isempty(d))
    for ii = 1:length(d)
%         disp([ d(ii).folder, filesep d(ii).name])
        
        
        %if DS
        ss = dir([ d(ii).folder, filesep d(ii).name, filesep, '*DS']);
        if (~isempty(ss))
            s = dir([ ss.folder, filesep ss.name, filesep, '*.tif']);
            if (~isempty(s))
                disp(s(1).folder)
            end
            if isempty(fieldnames(S))
                S = s;
                disp(length(S))
                
            else
                S = combineStructs(S,s);
                disp(length(S))
            end
            
        end
        %endDS

        
%         % if images
%         s = dir([ d(ii).folder, filesep d(ii).name, filesep, '*.tif']);
%         if isempty(fieldnames(S))
%             S = s;           
%             disp(length(S))
% 
%         else
%             S = combineStructs(S,s);
%             disp(length(S))
%         end
%         %end images
    end
end

% find folders with the name "ch"




end


function directories=getdir(directory)

d = dir(directory);
dd = d([d(:).isdir]);
dd = dd(~ismember({dd(:).name},{'.','..'}));
directories = dd;

end


function T = combineStructs(S, s)
fields = fieldnames(S);
% for ii = 1:length(fields)
%     field = fields(ii)
%     T.((char(field))) = cat(dim, S.((char(field))), s.((char(field))))
% end
A =struct2cell (S);
B = struct2cell(s);
newCell = [A B];
T = cell2struct(newCell, fields);

end