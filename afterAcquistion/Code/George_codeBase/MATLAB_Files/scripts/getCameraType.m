function camType = getCameraType(foldir)

expression = 'scmos';
expression2 = 'emccd';

booleansCMOS = regexpi(foldir, expression);
booleanEMCCD = regexpi(foldir, expression2);

if booleansCMOS
    camType = {'sCMOS (Hamatsu, ORCA Flash 4.0 v2)'};

elseif booleanEMCCD
    camType = {'EMCCD (Andor, iXon Ultra 897)'};
else
    disp('No camera type found, manually enter the camera type');
    camType = 'NA';
end

end