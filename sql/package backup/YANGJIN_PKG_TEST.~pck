CREATE OR REPLACE PACKAGE YANGJIN_PKG_TEST IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-05-31 10:41:42
  -- PURPOSE : YANGJIN PACKAGE

  TYPE TYPE_GR_ROW IS RECORD /*RECORD自定义行类型*/
  
  (
    TOPN          NUMBER, /*排名*/
    MEMBER_NUMBER NUMBER, /*购买人数*/
    ITEM_CODE     NUMBER(10), /*商品编码*/
    GOODS_NAME    VARCHAR2(200), /*商品名称*/
    MATDL         NUMBER(10), /*物料大类编码*/
    MATDLT        VARCHAR2(100), /*物料大类名称*/
    MATZL         NUMBER(10), /*物料中类编码*/
    MATZLT        VARCHAR2(100), /*物料中类名称*/
    MATXL         NUMBER(10), /*物料小类编码*/
    MATXLT        VARCHAR2(100) /*物料小类名称*/);

  TYPE TYPE_GR_TABLE IS TABLE OF TYPE_GR_ROW; /*自定义表类型*/

  FUNCTION GET_IP_CITY(IN_IP_INT IN NUMBER) RETURN VARCHAR2;
  /*返回ip归属城市*/
  FUNCTION MEMBER_REPURCHASE_CYCLE_DAYS(IN_MEMBER_KEY IN NUMBER)
    RETURN NUMBER;
  /*
  函数名：      MEMBER_REPURCHASE_CYCLE_DAYS
  目的：        返回会员的复购周期（天数）
  创建时间：    2017/08/17
  作者:         yangjin
  创建时间：    2017/08/24
  最后修改人：
  最后更改日期：
  */

  FUNCTION GET_GOODS_RECOMMEND(IN_MEMBER_BP IN NUMBER,
                               IN_ITEM_CODE IN NUMBER)
    RETURN GOODS_RECOMMEND_TABLE;
  /*
  函数名：      GET_GOODS_RECOMMEND
  目的：        
  创建时间：    2017/11/24
  作者:         yangjin
  创建时间：    2017/11/24
  最后修改人：
  最后更改日期：
  */

  FUNCTION GET_GOODS_RECOMMEND1(IN_MEMBER_BP IN NUMBER,
                                IN_ITEM_CODE IN NUMBER)
    RETURN GOODS_RECOMMEND_TABLE;
  --RETURN YANGJIN_PKG_TEST.TYPE_GR_TABLE;
/*
  函数名：      GET_GOODS_RECOMMEND
  目的：        
  创建时间：    2017/11/24
  作者:         yangjin
  创建时间：    2017/11/24
  最后修改人：
  最后更改日期：
  */

END YANGJIN_PKG_TEST;
/
CREATE OR REPLACE PACKAGE BODY YANGJIN_PKG_TEST IS

  FUNCTION GET_IP_CITY(IN_IP_INT IN NUMBER) RETURN VARCHAR2 IS
    RESULT_IP_CITY VARCHAR2(50);
  BEGIN
    SELECT /*+ INDEX(A,IP_START_IDX) */
     A.IP_CITY
      INTO RESULT_IP_CITY
      FROM DIM_IP_GEO A
     WHERE A.IP_START <= IN_IP_INT
       AND A.IP_END >= IN_IP_INT
       AND A.IP_CITY IS NOT NULL;
    RETURN(RESULT_IP_CITY);
  END GET_IP_CITY;

  FUNCTION MEMBER_REPURCHASE_CYCLE_DAYS(IN_MEMBER_KEY IN NUMBER)
    RETURN NUMBER IS
    RESULT_DAYS NUMBER;
    /*返回会员的复购周期（天数）*/
  BEGIN
    SELECT ROUND(NVL(SUM(C.POSTING_DATE - C.LAST_POSTING_DATE) /
                     COUNT(C.ORDER_KEY),
                     -1))
      INTO RESULT_DAYS
      FROM (SELECT B.MEMBER_KEY,
                   B.ORDER_KEY,
                   B.POSTING_DATE,
                   LAG(B.POSTING_DATE) OVER(PARTITION BY B.MEMBER_KEY ORDER BY B.POSTING_DATE) LAST_POSTING_DATE
              FROM (SELECT A.MEMBER_KEY,
                           TO_DATE(A.POSTING_DATE_KEY, 'yyyymmdd') POSTING_DATE,
                           A.ORDER_KEY
                      FROM MEMBER_LIFE_PERIOD_TMP_B A
                     WHERE A.ORDER_STATE = 1
                       AND A.MEMBER_KEY = IN_MEMBER_KEY
                          /*只取2016年之后的数据*/
                       AND A.POSTING_DATE_KEY >= 20160101) B) C
     WHERE C.LAST_POSTING_DATE IS NOT NULL;
    RETURN(RESULT_DAYS);
  END MEMBER_REPURCHASE_CYCLE_DAYS;

  --*********************************************************************************************
  FUNCTION GET_GOODS_RECOMMEND(IN_MEMBER_BP IN NUMBER,
                               IN_ITEM_CODE IN NUMBER)
    RETURN GOODS_RECOMMEND_TABLE IS
    V_GOODS_RECOMMEND_TABLE GOODS_RECOMMEND_TABLE := GOODS_RECOMMEND_TABLE();
  BEGIN
    FOR I IN (SELECT ROW_NUMBER() OVER(ORDER BY G.MEMBER_NUMBER DESC) TOPN,
                     G.MEMBER_NUMBER,
                     G.ITEM_CODE,
                     H.GOODS_NAME,
                     H.MATDL,
                     H.MATDLT,
                     H.MATZL,
                     H.MATZLT,
                     H.MATXL,
                     H.MATXLT
                FROM (SELECT F.ITEM_CODE, F.MEMBER_NUMBER
                        FROM (SELECT B.ITEM_CODE,
                                     COUNT(DISTINCT B.MEMBER_BP) MEMBER_NUMBER
                                FROM GOODS_RECOMMEND_BASE B
                               WHERE EXISTS
                               (SELECT 1
                                        FROM (SELECT A.MEMBER_BP
                                                FROM GOODS_RECOMMEND_BASE A
                                               WHERE A.ITEM_CODE = IN_ITEM_CODE) C
                                       WHERE B.MEMBER_BP = C.MEMBER_BP) /*购买此商品的所有会员*/
                                 AND NOT EXISTS
                               (SELECT 1
                                        FROM (SELECT E.ITEM_CODE
                                                FROM GOODS_RECOMMEND_BASE E
                                               WHERE E.MEMBER_BP = IN_MEMBER_BP) D
                                       WHERE B.ITEM_CODE = D.ITEM_CODE) /*此会员已经购买过的商品*/
                                 AND B.ITEM_CODE <> 0
                                 AND B.ITEM_CODE <> IN_ITEM_CODE
                                 AND B.ORDER_DATE >=
                                     TO_CHAR(SYSDATE - 91, 'YYYYMMDD') /*日期范围最近90天*/
                               GROUP BY B.ITEM_CODE) F
                       WHERE ROWNUM <= 50
                       ORDER BY F.MEMBER_NUMBER DESC) G,
                     DIM_GOOD H
               WHERE G.ITEM_CODE = H.ITEM_CODE
                 AND H.CURRENT_FLG = 'Y') LOOP
      V_GOODS_RECOMMEND_TABLE.EXTEND;
      V_GOODS_RECOMMEND_TABLE(V_GOODS_RECOMMEND_TABLE.COUNT) := GOODS_RECOMMEND_ROW(I.TOPN,
                                                                                    I.MEMBER_NUMBER,
                                                                                    I.ITEM_CODE,
                                                                                    I.GOODS_NAME,
                                                                                    I.MATDL,
                                                                                    I.MATDLT,
                                                                                    I.MATZL,
                                                                                    I.MATZLT,
                                                                                    I.MATXL,
                                                                                    I.MATXLT);
    END LOOP;
    RETURN V_GOODS_RECOMMEND_TABLE;
  END GET_GOODS_RECOMMEND;

  --*************************************************************************************************
  FUNCTION GET_GOODS_RECOMMEND1(IN_MEMBER_BP IN NUMBER,
                                IN_ITEM_CODE IN NUMBER)
    RETURN GOODS_RECOMMEND_TABLE IS
    --RETURN YANGJIN_PKG_TEST.TYPE_GR_TABLE IS
    V_GR_TABLE GOODS_RECOMMEND_TABLE := GOODS_RECOMMEND_TABLE();
    --V_GR_TABLE YANGJIN_PKG_TEST.TYPE_GR_TABLE := YANGJIN_PKG_TEST.TYPE_GR_TABLE();
  BEGIN
    FOR I IN (SELECT ROW_NUMBER() OVER(ORDER BY G.MEMBER_NUMBER DESC) TOPN,
                     G.MEMBER_NUMBER,
                     G.ITEM_CODE,
                     H.GOODS_NAME,
                     H.MATDL,
                     H.MATDLT,
                     H.MATZL,
                     H.MATZLT,
                     H.MATXL,
                     H.MATXLT
                FROM (SELECT F.ITEM_CODE, F.MEMBER_NUMBER
                        FROM (SELECT B.ITEM_CODE,
                                     COUNT(DISTINCT B.MEMBER_BP) MEMBER_NUMBER
                                FROM GOODS_RECOMMEND_BASE B
                               WHERE EXISTS
                               (SELECT 1
                                        FROM (SELECT A.MEMBER_BP
                                                FROM GOODS_RECOMMEND_BASE A
                                               WHERE A.ITEM_CODE = IN_ITEM_CODE) C
                                       WHERE B.MEMBER_BP = C.MEMBER_BP) /*购买此商品的所有会员*/
                                 AND NOT EXISTS
                               (SELECT 1
                                        FROM (SELECT E.ITEM_CODE
                                                FROM GOODS_RECOMMEND_BASE E
                                               WHERE E.MEMBER_BP = IN_MEMBER_BP) D
                                       WHERE B.ITEM_CODE = D.ITEM_CODE) /*此会员已经购买过的商品*/
                                 AND B.ITEM_CODE <> 0
                                 AND B.ITEM_CODE <> IN_ITEM_CODE
                                 AND B.ORDER_DATE >=
                                     TO_CHAR(SYSDATE - 91, 'YYYYMMDD') /*日期范围最近90天*/
                               GROUP BY B.ITEM_CODE) F
                       WHERE ROWNUM <= 50
                       ORDER BY F.MEMBER_NUMBER DESC) G,
                     DIM_GOOD H
               WHERE G.ITEM_CODE = H.ITEM_CODE
                 AND H.CURRENT_FLG = 'Y') LOOP
      V_GR_TABLE.EXTEND;
      V_GR_TABLE(V_GR_TABLE.COUNT) := GOODS_RECOMMEND_ROW(I.TOPN,
                                                          --V_GR_TABLE(V_GR_TABLE.COUNT) := YANGJIN_PKG_TEST.TYPE_GR_ROW(I.TOPN,
                                                          I.MEMBER_NUMBER,
                                                          I.ITEM_CODE,
                                                          I.GOODS_NAME,
                                                          I.MATDL,
                                                          I.MATDLT,
                                                          I.MATZL,
                                                          I.MATZLT,
                                                          I.MATXL,
                                                          I.MATXLT);
    END LOOP;
    RETURN V_GR_TABLE;
  END GET_GOODS_RECOMMEND1;

END YANGJIN_PKG_TEST;
/
