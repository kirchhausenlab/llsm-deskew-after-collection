function Meta = transferSettingsFile(Ex, scratchSinkFol, dirSink_ds3_raw, dirSink_ds3_processed)

cEx = char(Ex);

acquisitionFolder = getAcquistionFolder(Ex, scratchSinkFol)

% if the settings file is found\

while true
    d = dir([cEx filesep '*Settings.txt']);
    try
        settingsFile = [d.folder filesep d.name];
        copyfile(settingsFile, ) % scratch
        copyfile() % ds3_raw
        copyfile() % ds3_scratch
        
        
        Meta = getMeta2()
        
        break
        
    catch
        pause(60)
        
    end
end

    
    


end

function acquisitionFolder = getAcquistionFolder(Ex, scratchSinkFol)
cEx = char(Ex);




end

