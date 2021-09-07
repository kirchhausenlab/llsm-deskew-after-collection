function mkdircopyfile(sourceFile, sinkDir)
if ~exist(sinkDir,'dir')
    mkdir(sinkDir)
end
tifName = getTifName(sourceFile);

inSink = exist([sinkDir filesep tifName],'file');

if ~inSink 
    copyfile(sourceFile, sinkDir)
end

end

function tifName = getTifName(tifDir)
ctifDir = char(tifDir);
sepIdx = regexp(ctifDir,filesep);
tifIdx = regexp(ctifDir, '.(?<=.tif)');
tifName = ctifDir(max(sepIdx(sepIdx < tifIdx)) : tifIdx);

end