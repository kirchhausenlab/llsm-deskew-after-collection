function setPath(paths)

for ii = 1:length(paths)
    path = char(paths{ii});
    addpath(genpath(path));
    fprintf('Added %s to path\n', path)
end


end
