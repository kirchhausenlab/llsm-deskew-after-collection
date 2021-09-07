clear

rt = '/net/tkfastfs/scratch/Gustavo/20201118_p5_p55_sCMOS_Gu/LLSCalibrations/chroma';
ex = {'Ex00_488_560_z0p2'};
FileName488camA = 'c488.tif';
FileName560camB = 'c560.tif';
% FileName642camA = 'c642.tif';

for ii = [1]
    R = [rt filesep char(ex{ii}) filesep 'cropped_DS' filesep];
    
    [~, ~, XYZ488, ~, ~] = GU_estimateSigma3D(R,FileName488camA); % Get XYZ by adding a PSF
    [~, ~, XYZ560, ~, ~] = GU_estimateSigma3D(R,FileName560camB); % Get XYZ by adding a PSF
% 	[~, ~, XYZ642, ~, ~] = GU_estimateSigma3D(R,FileName642camA); % Get XYZ by adding a PSF
    const = 0.2*sind(31.5);
    
    A=abs(XYZ488.z - XYZ560.z)*const;
%     B=abs(XYZ560.z - XYZ642.z)*const;
    zAniso = 0.2*sind(31.5) / 0.104;
    
    nF = round(A/0.104/zAniso);
%     nF = round(B/0.104/zAniso);
    
end

