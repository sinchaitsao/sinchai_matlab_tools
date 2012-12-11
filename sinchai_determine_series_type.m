function simpleResults = sinchai_determine_series_type(rename)
% sinchai_determine_series_type.m
%
% Determines Series type from a folder containing dicom images from the
% scanner eg. /subject_01/series_01 /subject_01/series_02 ... etc
% This routine will determine what each of the series is.
%
% Instructions: CD into the subject_01 and run script
%
%
% July 29, 2008
%

% Set whether to change folder / directory names
if nargin>0
    if rename == 1
        changeDirectoryNames2SeriesDescription = 1;
    end
else
    changeDirectoryNames2SeriesDescription = 0;
end
%-------------------------------------------

dirList = dir;
currentDir = pwd;

% Counter for Results
counter = 1;

% get a list of which entries are directories
dirsOnly = [dirList.isdir];
success = 1;

for i=3:length(dirList)
    % take only the directories
    if dirsOnly(i)==1
        cd(dirList(i).name);
        dicomIMlist = dir;
        notDirList = [dicomIMlist.isdir];
        notDirList = ~notDirList;
        dicomIMlist = dicomIMlist(notDirList);
        try
            result= dicominfo(dicomIMlist(3).name);
            success = 1;
        catch
            success = 0;
        end
        if success == 1;
            simpleResults(counter).name = dirList(i).name;
            simpleResults(counter).type = result.SeriesDescription;
            cd(currentDir);

            if changeDirectoryNames2SeriesDescription
                newfilename = strrep(simpleResults(counter).type,' ','_');
                movefile(simpleResults(counter).name,newfilename);
            end

            counter = counter + 1;
        else
            cd(currentDir);
        end
    end
end

for j=1:counter-1
    [ simpleResults(j).name '     ' simpleResults(j).type ]
end

%fid = fopen('README.txt', 'r+');
%fprintf(fid, '%s \n',currentDir);
%for k = 1:length(simpleResults)
    %fprintf(fid, '%s \t %s \n',simpleResults(k).name,simpleResults(k).type);
%end
%fclose(fid);