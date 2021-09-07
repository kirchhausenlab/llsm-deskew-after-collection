function Meta = getCamSave(Meta, tline)
        marker = 0;
        
        marker405CamA = regexpi(tline,'Saving Camera A 405multi = TRUE','match');
        marker405CamB = regexpi(tline,'Saving Camera B 488multi = TRUE','match');
        
       marker488CamA = regexpi(tline,'Saving Camera A 488multi = TRUE','match');
       marker488CamB = regexpi(tline,'Saving Camera B 488ulti = TRUE','match');
       
       marker560CamA = regexpi(tline,'Saving Camera A 560multi = TRUE','match');
       marker560CamB = regexpi(tline,'Saving Camera B 560multi = TRUE','match');
       
       marker592CamA = regexpi(tline,'Saving Camera A 592multi = TRUE','match');
       marker592CamB = regexpi(tline,'Saving Camera A 592multi = TRUE','match');
       
       marker642CamA = regexpi(tline,'Saving Camera A 642multi = TRUE','match');
       marker642CamB = regexpi(tline,'Saving Camera B 642multi = TRUE','match');
       
       
       
       
       endMarker =regexpi(tline,'Saving Camera B 592hex','match'); 
       
       
       
       if(~isempty(marker405CamA))
           Meta.camSave(1,1) = 1;
       elseif (~isempty(marker405CamB))
           Meta.camSave(2,1) = 1;
       elseif (~isempty(marker488CamA))
           Meta.camSave(1,2) = 1;
       elseif (~isempty(marker488CamB))
           Meta.camSave(2,2) = 1;
       elseif (~isempty(marker560CamA))
           Meta.camSave(1,3) = 1;
       elseif (~isempty(marker560CamB))
           Meta.camSave(2,3) = 1;
       elseif (~isempty(marker592CamA))
           Meta.camSave(1,4) = 1;
       elseif (~isempty(marker592CamB))
           Meta.camSave(2,4) = 1;
       elseif (~isempty(marker642CamA))
           Meta.camSave(1,5) = 1;
       elseif (~isempty(marker642CamB))
           Meta.camSave(2,5) = 1;
       elseif (~isempty(endMarker))
           marker = 1;
       end
       
       
%        endMarker =regexpi(tline,'Shape (Triangle, Sine) = "Triangle"','match');
% %        idx = zeros(1,length(Meta.chan));
% %        if (marker)
% %            col = [488,560,642];
% %            for ii = 1:length(Meta.chan)
% %                idx(ii) = find(Meta.chan(ii) == col);
% %            end
% %            Meta.camSave =  Meta.camSave(:,idx);
% %        end
       
end
