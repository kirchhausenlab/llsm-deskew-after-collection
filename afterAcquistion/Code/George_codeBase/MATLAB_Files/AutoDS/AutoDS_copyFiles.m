% copy the source folder to the sink folder.

function folSink = AutoDS_copyFiles(dirSource,dirSink)
fprintf('Copying files from the source: %s\n \t to the sink: %s\n', dirSource, dirSink);
idx = strfind(dirSource,filesep);
folName = dirSource(idx(end)+1:end);
if (isempty(folName))
    folName = dirSource(idx(end-1)+1:end);
end

folSink = [dirSink filesep folName];
if ~exist(folSink,'dir')
    mkdir(folSink);
end
d = dir(dirSource);
dd = dir(folSink);

if (length(d) ~= length(dd))
%     copyfile(dirSource, folSink);
    str = timeStr;
    fprintf('%s \t %s copied to %s\n',str, dirSource,folSink);
else
    str = timeStr;
    fprintf('%s \t %s already copied to %s\n',str,dirSource,folSink);
end

end

