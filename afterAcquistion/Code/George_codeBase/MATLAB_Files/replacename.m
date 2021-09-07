function replacename(dirFolder, keyWord, replacementWord)


% dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP107\Interface\CS14\Ex91_488nm_300mW_560nm_500mW_z0p4';
cd(dirFolder);

% put the keyword that you want to change
% keyWord = 'ex';

% put the word you want to replace the keyword
% replacementWord = 'ex';


files = dir(cd);
for ii = 1:length(files) % for each folder you want to change the name
    % find if the keyWord is a part of the file's name
    fileName = char(files(ii).name)';
    matchWord = regexpi(files(ii).name, keyWord,'match');
    if string(matchWord) == string(keyWord) % if there is a match, then change the name
        oldFileName = char(fileName');
        fileName(1:length(keyWord)) = replacementWord';
        newName = char(fileName');  
         f = fullfile(files(ii).folder, newName);
      g = fullfile(files(ii).folder, oldFileName);
      movefile(g,f);   
    end
end
