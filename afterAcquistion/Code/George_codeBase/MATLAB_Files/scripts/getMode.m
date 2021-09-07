function Mode = getMode(Meta)
Mode = cell(length(Meta), 1);
for ii = 1:length(Meta)
    flag = regexpi(Meta(ii).zmotion,'sample');
    if flag 
%         Mode{ii} = {'Square Lattice';'Dithered'; 'Sample scan'};
         Mode{ii} = {'Square Lattice, Dithered, Sample scan'};
    else
%         Mode{ii} = {'Square Lattice';'Dithered'; 'Objective scan'};
        Mode{ii} = {'Square Lattice, Dithere, Objective scan'};
    end


end
end
