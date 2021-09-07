function [dirSink_ds3_raw, dirSink_ds3_processed] = getDS3Directories(dirSource, dirSink)

% sinkFol = get_sinkFol_comp({dirSource}, dirSink);

sinkFol=getSinkParentFolder(dirSource);


dirSink_ds3_raw = [ dirSink filesep sinkFol filesep 'raw'] ;

dirSink_ds3_processed = [ dirSink filesep sinkFol filesep 'processed'];

dirSink_ds3.raw = dirSink_ds3_raw;
dirSink_ds3.processed = dirSink_ds3_processed;



end



function folder = getSinkParentFolder(dirSource)


folder = '';
servers = {
    'llsm',...
    'AO-llsm',...
    'scratch'
    };
findUsedServer = regexp(dirSource, servers);
usedServerIndex = find(~cellfun(@isempty,findUsedServer));

try
    assert(length(usedServerIndex) == 1)
catch
    error("dirSource does not belong to the servers in tklab")
end

usedServer = servers{usedServerIndex};

endIndex = regexp(dirSource, usedServer,'end');
folder = dirSource(endIndex+1:end);

if isempty(folder)
    error("No Acquisition folder found. Check your dirSource and servers")
end

end



function sinkFol = get_sinkFol_comp(Ex, dirSink)

%% get the sink folder name
sinkFol = '';
cEx = char(Ex{1});
lattice = 'tklab-llsm';
AO = 'AO-LLSM';
scratch = 'scratch';
idx_llsm = regexp(cEx, lattice);
idx_ao = regexp(cEx, AO);
idx_scratch = regexp(cEx, scratch);

folder_flag = 0;

if (~isempty(idx_llsm) + ~isempty(idx_scratch) + ~isempty(idx_ao)) == 0
    error('Check that [Ex] is from llsm, ao or scratch. None are found')
elseif  (~isempty(idx_llsm) + ~isempty(idx_scratch) + ~isempty(idx_ao)) > 1
    error('Check that [Ex] is from llsm, ao or scratch. More than 1 found')
else
    if ~isempty(idx_llsm)
        idx_source = idx_llsm;
        keyword = lattice;
    elseif ~isempty(idx_scratch)
        idx_source = idx_scratch;
        keyword = scratch;
    else
        idx_source = idx_ao;
        keyword = AO;
    end
    
    while dirSink(end) == filesep
        dirSink(end) = '';
    end
    
    idx_Ex = regexp(char(Ex{1}),filesep);
    idx_dirSink = regexp(dirSink,filesep);
    idx_dirSink = idx_dirSink(idx_dirSink <= max(idx_Ex));
    
    % get the words inbetween filesep
%     words = cell(1,length(idx_dirSink)-1);
    for ii = 1:length(idx_dirSink)-1
        words = cEx(idx_Ex(ii)+1: idx_Ex(ii+1)-1);
        if strcmp(char(words), keyword)
            sinkFol = cEx(idx_Ex(ii+1):end);
            break
        end
    end
    if isempty(sinkFol)
        idx_fs = regexp(char(Ex), filesep);
        idx_fol = find(idx_fs > idx_source);
        sinkFol = cEx(idx_fs(idx_fol(2)):end);
    end
    if strcmp(sinkFol,filesep) || isempty(sinkFol)
        error("Check the lattice directory %s\n", cEx)
    end
    
    
%     words
%     
%     % check if there are word match
%     for ii = 1:length(words)
%         if ~isempty(regexp(dirSink, words{ii}))
%             words_idx = ii;
%             folder_flag = 1;
%             break;
%         else
%             words_idx = idx_source;
%             
%         end
%     end
    
% end
% 
% if folder_flag
%     idx_fs = regexp(cEx, words{words_idx},'end');
%     sinkFol = cEx(idx_fs+1:end)
%     
% else
%     
%     idx_fs = regexp(char(Ex), filesep);
%     idx_fol = find(idx_fs > idx_source);
%     sinkFol = cEx(idx_fs(idx_fol(2)):end)
% end
end

end