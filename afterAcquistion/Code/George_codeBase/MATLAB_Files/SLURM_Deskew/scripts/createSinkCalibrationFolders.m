function createSinkCalibrationFolders(dirSink)

fn = fieldnames(dirSink);
for ii = 1:length(fn)
    mkdir([dirSink.(fn{ii}) filesep 'LLSCalibration'])
    fprintf('Created %s \n', char(dirSink.(fn{ii})))
end


end
