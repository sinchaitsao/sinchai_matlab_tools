function sinchai_run_command_in_every_subdirectory(command);
dirList = dir;

for i=3:length(dirList)
    if dirList(i).isdir
        cd(dirList(i).name);
        fprintf(['\n\nGoing into directory: ' dirList(i).name '\n\n']);
        fprintf(['\n\nAttempting to execute command: ' command '\n\n']);
        try
            eval(command);
        catch
            fprintf(['\n\nCommand Failed in directory: ' dirList(i).name '\n\n']);
        end
        cd('..');
    end
end
