function Meta = getdsspn(Meta, tline)
if strcmp(Meta.scope, 'llsm')
    if Meta.ds < 0
        marker = regexpi(tline,'S PZT Offset', 'match');
        if (~isempty(marker))
            idx = strfind(tline,':');
            val= str2num(tline(idx+1: end));
            Meta.ds = val(2); % delete spaces
            Meta.planes = val(3);
        end
    end
else
    if Meta.ds < 0
        marker = regexpi(tline,'X Stage Offset', 'match');
        if (~isempty(marker))
            idx = strfind(tline,':');
            val= str2num(tline(idx+1: end));
            Meta.ds = val(2); % delete spaces
            Meta.planes = val(3);
        end
    end
end


end
