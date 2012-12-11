function sinchai_matrix2img(variable,filePrefix,VoxelSize,format,analyze75readComp)

%-------------------------------------------------------------------------
% sinchai_matrix2img.m
%-------------------------------------------------------------------------
% Converts 3d variable (ie 128 by 128 by 28)  to Analyze .img files
%
%
% eg. sinchai_matrix2img(FA_fullsize,'FA',[2 2 4],'double');
%
% eg. sinchai_matrix2img(FA_fullsize,'FA',[2 2 4],'double',1);
%       uses rot90 twice to compensate for analyze75read function
%
% July 31, 2009
%-------------------------------------------------------------------------

% Saving to .img file
   
size(variable);
data_size = size(variable);
if ~exist('filePrefix')==1
    filePrefix = 'volume';
end
disp(['writing file...' filePrefix '.img']);
% write img file

%fullFN = fnames(3).name;
%filePrefix = fullFN(1:strfind(fullFN,'.dcm')-1);
file_name_w = [filePrefix '.img'];
fid_w = fopen(file_name_w,'w');

for i = 1:data_size(3)
   I = variable(:,:,i);
   dim(3)=1;

   if exist('analyze75readComp','var')
       if analyze75readComp==1
           I = fliplr(rot90(I,-1));
       end
   else
        I = fliplr(rot90(I,1));  
   end 
   fwrite(fid_w,I,format); 
end

fclose(fid_w);

% get file type

if strcmpi(format,'uint8')
    TYPE=2;
elseif strcmpi(format,'int16')
    TYPE=4;
elseif strcmpi(format,'int32')
    TYPE=8;
elseif strcmpi(format,'float')
    TYPE=16;
elseif strcmpi(format,'double')
    TYPE=64;
elseif strcmpi(format,'int8')
    TYPE=130;
elseif strcmpi(format,'uint16')
    TYPE=132;
elseif strcmpi(format,'uint32')
    TYPE=136;
end

%-------------------------------------------------------------------------
% Write Analyze Header
%-------------------------------------------------------------------------
dim = size(variable);
P = [ pwd '/' file_name_w ];
DIM = [ dim(2) dim(1) dim(3)];
% type =  4 %type is determined above
SCALE = 1;
OFFSET = 0;
DESCRIP = 'defaults';
ORIGIN = DIM/2;
VOX = VoxelSize;

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);