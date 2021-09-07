function Meta = getScope(Meta, tline)

if strcmp(Meta.scope,'llsm')
    marker = 'TKAOSwak';
    if ~isempty(regexp(tline, marker,'match'))
        Meta.scope = 'TKAOSwak';
    end
end
    
    
    
end

