function Meta= getStacks(Meta, tline)

if Meta.stacks == 0
    marker = regexpi(tline,'# of stacks', 'match');
    if (~isempty(marker))
        idx = strfind(tline,':');
        val= str2num(tline(idx+1: end));
        Meta.stacks = val(1); % delete spaces
    end
end


end
