%
%   This function writes the mask in neurotract out into an analyze file
%
%   by Sinchai Tsao 3/9/2011
%
function success = sinchai_write_NTract_mask(tensor_data)
success = 0;

[ unzoom_mask ] = NTract_unzoom(tensor_data,tensor_data.mask);
for i=1:size(unzoom_mask,3)
    unzoom_mask(:,:,i) = fliplr(unzoom_mask(:,:,i));
end
sinchai_matrix2img(unzoom_mask,'mask',tensor_data.vox_size,'double');