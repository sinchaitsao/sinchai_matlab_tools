function sinchai_copyFreesurf2Post(subject,type,loc)
%
% ---------------------Help File------------------------------------------
% sinchai_copyFreesurf2Post.m
%
%
% copies files from data7 freesurfer subjects directory to
%           data7 post-freesurfer processing directory
%
% specify subject and diagnosis type by:
%       
%       sinchai_copyFreesurf2Post('<subject>','<type>');
%
% Oct 7, 2008
% ------------------------------------------------------------------------
%

% Set number of slices in volume
% IE 128 x 128 x NumberOfSlicesInZ
NumberOfSlicesInZ = 28;
currentDir = pwd;

if strcmpi(type,'normal')
    diagnosis = 'Normal';
elseif strcmpi(type,'MCI')
    diagnosis = 'MCI';
elseif strcmpi(type,'ProbAD') || strcmpi(type,'AD')
    diagnosis = 'ProbAD';
else
    fprintf('\n-------\nERROR:not known diagnosis type\nacceptable inputs:\nNormal\nMCI\nAD\n\n-------\n');
end

if strcmpi(loc,'img')
    location = '/home1/image/USC_AD/';
    subjCPcommand = [ '!cp /data7/freesurfer_subjects_USC_AD/' diagnosis '/' subject '/mri/' ];
else
    location = '/data7/'; 
    subjCPcommand = [ '!cp ' location 'freesurfer_subjects_USC_AD/' ...
    diagnosis '/' subject '/mri/' ];

end


destCPcommand = [ location 'post_freesurfer_USC_AD/' diagnosis ];

mkdir( destCPcommand , subject );
    
destCPcommand = [ destCPcommand '/' subject '/'];

files{1} = 'aseg.mgz';
files{2} = 'brainmask.mgz';
files{3} = 'T1.mgz';

for i=1:length(files)
    command = [ subjCPcommand files{i} ' ' destCPcommand '.']
    eval(command);
    fprintf(['\nExecuting Command: ' command '\n']);
end

if strcmpi(diagnosis,'ProbAD')
    darryl_diagnosis_notation = 'Prob';
else
    darryl_diagnosis_notation = diagnosis;
end

dcmdir = [ '/data7/USC_AD/' darryl_diagnosis_notation '/' subject '/DICOM/subject_01' ];

try
    cd(dcmdir);
catch
    try
        dcmdir = [ '/data7/USC_AD/' darryl_diagnosis_notation '/newscans/' subject '/DICOM/subject_01' ];
        cd(dcmdir);
    catch
        dcmdir = [ '/data7/USC_AD/' darryl_diagnosis_notation '/bad/' subject '/DICOM/subject_01' ];
        cd(dcmdir);
    end
end
results = sinchai_determine_series_type;

for j=1:length(results)+1
    if j>length(results)
        fprintf('\n\nERROR: DTI raw data not found!!! Help!\n\n');
        return;
    end
    if strcmpi(results(j).type,'DTI')
        fprintf('\n\nfound DTI Series Description\n\n');
        results(j).name
        cd(results(j).name);
        dirList = dir;
        if length(dirList)<728
            fprintf('\n\nNot DTI raw data (# of files less than 728) Lets keep looking...\n\n');   
        else
            fprintf('\n\nFOUND raw data DTI sequence\n\n');
            break;
        end
        cd('..');
    end
end


DCMimageDir = [ dcmdir '/' results(j).name '/' ];

cd( destCPcommand );
mkdir('Bzero_DICOM');
for j=3:NumberOfSlicesInZ+2
    filename = dirList(j).name;
    DCMCPY_command = [ '!cp ' DCMimageDir filename ' ' destCPcommand 'Bzero_DICOM/.']
    eval( DCMCPY_command );
end
cd('Bzero_DICOM');
sinchai_dcm2img;
cd('ANALYZE');
movefile('ANALYZE.img','../../Bzero256.img');
movefile('ANALYZE.hdr','../../Bzero256.hdr');
cd('../..');

% BzeroCPcommand = [ '!cp /data7/USC_AD/' diagnosis '/' subject '/EddyCorrect/AnalyzeVolumes/' ];
% 
% BzeroFiles{1} = 'SMALL_B0_fcorrected_01.hdr';
% BzeroFiles{2} = 'SMALL_B0_fcorrected_01.img';
% 
% for i=1:length(BzeroFiles)
%     command = [ BzeroCPcommand BzeroFiles{i} destCPcommand ]
%     eval(command);
%     fprintf(['\nExecuting Command: ' command '\n']);
% end
