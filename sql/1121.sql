SELECT * FROM OPER_NM_PROMOTION_ORDER_REPORT A WHERE A.ADD_TIME BETWEEN DATE'2017-11-21' AND DATE'2017-11-22';
SELECT * FROM FACT_EC_P_MANSONG A WHERE A.MANSONG_NAME LIKE '%API%';
SELECT 153+13 FROM DUAL;
SELECT * FROM OPER_NM_PROMOTION_ORDER_REPORT A WHERE A.PROMOTION_NAME LIKE '%API%';

SELECT * FROM DIM_GOOD A WHERE A.GOODS_NAME LIKE '%快乐自营五常金方田%';

SELECT *
  FROM DIM_GOOD A
 WHERE A.ITEM_CODE IN (195923,
                       192587,
                       198308,
                       171323001,
                       202832,
                       190511
                       
                       );
											 
SELECT * FROM FACT_GOODS_SALES A WHERE A.POSTING_DATE_KEY=20171123;


SELECT F.ITEM_CODE, F.MEMBER_NUMBER
  FROM (SELECT B.ITEM_CODE, COUNT(DISTINCT B.MEMBER_BP) MEMBER_NUMBER
          FROM GOODS_RECOMMEND_BASE B
         WHERE EXISTS (SELECT 1
                  FROM (SELECT A.MEMBER_BP
                          FROM GOODS_RECOMMEND_BASE A
                         WHERE A.ITEM_CODE = 225310) C
                 WHERE B.MEMBER_BP = C.MEMBER_BP) /*购买此商品的所有会员*/
           AND NOT EXISTS
         (SELECT 1
                  FROM (SELECT E.ITEM_CODE
                          FROM GOODS_RECOMMEND_BASE E
                         WHERE E.MEMBER_BP = 1111006723) D
                 WHERE B.ITEM_CODE = D.ITEM_CODE) /*此会员已经购买过的商品*/
           AND B.ITEM_CODE <> 0
           AND B.ITEM_CODE <> 225310
           AND B.ORDER_DATE >= TO_CHAR(SYSDATE - 91, 'YYYYMMDD') /*日期范围最近90天*/
         GROUP BY B.ITEM_CODE) F
 WHERE ROWNUM <= 50
 ORDER BY F.MEMBER_NUMBER DESC;
