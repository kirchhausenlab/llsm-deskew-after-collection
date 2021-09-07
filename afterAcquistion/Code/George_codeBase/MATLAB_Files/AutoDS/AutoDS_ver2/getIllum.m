function I= getIllum(dirSink)


Cam = {'CamA','CamB'};
Chan = {'405','445','488','514','560','592','607','642'};

keyword = 'illum';

I_dir = findKeywordDFS(dirSink, keyword);
counter = 1;
I.doIllum = true;
if isempty(I_dir)
    % choose a file for chromatic offset
    fprintf('dirSource: %s,\nkeyword: %s\n not found. Select the folder of interest\n', dirSink, keyword)
    
    chromDir = uigetdir(dirSink);
    if ~chromDir
        disp('No Illumination correction folders selected. LLFF will not be applied.');
    end
    
else % if there are files in Illum, organize by cam and channel
    
    fprintf('\n\nPLEASE CHECK THAT YOUR ILLUM CORRECTION TIFS ARE STORED IN \n/llsm/.../<Your_Parent_Acquisiton_Folder>/LLSCalibration/illum/nB_dither\n\n')
    dirIllum = [char(I_dir{1}) filesep 'nB_dither' filesep '*.tif'];
    dIllum = dir(dirIllum);
    
    while isempty(dIllum)
        fprintf('Illum tifs not found. Select the folder that has *.tif of illumunination correction\n', dirSink, keyword)
        dirIllum_temp = uigetdir(char(I_dir{1}));
        fprintf('Selected %s \n', dirIllum_temp);
        dirIllum = [dirIllum_temp filesep '*.tif'];
        dIllum = dir(dirIllum);
        counter = counter + 1;
        if counter > 2
            disp('No illumination correction file selected. Deskew will not have illumination correction');
            I.doIllum = false;
            break;
        end
    end
    if  I.doIllum
        
        I.dir = dIllum(1).folder;
        % Organize the folders into channels

        I.chan = cell(length(Cam), length(Chan));
        for kk = 1:length(dIllum)
            Illum = dIllum(kk).name;
            for ii = 1:length(Cam)
                for jj = 1:length(Chan)
                    expr_cam =  ['_' char(Cam(ii)) '_'];
                    expr_chan =  ['_' char(Chan(jj)) 'nm_'];
                   
                    flag_cam = regexpi(Illum, expr_cam);
                    if isempty(flag_cam) && ii == 1
                        flag_cam = 1;
                    end
                    flag_chan = regexpi(Illum, expr_chan);
                    if ~isempty(flag_cam) && ~isempty(flag_chan)
%                     if ~isempty(flag_chan)
                        I.chan{ii,jj} = Illum;
                    end
                    
                end
            end
            
        end
    end
end



disp(Chan);
    


end