% intialize table with format
% https://docs.google.com/spreadsheets/d/1kqab9kVX5Li44cw3JqCJWc48982sXFkMINOHO8nuZXY/edit#gid=61518901

T = {};
T{1,1} = 'Figures';
T{1,2} = 'Camera';
T{1,3} = {'Mode';'(Lattice type)';'(Dithered)';'(Scan type)'};

xlswrite('T.xls',T)

