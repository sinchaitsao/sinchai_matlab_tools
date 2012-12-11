function sinchai_anatO2vtk_bluebrain
%
% Script converts an AnatO.mat data into vtk blue brain data to be read by
% vtkVolume16Reader.
%
% outputs vtk anatomy output into anat_vtk16_output folder
%
load('AnatO.mat');

anatdata = AnatO;
clear AnatO;
max2 = max(anatdata(:));
anatdata = (anatdata./max2).*127;
anatdata = smooth3(anatdata);

currentDir = pwd;
% Saving to int16 data file file
data_size = [size(anatdata,1) size(anatdata,2) size(anatdata,3)];

mkdir('anat_vtk16_output');
cd('anat_vtk16_output');
filePrefix = 'vtk16format';

counter = 1;
for i = data_size(3):-1:1
    file_name_w = [filePrefix '.img'];
    fid_w = fopen([file_name_w '.' num2str(counter)],'w');
    I = zeros(data_size(1),data_size(2));
    I(:,:) = anatdata(:,:,i);
    fwrite(fid_w,I,'int16');
    fclose(fid_w);
    counter = counter + 1;
end

cd(currentDir);