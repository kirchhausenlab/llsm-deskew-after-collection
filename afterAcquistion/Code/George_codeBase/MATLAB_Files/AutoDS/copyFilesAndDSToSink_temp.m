%{
Copy files from the sources to the sink
For each files copied, DS it depending on the metadata. Use S for illum,
chroma and totalPSF

Should have a total of N_stack N_chan files
To avoid error, in the first iteration, wait until stack is recorded, only
processes stack until N-1.
For the last stack, wait 1.2*(tcycle * N_chan * planes)

Each time stack is transfered, mark it, and initialize the DS.
copy raw, use raw to make DS.

% Edit 2020 09 04
Check if at least two stacks or next Ex folder is created 
Transfer the files to the sink
for ones that are transferred, start the DS


%}

function copyFilesAndDSToSink(Meta,S)

% Make markers to keep track of what where transfered
M = struct;
% M.transfered
% M.DSed

% ------------ copyFiles ----------------------------
% If Meta.stack >1, then wait until second stack is generated
% if Meta.stac>1 but the second stack is not generated, allow user to put
%   in wait time, or move on to the next execution

% find stack second stack == stack001
str = sprintf('Ex%02d_',Meta.Ex+1);
dd = dir([Meta.dirParent filesep '**\' str '*']);
while true
    d = dir([Meta.dirSource filesep '*stack*.tif']);
    if (length(d) > length(Meta.chan)) % if more than 2 stacks are acquired
        %  ---- find the wait time ----- 
        
        % find stack0001
        stack0001 = dir([Meta.dirSource filesep '*stack0001*']);
        idx = regexp(stack0001(1).name,'_?\d+msec');
        t_perstack = str2double(stack0001(1).name(idx(1) + 1 : idx(2)-5)); % milliseconds
        Meta.twait = (t_perstack - ceil(Meta.tcycle*1000 /5) * 5 * length(Meta.chan) * 100)/1000;
        Meta.tacq = t_perstack/1000; %ceil(Meta.tcycle*1000/5)*5 * length(Meta.chan)/10 + Meta.twait
        break
    else
       % check if the new ExNM folder changes in size
       
       str = sprintf('Ex%02d',Meta.Ex+1);
       fprintf('%s\t\tCheck if %s is made. Wait %1.3fs \n', timeStr, str,max(Meta.texp) * Meta.planes * numel(Meta.chan) / 1000);
       dd = dir([Meta.dirParent filesep '**\' str '*']); 
       if (~isempty(dd)) % if new acquisition started, move on
           % Update stack number for this Ex folder.
           Meta.stacks = length(d)/ length(Meta.chan);
           break;
       else
           % wait 
           t_pause =  max(Meta.texp) * Meta.planes * numel(Meta.chan) / 1000 ;
           pause(t_pause);
           continue;
       end
    end
end
fprintf('%d total stacks found, proceed to Deskew\n', length(d))

% sink folder
dSink = dir([Meta.dirSink,filesep, '*.tif']); 

% keep track of which ones transferred and which are DSed
transferred = zeros(Meta.stacks, 1);
tif_transferred = dir([Meta.dirChan{end} filesep '*.tif']);
last_transferred = length(tif_transferred);
transferred(1:last_transferred) = 1;

M.transferred = cell(Meta.stacks, length(Meta.chan));

t = 0; % check if the acquisiton was cancelled.

% M.DSed =  zeros(Meta.stacks, length(Meta.chan));

% ----- Transfer and Deskew ------
% while stack num < deskewed num or
% while Ex02 is not made


% % sink folders, for each channels
% dSink = dir([Meta.dirChan{1},filesep, '*.tif']);
% if (isempty(dSink))
%     M.idxTrans = ones(1,2);
% else
%     M.idxTrans = [];
% end
% % M.idxTrans = ones(1,2);

% find the tif in the folder
d = dir([Meta.dirSource filesep '*stack*.tif']);
% ------- while Stack *nchan
while (sum(transferred) ~=  Meta.stacks )
    
    % Find which ones are transferred, tif are transferred in groups of
    % number of channels length(Meta.chan)
    
    stack_transferred =find(transferred(:,1) == 1, 1, 'last' ); % find the max stack (index is shifted by 1) that were transferred
    if (isempty(stack_transferred))
        stack_transferred = 0; % means none are transferred, not stack0000 was transferred
    end
    
    % find the current stack being acquired/ or was acquired (last one)
    d = dir([Meta.dirSource filesep '*stack*.tif']);
    curStackNum = floor(length(d) / length(Meta.chan));
    
    if (curStackNum > stack_transferred +1 ) % if the number of non-transferred images are more than the transferred
        
        % copy file(end-1) from the source to the sink
        if (stack_transferred < Meta.stacks)
            for ii = stack_transferred:(curStackNum-2)
                str = sprintf('*stack%04d*.tif',ii);
                tdir = dir([Meta.dirSource filesep str]);
                for jj = 1:length(tdir)
                    % find which ch
                    idx = regexp(tdir(jj).name, '_*nm_' );
                    chan = tdir(jj).name(idx-3:idx+1);
                    
                    % find which destination fol
                    for kk = 1:length(Meta.dirChan)
                        idxSinkFol = regexp(Meta.dirChan{kk},chan, 'once');
                        if ~isempty(idxSinkFol)
                            transSinkFol = Meta.dirChan{kk};
                            break;
                        end
                    end
                    
                    % transfer file to the destination fol
                    % sink folder =  transSinkFol
                    % source tif = [ tdir(jj).folder, filesep ,tdir(jj).name]
                    %         if (~exist([transSinkFol filesep tdir(jj).name],'file'))
                    copyfile([tdir(jj).folder, filesep ,tdir(jj).name filesep], transSinkFol);
                    M.transferred{ii+1,jj} = [transSinkFol filesep tdir(jj).name];
                    %         end
                    
                end
                fprintf('%s\t\t Ex%1.2d,\tStack #%d/%d transferred\n',timeStr, Meta.Ex, ii+1, Meta.stacks)
                transferred(ii+1) = 1;
                stack_transferred = stack_transferred + 1;
            end
            t = tic;
        end
        t2 = toc(t);
        if t2 > 3*(ceil(Meta.tcycle*1000/5)*5 * length(Meta.chan)/10 + Meta.twait)
            break % move on to deskew what you have
        end
     
    elseif (stack_transferred+1 == Meta.stacks) %Last stack
            % transfer the last stack
        % wait at least for one timepoint to ensure the 
        fprintf('%s\t\tLast stack of Ex%1.2d,\tStack %d/%d\n',timeStr, Meta.Ex, Meta.stacks-1, Meta.stacks)
        fprintf('%s\t\tPause for %1.3f seconds\n',timeStr, (ceil(Meta.tcycle*1000/5)*5 * length(Meta.chan)/10 + Meta.twait))
        pause((ceil(Meta.tcycle*1000/5)*5 * length(Meta.chan)/10 + Meta.twait)) % wait in seconds
        
        % transfer the last stack
        ii = Meta.stacks-1;
        str = sprintf('*stack%04d*.tif',ii);
        tdir = dir([Meta.dirSource filesep str]);
        for jj = 1:length(tdir)
            % find which ch
            idx = regexp(tdir(jj).name, '_*nm_' );
            chan = tdir(jj).name(idx-3:idx+1);
            
            % find which destination fol
            for kk = 1:length(Meta.dirChan)
                idxSinkFol = regexp(Meta.dirChan{kk},chan, 'once');
                if ~isempty(idxSinkFol)
                    transSinkFol = Meta.dirChan{kk};
                    break;
                end
            end
            
            % transfer file to the destination fol
            % sink folder =  transSinkFol
            % source tif = [ tdir(jj).folder, filesep ,tdir(jj).name]
            %         if (~exist([transSinkFol filesep tdir(jj).name],'file'))
            copyfile([tdir(jj).folder, filesep ,tdir(jj).name filesep], transSinkFol);
            M.transferred{ii+1,jj} = [transSinkFol filesep tdir(jj).name];
            %         end
            
        end
        transferred(ii+1) = 1;
        stack_transferred = stack_transferred + 1;
        t = tic;
        
   
        
    end
    
   
    
% % % % % %     % ------------ Start DS
% % % % % %     %%
% % % % % %     % input:
% % % % % %     %   M with file locations,
% % % % % %     %   S with illum, chroma, PSF info
% % % % % %     %   Meta with camflip, zmotion, ds info
% % % % % %     t2 = tic;
% % % % % %     AutoDS_deskewData20191117b(M,S,Meta)
% % % % % %     tend2 = toc(t2);
% % % % % %     
% % % % % %     tend = toc(t);
% % % % % %     if (tend2 < 5 && (tend > 10*( Meta.tacq + Meta.twait) || tend > 300))
% % % % % %         break;
% % % % % %     end
% % % % % %     
% % % % % %     % check if New folder is made
% % % % % % %      dd = dir([Meta.dirParent filesep '**\' str '*']);
% % % % % %     
    
end

disp("AUTODS COMPLETE WHOO HOOO");
end





% function copyFilesAndDSToSink(Meta,S)
% 
% % Make markers to keep track of what where transfered
% M = struct;
% % M.transfered
% % M.DSed
% 
% % ------------ copyFiles ----------------------------
% 
% % find stack second stack == stack001
% secondStackBool = false;
% twait = max(Meta.texp) * Meta.planes * numel(Meta.chan) / 1000 ;
% while (~secondStackBool)
%     d = dir([Meta.dirSource filesep '*stack0001*.tif']);
%     if (isempty(d))
%         fprintf("Need at least 2 stacks to avoid DS on collecting data!\n");
%         pause(twait);
%     end
%     if (~isempty(d))
%         secondStackBool = true;
%     end
% end
% % printf("second stack found, proceed")
% 
% % sink folders, for each channels
% dSink = dir([Meta.dirChan{1},filesep, '*.tif']);
% if (isempty(dSink))
%     M.idxTrans = ones(1,2);
% else
%     M.idxTrans = [];
% end
% % M.idxTrans = ones(1,2);
% 
% 
% stacks = 0;
% % ------- while Stack *nchan
% while stacks <  Meta.stacks
%     % find the current stack being acquired
%     d = dir([Meta.dirSource filesep '*stack*.tif']);
%     curStackNum = floor(length(d) / length(Meta.chan));
%     % if firstTrans
%     %     idxTrans = 1;
%     % end
%     
%     % if program was restarted
%     if isempty( M.idxTrans  )
%         M.idxTrans(1) = 1;
%         M.idxTrans(2) = curStackNum;
%     end
%     
%     if curStackNum < Meta.stacks
%         while curStackNum-1  <  M.idxTrans(end)
%             fprintf("Waiting %g seconds for stack #%d to be acquired ...\n", twait, curStackNum);
%             pause(twait);
%             d = dir([Meta.dirSource filesep '*stack*.tif']);
%             curStackNum = floor(length(d) / length(Meta.chan));
%         end
%     else
%         % Final run
%         curStackNum = curStackNum + 1;
%     end
%         
%         % transfer files from until Stack(curStackNum-1)
%         for ii = M.idxTrans(end):curStackNum - 1
%             
%             % find the stack_num_ to be transfered
%             str = sprintf('*stack%04d*.tif',ii-1);
%             tdir = dir([Meta.dirSource filesep str]);
%             
%             % transfer each tif to the appropriate destination
%             for jj = 1:length(tdir)
%                 % find which ch
%                 idx = regexp(tdir(jj).name, '_*nm_' );
%                 chan = tdir(jj).name(idx-3:idx+1);
%                 
%                 % find which destination fol
%                 for kk = 1:length(Meta.dirChan)
%                     idxSinkFol = regexp(Meta.dirChan{kk},chan, 'once');
%                     if ~isempty(idxSinkFol)
%                         transSinkFol = Meta.dirChan{kk};
%                         break;
%                     end
%                 end
%                 
%                 % transfer file to the destination fol
%                 % sink folder =  transSinkFol
%                 % source tif = [ tdir(jj).folder, filesep ,tdir(jj).name]
%                 %         if (~exist([transSinkFol filesep tdir(jj).name],'file'))
%                 copyfile([tdir(jj).folder, filesep ,tdir(jj).name filesep], transSinkFol);
%                 M.transfered{ii,jj} = [transSinkFol filesep tdir(jj).name];
%                 %         end
%                 
%             end
%         end
%         
%         
%         M.idxTrans(end-1) = M.idxTrans(end);
%         M.idxTrans(end) = curStackNum; % We need this stack to move on to the next transfer and then the DS
%         % % update number of tifs, dont copy until N-1
%         % d = dir([Meta.dirSource filesep '*stack*.tif']);
%         %
%         % % update idxTrans
%         % idxTrans = curStackNum + 1;
%         
%         stacks = M.idxTrans(end-1);
%    
%     
%     
%     
%     
%     % ------------ Start DS
%     %%
%     % input:
%     %   M with file locations,
%     %   S with illum, chroma, PSF info
%     %   Meta with camflip, zmotion, ds info
%     AutoDS_deskewData20191117b(M,S,Meta)
%     
%     
% end
% 
% disp("AUTODS COMPLETE WHOO HOOO");
% end
% 
% 
% 
