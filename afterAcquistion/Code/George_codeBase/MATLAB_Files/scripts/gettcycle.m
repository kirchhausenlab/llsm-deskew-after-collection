function Meta = gettcycle(Meta, tline)

  marker = regexpi(tline,'Cycle(s','match');
    if (~isempty(marker))
         idx = strfind(tline,char('Cycle(s)'));
        Meta.tcycle = 5* ceil(str2double(tline(12:end))*1000/5) /1000;
    end



end
