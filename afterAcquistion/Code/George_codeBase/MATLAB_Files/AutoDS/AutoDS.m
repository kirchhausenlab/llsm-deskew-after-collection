function AutoDS(source,S)


source = '/Users/kgo5020/Desktop/source/source'; % souce folder
sink = '/Users/kgo5020/Desktop/source/DS/'; % destination folder
copy = '/Users/kgo5020/Desktop/source/copy';

% S = struct;
% S.filepath = [];
%{
.filepath
.DSdone

%}

firstTime = 1; % save all the files for the fist run
filestored = 0;

fileNonMatchCount = 0; % number of filesnot mathcing files in dir with Struct
iterTime = 3; % check every second

if ([sink filesep 'DS'])
    mkdir([sink filesep 'DS']);
end

whileLoop = 1;
% while (whileLoop)
for kk  = 1:4
    files = dir([source, filesep, '*tif']);
    length(files)
    
    if (firstTime && length(S) == 1)
        for (ii = 1:length(files))
            S(ii).filepath = files(ii).name;
            S(ii).DSdone = false;
        end
        firstTime = 0;
        
    end
    
    
    % add new files
    while (length(files) >= length(S)) % if there are new files, then update the structure
        
        for (ii = 1:length(files))  % find which ones are new and update the sturcture
            for (jj = 1:length(S))
                disp((S(jj).filepath))
                disp((files(ii).name))
                if (length(S(jj).filepath) ~= length(files(ii).name))
                    fileNonMatchCount = fileNonMatchCount+1;
                    break;
                else
                    if (S(jj).filepath == files(ii).name)
                        break
                    end
                    fileNonMatchCount = fileNonMatchCount+1;
                end
                if (fileNonMatchCount == length(S))
                    S(end+1).filepath = files(ii).name;
                    S(end+1).DSdone = false;
                    
                end
                fileNonMatchCount  =0;
            end
            
        end
        if whileLoop + length(files) > 1001
            break;
        end
        whileLoop = whileLoop + 1;
    end
    
    % deskew files that are not yet deskewed
    
    
    for ii = 1:length(S)
        if (~S(ii).DSdone)
            

            
            AutoDS_deskewFile(S(ii).filepath, source, sink);
            S(ii).DSdone = 1;
        end
    end

   
    
    
    
    
    
    
    %
    %     for ii = 1:length(files) % go through the entire folder to store the file tif into the structure
    %         while (filestored < length(S))
    %
    %
    %
    %
    %
    %
    %
    %         end
    %
    %
    %             jj = length(files)
    %             if (file(jj).filepath ~= S(ii).filepath) % only save the new ones by checking the number of files
    %                 filestored = filestored + 1;
    %             else
    %
    %
    %                 if (~fileCounter)
    %                     fileCounter = 1;
    %                     S(fileCounter).tif = files(ii).filepath;
    %                     fileCounter= fileCounter+1;
    %                 else
    %                     S(fileCounter).tif = files(ii).filepath;
    %                     fileCounter= fileCounter+1;
    %                 end
    %                 filestored = 0;
    %
    %             end
    %
    %         end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    for ii = 1:length(S)
        disp(S(ii).filepath);
    end
    disp('------');
    pause(iterTime); %wait one sec before proceeding
    if length(S) > 3
        whileLoop = 0;
    end
    
end

end
