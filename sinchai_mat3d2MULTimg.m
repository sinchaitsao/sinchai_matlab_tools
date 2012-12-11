function sinchai_mat3d2MULTimg(VoxelSIZE,NumofVols)

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
global currentDir anatdata VoxelSize file_name_w I num_img_per_vol
VoxelSize = VoxelSIZE;
currentDir = pwd;
% Saving to .img file
   
size(mat3d)
anatdata = mat3d;
data_size = [size(anatdata,1) size(anatdata,2) size(anatdata,3)];
num_img_per_vol = data_size(3)/NumofVols;

% write img file

%fullFN = fnames(3).name;
%filePrefix = fullFN(1:strfind(fullFN,'.dcm')-1);

for j = 0:(NumofVols-1)
    filePrefix = 'ANALYZE';
    file_name_w = [filePrefix '_' num2str(j) '.img'];
    fid_w = fopen(file_name_w,'w');
    I = zeros(data_size(1),data_size(2));
    for i = j*num_img_per_vol+1:1*(j+1)*num_img_per_vol
        I(:,:) = anatdata(:,:,i);
        fwrite(fid_w,I,'int16');
    end
    writeHeader();
end

fclose(fid_w);


%-------------------------------------------------------------------------
% Write Analyze Header
%-------------------------------------------------------------------------
function writeHeader
global currentDir anatdata VoxelSize file_name_w I num_img_per_vol
P = [ currentDir '/' file_name_w ];
DIM = [size(I) num_img_per_vol];
TYPE = 4;           %int16
SCALE = 1;
OFFSET = 0;
DESCRIP = 'defaults';
ORIGIN = [0 0 0];
VOX = VoxelSize;

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);