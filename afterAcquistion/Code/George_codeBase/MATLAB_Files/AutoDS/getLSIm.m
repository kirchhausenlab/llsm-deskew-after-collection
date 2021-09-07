function LSIm = getLSIm(c, S, Meta)

chan = sprintf("%d",Meta.chan(c));
cam = Meta.camSave(:,c);
idx = find(cam == 1);
disp("Selecting LSIm");




for ii = 1:length(S.I.tif)
    flag = regexp(S.I.tif, chan,'ONCE');
    idx = find(~isempty(flag));
    if (idx) 
        break;
    end
end

fprintf("Found ch%d, cameraA\n", Meta.chan(c));
LSIm_dir = S.I.tif{idx};

LSIm = [S.I.dir

















end