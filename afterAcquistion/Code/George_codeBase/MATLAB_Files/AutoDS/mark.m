function mark(st, destination)
name = sprintf('Created_%s_line_%d.txt', st.name, st.line);
save(fullfile(destination,name));
end
