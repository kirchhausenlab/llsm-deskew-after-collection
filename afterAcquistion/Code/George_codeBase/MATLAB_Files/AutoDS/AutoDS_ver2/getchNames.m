function chNames = getchNames(Ex_directory)
folders = getdir(char(Ex_directory));

chNames = '';
% counter = 1;

for ii=1:length(folders)
    folder = folders(ii);
    chfolderFlag = regexpi(folder.name, 'ch');
    
    if chfolderFlag
        chNames{end+1} = cellstr(string(folder.name));
%         counter = counter +1;
        
    end


end