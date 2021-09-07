
% This function should be called in srun/sbatch, and creates 3 child
% processes where the parent waits until 
function checkCalibrations(sourceCalibrationFolder)

% create and run 3 child processes in the background and let the parent
% wait until all are compeleted
d = [sourceCalibrationFolder filesep 'data'];
dir_illum = [d filesep 'illum.mat'];
dir_bk = [d filesep 'bk.mat'];
dir_chroma = [d filesep 'chroma.mat'];

hasIllum = exist(dir_illum,'file');
hasBk = exist(dir_bk, 'file');
hasChroma = exist(dir_chroma,'file');

while ~hasIllum && ~hasBk && ~hasChroma
    pause(60)
    hasIllum = exist(dir_illum,'file');
    hasBk = exist(dir_bk, 'file');
    hasChroma = exist(dir_chroma,'file');
    if ~hasIllum
        fprintf('No illum found in %s\n', dir_illum);
    end
    if ~hasBk
        fprintf('No bk found in %s\n', dir_bk);
    end
    if ~hasBk
        fprintf('No chroma found in %s\n', dir_chroma);
    end
end



end