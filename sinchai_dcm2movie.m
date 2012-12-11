function sinchai_dcm2movie
%-------------------------------------------------------------------------
% sinchai_dcm2movie.m
%-------------------------------------------------------------------------
% converts a directory of dicom images into a movie
%
% the output movie is name movie.avi
%
%
% Written by Sinchai Tsao
% PhD Candidate, University of Southern California
% ON
% Aug 19, 2008
%-------------------------------------------------------------------------
current_directory = pwd;

dirList = dir();
dirListIsDir = [dirList.isdir]';

% remove all directories from the list (removes . and .. )
dirList = dirList(~dirListIsDir);

% Initialize variables
im = dicomread(dicominfo(dirList(1).name));

for i=1:length(dirList)-10
    info = dicominfo(dirList(i).name);
    imshow(dicomread(info),[]);
    dicom_movie(info.InstanceNumber) = getframe;
end

mkdir avi_movie;
cd('avi_movie');

movie2avi(dicom_movie,'dicom_movie.avi','fps',5,'quality',100);

cd(current_directory);