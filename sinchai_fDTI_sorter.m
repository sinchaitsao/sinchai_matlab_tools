function sinchai_fDTI_sorter(no_of_grad,no_of_bzeros,no_of_slices)

%no_of_grad                  = 140;
%no_of_bzeros                = 10;
%no_of_slices                = 2;

counter = 0;
dirList = dir;
disp('Renaming files by instance number...');
for i=1:length(dirList)
    if ~dirList(i).isdir
        filename = dirList(i).name;
        temp = regexpi(filename,'\d*','match');
        filenumber = str2num(temp{2});
        new_filename = num2str(filenumber,'%06.f');
        movefile(filename,[ new_filename '.dcm' ]);
    end
end

disp('Grouping files...');
max_filenumber = max(filenumber);

no_of_DTI_acquisitions = max_filenumber/((no_of_grad+no_of_bzeros)*no_of_slices);

for k=0:no_of_DTI_acquisitions-1
    mkdir(num2str((k+1),'%03.f'));
    for l=0:(no_of_grad+no_of_bzeros-1)
        for m=1:no_of_slices
            file_num = (k*(no_of_grad+no_of_bzeros)*no_of_slices)+(l*no_of_slices)+m;
            try
                movefile([ num2str(file_num,'%06.f') '.dcm' ],[ num2str(k+1,'%03.f') '/.' ]);
            catch
                [ num2str(file_num,'%06.f') '.dcm' ]
            end
        end
    end
    disp(k/no_of_DTI_acquisitions);
end