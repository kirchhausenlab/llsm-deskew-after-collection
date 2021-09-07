function add_splane_FolName(Ex_directories)

disp("***** Checking if Ex Folders have the z0pN extention ******");
% find if there is the z0p extention
% str = 'Ex14_488_30mW_z0p4';
expr = 'z\d+p';
for ii = 1:length(Ex_directories)
    % check if the expression exists
    str = char(Ex_directories{ii});
%     disp(Ex_directories{ii})
    flag = regexpi(str,expr);
    c = char(Ex_directories{ii});
    idx_slash = regexp(c, filesep);
    
    % if z0pN, z1pN,.... missing, then read the settings file 
    if isempty(flag)
        % getMeta file
        Meta = getMeta(Ex_directories{ii});
        
        % make new name
        
        %- find the number before period
        left_char = regexpi(char(string(Meta.ds)),'\d+(.)','match','once');
        right_char = regexpi(char(string(Meta.ds)),'(.)\d+','match','once');
        
       
        
        % update the new name
         str = ['_z' left_char(1:end-1) 'p' right_char(2:end)];
        % save the folder name
        
        fprintf("Adding %s to %s\n",str, c(idx_slash(end):end))
        
        movefile([char(Ex_directories{ii})], [char(Ex_directories{ii}) str ],'f');
        
    else
        fprintf("%s has z0pN\n", c(idx_slash(end)+1:idx_slash(end)+5));
%         fprintf("\t z0pN in \t %s \n",c(idx_slash(end):end))
        
        
    end
    
    
end
disp("***** z0pN extention Check complete ******");


%%
% clear
% str = 'Ex14_488_30mW_z1p4';
% expr = 'z\d+p';
% regexpi(str,expr)




end


