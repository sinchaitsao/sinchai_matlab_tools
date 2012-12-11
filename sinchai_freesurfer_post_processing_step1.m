function sinchai_freesurfer_post_processing_step1( subject, type, loc)
%
%------------------HELP FILE----------------------------------------------
%
% sinchai_freesurfer_post_processing_step1.m
%
%
% freesurfer post processing workflow:
%
%   sinchai_freesurfer_post_processing_step1.m
%   mri_convert aseg.mgz aseg.img
%   mri_convert T1.mgz T1.img
%   sinchai_freesurfer_post_processing_step2.m
%   find origin using SPM
%   sinchai_freesurfer_post_processing_step3(<T1Origin>,<BzeroOrigin>)
%   coregister T1 with Bzero and apply it to aseg using SPM
%   REMEMBER TO SET DEFAULT METHOD TO NEAREST NEIGHBOUR!!!
%   sinchai_freesrufer_post_processing_step4
%
try
    % see if data is on local system
%     if ~sinchai_check_stats_processing(subject)
%         fprintf('\n\nFreesurfer Processing Unsuccessful post processing cancelled...\n\n');
%         return;
%     end
    sinchai_copyLocalFreesurfer2Data7(subject,type)
    sinchai_copyFreesurf2Post(subject,type,loc)
catch
    sinchai_copyFreesurf2Post(subject,type,'data7') %If not assume data is already on Data7
end



fprintf('\n\nCOMPLETE... Now do MRI_convert...\n\n');