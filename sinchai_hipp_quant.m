function sinchai_hipp_quant(varargin)

%-------------------------------------------------------------------------
% sinchai_hipp_quant.m
%-------------------------------------------------------------------------
%
% Quantifies Hippocampus Volumes from FSL output
%
% July 31, 2008
%-------------------------------------------------------------------------

rt = analyze75read('Rt_Hipp2');
lt = analyze75read('Lt_Hipp2');

rt = (rt>0);
lt = (lt>0);

% volume = number of voxels * voxel volume

rtVol = sum(sum(sum(rt))) * 0.5 * 0.5 * 0.5;
ltVol = sum(sum(sum(lt))) * 0.5 * 0.5 * 0.5;
totalVol = rtVol + ltVol;

% print to text file
fid = fopen('hipp_volume_results.txt', 'wt');
fprintf(fid, 'Left Hipp Vol (mm^3):\n%d\n',ltVol);
fprintf(fid, 'Right Hipp Vol (mm^3):\n%d\n',rtVol);
fprintf(fid, 'Total Hipp Vol (mm^3):\n%d\n',totalVol);
fclose(fid);

save hippVol.mat rtVol ltVol totalVol;