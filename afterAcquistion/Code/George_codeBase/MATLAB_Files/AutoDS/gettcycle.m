function Meta = gettcycle(Meta, tline)

  marker = regexpi(tline,'Cycle(s','match');
    if (~isempty(marker))
         idx = strfind(tline,char('Cycle(s)'));
        Meta.tcycle = str2double(tline(12:end));
    end



end
