function sinchai_B0imgtoVTK16(varargin)

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
    filename = varargin{1};
else
    options = 'none';
end


%-------------------------------------------------------------------------


b = analyze75info('filename');
anatdata = analyze75read(b);

currentDir = pwd;
% Saving to int16 data file file
data_size = [size(anatdata,1) size(anatdata,2) size(anatdata,3)];

mkdir('anat_vtk16_output');
cd('anat_vtk16_output');
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