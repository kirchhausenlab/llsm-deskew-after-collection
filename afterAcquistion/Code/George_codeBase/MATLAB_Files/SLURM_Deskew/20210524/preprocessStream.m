function preprocessStream(data, sinkEx)
for ii = 1:length(data)
    d = data(ii)
%     cmd = sprintf('srun matlab -nodisplay -nosplash -nodesktop -nojvm -r ";tic; disp(1); disp(2); pause(5); toc; exit()" &');
    cmd = sprintf('srun matlab -nodisplay -nosplash -nodesktop -nojvm -r ";tic; disp(1); disp(2); pause(5); toc; exit()" &');

end

end

%{
cmd command
Input: 
    tif directory of source
    sink directory
    sinkEx




%}
