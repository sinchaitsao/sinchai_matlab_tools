function filterindex=sinchai_TractStraySeedFilterNeuro(varargin)
filterindex=0;
if nargin==0
    [tract_loc.fname,tract_loc.pname,filterindex] = uigetfile('*.mat',...
        'Enter tract file to be edited');
    if filterindex==0
        return;
    end
    isvisible=1;
elseif nargin==1        
    tract_loc=varargin{1};
    isvisible=1;
elseif nargin==5
    tract_loc=varargin{1};
    out_loc=varargin{2};
    sel_slice=varargin{3};
    isand=varargin{4};
    isvisible=varargin{5};
else
    warndlg('Incorrect number of arguments.');
    return;
end
if exist(fullfile(tract_loc.pname,tract_loc.fname),'file')~=2
    return;
end
    
az=0;
el=90;

load(fullfile(tract_loc.pname,tract_loc.fname));
if isvisible==1
    h=figure;
    s_no=length(tract);
    for slice_no=1:s_no
        gtract=tract{slice_no};
        tcnt=size(gtract,2);
        for i=1:tcnt
            tr=double(gtract{i}{2});
            trl=size(tr,1);
            line(tr(:,1),tr(:,2), tr(:,3), 'Color',[1 0 0]); hold on;
        end
    end
    axis vis3d;
    view(az,el);
    dims=tractp.sf;
    daspect([dims(1)/dims(1),dims(2)/dims(1),dims(3)/dims(1)]);
    clear gtract tcnt tr tr1;
    pause;
end

if ~exist('sel_slice','var')
    Idlgv_prompt = {'x1, x2, y1, y2, z1, z2','1=and 0=not'};
    Idlgv_lines = 1;
    Idlgv_def ={'-10, 10, 20, 100, 0, 100','0'};
    Idlgv_title = 'Exclusion Plane';
    Idlgv_ans = inputdlg(Idlgv_prompt,Idlgv_title,Idlgv_lines,Idlgv_def);

    if isempty(Idlgv_ans)
        filterindex=0;
        if isvisible==1
            delete(h);
        end
        return;
    end
    sel_slice=str2num(Idlgv_ans{1,1});
    isand=str2num(Idlgv_ans{2,1});
end

sn=size(tract,2);
temp=[];
for i=1:sn
    fprintf('.');
    tcnt=size(tract{i},2);
    tcnt2=1;
    for j=1:tcnt
        gseed=tract{i}{j}{1};
        tr(2)=tractp.sf(1)*((0.5+vol_dim(1)/2 )-gseed(1));
        tr(1)=tractp.sf(2)*(gseed(2)-(vol_dim(2)/2+0.5));
        tr(3)=gseed(3)*tractp.sf(3);
        
        isfound=0;
        if tr(1)>=sel_slice(1) &&...
                tr(1)<=sel_slice(2) &&...
                tr(2)>=sel_slice(3) &&...
                tr(2)<=sel_slice(4) &&...
                tr(3)>=sel_slice(5) &&...
                tr(3)<=sel_slice(6)

            isfound=1;
        end
        if isfound && isand
            temp{i}{tcnt2}=tract{i}{j};
            tcnt2=tcnt2+1;
        elseif ~isfound && ~isand
            temp{i}{tcnt2}=tract{i}{j};
            tcnt2=tcnt2+1;
        end
    end
end
fprintf('\n');
f_result.tract=temp; 
clear gtract tcnt tcnt2 temp;

if isvisible==1
    s_no=size(f_result.tract,2);
    h1=figure;
    for slice_no=1:s_no
        gtract=f_result.tract{slice_no};
        tcnt=size(gtract,2);
        for i=1:tcnt
            tr=double(gtract{i}{2});
            trl=size(tr,1);
            line(tr(:,1),tr(:,2), tr(:,3), 'Color',[1 0 0]);
            hold on;
        end
    end
    axis vis3d;
    view(az,el);
    daspect([dims(1)/dims(1),dims(2)/dims(1),dims(3)/dims(1)]);
    pause;
end

f_result.tractp=tractp;
f_result.img_mode=img_mode;
f_result.vol_dim=vol_dim;

if ~exist('out_loc','var')
    [out_loc.fname,out_loc.pname,filterindex] =...
        uiputfile(fullfile(tract_loc.pname,tract_loc.fname),...
    'Enter filename(with .mat) to save');
    if filterindex==0;
        if isvisible==1
            delete(h);
            delete(h1);
        end
        return;
    end
end
if isvisible==1
    delete(h);
    delete(h1);
end

save(fullfile(out_loc.pname,out_loc.fname),'-struct','f_result');
   

filterindex=1;

end