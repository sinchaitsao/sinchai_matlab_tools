% sinchai_rename_dir_patientID_series_dir
%
% written by Sinchai Tsao 
%
% 3/12/2011
%

function sinchai_rename_dir_patientID_series_dir

dirList = dir;

for i=1:length(dirList)
    if dirList(i).isdir && ~strcmp(dirList(i).name,'.') && ~strcmp(dirList(i).name,'..')
        cd(dirList(i).name);
        innerDirList = dir;
        for j=1:length(innerDirList)
           if innerDirList(j).isdir && ~strcmp(innerDirList(j).name,'.') && ~strcmp(innerDirList(j).name,'..')
               cd(innerDirList(j).name);
               dicomDirList = dir;
               for k=1:length(dicomDirList)
                    if ~dicomDirList(k).isdir
                        try
                            dicomInfo = dicominfo(dicomDirList(k).name);
                            break;
                        catch
                            display([ dicomDirList(k).name ' is not a dicomfile.']);
                        end
                    end 
               end
               sinchai_rename_dir_Series_Description(1);
               cd('..');
               break;
           end 
        end
        cd('..');
        
        try
            if ~strcmp(dirList(i).name,dicomInfo.PatientID)
                movefile(dirList(i).name,dicomInfo.PatientID);
            end
            clear dicomInfo;
        catch
            display(['Error in ' dirList(i).name]);
        end
    end
end