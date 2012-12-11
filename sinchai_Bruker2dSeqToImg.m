function sinchai_Bruker2dSeqToImg(varargin)

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

% Parse Input arguments

if length(varargin)==1
    options = varargin{1};
else
    options = 'none';
end

%-------------------------------------------------------------------------
% Set Options
%-------------------------------------------------------------------------

if( strcmp(options,'blue_brain') )
    resizeIMG = 1;  % if 1, the image will be resized by half.
    VoxelSize = [2.0312 2.0312 2];
else
    resizeIMG = 0;
end

if resizeIMG
    fprintf('-------------\n WARNING \n Image will be resized by half \n -------------\n');
end

%-------------------------------------------------------------------------

currentDir = pwd;


delete('.*')

fnames = dir(pwd);

N = size(fnames,1) - 2
DCMinfo = dicominfo(fnames(3).name);

if resizeIMG
    % DO NOT READ VOXEL SIZE FROM DICOM HEADER USE VOXEL SIZE SETTINGS (SEE
    % ABOVE)
else
    VoxelSize = [DCMinfo.PixelSpacing;DCMinfo.SliceThickness];
    VoxelSize = VoxelSize';
end

II = dicomread(DCMinfo);

if resizeIMG
    mat3d = zeros(size(II,1)/2,size(II,2)/2,N);
else
    mat3d = zeros(size(II,1),size(II,2),N);
end

finfo = [];

for i = 3:length(fnames)
    fname = fnames(i).name;
    finfo = dicominfo(fname);
    fprintf(['reading file...' fname '\n']);

    Inst_no = finfo.InstanceNumber;
    Sl_loc = finfo.SliceLocation;
    II = dicomread(finfo);
    
    if resizeIMG
        II = imresize(II,0.5,'bilinear');
    end
    
    if strcmpi(options,'sagittal')
        mat3d(:,:,Inst_no) = flipud(rot90(II,3));
    else
        mat3d(:,:,Inst_no) = rot90(II,3); % to our mat orientation standard
    end
end

% get the dimensions right
if strcmpi(options,'sagittal')
    mat3d = shiftdim(mat3d,2);
end

fprintf('dicom file read done...');

% Saving to .img file
   
size(mat3d)
anatdata = mat3d;
data_size = [size(anatdata,1) size(anatdata,2) size(anatdata,3)];

% write img file

%fullFN = fnames(3).name;
%filePrefix = fullFN(1:strfind(fullFN,'.dcm')-1);
filePrefix = 'ANALYZE';
file_name_w = [filePrefix '.img'];
fid_w = fopen(file_name_w,'w');
I = zeros(data_size(1),data_size(2));

for i = 1:data_size(3)
   I(:,:) = anatdata(:,:,i);
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