function sinchai_read_apply_SPM_transform(file1, file2)
%
% requires SPM 8
%
%

delete('test*');
delete('rtest*');
copyfile('FA_060.img','test.img');

P = 'bzero_060.hdr,1';

V = spm_vol(P);

P1 = 'FA_060.hdr,1';

V1 = spm_vol(P1);

V_new = V;
V_new.fname = 'test.img';
V_new.dt = V1.dt;

spm_create_vol(V_new);

copyfile('bzero_001.hdr','test1.hdr');
copyfile('bzero_001.img','test1.img');
