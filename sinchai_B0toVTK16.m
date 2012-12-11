function sinchai_B0toVTK16(varargin)

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

currentDir = pwd;


delete('.*')

fnames = dir(pwd);

N = size(fnames,1) - 2
DCMinfo = dicominfo(fnames(3).name);


VoxelSize = [DCMinfo.PixelSpacing;DCMinfo.SliceThickness];
VoxelSize = VoxelSize';


II = dicomread(DCMinfo);



mat3d = zeros(size(II,1),size(II,2),N);

finfo = [];

for i = 3:length(fnames)
    fname = fnames(i).name;
    finfo = dicominfo(fname);
    fprintf(['reading file...' fname '\n']);

    Inst_no = finfo.InstanceNumber;
    Sl_loc = finfo.SliceLocation;
    II = dicomread(finfo);



    mat3d(:,:,Inst_no) = rot90(II,3); % to our mat orientation standard

end


fprintf('dicom file read done...');

% Saving to int16 data file file

size(mat3d)
anatdata = mat3d;
data_size = [size(anatdata,1) size(anatdata,2) size(anatdata,3)];

mkdir('vtk16_output');
cd('vtk16_output');
filePrefix = 'vtk16format';


for i = 1:data_size(3)
    file_name_w = [filePrefix '.img'];
    fid_w = fopen([file_name_w '.' num2str(i)],'w');
    I = zeros(data_size(1),data_size(2));
    I(:,:) = anatdata(:,:,i);
    fwrite(fid_w,I,'int16');
    fclose(fid_w);
end

cd(currentDir);