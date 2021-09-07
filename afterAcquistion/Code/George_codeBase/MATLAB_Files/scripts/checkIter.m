function checkIter(Ex)
% input needs to be type cell

cEx = char(Ex{1});
d = dir([cEx filesep '*.tif']);

for ii = 1:length(d)
    name = d(ii).name;
    
    % get Iter_N_'s N
    Iter_N = regexp(name,'((?<=_Iter_)\d+(?=_))','match','once');
    Iter_dN = sprintf('%04d',str2num(Iter_N));
    
    % split name into two
    left_idx = regexp(name,'Iter_','end');
    if isempty(left_idx)
        break
    else
        right_idx = left_idx + length(Iter_N)+1;
        newName = [name(1:left_idx) Iter_dN name(right_idx:end)];
        if ~exist( [d(ii).folder filesep newName],'file')
            movefile([d(ii).folder filesep d(ii).name], [d(ii).folder filesep newName],'f')
        end
    end
    
end




end