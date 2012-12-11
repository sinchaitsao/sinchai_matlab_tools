
path2dest = '/home1/image/Sinchai/LALES_Hipp/';
d = dir;
d = d([d.isdir]);
for i=3:length(d)
    cd(d(i).name);
    display(d(i).name);
    cd('mri');
    mkdir([path2dest d(i).name]);
    copyfile('aseg.mgz', [path2dest d(i).name '/aseg.mgz']);
    copyfile('T1.mgz', [path2dest d(i).name '/T1.mgz']); 
    cd('..');
    cd('..');
end
