function [I,C,PSF] = AutoDS_getTif(folSink)

d = dir(folSink);
for ii = 1:length(d)
    marker = regexp(d(ii).name, 'LLSCalib', 'once');
    folCalib = d(ii).name;
    if (~isempty(marker))
        break
    end
end
% ------------ finding illum files -----------------

dirCalib = [folSink filesep folCalib];
dcalib = dir(dirCalib);
marker = 0;
for ii = 1:length(dcalib)
    marker = regexp(dcalib(ii).name, 'illum', 'once');
    folIllum = dcalib(ii).name;
    if (~isempty(marker))
        break
    end
end
dirIllum = [dirCalib filesep folIllum];

dIllum = dir(dirIllum);
marker =0;
counter = 1;
for ii = 1:length(dIllum)
    marker = regexp(dIllum(ii).name, '.tif', 'once');
    if (~isempty(marker))
        I.tif{counter,1} = dIllum(ii).name;
        counter = counter + 1;
    end
end
I.dir = dIllum(1).folder;
% ------------ finding chroma files -----------------
marker = 0;
for ii = 1:length(dcalib)
    marker = regexp(dcalib(ii).name, 'chroma', 'once');
    folChroma = dcalib(ii).name;
    if (~isempty(marker))
        break
    end
end
dirChroma = [dirCalib filesep folChroma];

dChroma = dir(dirChroma);
marker =0;
counter = 1;
for ii = 1:length(dChroma)
    marker = regexp(dChroma(ii).name, '.tif', 'once');
    if (~isempty(marker))
        C.tif{counter,1} = dChroma(ii).name;
        counter = counter + 1;
    end
end
C.dir = dChroma(1).folder;
% ------------ finding totalPSF files -----------------

marker =0;
counter = 1;
for ii = 1:length(dcalib)
    marker = regexp(dcalib(ii).name, 'totalPSF.tif', 'once');
    if (~isempty(marker))
        PSF.tif{counter,1} = dcalib(ii).name;
        counter = counter + 1;
    end
end
PSF.dir = dcalib(1).folder;



end
