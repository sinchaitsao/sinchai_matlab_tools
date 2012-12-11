function sinchai_TractFilterNeuroGUI

% ROI THRESHOLD
roi_thres = 0.00001;
filterIndex1 = 1;
count = 0;

while filterIndex1
    count = count+1;
    % Get ROI File Name
    [roiname(count).fname,roiname(count).pname,filterIndex1] = uigetfile('*.img','Select the ROI file');
end

count = count-1;

% Check for Errors
if ~filterIndex1 && count == 0
    disp('User Selection not accepted... Exiting...');
    return;
end

% Get Tract File Name
[tract.fname,tract.pname,filterIndex2] = uigetfile({'*.mat *.trt'},'Select the Tract file');


% Check for Errors
if ~filterIndex2
    disp('User Selection not accepted... Exiting...');
    return;
end

% Get Filter Type
button = questdlg('Select Filter Type','Filter Operation Selection','IsAnd','Not','Cancel','IsAnd');


% Check for Errors
if strcmpi(button,'Cancel')
    disp('User Selection not accepted... Exiting...');
    return;
end

% Save tract file name
tract_file_name = tract.fname;

if count == 1
    % Get Output File Name
    prompt = {'Enter Output Filename:'};
    dlg_title = 'Output Filename';
    num_lines = 1;
    tempROI = roiname(1).fname;
    def = {[ tract_file_name(1:length(tract_file_name)-4) '_' ...
        tempROI(1:length(tempROI)-4) ]};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
end

% Assign Filter Type
if strcmpi(button,'IsAnd')
    filterType = 1;
elseif strcmpi(button,'Not')
    filterType = 0;
end


% Filter AWAY!


if count == 1
    disp(['filtering using roi: [' roiname.fname '] using tracts from [' ...
        tract.fname '] filter type: [' button ']']);
    f_result=TractFilterNeuro(roiname(1),tract,filterType,roi_thres);
    save(answer{1},'-struct','f_result');
else
    for i=1:count
        disp(['filtering using roi: [' roiname(i).fname '] using tracts from [' ...
            tract.fname '] filter type: [' button ']']);
        f_result=TractFilterNeuro(roiname(i),tract,filterType,roi_thres);
        temp = roiname(i).fname;
        save([ tract_file_name(1:length(tract_file_name)-4) '_' temp(1:length(temp)-4) '.mat'],'-struct','f_result');
    end
end
