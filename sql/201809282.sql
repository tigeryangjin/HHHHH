ALTER INDEX &I REBUILD PARALLEL(DEGREE 8) NOLOGGING;
ALTER INDEX &I NOPARALLEL;
