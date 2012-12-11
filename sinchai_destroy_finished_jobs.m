function sinchai_destroy_finished_jobs

r = findResource();
[p q r f] = findJob(r);
destroy(f);