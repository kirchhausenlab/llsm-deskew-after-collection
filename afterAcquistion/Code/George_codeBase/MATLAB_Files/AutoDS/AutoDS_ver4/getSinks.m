function Tifdirs = getSinks(acquiredTifs, scratch_dirSink, datasync_dirSink, Exs_llsm_dir)


Tifdirs = struct();
% Tifdirs.source
%           .dir
%           .meta
%           .settingDir

% Tifdirs.sink
%           .dirScratch
%           .dirDS3_raw
%           .dirDS3_processed



% for each tif, have the destination folder

for ii = 1:length(acquiredTifs)
    % ----------------- source -----------------
    Tifdirs.source(ii).tif = acquiredTifs(ii).tif;
    Tifdirs.source(ii).dirSource = {char(Exs_llsm_dir{ii}{1})};
    Tifdirs.source(ii).meta = acquiredTifs(ii).meta;
    Tifdirs.source(ii).dirSetting = getSettingsFile( Tifdirs.source(ii).dirSource ) ;
    
    % ----------------- sink -----------------
    % for each source tif, set the destination folder
    for jj = 1:length(Tifdirs.source(ii).tif)
        sourceParentFol = get_sinkFol_comp(Exs_llsm_dir{ii}, scratch_dirSink);
        
         % get the scratch folder (until CS1_.../)
        sinkDir_scratch = [scratch_dirSink filesep sourceParentFol];
        
        % directories for datasync3
        ds3Dirs = getDS3SinkFol(sourceParentFol);
        sinkDir_ds3 = strcat(datasync_dirSink, ds3Dirs);
        
        % name of the acquried tif. Usually 'Ex00_.... .tif'
        tifName = getTifName(Tifdirs.source(ii).tif{jj});
        
        chanFolName = getChanFol(tifName);
        
        Tifdirs.sink(ii).dirScratch{jj} = [sinkDir_scratch filesep chanFolName ];
        Tifdirs.sink(ii).dirDS3_raw{jj} =  [sinkDir_ds3{1}];
        Tifdirs.sink(ii).dirDS3_processed{jj} = [sinkDir_ds3{2} filesep chanFolName];
    end
    
    
end


end

function dirSettings = getSettingsFile( Ex_directory ) 

settingsSource = [char(Ex_directory{1}) filesep '*Settings*'];
txtFile = dir(settingsSource);
dirSettings = cell(1, length(txtFile));
for ii = 1:length(dirSettings)
    dirSettings{ii} = [txtFile(ii).folder filesep txtFile(ii).name];
end

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
    idx_fs = regexp(cEx, words{words_idx},'start');
    sinkFol = cEx(idx_fs-1:end);
    
else
    
    idx_fs = regexp(char(Ex{1}), filesep);
    idx_fol = find(idx_fs > idx_source);
    sinkFol = cEx(idx_fs(idx_fol(2)):end);
end




end


function tifName = getTifName(tifDir)
ctifDir = char(tifDir);
sepIdx = regexp(ctifDir,filesep);
tifIdx = regexp(ctifDir, '.(?<=.tif)');
tifName = ctifDir(max(sepIdx(sepIdx < tifIdx)) : tifIdx);

end



function chanFolName = getChanFol(tifName)
Chan = {'405','445','488','514','560','592','607','642'};


% ---------- search which channel is used -------------
search_chan = regexpi(tifName, cellfun(@(c)['_' c 'nm_'],Chan,'uni',false));

chanIdx = find(~cellfun(@isempty,search_chan));
assert(length(chanIdx) == 1)

% ------- search which cam is used -----
search_cam = regexpi(tifName, '.(?<=_Cam)');
if isempty(search_cam)
    Cam = 'A';
else
    Cam = tifName(search_cam + 1);
end

assert(Cam == 'A' || Cam == 'B')


% ----------- get the folder name -----------
chanFolName = ['ch' char(Chan{chanIdx}) 'nmCam' Cam] ;

end


function  ds3SinkFol = getDS3SinkFol(sinkFol)
ds3SinkFol = cell(1,2);

fsIdx = regexp(sinkFol, filesep);
ds3SinkFol{1} = [sinkFol(1:fsIdx(2)) filesep 'raw' filesep sinkFol(fsIdx(2)+1:end)];
ds3SinkFol{2} = [sinkFol(1:fsIdx(2)) filesep 'processed' filesep sinkFol(fsIdx(2)+1:end)];

end



