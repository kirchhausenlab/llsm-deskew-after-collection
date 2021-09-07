function deskewChroma(dirSink)

% find chroma folder
chromaFolderDir = [dirSink filesep '*' filesep 'chroma'];
d = getdir(chromaFolderDir);
acqFol = [d(1).folder filesep d(1).name]

% find settings file
ExNum = 0;
Meta = AutoDS_readtxt(acqFol, acqFol,ExNum)

M.transferred = cell(1, length(Meta.chan));
S.illum = false;
AutoDS_deskewData20191117b(M,S,Meta)

deskew 

