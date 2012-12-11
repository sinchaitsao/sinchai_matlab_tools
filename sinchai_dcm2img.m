function sinchai_dcm2img(outputName,varargin)

%-------------------------------------------------------------------------
% sinchai_dcm2img.m
%-------------------------------------------------------------------------
% Converts dicom files to Analyze .img files
%
% sinchai_dcm2img(FILENAME);
%          OR
% sinchai_dcm2img(FILENAME,'OptionName','OptionValue');
%
% Options:       OptionName    OptionValue
%                'VoxelSize'    [x x x]
%                'OrderBy'      'filename'
%                     "         'InstanceNo'
%                     "         'InstanceNoReversed'
%                     "         'SliceLocationReversed'
%                'Options'      'blue brain'
%                     "         'none'
%                     "         'sagittal'
%                     "         'coronal'
%
%
% Default is order by Slice Location
%
% Example for SPGR use:
%       sinchai_dcm2img('SPGR','OrderBy','InstanceNo','Options','coronal');
%
%
% revised July 21, 2009
%-------------------------------------------------------------------------

% Parse Input arguments
options = 'none';
if ~exist('outputName','var')
    outputName = 'ANALYZE';
end

if nargin ~= 2 || nargin ~= 4
   display('Number of arguments are not correct'); 
end

if nargin > 1
    if strcmp(varargin{1},'VoxelSize')
        VoxelSize = varargin{2};
    elseif strcmpi(varargin{1},'OrderBy')
        if strcmpi(varargin{2},'filename')
            orderIM = 1;
        elseif strcmpi(varargin{2},'InstanceNo')
            orderIM = 2;
        elseif strcmpi(varargin{2},'InstanceNoReversed')
            orderIM = 5;
        elseif strcmpi(varargin{2},'SliceLocationReversed')
            orderIM = 4;
            display('Using Slice Location to order images... order is REVERSED');
        end
    elseif strcmpi(varargin{1},'options')
        options = varargin{2};
    end
else
    orderIM = 3;
    display('Using Slice Location to order images...');
end


if nargin > 3
    if strcmp(varargin{3},'VoxelSize')
        VoxelSize = varargin{4};
    elseif strcmpi(varargin{3},'OrderBy')
        if strcmpi(varargin{4},'filename')
            orderIM = 1;
        elseif strcmpi(varargin{4},'InstanceNo')
            orderIM = 2;
        elseif strcmpi(varargin{4},'InstanceNoReversed')
            orderIM = 5;
        elseif strcmpi(varargin{4},'SliceLocationReversed')
            orderIM = 4;
            display('Using Slice Location to order images... order is REVERSED');
        end
    elseif strcmpi(varargin{3},'options')
        options = varargin{4};
    end
end

%-------------------------------------------------------------------------
% Set Options
%-------------------------------------------------------------------------

% Displays images slice by slice
debug = 0;

% How to order images
%orderIM = 1;        %Order images by how you read the files IE filename
%orderIM = 2;        %Order images by Instance No
%orderIM = 3;        %Order images by Slice Location

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

if( strcmp(options,'blue_brain') )
    fprintf('Blue Brain settings Selected\n\n');
    resizeIMG = 1;  % if 1, the image will be resized by half.
    VoxelSize = [2.0312 2.0312 4];
else
    resizeIMG = 0;
end

if resizeIMG
    fprintf('-------------\n WARNING \n Image will be resized by half \n -------------\n');
end

%-------------------------------------------------------------------------

currentDir = pwd;


delete('.*');

fnames = dir(pwd);

N = size(fnames,1) - 2

% Get DICOM header information
for k=3:length(currentDir)
    try
        DCMinfo = dicominfo(fnames(k).name);
        break;
    catch
        if k==length(currentDir)
            display('Cannot get dicominfo see line 59 of the code');
        end
    end
end

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
    %mat3d = zeros(size(II,1),size(II,2),N);
end

%initialize Slice Location array
Sl_loc = zeros(N,1);
Inst_no = zeros(N,1);

finfo = [];

Image_Count = 1;

for i = 3:length(fnames)
    fname = fnames(i).name;
    try
        finfo = dicominfo(fname);
        successDCMread = 1;
    catch
        display([fnames(i).name ' is not a dcm file... skipping...']);
        successDCMread = 0;
    end

    if(successDCMread)
        fprintf(['reading file...' fname '\n']);

        Inst_no(Image_Count)                = finfo.InstanceNumber;
        Sl_loc(finfo.InstanceNumber)        = finfo.SliceLocation;
        II                                  = dicomread(finfo);

        if debug
            imshow(II,[]);
            pause;
        end

        if resizeIMG
            II = imresize(II,0.5,'nearest');
        end

        if orderIM==1 || orderIM==5 || orderIM==2
            j = Image_Count;
        else
            j = finfo.InstanceNumber;
        end

        if strcmpi(options,'sagittal')
            mat3d(:,:,j) = flipud(rot90(II,3));
        else
            mat3d(:,:,j) = rot90(II,3); % to our mat orientation standard
        end

        Image_Count = Image_Count + 1;
    end

end

if orderIM==2
    display('sorting slices based on instance number...');
    [result,index] = sort(Inst_no);
    mat3d = mat3d(:,:,index);
elseif orderIM==3
    display('sorting slices based on slice location...');
    [result,index] = sort(Sl_loc);
    mat3d = mat3d(:,:,index);
elseif orderIM==4
    display('sorting slices based on slice location... THE ORDER is REVERSED');
    [result,index] = sort(Sl_loc);
    totalLength = length(index);
    newIndex = totalLength + 1 - index;
    mat3d = mat3d(:,:,newIndex);
elseif orderIM==5
    display('sorting slices based on Instance Number... THE ORDER is REVERSED');
    [result,index] = sort(Inst_no);
    totalLength = length(index);
    newIndex = totalLength + 1 - index;
    mat3d = mat3d(:,:,newIndex);
end

display('dicom file read done...');


% get the dimensions right
if strcmpi(options,'sagittal')
    display('Making images Axial from Sagittal!');
    mat3d = shiftdim(mat3d,2);
elseif strcmpi(options,'coronal')
    display('Making images Axial from Coronal!');
    mat3d = shiftdim(mat3d,1);
    mat3d = shiftdim(mat3d,1);
    for i=1:size(mat3d,2)
        newmat3d(:,:,i) = rot90(mat3d(:,:,i),-1);
    end
    clear mat3d;
    mat3d = newmat3d;
    clear newmat3d;
end

% Saving to .img file

size(mat3d)
anatdata = mat3d;
data_size = [size(anatdata,1) size(anatdata,2) size(anatdata,3)];

% write img file

%fullFN = fnames(3).name;
%filePrefix = fullFN(1:strfind(fullFN,'.dcm')-1);
filePrefix = outputName;
file_name_w = [filePrefix '.img'];
mkdir(outputName);
cd(outputName);
fid_w = fopen(file_name_w,'w');

I = zeros(data_size(1),data_size(2));

for i = 1:data_size(3)
    I(:,:) = int16(round(anatdata(:,:,i)));
    fwrite(fid_w,I,'int16');
end

fclose(fid_w);

%-------------------------------------------------------------------------
% Write Analyze Header
%-------------------------------------------------------------------------

P = [ currentDir '/' outputName '/' file_name_w ];
DIM = size(anatdata);
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
VOX = VoxelSize

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);
cd(currentDir);