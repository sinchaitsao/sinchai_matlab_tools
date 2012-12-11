function sinchai_rename_dir_Series_Description(name_using_series_num)
%
% rename directories using Series Description
%
% written by Sinchai Tsao
%
% Usage:
%
%           (*)To use without Series Number:
%
%                   sinchai_rename_dir_Series_Description
%
%                   output: [ AX_3D_FSPGR ]
%
%           (*)To use with Series Number:
%
%                   sinchai_rename_dir_Series_Description(1)
%
%                   output: [ 12_AX_3D_FSPGR ]
%

dirList = dir;

for i=3:length(dirList)
    if dirList(i).isdir
        cd(dirList(i).name);
        innerDirList = dir;
        dcminfo = dicominfo(innerDirList(5).name);
        folderName = strrep(dcminfo.SeriesDescription,' ','_');
        if nargin==1 && name_using_series_num == 1
            folderName = [ num2str(dcminfo.SeriesNumber,'%2.2d') '_' folderName ];
        end
        cd('..');
        if ~strcmp(dirList(i).name,folderName)
            movefile(dirList(i).name,folderName,'f');
        end
    end
end