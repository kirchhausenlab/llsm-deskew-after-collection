function   [dirAcq] = findAcquistionFolder(c,dirSource, foundAcq)

while (~foundAcq)
    fprintf('Finding where Ex%02d is taking place...\n', c);
    str = sprintf('Ex%02d_',c);
%     if ExNum > 0
        files = dir([dirSource filesep '**' filesep str '*']);
%     else
%         files = dir([dirSource filesep '*' filsesep str '*']);
%     end
    if (~isempty(files) && foundAcq == 0)
        str_time = timeStr;
        % files(1) because (1) is folder, (2) is the settings file
        fprintf('%s \t %s found %s \n',str_time, str, files(1).folder);
        % copy settings file to the sink
        dirAcq=[files(1).folder filesep files(1).name];
        
        foundAcq = 1;
    end
    pause(5);
    
end

end