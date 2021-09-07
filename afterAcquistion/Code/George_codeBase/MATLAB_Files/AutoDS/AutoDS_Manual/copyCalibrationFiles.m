function copyCalibrationFiles(dirSource, dirSink)

% check where the LLSCalibration Folder is folder is 
keyword = 'LLSCalib';
folders = findDirKeyword(dirSource, keyword);
if length(folders) > 1
    error('%d folders found for %s. \n \tPlease check directory', length(folders),keyword);
else
movefile(char(folders{1}), dirSink)
end


end
