--1.
/*CREATE TABLE YANGJIN.DIM_GOOD_CLASS_TMP AS
SELECT * FROM DIM_GOOD_CLASS A
WHERE 1=2;*/

SELECT * FROM YANGJIN.DIM_GOOD_CLASS_TMP FOR UPDATE;

--2.MERGE
MERGE /*+APPEND*/
INTO DIM_GOOD_CLASS T
USING (SELECT A.MATDL,
              A.MATDLT,
              A.MATZL,
              A.MATZLT,
              A.MATXL,
              A.MATXLT,
              A.MATKL,
              A.MATKLT,
              A.GC_ID,
              A.GC_NAME,
              A.MD,
              A.EXC,
              A.DES
         FROM YANGJIN.DIM_GOOD_CLASS_TMP A) S
ON (T.MATKL = S.MATKL)
WHEN MATCHED THEN
  UPDATE
     SET T.MATDL   = S.MATDL,
         T.MATDLT  = S.MATDLT,
         T.MATZL   = S.MATZL,
         T.MATZLT  = S.MATZLT,
         T.MATXL   = S.MATXL,
         T.MATXLT  = S.MATXLT,
         T.MATKLT  = S.MATKLT,
         T.GC_ID   = S.GC_ID,
         T.GC_NAME = S.GC_NAME,
         T.MD      = S.MD,
         T.EXC     = S.EXC,
         T.DES     = S.DES
WHEN NOT MATCHED THEN
  INSERT
    (T.MATDL,
     T.MATDLT,
     T.MATZL,
     T.MATZLT,
     T.MATXL,
     T.MATXLT,
     T.MATKL,
     T.MATKLT,
     T.GC_ID,
     T.GC_NAME,
     T.MD,
     T.EXC,
     T.DES)
  VALUES
    (S.MATDL,
     S.MATDLT,
     S.MATZL,
     S.MATZLT,
     S.MATXL,
     S.MATXLT,
     S.MATKL,
     S.MATKLT,
     S.GC_ID,
     S.GC_NAME,
     S.MD,
     S.EXC,
     S.DES);

--tmp
SELECT *
  FROM YANGJIN.DIM_GOOD_CLASS_TMP A
 WHERE NOT EXISTS (SELECT 1 FROM DIM_GOOD_CLASS B WHERE A.MATKL = B.MATKL);
SELECT *
  FROM DIM_GOOD_CLASS A
 WHERE NOT EXISTS
 (SELECT 1 FROM YANGJIN.DIM_GOOD_CLASS_TMP B WHERE A.MATKL = B.MATKL);
SELECT * FROM dim_good_class;

SELECT *
  FROM ALL_SOURCE A
 WHERE UPPER(A.TEXT) LIKE '%INSERT%DIM_GOOD_CLASS%';
