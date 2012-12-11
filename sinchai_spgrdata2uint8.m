function sinchai_spgrdata2uint8

%
%  anatdata2spm
%
%  input/load   spgrdata.mat     (x,y,z)
%  output        spgr.img
%
%  for SPM2

% Load Anatomy
load spgrdata.mat;   
anatDataSize = size(spgrdata)
anatdata = spgrdata;
data_size = [size(anatdata,1) size(anatdata,2) size(anatdata,3)];

% write spm anatomy
file_name_w = 'Hipp.img';
fid_w = fopen(file_name_w,'w');
I = zeros(data_size(1),data_size(2));
for i = 1:data_size(3)
   I(:,:) = anatdata(:,:,i);
   %I2 = fliplr(flipud(I));
   I2 = fliplr(I);
   %I2 = I;
   fwrite(fid_w,I2,'uint8'); 

   %file_name_wi = ['anat_spm' '_S' num2str(i)  '.img'];
   %fid_wi = fopen(file_name_wi,'w');
   %fwrite(fid_wi,I2,'ushort'); 
   %fclose(fid_wi);
   
end
fclose(fid_w);

% set Voxel Size Automatically
write_hdr = 1;
if anatDataSize(1)==128
    VOX = [2 2 4];
elseif anatDataSize(1)==256
    VOX = [1 1 4];
else
    fprintf('\n\n\nERROR: image size is not 128x128x? or 256x256x? HDR written will not be correct \n\n\n');
    write_hdr = 0;
end
        
if write_hdr
    %-------------------------Write HDR---------------------------------------
    currentDir = pwd;
    P = [ currentDir '/Hipp.img' ];
    DIM = anatDataSize;
    TYPE = 2;           %int16 (see below)

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
    %VOX = [2 2 4]

    s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);
    %-------------------------------------------------------------------------
end