function B = getBk(dirSink, flag)

Cam = {'CamA','CamB'};

B = cell(2,1); % camA and camB
if flag
    
    keywords = {'background','bk','darkcurrent','dark'};
    for ii = 1:length(keywords)
        keyword = keywords{ii};
        B_dir = findKeywordDFS(dirSink, keyword)
        if ~isempty(B_dir)
            break;
        end
    end
    
    
    
    counter = 1;
    if isempty(B_dir)
        % choose a file for chromatic offset
        fprintf('dirSource: %s,\nkeyword: %s\n not found. Select the folder of interest\n', dirSink, keyword)
        
        B_dir = uigetdir(pwd);
        if ~B_dir
            disp('No Background folders selected. "Default" background images will be applied.');
            B;
        end
        
    else % if there are files in Illum, organize by cam and channel
        dirBk = [char(B_dir{1}) filesep '*.tif'];
        dBk = dir(dirBk);
        
        while isempty(dBk)
            fprintf('Bk tifs not found. Select the folder that has *.tif of Background\n', dirSink, keyword)
            dirIllum_temp = uigetdir(char(B_dir{1}));
            dirBk = [dirIllum_temp filesep '*.tif'];
            dBk = dir(dirBk);
            counter = counter + 1;
            if counter > 2
                disp('No background tif found. "Default" background images will be used');
                B;
                break;
            end
        end
        
        I.dir = dBk(1).folder;
        % Organize the folders into channels
      

    for ii = 1:length(dBk)
        whichCam = regexpi(char(dBk(ii).name), Cam);
        if isempty(find(~cellfun(@isempty,whichCam))) % if single camera mode, not cameraB
            B{1} = [ dBk(1).folder filesep dBk(ii).name];
        elseif ~isempty(whichCam{1})
            B{1} = [ dBk(1).folder filesep dBk(ii).name];
        elseif ~isempty(whichCam{2})
            B{2} = [ dBk(1).folder filesep dBk(ii).name];
        end
    end
    emptyCam = cellfun(@isempty,B);
    
    
    for ii =1:length(emptyCam)
       if emptyCam(ii)
           fprintf('%s bk not found, using default', Cam{ii});
           % set to default
           % B{ii} = 
       end
    end
    
    end
    
    
end
B{:}

end
