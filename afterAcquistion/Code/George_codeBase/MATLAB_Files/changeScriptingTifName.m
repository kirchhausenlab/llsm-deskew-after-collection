% Scripting change name 

%{
    Flow chart
* Make a copy of the original file, save it to "Original"
* Using laser channel as a key, organize the file, using the first stack
name as the template. 

Ideally
find folders that start with CS
gointo the folder, change the name


%}
function changeScriptingTifName(fName)

channels = [405 488 560 592 642];
channelMarker = zeros(1,length(channels));
channelFirstName = cell(1,length(channels));
maxSt = 0;
% --- ---- ---- ---- CHANGE NAME --- ---- ---- ------- ---- ---- ----
% folderName = 'Z:\Mithun\20190502_p5_p55_sCMOS_Mithun_Lamin\test\Ex02ts_488_300mW_80p_560nm_500mW_80p_z0p4';
% ---- --- --- ---- --- --- --- --- --- -- --- -- --- --- --- -- --- --- 
originalcd = cd;
cd(fName);
if ~exist(strcat(fName,filesep,'Original'))
    mkdir(fName,'Original')
else
    disp('Original folder exists already');
end

d = dir('*.tif');
if ~isempty(d)
for ii = 1:numel(d)
    if ii == 1
        disp(d(ii).name)
    end
    % copy the files into the original
    if ~exist(strcat(fName,filesep,'Original',filesep,d(ii).name))
        copyfile(d(ii).name, (strcat(fName,filesep,'Original')))
    else
        str = sprintf('%s already exists in Original',d(ii).name);
%         disp(str);
    end
    
    % Mark which channels are used AND save the template for the name 
    for jj = 1:numel(channels)
        [i,e] = regexp(d(ii).name,'_...nm');
        if ~isempty(regexp(d(ii).name(i:e),char(string(channels(jj)))))
            if channelMarker(jj) == 0
                channelFirstName{jj} = d(ii).name;
            end
            channelMarker(jj) =  channelMarker(jj)+ 1;
            dd(jj).name{channelMarker(jj)} = d(ii).name;
            [sitime,eitime] = regexp(d(ii).name,'_..........msecAbs');
            if isempty(sitime)
                [sitime,eitime] = regexp(d(ii).name,'_...........secAbs');
            end
            dd(jj).time(channelMarker(jj)) = str2double(d(ii).name(sitime+1:eitime-7));
        end
    end   
    [si, ei] = regexp(d(ii).name,'stack....');
    Ntemp = str2double(d(ii).name(ei-3:ei));
    if Ntemp > maxSt
        maxSt = Ntemp;
    end
end
% Find the order of the tif files based on the time, 
[r,c] = size(dd(end).name);
dOriginal = zeros(c,2);

for ii = 1:length(dd)
    if ~isempty(dd(ii).time)
        for jj = 1:c
            dOriginal(jj,1) = jj;
            
            dOriginal(jj,1) = jj;
            dOriginal(jj,2) = dd(ii).time(jj);
            
        end
        
        s = sort(dOriginal(:,2));
        for jj = 1:length(s)
            if length(find(dOriginal(jj,2) == s)) > 1
                dd(ii).idx(jj) = min(find(dOriginal(jj,2) == s));
            else
%                 disp(dd(ii).name(jj));
                dd(ii).idx(jj) = min(find(dOriginal(jj,2) == s));
            end
        end
        
    end
end


%
% find if name has been changed already by checking if stack# matches the
% #of tif files
%
if ~(Ntemp == max(channelMarker)-1)
    for kk = 1:length(dd)
        if ~isempty(dd(kk).name)
            % change file name to the template, with the new stack 
            for ll = 1:length(dd(kk).name)
                originalTifName = dd(kk).name{dd(ii).idx(ll)};
                tempTifName = char(channelFirstName{kk});
                [sit, eit] = regexp(tempTifName,'stack....');
                %                 stNew = sprintf('%04d',ll-1);
                stNew = sprintf('%04d',dd(ii).idx(ll));
                tempTifName(eit-3:eit) = stNew;
                
                [siAcqtime, eiAcqtime] = regexp(tempTifName,'nm_.......m');
%                 if ll > 1
                    timDif = s(ll) - s(1);
%                 else
%                     timDif = 0;
%                 end
                actime = sprintf('%07d',timDif);
                tempTifName(siAcqtime+3:siAcqtime+9) = actime;
                
                [sitimeEnd, eitimeEnd] = regexp(tempTifName,'_..........msecAbs');
                timeNew = dd(ii).time(ll);
                stTime = sprintf('%010d',timeNew);
                tempTifName(sitimeEnd+1:sitimeEnd+10) = stTime;
                
                newTifName = tempTifName;
                if length(originalTifName) ~= length(newTifName) ||max(~(originalTifName == newTifName))
                    if isfile(originalTifName)
                    movefile(originalTifName,newTifName)
                    strDispEnd = sprintf('%s\n    changed to %s',originalTifName,newTifName);
                    disp(strDispEnd)
                    else
                        disp('Not here')
                    end
                end
                
            end
        end
    end
else
    disp('Name already changed');
end
end
    

% stCheck = sprintf('stack%04d',max(channelMarker)-1);
% [si, ei] = regexp(d(ii).name,'stack....');
% finalst = d(ii).name(si:ei);



