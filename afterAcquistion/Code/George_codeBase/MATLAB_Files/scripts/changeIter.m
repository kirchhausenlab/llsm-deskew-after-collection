function changeIter(chdir)
tifext = '*.tif';

iterbad = 'ex09_iter_1_';
itergood = 'ex09_iter_0001_';
% regexpi(itergood, 'Iter_[0-9]{4}','match')

for ii=1:length(chdir)
    for jj = 1:length(chdir(ii).ch)
        
        % get all the tif images
        d = dir([char(chdir(ii).ch{jj}) filesep tifext]);
        
        for kk = 1:length(d)
            % if iteration mode
            flag = regexpi(d(kk).name,'Iter');
%             flag = regexpi(d(kk).name,'Iter_[0-9]{4}','match');
            if ~isempty(flag)
                % if iter_1_ then change name to iter_0001_ (4 digits)
                flag = 1;
                flag = regexpi(d(kk).name, 'Iter_[0-9]{4}','match');
%                 disp(d(kk).name);
                
                if isempty(flag)
                    % get the iteration number
                    num_char = regexpi(d(kk).name,'(?<=_Iter_)\d+','match','once');
                    if isempty(num_char)
                        % iteration mode used, but one stack only
                        continue;
                    end
                    
                    % new char
                    new_num_char = sprintf('%04d',str2double(num_char));
                    % change name
                    leftidx = regexpi(d(kk).name,'_Iter_') + 5;
                    rightidx = regexp(d(kk).name,'_stack') ;
                    
                    new_name = [d(kk).name(1:leftidx) new_num_char d(kk).name(rightidx:end)];
                    disp([chdir(ii).ch{jj} filesep    new_name]);
%                     fprintf('%s \nto %s\n',  d(kk).name,  [new_name])
                    
                    % save tif
                    movefile([chdir(ii).ch{jj} filesep d(kk).name], [chdir(ii).ch{jj} filesep new_name])
                    
                end
            end
            
        end
            
        
    end
end
disp('************** Compelte ************');
end


%%
% regexpi(itergood, 'Iter_[0-9]{4}','match')