
int8_2mat1(256,256,256,'aseg.img');
fs_vol_cor_ax2;     % correct orientation
info=analyze75info('aseg.hdr');
load spgrdata.mat;

new_spgrdata = spgrdata;

spgrdata = (new_spgrdata == 17);
save spgrdata.mat spgrdata
spgrdata2spm2;
movefile('spgr.img','leftHipp_T1space.img');

spgrdata = (new_spgrdata == 53);
save spgrdata.mat spgrdata
spgrdata2spm2;
movefile('spgr.img','rightHipp_T1space.img');

copyfile('aseg.hdr','leftHipp_T1space.hdr');
copyfile('aseg.hdr','rightHipp_T1space.hdr');