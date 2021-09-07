% breadth first search for keyword Ex 
% search layer by layer

% input: foldir -- directory of the overall acquisition folder
%        example, foldir = '/Volumes/scratch/Gustavo/20201016_p5_p55_sCMOS_Gu'
%
% output: acquisitons -- cell that has the directory to all the Ex folders
%         

% recursively go check each folder in each layer one by one (BFS) and store
% the directory as a string in acquisitions

function acquisitions = findEx(foldir)
acquisitions ={};

d = getdir(foldir);
for ii = 1:length(d)
    % get the Ex folder directory
    acquisition = BFS([foldir filesep d(ii).name]);
    for jj = 1:length(acquisition)
         acquisitions{end+1,1} = acquisition{jj};
    end
end


end

function acquisition = BFS(directory)
acquisition =  {};
d = getdir(directory);

expression = 'Ex';
for ii = 1:length(d)
    isEx = regexp(d(ii).name, expression);
    if isEx
        acquisition{end+1,1} = cellstr([directory filesep d(ii).name]);
    else
        acquisitionBFS = BFS([directory filesep d(ii).name]);
        acquisition = [acquisition; acquisitionBFS];
    end
end

end


function directories=getdir(directory)

d = dir(directory);
dd = d([d(:).isdir]);
dd = dd(~ismember({dd(:).name},{'.','..'}));
directories = dd;

end