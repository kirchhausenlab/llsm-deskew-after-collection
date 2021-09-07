function tif = organizeTif(acquiredTifs, scratch_dirSink,datasync_dirSink, dirSource, Exs_llsm_dir))
%%

% ---------------- organize sources+meta --------------

% get the total number of the acquried tifs
n_tif =0;
for ii = 1:length(acquiredTifs)
    n_tif = n_tif + length(acquiredTifs(ii).tif);
end
tif(n_tif) = struct();

name= {};
sources = {};
meta =[];
scratch =[];
ds3raw=[];
ds3processed=[];

% organize source folde and meta
for ii = 1:length(acquiredTifs)
   n = length(acquiredTifs(ii).tif);
   
   % organize sources
   sources = vertcat(sources, repmat(cellstr(acquiredTifs(ii).source), [n,1]));
   
   %organize meta
   metai = repmat(acquiredTifs(ii).meta, [n,1]);
   meta = [meta, vertcat(metai(:))];
end


% ------ organize sink ------------
for ii = 1:length(acquiredTifs)
   n = length(acquiredTifs(ii).tif);
   

end




% ------ organize to tif ------

tif.source = sources;
tif.meta = meta;


    %{
    tif(1)
        .name               = file name, {cell}
        .source             = directory, {cell}
        .sink 
            .scratch        = directory, {cell}
            .ds3raw         = directory, {cell}
            .ds3processed   = directory, {cell}

        .meta               = metadata, {cell}->[struct]


    %}