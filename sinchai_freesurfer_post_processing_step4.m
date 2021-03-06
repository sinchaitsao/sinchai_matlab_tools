function sinchai_freesurfer_post_processing_step4(loc)

%
% ---------------------Help File------------------------------------------
% sinchai_freesurfer_post_processing_step4.m
%
% resizes raseg.img to 128x128x? and extracts:
%   1) Hippocampus (pixel value = 53)
%
% Written by Sinchai Tsao
% PhD Candidate Dept BME, USC
% Research Asst, Biomedical Imaging Laboratory,Dept of Radiology and BME,USC
% on Oct 9, 2008
% ------------------------------------------------------------------------
%
mkdir('HippROI');
%resizes image from 256 by 256 to 128 by 128 in the x-y direction
uint8_2mat1(256,256,60,'raseg.img');
info=analyze75info('raseg.hdr');
load spgrdata.mat;


for i=1:size(spgrdata,3)
    new_spgrdata(:,:,i) = imresize(spgrdata(:,:,i),0.5,'nearest');
end


spgrdata = (new_spgrdata == 17);
save spgrdata.mat spgrdata
spgrdata2spm2;
movefile('spgr.img','HippROI/leftHipp.img');

spgrdata = (new_spgrdata == 53);
save spgrdata.mat spgrdata
spgrdata2spm2;
movefile('spgr.img','HippROI/rightHipp.img');

spgrdata = (new_spgrdata == 4);
save spgrdata.mat spgrdata
spgrdata2spm2;
movefile('spgr.img','HippROI/leftVentricle.img');

spgrdata = (new_spgrdata == 43);
save spgrdata.mat spgrdata
spgrdata2spm2;
movefile('spgr.img','HippROI/rightVentricle.img');

% spgrdata = (new_spgrdata == 9);
% save spgrdata.mat spgrdata
% spgrdata2spm2;
% movefile('spgr.img','HippROI/leftThalamus.img');
% 
% spgrdata = (new_spgrdata == 48);
% save spgrdata.mat spgrdata
% spgrdata2spm2;
% movefile('spgr.img','HippROI/rightThalamus.img');
% 
% delete('int16map.mat');
% delete('spgrdata.mat');


cd('HippROI');

%-------------------------Write HDR---------------------------------------
currentDir = pwd;

DIM = [128 128 60];
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
VOX=[info.PixelDimensions(1)*2 info.PixelDimensions(2)*2 info.PixelDimensions(3)];
% VOX = [2 2 4];

region(1).name = 'leftHipp.img';
region(2).name = 'rightHipp.img';
region(3).name = 'leftVentricle.img';
region(4).name = 'rightVentricle.img';

for i=1:length(region)
    P = fullfile(currentDir,region(i).name);
    s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);
end


%-------------------------------------------------------------------------
% copy files back to Data7 if "loc" variable is provided
if (nargin>0)
    fprintf('\n\nCopying Files back to Data7 Archive...\n\n');
    if strcmpi(loc,'img')
        currDir = pwd;
        matches = regexpi(currDir,'\/[a-z0-9]*');
        matchLength = length(matches);
        subject = currDir((matches(matchLength-1)+1):(matches(matchLength)-1));
        type = currDir((matches(matchLength-2)+1):(matches(matchLength-1)-1));
        copyfile(['/home1/image/USC_AD/post_freesurfer_USC_AD/' type '/' subject],...
            ['/data7/post_freesurfer_USC_AD/' type '/' subject]);
    end
end