function B = getBkImages(B_directories)

Cam = {'CamA','CamB'};
% Chan = {'405','445','488','514','560','592','607','642'};
directories = B_directories;

keys = {};
values = {};
usedCam = {};

for ii = 1:size(directories, 1)
    if ~isempty(B_directories{ii})
%         name = sprintf('ch%snm%s',Chan{jj}, Cam{ii});
        charBk = char(B_directories{ii});
        cam_idx = regexp(char(B_directories{ii}), '_(Cam[AB])_');
        name = charBk(cam_idx+1:cam_idx+4);
        usedCam{end+1} = name;
        BKImage = readtiff(charBk);
        averaged_BKImage = squeeze(mean(BKImage,3));
        
        keys{end+1} = name;
        values{end+1}= {averaged_BKImage};
        
    end
end


B.keys = usedCam;
B.tif_av = containers.Map(keys,values);



end
