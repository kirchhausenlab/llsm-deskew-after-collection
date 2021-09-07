% TO calculate the shift
%
% b488=readtiff('/scratch/Giuseppe/Translate_642_channel/LLSCalibration/chroma/Ex01_488_300mW_560_500mW_642_500mW_z0p1/ex01_CamA_ch0_stack0000_488nm_0000000msec_0016258907msecAbs_000x_000y_000z_0000t.tif');
% b642=readtiff('/scratch/Giuseppe/Translate_642_channel/LLSCalibration/chroma/Ex01_488_300mW_560_500mW_642_500mW_z0p1/ex01_CamA_ch2_stack0000_642nm_0000000msec_0016258907msecAbs_000x_000y_000z_0000t.tif');
% 
% sigma = [1.2, 2.5]; % estimate
% 
% [pstruct488, ~] = pointSourceDetection3D(b488, sigma, 'Mode', 'xyzAsrc', 'Alpha', .05,...
%              'RemoveRedundant', true,...
%              'RefineMaskLoG', false); 
% [pstruct642, ~] = pointSourceDetection3D(b642, sigma, 'Mode', 'xyzAsrc', 'Alpha', .05,...
%              'RemoveRedundant', true,...
%              'RefineMaskLoG', false);
% idx488 = find(pstruct488.A==max([pstruct488.A]));
% idx642 = find(pstruct642.A==max([pstruct642.A]));
% 
% dx=pstruct642.x(idx642)-pstruct488.x(idx488);
% dy=pstruct642.y(idx642)-pstruct488.y(idx488);
% 
% b642_1=zeros(size(b642));
% b642_1(round(dx)+1:end,1:end+round(dy),:)=b642(1:end-round(dx),-round(dy)+1:end,:);
% 
% R=b642_1(:,:,50);
% G=b488(:,:,50);
% RGB=zeros(64,64,3);
% RGB(:,:,1)=R/max(R(:));
% RGB(:,:,2)=G/max(G(:));
% 
% image(RGB), axis image
clear

folder_name='/nfs/scratch/Giuseppe/Translate_642_channel/CS1/Ex07_488_300mW_560_500mW_642_500mW_z0p2';
dx=3.8143; dy=-2.7788;
pos=find(folder_name==filesep);
mkdir([folder_name(1:pos(end)) filesep folder_name(pos(end)+3:end)])
dirout=dir(fullfile(folder_name,'*.tif'));
idc = strfind({dirout.name},'642');   % search for 'bore' in all cells.
idx = ~cellfun('isempty',idc);

parfor l=find(idx==1)
fun(folder_name,dirout, pos, dx, dy, l)
end

function fun(folder_name,dirout, pos, dx, dy, l)
    copyfile([folder_name filesep dirout(l).name],[folder_name(1:pos(end)) filesep folder_name(pos(end)+3:end) filesep dirout(l).name])
    A=readtiff([folder_name filesep dirout(l).name]);
    Ac=uint16(zeros(size(A)))+median(A(:));
    Ac(round(dx)+1:end,1:end+round(dy),:)=A(1:end-round(dx),-round(dy)+1:end,:);
    Ac = uint16(Ac);
    imwrite(Ac(:,:,1),[folder_name filesep dirout(l).name]);
    for m = 2:size(A,3)
        imwrite(Ac(:,:,m),[folder_name filesep dirout(l).name], 'writemode', 'append');
    end
end