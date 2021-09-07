function check3Dacquisition(Ex_directories)

disp('');
disp("******* Check Volume scans ********");
Meta = getMeta2_AO(Ex_directories);
for ii=1:length(Ex_directories)
    Ex_directory = char(Ex_directories{ii});
    sometif = dir([Ex_directory filesep '*.tif']);
    chCheck = dir([Ex_directory filesep 'ch*']);
    removeEx = 0;

    
%     disp(ii);

    if Meta(ii).ds <= 0
        removeEx =1;
    end

    
    % if no tif, rename\
    if isempty(chCheck) 
        if isempty(sometif)
            removeEx = 1;
            
            
        else
%             sometif(1).folder
% Some files have the name
% 
%    '._ex0_CamA_ch0_stack0000_488nm_0000000msec_0075262379msecAbs.tif'   
%
% so use sometif(end) instead of sometif(1)

            Tif = readtiff([sometif(end).folder filesep sometif(end).name]);
            Tif_size_z = size(Tif);
            % if not 3D
            if length(Tif_size_z) < 3
                removeEx = 1;
            elseif length(Tif_size_z) > 2 && Tif_size_z(3) < 2
                removeEx = 1;
            end
            
            
        end
    end
    idx = regexpi(Ex_directory, '/Ex');
    

    
    if removeEx
        % change name
        left_str = Ex_directory(1:idx-1);
        right_str = Ex_directory(idx+1:end);
        fprintf("%s changed to\n\t %s\n", Ex_directory(idx:end), Ex_directory(idx+1:end))
        if strcmp(Ex_directory,  [left_str filesep  right_str])
            continue;
        else
            movefile(Ex_directory, [left_str filesep  right_str]);
        end
        
    else
        c = char(Ex_directory(idx:end));
        fprintf("%s is 3D\n", c(2:end));
    end
   
    
end





end