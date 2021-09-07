function exchange2chFolName(Ex_directories)

for ii =3:24
    c = Ex_directories{ii};
    d= getdir(char(c));
     movefile([char(c) filesep 'ch488nmCamB*' filesep 'DS_488'],[char(c) filesep 'ch488nmCamB*' filesep 'DS']);
     movefile([char(c) filesep 'ch560nmCamA*' filesep 'DS_560'],[char(c) filesep 'ch560nmCamA*' filesep 'DS']);

    
    %     d.folder
%     disp(1)
% % %     movefile([d.folder filesep d.name filesep d.name],[d.folder filesep 'ch560nmCamA*']);
%   movefile([d.folder filesep 'ch488nmCamB*' filesep 'DS'], [d.folder filesep 'ch560nmCamA*' filesep 'DS_560'])
%   
%     movefile([d.folder filesep 'ch560nmCamA*' filesep 'DS'], [d.folder filesep 'ch488nmCamB*' filesep 'DS_488'])
% 
%     
    
    
end



end