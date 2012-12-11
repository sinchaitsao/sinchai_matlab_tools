function sinchai_breastDTI_arrange
dirList     = dir('*.dcm');
grads       = 64;
temp        = dicomread(dirList(1).name);
b0          = split52slice(temp);
dti         = zeros(192,192,52,2,64);
%img         = zeros(1536,1536,65);
%img(:,:,1)  = temp;

h = waitbar(0,'Please wait...');
for i = 2:65
    dti(:,:,:,1,i-1)    = b0;
    temp                = dicomread(dirList(i).name);
    dti(:,:,:,2,i-1)    = split52slice(temp);
    %img(:,:,i)          = temp;
    waitbar(i/65)
end
close(h);

output.b_val    = [ 0 700 ];
output.vox_size = [ 1.9 1.9 2 ];
output.img_mode = 2;
output.img      = zeros(129,129,52);
output.dti      = dti;

save arrangedData.mat -struct output;

end

function images = split52slice(input)
    images = zeros(192,192,52);
    for j=0:7
        for i=0:7
            if j*8+i+1<53
                images(:,:,j*8+i+1) = input(j*192+1:j*192+192,i*192+1:i*192+192);
            else
                return
            end
            
        end
    end
end