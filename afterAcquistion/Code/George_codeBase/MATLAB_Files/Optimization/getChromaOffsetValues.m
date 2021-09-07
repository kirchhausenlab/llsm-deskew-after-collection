function C = getChromaOffsetValues(C_directories)

% get the centroid values of the chromatic offset bead, no 



Cam = {'CamA','CamB'};
Chan = {'405','445','488','514','560','592','607','642'};

% sum(~cellfun(@isempty,C.chan),2); number of combinations for the chroma
% shift

C = C_directories;
directories =C.chan;

keys = {};
values = {};
usedChan = {};
for ii = 1:size(directories, 1)
    for jj = 1:size(directories,2)
        if ~isempty(C.chan{ii,jj})
            
            expression = '/ch(\w+)nm.*(Cam[AB])';
            
            % matches for debugging purposes
            [tokens,~] = regexp(directories{ii, jj},expression,'tokens','match');
            
            if isempty(tokens)
                cam = 'CamA';
                channel = regexpi(data.channels{ii},'((?<=/ch)\d+(?=nm))','match','once');
            else
                assert(length(tokens{1}) == 2)
                channel = char(tokens{1}{1});
                cam = char(tokens{1}{2});
            end
            
            
            name = sprintf('ch%snm%s',channel, cam);
            usedChan{end+1} = name;
            
            % get the metadata
%             d_settings = dir([char(C.dir) filesep '*Settings.txt']);
            Meta = getMeta2_AO(char(C.dir));
            
            if Meta.ds > 0
                 currChromaBead_dir = ([  char(directories{ii, jj})]);
                [~,~,XYZ,~,~] =  GU_estimateSigma3D(currChromaBead_dir,'');
            else
                disp('Bead collected not using sample scan')
                
                % get rid of DS
                chDir  = [  char(directories{ii, jj})];
                idx = regexp(chDir, [filesep 'DS' filesep]);
                currChromaBead_dir = [chDir(1:idx) , chDir(idx+3:end)];
                [~,~,XYZ,~,~] =  GU_estimateSigma3D(currChromaBead_dir,'');
            end
            
            
%             try 
%                 currChromaBead_dir = ([  char(directories{ii, jj})]);
%                 [~,~,XYZ,~,~] =  GU_estimateSigma3D(currChromaBead_dir,'');
%             catch
%                 disp('Bead collected not using sample scan')
%                 
%                 % get rid of DS
%                 chDir  = [  char(directories{ii, jj})];
%                 idx = regexp(chDir, [filesep 'DS' filesep]);
%                 currChromaBead_dir = [chDir(1:idx) , chDir(idx+3:end)];
%                 [~,~,XYZ,~,~] =  GU_estimateSigma3D(currChromaBead_dir,'');
%             end
                
            
            XYZz = XYZ.z;
            
            keys{end+1} = name;
            values{end+1}= XYZz;

        end
    end
end

C.keys = keys;
C.values = containers.Map(keys,values);


end
