function Ntp = gettimepoints(Ex_directories,Meta)
Ntp(length(Ex_directories)) = struct();
for ii=1:length(Ex_directories)
    d=getdir(char(Ex_directories{ii}));
    Ntp(ii).chan = Meta(ii).chan;
    
    % for each channel
    for jj = 1:length(d)
        dd = dir([char(Ex_directories{ii}) filesep d(jj).name filesep '*.tif']);
        Ntp(ii).stacks(jj) = length(dd);
        Ntp(ii).sourcedir{jj} = {[char(Ex_directories{ii}) filesep d(jj).name filesep '*.tif']};
    end

end

end