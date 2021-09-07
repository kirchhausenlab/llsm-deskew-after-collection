function imPixRawDS = getImagePix(Meta)

imPixRawDS(length(Meta)) = struct;
%%%%%%%%%%% Raw Images %%%%%%%%%%%

% organize to pixels to array
rawPix3D = zeros(length(Meta),3);
for ii = 1:length(Meta)
    rawPix3D(ii,1) = Meta(ii).roi(1);
    rawPix3D(ii,2) = Meta(ii).roi(2);
    rawPix3D(ii,3) = Meta(ii).planes;
end

%%%%%%%%%%% Deskewed Images %%%%%%%%%%%

DSPix3D = zeros(length(Meta),3);
for ii = 1:length(Meta)
    
    % if the sample scan, otherwise we have -1. Meaning was objective scan
    if (Meta(ii).ds > 0)
        DSPix3D(ii,1) = rawPix3D(ii,1);
        
        dy = Meta(ii).ds * cosd(31.5) / 0.104;
        DSPix3D(ii,2) = ceil(rawPix3D(ii,2) + (Meta(ii).planes-1)*dy);
        DSPix3D(ii,3) =  rawPix3D(ii,3);
        
    else
        DSPix3D(ii,1) = -1;
        DSPix3D(ii,2) = -1;
        DSPix3D(ii,3) = -1;
    end
    
end

%%%%%%%%%%% Organize into structure %%%%%%%%%%%

for ii = 1:length(Meta)
    imPixRawDS(ii).raw = rawPix3D(ii,:)  ;
    imPixRawDS(ii).ds = DSPix3D(ii,:);
%     imPixRawDS(ii).name = Meta(ii).name;
%     imPixRawDS(ii).sourcedir = Meta(ii).sourcedir;

end
