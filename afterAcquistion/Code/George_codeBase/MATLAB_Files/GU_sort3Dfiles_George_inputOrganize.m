

for k = 1:numel(data(1).channels)
    % Works, 062518,
    % Improve code, if tif in rt, find wavelength, if none, then already
    % processed or none tifs exists. then find folder named ch. 
    
    tic
    rt = [data.source];
    cd(rt)
    % Edited, KGO 062518
    chan = [405, 488, 560, 592, 642];
    fprintf('source: %s\n\t has %d channels\n',data.source,numel(data.channels));
    
    input_str = sprintf('Enter laser wavelength for channel %d: ',k);
    
    chan_double = input(input_str);
    while ~(chan_double == chan)
        fprintf('\n%d not found, type in [%s]\n',chan_double,num2str(chan));
        chan_double = input(input_str);
    end
    chan_str_mk = ['ch' num2str(chan_double)];
    mkdir(chan_str_mk);
    chan_str = num2str(chan_double);
    
    
    %% Firdt channel
    %     stackFiles = dir([rt '*488nm*.tif']);  %%% %%%     Change here     %%%% %%%%
    
    str = sprintf('*%snm*.tif', chan_str);
    %     stackFiles = dir([rt '*560nm*.tif']);  %%% %%%     Change here     %%%% %%%%
    stackFiles = dir([rt str]);  %%% %%%     Change here     %%%% %%%%
    
    if numel(stackFiles) >0
        stackFiles = {stackFiles.name};
        
        i = regexpi(stackFiles, '(?<=msec_)\d+', 'match');
        [~,i] = sort(cellfun(@str2double, i));
        stackFiles = stackFiles(i);
        stackFiles = cellfun(@(i) [i], stackFiles, 'unif', 0);
        cd(rt)
        
        for j = 1:numel(stackFiles)
            %             movefile([rt stackFiles{j}], [rt 'ch488' filesep stackFiles{j}])  %% Change here
            %             movefile([rt stackFiles{j}], [rt 'ch560' filesep stackFiles{j}])  %% Change here
            movefile([rt stackFiles{j}], [rt chan_str_mk filesep stackFiles{j}])  %% Change here
            
        end
    end
    %%
    %     stackFiles = dir([rt '*560nm*.tif']);    %%% %%%     Change here     %%%% %%%%
    %     stackFiles = {stackFiles.name};
    %     i = regexpi(stackFiles, '(?<=msec_)\d+', 'match');
    %     [~,i] = sort(cellfun(@str2double, i));
    %     stackFiles = stackFiles(i);
    %     stackFiles = cellfun(@(i) [i], stackFiles, 'unif', 0);
    %     cd(rt)
    %
    %     for j = 1:numel(stackFiles)
    %         movefile([rt stackFiles{j}], [rt 'ch560' filesep stackFiles{j}])
    %     end
    %
    %
    %     fprintf('Finished processing: %s\n', rt);
    %     toc
end
