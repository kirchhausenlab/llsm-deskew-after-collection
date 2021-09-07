function Meta = getcamflip(Meta, tline)
% find FOV ROI, store the values, see which ones bigger, subtract
% to get the ROI

% if Meta.roi(1) == 0
    marker = regexpi(tline,'Orca4.0 : Image Transform (None, Transpose,','match');
%     disp(tline)
    if (~isempty(marker))
         idx = strfind(tline,char('"Rot 90"'));
         if isempty(idx)
             Meta.camflip = true;
         else 
             Meta.camflip = false;
         end
    end
% end


end
