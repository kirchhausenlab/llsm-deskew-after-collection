
function directories=getdir(directory)

d = dir(directory);
dd = d([d(:).isdir]);
dd = dd(~ismember({dd(:).name},{'.','..'}));
directories = dd;

end