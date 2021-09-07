function deleteChromatxt(data)

nd = numel(data);
for k = 1:nd
    tic
    for j = 1:numel(data(k).channels)
        if exist(fullfile([data(k).channels{j},'DS\'],'ChromaticOffsetApplied.txt'),'file')
        delete(fullfile([data(k).channels{j},'DS\'],'ChromaticOffsetApplied.txt'))
        end
    
    end
    fprintf('Completed %d of %d ',k,nd);
    toc
end

end
