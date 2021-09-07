function croptiff(fName, tifName , croptoPixX,croptoPixY)

i = readtiff([fName, tifName]);
[x,y,f] = size(i);

if (x ~= croptoPixX) || (y ~= croptoPixY)
    
    
    cropPixX = abs(x-croptoPixX)/2;
    cropPixY = abs(y-croptoPixY)/2;
    
    % make the new tif file
    outputTif = zeros(numel(cropPixX+1:x-cropPixX),numel(cropPixY+1:y-cropPixY),f);
    for ii = 1:size(i,3) % X 
        temp = i(:,:,ii);
        tempNew = temp(cropPixX+1:end-cropPixX,cropPixY+1:end-cropPixY);
        outputTif(:,:,ii) = tempNew;
    end
    
    % save the orginal file into a new folder
    cd(fName);
    if ~exist(strcat(fName,filesep,'Original'))
        mkdir(fName,'Raw not cropped')
        str = sprintf('%s Folder created',fName);
        disp(str)
    end
    if ~exist(strcat(fName,filesep,'Original',filesep,tifName))
        copyfile(tifName, (strcat(fName,filesep,'Original')))
        strFiles = sprintf('%s created',tifName);
        disp(strFiles)
        
    end
    
    
    writetiff(single(outputTif),[fName,filesep, tifName])
else
%    str = sprintf('No crop for %s', [fName,filesep, tifName]);
%    disp(str)
end






