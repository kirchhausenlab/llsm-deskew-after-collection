function Meta = getZmotion(Meta,tline)
        zmotion = regexpi(tline,'Z motion', 'match');
        if (~isempty(zmotion))
            idx = strfind(tline,char(zmotion));
            Meta.zmotion = tline(idx+length('Z motion') + 2: end);
            Meta.zmotion = strtrim( Meta.zmotion); % delete spaces
        end
end
