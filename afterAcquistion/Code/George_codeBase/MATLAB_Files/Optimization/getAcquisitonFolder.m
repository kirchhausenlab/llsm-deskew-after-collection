function dirAcquisiton = getAcquisitonFolder(dirSource)

keywords = {
    'tklab-llsm',
    'AO-LLSM',
    'scartch',
    };
findKeyword = regexp(dirSource, keywords,'match');
keywordsIdx = ~cellfun(@isempty,findKeyword);


try
    assert(sum(keywordsIdx) == 1)
catch
    error('Please check dirSource\n needs to match the /llsm/ directory or /scratch directory ')
end

server = char(keywords{keywordsIdx});

acqIdx = regexpi(dirSource, server,'end');
dirAcquisiton = dirSource(acqIdx+1:end);



end