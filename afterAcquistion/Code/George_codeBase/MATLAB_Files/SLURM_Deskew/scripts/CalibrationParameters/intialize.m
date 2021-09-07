%{
dirSink =

struct with fields:

scratch: '/scratch/George///20210507_p5_p55_sCMOS_Alex/'
ds3_raw: '/nfs/data1expansion/datasync3/George///20210507_p5_p55_sCMOS_Alex/raw'
ds3_processed: '/nfs/data1expansion/datasync3/George///20210507_p5_p55_sCMOS_Alex/processed'

%}

function intialize(dirSource)

% Check if LLSCalibration folder is created
calibrationFolder = getCalibrationFolder(dirSource);

% Check if background has been acquired
Bk = getBackground(calibrationFolder);

% check if illumination correction has been acquired
LLFF = getLLFF(calibrationFolder);

%%

% check if chromatic offset has been acquired
while true
    
end


% Compile calibration files into a structure
Calib = 0;



end

function calibrationFolder = checkCalibrationFolderCreated(dirSource)
LLSCalibFolderNotCreated = true;
while LLSCalibFolderNotCreated
    d = dir([dirSource filesep 'LLSCalib*']);
    if ~isempty(d)
        calibrationFolder = [d.folder filesep d.name];
        disp('Found LLSCalib Folder!')
        break
    end
    disp('Pausing 1 min to check if LLSCalib folder is created...')
    pause(60)
end

end


function Bk = getBackground(calibrationFolder)

% dzSelect = '(?<=_zp)\d+|(?<=_z0p)\d+|(?<=zint_0p)\d+';
% backgroundSelect = '(bk)|(background)|(dark)';
backgroundSelect = {
    'bk',...
    'background',...
    'dark'
    };
backgroundNotAcquired = true;

while backgroundNotAcquired
    for ii = 1:length(backgroundSelect)
        d = dir([calibrationFolder filesep backgroundSelect{ii} filesep '*tif']);
        if ~isempty(d)
            disp('Found background images!')
            
            % check if images have completing collecting
            for jj = 1:length(d)
                backgroundImage = [d(jj).folder filesep d(jj).name ];
                fclose(fopen(backgroundImage));
                Bk{jj} = backgroundImage;
            end
            
            backgroundNotAcquired = false;
            break
        end
    end
    if backgroundNotAcquired
        disp('Pausing 1 min to check if background images were collected...')
        pause(60)
    end
end



end



function LLFF = getLLFF(calibrationFolder)



LLFFNotAcquired = true;
while LLFFNotAcquired
    for ii = 1:length(backgroundSelect)
        d = dir([calibrationFolder filesep 'illum' filesep 'nB_Dither' filesep '*tif']);
        if ~isempty(d)
            disp('Found illumination correction images!')
            
            % check if images have completing collecting
            for jj = 1:length(d)
                LLFFImage = [d(jj).folder filesep d(jj).name ];
                fclose(fopen(LLFFImage));
                LLFF{jj} = LLFFImage;
            end
            
            LLFFNotAcquired = false;
            break
        end
    end
    if LLFFNotAcquired
        disp('Pausing 1 min to check if background images were collected...')
        pause(60)
    end
end



end