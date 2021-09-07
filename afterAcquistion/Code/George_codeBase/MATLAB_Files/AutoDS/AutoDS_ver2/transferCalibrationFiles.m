function new_dirSink = transferCalibrationFiles(dirSource, dirSink, transfer_bool)

% check where the LLSCalibration Folder is folder is 
keyword = 'LLSCalib';
folders = findKeywordDFS(dirSource, keyword);
if length(folders) > 1
%     disp(folders{:});
    error('%d folders found for %s. \n \tPlease check directory', length(folders),keyword);
elseif isempty(folders)
    error('No folders found for %s. \n \tPlease check directory', keyword);
else
    %     idx = regexp(dirSource, filesep);
    idx = regexp(char(folders{1}), filesep);
    C = char(folders{1});
    if transfer_bool
        copyfile(char(folders{1}), [ dirSink filesep C(idx(end-1)+1:end) ],'f' )
    end
    new_dirSink =  [ dirSink filesep C(idx(end-1)+1:idx(end)) ];
end

if transfer_bool
    disp('transfered');
end

end
