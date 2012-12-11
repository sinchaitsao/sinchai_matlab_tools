flag = 1;

Idlgv_prompt=[];
Idlgv_def=[];
var_names=[];

Idlgv_prompt{1,length(Idlgv_prompt)+1} =...
    'Subject ID';
Idlgv_def{1,length(Idlgv_def)+1}='013006D1';
var_names{1,length(var_names)+1}='subjectID';


Idlgv_prompt{1,length(Idlgv_prompt)+1} =...
    'Pathology Group';
Idlgv_def{1,length(Idlgv_def)+1}='MCI';
var_names{1,length(var_names)+1}='group';


Idlgv_prompt{1,length(Idlgv_prompt)+1} =...
    'specify current system';
Idlgv_def{1,length(Idlgv_def)+1}='img';
var_names{1,length(var_names)+1}='sys';


Idlgv_lines = 1;

Idlgv_title = 'Hipp Freesurfer Post-processing pipeline';
Idlgv_ans = inputdlg(Idlgv_prompt,Idlgv_title,Idlgv_lines,Idlgv_def);
    
subjectID = Idlgv_ans{1}
group = Idlgv_ans{2}
sys = Idlgv_ans{3}


sinchai_freesurfer_post_processing_step1(subjectID,group,sys);

f = figure;
h = uicontrol('Position',[20 20 200 40],'String','Continue',...
              'Callback','uiresume(gcbf)');
g = uicontrol('Style','text','Position',[0 200 500 100],'String',...
    {'mri_convert aseg.mgz aseg.img','mri_convert T1.mgz T1.img',['Current Dir: ' pwd ]});
disp('Paused');    
uiwait(gcf); 
disp('Continuing');
try
close(f);
end
%   mri_convert aseg.mgz aseg.img
%   mri_convert T1.mgz T1.img

sinchai_freesurfer_post_processing_step2;
%   find origin using SPM
clear flag Idlgv_ans Idlgv_def Idlgv_lines Idlgv_prompt Idlgv_title;

flag = 1;

Idlgv_prompt=[];
Idlgv_def=[];
var_names=[];

Idlgv_prompt{1,length(Idlgv_prompt)+1} =...
    'T1 Origin';
Idlgv_def{1,length(Idlgv_def)+1}='x,y,z';
var_names{1,length(var_names)+1}='T1_origin';


Idlgv_prompt{1,length(Idlgv_prompt)+1} =...
    'B0 Origin';
Idlgv_def{1,length(Idlgv_def)+1}='x,y,z';
var_names{1,length(var_names)+1}='B0_origin';



Idlgv_lines = 1;

Idlgv_title = 'Set Origins';
Idlgv_ans = inputdlg(Idlgv_prompt,Idlgv_title,Idlgv_lines,Idlgv_def);
    
eval(['T1Origin = [' Idlgv_ans{1} ']']);
eval(['BzeroOrigin = [' Idlgv_ans{2} ']']);



sinchai_freesurfer_post_processing_step3(T1Origin,BzeroOrigin);


f = figure;
h = uicontrol('Position',[20 20 200 40],'String','Continue',...
              'Callback','uiresume(gcbf)');
g = uicontrol('Style','text','Position',[0 200 500 100],'String',...
    {[subjectID ' ' group ' ' sys],'coregister T1 to Bzero and apply to aseg',...
    'Set Default Coregistration mode to Nearest Neighbour'});
disp('Paused');    
uiwait(gcf); 
disp('Continuing');
try
close(f);
end 
%   coregister T1 with Bzero and apply it to aseg using SPM
sinchai_freesurfer_post_processing_step4(sys);
display([subjectID 'is DONE.....!!']);
