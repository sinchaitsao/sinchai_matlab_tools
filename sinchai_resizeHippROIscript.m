function sinchai_resizeHippROI

%resizes image from 256 by 256 to 128 by 128 in the x-y direction
int16_2mat1(256,256,28,'raseg.img');
load spgrdata.mat;
spgrdata = (spgrdata == 53);

for i=1:28
    new_spgrdata(:,:,i) = imresize(spgrdata(:,:,i),0.5,'nearest');
end

spgrdata = new_spgrdata;
save spgrdata.mat spgrdata
spgrdata2spm2;
delete('uint8map.mat');
delete('orig_spgrdata.mat');
delete('spgrdata.mat');
mkdir('HippROI');
movefile('spgr.img','HippROI/Hipp.img');
cd('HippROI');
%-------------------------Write HDR---------------------------------------
currentDir = pwd;
P = [ currentDir '/Hipp.img' ];
DIM = [128 128 28];
TYPE = 4;           %int16 (see below)

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
VOX = [2 2 4]

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);
%-------------------------------------------------------------------------