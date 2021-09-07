% Check the ratio of the illumination depending on the NA annulus
% Locations of the illum to be checked will be depending on the NA. 
% Locations will be in 9 places, right top, right middle, right bottom,....
%
% Find and save every folder that has the illum file, seprate it by the
% channels 

function illumRatioCheck

% datasync3
d=dir('X:\');
for ii = 1:10%length(d)
    matchStr = regexp(d(ii).name, '\d*', 'once');
    if ~isempty(matchStr)
        disp([d(ii).folder filesep d(ii).name])
    end
        
        
    
end



end
