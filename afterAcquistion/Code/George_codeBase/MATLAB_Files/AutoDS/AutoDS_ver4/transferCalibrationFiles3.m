function transferCalibrationFiles3(dirSource, dirSink, dirAcquisition)

% check where the LLSCalibration Folder is folder is 
keyword = 'LLSCalib';
folders = findKeywordDFS(dirSource, keyword);
if length(folders) > 1
%     disp(folders{:});
    error('%d folders found for %s. \n \tPlease check directory', length(folders),keyword);
elseif isempty(folders)
    error('No folders found for %s. \n \tPlease check directory', keyword);
else

    idx = regexp(char(folders{1}), filesep);

    C = char(folders{1});
    
    idx2 = regexp(C,[filesep 'LLSCalib']);
    
    startIdx = min(idx(idx2<=idx));
    
    sinkCalibFol = [ dirSink filesep dirAcquisition filesep C(startIdx+1:end) ]
    if ~exist(sinkCalibFol, 'dir')
        mkdir(sinkCalibFol)
    end
    
    fprintf('Copying calibration folders to  %s\n',sinkCalibFol)
    copyfile(char(folders{1}), sinkCalibFol,'f' )
%     new_dirSink =  [ dirSink filesep C(idx(end-1)+1:idx(end)) ];
end

fprintf('Calibration file transfered to: %s\n',dirSink);

end
