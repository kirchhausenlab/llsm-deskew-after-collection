function transferCalibrationFiles2_DS3(dirSource, dirSink)

% check where the LLSCalibration Folder is folder is 
keyword = 'LLSCalib';
folders = findKeywordDFS(dirSource, keyword);
if length(folders) > 1
%     disp(folders{:});
    error('%d folders found for %s. \n \tPlease check directory', length(folders),keyword);
elseif isempty(folders)
    error('No folders found for %s. \n \tPlease check directory', keyword);
else
    %     idx = regexp(dirSource, filesep);
    idx = regexp(char(folders{1}), filesep);

    C = char(folders{1});
    
    idx2 = regexp(C,[filesep 'LLSCalib']);
    
    startIdx = min(idx(idx2<=idx));
    
    % get rid of the filesep at the end of dirSource
    
    while dirSource(end) == filesep
        dirSource(end) = '';
    end
    
    sinkFol = get_sinkFol_comp({dirSource}, dirSink);
    
    if ~exist([ dirSink filesep sinkFol filesep 'raw' filesep C(startIdx+1:end) ], 'dir')
        mkdir([ dirSink filesep sinkFol filesep 'raw' filesep C(startIdx+1:end) ])
    end
    
    t = tic;
    copyfile(char(folders{1}),  [ dirSink filesep sinkFol filesep 'raw' filesep C(startIdx+1:end) ],'f' )
    fprintf('\Transfer time to datasync3/raw/: %dmin, %1.2fsec\n', ceil(toc(t)/60), rem(toc(t),60));
    
     if ~exist([ dirSink filesep sinkFol filesep 'processed' filesep C(startIdx+1:end) ], 'dir')
        mkdir([ dirSink filesep sinkFol filesep 'processed' filesep C(startIdx+1:end) ])
    end
    
%     copyfile(char(folders{1}), [ dirSink filesep sinkFol filesep 'processed' filesep C(idx(end)+1:end) ],'f' )
    copyfile(char(folders{1}), [ dirSink filesep sinkFol filesep 'processed' filesep C(startIdx+1:end) ],'f' )
    fprintf('\Transfer time to datasync3/processed/: %dmin, %1.2fsec\n', ceil(toc(t)/60), rem(toc(t),60));

    
%     new_dirSink =  [ dirSink filesep C(idx(end-1)+1:idx(end)) ];
end

fprintf('Calibration file transfered to: %s\n',dirSink);

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
    idx_Ex = regexp(char(Ex{1}),filesep);
    idx_dirSink = regexp(dirSink,filesep);
    idx_dirSink = idx_dirSink(idx_dirSink <= max(idx_Ex));
    
    % get the words inbetween filesep
    words = cell(1,length(idx_dirSink)-1);
    for ii = 1:length(idx_dirSink)-1
        words{ii} =  cEx(idx_Ex(end-ii)+1:idx_Ex(end-ii+1)-1);
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