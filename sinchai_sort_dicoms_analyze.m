function sinchai_sort_dicoms_analyze

mkdir('dicom');
movefile('*.dcm','dicom/');
movefile('ANALYZE/ANALYZE.hdr','spgr.hdr');
movefile('ANALYZE/ANALYZE.img','spgr.img');
rmdir('ANALYZE','s');
temp = pwd;
display([ 'Processing... ' temp ]);