function sinchai_rename_dicom_files

% Script to sort dicom files
dirList = dir;
for i=1:length(dirList)

    try
        info = dicominfo(dirList(i).name);
        
        series_des = strrep(info.SeriesDescription,' ','_');
        series_des = strrep(series_des,'/','_');
        series_des = strrep(series_des,'+','_');
        series_des = strrep(series_des,'-','_');
        im_num = info.InstanceNumber;

        movefile(dirList(i).name , num2str(im_num,'%.4d'));
        display([num2str(i) '/' num2str(length(dirList))]);

    catch
        display([ dirList(i).name ' is not a valid dicom file.' ]);
    end

end