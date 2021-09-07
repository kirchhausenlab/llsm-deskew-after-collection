function str = getTime
    a = clock;
    str = sprintf('%04d%02d%02d_%02d:%02d;%2.2f',a(1),a(2),a(3),a(4),a(5),a(6));
end