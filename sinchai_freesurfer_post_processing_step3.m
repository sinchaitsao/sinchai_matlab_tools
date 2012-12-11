function sinchai_freesurfer_post_processing_step3(T1Origin,BzeroOrigin)
%
%------------------HELP FILE----------------------------------------------
%
% sinchai_freesurfer_post_processing_step3.m
%
%       sinchai_freesurfer_post_processing_step3(T1Origin,BzeroOrigin)
%
%       Example:
%       sinchai_freesurfer_post_processing_step3( [127 146 110] , [128 147 14] )
%
% this files sets the origins of the two header files for T1 and aseg and
% resizes and generates the HIPP ROI files
%
% freesurfer post processing workflow:
%
%   sinchai_freesurfer_post_processing_step1.m
%   mri_convert aseg.mgz aseg.img
%   mri_convert T1.mgz T1.img
%   sinchai_freesurfer_post_processing_step2.m
%   find origin using SPM
%   sinchai_freesurfer_post_processing_step3(<T1Origin>,<BzeroOrigin>)
%   coregister T1 with Bzero and apply it to aseg using SPM
%   sinchai_freesrufer_post_processing_step4
%

%----------------------------Generate HDR files----------------------------
header = analyze75info('T1.img');
P = 'T1.hdr';
DIM = header.Dimensions(1:3);
TYPE = 4;           %int16
SCALE = 1;
OFFSET = 0;
DESCRIP = 'defaults';
ORIGIN = T1Origin;
VOX = header.PixelDimensions;

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);


clear header;

%--------------------------Copies T1 HDR to Aseg HDR file-----------------
copyfile('T1.hdr','aseg.hdr');

%----------------------------Generate HDR files----------------------------
header = analyze75info('Bzero256.img');
P = 'Bzero256.hdr';
DIM = header.Dimensions(1:3);
TYPE = 4;           %int16
SCALE = 1;
OFFSET = 0;
DESCRIP = 'defaults';
ORIGIN = BzeroOrigin;
VOX = header.PixelDimensions;

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);