% first get the dirSink folder

function Calib = getCalibrationParams(dirSource)

% get the Sink Folder
dirSink = getSinkDirectories(dirSource, scratch_dirSink, datasync_dirSink);

% create sink Calibration directory
createSinkCalibrationFolders(dirSink)


% get calibration folder on the parent of SLURM node,
% try
%     str = sprintf('sh /nfs/scratch/George/MATLAB_Files/SLURM_Deskew/scripts/bash/getCalibrationFolder.sh ''%s\''', dirSource);
%     [status, cmdout] = system(str);
%     cmdout_cell = splitlines(cmdout);
%     lastIdx = length(cmdout_cell);
%     while isempty(cmdout_cell{lastIdx})
%         lastIdx = lastIdx - 1;
%     end
%     calibrationFolder = char(cmdout_cell{lastIdx});
% 
% catch
    sourceCalibrationFolder = getCalibrationFolder(dirSource)
% end

disp('Calibration Folder acquired')
% parent process exited



% ----------------------------------------------------------------------
% ----------------------------------------------------------------------

% let the parent fork and create 3 child processes and let it wait until
% all three children have completed their process
% try
%     saveCalibrationParams(sourceCalibrationFolder)
% catch
    cmd_saveCalib = sprintf('sh /nfs/scratch/George/MATLAB_Files/SLURM_Deskew/scripts/bash/saveCalibrationParams.sh ''%s'' ''%s''', sourceCalibrationFolder, dirSink.scratch);
    system(cmd_saveCalib)
    
% end

% try
checkCalibrations(sourceCalibrationFolder);
% catch
% waitFcn = sprintf('/nfs/scratch/George/MATLAB_Files/SLURM_Deskew/scripts/bash/checkCalib.sh ''%s''', sourceCalibrationFolder);
% [status, cmdout] = system(waitFcn);
% end

disp('----------- Acquired calibration parameters -----------')
end





%% Example for parent waiting for the child
% This runs the child in bk and parent process waits to continue to its
% process, including your matlab command window, until the child process is
% compelte
%{ 
'''

str = 'srun matlab -nodisplay -nosplash -nodesktop -nojvm -r ";tic; disp(1); disp(2); pause(5); toc; exit()"';
system(str)

'''


cmdout =

    '
                                 < M A T L A B (R) >
                       Copyright 1984-2020 The MathWorks, Inc.
                   R2020a Update 5 (9.8.0.1451342) 64-bit (glnxa64)
                                    August 6, 2020
     
      
     For online documentation, see https://www.mathworks.com/support
     For product information, visit www.mathworks.com.
      
          1
     
          2
     
     Elapsed time is 5.004851 seconds.
     
                                 < M A T L A B (R) >
                       Copyright 1984-2020 The MathWorks, Inc.
                   R2020a Update 5 (9.8.0.1451342) 64-bit (glnxa64)
                                    August 6, 2020
     
      
     For online documentation, see https://www.mathworks.com/support
     For product information, visit www.mathworks.com.
      
          1
     
          2
     
     Elapsed time is 1.000764 seconds.
     '


%}


%% Example of parent not waiting for the child 
% This runs the child in bk and parent process continues to execute
% including your matlab command window
 %{

'''
str = 'srun matlab -nodisplay -nosplash -nodesktop -nojvm -r ";tic; disp(1); disp(2); pause(5); toc; exit()" & echo hello';
[status, cmdout] = system(str)

cmdout = 'hello'

'''


%}