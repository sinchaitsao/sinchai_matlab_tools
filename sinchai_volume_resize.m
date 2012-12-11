function new_volume = sinchai_volume_resize(image_volume)

for j=1:size(image_volume,3)
   new_volume(:,:,j) = imresize(image_volume(:,:,j),0.5); 
end