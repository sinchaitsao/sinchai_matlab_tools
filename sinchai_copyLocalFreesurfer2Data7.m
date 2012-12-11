function sinchai_copyLocalFreesurfer2Data7(subject,type)
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

subjCPcommand = [ '/usr/local/freesurfer/subjects/' subject ];

destCPcommand = [ '/data7/freesurfer_subjects_USC_AD/' diagnosis '/'];

mkdir( destCPcommand, subject );

destCPcommand = [ destCPcommand subject ];
fprintf(['\n\nCopying from <' subjCPcommand '> to <' destCPcommand '>..........\n\n']);

copyfile( subjCPcommand , destCPcommand );
fprintf(['\n\nDONE!!\n\n']);
