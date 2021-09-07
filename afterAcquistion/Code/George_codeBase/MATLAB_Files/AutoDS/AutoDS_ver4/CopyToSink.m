function CopyToSink(TifDirs)

% copy each tif into the destination
for ii = 1:length(TifDirs.source)
    for jj = 1:length(TifDirs.source(1).tif)
        
        mkdircopyfile(TifDirs.source(1).tif{jj}, TifDirs.sink(1).dirScratch{jj})
        mkdircopyfile(TifDirs.source(1).tif{jj}, TifDirs.sink(1).dirDS3_raw{jj})
        mkdircopyfile(TifDirs.source(1).tif{jj}, TifDirs.sink(1).dirDS3_processed{jj})
        
    end
end



end