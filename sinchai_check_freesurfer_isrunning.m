function sinchai_check_freesurfer_isrunning

currentDir = pwd;
subsDir = '/usr/local/freesurfer/subjects';
cd( subsDir );

directoryList = dir;
counter = 1;

for i=3:length(directoryList)
    if directoryList(i).isdir
       cd([ directoryList(i).name '/scripts']);
       subDirList = dir;
       for j=3:length(subDirList)
          if strcmpi(subDirList(j).name,'IsRunning.lh+rh')
              List{counter} = directoryList(i).name;
              counter = counter + 1;
          end
       end
       cd( subsDir );
    end
end

try
	List
catch
	fprintf('\n\nNo freesurfer subject is running\n\n');
end