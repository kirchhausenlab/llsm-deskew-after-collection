function saveIllumParam(sourceCalibrationFolder, dirSink_scartch)

% dir is not case sensitive, but needs to be in 'nB_dither'
d = dir([sourceCalibrationFolder filesep 'illum' filesep 'nB_Dither' filesep '*.tif']);

% num of tifs 
N = length(d);

keys = {};
values = {};

% check if tif images have finished collecting, if true save it to a
% hashMap


for ii = 1:N
    tif = [d(ii).folder filesep d(ii).name ]
    
    % wait until tif finished collecting
    fclose(fopen(tif));
    
    % find the key, value for hashMap
    expression = '_(Cam[AB])_.*._(\w+)nm_';
    [tokens,~] = regexp(tif, expression,'tokens','match');
    key=sprintf('ch%snm%s',char(tokens{1}{2}), char(tokens{1}{1}));
    if isempty(strcmp(keys, key)) || ~max(strcmp(keys, key))
        keys{end+1} = key;
        
        LSImage = readtiff(tif);
        averaged_LSImage = squeeze(mean(LSImage,3));
        values{end+1}= {averaged_LSImage};
        
    end
end

I.tif_av = containers.Map(keys,values);
I.keys = keys;

save

end

