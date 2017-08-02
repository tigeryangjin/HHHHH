--TMP
DROP TABLE JIN_TMP;
CREATE TABLE JIN_TMP AS
SELECT A.VISIT_DATE_KEY, A.MEMBER_KEY, A.PAGE_VALUE
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY BETWEEN 20170601 AND 20170730 /*最近二个月*/
   AND A.PAGE_NAME IN ('good', 'Good')
   AND A.MEMBER_KEY <> 0;

--近2月订购+加购物车过水果( MATxLT='生鲜蔬果')和榨汁机 的会员
SELECT DISTINCT E.MEMBER_KEY
  FROM (SELECT DISTINCT A.MEMBER_KEY
          FROM JIN_TMP A
         WHERE EXISTS (SELECT 1
                  FROM (SELECT TO_CHAR(D.ITEM_CODE) ITEM_CODE
                          FROM DIM_GOOD D
                         WHERE D.CURRENT_FLG = 'Y'
                           AND D.MATXL = 510602
                        UNION ALL
                        SELECT '215588' ITEM_CODE
                          from dual
                        union all
                        select '216178'
                          from dual
                        union all
                        select '196899'
                          from dual
                        union all
                        select '215063'
                          from dual
                        union all
                        select '212484'
                          from dual
                        union all
                        select '209836'
                          from dual
                        union all
                        select '201434'
                          from dual
                        union all
                        select '221313'
                          from dual
                        union all
                        select '214532'
                          from dual
                        union all
                        select '214498'
                          FROM DUAL) C
                 WHERE A.PAGE_VALUE = C.ITEM_CODE)
        UNION ALL
        /*加车*/
        SELECT DISTINCT B.MEMBER_KEY
          FROM FACT_SHOPPINGCAR B
         WHERE B.CREATE_DATE BETWEEN DATE '2017-06-01' AND DATE
         '2017-07-30' /*最近二个月*/
           AND (B.SCGID IN ('215588',
                            '216178',
                            '196899',
                            '215063',
                            '212484',
                            '209836',
                            '201434',
                            '221313',
                            '214532',
                            '214498') OR EXISTS
                (SELECT 1
                   FROM (SELECT *
                           FROM DIM_GOOD D
                          WHERE D.CURRENT_FLG = 'Y'
                            AND D.MATXL = 510602) C
                  WHERE B.SCGID = C.ITEM_CODE))) E
									ORDER BY 1;




