function applyChromaOffset(Meta)

chan488 = [Meta.dirChan{1} filesep 'DS' filesep '*.tif'];
chan560 = [Meta.dirChan{2} filesep 'DS' filesep '*.tif'];

nF = 5;
ch1 = false;
ch2 = true;



tiff488 = dir(char(chan488));
Top = false;
for ii = 1:length(tiff488)
    Path = [Meta.dirChan{1} filesep 'DS' filesep tiff488(ii).name];
    im = readtiff(Path);
    sizeIM = size(im);
    im2 = zeros([sizeIM]+[0 0 nF]);
    if Top
        im2(:,:,nF+1:end) = im;
    else
        im2(:,:,1:end-nF) = im;
    end
    writetiff((single(im2)),Path);
    
    
end

save(fullfile([Meta.dirChan{1} filesep 'DS'],'ChromaticOffsetApplied.txt'));  


tiff560 = dir(char(chan560));
Top = true;
for ii = 1:length(tiff560)
    Path = [Meta.dirChan{2} filesep 'DS' filesep tiff560(ii).name];
    im = readtiff(Path);
    sizeIM = size(im);
    im2 = zeros([sizeIM]+[0 0 nF]);
    if Top
        im2(:,:,nF+1:end) = im;
    else
        im2(:,:,1:end-nF) = im;
    end
    writetiff((single(im2)),Path);
    
    
end
save(fullfile([Meta.dirChan{2} filesep 'DS'],'ChromaticOffsetApplied.txt'));  






end
