function transferRawProcessedDS3(dirSink_ds3, dirSink_ds3_raw, dirSink_ds3_processed)
% check where the LLSCalibration Folder is folder is 
keyword = 'LLSCalib';
folders = findKeywordDFS(dirSink_ds3, keyword);

% move the calibration files
if length(folders) > 1
    return
else
    copyfile(char(folders{1}), [dirSink_ds3_raw filesep 'LLSCalibration'])
    movefile(char(folders{1}), [dirSink_ds3_processed filesep 'LLSCalibration'])
    
    % make transfer flag
    fclose(fopen([dirSink_ds3_raw filesep 'transfer.txt'],'w'));
    
end

% 
% % make the processed folder, no calibration file
% if ~exist(dirSink_ds3_processed, 'dir')
%     mkdir(dirSink_ds3_processed)
% end

end