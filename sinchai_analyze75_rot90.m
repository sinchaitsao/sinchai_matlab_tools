function rot90_output = sinchai_analyze75_rot90(data)

rot90_output = zeros(size(data));

for j=1:size(data,3)
    rot90_output(:,:,j) = rot90(data(:,:,j),2);
end