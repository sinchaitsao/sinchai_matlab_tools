function sinchai_freesurfer_post_processing_step2(flag)
%
%------------------HELP FILE----------------------------------------------
%
% sinchai_freesurfer_post_processing_step2.m
%
% this file converts Freesurfer IMG files into proper format without the
% .mat directional cosine file, it also generates the appropriate header
% files for the new img files.
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

%-------------------------------------------------------------------------
%                               OPTIONS
%-------------------------------------------------------------------------
flag = 1;

%-------------------------------------------------------------------------

if exist('aseg.img')~=2
    error('Run MRI_convert first!!');
    return;
end


%----------------------------CHECK FLAGS-----------------------------------
% if flag = 1 will only run if no raseg.img file is present, IE the directory has not been previously processed.

if flag==1
    if exist('raseg.img','file')==2
        error('directory already processed');
        return
    end
end

%----------------------------ADJUST MGZ IMG output-------------------------
reshapeMGZoutput( 'aseg.img' );
reshapeMGZoutput( 'T1.img' );
delete('*mat');

%----------------------------Generate HDR files----------------------------
P = 'T1.hdr';
DIM = [256 256 256];
TYPE = 4;           %int16
SCALE = 1;
OFFSET = 0;
DESCRIP = 'defaults';
ORIGIN = [0 0 0];
VOX = [1 1 1];

s = ANALYZE_write_hdr(P,DIM,VOX,SCALE,TYPE,OFFSET,ORIGIN,DESCRIP);

copyfile('T1.hdr','aseg.hdr');

function reshapeMGZoutput( imageFile )

analyzeInfo = analyze75info( imageFile );

imageDim = double(analyzeInfo.Dimensions);
uint8_2mat1(imageDim(1),imageDim(2),imageDim(3),imageFile);
fs_vol_cor_ax2;
spgrdata2spm2;

delete('spgrdata.mat');
delete('orig_spgrdata.mat');
delete('uint8map.mat');
movefile('spgr.img',imageFile);

