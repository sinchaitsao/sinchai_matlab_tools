function sinchai_renameSPMsegments

reply = input('Enter file prefix (eg. 070208D1_noASSET):\n','s');

eval(['!mv anat.hdr ' reply '.hdr;']);
eval(['!mv anat.img ' reply '.img;']);

eval(['!mv c1anat.hdr ' reply '_seg1.hdr;']);
eval(['!mv c1anat.img ' reply '_seg1.img;']);

eval(['!mv c2anat.hdr ' reply '_seg2.hdr;']);
eval(['!mv c2anat.img ' reply '_seg2.img;']);

eval(['!mv c3anat.hdr ' reply '_seg3.hdr;']);
eval(['!mv c3anat.img ' reply '_seg3.img;']);