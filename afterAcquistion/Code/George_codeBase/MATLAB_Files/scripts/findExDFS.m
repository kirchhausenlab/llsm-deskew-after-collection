% breadth first search for keyword Ex v
% search layer by layer

% input: foldir -- directory of the overall acquisition folder
%        example, foldir = '/Volumes/scratch/Gustavo/20201016_p5_p55_sCMOS_Gu'
%
% output: acquisitons -- cell that has the directory to all the Ex folders
%         

% recursively go check each folder if it has the Ex expression, if not, go
% deeper in the layers. Once found/notfound, move on to the next one (Depth First Search)

function acquisitions = findExDFS(foldir)
acquisitions ={};

d = getdir(foldir);
if isempty(d)
    error('****************** No Ex folders found. Check directory ******************');
end
% for ii = 1:length(d)
%     % get the Ex folder directory, depth first search
%     acquisition = DFS([foldir filesep d(ii).name]);
%     for jj = 1:length(acquisition)
%          acquisitions{end+1,1} = acquisition{jj};
%     end
% end
acquisitions = DFS([foldir ]);


fprintf('Total Ex acquisitions: %02d\n', length(acquisitions));


end

function acquisition = DFS(directory)
acquisition =  {};
d = getdir(directory);
if ~isempty(d)
    expression = 'Ex';
    for ii = 1:length(d)
        isEx = regexp(d(ii).name, expression);
        if isEx
            acquisition{end+1,1} = cellstr([directory filesep d(ii).name]);
        else
            acquisitionBFS = DFS([directory filesep d(ii).name]);
            acquisition = [acquisition; acquisitionBFS];
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