function Meta = getdsspn(Meta, tline)

% disp(tline);


if Meta.ds < 0
    marker = regexpi(tline,{'S PZT Offset','S Piezo Offset'}, 'match');
    if max(~cellfun(@isempty,marker))
        
        idx = strfind(tline,':');
        val= str2num(tline(idx+1: end));
%         val = val(find(~isspace(val)))
        Meta.ds = val(2); % delete spaces
        Meta.planes = val(3);
    end
end


end
