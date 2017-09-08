SELECT *
  FROM DIM_GOOD A
 WHERE A.ITEM_CODE IN (223910,
                       224087,
                       224226,
                       224253,
                       224403,
                       224441,
                       224522,
                       224523,
                       224559,
                       224600,
                       224689,
                       224794,
                       225009,
                       225027,
                       225029,
                       225126,
                       225127,
                       225133,
                       225136,
                       225330,
                       225513,
                       226026);

SELECT *
  from ods_zmaterial a
 where a.zmater2 in ('000000000000223910',
                     '000000000000224087',
                     '000000000000224226',
                     '000000000000224253',
                     '000000000000224403',
                     '000000000000224441',
                     '000000000000224522',
                     '000000000000224523',
                     '000000000000224559',
                     '000000000000224600',
                     '000000000000224689',
                     '000000000000224794',
                     '000000000000225009',
                     '000000000000225027',
                     '000000000000225029',
                     '000000000000225126',
                     '000000000000225127',
                     '000000000000225133',
                     '000000000000225136',
                     '000000000000225330',
                     '000000000000225513',
                     '000000000000226026');

SELECT A.GOODS_COMMON_KEY, MIN(A.POSTING_DATE_KEY)
  FROM FACT_GOODS_SALES A
 WHERE A.GOODS_COMMON_KEY IN (223910,
                              224087,
                              224226,
                              224253,
                              224403,
                              224441,
                              224522,
                              224523,
                              224559,
                              224600,
                              224689,
                              224794,
                              225009,
                              225027,
                              225029,
                              225126,
                              225127,
                              225133,
                              225136,
                              225330,
                              225513,
                              226026)
 GROUP BY A.GOODS_COMMON_KEY
 ORDER BY 2 DESC;
