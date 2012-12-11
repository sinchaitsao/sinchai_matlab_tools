function sinchai_extract_rois(filename,output_filename,roi)
%-------------------------------------------------------------------------
% sinchai_extract_rois.m
%-------------------------------------------------------------------------
% Extracts analyze files with multiple ROIs eg. intensity = 1,2,3 etc...
%
%
% eg. sinchai_extract_rois('frniftiFormat.hdr','left_HypoT',1);
%       for an roi with intensity value = 1
%
% Oct 16, 2009
%-------------------------------------------------------------------------

a = analyze75read(filename);
info = analyze75info(filename);
b = (a==roi);
b = uint8(b);

sinchai_matrix2img(b,output_filename,info.PixelDimensions,'uint8',1);