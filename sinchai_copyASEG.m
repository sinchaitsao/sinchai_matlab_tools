`function sinchai_copyASEG(category,subject)

try
    cd(['/data7/post_freesurfer_USC_AD/' category '/' subject]);
catch
    mkdir(['/data7/post_freesurfer_USC_AD/' category '/' subject]);
    cd(['/data7/post_freesurfer_USC_AD/' category '/' subject]);
end

eval(['!cp /data7/freesurfer_subjects_USC_AD/' category '/' subject ...
    '/mri/aseg.mgz /data7/post_freesurfer_USC_AD/' category '/' subject]);

eval(['!cp /data7/freesurfer_subjects_USC_AD/' category '/' subject ...
    '/mri/T1.mgz /data7/post_freesurfer_USC_AD/' category '/' subject]);

!mri_convert aseg.mgz aseg_orig.img
!mri_convert T1.mgz T1.img
!rm aseg_orig.mat
uint8_2mat1(256,256,256,'aseg_orig.img');

clear all;
fs_vol_cor_ax2;
spgrdata2spm2;
!mv spgr.img aseg.img
%-------------------------------------------------------------------------
% Write Analyze Header
%-------------------------------------------------------------------------
load('spgrdata.mat')
currentDir = pwd;
file_name_w = 'aseg.img';
P = [ currentDir '/' file_name_w ];
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
VOX = [1 1 1];

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);
clear all;

%-------------------------------------------------------------------------
% Save Hippocampus Region
%-------------------------------------------------------------------------
load('spgrdata.mat');
spgrdata = spgrdata==53;
save spgrdata spgrdata;
clear all;
spgrdata2spm2;
!cp spgr.img hipp.img
!cp aseg.hdr hipp.hdr

%-------------------------------------------------------------------------
% cleans up folder
%-------------------------------------------------------------------------
delete('uint8map.mat');
delete('orig_spgrdata.mat');
delete('spgrdata.mat');