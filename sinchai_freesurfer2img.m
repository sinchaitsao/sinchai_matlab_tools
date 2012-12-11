function  sinchai_freesurfer2img

load spgrdata.mat
save orig_spgrdata.mat spgrdata

old = flip_z_vol(spgrdata);

xs = size(old,1);
ys = size(old,2);
zs = size(old,3);

I = zeros(xs,zs);

%clear spgrdata

spgrdata = zeros(xs,zs,ys);

j = 0;
for i = 1:ys
    j = j+1;
    I(:,:) = old(:,i,:);
    spgrdata(:,:,j) = I(:,:); 
end

save spgrdata.mat spgrdata

currentDir = pwd;
file_name_w = 'spgr.img';
P = [ currentDir '/' file_name_w ];
DIM = [256 256 256];

TYPE = 132;
% prec = str2mat('uint8','int16','int32','float','double','int8','uint16','uint32','uint8','int16','int32','float','double','int8','uint16','uint32');
% types   = [    2      4      8   16   64   130    132    136,   512   1024   2048 4096 16384 33280  33792  34816];
% swapped = [    0      0      0    0    0     0      0      0,     1      1      1    1     1     1      1      1];
% maxval  = [2^8-1 2^15-1 2^31-1  Inf  Inf 2^7-1 2^16-1 2^32-1, 2^8-1 2^15-1 2^31-1  Inf   Inf 2^8-1 2^16-1 2^32-1];
% minval  = [    0  -2^15  -2^31 -Inf -Inf  -2^7      0      0,     0  -2^15  -2^31 -Inf  -Inf  -2^7      0      0];
% nanrep  = [    0      0      0    1    1     0      0      0,     0      0      0    1     1     0      0      0];
% bits    = [    8     16     32   32   64     8     16     32,     8     16     32   32    64     8     16     32];
% intt    = [    1      1      1    0    0     1      1      1,     1      1      1    0     0     1      1      1];

SCALE = 1;
OFFSET = 0;
DESCRIP = 'defaults';
ORIGIN = [0 0 0];
VOX = [1 1 1];

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);