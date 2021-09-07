function Time = getImWaitTime(Meta, N_stacks)
Time(length(Meta)) = struct();
expression = '_*msec_';
for ii = 1:length(N_stacks) % for each Ex
    if ii==19
        disp(1)
    end
    
    for jj = 1:length(N_stacks(ii).chan) % for each channel
          d = dir(char([N_stacks(ii).sourcedir{jj}])); % get the number of images per channel
          t_im = zeros(length(d),1);
          t_wait = t_im;
          if length(d) == 1 % if only there is one stack
              t_im = Meta(ii).tcycle * Meta(ii).planes;
              t_wait = 0;
          else % if more than one stack
              t_prev = 0;
              for kk = 2:length(d)
                  t_im(kk) = Meta(ii).tcycle * Meta(ii).planes*length(N_stacks(ii).chan);
                  idx = regexp(d(kk).name, expression);
                  t_total = str2double(d(kk).name(idx-7:idx-1));
                  t_image = t_total - t_prev;
                  t_wait(kk) = (t_image/1000 - t_im(kk));
                  if t_wait(kk) < 1e-3
                      t_wait(kk) = 0;
                  end
                  t_prev = t_total;
                  
              end
              
          end
          if ii==12
              disp(1)
          end
          if jj > 1 && (length(t_im) > length(Time(ii).t_im(:,jj-1)))
              
              temp_Time_t_im = zeros(length(t_im), jj-1);
              temp_Time_t_wait = zeros(length(t_im), jj-1);
              for ll = 1:jj-1
                  temp_Time_t_im(1:length(Time(ii).t_im(:,ll))) = Time(ii).t_im(:,ll);
                  temp_Time_t_wait(1:length(Time(ii).t_im(:,:))) = Time(ii).t_wait(:,ll);
              end
              Time(ii).t_im = temp_Time_t_im;
              Time(ii).t_wait = temp_Time_t_wait;
          end
          
          disp(ii);
          Time(ii).t_im(:,jj) = t_im;
          Time(ii).t_wait(:,jj) = t_wait;
          
    end



end