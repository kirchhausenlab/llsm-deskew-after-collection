function copyToDatasync3(dirSource, dirSink_ds3_raw,keyword)


for ii = 1:length(Exs)
    Ex = Exs{ii};
    
    idx_scratch =regexp(char(Ex), 'scratch');
    idx_fs =regexp(char(Ex), filesep);
    f = find(idx_fs > idx_scratch);
    charEx = char(Ex);
    folname = charEx(idx_fs(f(3)):end);
    
        fprintf('Copy %s \nto %s\n', char(Ex), [dirSink_ds3_raw folname])

    copyfile(char(Ex), [dirSink_ds3_raw folname])
end


end