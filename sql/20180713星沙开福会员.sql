--1.
SELECT COUNT(1)
  FROM (SELECT A.MEMBER_KEY, A.ADDRESS_KEY
          FROM FACT_ORDER A, DIM_ZONE B
         WHERE A.ADDRESS_KEY = B.ZONE1_4
           AND A.MEMBER_KEY <> 0
           AND A.POSTING_DATE_KEY >= 20180113
           AND B.VTEXT2 = '长沙市'
           AND B.VTEXT3 IN ('长沙县', '开福区')) C;

--2.
SELECT DISTINCT C.MEMBER_KEY
  FROM (SELECT A.MEMBER_KEY, A.ADDRESS_KEY
          FROM FACT_ORDER A, DIM_ZONE B
         WHERE A.ADDRESS_KEY = B.ZONE1_4
           AND A.MEMBER_KEY <> 0
           AND A.POSTING_DATE_KEY >= 20170713
           AND B.ZONE1_4 IN (10008,
                             10009,
                             10012,
                             10013,
                             10014,
                             10015,
                             10016,
                             10017,
                             10018,
                             10020,
                             11398,
                             11400,
                             5953,
                             5954,
                             5955,
                             5957,
                             5966,
                             7332,
                             7435,
                             7436,
                             7446,
                             9263,
                             9914,
                             9915)) C
 ORDER BY C.MEMBER_KEY;

--tmp
SELECT * FROM DIM_ZONE B WHERE B.VTEXT2 LIKE '%长沙%';
SELECT *
  FROM DIM_ZONE B
 WHERE B.VTEXT2 = '长沙市'
   AND B.VTEXT3 IN ('长沙县')
 ORDER BY B.ZONE1_4;
