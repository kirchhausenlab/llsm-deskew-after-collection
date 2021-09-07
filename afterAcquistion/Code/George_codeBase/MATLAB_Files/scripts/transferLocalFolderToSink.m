function transferLocalFolderToSink(dirSink_ds3_preprocessed, sinkEx)


disp('Transferring to Datasync3 processed');
cEx = char(sinkEx);
sinkFol = get_sinkFol(cEx);
copyfile(cEx, [dirSink_ds3_preprocessed filesep  sinkFol])



end



function sinkFol = get_sinkFol(Ex)

% servers = {
%     'tklab-llsm',
%     'AO-LLSM',
%     'scratch',
%     };
% 
% x = regexp(Ex, servers);
% idx = find(~cellfun(@isempty,x));
% 
% idx_filesep = regexp(Ex, filesep);
% 
% ii = regexp(Ex, servers{idx});
% 
% idx_filesep = idx_filesep(idx_filesep > ii);
% 
% 
% sinkFol  = Ex(idx_filesep(3):end);



cEx = char(Ex);
idx_llsm = regexp(char(Ex), 'tklab-llsm');
idx_ao = regexp(char(Ex), 'AO-LLSM');
idx_scratch = regexp(char(Ex), 'scratch');

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
end

idx_fs = regexp(char(Ex), filesep);
idx_fol = find(idx_fs > idx_source);

sinkFol = cEx(idx_fs(idx_fol(2)):end);


end