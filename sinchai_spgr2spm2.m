function sinchai_spgr2spm2

%-------------------------------------------------------------------------
% sinchai_spgr2spm2.m
%-------------------------------------------------------------------------
% converts cor3Dfspgr images in DICOM to ANALYZE format
% checks to see if the cor are from A-P or P-A
%-------------------------------------------------------------------------
clear all;
dirList = dir;
dcminfo = dicominfo(dirList(6).name);
a = dcminfo.SliceThickness;
b = dcminfo.PixelSpacing;
VoxelSize = [ b(1) a b(2) ]
for i=5:7
    dcminfo = dicominfo(dirList(i).name);
    ['Slice Location:' num2str(dcminfo.SliceLocation)]
end
%pause;

dcm2mat3d;
load mat3d;
spgrdata = mat3d;
save spgrdata spgrdata;
clear spgrdata mat3d;
vol_cor_ax;
spgrdata2spm2;


load spgrdata.mat;
currentDir = pwd;
P = [ currentDir '/spgr.img' ];
DIM = size(spgrdata);
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
VOX = VoxelSize;

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);
cd(currentDir);
close all;