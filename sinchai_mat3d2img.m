function sinchai_mat3d2img(VoxelSize,varargin)

%-------------------------------------------------------------------------
% sinchai_dcm2img.m
%-------------------------------------------------------------------------
% Converts dicom files to Analyze .img files
%
% Options:
% 1) 'blue brain' = axial B0
%  cd into a folder with B0 dicom images only and execute this script
%
% 2) 'none' = axial data
%
% 3) 'sagittal' = sagittal data
%
% July 21, 2008
%-------------------------------------------------------------------------

load mat3d;
currentDir = pwd;
filePrefix = 'ANALYZE';

if nargin > 1
   filePrefix = varargin{1};
end

% Saving to .img file
   
size(mat3d)
anatdata = mat3d;
data_size = [size(anatdata,1) size(anatdata,2) size(anatdata,3)];

% write img file

%fullFN = fnames(3).name;
%filePrefix = fullFN(1:strfind(fullFN,'.dcm')-1);
file_name_w = [filePrefix '.img'];
fid_w = fopen(file_name_w,'w');
I = zeros(data_size(1),data_size(2));

for i = 1:data_size(3)
   I(:,:) = anatdata(:,:,i);
   %I = rot90(I,2);
   fwrite(fid_w,I,'int16'); 
end

fclose(fid_w);

%-------------------------------------------------------------------------
% Write Analyze Header
%-------------------------------------------------------------------------

P = [ currentDir '/' file_name_w ];
DIM = size(anatdata);
TYPE = 4;           %int16
SCALE = 1;
OFFSET = 0;
DESCRIP = 'defaults';
ORIGIN = [0 0 0];
VOX = VoxelSize;

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);