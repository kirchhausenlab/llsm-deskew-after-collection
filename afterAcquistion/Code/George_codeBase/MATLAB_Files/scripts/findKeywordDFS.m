% breadth first search for keyword Ex v
% search layer by layer

% input: foldir -- directory of the overall acquisition folder
%        example, foldir = '/Volumes/scratch/Gustavo/20201016_p5_p55_sCMOS_Gu'
%
% output: acquisitons -- cell that has the directory to all the Ex folders
%         

% recursively go check each folder if it has the Ex expression, if not, go
% deeper in the layers. Once found/notfound, move on to the next one (Depth First Search)

function acquisitions = findKeywordDFS(foldir,keyword)
keyword;
acquisitions ={};

d = getdir(foldir);
if isempty(d)
    error('****************** No folders found. Check directory ******************');
else
    acquisitions = DFS([foldir], keyword);
end

fprintf('Total folders with the name %s: %02d\n', keyword, length(acquisitions));
% acquisitions{:};
for ii = 1:length(acquisitions)
    fprintf('%s\n', char(acquisitions{ii}))
end
end

function acquisition = DFS(directory, keyword)
acquisition =  {};
d = getdir(directory);
if ~isempty(d)
    expression = keyword;
    for ii = 1:length(d)
        isEx = regexpi(d(ii).name, expression);
        if isEx
            acquisition{end+1,1} = cellstr([directory filesep d(ii).name]);
        else
            acquisitionDFS = DFS([directory filesep d(ii).name], keyword);
            acquisition = [acquisition; acquisitionDFS];
        end
    end
end

end


function directories=getdir(directory)

d = dir(directory);
dd = d([d(:).isdir]);
dd = dd(~ismember({dd(:).name},{'.','..'}));
directories = dd;

end