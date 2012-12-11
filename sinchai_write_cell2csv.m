function sinchai_write_cell2csv(name,input);

[fid, message] = fopen(name, 'w');
display(message);

for i=1:length(input)
    fwrite(fid, input{i}, 'char');
    fwrite(fid,',','char');
end
fclose(fid);

    