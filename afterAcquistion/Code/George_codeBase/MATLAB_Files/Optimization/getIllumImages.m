function I = getIllumImages(I_directory)

Cam = {'CamA','CamB'};
Chan = {'405','445','488','514','560','592','607','642'};

I = I_directory;
directories =I_directory.chan;
% I.tif_av = cell(size(I.chan));
  
keys = {};
values = {};
usedChan = {};
for ii = 1:size(directories, 1)
    for jj = 1:size(directories,2)
        if ~isempty(I.chan{ii,jj})
            name = sprintf('ch%snm%s',Chan{jj}, Cam{ii});
            usedChan{end+1} = name;
            LSImage = readtiff([I.dir filesep I.chan{ii,jj}]);
            averaged_LSImage = squeeze(mean(LSImage,3));
            
            keys{end+1} = name;
            values{end+1}= {averaged_LSImage};

        end
    end
end

I.tif_av = containers.Map(keys,values);
I.keys = usedChan;

end
