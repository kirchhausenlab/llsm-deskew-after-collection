function Meta = getChanAOTFtexp(Meta, tline, numChanPhr,lamda,numChan)

if (regexp(tline,numChanPhr)) % find of the line contains the phrase
    %         disp(lamda)
    for ii = 1:length(lamda) % find the lamda
        lamdai = regexpi(tline, lamda{ii}, 'match');
        
        if (~isempty(lamdai))
            %                 lamdai = lamda{ii}
            break
        end
    end
    if strcmp(Meta.scope, 'llsm')
        idx_powers = strfind(tline,char(lamdai)) + 4;
        val = str2num(tline(idx_powers:end)); % value of aotf and texp
    else
        idx_powers = strfind(tline,char(lamdai))+ 4;
        tline = tline(idx_powers:end);
        V = regexp(tline,'\d*','Match');
        val(1) = str2num(char(V{1}));
        val(2) = str2num(char(V{2}));
    end
    
    if ((Meta.chan(1) ==0)) % add channels
        Meta.chan(end) = str2num(char(lamdai));
        Meta.aotf(end) = val(1);
        Meta.texp(end) = val(2)/1000;
        
    else
        Meta.chan(end+1) = str2num(char(lamdai));
        Meta.aotf(end+1) = val(1);
        Meta.texp(end+1) = val(2)/1000;
    end
    numChan = numChan + 1;
    
end
end
