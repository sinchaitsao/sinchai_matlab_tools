% TractFilterNeuro.m
% This program is designed to filter tractography files generated in 
% NeuroTract with ROI files in Analyze formate. The data structure for
% roi_loc and tract_loc contains two variables "pname" for the path of the
% file and "fname" for the filename. Two other variables are also available
% to be set, roi_th or threshold for filtering and isand which selects
% whether the filting is an and or a not filter.  If the ROI is binary, the
% proper setting for roi_th is 1.
% Standard input line is
% [temp,filterindex]=TractFilterNeuro(roi_loc,tract_loc,1,1)

% Author: Darryl H. Hwang
% Version 1.0
% Last Modified on 3/30/09

function [f_result,filterindex]=sinchai_TractFilterNeuroICA(roi_loc,tract_loc,varargin)

filterindex=0;
f_result=[];
if nargin==2
    roi_th=1;
    isand=1;
elseif nargin==3
    roi_th=varargin{1};
    isand=1;
elseif nargin==4
    roi_th=varargin{1};
    isand=varargin{2};
else
    warndlg('Incorrect number of arguments');
    return;
end

%load('tractp.mat');
tractp.sf = [2 2 4];
vol_dim = [ 128 128 28 ];


h=waitbar(0,'Tract filtering in progress. Please wait...');

%load(fullfile(tract_loc.pname,tract_loc.fname));
info=analyze75info(fullfile(roi_loc.pname,roi_loc.fname));
data=double(analyze75read(info));

sn=size(data,3); % NUMBER OF SLICES

roi_bounds=size(data);
g_bwroi=zeros(roi_bounds(1),roi_bounds(2),roi_bounds(3));
for k=1:roi_bounds(3)
    g_bwroi(:,:,k)=fliplr(flipud(data(:,:,k)));
end
g_bwroi(find(g_bwroi<roi_th))=0;
g_bwroi(find(g_bwroi>=roi_th))=1;

% imshow(g_bwroi(:,:,34),[]);
% jack=g_bwroi(:,:,34);
% [r,c]=find(jack==1);

cnt=1;
for k=1:size(g_bwroi,1)
    if find(g_bwroi(k,:,:)>0)~=0
        g_pos_cr(cnt)=k;
        cnt=cnt+1;
    end
end

temp=[];
load('numbers.mat');
for slice_no=1:sn
    sliceLoaded = load(['tv_ICA/ztv_ICA_' num2str(slice_no,'%0.2d') '.mat']);

    for parameter=1:numbers(slice_no)
        tract{parameter}{1}=single(sliceLoaded.tract0{parameter}{1});
        tract{parameter}{2}=single(sliceLoaded.tract0{parameter}{2});
    end;
    temp_tract=tract;
    tcnt=size(temp_tract,2);
    tcnt2=1;
    for i=1:tcnt
        try
            tr = temp_tract{i}{2};
        catch
            %disp(['Error at ' num2str(i)]);
        end
        tr(isnan(tr)) = 0;
        tr=double(tr);

        tr_l=size(tr,1);
        
        if size(tr,1)>1
            tr_val=zeros(tr_l,3);
            tr_val(:,1)=0.5+vol_dim(1)/2 -(tr(:,2)./tractp.sf(1));
            tr_val(:,2)=(tr(:,1)./tractp.sf(2)+vol_dim(2)/2+0.5);
            tr_val(:,3)=tr(:,3)./tractp.sf(3);
            roi_count=0;
            for roi_no=1:length(g_pos_cr)
                I3=find(round(tr_val(:,1))==g_pos_cr(roi_no));
                I1=round(tr_val(I3,3));
                I2=round(tr_val(I3,2));
                for k=1:length(I1)
                    if I1(k)>0 && I1(k)<=roi_bounds(3) && I2(k)>0 &&...
                            I2(k)<=roi_bounds(2)
                        roi_count=roi_count+g_bwroi(g_pos_cr(...
                            roi_no),I2(k),I1(k));
                    end
                end
                if (roi_count>0) && isand
                    temp{slice_no}{tcnt2}=temp_tract{i};
                    tcnt2=tcnt2+1;
                    break;
                end
            end
            if roi_count==0 && ~isand
                temp{slice_no}{tcnt2}=temp_tract{i};
                tcnt2=tcnt2+1;
            end
        end
    end
    waitbar(slice_no/sn);
end

if ~isempty(temp)
    filterindex=1;
    f_result.tract=temp;
    f_result.img_mode=4;
    f_result.tractp=tractp;
    f_result.vol_dim=vol_dim;
end
close(h);

end