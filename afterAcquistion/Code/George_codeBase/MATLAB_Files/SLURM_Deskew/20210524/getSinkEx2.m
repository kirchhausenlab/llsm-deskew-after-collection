function sinkEx = getSinkEx2(dirSink, Ex)
 sinkFol = get_sinkFol_comp(Ex, dirSink)
 sinkEx = cellstr([dirSink filesep sinkFol]);

end
function sinkFol = get_sinkFol_comp(Ex, dirSink)

%% get the sink folder name

cEx = char(Ex{1});
idx_llsm = regexp(cEx, 'tklab-llsm');
idx_ao = regexp(cEx, 'AO-LLSM');
idx_scratch = regexp(cEx, 'scratch');

folder_flag = 0;

if (~isempty(idx_llsm) + ~isempty(idx_scratch) + ~isempty(idx_ao)) == 0
    error('Check that [Ex] is from llsm, ao or scratch. None are found')
elseif  (~isempty(idx_llsm) + ~isempty(idx_scratch) + ~isempty(idx_ao)) > 1
    error('Check that [Ex] is from llsm, ao or scratch. More than 1 found')
else
    if ~isempty(idx_llsm)
        idx_source = idx_llsm;
    elseif ~isempty(idx_scratch)
        idx_source = idx_scratch;
    else
        idx_source = idx_ao;
    end
    if dirSink(end) ~= filesep
        dirSink(end+1) = filesep;
    end
    idx_dirSink = regexp(dirSink,filesep);
    
    % -----------------
    deleteIdx_dirSink = true(1, length(idx_dirSink));
    for ii = 2:length(idx_dirSink)
        if idx_dirSink(ii-1) +1 == idx_dirSink(ii)
            deleteIdx_dirSink(ii) = false;
        end
    end
    
    idx_dirSink = idx_dirSink(deleteIdx_dirSink);
    % ---------------
    
    words = cell(1, length(idx_dirSink) -1);
    for ii = 1:length(idx_dirSink)-1
%         words{ii} =  cEx(idx_Ex(end-ii)+1:idx_Ex(end-ii+1)-1);
        words{ii} = dirSink(idx_dirSink(end-ii)+1:idx_dirSink(end-ii+1)-1);
    end

    
    % check if there are word match
    for ii = 1:length(words)
        if ~isempty(regexp(cEx, words{ii}))
            words_idx = ii;
            folder_flag = 1;
            break;
        else
            words_idx = idx_source;
            
        end
    end
          
end

if folder_flag
    idx_fs = regexp(cEx, words{words_idx},'end');
    sinkFol = cEx(idx_fs+1:end);
    
else
    
    idx_fs = regexp(char(Ex), filesep);
    idx_fol = find(idx_fs > idx_source);
    sinkFol = cEx(idx_fs(idx_fol(2)):end);
end

end


function bool = exist_chFol(dirSink, sinkFol, d)
Chan = {'405','445','488','514','560','592','607','642'};
search_chan = regexpi(d.name, cellfun(@(c)['_' c 'nm_'],Chan,'uni',false));
find_chan = find(~cellfun(@isempty,search_chan));

d_ch = char(Chan{find_chan});

if ~regexpi([dirSink, filesep, sinkFol, filesep, ['ch' d_ch '*']], 'dir')
    % if directory does not exist (ch488nm, ch560,...
    bool = false;
else
    d_chSource = [dirSink, filesep, sinkFol];
    d_chfol = dir([dirSink, filesep, sinkFol, filesep, ['ch' d_ch '*']]);
    assert(length(d_chfol) < 2)
    
    % check if tif is in the subfolder
    if isempty(d_chfol)
        bool = false;
        return
    else
        if exist([d_chSource filesep d_chfol(1).name filesep d(1).name],'file')
            bool = true;
        else
            bool = false;
        end
    end
end
end




