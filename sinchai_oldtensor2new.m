function new = sinchai_oldtensor2new(old)
%
% Sinchai Tsao
% 3/9/2009
% 
% Example:
%   old = load(XXX_old_tensor);
%   new = sinchai_oldtensor2new(old);
%   save newTensor.mat -struct new;
%
% Changes old nTrack tensor file variables to new NeuroTract tensor files
% remember that the orientation remains in radiological so you have to flip
% the tracts L to R when displaying in the new TractRender

new.D1 = old.g_D1;
new.b_val = [0 1000];
new.dg = old.g_dg;
new.img_dim = size(old.g_dti);
new.img_mode = old.g_img_mode;
new.mask = old.g_mask;
new.th = 1700;
new.tix = [ 1 4 5 ; 4 2 6 ; 5 6 3 ];
new.vox_size = old.g_img_dim;
new.zoom_win = old.g_win;

