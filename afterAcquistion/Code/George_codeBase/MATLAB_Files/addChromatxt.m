function addChromatxt(data)

nd = numel(data);
for k = 1:nd
    tic
    for j = 1:numel(data(k).channels)
        if ~exist(fullfile([data(k).channels{j},'DS' filesep],'ChromaticOffsetApplied.txt'),'file')
             save(fullfile([data(k).channels{j},'DS' filesep],'ChromaticOffsetApplied.txt'));  
        end
    end
    fprintf('Chroma txt added %d of %d ',k,nd);
    toc
end

end