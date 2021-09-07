function C = getChromaTif(data)
Cam = {'CamA','CamB'};
Chan = {'405','488','560','592','642'};

C.chan = cell(2,5);
C.do = true;

for dd = 1:length(data(1).framePathsDS)
    frame = char(data(1).framePathsDS{dd});
    for ii = 1:length(Cam)
        for jj = 1:length(Chan)
            expr_cam =  ['_' char(Cam(ii)) '_'];
            expr_chan =  ['_' char(Chan(jj)) 'nm_'];
            flag_cam = regexpi(frame, expr_cam);
            flag_chan = regexpi(frame, expr_chan);
            
            if ~isempty(flag_cam) && ~isempty(flag_chan)
                C.chan{ii,jj} = frame;
            end
            
        end
    end
    
end




end
