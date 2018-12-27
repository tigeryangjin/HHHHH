/*
12月浏览美妆类商品的用户BP和次数
*/
--浏览
SELECT TO_NUMBER(A.MEMBER_KEY) MEMBER_BP, COUNT(1) PV
  FROM FACT_PAGE_VIEW SUBPARTITION(FPV201812) A
 WHERE A.VISIT_DATE_KEY BETWEEN 20181201 AND 20181231
   AND A.MEMBER_KEY <> 0
   AND a.page_value =
       translate(a.page_value,
                 '0' || translate(a.page_value, '#0123456789', '#'),
                 '0')
   AND EXISTS (SELECT 1
          FROM (SELECT D.GOODS_COMMONID
                  FROM DIM_EC_GOOD D
                 WHERE D.MATDL IN (30)) B
         WHERE A.PAGE_VALUE = B.GOODS_COMMONID)
 GROUP BY TO_NUMBER(A.MEMBER_KEY)
 ORDER BY COUNT(1) DESC;

--tmp
SELECT * FROM DIM_GOOD_CLASS A WHERE A.MATDLT LIKE '%美%';
SELECT * FROM DIM_GOOD_CLASS A WHERE A.MATZLT LIKE '%美%';
SELECT * FROM DIM_GOOD_CLASS A WHERE A.MATXLT LIKE '%美%';
SELECT * FROM DIM_GOOD_CLASS A WHERE A.Matklt LIKE '%美%';

SELECT * FROM DIM_GOOD_CLASS A WHERE A.MATDLT LIKE '%妆%';
SELECT * FROM DIM_GOOD_CLASS A WHERE A.MATZLT LIKE '%妆%';
SELECT * FROM DIM_GOOD_CLASS A WHERE A.MATXLT LIKE '%妆%';
SELECT * FROM DIM_GOOD_CLASS A WHERE A.Matklt LIKE '%妆%';
