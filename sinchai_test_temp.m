
%=======================================================================
% - FORMAT specifications for programers
%=======================================================================
%( This is a multi function function, the first argument is an action  )
%( string, specifying the particular action function to take.          )
%
% FORMAT spm_spm_ui('CFG',D)
% Configure design
% D       - design definition structure - see format definition below
% (If D is a struct array, then the user is asked to choose from the
% design definitions in the array. If D is not specified as an
% argument, then user is asked to choose from the standard internal
% definitions)
%
% FORMAT [P,I] = spm_spm_ui('Files&Indices',DsF,Dn,DbaTime)
% PET/SPECT file & factor level input
% DsF     - 1x4 cellstr of factor names (ie D.sF)
% Dn      - 1x4 vector indicating the number of levels (ie D.n)
% DbaTime - ask for F3 images in time order, with F2 levels input by user?
% P       - nScan x 1 cellsrt of image filenames
% I       - nScan x 4 matrix of factor level indices
%
% FORMAT D = spm_spm_ui('DesDefs_Stats')
% Design definitions for simple statistics
% D      - struct array of design definitions (see definition below)
%
% FORMAT D = spm_spm_ui('DesDefs_PET')
% Design definitions for PET/SPECT models
% D      - struct array of design definitions (see definition below)
%
% FORMAT D = spm_spm_ui('DesDefs_PET96')
% Design definitions for SPM96 PET/SPECT models
% D      - struct array of design definitions (see definition below)

%=======================================================================
% Design definitions specification for programers & power users
%=======================================================================
% Within spm_spm_ui.m, a definition structure, D, determines the
% various options, defaults and specifications appropriate for a
% particular design. Usually one uses one of the pre-specified
% definitions chosen from the menu, which are specified in the function
% actions at the end of the program (spm_spm_ui('DesDefs_Stats'),
% spm_spm_ui('DesDefs_PET'), spm_spm_ui('DesDefs_PET96')). For
% customised use of spm_spm_ui.m, the design definition structure is
% shown by the following example:
%
% D = struct(...
%       'DesName','The Full Monty...',...
%       'n',[Inf Inf Inf Inf],  'sF',{{'repl','cond','subj','group'}},...
%       'Hform',                'I(:,[4,2]),''-'',{''stud'',''cond''}',...
%       'Bform',                'I(:,[4,3]),''-'',{''stud'',''subj''}',...
%       'nC',[Inf,Inf],'iCC',{{[1:8],[1:8]}},'iCFI',{{[1:7],[1:7]}},...
%       'iGXcalc',[1,2,3],'iGMsca',[1:7],'GM',50,...
%       'iGloNorm',[1:9],'iGC',[1:11],...
%       'M_',struct('T',[-Inf,0,0.8*sqrt(-1)],'I',Inf,'X',Inf),...
%       'b',struct('aTime',1));
%
% ( Note that the struct command expands cell arrays to give multiple    )
% ( records, so if you want a cell array as a field value, you have to   )
% ( embed it within another cell, hence the double "{{"'s.               )
%

% D = spm_spm_ui(char(spm_input('Select design class...','+1','m',...
% 		{'Basic stats','Standard PET designs','SPM96 PET designs'},...
% 		{'DesDefs_Stats','DesDefs_PET','DesDefs_PET96'},2)));
% D = D(spm_input('Select design type...','+1','m',{D.DesName}'))
% 
% [P,I] = spm_spm_ui('Files&Indices',D.sF,D.n,DbaTime)
% PET/SPECT file & factor level input
% DsF     - 1x4 cellstr of factor names (ie D.sF)
% Dn      - 1x4 vector indicating the number of levels (ie D.n)
% DbaTime - ask for F3 images in time order, with F2 levels input by user?
% P       - nScan x 1 cellsrt of image filenames
% I       - nScan x 4 matrix of factor level indices

%-----------------------------------------------------

% Run this the first time to generate D.mat and filenames.mat
% modify filenames.mat then run below
D = spm_spm_ui(char(spm_input('Select design class...','+1','m',...
		{'Basic stats','Standard PET designs','SPM96 PET designs'},...
		{'DesDefs_Stats','DesDefs_PET','DesDefs_PET96'},2)));
D = D(spm_input('Select design type...','+1','m',{D.DesName}'))

save D.mat D;

[P,I] = spm_spm_ui('Files&Indices',D.sF,D.n)
save filenames.mat P I;



%-----------------------------------------------------

% Run this to process
load SPM.mat
sinchai_spm2_spm_spm_ui('CFG',SPM);



