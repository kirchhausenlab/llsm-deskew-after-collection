function calibrationFolder = getCalibrationFolder(dirSource)

LLSCalibFolderNotCreated = true;
while LLSCalibFolderNotCreated
    d = dir([dirSource filesep 'LLSCalib*']);
    if ~isempty(d)
        calibrationFolder = [d.folder filesep d.name];
%         fprintf('Found LLSCalib Folder: %s \n', calibrationFolder);
            disp('Found LLSCalib Folder!')
        break
    end
    disp('Pausing 1 min to check if LLSCalib folder is created...')
    pause(60)
end

disp(calibrationFolder)


end
