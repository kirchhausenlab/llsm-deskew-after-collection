% ricardo 20200909

% flip the images
% clear; clc; close all;
function imageflipGeorge(data)

% select the directory of the images;
for kk = 1:length(data)
% dr = '/net/10.117.38.184/scratch/Ricardo/2020/09_September/09092020/Magnet_Glued_with_Epoxy_SampleHolder_ScotchTaped_to stage/Beads_inWater_300mW_500ms/Ex01_488_300mW_z0p25';
dr = data(kk).source;
image_files = [dr filesep '*.tif'];
im = dir(image_files);

for ii = 1:length(im)
    cur_im_name = im(ii).name;
    cur_im_loc = im(ii).folder;
    cur_im_dir = [cur_im_loc filesep cur_im_name];
    cur_im = readtiff(cur_im_dir);
    
    % move the current images to a new folder -- original
    if(~exist([im(ii).folder filesep 'original'],'dir'))
        mkdir( [im(ii).folder filesep 'original']);
    end
    % move the file
    new_cur_im_dir = [cur_im_loc filesep 'original'];
    movefile(cur_im_dir,new_cur_im_dir);
    
    % initialize empty bits
    corrected_cur_im = zeros(size(cur_im));
    
    % loop through all the z-planes
    for jj = 1:size(cur_im,3)
        corrected_cur_im(:,:,jj) = fliplr(cur_im(:,:,jj));
    end
    
%     if(~exist([im(ii).folder filesep 'preproc_flipped'],'dir'))
%        mkdir( [im(ii).folder filesep 'preproc_flipped']);
%     end
    
    % save the corrected images writetiff(image_matrix, directory)
    writetiff(single(corrected_cur_im),[cur_im_loc filesep im(ii).name]);

end
if ~exist(fullfile([cur_im_loc filesep],'ImageFlipped.txt'),'file')
    save(fullfile([cur_im_loc filesep],'ImageFlipped.txt'));
end
end

% if ~exist(fullfile([data(k).channels{j},'DS\'],'ChromaticOffsetApplied.txt'),'file')
%     save(fullfile([data(k).channels{j},'DS\'],'ChromaticOffsetApplied.txt'));
% end