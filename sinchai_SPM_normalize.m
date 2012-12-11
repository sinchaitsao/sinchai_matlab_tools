function sinchai_SPM_normalize(varargin)
%-------------------------------------------------------------------------
% sinchai_SPM_normalize.m
%-------------------------------------------------------------------------
% performs SPM normalization
%
% Options:
%
% 1) Just Transform the Image with pre-specified SN file
%
%       sinchai_SPM_normalize(<full-path-to-SN-MATRIX-file>,...
%           <full-path-to-IMAGE-TO-TRANSFORM-file>);
%
% Example:
%
% sinchai_SPM_normalize('/home/dti4/image_data/071708D1_SPGR/hipp_calc/ANALYZE_sn.mat',...
%    '/home/dti4/image_data/071708D1_SPGR/hipp_calc/ANALYZE.img');
%
%
% 2) Generate SN file Only
%
%       sinchai_SPM_normalize(<full-path-to-SOURCE-file>,...
%           <full-path-to-OUTPUT-SN-MATRIX-file>,...
%           <full-path-to-TEMPLATE-file>);
%
% Example:
%
% sinchai_SPM_normalize('/home/dti4/image_data/071708D1_SPGR/hipp_calc/ANALYZE.img',...
%    '/home/dti4/image_data/071708D1_SPGR/hipp_calc/ANALYZE_sn.mat',...
%    '/home/image/spm2/templates/T1.mnc');
%
%
% 3) Generate SN file and Transform prespecified image
%
%       sinchai_SPM_normalize(<full-path-to-SOURCE-file>,...
%        	<full-path-to-OUTPUT-SN-MATRIX-file>,...
%       	<full-path-to-IMAGE-TO-TRANSFORM-file>,...
%         	<full-path-to-TEMPLATE-file>);
%
% Example:
% 
% sinchai_SPM_normalize('/home/dti4/image_data/071708D1_SPGR/hipp_calc/ANALYZE.img',...
%     '/home/dti4/image_data/071708D1_SPGR/hipp_calc/ANALYZE_sn.mat',...
%     '/home/dti4/image_data/071708D1_SPGR/hipp_calc/ANALYZE.img',...
%     '/home/image/spm2/templates/T1.mnc');
%
%
%
% Written by Sinchai Tsao
% PhD Candidate, University of Southern California
% ON
% Aug 5, 2008
%-------------------------------------------------------------------------

normalize = 0;
write_sn = 0;

    % Just Transform the Image with pre-specified SN file
if nargin < 3
    matrix_file = varargin{1};
    image_to_transform = varargin{2};
    write_sn = 1;

    % Generate SN file Only
elseif nargin < 4
    source_file = varargin{1};
    matrix_file = varargin{2};
    Template = varargin{3}
    normalize = 1;


    % Generate SN file and Transform prespecified image
elseif nargin < 5
    source_file = varargin{1};
    matrix_file = varargin{2};
    image_to_transform = varargin{3};
    Template = varargin{4};
    normalize = 1;
    write_sn = 1;
else
    fprintf('inputs to function sinchai_SPM_normalize are not correct, please check and rerun function');
    return
end


% Template = '/home/image/spm2/templates/T1.mnc';                                         % Template File
% source_file = '/home/dti4/image_data/071708D1_SPGR/hipp_calc/ANALYZE.img';              % Source File
% matrix_file = '/home/dti4/image_data/071708D1_SPGR/hipp_calc/ANALYZE_sn.mat';           % Matfile to write to
% image_to_transform = '/home/dti4/image_data/071708D1_SPGR/hipp_calc/ANALYZE.img';       % Image to Transform

objmask = '';                                                                             % Mask File (Not Used)
defs.estimate.smsrc = 8;
defs.estimate.smoref = 0;
defs.estimate.regtype = 'mni';
defs.estimate.weight = '';
defs.estimate.cutoff = 25;
defs.estimate.nits = 16;
defs.estimate.reg = 1;
defs.estimate.wtsrc = 0;

defs.write.preserve = 0;
defs.write.bb = [ -78 -112 -50 ; 78 76 85 ];
defs.write.vox = [2 2 2];
defs.write.interp = 1;
defs.write.wrap = [0 0 0];

if normalize
    spm_normalise(Template, source_file, matrix_file,...
        defs.estimate.weight, objmask,defs.estimate);
end

if write_sn
    spm_write_sn(image_to_transform,matrix_file,defs.write);
end
