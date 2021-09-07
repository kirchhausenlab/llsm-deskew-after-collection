clear; clc; close all;
rt = 'Z:\George\20180608_p35_p4_sCMOS_George_Cells1\Ex03_CLTA_RFP_Ap2_eGFP_488_300mW_z0p4\ch488\DS\GPUdecon\MIPs\';
fn = dir([rt '*tif']);
fn = {fn.name}';

t = readtiff([rt fn{1}]);
im = zeros([size(t), numel(fn)]);

for ii = 1:numel(fn)
    im(:,:,ii) = readtiff([rt fn{ii}]);
end

figure(1);
imtool3D(im);

%%

figure(2); histogram (im(:));

p99 = prctile(im(im>0),99)
p90 = prctile(im(im>0),90)

