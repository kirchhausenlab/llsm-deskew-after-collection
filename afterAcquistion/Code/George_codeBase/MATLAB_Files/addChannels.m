function addChannels(Ex_directories)
%%
expr = {'405nm';'488nm';'560nm';'592nm';'642nm'};
expr_cam = {'CamA';'CamB'};
for ii = 1:length(Ex_directories)
    c = char(Ex_directories{ii});
    c_idx = regexpi(c,'Ex');
    % get all tif in the Ex folder
    d = dir([char(Ex_directories{ii}) filesep '*.tif']);
    if isempty(d)
            fprintf('%s already organized into channels\n', c(c_idx:c_idx+4));
    end
  
    parfor jj = 1:length(d)
        
       
            % find the channel
            flag = regexp(d(jj).name, expr,'match','once');
            idx = find(~cellfun(@isempty,flag));
            ch_char = char(expr{idx});
            
            % find camera
            flag = regexpi(d(jj).name, expr_cam,'match','once');
            idx = find(~cellfun(@isempty,flag));
            ch_cam = char(expr_cam{idx});
            
            % check if the channel folder exists
            channelFolName = ['ch' ch_char ch_cam];
            
            if ~exist([char(Ex_directories{ii}) filesep channelFolName],'dir')
                mkdir([char(Ex_directories{ii}) filesep channelFolName]);
                fprintf('Creating %s\n',char([c(c_idx:end) filesep channelFolName]));
            end
            
            % movefile from the raw to the channels
            source = [char(Ex_directories{ii}) filesep d(jj).name ] ;
            dest = [char(Ex_directories{ii}) filesep channelFolName filesep d(jj).name ] ;
            movefile(source, dest);
            
            
            
        
    end
end
disp('****** Complete ******');
end
%%
% regexp(d(jj).name, expr,'match','once')



