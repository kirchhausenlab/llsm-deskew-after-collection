%deskewFrame3D(vol, angle, dz, xyPixelSize, varargin)
% Applies a shear transform to convert raw light sheet microscopy data
% into a volume with real-world coordinates.
%
% Inputs:
%           vol : raw data volume
%         angle : scanning angle of the system (in degrees)
%            dz : distance between acquisition planes (z-step), in �m
%   xyPixelSize : pixel size in object space, in �m
%
% Options:
%       reverse : {true}|false, selects scanning direction
%                 true: top right to bottom left
%                 false: top left to bottom right
%
% Parameters:
%        'Crop' : {true}|false crops the transformed volume at 50% of the
%                 outermost image planes
%      'Interp' : {'cubic'}|'linear' interpolation mode.
%
% See also imwarp

% Francois Aguet 09/2013 (last modified 08/2014)
% edited Gokul Upadhyayula, Oct 2015

function volout = AutoDS_deskewFrame3D20191117(vol, skewAngle, dz, xyPixelSize, reversed)

% ip = inputParser;
% ip.CaseSensitive = false;
% ip.addRequired('vol');
% ip.addRequired('angle'); % typical value: 32.8
% ip.addRequired('dz'); % typical value: 0.2-0.5
% ip.addRequired('xyPixelSize'); % typical value: 0.1
% ip.addOptional('reverse', false, @islogical);
% ip.addParamValue('Crop', true, @islogical);
% ip.addParamValue('Interp', 'linear', @(x) any(strcmpi(x, {'cubic', 'linear'})));
% ip.parse(vol, angle, dz, xyPixelSize, varargin{:});

ip.Results.Interp = 'linear';

[ny,nx,nz] = size(vol);
ip.Results.angle = skewAngle;
theta = ip.Results.angle * pi/180;
dx = cos(theta)*dz/xyPixelSize; % pixels shifted slice to slice in x

ip.Results.reverse = reversed;
if ~ip.Results.reverse
    xshift = -dx;
    xstep = dx;
else
    xshift = dx + ceil((nz-1)*dx);
    xstep = -dx;
end
nxOut = ceil((nz-1)*dx) + nx; % width of output volume

% % % remove the crop section, or we lose data //GU
% if ip.Results.Crop
%     if nxOut>=2*nx
%         cropWidth = floor(nx/2);
%     else
%         cropWidth = floor(ceil((nz-1)*dx)/2);
%     end
%     xshift = xshift - cropWidth;
%     nxOut = nxOut - cropWidth*2;
% end

% shear transform matrix
S = [1 0 0 0;
    0 1 0 0;
    xstep 0 1 0;
    xshift 0 0 1];
tform = affine3d(S);

RA = imref3d([ny nxOut nz], 1, 1, 1);
% volout = imwarp(vol, tform, ip.Results.Interp, 'FillValues', 0, 'OutputView', RA);



% % Edit KGO, calculate mean plane intensity for the background
volout = imwarp(vol, tform, ip.Results.Interp, 'FillValues', 0, 'OutputView', RA);
% volout(volout==0)=mean;

% for ii = 1:size(vol,3)
%     meanFillValues = squeeze(mean(mean(volout(:,:,ii))));
%     [x,y] = find((volout(:,:,ii) < 0));
%     volout(x,y,ii) = meanFillValues;
% end
% for ii = 1:1%size(vol,3)
%     tic
%     meanFillValues = squeeze(mean(mean(volout(:,:,ii))));%.*ones(size(volout(:,:,ii)));
%     toc
%     tic
%     [x,y] = find(volout(:,:,ii) ~= 0);
%     toc
%     tic
%     volout(x,y,ii) = meanFillValues; % Most time consuming
%     toc
% %     [x,y] = find((volout(:,:,ii) < 0));
% %     volout(x,y,ii) = meanFillValues;
% end

% % % % % % % average of the raw image
% % % % % % for ii = 1:size(vol,3)
% % % % % %     planeVals = (vol(:,:,ii));
% % % % % %     meanPlaneVals = mean(planeVals(:));
% % % % % %     meanFillValues = meanPlaneVals.*ones(size(volout(:,:,ii)));
% % % % % %     [~,y] = find(volout(1,:,ii) ~= 0);
% % % % % %     idy = y(1);
% % % % % %     meanFillValues(:,idy:nx+idy-1) = vol(:,:,ii);
% % % % % %     volout(:,:,ii) = meanFillValues;
% % % % % % end



bkOpt = 2;
modePlaneVals = -1;
switch bkOpt
    case  1
        % BACKGROUND = MODE OF EACH PLANCE
        % Each plane has different bk value
        for ii = 1:size(vol,3)
            planeVals = (vol(:,:,ii));
            %     figure(1);
            %     histogram(planeVals(:),2000);
            modePlaneVals = mode(planeVals(:));
            modeFillValues = modePlaneVals.*ones(size(volout(:,:,ii)));
            [~,y] = find(volout(1,:,ii) ~= 0);
            idy = y(1);
            modeFillValues(:,idy:nx+idy-1) = vol(:,:,ii);
            volout(:,:,ii) = modeFillValues;
            %     figure(2);
            %     imagesc(modeFillValues)
        end
        
        
    case  2
        % BACKGROUND = MEDIAN OF THE EACH STACK
        % each plane has the same value
        % check for -1. If negative, calculate the value
        if (modePlaneVals < 0) 
            planeVals = vol(:,:,:);
            %     figure(1)154.;
            
            %     histogram(planeVals(:),2000);
           modePlaneVals = median (planeVals(:));
        end
         
        for ii = 1:size(vol,3)
            modeFillValues = modePlaneVals.*ones(size(volout(:,:,ii)));
            [~,y] = find(volout(1,:,ii) ~= 0);
            idy = y(1);
            modeFillValues(:,idy:nx+idy-1) = vol(:,:,ii);
            volout(:,:,ii) = modeFillValues;
            %     figure(2);
            %     imagesc(modeFillValues)
        end
end
            


% % NOTCOMPLETED: average of the last 5 pixels left and right
% for ii = 1:size(vol,3)
% %     meanFillValues = squeeze(mean(mean(volout(:,:,ii)))).*ones(size(volout(:,:,ii)));
%     [~,y] = find(volout(1,:,ii) ~= 0);
%     if ii > 1 && y(1) <= 5
%          idx_left = y(1):y(ii);
%          idx_right = y(end-5:end);
%     elseif  y(end) - y(ii) <= 5 && ii < nx
%         idx_right = y(ii) : y(nx);
%         idx_left = y(1):y(5);
%     elseif ii == 1 || ii == size(vol,3)
%         return
%     else
%         idx_left = y(1):y(5);
%         idx_right = y(end-5:end);
%     end
%     
%     leftvol = vol(:,idx_left,ii);
%     rightvol = vol(:,idx_right,ii);
%     
%     meanFillValuesLeft = mean(leftvol(:)).*ones(size(volout(1:y(1),:,ii))); %left handside
%     meanFillValuesRight = mean(rightvol(:).*ones(size(volout(y(ii):y(end),:,ii))); % Right handsize
% 
%     volout(:,:,ii) = meanFillValues;
% end





