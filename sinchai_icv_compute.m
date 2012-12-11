function sinchai_icv_compute(threshold,name)
%
% ---------------------Help File------------------------------------------
% sinchai_icv_compute.m
%
% run's Wit's compute_icv and saves the segmented image
%
% You need to set the threshold (suggested value = 0.8)
%
%           sinchai_icv_compute(<threshold>,'rspgr')
%
% Written by Sinchai Tsao
% PhD Candidate Dept BME, USC
% Research Asst, Biomedical Imaging Laboratory,Dept of Radiology and BME,USC
% on Oct 9, 2008
% ------------------------------------------------------------------------
%

if nargin < 1
    threshold = 0.8;
    name = 'spgr';
elseif nargin < 2
    name = 'spgr';
end

segname = [name '_seg'];
hdrInfo = analyze75info([segname '1.img']);

xs = double(hdrInfo.Dimensions(1));
ys = double(hdrInfo.Dimensions(2));
zs = double(hdrInfo.Dimensions(3));
xd = hdrInfo.PixelDimensions(1);
yd = hdrInfo.PixelDimensions(2);
zd = hdrInfo.PixelDimensions(3);
th = threshold

v = xd*yd*zd;

T = zeros(xs,ys,zs); T1 = T; T2 = T; T3 = T;

M = uint8_2mat(xs,ys,zs,segname,1,3);
T1(:,:,:) = M(:,:,:,1); T2(:,:,:) = M(:,:,:,2); T3(:,:,:) = M(:,:,:,3);
T = (T1+T2+T3)./255;

C = double(myroicolor(T,th,1));
Vc = sum(sum(sum(C)));
V = Vc*v

save ICV.mat V Vc th v xs ys zs M T
fid = fopen('ICV.txt','w');
fprintf(fid,num2str(V));

delete(['f_' name '.mat'])
delete(['uint8_' name '.mat'])
delete('floatmap.mat')
delete('uint8map.mat')
delete(['uint8_' name '*.mat'])

% % Save original SPGRs
% mkdir('orig_spgr');
% if exist('spgr.img','file') == 2
%     movefile('spgr.img','orig_spgr/spgr.img');
%     movefile('spgr.mat','orig_spgr/spgr.mat');
%     movefile('spgr.hdr','orig_spgr/spgr.hdr');
% end
% 
% % Save Segmented Volume
% spgrdata = C;
% save spgrdata.mat spgrdata;
% spgrdata2spm2;
% delete('spgrdata.mat');
% movefile('spgr.img','icv.img');
% if exist('rspgr.hdr','file') == 2
%     copyfile('rspgr.hdr','icv.hdr');
% else
%     fprintf('\n\nNo header file exists for icv.img, you need to create one\n\n');
% end