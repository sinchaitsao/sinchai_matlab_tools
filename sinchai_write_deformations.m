function sinchai_write_deformations(sn_filename)
%-------------------------------------------------------------------------
% sinchai_write_deformations.m
%-------------------------------------------------------------------------
% extracts deformation map (Y_<XXX>.hdr, Y_<XXX>.img from SPM's <XXX>_sn.mat file
%
%   Example:
%       sinchai_write_deformations('/home1/image/FA_sn.mat');
%
%   Adapted from: spm_Deformations.m in the SPM2 Deformations Toolkit
%           Copied: spm_write_defs and bbvox_from_V functions from
%           spm_deformations.m
%
%
%_____ Original SPM Function definition ________________________________
% function spm_write_defs(sn, vox,bb)
% Write deformation field.
% FORMAT spm_write_defs(sn, vox,bb)
% sn  - information from the `_sn.mat' file containing the spatial
%         normalization parameters.
% The deformations are stored in y1.img, y2.img and y3.img
%_______________________________________________________________________
%
%
% Written by Sinchai Tsao
% PhD Candidate, University of Southern California
% ON
% Aug 8, 2008
%-------------------------------------------------------------------------


%--------------------- Added by Sinchai --------------------------
sn = load(sn_filename);
sn.fname = sn_filename;
vox = [ 2 2 2 ];
bb = [ -78 -112 -50 ; 78 76 85 ];

%--------------- the following is the same as spm_write_defs in spm_sn2defs ----------

[bb0,vox0] = bbvox_from_V(sn.VG);
if any(~finite(vox)), vox = vox0; end;
if any(~finite(bb)),  bb  = bb0;  end;
bb  = sort(bb);
vox = abs(vox);

% Commented out by SJT 8/21/2008-------
% if nargin>=3,
% Commented out by SJT 8/21/2008-------

	if any(~finite(vox)), vox = vox0; end;
	if any(~finite(bb)),  bb  = bb0;  end;
	bb  = sort(bb);
	vox = abs(vox);

	% Adjust bounding box slightly - so it rounds to closest voxel.
	bb(:,1) = round(bb(:,1)/vox(1))*vox(1);
	bb(:,2) = round(bb(:,2)/vox(2))*vox(2);
	bb(:,3) = round(bb(:,3)/vox(3))*vox(3);
 
	M   = sn.VG(1).mat;
	vxg = sqrt(sum(M(1:3,1:3).^2));
	ogn = M\[0 0 0 1]';
	ogn = ogn(1:3)';
 
	% Convert range into range of voxels within template image
	x   = (bb(1,1):vox(1):bb(2,1))/vxg(1) + ogn(1);
	y   = (bb(1,2):vox(2):bb(2,2))/vxg(2) + ogn(2);
	z   = (bb(1,3):vox(3):bb(2,3))/vxg(3) + ogn(3);
 
	og  = -vxg.*ogn;
	of  = -vox.*(round(-bb(1,:)./vox)+1);
	M1  = [vxg(1) 0 0 og(1) ; 0 vxg(2) 0 og(2) ; 0 0 vxg(3) og(3) ; 0 0 0 1];
	M2  = [vox(1) 0 0 of(1) ; 0 vox(2) 0 of(2) ; 0 0 vox(3) of(3) ; 0 0 0 1];
	mat = sn.VG.mat*inv(M1)*M2; 
	dim = [length(x) length(y) length(z)];

% Commented out by SJT 8/21/2008-------
% else,
% 	dim    = sn.VG.dim(1:3);
% 	x      = 1:dim(1);
% 	y      = 1:dim(2);
% 	z      = 1:dim(3);
% 	mat    = sn.VG.mat;
% end;
% Commented out by SJT 8/21/2008-------


[pth,nm,xt,vr]  = fileparts(deblank(sn.VF.fname));
%VX = struct('fname',fullfile(pth,['y1_' nm '.img']),  'dim',[dim 16], ...
%	'mat',mat,  'pinfo',[1 0 0]',  'descrip','Deformation field - X');
%VY = struct('fname',fullfile(pth,['y2_' nm '.img']),  'dim',[dim 16], ...
%	'mat',mat,  'pinfo',[1 0 0]',  'descrip','Deformation field - Y');
%VZ = struct('fname',fullfile(pth,['y3_' nm '.img']),  'dim',[dim 16], ...
%	'mat',mat,  'pinfo',[1 0 0]',  'descrip','Deformation field - Z');

VX = struct('fname',fullfile(pth,['y_' nm '.img']),  'dim',[dim 16], ...
        'mat',mat,  'pinfo',[1 0 0]',  'descrip','Deformation field', 'n',1);
VY = VX; VY.n = 2;
VZ = VX; VZ.n = 3;

X = x'*ones(1,VX.dim(2));
Y = ones(VX.dim(1),1)*y;

st = size(sn.Tr);

if (prod(st) == 0),
	affine_only = 1;
	basX = 0; tx = 0;
	basY = 0; ty = 0;
	basZ = 0; tz = 0;
else,
	affine_only = 0;
	basX = spm_dctmtx(sn.VG(1).dim(1),st(1),x-1);
	basY = spm_dctmtx(sn.VG(1).dim(2),st(2),y-1);
	basZ = spm_dctmtx(sn.VG(1).dim(3),st(3),z-1); 
end,

VX = spm_create_vol(VX);
VY = spm_create_vol(VY);
VZ = spm_create_vol(VZ);

% Cycle over planes
%----------------------------------------------------------------------------
for j=1:length(z)

	% Nonlinear deformations
	%----------------------------------------------------------------------------
	if (~affine_only)
		% 2D transforms for each plane
		tx = reshape( reshape(sn.Tr(:,:,:,1),st(1)*st(2),st(3)) *basZ(j,:)', st(1), st(2) );
		ty = reshape( reshape(sn.Tr(:,:,:,2),st(1)*st(2),st(3)) *basZ(j,:)', st(1), st(2) );
		tz = reshape( reshape(sn.Tr(:,:,:,3),st(1)*st(2),st(3)) *basZ(j,:)', st(1), st(2) );

		X1 = X    + basX*tx*basY';
		Y1 = Y    + basX*ty*basY';
		Z1 = z(j) + basX*tz*basY';
	end

	% Sample each volume
	%----------------------------------------------------------------------------
	Mult = sn.VF.mat*sn.Affine;
	if (~affine_only)
		X2= Mult(1,1)*X1 + Mult(1,2)*Y1 + Mult(1,3)*Z1 + Mult(1,4);
		Y2= Mult(2,1)*X1 + Mult(2,2)*Y1 + Mult(2,3)*Z1 + Mult(2,4);
		Z2= Mult(3,1)*X1 + Mult(3,2)*Y1 + Mult(3,3)*Z1 + Mult(3,4);
	else
		X2= Mult(1,1)*X + Mult(1,2)*Y + (Mult(1,3)*z(j) + Mult(1,4));
		Y2= Mult(2,1)*X + Mult(2,2)*Y + (Mult(2,3)*z(j) + Mult(2,4));
		Z2= Mult(3,1)*X + Mult(3,2)*Y + (Mult(3,3)*z(j) + Mult(3,4));
	end

	VX = spm_write_plane(VX,X2,j);
	VY = spm_write_plane(VY,Y2,j);
	VZ = spm_write_plane(VZ,Z2,j);

end;
VX = spm_close_vol(VX);
VY = spm_close_vol(VY);
VZ = spm_close_vol(VZ);
return;
%_______________________________________________________________________






%_______________________________________________________________________
function [bb,vx] = bbvox_from_V(V)
vx = sqrt(sum(V.mat(1:3,1:3).^2));
o  = V.mat\[0 0 0 1]';
o  = o(1:3)';
bb = [-vx.*(o-1) ; vx.*(V.dim(1:3)-o)];
return;