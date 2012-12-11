function [final_soln x y final_rot] = sinchai_single_slice_coregistration(slice1,slice2)
% Written by Sinchai Tsao PhD Candidate University of Southern Cal.
% on Feb 11, 2010
%
% Performs single slice coregistration using (1) translation (2) rotation
% Only performs a single repetition with imabsdiff to measure improvement
%
% slice1 - reference image
% slice2 - image to be coregistered
% x - translation in x direction
% y - translation in y direction
% final_rot - rotation about center of image

% Size of Image
image_size = size(slice1,2);

% Perform translational coregistration
disp('Translating Image...');
i=1;
for b=-2:0.2:2
    for a=-2:0.2:2
        A = [ 1 0 ; 0 1 ; a b ];
        t = maketform('affine',A);
        B = imtransform(slice2,t,'bicubic','xdata',[1 image_size],'ydata',[1 image_size]);
        diff(i) = sum(sum(imabsdiff(slice1,B)));
        location(:,i) = [ a b ];
        i=i+1;
    end
end
[ val indice ] = min(diff);

%
% Perform rotational coregistration
%
disp('Rotating Image...');
location(:,indice);
trans_soln       = [ 1 0 0 ; 0 1 0 ; location(:,indice)' 1];
go2center        = [ 1 0 0 ; 0 1 0 ; -64 -64 1];
inv_go2center    = [ 1 0 0 ; 0 1 0 ; 64 64 1];
k=1;
for rot = -4/180*pi:0.001:4/180*pi
    matrix1 = trans_soln*go2center*[ cos(rot) sin(rot) 0 ; -sin(rot) cos(rot) 0 ; 0 0 1]*inv_go2center;
    t = maketform('affine',matrix1);
    B = imtransform(slice2,t,'bicubic','xdata',[1 image_size],'ydata',[1 image_size]);
    diff1(k) = sum(sum(imabsdiff(slice1,B)));
    k=k+1;
end
rot_index = -4/180*pi:0.001:4/180*pi;
[ val1 indice1 ] = min(diff1);
final_rot = rot_index(indice1);

% create final image;

final_matrix = trans_soln*go2center*[ cos(final_rot) sin(final_rot) 0 ; -sin(final_rot) cos(final_rot) 0 ; 0 0 1]*inv_go2center;
t = maketform('affine',final_matrix);
final_soln = imtransform(slice2,t,'bicubic','xdata',[1 image_size],'ydata',[1 image_size]);

x = location(1,indice);
y = location(2,indice);
