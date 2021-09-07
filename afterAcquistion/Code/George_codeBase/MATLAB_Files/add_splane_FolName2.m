function add_splane_FolName2(Ex_directories)

disp("***** Checking if Ex Folders have the z0pN extention ******");
% find if there is the z0p extention
% str = 'Ex14_488_30mW_z0p4';
expr = 'z\d+p';
cc=0;
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
        
        
        if(isempty(left_char)) || isempty(right_char) 
            % check zNp0
            left_char = char(string(Meta.ds));
            str = ['z' left_char(1) 'p0'];
            cc =1;
             
        else
              % update the new name
            str = ['_z' left_char(1:end-1) 'p' right_char(2:end)];
        end
        
       
        
      
        % save the folder name
        
        fprintf("Adding %s to %s\n",str, c(idx_slash(end):end))
        
        if cc
            idx_c = regexp(c, '_z','once');
        
        % delete and change z0p whatever
             c_new = c(1:idx_c);
             movefile([char(Ex_directories{ii})], [c_new str],'f');
            cc=0;
        else
            
        
            movefile([char(Ex_directories{ii})], [char(Ex_directories{ii}) str ],'f');
        end
        
    else
        % check if the z0pN flag is correct
        Meta = getMeta2_AO(Ex_directories{ii});
        fprintf("%s has z0pN. check if correct\n", c(idx_slash(end)+1:idx_slash(end)+5));
        left_char = regexpi(char(string(Meta.ds)),'\d+(.)','match','once');
        right_char = regexpi(char(string(Meta.ds)),'(.)\d+','match','once');
        
        if(isempty(left_char)) || isempty(right_char) 
            % check zNp0
            left_char = char(string(Meta.ds));
             str = ['z' left_char(1) 'p0'];
        else
              
        % update the new name
         str = ['z' left_char(1:end-1) 'p' right_char(2:end)];
        end
        
       
      
        % save the folder name
        
        c=char(Ex_directories{ii});
        %find the index of _z0p whatever
        idx_c = regexp(c, '(_z)\d+','once');
        
        % delete and change z0p whatever
        c_new = c(1:idx_c);
        
        if ~strcmp([char(Ex_directories{ii})], [c_new str ])
            fprintf("Changing %s to %s\n", c(idx_c+1:end),str);
        
            movefile([char(Ex_directories{ii})], [c_new str ],'f');
        else
            fprintf("\t looks good\n");
        end

        
    end
    
    
end
disp("***** z0pN extention Check complete ******");


%%
% clear
% str = 'Ex14_488_30mW_z1p4';
% expr = 'z\d+p';
% regexpi(str,expr)




end


