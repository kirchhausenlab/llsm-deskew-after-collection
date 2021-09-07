clc;
delete(gcp('nocreate'))
parpool(100)

%%
clc
spmd

    % create a message (magic square) unique to each worker
    my_message = (labindex);

    % pass messages in a round robin
    right_neighbor = mod(labindex, numlabs)   + 1; % mablab is base 1 indexed
    left_neighbor  = mod(labindex-2, numlabs) + 1;
    labSend(my_message, right_neighbor);
    neighbors_message = labReceive(left_neighbor);

    % print the message that was just received
    fprintf('received the following from Lab %i:\n', left_neighbor)
    disp(neighbors_message)

end