function sinchai_icv_run_script(varargin)
%
% ---------------------Help File------------------------------------------
% sinchai_icv_run_script.m
%
% run's Wit's compute_icv script to every sub-directory so cd into
% /SPGR/Normal/ and run this script
%
% To set threshold manually IE not the default 0.8
% use
%           sinchai_icv_run_script(<threshold>)
%
% Written by Sinchai Tsao
% PhD Candidate Dept BME, USC
% Research Asst, Biomedical Imaging Laboratory,Dept of Radiology and BME,USC
% on Oct 9, 2008
% ------------------------------------------------------------------------
%

% Set compute_icv() threshold
if nargin > 0
    threshold = str2double(varargin{1});
else
    threshold = 0.8;
end

dirList = dir;
subjectDir = pwd;
for i=3:length(dir)
    if dirList(i).isdir
        cd(dirList(i).name);
        fprintf(['Processing... ' dirList(i).name]);
        if exist('ICV.txt','file')~=2 && exist('rspgr_seg1.img','file')==2


            % clean up stuff from before if its there
            delete('mat3d.mat');
            delete('orig_spgrdata.mat');
            delete('spgrdata.mat');

            % move dcms to another folder if its there
            error = 0;
            try
                a = ls('*.dcm');
            catch
                error = 1;
            end

            if ~error
                mkdir('dcm');
                movefile('*.dcm','dcm/.');
            end


            sinchai_icv_compute(threshold)
        elseif exist('rspgr_seg1.img','file')~=2
            fprintf(['\n\nRun Segmentation on: <' dirList(i).name '> before computing ICV\n\n']);
        elseif exist('ICV.txt','file')==2
            fprintf(['\n\nICV already computed on: <' dirList(i).name '> ignoring...\n\n']);
        end
        cd(subjectDir);
    else
        fprintf(['\n\nOmitting ' dirList(i).name '\n\n']);
    end
    
end


