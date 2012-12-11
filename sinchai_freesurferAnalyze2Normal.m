function sinchai_freesurferAnalyze2Normal(file)
% Written by Sinchai Tsao 9/14/2009
%
% Use to convert mri_convert output ANALYZE files to a more standard format
% and correct for neurological -> radiological problems.
%
% Usage: sinchai_freesurferAnalayze2Normal('T1');
%
%

T1 = analyze75read([ file '.img' ]);
T1_info = analyze75info([ file '.img' ]);
file_name_w = [file '_new.img'];
fid_w = fopen(file_name_w,'w');

T1_size = size(T1);
T1_new = zeros([ T1_size(3) T1_size(2) ]);

for j=T1_size(1):-1:1
    T1_new = squeeze(T1(j,:,:));
    fwrite(fid_w,T1_new,'uint8');
end

fclose(fid_w);

% file type = uint8
TYPE = 2;

%-------------------------------------------------------------------------
% Write Analyze Header
%-------------------------------------------------------------------------

P = [ pwd '/' file_name_w ];
DIM = [ T1_size(3) T1_size(2) T1_size(1)];
% type =  4 %type is determined above
SCALE = 1;
OFFSET = 0;
DESCRIP = 'defaults';
ORIGIN = [0 0 0];
VOX = T1_info.PixelDimensions;

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);