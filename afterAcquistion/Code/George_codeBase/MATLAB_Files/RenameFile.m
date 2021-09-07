

%% RenameFile (first several characters Only)


% Improve code to change the file name
% --- 
% Find the location of the keyword 'Ex0000';
% change that to the Ex111 you want,
% save file
% then move the files into that folder
% delete the old files (if you want);

clc;
% select folder directory with the name Ex00_ ... 
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP107\Interface\CS14\Ex91_488nm_300mW_560nm_500mW_z0p4';
cd(dirFolder);

% put the keyword that you want to change
keyWord = 'ex85';

% put the word you want to replace the keyword
replacementWord = 'ex91';


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

disp('done');

% CS14
clear
clc;
% select folder directory with the name Ex00_ ... 
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP107\Interface\CS14\Ex91_488nm_300mW_560nm_500mW_z0p4';
cd(dirFolder);

% put the keyword that you want to change
keyWord = 'ex85';

% put the word you want to replace the keyword
replacementWord = 'ex90';


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

% cs 13
clear
clc;
% select folder directory with the name Ex00_ ... 
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS12\planeChromatic\Ex89b_488nm_300mW_560nm_500mW_z0p814';
cd(dirFolder);

% put the keyword that you want to change
keyWord = 'ex83b';

% put the word you want to replace the keyword
replacementWord = 'ex89b';


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

clear
clc;
% select folder directory with the name Ex00_ ... 
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS12\Ex89_488nm_300mW_560nm_500mW_z0p4';
cd(dirFolder);

% put the keyword that you want to change
keyWord = 'ex83';

% put the word you want to replace the keyword
replacementWord = 'ex89';


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

% cs 12
clear
clc;
% select folder directory with the name Ex00_ ... 
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP107\Interface\CS14\Ex91_488nm_300mW_560nm_500mW_z0p4';
cd(dirFolder);

% put the keyword that you want to change
keyWord = 'ex';

% put the word you want to replace the keyword
replacementWord = 'ex';


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

% cs 11
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Interface\CS11\Ex84_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex72';
replaceWord = 'ex84';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Interface\CS11\Ex85_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex73';
replaceWord = 'ex85';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Interface\CS11\Ex86_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex74';
replaceWord = 'ex86';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Interface\CS11\Ex87_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex75';
replaceWord = 'ex87';
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Interface\CS11\planeChromatic\Ex74b_488nm_300mW_560nm_500mW_z0p814';
keyWord = 'ex86b';
replaceWord = 'ex74b';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Mitotic\CS11\planeSide\Ex88c_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex85c';
replaceWord = 'ex88c';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Mitotic\CS11\planeSide\Ex88_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex85';
replaceWord = 'ex88';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex63_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex63';
replaceWord = 'ex66';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)



dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex64_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex67';
replaceWord = 'ex64';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)






%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex65_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex68';
replaceWord = 'ex65';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex66_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex69';
replaceWord = 'ex66';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex67_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex70';
replaceWord = 'ex67';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)



dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex68_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex71';
replaceWord = 'ex68';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex69_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex72';
replaceWord = 'ex69';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex70_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex61';
replaceWord = 'ex70';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex71_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex62';
replaceWord = 'ex71';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)



%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex73_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex64';
replaceWord = 'ex73';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex72_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex63';
replaceWord = 'ex72';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


%%

%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex74_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex65';
replaceWord = 'ex74';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)




%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Interface\CS10\Ex72_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex63';
replaceWord = 'ex72';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Mitotic\CS10\volume\Ex75_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex73';
replaceWord = 'ex75';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Mitotic\CS9\planeSide\Ex61c_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex56c';
replaceWord = 'ex61c';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Mitotic\CS9\planeSide\Ex62c_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex57c';
replaceWord = 'ex62c';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Mitotic\CS9\plane\Ex61_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex56b';
replaceWord = 'ex61b';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Mitotic\CS9\plane\Ex62_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex57b';
replaceWord = 'ex62b';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Mitotic\CS9\volume\Ex61b_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex56';
replaceWord = 'ex61';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP107\Mitotic\CS9\volume\Ex62b_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex57';
replaceWord = 'ex62';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

%****
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Mitotic\CS8\planeSide\Ex56c_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex52c';
replaceWord = 'ex56c';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Mitotic\CS8\planeSide\Ex57c_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex51c';
replaceWord = 'ex57c';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


%****2
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Mitotic\CS8\plane\Ex56b_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex52b';
replaceWord = 'ex56b';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Mitotic\CS8\plane\Ex57b_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex51b';
replaceWord = 'ex57b';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)



%****3
dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Mitotic\CS8\volume\Ex56_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex52';
replaceWord = 'ex56';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)

dirFolder = 'C:\Users\tklab\Desktop\New folder\Live\NUP205\Mitotic\CS8\volume\Ex57_488nm_300mW_560nm_500mW_z0p0';
keyWord = 'ex51';
replaceWord = 'ex57';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)



% 1
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP107\Mitotic\CS7\volume\Ex52_560nm_500mW_z0p4';
keyWord = 'ex50';
replaceWord = 'ex52';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)




%2
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP107\Mitotic\CS7\plane\Ex52b_560nm_500mW_z0p0';
keyWord = 'ex50b';
replaceWord = 'ex52b';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)




%3 
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP107\Mitotic\CS7\planeSlide\Ex52c_560nm_500mW_z0p0';
keyWord = 'ex50c';
replaceWord = 'ex52c';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)





dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP107\Interface\CS7\Ex51_560nm_500mW_z0p4';
keyWord = 'ex39';
replaceWord = 'ex51';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)




%%---------------------------------------------------
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP205\Interface\CS6\Ex27_488nm_300mW_560nm_500mW_z0p4';
keyWord = 'ex26';
replaceWord = 'ex27';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)




%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP205\Mitotic\CS6\planeSide\Ex26c_560nm_500mW_z0p4';
keyWord = 'ex24c';
replaceWord = 'ex26c';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)




%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP205\Mitotic\CS6\planeSide\Ex35c_560nm_500mW_z0p4';
keyWord = 'ex27c';
replaceWord = 'ex35c';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)




%2 
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP205\Mitotic\CS6\volume\Ex26_560nm_500mW_z0p4';
keyWord = 'ex24';
replaceWord = 'ex26';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)




%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP205\Mitotic\CS6\volume\Ex34_560nm_500mW_z0p44';
keyWord = 'ex27';
replaceWord = 'ex35';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)




%3
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP205\Mitotic\CS6\plane\Ex25b_560nm_500mW_z0p0';
keyWord = 'ex24b';
replaceWord = 'ex26b';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)




%
dirFolder = 'C:\Users\tklab\Desktop\New folder\Fixed\NUP205\Mitotic\CS6\plane\Ex35b_560nm_500mW_z0p0';
keyWord = 'ex27b';
replaceWord = 'ex35b';
cd('Z:\George\MATLAB_Files')
replacename(dirFolder, keyWord, replaceWord)


