function chdir= getChdir(Ex_directories)

% disp("******** Check Iteration mode annotation ******** ")
chdir(length(Ex_directories)) = struct();

expr = 'ch*';


for ii = 1:length(Ex_directories)
    counter = 1;
    
    % get all the files in the directory
    d = getdir(char(Ex_directories{ii}));
    
    % check if folder with "ch..."
    for jj = 1:length(d)
        name = d(jj).name;
        flag = regexpi(name,expr);
        if ~isempty(flag)
            chdir(ii).ch{counter,1} = [char(Ex_directories{ii}) filesep name];
            counter = counter + 1;
        end
    end
    
    

    
    
end
% disp("******** Check Iteration mode annotation complete ******** ")


end
