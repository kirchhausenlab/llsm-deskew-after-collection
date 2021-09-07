% Transfer N-1 images
% for the Nth image, check if the size of the file is the same as the
% previous one

% ---------------------------------
% Descriptions
%   As images are colleted on llsm, transfer the completed images to the
%   destination. Output the image directories

% ----------------------------------
% Assumptions
%   1. Images are considered to be completed, if the size of the image in
%   bytes are >= to the previous images
%   2. Transfer the images only when we see more than one image (if we
%   collect 10 image, transfer 9 images first), get the bytes of all the
%   images and save the min value

function transferLocalToSink_auto(scratch_dirSink,datasync_dirSink, Exs_llsm_dir, OnlyDeskewFirstStack, dirSource, I, B, C)

   
%% version 1
% %     fullImgs = struct();
%     % get all the tif images regardless of if the tif has completed the
%     % scan or not
%     
%     allTifs = getAllTifs(Exs_llsm_dir);
%    
%     % check which tif completed the acquisition
%     acquiredTifs = getAcquiredTifs(allTifs, OnlyDeskewFirstStack);
%     
%     % organize the source and the sink directorys
%     TifDirs = getSinks(acquiredTifs, scratch_dirSink, datasync_dirSink, Exs_llsm_dir);
%     
%     disp(1)
%     % transfer the tifs to the destination
%     CopyToSink(TifDirs)
%     
%     % Deskew and apply chromatic offset
%     preprocess2(TifDirs)
    
    
    %% version 2
    %{
    tif{1}
        .source             = directory
        .sink 
            .scratch        = directory
            .ds3raw         = directory
            .ds3processed   = directory

        .meta               = metadata
    %}
    
    
    clc;
     % get all the tif images regardless of if the tif has completed the
%     % scan or not
     allTifs = getAllTifs(Exs_llsm_dir);
     
      % check which tif completed the acquisition
     acquiredTifs = getAcquiredTifs(allTifs, OnlyDeskewFirstStack);
              
% % %      % organize tif structure -- NOT COMPLETED
% % %      tif = organizeTif(acquiredTifs, scratch_dirSink,datasync_dirSink, dirSource, Exs_llsm_dir)

    % transfer acquiredTifs to sink
    copyToScratch(acquiredTifs, scratch_dirSink, Exs_llsm_dir)
    
    % transfer acquiredTifs to datasync3
    copyToScratch(acquiredTifs, datasync_dirSink, Exs_llsm_dir)
    
    % get the scratch acquisition folder directory
    dirScratch_acquiredTifs = get_dirScratch_acquiredTifs()
    
    % get the data
    for ii = 1:length(dirScratch_acquiredTifs
    data = AutoGU_loadConditionData3D(sinkEx)

end




% tif dir should be 
%{
data.dir

{ [scratchDir(to be deskewed)],  [DS3_raw], [Ds3_processed]]}


data.meta
{[dz] [pixelsize] [zAniso] [sample/piezo scan] [texp]}



 source: '/net/10.117.38.184/scratch/George/14122020_copyGeorge/test_data/Source/Ex10_488_50mW_560_200mW_642_50Mw_z0p5/'
         channels: {'/net/10.117.38.184/scratch/George/14122020_copyGeorge/test_data/Source/Ex10_488_50mW_560_200mW_642_50Mw_z0p5/'}
             date: '141220'
        framerate: 0
        imagesize: [512 512 51]
      movieLength: 15
          markers: {'gfp'}
       framePaths: {{15×3 cell}}
        maskPaths: {15×3 cell}
        pixelSize: 0.1040
               dz: 0.5000
           zAniso: 2.5120
            angle: 31.5000
    objectiveScan: 0
         reversed: 0
     framePathsDS: {{15×3 cell}}
    framePathsDSR: {{15×3 cell}}
f: [integer]
%}









function transferSourceSink(scratch_dirSink, datasync_dirSink,fullSourceImgs, Exs_llsm_dir)

% tranfer the tifs to the sink, if the tif does not exist in the sink
% folder or the channels folder

for ii=1:length(fullSourceImgs)
    for jj=1:length(fullSourceImgs(ii).tif)
        
        sinkFol = get_sinkFol_comp(Exs_llsm_dir{ii}, scratch_dirSink);
        
        % get the scratch folder (until CS1_.../)
        sinkDir_scratch = [scratch_dirSink filesep sinkFol];
        
        % get ds3 raw and processed folder
        ds3Dirs = getDS3SinkFol(sinkFol);
        sinkDir_ds3 = strcat(datasync_dirSink, ds3Dirs);
        
        % check if the settings file has been tranfered
        if ~exist(sinkDir_scratch,'dir')
            mkdir(sinkDir_scratch)
        end
        
        % check if the tif is in the sinkFol 
        tifName = getTifName(fullSourceImgs(ii).tif{jj});
        inSink = exist([sinkDir_scratch filesep tifName],'file');
        
        % check if tif is in the channel folder
        chanFolName = getChanFol(tifName);
%         [sinkDir filesep chanFolName filesep tifName]
        inChan = exist([sinkDir_scratch filesep chanFolName filesep tifName],'file');
        
        % if tif is not in sinkFol or sinkFol/channelFol, transfer the file
        % to scratch and to DS3 
        if ~inSink || ~inChan
            
            
            % if the channel folders are not in the sink
            if ~exist([sinkDir_scratch filesep chanFolName ],'dir')
                mkdir([sinkDir_scratch filesep chanFolName ])
                
                mkdir([sinkDir_ds3{1} ])
                mkdir([sinkDir_ds3{2} filesep chanFolName])

            end
            
            % copy settings file
            
            
            
            % copy tif to the source and the sink
           fprintf('%s transferred to scratch and DS3\n',tifName')
           copyfile(fullSourceImgs(ii).tif{jj}, [sinkDir_scratch filesep chanFolName ])
           copyfile(fullSourceImgs(ii).tif{jj}, [sinkDir_ds3{1} ])
           copyfile(fullSourceImgs(ii).tif{jj}, [sinkDir_ds3{2} filesep chanFolName ])

           
           % deskew the tif
           
           
           
        end
        
        
           
%         if 
        
        
        
        
    end
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


