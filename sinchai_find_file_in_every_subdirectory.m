function sinchai_find_file_in_every_subdirectory(filename);
dirList = dir;

for i=3:length(dirList)
    if dirList(i).isdir
        cd(dirList(i).name);
        if exist(filename,'file')>0
           display(['found:' dirList(i).name]);
        else
           display(['not found:' dirList(i).name]);
        end
        cd('..');
    end
end
