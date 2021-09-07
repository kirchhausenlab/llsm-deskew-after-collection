function dirSink = getSinkDirectories(dirSource, scratch_dirSink, datasync_dirSink)

sinkParentFolder = getSinkParentFolder(dirSource);

dirSink.scratch = [scratch_dirSink filesep sinkParentFolder];
dirSink.ds3_raw = [datasync_dirSink filesep sinkParentFolder 'raw'];
dirSink.ds3_processed = [datasync_dirSink filesep sinkParentFolder 'processed'];

end


function folder = getSinkParentFolder(dirSource)


folder = '';
servers = {
    'tklab-llsm',...
    'AO-llsm',...
    'scratch'
    };
findUsedServer = regexp(dirSource, servers);
usedServerIndex = find(~cellfun(@isempty,findUsedServer));

try
    assert(length(usedServerIndex) == 1)
catch
    error("dirSource does not belong to the servers in tklab")
end

usedServer = servers{usedServerIndex};

endIndex = regexp(dirSource, usedServer,'end');
folder = dirSource(endIndex+1:end);

if isempty(folder)
    error("No Acquisition folder found. Check your dirSource and servers")
end

end

