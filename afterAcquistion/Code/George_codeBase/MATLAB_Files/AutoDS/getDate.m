function Meta = getDate(Meta, tline)

if (isempty(Meta.date))
    marker = regexpi(tline,'Date', 'match');
    if (~isempty(marker))
        idx = strfind(tline,':');
        Meta.date = (tline(idx+1: end));
        Meta.date = strtrim( Meta.date);
    end
end
end
