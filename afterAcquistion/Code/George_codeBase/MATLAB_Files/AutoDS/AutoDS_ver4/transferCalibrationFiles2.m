function transferCalibrationFiles2(dirSource, dirSink)

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

    
    idx2 = regexp(C,[filesep 'LLSCalib']);
   
    % delete duplicated filesep -- messes up the folder structure
    keepIdx = true(1, length(idx));
    
    % without the below, 
    %   dirSource = '/scratch/George/AutoDS_data/llsm/20210218_p5_p55_sCMOS_Gu
    %   dirSource = '/scratch/George/AutoDS_data/llsm/20210218_p5_p55_sCMOS_Gu/
    % will yield different sinkCalibFol
    for ii = 1:length(idx)-1
        if idx(ii)+1 == idx(ii+1)
            keepIdx(ii) = false;
        end
    end
    
    startIdx = max(idx(idx2>idx(keepIdx)));

    sinkCalibFol = [ dirSink filesep C(startIdx+1:end) ];
    if ~exist(sinkCalibFol, 'dir')
        mkdir(sinkCalibFol)
    end
    
    fprintf('Copying calibration folders to  %s\n',sinkCalibFol)
    copyfile(char(folders{1}), sinkCalibFol,'f' )
%     new_dirSink =  [ dirSink filesep C(idx(end-1)+1:idx(end)) ];
end

fprintf('Calibration file transfered to: %s\n',dirSink);

end
