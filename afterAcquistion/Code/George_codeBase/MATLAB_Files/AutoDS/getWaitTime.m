function  Meta = getWaitTime(Meta, tline)
% -------- THIS IS NOT WAIT TIME ----
marker = regexpi(tline,'Added time (ms) =','match');
disp(tline);
if (~isempty(marker))
%  roi = [str2num(tline(r_idx+6:r_idx+10 )), str2num(tline(l_idx+5:l_idx+4 + 4)), str2num(tline(t_idx + 4:t_idx+7)), str2num(tline(b_idx + 4:b_idx+8))]; 
end

end