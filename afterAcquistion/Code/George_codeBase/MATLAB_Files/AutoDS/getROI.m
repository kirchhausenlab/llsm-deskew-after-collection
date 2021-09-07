function Meta = getROI(Meta, tline)
% find FOV ROI, store the values, see which ones bigger, subtract
% to get the ROI

if Meta.roi(1) == 0
    marker = regexpi(tline,'FOV ROI', 'match');
    
    left = 'Left=';
    right = 'Right=';
    top = 'Top=';
    bot= 'Bot=';
    roi = zeros(1,4);
    
    if (~isempty(marker))
        r_idx = strfind(tline,right);
        l_idx = strfind(tline,left);
        t_idx = strfind(tline,top);
        b_idx = strfind(tline,bot);
        
        roi = [str2double(tline(r_idx+6:r_idx+10 )), str2double(tline(l_idx+5:l_idx+4 + 4)), str2double(tline(t_idx + 4:t_idx+7)), str2double(tline(b_idx + 4:b_idx+8))]; 
        Meta.roi(1) = abs(roi(1) - roi(2))+1;
        Meta.roi(2) = abs(roi(3) - roi(4))+1;
        
      
    end
end


end
