CREATE OR REPLACE PACKAGE YANGJIN_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-05-31 10:41:42
  -- PURPOSE : YANGJIN PACKAGE

  FUNCTION IP_INT_TO_STR(IN_IP_INT IN NUMBER) RETURN VARCHAR2;
  /*ip int 转换*/

  FUNCTION GET_IP_CITY(IN_IP_INT IN NUMBER) RETURN VARCHAR2;
  /*返回ip归属城市*/

  FUNCTION UNIX_TO_ORACLE(IN_NUMBER IN NUMBER) RETURN DATE;
  /*UNIX时间转成ORACLE时间*/

  FUNCTION GET_DIM_GOOD_PRICE_LEVEL(IN_ITEM_CODE IN NUMBER) RETURN VARCHAR2;
  /*返回商品价格在所属物料细类的等级*/

  FUNCTION RAND_STRING(N IN NUMBER) RETURN VARCHAR2;
  /*随机生成指定长度字符串*/

  PROCEDURE YANGJIN_PKG_DATE_FIX(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       YANGJIN_PKG_DATE_FIX
  目的:         
  作者:         yangjin
  创建时间：    2017/12/04
  最后修改人：
  最后更改日期：
  */

  PROCEDURE LOG_TEST;
  /*
  功能名:       DATA_ACQUISITION_ITEM_MIN_PER
  目的:         统计 DATA_ACQUISITION_ITEM的最小PERIOD
  作者:         yangjin
  创建时间：    2017/10/30
  最后修改人：
  最后更改日期：
  */

  PROCEDURE ALTER_TABLE_SHRINK_SPACE(IN_TABLE_NAME IN VARCHAR2);
  /*
  功能名:       ALTER_TABLE_SHRINK_SPACE
  目的:         收缩表的高水位线
  作者:         yangjin
  创建时间：    2017/07/26
  最后修改人：
  最后更改日期：
  */

  PROCEDURE TABLE_OPTIMIZATION;
  /*
  功能名:       TABLE_OPTIMIZATION
  目的:         数据库表优化
  作者:         yangjin
  创建时间：    2017/09/27
  最后修改人：
  最后更改日期：
  */

  PROCEDURE PROCESSMAKETHMSC_IA(STARTPOINT IN NUMBER);
  /*
  功能名:       PROCESSMAKETHMSC_IA
  目的:         在原FACT_HMSC_MARKET表的基础上，细化到商品和地区
  作者:         yangjin
  创建时间：    2017/05/31
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_PRODUCT_DAILY_RPT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_PRODUCT_DAILY_RPT
  目的:         新媒体中心数据日报
  作者:         yangjin
  创建时间：    2017/06/13
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_PRODUCT_DAILY_PREVIEW(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_PRODUCT_DAILY_PREVIEW
  目的:         新媒体中心每日商品预览
  作者:         yangjin
  创建时间：    2018/01/19
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_PRODUCT_PVUV_DAILY_RPT(IN_VISIT_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_PRODUCT_PVUV_DAILY_RPT
  目的:         
  作者:         yangjin
  创建时间：    2017/06/29
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_NM_PROMOTION_ITEM_RPT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_NM_PROMOTION_ITEM_RPT
  目的:         新媒体中心促销报表（商品级别）
  作者:         yangjin
  创建时间：    2017/09/19
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_NM_PROMOTION_ORDER_RPT(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_NM_PROMOTION_ORDER_RPT
  目的:         新媒体中心促销报表（订单级别）
  作者:         yangjin
  创建时间：    2017/09/19
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_NM_VOUCHER_RPT;
  /*
  功能名:       OPER_NM_VOUCHER_RPT
  目的:         新媒体中心优惠券报表
  作者:         yangjin
  创建时间：    2017/09/19
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_MEMBER_NOT_IN_EC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_MEMBER_NOT_IN_EC
  目的:         在其他渠道下单了但是没有在电商注册会员的每天发短信(每天)
  作者:         yangjin
  创建时间：    2017/07/27
  最后修改人：
  最后更改日期：
  */

  PROCEDURE FACT_GOODS_SALES_FIX(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       FACT_GOODS_SALES_FIX
  目的:         通过存储过程重新往FACT_GOODS_SALES,FACT_GOODS_SALES_REVERSE插入数据
  作者:         yangjin
  创建时间：    2017/07/28
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DIM_GOOD_FIX;
  /*
  功能名:       DIM_GOOD_FIX
  目的:         对DIM_GOOD表修复数据，如果有商品资料未导入DIM_GOOD
                ODS_ZMATERIAL有的商品而DIM_GOOD没有的商品资料。
  作者:         yangjin
  创建时间：    2017/08/15
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DIM_GOOD_PRICE_LEVEL_UPDATE;
  /*
  功能名:       DIM_GOOD_PRICE_LEVEL_UPDATE
  目的:         更新DIM_GOOD.GOOD_PRICE_LEVEL字段，使用GET_DIM_GOOD_PRICE_LEVEL函数
  作者:         yangjin
  创建时间：    2017/08/31
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DISTRICT_NAME_UPDATE;
  /*
  功能名:       DISTRICT_NAME_UPDATE
  目的:         住宅小区名字更新
  作者:         yangjin
  创建时间：    2017/07/30
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DATA_ACQUISITION_ITEM_BASE(I_DATE_KEY NUMBER);
  /*
  功能名:       DATA_ACQUISITION_ITEM_BASE
  目的:         清洗DATA_ACQUISITION_ITEM表，去除重复数据,插入中间表DATA_ACQUISITION_ITEM_TMP
                然后再插入DATA_ACQUISITION_ITEM_BASE表。
  作者:         yangjin
  创建时间：    2017/11/01
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DATA_ACQUISITION_ITEM_CURRENT(I_DATE_KEY NUMBER);
  /*
  功能名:       DATA_ACQUISITION_ITEM_CURRENT
  目的:         从DATA_ACQUISITION_ITEM_BASE表取数，计算出当期的销售数量和销售金额写入DATA_ACQUISITION_ITEM_CURRENT表
  作者:         yangjin
  创建时间：    2017/11/01
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DATA_ACQUISITION_ITEM_MIN_PER;
  /*
  功能名:       DATA_ACQUISITION_ITEM_MIN_PER
  目的:         统计 DATA_ACQUISITION_ITEM的最小PERIOD
  作者:         yangjin
  创建时间：    2017/10/30
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DATA_ACQUISITION_WEEK_TOPN(I_DATE_KEY NUMBER);
  /*
  功能名:       DATA_ACQUISITION_WEEK_TOPN
  目的:         DATA_ACQUISITION_WEEK_TOPN周销售排行 
  作者:         yangjin
  创建时间：    2017/11/02
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DATA_ACQUISITION_WEEK_NEW(I_DATE_KEY NUMBER);
  /*
  功能名:       DATA_ACQUISITION_WEEK_NEW
  目的:         DATA_ACQUISITION_WEEK_NEW周新品销售排行 
  作者:         yangjin
  创建时间：    2017/11/02
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DATA_ACQUISITION_MONTH_TOPN(I_DATE_KEY NUMBER);
  /*
  功能名:       DATA_ACQUISITION_MONTH_TOPN
  目的:         DATA_ACQUISITION_MONTH_TOPN月销售排行 
  作者:         yangjin
  创建时间：    2017/10/30
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DATA_ACQUISITION_MONTH_NEW(I_DATE_KEY NUMBER);
  /*
  功能名:       DATA_ACQUISITION_MONTH_NEW
  目的:         DATA_ACQUISITION_MONTH_NEW月新品销售排行 
  作者:         yangjin
  创建时间：    2017/10/30
  最后修改人：
  最后更改日期：
  */

  PROCEDURE EC_NEW_MEMBER_TRACK_BASE(I_DATE_KEY NUMBER);
  /*
  功能名:       EC_NEW_MEMBER_TRACK_BASE
  目的:         用于跟踪ec会员0-5单的订购情况，此表为基表，在此表基础上计算0-5单顺序 
  作者:         yangjin
  创建时间：    2017/11/09
  最后修改人：
  最后更改日期：
  */

  PROCEDURE EC_NEW_MEMBER_TRACK_RANK;
  /*
  功能名:       EC_NEW_MEMBER_TRACK_RANK
  目的:         计算ec会员的第几单
  作者:         yangjin
  创建时间：    2017/11/09
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_DIM_MEMBER_ZONE;
  /*
  功能名:       MERGE_DIM_MEMBER_ZONE
  目的:         member地区
  作者:         yangjin
  创建时间：    2017/11/22
  最后修改人：
  最后更改日期：
  */

  PROCEDURE FACT_TV_QRC_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       FACT_TV_QRC_PROC
  目的:         tv商品扫码行为记录
  作者:         yangjin
  创建时间：    2018/01/31
  最后修改人：
  最后更改日期：
  */

  PROCEDURE CR_DATA_BASE_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       CR_DATA_BASE_PROC
  目的:         商品推荐基础表，用于阿里云的输入数据。
  作者:         yangjin
  创建时间：    2018/02/07
  最后修改人：
  最后更改日期：
  */

END YANGJIN_PKG;
/
CREATE OR REPLACE PACKAGE BODY YANGJIN_PKG IS

  FUNCTION IP_INT_TO_STR(IN_IP_INT IN NUMBER) RETURN VARCHAR2 IS
    RESULT_IP_STR VARCHAR2(20);
  BEGIN
    IF IN_IP_INT BETWEEN 0 AND 4294967295
    THEN
      RESULT_IP_STR := TO_CHAR(FLOOR(IN_IP_INT / (256 * 256 * 256))) || '.' ||
                       TO_CHAR(FLOOR((IN_IP_INT -
                                     FLOOR(IN_IP_INT / (256 * 256 * 256)) * 256 * 256 * 256) /
                                     (256 * 256))) || '.' ||
                       TO_CHAR(FLOOR((IN_IP_INT -
                                     FLOOR(IN_IP_INT / (256 * 256 * 256)) * 256 * 256 * 256 -
                                     FLOOR((IN_IP_INT -
                                            FLOOR(IN_IP_INT /
                                                   (256 * 256 * 256)) * 256 * 256 * 256) /
                                            (256 * 256)) * 256 * 256) / 256)) || '.' ||
                       TO_CHAR(IN_IP_INT -
                               FLOOR(IN_IP_INT / (256 * 256 * 256)) * 256 * 256 * 256 -
                               FLOOR((IN_IP_INT -
                                     FLOOR(IN_IP_INT / (256 * 256 * 256)) * 256 * 256 * 256) /
                                     (256 * 256)) * 256 * 256 -
                               FLOOR((IN_IP_INT -
                                     FLOOR(IN_IP_INT / (256 * 256 * 256)) * 256 * 256 * 256 -
                                     FLOOR((IN_IP_INT -
                                            FLOOR(IN_IP_INT /
                                                   (256 * 256 * 256)) * 256 * 256 * 256) /
                                            (256 * 256)) * 256 * 256) / 256) * 256);
    ELSE
      RESULT_IP_STR := NULL;
    END IF;
    RETURN(RESULT_IP_STR);
  END IP_INT_TO_STR;

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

  FUNCTION UNIX_TO_ORACLE(IN_NUMBER IN NUMBER) RETURN DATE IS
  BEGIN
    RETURN(TO_DATE('19700101', 'yyyymmdd') + IN_NUMBER / 86400 +
           TO_NUMBER(SUBSTR(TZ_OFFSET(SESSIONTIMEZONE), 1, 3)) / 24);
  END UNIX_TO_ORACLE;

  FUNCTION GET_DIM_GOOD_PRICE_LEVEL(IN_ITEM_CODE IN NUMBER) RETURN VARCHAR2 IS
    /*返回商品价格在所属物料细类的等级*/
    V_MATL_GROUP       NUMBER;
    V_GOOD_PRICE_LEVEL VARCHAR2(10);
  BEGIN
    DECLARE
      TYPE TYPE_ARRAYS IS RECORD(
        MATL_GROUP      NUMBER,
        HIGH_PRICE_LINE NUMBER,
        LOW_PRICE_LINE  NUMBER);
    
      TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --类似二维数组 
    
      VAR_ARRAY TYPE_ARRAY;
    BEGIN
      /*V_MATL_GROUP*/
      SELECT A.MATL_GROUP
        INTO V_MATL_GROUP
        FROM DIM_GOOD A
       WHERE A.ITEM_CODE = IN_ITEM_CODE
         AND A.CURRENT_FLG = 'Y';
      /*HIGH_PRICE_LINE,LOW_PRICE_LINE*/
      SELECT G.*
        BULK COLLECT
        INTO VAR_ARRAY
        FROM (SELECT D.MATL_GROUP,
                     (CASE
                       WHEN D.HIGH_PRICE_LINE > F.PRICE43 * 1.2 THEN
                        F.PRICE43 * 1.2
                       ELSE
                        D.HIGH_PRICE_LINE
                     END) HIGH_PRICE_LINE,
                     (CASE
                       WHEN D.LOW_PRICE_LINE < E.PRICE41 * 0.8 THEN
                        E.PRICE41 * 0.8
                       ELSE
                        D.LOW_PRICE_LINE
                     END) LOW_PRICE_LINE
                FROM (SELECT A.MATL_GROUP,
                             AVG(NVL(A.GOOD_PRICE, 0)) +
                             STDDEV(NVL(A.GOOD_PRICE, 0)) HIGH_PRICE_LINE,
                             AVG(NVL(A.GOOD_PRICE, 0)) -
                             STDDEV(NVL(A.GOOD_PRICE, 0)) LOW_PRICE_LINE
                        FROM DIM_GOOD A
                       WHERE A.GOOD_PRICE > 0
                         AND A.CURRENT_FLG = 'Y'
                       GROUP BY A.MATL_GROUP, A.MATXXLT) D,
                     (SELECT C.MATL_GROUP, MEDIAN(C.GOOD_PRICE) PRICE41
                        FROM (SELECT A.MATL_GROUP,
                                     A.GOOD_PRICE,
                                     B.MEDIAN_PRICE
                                FROM (SELECT A1.MATL_GROUP, A1.GOOD_PRICE
                                        FROM DIM_GOOD A1
                                       WHERE A1.GOOD_PRICE > 0
                                         AND A1.CURRENT_FLG = 'Y') A,
                                     (SELECT B1.MATL_GROUP,
                                             MEDIAN(B1.GOOD_PRICE) MEDIAN_PRICE
                                        FROM DIM_GOOD B1
                                       WHERE B1.GOOD_PRICE > 0
                                         AND B1.CURRENT_FLG = 'Y'
                                       GROUP BY B1.MATL_GROUP) B
                               WHERE A.MATL_GROUP = B.MATL_GROUP(+)) C
                       WHERE C.GOOD_PRICE < C.MEDIAN_PRICE
                       GROUP BY C.MATL_GROUP) E,
                     (SELECT C.MATL_GROUP, MEDIAN(C.GOOD_PRICE) PRICE43
                        FROM (SELECT A.MATL_GROUP,
                                     A.GOOD_PRICE,
                                     B.MEDIAN_PRICE
                                FROM (SELECT A1.MATL_GROUP, A1.GOOD_PRICE
                                        FROM DIM_GOOD A1
                                       WHERE A1.GOOD_PRICE > 0
                                         AND A1.CURRENT_FLG = 'Y') A,
                                     (SELECT B1.MATL_GROUP,
                                             MEDIAN(B1.GOOD_PRICE) MEDIAN_PRICE
                                        FROM DIM_GOOD B1
                                       WHERE B1.GOOD_PRICE > 0
                                         AND B1.CURRENT_FLG = 'Y'
                                       GROUP BY B1.MATL_GROUP) B
                               WHERE A.MATL_GROUP = B.MATL_GROUP(+)) C
                       WHERE C.GOOD_PRICE > C.MEDIAN_PRICE
                       GROUP BY C.MATL_GROUP) F
               WHERE D.MATL_GROUP = E.MATL_GROUP
                 AND D.MATL_GROUP = F.MATL_GROUP) G
       WHERE G.MATL_GROUP = V_MATL_GROUP;
      /*V_GOOD_PRICE_LEVEL*/
      SELECT CASE
               WHEN H.GOOD_PRICE < VAR_ARRAY(1).LOW_PRICE_LINE THEN
                'LOW'
               WHEN H.GOOD_PRICE >= VAR_ARRAY(1).LOW_PRICE_LINE AND
                    H.GOOD_PRICE <= VAR_ARRAY(1).HIGH_PRICE_LINE THEN
                'MEDIUM'
               WHEN H.GOOD_PRICE > VAR_ARRAY(1).HIGH_PRICE_LINE THEN
                'HIGH'
             END
        INTO V_GOOD_PRICE_LEVEL
        FROM DIM_GOOD H
       WHERE H.ITEM_CODE = IN_ITEM_CODE
         AND H.CURRENT_FLG = 'Y'
         AND H.GOOD_PRICE > 0 /*商品价格大于0才分档*/
      ;
    END;
    RETURN(V_GOOD_PRICE_LEVEL);
  END GET_DIM_GOOD_PRICE_LEVEL;

  FUNCTION RAND_STRING(N IN NUMBER) RETURN VARCHAR2 IS
    RETURN_STRING VARCHAR2(20);
    I             NUMBER;
  BEGIN
    FOR I IN 1 .. N LOOP
      RETURN_STRING := RETURN_STRING || SUBSTR('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
                                               TRUNC(DBMS_RANDOM.VALUE(1, 62)),
                                               1);
    END LOOP;
    RETURN(RETURN_STRING);
  END RAND_STRING;

  PROCEDURE YANGJIN_PKG_DATE_FIX(IN_POSTING_DATE_KEY IN NUMBER) IS
  
    /*
    功能说明：每天的运行的存储过程，用于手工维护执行
    作者时间：yangjin  2017-10-30
    */
  
  BEGIN
    BEGIN
      YANGJIN_PKG.PROCESSMAKETHMSC_IA(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.OPER_PRODUCT_DAILY_RPT(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.OPER_PRODUCT_PVUV_DAILY_RPT(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.OPER_NM_PROMOTION_ITEM_RPT(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.OPER_NM_PROMOTION_ORDER_RPT(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.OPER_NM_VOUCHER_RPT;
      YANGJIN_PKG.OPER_MEMBER_NOT_IN_EC(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.DIM_GOOD_PRICE_LEVEL_UPDATE;
      YANGJIN_PKG.DATA_ACQUISITION_ITEM_BASE(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.DATA_ACQUISITION_ITEM_CURRENT(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.DATA_ACQUISITION_ITEM_MIN_PER;
      YANGJIN_PKG.DATA_ACQUISITION_WEEK_TOPN(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.DATA_ACQUISITION_WEEK_NEW(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.DATA_ACQUISITION_MONTH_TOPN(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.DATA_ACQUISITION_MONTH_NEW(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.EC_NEW_MEMBER_TRACK_BASE(IN_POSTING_DATE_KEY);
      YANGJIN_PKG.EC_NEW_MEMBER_TRACK_RANK;
      YANGJIN_PKG.MERGE_DIM_MEMBER_ZONE;
    END;
  END YANGJIN_PKG_DATE_FIX;

  PROCEDURE LOG_TEST IS
    V_OUTPUT_FILE UTL_FILE.FILE_TYPE;
    V_FILE_NAME   VARCHAR2(50);
  
    /*
    功能说明：DATA_ACQUISITION_MONTH_TOPN月销售排行  
    作者时间：yangjin  2017-10-30
    */
  
  BEGIN
    --外层循环得到内层循环BETWEEN的最小值和最大值
    FOR J IN (SELECT (LEVEL - 1) * 1000000 MINVAL, LEVEL * 1000000 MAXVAL
                FROM DUAL
              CONNECT BY LEVEL <=
                         (SELECT COUNT(1) FROM ODSHAPPIGO.ODS_PAGEVIEW) /
                         1000000 + 1) LOOP
      /*统一文件名称*/
      V_FILE_NAME := 'ods_pv_' || TO_CHAR(SYSDATE, 'YYYYMMDD_HH24MISS') ||
                     '.log';
      /*打开文件*/
      V_OUTPUT_FILE := UTL_FILE.FOPEN('LOG_TEST', V_FILE_NAME, 'W', 32767);
    
      /*写入title*/
      UTL_FILE.PUT_LINE(V_OUTPUT_FILE,
                        'ID,VID,MID,V,T,HMSC,HMMD,HMPL,HMKW,HMCI,URL,QUERY,AGENT,IP,CREATEON,A,VER,P,ISPROCESSED');
    
      /*循环，获取需要导出的数据*/
      FOR I IN (SELECT B.ID,
                       B.VID,
                       B.MID,
                       B.V,
                       B.T,
                       B.HMSC,
                       B.HMMD,
                       B.HMPL,
                       B.HMKW,
                       B.HMCI,
                       B.URL,
                       B.QUERY,
                       B.AGENT,
                       B.IP,
                       B.CREATEON,
                       B.A,
                       B.VER,
                       B.P,
                       B.ISPROCESSED
                  FROM (SELECT A.ID,
                               A.VID,
                               A.MID,
                               A.V,
                               A.T,
                               A.HMSC,
                               A.HMMD,
                               A.HMPL,
                               A.HMKW,
                               A.HMCI,
                               A.URL,
                               A.QUERY,
                               A.AGENT,
                               A.IP,
                               A.CREATEON,
                               A.A,
                               A.VER,
                               A.P,
                               A.ISPROCESSED,
                               ROW_NUMBER() OVER(ORDER BY A.ID) RN
                          FROM ODSHAPPIGO.ODS_PAGEVIEW A) B
                 WHERE B.RN BETWEEN J.MINVAL AND J.MAXVAL) LOOP
      
        /*行数据依次写入文件*/
        UTL_FILE.PUT_LINE(V_OUTPUT_FILE,
                          I.ID || ',' || I.VID || ',' || I.MID || ',' || I.V || ',' || I.T || ',' ||
                          I.HMSC || ',' || I.HMMD || ',' || I.HMPL || ',' ||
                          I.HMKW || ',' || I.HMCI || ',' || I.URL || ',' ||
                          I.QUERY || ',' || I.AGENT || ',' || I.IP || ',' ||
                          I.CREATEON || ',' || I.A || ',' || I.VER || ',' || I.P || ',' ||
                          I.ISPROCESSED);
      END LOOP;
    
      /*关闭文件*/
      UTL_FILE.FCLOSE(V_OUTPUT_FILE);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
  END LOG_TEST;

  PROCEDURE ALTER_TABLE_SHRINK_SPACE(IN_TABLE_NAME IN VARCHAR2) IS
  BEGIN
  
    EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(IN_TABLE_NAME) ||
                      ' ENABLE ROW MOVEMENT';
    EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(IN_TABLE_NAME) ||
                      ' SHRINK SPACE';
    EXECUTE IMMEDIATE 'ALTER TABLE ' || TO_CHAR(IN_TABLE_NAME) ||
                      ' DISABLE ROW MOVEMENT';
    DBMS_STATS.GATHER_TABLE_STATS('DW_USER', TO_CHAR(IN_TABLE_NAME));
  END ALTER_TABLE_SHRINK_SPACE;

  PROCEDURE TABLE_OPTIMIZATION IS
  BEGIN
    /*
    每周六20:00开始执行
    */
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('DATA_ACQUISITION_ITEM_BASE');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('DATA_ACQUISITION_ITEM_CURRENT');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('DATA_ACQUISITION_MONTH_NEW');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_ORDER_2');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_ORDER_COMMON');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_ORDER_GOODS');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_P_MANSONG');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_P_MANSONG_GOODS');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_P_XIANSHI');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_P_XIANSHI_GOODS');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_VOUCHER');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_VOUCHER_BATCH');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_GOODS_COMMON');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('FACT_EC_GOODS_MANUAL');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('KPI_ACTIVE_VID_BASE');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('MEMBER_LABEL_LINK');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('OPER_NM_PROMOTION_ITEM_REPORT');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('OPER_NM_PROMOTION_ORDER_REPORT');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('OPER_NM_VOUCHER_REPORT');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('OPER_PRODUCT_DAILY_REPORT');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('OPER_PRODUCT_PVUV_DAILY_REPORT');
    YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('PUSH_MSG_LOG');
  END TABLE_OPTIMIZATION;

  PROCEDURE PROCESSMAKETHMSC_IA(STARTPOINT IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    --STARTPOINT  NUMBER;
    -- ENDPOINT    FACT_PAGE_VIEW.ID%TYPE;
    /*
    功能说明：在原FACT_HMSC_MARKET表的基础上，细化到商品和地区
    
    作者时间：yangjin  2016-05-24
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.PROCESSMAKETHMSC_IA'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_HMSC_ITEM_AREA_MARKET'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*清空中间表*/
      DELETE FROM FACT_PV_IA_HMSC;
      DELETE FROM FACT_ORDER_IA_HMSC;
      COMMIT;
    
      /*删除指定日期的数据*/
      DELETE FACT_HMSC_ITEM_AREA_MARKET T
       WHERE T.VISIT_DATE_KEY = STARTPOINT;
      COMMIT;
    
      INSERT INTO FACT_PV_IA_HMSC
        (VISIT_DATE_KEY,
         APPLICATION_KEY,
         HMMD,
         HMPL,
         XLFLAG,
         GOODS_COMMONID,
         PV_IP_CITY,
         MCNT,
         VCNT,
         SCNT)
        SELECT /*+PARALLEL(16)*/
         F.VISIT_DATE_KEY,
         F.APPLICATION_KEY,
         F.HMMD,
         F.HMPL,
         F.XLFLAG,
         F.GOODS_COMMONID,
         YANGJIN_PKG.GET_IP_CITY(F.IP_INT) PV_IP_CITY,
         SUM(F.MCNT) MCNT,
         SUM(F.VCNT) VCNT,
         SUM(F.SCNT) SCNT
          FROM (SELECT E.VISIT_DATE_KEY,
                       E.APPLICATION_KEY,
                       E.HMMD,
                       E.HMPL,
                       E.XLFLAG,
                       E.GOODS_COMMONID,
                       E.IP_INT,
                       COUNT(DISTINCT E.MEMBER_KEY) MCNT,
                       COUNT(DISTINCT E.DEVICE_KEY) VCNT,
                       COUNT(DISTINCT E.SESSION_KEY) SCNT
                  FROM (SELECT A.VISIT_DATE_KEY,
                               DECODE(A.APPLICATION_KEY,
                                      10,
                                      'IOS',
                                      20,
                                      'ANDROID') AS APPLICATION_KEY,
                               (SELECT B.HMMD
                                  FROM DIM_HMSC B
                                 WHERE B.HMSC = A.HMSC) AS HMMD,
                               (SELECT C.HMPL
                                  FROM DIM_HMSC C
                                 WHERE C.HMSC = A.HMSC) AS HMPL,
                               CASE
                                 WHEN EXISTS
                                  (SELECT *
                                         FROM FACT_VISITOR_REGISTER D
                                        WHERE D.CREATE_DATE_KEY BETWEEN
                                              TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(STARTPOINT),
                                                                                   'yyyymmdd'),
                                                                           -1),
                                                                'yyyymmdd')) AND
                                              STARTPOINT
                                          AND D.VISTOR_KEY = A.DEVICE_KEY) THEN
                                  '新用户'
                                 ELSE
                                  '老用户'
                               END AS XLFLAG,
                               SUBSTR(A.PAGE_VALUE, 1, 6) GOODS_COMMONID,
                               A.IP_INT,
                               A.MEMBER_KEY,
                               A.DEVICE_KEY,
                               A.SESSION_KEY
                          FROM FACT_PAGE_VIEW A
                         WHERE UPPER(A.PAGE_NAME) = 'GOOD'
                           AND REGEXP_LIKE(A.PAGE_VALUE, '^[[:digit:]]+$')
                           AND A.VISIT_DATE_KEY = STARTPOINT) E
                 GROUP BY E.VISIT_DATE_KEY,
                          E.APPLICATION_KEY,
                          E.HMMD,
                          E.HMPL,
                          E.XLFLAG,
                          E.GOODS_COMMONID,
                          E.IP_INT) F
         GROUP BY F.VISIT_DATE_KEY,
                  F.APPLICATION_KEY,
                  F.HMMD,
                  F.HMPL,
                  F.XLFLAG,
                  F.GOODS_COMMONID,
                  YANGJIN_PKG.GET_IP_CITY(F.IP_INT);
      COMMIT;
    
      INSERT INTO FACT_ORDER_IA_HMSC
        (ORDER_CREATE_KEY,
         APPLICATION_KEY,
         HMMD,
         HMPL,
         XLFLAG,
         GOODS_COMMONID,
         ORDER_IP_CITY,
         ORDERRS,
         ORDERCS,
         ORDERAMOUNT,
         ORDERCGRS,
         ORDERCGCS,
         ORDERCGAMOUNT)
      
        SELECT F.ORDER_CREATE_KEY,
               F.APPLICATION_KEY,
               F.HMMD,
               F.HMPL,
               F.XLFLAG,
               F.GOODS_COMMONID,
               F.ORDER_IP_CITY,
               COUNT(DISTINCT F.CUST_NO) ORDERRS,
               COUNT(DISTINCT F.ORDER_SN) ORDERCS,
               SUM(F.ORDER_AMOUNT) AS ORDERAMOUNT,
               COUNT(DISTINCT F.CUST_CG_NO) ORDERCGRS,
               COUNT(DISTINCT F.ORDER_CG_SN) ORDERCGCS,
               SUM(F.ORDER_CG_AMOUNT) AS ORDERCGAMOUNT
          FROM (SELECT A.ADD_TIME ORDER_CREATE_KEY,
                       DECODE(C.APPLICATION_KEY, 10, 'IOS', 20, 'ANDROID') AS APPLICATION_KEY,
                       (SELECT D.HMMD FROM DIM_HMSC D WHERE D.HMSC = C.HMSC) AS HMMD,
                       (SELECT D.HMPL FROM DIM_HMSC D WHERE D.HMSC = C.HMSC) AS HMPL,
                       CASE
                         WHEN EXISTS (SELECT *
                                 FROM FACT_VISITOR_REGISTER E
                                WHERE E.CREATE_DATE_KEY BETWEEN
                                      TO_NUMBER(TO_CHAR(ADD_MONTHS(TO_DATE(TO_CHAR(STARTPOINT),
                                                                           'yyyymmdd'),
                                                                   -1),
                                                        'yyyymmdd')) AND
                                      STARTPOINT
                                  AND E.VID = C.VID) THEN
                          '新用户'
                         ELSE
                          '老用户'
                       END AS XLFLAG,
                       A.CUST_NO,
                       A.ORDER_SN,
                       A.ORDER_AMOUNT,
                       CASE
                         WHEN (A.PAYMENT_CODE = 'offline' OR
                              A.ORDER_STATE IN (20, 30, 40, 50)) THEN
                          A.CUST_NO
                       END CUST_CG_NO,
                       CASE
                         WHEN (A.PAYMENT_CODE = 'offline' OR
                              A.ORDER_STATE IN (20, 30, 40, 50)) THEN
                          A.ORDER_SN
                       END ORDER_CG_SN,
                       CASE
                         WHEN (A.PAYMENT_CODE = 'offline' OR
                              A.ORDER_STATE IN (20, 30, 40, 50)) THEN
                          A.ORDER_AMOUNT
                         ELSE
                          0
                       END ORDER_CG_AMOUNT,
                       B.GOODS_COMMONID,
                       YANGJIN_PKG.GET_IP_CITY(GET_IP_NUMBER(A.ORDER_IP)) ORDER_IP_CITY
                  FROM FACT_EC_ORDER         A,
                       FACT_EC_ORDERGOODS    B,
                       FACT_VISITOR_REGISTER C
                 WHERE A.ORDER_ID = B.ORDER_ID
                   AND A.VID = C.VID
                   AND A.ADD_TIME = STARTPOINT
                   AND A.APP_NAME IN ('KLGAndroid', 'KLGiPhone')) F
         GROUP BY F.ORDER_CREATE_KEY,
                  F.APPLICATION_KEY,
                  F.HMMD,
                  F.HMPL,
                  F.XLFLAG,
                  F.GOODS_COMMONID,
                  F.ORDER_IP_CITY;
      COMMIT;
    
      INSERT INTO FACT_HMSC_ITEM_AREA_MARKET
        (VISIT_DATE_KEY,
         APPLICATION_KEY,
         HMMD,
         HMPL,
         XLFLAG,
         ITEM_CODE,
         GOODS_NAME,
         IP_CITY,
         MCNT,
         VCNT,
         SCNT,
         ORDERRS,
         ORDERCS,
         ORDERAMOUNT,
         ORDERCGRS,
         ORDERCGCS,
         ORDERCGAMOUNT,
         INSERT_DT,
         UPDATE_DT)
        SELECT D.VISIT_DATE_KEY,
               D.APPLICATION_KEY,
               D.HMMD,
               D.HMPL,
               D.XLFLAG,
               E.ITEM_CODE,
               E.GOODS_NAME,
               D.IP_CITY,
               D.MCNT,
               D.VCNT,
               D.SCNT,
               D.ORDERRS,
               D.ORDERCS,
               D.ORDERAMOUNT,
               D.ORDERCGRS,
               D.ORDERCGCS,
               D.ORDERCGAMOUNT,
               SYSDATE,
               SYSDATE
          FROM (SELECT A.VISIT_DATE_KEY,
                       A.APPLICATION_KEY,
                       A.HMMD,
                       A.HMPL,
                       A.XLFLAG,
                       A.PV_IP_CITY IP_CITY,
                       A.GOODS_COMMONID,
                       NVL(A.MCNT, 0) AS MCNT,
                       NVL(A.VCNT, 0) AS VCNT,
                       NVL(A.SCNT, 0) AS SCNT,
                       NVL(C.ORDERRS, 0) AS ORDERRS,
                       NVL(C.ORDERCS, 0) AS ORDERCS,
                       NVL(C.ORDERAMOUNT, 0) AS ORDERAMOUNT,
                       NVL(C.ORDERCGRS, 0) AS ORDERCGRS,
                       NVL(C.ORDERCGCS, 0) AS ORDERCGCS,
                       NVL(C.ORDERCGAMOUNT, 0) AS ORDERCGAMOUNT
                  FROM (SELECT * FROM FACT_PV_IA_HMSC WHERE HMMD IS NOT NULL) A,
                       (SELECT *
                          FROM FACT_ORDER_IA_HMSC
                         WHERE HMMD IS NOT NULL) C
                 WHERE A.VISIT_DATE_KEY = C.ORDER_CREATE_KEY(+)
                   AND A.APPLICATION_KEY = C.APPLICATION_KEY(+)
                   AND A.HMMD = C.HMMD(+)
                   AND A.HMPL = C.HMPL(+)
                   AND A.XLFLAG = C.XLFLAG(+)
                   AND A.PV_IP_CITY = C.ORDER_IP_CITY(+)
                   AND A.GOODS_COMMONID = C.GOODS_COMMONID(+)
                UNION
                SELECT C.ORDER_CREATE_KEY,
                       C.APPLICATION_KEY,
                       C.HMMD,
                       C.HMPL,
                       C.XLFLAG,
                       C.ORDER_IP_CITY,
                       C.GOODS_COMMONID,
                       NVL(A.MCNT, 0) AS MCNT,
                       NVL(A.VCNT, 0) AS VCNT,
                       NVL(A.SCNT, 0) AS SCNT,
                       NVL(C.ORDERRS, 0) AS ORDERRS,
                       NVL(C.ORDERCS, 0) AS ORDERCS,
                       NVL(C.ORDERAMOUNT, 0) AS ORDERAMOUNT,
                       NVL(C.ORDERCGRS, 0) AS ORDERCGRS,
                       NVL(C.ORDERCGCS, 0) AS ORDERCGCS,
                       NVL(C.ORDERCGAMOUNT, 0) AS ORDERCGAMOUNT
                  FROM (SELECT * FROM FACT_PV_IA_HMSC WHERE HMMD IS NOT NULL) A,
                       (SELECT *
                          FROM FACT_ORDER_IA_HMSC
                         WHERE HMMD IS NOT NULL) C
                 WHERE A.VISIT_DATE_KEY(+) = C.ORDER_CREATE_KEY
                   AND A.APPLICATION_KEY(+) = C.APPLICATION_KEY
                   AND A.HMMD(+) = C.HMMD
                   AND A.HMPL(+) = C.HMPL
                   AND A.XLFLAG(+) = C.XLFLAG
                   AND A.PV_IP_CITY(+) = C.ORDER_IP_CITY
                   AND A.GOODS_COMMONID(+) = C.GOODS_COMMONID) D,
               DIM_EC_GOOD E
         WHERE D.GOODS_COMMONID = E.GOODS_COMMONID;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:STARTPOINT:' || TO_CHAR(STARTPOINT);
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
    
  END PROCESSMAKETHMSC_IA;

  PROCEDURE OPER_PRODUCT_DAILY_RPT(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：新媒体中心数据日报
    作者时间：yangjin  2016-06-13
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_PRODUCT_DAILY_RPT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_PRODUCT_DAILY_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*删除指定日期的数据*/
      DELETE OPER_PRODUCT_DAILY_REPORT T
       WHERE T.POSTING_DATE_KEY = IN_POSTING_DATE_KEY;
      COMMIT;
    
      INSERT INTO OPER_PRODUCT_DAILY_REPORT
        (ROW_ID,
         POSTING_DATE_KEY,
         SALES_SOURCE_NAME,
         SALES_SOURCE_SECOND_NAME,
         OWN_ACCOUNT,
         BRAND_NAME,
         TRAN_TYPE,
         TRAN_TYPE_NAME,
         ITEM_OR_GIFT,
         MATDLT,
         MATZLT,
         MATXLT,
         MD_PERSON,
         ITEM_CODE,
         GOODS_KEY,
         GOODS_NAME,
         TOTAL_ORDER_AMOUNT,
         NET_ORDER_AMOUNT,
         EFFECTIVE_ORDER_AMOUNT,
         CANCEL_ORDER_AMOUNT,
         REVERSE_ORDER_AMOUNT,
         REJECT_ORDER_AMOUNT,
         CANCEL_REVERSE_AMOUNT,
         CANCEL_REJECT_AMOUNT,
         TOTAL_SALES_AMOUNT,
         NET_SALES_AMOUNT,
         EFFECTIVE_SALES_AMOUNT,
         TOTAL_ORDER_MEMBER_COUNT,
         NET_ORDER_MEMBER_COUNT,
         EFFECTIVE_ORDER_MEMBER_COUNT,
         CANCEL_ORDER_MEMBER_COUNT,
         REVERSE_MEMBER_COUNT,
         REJECT_MEMBER_COUNT,
         CANCEL_REVERSE_MEMBER_COUNT,
         CANCEL_REJECT_MEMBER_COUNT,
         TOTAL_ORDER_COUNT,
         NET_ORDER_COUNT,
         EFFECTIVE_ORDER_COUNT,
         CANCEL_ORDER_COUNT,
         REVERSE_COUNT,
         REJECT_COUNT,
         CANCEL_REVERSE_COUNT,
         CANCEL_REJECT_COUNT,
         GROSS_PROFIT_AMOUNT,
         NET_PROFIT_AMOUNT,
         EFFECTIVE_PROFIT_AMOUNT,
         GROSS_PROFIT_RATE,
         NET_PROFIT_RATE,
         EFFECTIVE_PROFIT_RATE,
         TOTAL_ORDER_QTY,
         NET_ORDER_QTY,
         EFFECTIVE_ORDER_QTY,
         CANCEL_ORDER_QTY,
         REVERSE_QTY,
         REJECT_QTY,
         CANCEL_REVERSE_QTY,
         CANCEL_REJECT_QTY,
         NET_ORDER_CUST_PRICE,
         EFFECTIVE_ORDER_CUST_PRICE,
         NET_ORDER_UNIT_PRICE,
         EFFECTIVE_ORDER_UNIT_PRICE,
         TOTAL_PURCHASE_AMOUNT,
         NET_PURCHASE_AMOUNT,
         EFFECTIVE_PURCHASE_AMOUNT,
         PROFIT_AMOUNT,
         COUPONS_AMOUNT,
         FREIGHT_AMOUNT,
         PRODUCT_AVG_PRICE,
         REJECT_AMOUNT,
         LIVE_OR_REPLAY)
        SELECT OPER_PRODUCT_DAILY_REPORT_SEQ.NEXTVAL,
               FO.POSTING_DATE_KEY /*过账日期key*/,
               DS.SALES_SOURCE_NAME /*销售一级组织名称*/,
               DS.SALES_SOURCE_SECOND_NAME /*销售二级组织名称*/,
               DG.OWN_ACCOUNT /*是否自营*/,
               DG.BRAND_NAME /*品牌*/,
               FO.TRAN_TYPE /*交易类型*/,
               FO.TRAN_TYPE_NAME /*交易类型说明*/,
               FO.ITEM_OR_GIFT /*主赠品*/,
               DG.MATDLT /*物料大类*/,
               DG.MATZLT /*物料中类*/,
               DG.MATXLT /*物料小类*/,
               FO.MD_PERSON /*MD工号*/,
               DG.ITEM_CODE /*商品短编码*/,
               FO.GOODS_KEY /*商品长编码*/,
               DG.GOODS_NAME /*商品名称*/,
               FO.TOTAL_ORDER_AMOUNT /*总订购金额*/,
               FO.NET_ORDER_AMOUNT /*净订购金额*/,
               FO.EFFECTIVE_ORDER_AMOUNT /*有效订购金额*/,
               FO.CANCEL_ORDER_AMOUNT /*取消订购金额*/,
               FO.REVERSE_ORDER_AMOUNT /*退货订购金额*/,
               FO.REJECT_ORDER_AMOUNT /*拒收订购金额*/,
               FO.CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
               FO.CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
               FO.TOTAL_SALES_AMOUNT /*总售价金额*/,
               FO.NET_SALES_AMOUNT /*净售价金额*/,
               FO.EFFECTIVE_SALES_AMOUNT /*有效售价金额*/,
               FO.TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
               FO.NET_ORDER_MEMBER_COUNT /*净订购人数*/,
               FO.EFFECTIVE_ORDER_MEMBER_COUNT /*有效订购人数*/,
               FO.CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
               FO.REVERSE_MEMBER_COUNT /*退货订购人数*/,
               FO.REJECT_MEMBER_COUNT /*拒收订购人数*/,
               FO.CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
               FO.CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
               FO.TOTAL_ORDER_COUNT /*总订购单数*/,
               FO.NET_ORDER_COUNT /*净订购单数*/,
               FO.EFFECTIVE_ORDER_COUNT /*有效订购单数*/,
               FO.CANCEL_ORDER_COUNT /*取消订购单数*/,
               FO.REVERSE_COUNT /*退货订购单数*/,
               FO.REJECT_COUNT /*拒收订购单数*/,
               FO.CANCEL_REVERSE_COUNT /*退货取消订购件数*/,
               FO.CANCEL_REJECT_COUNT /*拒收取消订购件数*/,
               FO.GROSS_PROFIT_AMOUNT /*还原后总毛利额*/,
               FO.NET_PROFIT_AMOUNT /*还原后净毛利额*/,
               FO.EFFECTIVE_PROFIT_AMOUNT /*还原后有效毛利额*/,
               FO.GROSS_PROFIT_RATE /*还原后总毛利率*/,
               FO.NET_PROFIT_RATE /*还原后净毛利率*/,
               FO.EFFECTIVE_PROFIT_RATE /*还原后有效毛利率*/,
               FO.TOTAL_ORDER_QTY /*总订购数量*/,
               FO.NET_ORDER_QTY /*净订购数量*/,
               FO.EFFECTIVE_ORDER_QTY /*有效订购数量*/,
               FO.CANCEL_ORDER_QTY /*取消订购数量*/,
               FO.REVERSE_QTY /*退货订购数量*/,
               FO.REJECT_QTY /*拒收订购数量*/,
               FO.CANCEL_REVERSE_QTY /*退货取消订购数量*/,
               FO.CANCEL_REJECT_QTY /*拒收取消订购数量*/,
               FO.NET_ORDER_CUST_PRICE /*净订购客单价*/,
               FO.EFFECTIVE_ORDER_CUST_PRICE /*有效订购客单价*/,
               FO.NET_ORDER_UNIT_PRICE /*净订购件单价*/,
               FO.EFFECTIVE_ORDER_UNIT_PRICE /*有效订购件单价*/,
               FO.TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
               FO.NET_PURCHASE_AMOUNT /*净订购成本*/,
               FO.EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本*/,
               FO.PROFIT_AMOUNT /*折扣金额*/,
               FO.COUPONS_AMOUNT /*优惠券金额*/,
               FO.FREIGHT_AMOUNT /*运费*/,
               FO.PRODUCT_AVG_PRICE /*商品平均售价*/,
               FO.REJECT_AMOUNT /*拒退金额*/,
               FO.LIVE_OR_REPLAY /*直播重播*/
          FROM (SELECT OD2.GOODS_KEY /**/,
                       OD2.GOODS_COMMON_KEY /**/,
                       OD2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                       OD2.ITEM_OR_GIFT /*主赠品*/,
                       OD2.TRAN_TYPE /*交易类型*/,
                       DECODE(OD2.TRAN_TYPE,
                              'TAN',
                              '主品',
                              'REN',
                              '主品退货') TRAN_TYPE_NAME /*交易类型说明*/,
                       OD2.MD_PERSON /*MD工号*/,
                       OD2.POSTING_DATE_KEY /*过账日期key*/,
                       OD2.LIVE_OR_REPLAY /*是否播出*/,
                       OD2.TOTAL_ORDER_AMOUNT /*总订购金额*/,
                       OD2.NET_ORDER_AMOUNT /*净订购金额*/,
                       OD2.EFFECTIVE_ORDER_AMOUNT /*有效订购金额*/,
                       OD2.CANCEL_ORDER_AMOUNT /*取消订购金额*/,
                       OD2.REVERSE_ORDER_AMOUNT /*退货订购金额*/,
                       OD2.REJECT_ORDER_AMOUNT /*拒收订购金额*/,
                       OD2.CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
                       OD2.CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
                       OD2.TOTAL_SALES_AMOUNT /*总售价金额*/,
                       OD2.NET_SALES_AMOUNT /*净售价金额*/,
                       OD2.EFFECTIVE_SALES_AMOUNT /*有效售价金额*/,
                       OD2.TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
                       OD2.NET_ORDER_MEMBER_COUNT /*净订购人数*/,
                       OD2.EFFECTIVE_ORDER_MEMBER_COUNT /*有效订购人数*/,
                       OD2.CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
                       OD2.REVERSE_MEMBER_COUNT /*退货订购人数*/,
                       OD2.REJECT_MEMBER_COUNT /*拒收订购人数*/,
                       OD2.CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
                       OD2.CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
                       OD2.TOTAL_ORDER_COUNT /*总订购单数*/,
                       OD2.NET_ORDER_COUNT /*净订购单数*/,
                       OD2.EFFECTIVE_ORDER_COUNT /*有效订购单数*/,
                       OD2.CANCEL_ORDER_COUNT /*取消订购单数*/,
                       OD2.REVERSE_COUNT /*退货订购单数*/,
                       OD2.REJECT_COUNT /*拒收订购单数*/,
                       OD2.CANCEL_REVERSE_COUNT /*退货取消订购件数*/,
                       OD2.CANCEL_REJECT_COUNT /*拒收取消订购件数*/,
                       OD2.TOTAL_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                       OD2.TOTAL_PURCHASE_AMOUNT GROSS_PROFIT_AMOUNT /*还原后总毛利额*/,
                       OD2.NET_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                       OD2.NET_PURCHASE_AMOUNT NET_PROFIT_AMOUNT /*还原后净毛利额*/,
                       OD2.EFFECTIVE_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                       OD2.EFFECTIVE_PURCHASE_AMOUNT EFFECTIVE_PROFIT_AMOUNT /*还原后有效毛利额*/,
                       DECODE(OD2.TOTAL_ORDER_AMOUNT,
                              0,
                              0,
                              (OD2.TOTAL_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                              OD2.TOTAL_PURCHASE_AMOUNT) /
                              OD2.TOTAL_ORDER_AMOUNT) GROSS_PROFIT_RATE /*还原后总毛利率*/,
                       DECODE(OD2.NET_ORDER_AMOUNT,
                              0,
                              0,
                              (OD2.NET_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                              OD2.NET_PURCHASE_AMOUNT) / OD2.NET_ORDER_AMOUNT) NET_PROFIT_RATE /*还原后净毛利率*/,
                       DECODE(OD2.EFFECTIVE_ORDER_AMOUNT,
                              0,
                              0,
                              (OD2.EFFECTIVE_ORDER_AMOUNT + OD2.PROFIT_AMOUNT -
                              OD2.EFFECTIVE_PURCHASE_AMOUNT) /
                              OD2.EFFECTIVE_ORDER_AMOUNT) EFFECTIVE_PROFIT_RATE /*还原后有效毛利率*/,
                       OD2.TOTAL_ORDER_QTY /*总订购数量*/,
                       OD2.NET_ORDER_QTY /*净订购数量*/,
                       OD2.EFFECTIVE_ORDER_QTY /*有效订购数量*/,
                       OD2.CANCEL_ORDER_QTY /*取消订购数量*/,
                       OD2.REVERSE_QTY /*退货订购数量*/,
                       OD2.REJECT_QTY /*拒收订购数量*/,
                       OD2.CANCEL_REVERSE_QTY /*退货取消订购数量*/,
                       OD2.CANCEL_REJECT_QTY /*拒收取消订购数量*/,
                       OD2.NET_ORDER_CUST_PRICE /*净订购客单价*/,
                       OD2.EFFECTIVE_ORDER_CUST_PRICE /*有效订购客单价*/,
                       OD2.NET_ORDER_UNIT_PRICE /*净订购件单价*/,
                       OD2.EFFECTIVE_ORDER_UNIT_PRICE /*有效订购件单价*/,
                       OD2.TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
                       OD2.NET_PURCHASE_AMOUNT /*净订购成本*/,
                       OD2.EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本*/,
                       OD2.PROFIT_AMOUNT /*折扣金额*/,
                       OD2.COUPONS_AMOUNT /*优惠券金额*/,
                       OD2.FREIGHT_AMOUNT /*运费*/,
                       OD2.PRODUCT_AVG_PRICE /*商品平均售价*/,
                       OD2.REJECT_AMOUNT /*拒退金额*/
                  FROM (SELECT OD1.GOODS_KEY /**/,
                               OD1.GOODS_COMMON_KEY /**/,
                               OD1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                               DECODE(OD1.TRAN_TYPE, 0, '主品', 1, '赠品') ITEM_OR_GIFT /*主赠品*/,
                               DECODE(OD1.CANCEL_STATE, 0, 'TAN', 1, 'REN') TRAN_TYPE /*交易类型*/,
                               OD1.MD_PERSON /*MD工号*/,
                               OD1.POSTING_DATE_KEY /*过账日期key*/,
                               DECODE(OD1.LIVE_OR_REPLAY,
                                      '10',
                                      '直播',
                                      '01',
                                      '重播',
                                      '未分配') LIVE_OR_REPLAY /*是否播出*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_ORDER_AMOUNT,
                                          1,
                                          0)) TOTAL_ORDER_AMOUNT /*总订购金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_ORDER_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_ORDER_AMOUNT))) NET_ORDER_AMOUNT /*净订购金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_ORDER_AMOUNT,
                                          1,
                                          -ABS(OD1.EFFECTIVE_ORDER_AMOUNT))) EFFECTIVE_ORDER_AMOUNT /*有效订购金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          0,
                                          1,
                                          OD1.TOTAL_ORDER_AMOUNT)) CANCEL_ORDER_AMOUNT /*取消订购金额*/,
                               0 REVERSE_ORDER_AMOUNT /*退货订购金额*/,
                               0 REJECT_ORDER_AMOUNT /*拒收订购金额*/,
                               0 CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
                               0 CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_SALES_AMOUNT,
                                          1,
                                          0)) TOTAL_SALES_AMOUNT /*总售价金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_SALES_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_SALES_AMOUNT))) NET_SALES_AMOUNT /*净售价金额*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_SALES_AMOUNT,
                                          1,
                                          -ABS(OD1.EFFECTIVE_SALES_AMOUNT))) EFFECTIVE_SALES_AMOUNT /*有效售价金额*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.MEMBER_KEY),
                                      1,
                                      0) TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.MEMBER_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.MEMBER_KEY)) NET_ORDER_MEMBER_COUNT /*净订购人数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.MEMBER_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.MEMBER_KEY)) EFFECTIVE_ORDER_MEMBER_COUNT /*有效订购人数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      0,
                                      1,
                                      COUNT(DISTINCT OD1.MEMBER_KEY)) CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
                               0 REVERSE_MEMBER_COUNT /*退货订购人数*/,
                               0 REJECT_MEMBER_COUNT /*拒收订购人数*/,
                               0 CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
                               0 CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY),
                                      1,
                                      0) TOTAL_ORDER_COUNT /*总订购单数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.ORDER_H_KEY)) NET_ORDER_COUNT /*净订购单数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY),
                                      1,
                                      -COUNT(DISTINCT OD1.ORDER_H_KEY)) EFFECTIVE_ORDER_COUNT /*有效订购单数*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      0,
                                      1,
                                      COUNT(DISTINCT OD1.ORDER_H_KEY)) CANCEL_ORDER_COUNT /*取消订购单数*/,
                               0 REVERSE_COUNT /*退货订购单数*/,
                               0 REJECT_COUNT /*拒收订购单数*/,
                               0 CANCEL_REVERSE_COUNT /*退货取消订购件数*/,
                               0 CANCEL_REJECT_COUNT /*拒收取消订购件数*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_ORDER_QTY,
                                          1,
                                          0)) TOTAL_ORDER_QTY /*总订购数量*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_ORDER_QTY,
                                          1,
                                          -ABS(OD1.NET_ORDER_QTY))) NET_ORDER_QTY /*净订购数量*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_ORDER_QTY,
                                          1,
                                          -ABS(OD1.EFFECTIVE_ORDER_QTY))) EFFECTIVE_ORDER_QTY /*有效订购数量*/,
                               DECODE(OD1.CANCEL_STATE,
                                      0,
                                      0,
                                      1,
                                      COUNT(DISTINCT OD1.TOTAL_ORDER_QTY)) CANCEL_ORDER_QTY /*取消订购数量*/,
                               0 REVERSE_QTY /*退货订购数量*/,
                               0 REJECT_QTY /*拒收订购数量*/,
                               0 CANCEL_REVERSE_QTY /*退货取消订购数量*/,
                               0 CANCEL_REJECT_QTY /*拒收取消订购数量*/,
                               SUM(OD1.NET_ORDER_AMOUNT) /
                               COUNT(DISTINCT OD1.MEMBER_KEY) NET_ORDER_CUST_PRICE /*净订购客单价*/,
                               SUM(OD1.EFFECTIVE_ORDER_AMOUNT) /
                               COUNT(DISTINCT OD1.MEMBER_KEY) EFFECTIVE_ORDER_CUST_PRICE /*有效订购客单价*/,
                               SUM(OD1.NET_ORDER_AMOUNT) /
                               SUM(OD1.NET_ORDER_QTY) NET_ORDER_UNIT_PRICE /*净订购件单价*/,
                               SUM(OD1.EFFECTIVE_ORDER_AMOUNT) /
                               SUM(OD1.EFFECTIVE_ORDER_QTY) EFFECTIVE_ORDER_UNIT_PRICE /*有效订购件单价*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.TOTAL_PURCHASE_AMOUNT,
                                          1,
                                          0)) TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.NET_PURCHASE_AMOUNT,
                                          1,
                                          -ABS(OD1.NET_PURCHASE_AMOUNT))) NET_PURCHASE_AMOUNT /*净订购成本*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.EFFECTIVE_PURCHASE_AMOUNT,
                                          1,
                                          -ABS(OD1.EFFECTIVE_PURCHASE_AMOUNT))) EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本*/,
                               SUM(DECODE(OD1.CANCEL_STATE,
                                          0,
                                          OD1.PROFIT_AMOUNT,
                                          1,
                                          -ABS(OD1.PROFIT_AMOUNT))) PROFIT_AMOUNT /*折扣金额*/,
                               SUM(OD1.COUPONS_AMOUNT) COUPONS_AMOUNT /*优惠券金额*/,
                               SUM(OD1.FREIGHT_AMOUNT) FREIGHT_AMOUNT /*运费*/,
                               SUM(OD1.TOTAL_SALES_AMOUNT) /
                               SUM(OD1.TOTAL_ORDER_QTY) PRODUCT_AVG_PRICE /*商品平均售价*/,
                               0 REJECT_AMOUNT /*拒退金额*/
                          FROM (SELECT OD.ORDER_KEY /*订单权责制*/,
                                       OD.ORDER_H_KEY /*订单发生制*/,
                                       OD.ORDER_DESC /*订购状态*/,
                                       OD.GOODS_KEY /*商品*/,
                                       OD.GOODS_COMMON_KEY /*商品短编码*/,
                                       OD.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                       OD.TRAN_TYPE /*是否赠品标志*/,
                                       OD.TRAN_DESC /*交易类型*/,
                                       OD.MD_PERSON /*MD工号*/,
                                       OD.POSTING_DATE_KEY /*过账日期key*/,
                                       TO_CHAR(OD.LIVE_STATE) ||
                                       TO_CHAR(OD.REPLAY_STATE) LIVE_OR_REPLAY /*直播重播*/,
                                       OD.ORDER_STATE /*订单状态*/,
                                       OD.CANCEL_STATE /*取消状态*/,
                                       OD.MEMBER_KEY /*会员key*/,
                                       OD.NUMS TOTAL_ORDER_QTY /*总订购数量*/,
                                       OD.NUMS NET_ORDER_QTY /*净订购数量*/,
                                       OD.NUMS EFFECTIVE_ORDER_QTY /*有效订购数量*/,
                                       OD.ORDER_AMOUNT TOTAL_ORDER_AMOUNT /*总订单金额*/,
                                       OD.ORDER_AMOUNT NET_ORDER_AMOUNT /*净订购金额*/,
                                       OD.ORDER_AMOUNT EFFECTIVE_ORDER_AMOUNT /*有效订购金额*/,
                                       OD.SALES_AMOUNT TOTAL_SALES_AMOUNT /*总售价金额*/,
                                       OD.SALES_AMOUNT NET_SALES_AMOUNT /*净订购金额*/,
                                       OD.SALES_AMOUNT EFFECTIVE_SALES_AMOUNT /*有效订购金额*/,
                                       OD.UNIT_PRICE /*单个商品售价*/,
                                       OD.COST_PRICE /*商品单件成本*/,
                                       OD.FREIGHT_AMOUNT /*运费*/,
                                       OD.COUPONS_PRICE COUPONS_AMOUNT /*优惠券金额*/,
                                       OD.PURCHASE_AMOUNT TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
                                       OD.PURCHASE_AMOUNT NET_PURCHASE_AMOUNT /*净订购成本*/,
                                       OD.PURCHASE_AMOUNT EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本*/,
                                       OD.PROFIT_AMOUNT /*折扣金额*/
                                  FROM (
                                        /*取消的订单，按过账日期POSTING_DATE_KEY记正向订单。
                                        2017-06-14 yangjin*/
                                        SELECT ODU1.ORDER_KEY /*订单权责制*/,
                                                ODU1.ORDER_H_KEY /*订单发生制*/,
                                                ODU1.ORDER_DESC /*订购状态*/,
                                                ODU1.GOODS_KEY /*商品*/,
                                                ODU1.GOODS_COMMON_KEY /*商品短编码*/,
                                                ODU1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                                ODU1.TRAN_TYPE /*是否赠品标志*/,
                                                ODU1.TRAN_DESC /*交易类型*/,
                                                ODU1.MD_PERSON /*MD工号*/,
                                                ODU1.POSTING_DATE_KEY /*过账日期key*/,
                                                ODU1.LIVE_STATE /*是否直播*/,
                                                ODU1.REPLAY_STATE /*是否重播*/,
                                                ODU1.ORDER_STATE /*订单状态*/,
                                                CASE
                                                  WHEN ODU1.CANCEL_STATE = 1 AND
                                                       ODU1.POSTING_DATE_KEY <=
                                                       ODU1.UPDATE_TIME THEN
                                                   0
                                                  ELSE
                                                   ODU1.CANCEL_STATE
                                                END CANCEL_STATE /*取消状态*/,
                                                ODU1.MEMBER_KEY /*会员key*/,
                                                ODU1.NUMS,
                                                ODU1.ORDER_AMOUNT,
                                                ODU1.SALES_AMOUNT,
                                                ODU1.UNIT_PRICE /*单个商品售价*/,
                                                ODU1.COST_PRICE /*商品单件成本*/,
                                                ODU1.FREIGHT_AMOUNT /*运费*/,
                                                ODU1.COUPONS_PRICE /*优惠券金额*/,
                                                ODU1.PURCHASE_AMOUNT /*订购成本*/,
                                                ODU1.PROFIT_AMOUNT /*折扣金额*/
                                          FROM FACT_GOODS_SALES ODU1
                                        UNION ALL
                                        /*取消的订单，按更新日期UPDATE_TIME记逆向订单（虚拟记录）。
                                        2017-06-14 yangjin*/
                                        SELECT ODU2.ORDER_KEY /*订单权责制*/,
                                                ODU2.ORDER_H_KEY /*订单发生制*/,
                                                ODU2.ORDER_DESC /*订购状态*/,
                                                ODU2.GOODS_KEY /*商品*/,
                                                ODU2.GOODS_COMMON_KEY /*商品短编码*/,
                                                ODU2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                                ODU2.TRAN_TYPE /*是否赠品标志*/,
                                                ODU2.TRAN_DESC /*交易类型*/,
                                                ODU2.MD_PERSON /*MD工号*/,
                                                ODU2.UPDATE_TIME POSTING_DATE_KEY /*过账日期key*/,
                                                ODU2.LIVE_STATE /*是否直播*/,
                                                ODU2.REPLAY_STATE /*是否重播*/,
                                                ODU2.ORDER_STATE /*订单状态*/,
                                                ODU2.CANCEL_STATE /*取消状态*/,
                                                ODU2.MEMBER_KEY /*会员key*/,
                                                ODU2.NUMS,
                                                ODU2.ORDER_AMOUNT,
                                                ODU2.SALES_AMOUNT,
                                                ODU2.UNIT_PRICE /*单个商品售价*/,
                                                ODU2.COST_PRICE /*商品单件成本*/,
                                                ODU2.FREIGHT_AMOUNT /*运费*/,
                                                ODU2.COUPONS_PRICE /*优惠券金额*/,
                                                ODU2.PURCHASE_AMOUNT,
                                                ODU2.PROFIT_AMOUNT /*折扣金额*/
                                          FROM FACT_GOODS_SALES ODU2
                                         WHERE ODU2.CANCEL_STATE = 1
                                           AND ODU2.CANCEL_BEFORE_STATE = 1 /*发货前取消的订单才虚拟出记录*/
                                           AND ODU2.POSTING_DATE_KEY <=
                                               ODU2.UPDATE_TIME
                                        
                                        ) OD
                                 WHERE OD.POSTING_DATE_KEY =
                                       IN_POSTING_DATE_KEY
                                   AND OD.TRAN_TYPE = 0 /*只显示主品*/
                                ) OD1
                         GROUP BY OD1.GOODS_KEY,
                                  OD1.GOODS_COMMON_KEY,
                                  OD1.SALES_SOURCE_SECOND_KEY,
                                  DECODE(OD1.TRAN_TYPE, 0, '主品', 1, '赠品'),
                                  DECODE(OD1.CANCEL_STATE, 0, 'TAN', 1, 'REN'),
                                  OD1.MD_PERSON,
                                  OD1.POSTING_DATE_KEY,
                                  DECODE(OD1.LIVE_OR_REPLAY,
                                         '10',
                                         '直播',
                                         '01',
                                         '重播',
                                         '未分配'),
                                  OD1.CANCEL_STATE) OD2
                UNION ALL
                --*************************************************************************************
                --REVERSE
                --*************************************************************************************
                SELECT RD2.GOODS_KEY,
                       RD2.GOODS_COMMON_KEY,
                       RD2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                       '主品' ITEM_OR_GIFT /*主赠品*/,
                       RD2.TRAN_TYPE /*交易类型*/,
                       DECODE(RD2.TRAN_TYPE,
                              'TAN',
                              '主品',
                              'REN',
                              '主品退货') TRAN_TYPE_NAME /*交易类型说明*/,
                       RD2.MD_PERSON /*MD员工号*/,
                       RD2.POSTING_DATE_KEY /*过账日期*/,
                       RD2.LIVE_OR_REPLAY /*直重播*/,
                       RD2.TOTAL_ORDER_AMOUNT /*总订购金额*/,
                       RD2.NET_ORDER_AMOUNT /*净订购金额*/,
                       -RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                       RD2.CANCEL_REVERSE_AMOUNT + RD2.CANCEL_REJECT_AMOUNT EFFECTIVE_ORDER_AMOUNT /*有效订购金额= -退货订购金额-拒收订购金额+退货取消订购金额+拒收取消订购金额*/,
                       RD2.CANCEL_ORDER_AMOUNT /*取消订购金额*/,
                       RD2.REVERSE_ORDER_AMOUNT /*退货订购金额*/,
                       RD2.REJECT_ORDER_AMOUNT /*拒收订购金额*/,
                       RD2.CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
                       RD2.CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
                       RD2.TOTAL_SALES_AMOUNT /*总售价金额*/,
                       RD2.NET_SALES_AMOUNT /*净售价金额*/,
                       -RD2.REVERSE_SALES_AMOUNT - RD2.REJECT_SALES_AMOUNT +
                       RD2.CANCEL_REVERSE_SALES_AMOUNT +
                       RD2.CANCEL_REJECT_SALES_AMOUNT EFFECTIVE_SALES_AMOUNT /*有效售价金额= -退货售价金额-拒收售价金额+退货取消售价金额+拒收取消售价金额*/,
                       RD2.TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
                       RD2.NET_ORDER_MEMBER_COUNT /*净订购人数*/,
                       -RD2.REVERSE_MEMBER_COUNT - RD2.REJECT_MEMBER_COUNT +
                       RD2.CANCEL_REVERSE_MEMBER_COUNT +
                       RD2.CANCEL_REJECT_MEMBER_COUNT EFFECTIVE_ORDER_MEMBER_COUNT /*有效订购人数=-退货订购人数-拒收订购人数+退货取消订购人数+拒收取消订购人数*/,
                       RD2.CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
                       RD2.REVERSE_MEMBER_COUNT /*退货订购人数*/,
                       RD2.REJECT_MEMBER_COUNT /*拒收订购人数*/,
                       RD2.CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
                       RD2.CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
                       RD2.TOTAL_ORDER_COUNT /*总订购单数*/,
                       RD2.NET_ORDER_COUNT /*净订购单数*/,
                       -RD2.REVERSE_COUNT - RD2.REJECT_COUNT +
                       RD2.CANCEL_REVERSE_COUNT + RD2.CANCEL_REJECT_COUNT EFFECTIVE_ORDER_COUNT /*有效订购单数*/,
                       RD2.CANCEL_ORDER_COUNT /*取消订购单数*/,
                       RD2.REVERSE_COUNT /*退货订购单数*/,
                       RD2.REJECT_COUNT /*拒收订购单数*/,
                       RD2.CANCEL_REVERSE_COUNT /*退货取消订购单数*/,
                       RD2.CANCEL_REJECT_COUNT /*拒收取消订购单数*/,
                       RD2.GROSS_PROFIT_AMOUNT /*还原后总毛利额*/,
                       RD2.NET_PROFIT_AMOUNT /*还原后净毛利额*/,
                       (-RD2.REVERSE_SALES_AMOUNT - RD2.REJECT_SALES_AMOUNT +
                       RD2.CANCEL_REVERSE_SALES_AMOUNT +
                       RD2.CANCEL_REJECT_SALES_AMOUNT) -
                       (-RD2.REVERSE_PURCHASE_AMOUNT -
                       RD2.REJECT_PURCHASE_AMOUNT +
                       RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
                       RD2.CANCEL_REJECT_PURCHASE_AMOUNT) EFFECTIVE_PROFIT_AMOUNT /*还原后有效毛利额*/,
                       RD2.GROSS_PROFIT_RATE /*还原后总毛利率*/,
                       RD2.NET_PROFIT_RATE /*还原后净毛利率*/,
                       DECODE(-RD2.REVERSE_ORDER_AMOUNT -
                              RD2.REJECT_ORDER_AMOUNT +
                              RD2.CANCEL_REVERSE_AMOUNT +
                              RD2.CANCEL_REJECT_AMOUNT,
                              0,
                              0,
                              ((-RD2.REVERSE_SALES_AMOUNT -
                              RD2.REJECT_SALES_AMOUNT +
                              RD2.CANCEL_REVERSE_SALES_AMOUNT +
                              RD2.CANCEL_REJECT_SALES_AMOUNT) -
                              (-RD2.REVERSE_PURCHASE_AMOUNT -
                              RD2.REJECT_PURCHASE_AMOUNT +
                              RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
                              RD2.CANCEL_REJECT_PURCHASE_AMOUNT)) /
                              (-RD2.REVERSE_ORDER_AMOUNT -
                              RD2.REJECT_ORDER_AMOUNT +
                              RD2.CANCEL_REVERSE_AMOUNT +
                              RD2.CANCEL_REJECT_AMOUNT)) EFFECTIVE_PROFIT_RATE /*还原后有效毛利率*/,
                       RD2.TOTAL_ORDER_QTY /*总订购数量*/,
                       RD2.NET_ORDER_QTY /*净订购数量*/,
                       -RD2.REVERSE_QTY - RD2.REJECT_QTY +
                       RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY EFFECTIVE_ORDER_QTY /*有效订购数量= -退货订购数量-拒收订购数量+退货取消订购数量+拒收取消订购数量*/,
                       RD2.CANCEL_ORDER_QTY /*取消订购数量*/,
                       RD2.REVERSE_QTY /*退货订购数量*/,
                       RD2.REJECT_QTY /*拒收订购数量*/,
                       RD2.CANCEL_REVERSE_QTY /*退货取消订购数量*/,
                       RD2.CANCEL_REJECT_QTY /*拒收取消订购数量*/,
                       RD2.NET_ORDER_CUST_PRICE /*净订购客单价*/,
                       DECODE(-RD2.REVERSE_MEMBER_COUNT -
                              RD2.REJECT_MEMBER_COUNT +
                              RD2.CANCEL_REVERSE_MEMBER_COUNT +
                              RD2.CANCEL_REJECT_MEMBER_COUNT,
                              0,
                              0,
                              (-RD2.REVERSE_ORDER_AMOUNT -
                              RD2.REJECT_ORDER_AMOUNT +
                              RD2.CANCEL_REVERSE_AMOUNT +
                              RD2.CANCEL_REJECT_AMOUNT) /
                              (-RD2.REVERSE_MEMBER_COUNT -
                              RD2.REJECT_MEMBER_COUNT +
                              RD2.CANCEL_REVERSE_MEMBER_COUNT +
                              RD2.CANCEL_REJECT_MEMBER_COUNT)) EFFECTIVE_ORDER_CUST_PRICE /*有效订购客单价*/,
                       RD2.NET_ORDER_UNIT_PRICE /*净订购件单价*/,
                       DECODE(-RD2.REVERSE_QTY - RD2.REJECT_QTY +
                              RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY,
                              0,
                              0,
                              (-RD2.REVERSE_ORDER_AMOUNT -
                              RD2.REJECT_ORDER_AMOUNT +
                              RD2.CANCEL_REVERSE_AMOUNT +
                              RD2.CANCEL_REJECT_AMOUNT) /
                              (-RD2.REVERSE_QTY - RD2.REJECT_QTY +
                              RD2.CANCEL_REVERSE_QTY + RD2.CANCEL_REJECT_QTY)) EFFECTIVE_ORDER_UNIT_PRICE /*有效订购件单价*/,
                       0 TOTAL_PURCHASE_AMOUNT /*总订购成本*/,
                       0 NET_PURCHASE_AMOUNT /*净订购成本*/,
                       -RD2.REVERSE_PURCHASE_AMOUNT -
                       RD2.REJECT_PURCHASE_AMOUNT +
                       RD2.CANCEL_REVERSE_PURCHASE_AMOUNT +
                       RD2.CANCEL_REJECT_PURCHASE_AMOUNT EFFECTIVE_PURCHASE_AMOUNT /*有效订购成本=-退货订购成本-拒收订购成本+退货取消订购成本+拒收取消订购成本*/,
                       RD2.PROFIT_AMOUNT PROFIT_AMOUNT /*折扣金额*/,
                       RD2.COUPONS_AMOUNT COUPONS_AMOUNT /*优惠券金额*/,
                       RD2.FREIGHT_AMOUNT FREIGHT_AMOUNT /*运费*/,
                       0 PRODUCT_AVG_PRICE /*商品平均售价*/,
                       - (-RD2.REVERSE_ORDER_AMOUNT - RD2.REJECT_ORDER_AMOUNT +
                         RD2.CANCEL_REVERSE_AMOUNT +
                         RD2.CANCEL_REJECT_AMOUNT) REJECT_AMOUNT /*拒退金额*/
                  FROM (SELECT RD1.GOODS_KEY,
                               RD1.GOODS_COMMON_KEY,
                               RD1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                               RD1.TRAN_DESC TRAN_TYPE /*交易类型*/,
                               RD1.MD_PERSON /*MD员工号*/,
                               RD1.POSTING_DATE_KEY /*过账日期*/,
                               DECODE(RD1.LIVE_OR_REPLAY,
                                      '10',
                                      '直播',
                                      '01',
                                      '重播',
                                      '未分配') LIVE_OR_REPLAY,
                               0 TOTAL_ORDER_AMOUNT /*总订购金额*/,
                               0 NET_ORDER_AMOUNT /*净订购金额*/,
                               0 CANCEL_ORDER_AMOUNT /*取消订购金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.ORDER_AMOUNT,
                                                 30,
                                                 RD1.ORDER_AMOUNT,
                                                 20,
                                                 0),
                                          0)) REVERSE_ORDER_AMOUNT /*退货订购金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.ORDER_AMOUNT,
                                                 0),
                                          0)) REJECT_ORDER_AMOUNT /*拒收订购金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.ORDER_AMOUNT,
                                                 30,
                                                 RD1.ORDER_AMOUNT,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_AMOUNT /*退货取消订购金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.ORDER_AMOUNT,
                                                 0),
                                          0)) CANCEL_REJECT_AMOUNT /*拒收取消订购金额*/,
                               0 TOTAL_SALES_AMOUNT /*总售价金额*/,
                               0 NET_SALES_AMOUNT /*净售价金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.SALES_AMOUNT,
                                                 30,
                                                 RD1.SALES_AMOUNT,
                                                 20,
                                                 0),
                                          0)) REVERSE_SALES_AMOUNT /*退货售价金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.SALES_AMOUNT,
                                                 0),
                                          0)) REJECT_SALES_AMOUNT /*拒收售价金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.SALES_AMOUNT,
                                                 30,
                                                 RD1.SALES_AMOUNT,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_SALES_AMOUNT /*退货取消售价金额*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.SALES_AMOUNT,
                                                 0),
                                          0)) CANCEL_REJECT_SALES_AMOUNT /*拒收取消售价金额*/,
                               0 TOTAL_ORDER_MEMBER_COUNT /*总订购人数*/,
                               0 NET_ORDER_MEMBER_COUNT /*净订购人数*/,
                               0 CANCEL_ORDER_MEMBER_COUNT /*取消订购人数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.MEMBER_KEY,
                                                   30,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) REVERSE_MEMBER_COUNT /*退货订购人数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) REJECT_MEMBER_COUNT /*拒收订购人数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.MEMBER_KEY,
                                                   30,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) CANCEL_REVERSE_MEMBER_COUNT /*退货取消订购人数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.MEMBER_KEY,
                                                   NULL),
                                            0)) CANCEL_REJECT_MEMBER_COUNT /*拒收取消订购人数*/,
                               0 TOTAL_ORDER_COUNT /*总订购单数*/,
                               0 NET_ORDER_COUNT /*净订购单数*/,
                               0 CANCEL_ORDER_COUNT /*取消订购单数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.ORDER_H_KEY,
                                                   30,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) REVERSE_COUNT /*退货订购单数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            0,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) REJECT_COUNT /*拒收订购单数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   10,
                                                   RD1.ORDER_H_KEY,
                                                   30,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) CANCEL_REVERSE_COUNT /*退货取消订购单数*/,
                               COUNT(DISTINCT DECODE(RD1.CANCEL_STATE,
                                            1,
                                            DECODE(RD1.CANCEL_REASON,
                                                   20,
                                                   RD1.ORDER_H_KEY,
                                                   NULL),
                                            0)) CANCEL_REJECT_COUNT /*拒收取消订购单数*/,
                               0 GROSS_PROFIT_AMOUNT /*还原后总毛利额*/,
                               0 NET_PROFIT_AMOUNT /*还原后净毛利额*/,
                               0 GROSS_PROFIT_RATE /*还原后总毛利率*/,
                               0 NET_PROFIT_RATE /*还原后净毛利率*/,
                               0 TOTAL_ORDER_QTY /*总订购数量*/,
                               0 NET_ORDER_QTY /*净订购数量*/,
                               0 CANCEL_ORDER_QTY /*取消订购数量*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.NUMS,
                                                 30,
                                                 RD1.NUMS,
                                                 20,
                                                 0),
                                          0)) REVERSE_QTY /*退货订购数量*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.NUMS,
                                                 0),
                                          0)) REJECT_QTY /*拒收订购数量*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.NUMS,
                                                 30,
                                                 RD1.NUMS,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_QTY /*退货取消订购数量*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.NUMS,
                                                 0),
                                          0)) CANCEL_REJECT_QTY /*拒收取消订购数量*/,
                               0 NET_ORDER_CUST_PRICE /*净订购客单价*/,
                               0 NET_ORDER_UNIT_PRICE /*净订购件单价*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.PURCHASE_AMOUNT,
                                                 30,
                                                 RD1.PURCHASE_AMOUNT,
                                                 20,
                                                 0),
                                          0)) REVERSE_PURCHASE_AMOUNT /*退货订购成本*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          0,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.PURCHASE_AMOUNT,
                                                 0),
                                          0)) REJECT_PURCHASE_AMOUNT /*拒收订购成本*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 10,
                                                 RD1.PURCHASE_AMOUNT,
                                                 30,
                                                 RD1.PURCHASE_AMOUNT,
                                                 20,
                                                 0),
                                          0)) CANCEL_REVERSE_PURCHASE_AMOUNT /*退货取消订购成本*/,
                               SUM(DECODE(RD1.CANCEL_STATE,
                                          1,
                                          DECODE(RD1.CANCEL_REASON,
                                                 20,
                                                 RD1.PURCHASE_AMOUNT,
                                                 0),
                                          0)) CANCEL_REJECT_PURCHASE_AMOUNT /*拒收取消订购成本*/,
                               SUM(RD1.PROFIT_AMOUNT) PROFIT_AMOUNT /*折扣金额*/,
                               SUM(RD1.COUPONS_AMOUNT) COUPONS_AMOUNT /*优惠券金额*/,
                               SUM(RD1.FREIGHT_AMOUNT) FREIGHT_AMOUNT /*运费*/
                          FROM (SELECT RD.ORDER_KEY /*订单权责制*/,
                                       RD.ORDER_H_KEY /*订单发生制*/,
                                       RD.CANCEL_REASON /*退货类型*/,
                                       RD.CANCEL_STATE /*退货状态*/,
                                       RD.GOODS_KEY /*商品*/,
                                       RD.GOODS_COMMON_KEY /*商品短编码*/,
                                       RD.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                       RD.TRAN_TYPE /*是否赠品标志*/,
                                       RD.TRAN_DESC /*交易类型*/,
                                       RD.MD_PERSON /*MD工号*/,
                                       RD.POSTING_DATE_KEY /*过账日期key*/,
                                       TO_CHAR(RD.LIVE_STATE) ||
                                       TO_CHAR(RD.REPLAY_STATE) LIVE_OR_REPLAY /*直播重播*/,
                                       RD.MEMBER_KEY /*会员key*/,
                                       RD.ORDER_AMOUNT /*退货订购金额*/,
                                       RD.NUMS /*总订购数量*/,
                                       RD.SALES_AMOUNT /*总售价金额*/,
                                       RD.UNIT_PRICE /*单个商品售价*/,
                                       RD.COST_PRICE /*商品单件成本*/,
                                       RD.FREIGHT_AMOUNT /*运费*/,
                                       RD.COUPONS_AMOUNT /*优惠券金额*/,
                                       RD.PURCHASE_AMOUNT /*总订购成本*/,
                                       RD.PROFIT_AMOUNT /*折扣金额*/
                                  FROM (
                                        
                                        /*取消的订单，按过账日期POSTING_DATE_KEY记正向订单。
                                        2017-06-15 yangjin*/
                                        SELECT RDU1.ORDER_KEY /*订单权责制*/,
                                                RDU1.ORDER_H_KEY /*订单发生制*/,
                                                RDU1.CANCEL_REASON /*退货类型*/,
                                                CASE
                                                  WHEN RDU1.CANCEL_STATE = 1 AND
                                                       RDU1.POSTING_DATE_KEY <=
                                                       RDU1.UPDATE_TIME THEN
                                                   0
                                                  ELSE
                                                   RDU1.CANCEL_STATE
                                                END CANCEL_STATE /*退货状态*/,
                                                RDU1.GOODS_KEY /*商品*/,
                                                RDU1.GOODS_COMMON_KEY /*商品短编码*/,
                                                RDU1.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                                RDU1.TRAN_TYPE /*是否赠品标志*/,
                                                RDU1.TRAN_DESC /*交易类型*/,
                                                RDU1.MD_PERSON /*MD工号*/,
                                                RDU1.POSTING_DATE_KEY /*过账日期key*/,
                                                RDU1.LIVE_STATE /*是否直播*/,
                                                RDU1.REPLAY_STATE /*是否重播*/,
                                                RDU1.MEMBER_KEY /*会员key*/,
                                                RDU1.ORDER_AMOUNT /*退货订购金额*/,
                                                RDU1.NUMS /*总订购数量*/,
                                                RDU1.SALES_AMOUNT /*总售价金额*/,
                                                RDU1.UNIT_PRICE /*单个商品售价*/,
                                                RDU1.COST_PRICE /*商品单件成本*/,
                                                RDU1.FREIGHT_AMOUNT /*运费*/,
                                                RDU1.COUPONS_PRICE COUPONS_AMOUNT /*优惠券金额*/,
                                                RDU1.PURCHASE_AMOUNT /*总订购成本*/,
                                                RDU1.PROFIT_AMOUNT /*折扣金额*/
                                          FROM FACT_GOODS_SALES_REVERSE RDU1
                                         WHERE RDU1.CANCEL_REASON IN
                                               (10, 20, 30)
                                           AND RDU1.TRAN_DESC = 'REN'
                                        UNION ALL
                                        /*取消的订单，按过账日期POSTING_DATE_KEY记逆向订单。
                                        2017-06-15 yangjin*/
                                        SELECT RDU2.ORDER_KEY /*订单权责制*/,
                                                RDU2.ORDER_H_KEY /*订单发生制*/,
                                                RDU2.CANCEL_REASON /*退货类型*/,
                                                RDU2.CANCEL_STATE /*退货状态*/,
                                                RDU2.GOODS_KEY /*商品*/,
                                                RDU2.GOODS_COMMON_KEY /*商品短编码*/,
                                                RDU2.SALES_SOURCE_SECOND_KEY /*销售二级组织key*/,
                                                RDU2.TRAN_TYPE /*是否赠品标志*/,
                                                RDU2.TRAN_DESC /*交易类型*/,
                                                RDU2.MD_PERSON /*MD工号*/,
                                                RDU2.UPDATE_TIME             POSTING_DATE_KEY /*过账日期key*/,
                                                RDU2.LIVE_STATE /*是否直播*/,
                                                RDU2.REPLAY_STATE /*是否重播*/,
                                                RDU2.MEMBER_KEY /*会员key*/,
                                                RDU2.ORDER_AMOUNT /*退货订购金额*/,
                                                RDU2.NUMS /*总订购数量*/,
                                                RDU2.SALES_AMOUNT /*总售价金额*/,
                                                RDU2.UNIT_PRICE /*单个商品售价*/,
                                                RDU2.COST_PRICE /*商品单件成本*/,
                                                RDU2.FREIGHT_AMOUNT /*运费*/,
                                                RDU2.COUPONS_PRICE           COUPONS_AMOUNT /*优惠券金额*/,
                                                RDU2.PURCHASE_AMOUNT /*总订购成本*/,
                                                RDU2.PROFIT_AMOUNT /*折扣金额*/
                                          FROM FACT_GOODS_SALES_REVERSE RDU2
                                         WHERE RDU2.CANCEL_REASON IN
                                               (10, 20, 30)
                                           AND RDU2.TRAN_DESC = 'REN'
                                           AND RDU2.CANCEL_STATE = 1
                                           AND RDU2.POSTING_DATE_KEY <=
                                               RDU2.UPDATE_TIME
                                        
                                        ) RD
                                 WHERE RD.POSTING_DATE_KEY =
                                       IN_POSTING_DATE_KEY
                                   AND RD.CANCEL_REASON IN (10, 20, 30)
                                   AND RD.TRAN_DESC = 'REN') RD1
                         GROUP BY RD1.GOODS_KEY,
                                  RD1.GOODS_COMMON_KEY,
                                  RD1.SALES_SOURCE_SECOND_KEY,
                                  RD1.TRAN_DESC,
                                  RD1.MD_PERSON,
                                  RD1.POSTING_DATE_KEY,
                                  DECODE(RD1.LIVE_OR_REPLAY,
                                         '10',
                                         '直播',
                                         '01',
                                         '重播',
                                         '未分配')) RD2) FO,
               (SELECT DG.BRAND_NAME BRAND_NAME /*品牌*/,
                       DG.MATDLT MATDLT /*物料大类*/,
                       DG.MATZLT MATZLT /*物料中类*/,
                       DG.MATXLT MATXLT /*物料小类*/,
                       DG.ITEM_CODE /*商品*/,
                       DG.GOODS_NAME GOODS_NAME /*商品名称*/,
                       DECODE(DG.GROUP_ID, 2000, '自营', '非自营') OWN_ACCOUNT /*是否自营*/
                  FROM DIM_GOOD DG
                 WHERE DG.CURRENT_FLG = 'Y') DG,
               (SELECT * FROM DIM_SALES_SOURCE) DS
         WHERE FO.GOODS_COMMON_KEY = DG.ITEM_CODE(+)
           AND FO.SALES_SOURCE_SECOND_KEY = DS.SALES_SOURCE_SECOND_KEY;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*更新报表的商品资料相关字段*/
      UPDATE OPER_PRODUCT_DAILY_REPORT A
         SET (A.OWN_ACCOUNT,
              A.BRAND_NAME,
              A.MATDLT,
              A.MATZLT,
              A.MATXLT,
              A.ITEM_CODE,
              A.GOODS_NAME) =
             (SELECT DECODE(DG.GROUP_ID, 2000, '自营', '非自营') OWN_ACCOUNT /*是否自营*/,
                     DG.BRAND_NAME BRAND_NAME /*品牌*/,
                     DG.MATDLT MATDLT /*物料大类*/,
                     DG.MATZLT MATZLT /*物料中类*/,
                     DG.MATXLT MATXLT /*物料小类*/,
                     DG.ITEM_CODE /*商品*/,
                     DG.GOODS_NAME GOODS_NAME /*商品名称*/
                FROM DIM_GOOD DG
               WHERE DG.CURRENT_FLG = 'Y'
                 AND DG.ITEM_CODE = A.GOODS_KEY)
       WHERE A.ITEM_CODE IS NULL
         AND EXISTS (SELECT 1
                FROM DIM_GOOD B
               WHERE A.GOODS_KEY = B.ITEM_CODE
                 AND B.CURRENT_FLG = 'Y');
      UPDATE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
    
  END OPER_PRODUCT_DAILY_RPT;

  PROCEDURE OPER_PRODUCT_DAILY_PREVIEW(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：新媒体中心每日商品预览
    作者时间：yangjin  2018-01-19
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_PRODUCT_DAILY_PREVIEW'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_PRODUCT_DAILY_PREVIEW'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*中间表ETL*/
      --OPER_PRODUCT_DAILY_DS_S
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_PRODUCT_DAILY_DS_S';
      INSERT INTO OPER_PRODUCT_DAILY_DS_S
        (POSTING_DATE_KEY,
         MATDLT,
         MATZLT,
         MATXLT,
         ITEM_CODE,
         DS_ORDER_QTY,
         DS_PROFIT_AMOUNT,
         DS_PROFIT_RATE,
         DS_ORDER_AMOUNT,
         DS_ORDER_MEMBER_COUNT,
         DS_REJECT_MEMBER_COUNT,
         DS_REJECT_QTY,
         DS_REVERSE_MEMBER_COUNT,
         DS_REVERSE_QTY)
        SELECT A1.POSTING_DATE_KEY,
               A1.MATDLT,
               A1.MATZLT,
               A1.MATXLT,
               A1.ITEM_CODE,
               SUM(A1.TOTAL_ORDER_QTY) DS_ORDER_QTY, /*电商销售件数*/
               SUM(A1.GROSS_PROFIT_AMOUNT) DS_PROFIT_AMOUNT, /*电商毛利额*/
               SUM(A1.GROSS_PROFIT_RATE) DS_PROFIT_RATE, /*电商毛利率*/
               SUM(A1.TOTAL_ORDER_AMOUNT) DS_ORDER_AMOUNT, /*电商销售金额*/
               SUM(A1.TOTAL_ORDER_MEMBER_COUNT) DS_ORDER_MEMBER_COUNT, /*电商订购人数*/
               SUM(A1.REJECT_MEMBER_COUNT) DS_REJECT_MEMBER_COUNT, /*电商拒收人数*/
               SUM(A1.REJECT_QTY) DS_REJECT_QTY, /*电商拒收件数*/
               SUM(A1.REVERSE_MEMBER_COUNT) DS_REVERSE_MEMBER_COUNT, /*电商退货人数*/
               SUM(A1.REVERSE_QTY) DS_REVERSE_QTY /*电商退货件数*/
          FROM OPER_PRODUCT_DAILY_REPORT A1
         WHERE A1.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
           AND A1.SALES_SOURCE_NAME = '电商'
           AND A1.ITEM_CODE IS NOT NULL
         GROUP BY A1.POSTING_DATE_KEY,
                  A1.MATDLT,
                  A1.MATZLT,
                  A1.MATXLT,
                  A1.ITEM_CODE;
      COMMIT;
    
      --OPER_PRODUCT_DAILY_TV_S
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_PRODUCT_DAILY_TV_S';
      INSERT INTO OPER_PRODUCT_DAILY_TV_S
        (POSTING_DATE_KEY,
         MATDLT,
         MATZLT,
         MATXLT,
         ITEM_CODE,
         TV_ORDER_QTY,
         TV_ORDER_AMOUNT)
        SELECT A1.POSTING_DATE_KEY,
               A1.MATDLT,
               A1.MATZLT,
               A1.MATXLT,
               A1.ITEM_CODE,
               SUM(A1.TOTAL_ORDER_QTY) TV_ORDER_QTY, /*TV销售件数*/
               SUM(A1.TOTAL_ORDER_AMOUNT) TV_ORDER_AMOUNT /*TV销售金额*/
          FROM OPER_PRODUCT_DAILY_REPORT A1
         WHERE A1.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
           AND A1.SALES_SOURCE_NAME = 'TV'
           AND A1.ITEM_CODE IS NOT NULL
         GROUP BY A1.POSTING_DATE_KEY,
                  A1.MATDLT,
                  A1.MATZLT,
                  A1.MATXLT,
                  A1.ITEM_CODE;
      COMMIT;
    
      --OPER_PRODUCT_DAILY_PUV_S
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_PRODUCT_DAILY_PUV_S';
      INSERT INTO OPER_PRODUCT_DAILY_PUV_S
        (VISIT_DATE_KEY, ITEM_CODE, PV, UV)
        SELECT C1.VISIT_DATE_KEY,
               SUBSTR(C1.ITEM_CODE, 1, 6) ITEM_CODE,
               SUM(C1.GOODPV) PV,
               SUM(C1.GOODUV) UV
          FROM FACT_DAILY_GOODORDER C1
         WHERE C1.VISIT_DATE_KEY = IN_POSTING_DATE_KEY
         GROUP BY C1.VISIT_DATE_KEY, SUBSTR(C1.ITEM_CODE, 1, 6);
      COMMIT;
    
      --OPER_PRODUCT_DAILY_EVAL_S
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_PRODUCT_DAILY_EVAL_S';
      INSERT INTO OPER_PRODUCT_DAILY_EVAL_S
        (GEVAL_ADDTIME_KEY,
         ITEM_CODE,
         LOW_EVAL_COUNT,
         MED_EVAL_COUNT,
         HIGH_EVAL_COUNT)
        SELECT H.GEVAL_ADDTIME_KEY,
               H.ITEM_CODE,
               SUM(H.LOW_EVAL) LOW_EVAL_COUNT, /*差评次数*/
               SUM(H.MED_EVAL) MED_EVAL_COUNT, /*中评次数*/
               SUM(H.HIGH_EVAL) HIGH_EVAL_COUNT /*好评次数*/
          FROM (SELECT G.GEVAL_ADDTIME_KEY,
                       G.ITEM_CODE,
                       CASE
                         WHEN G.GEVAL_SCORES IN (1, 2) THEN
                          1
                         ELSE
                          0
                       END LOW_EVAL,
                       CASE
                         WHEN G.GEVAL_SCORES IN (3) THEN
                          1
                         ELSE
                          0
                       END MED_EVAL,
                       CASE
                         WHEN G.GEVAL_SCORES IN (4, 5) THEN
                          1
                         ELSE
                          0
                       END HIGH_EVAL
                  FROM FACT_GOODS_EVALUATE G
                 WHERE G.GEVAL_ADDTIME_KEY = IN_POSTING_DATE_KEY
                   AND G.ITEM_CODE IS NOT NULL) H
         GROUP BY H.GEVAL_ADDTIME_KEY, H.ITEM_CODE;
      COMMIT;
    
      --OPER_PRODUCT_DAILY_FAV_S
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_PRODUCT_DAILY_FAV_S';
      INSERT INTO OPER_PRODUCT_DAILY_FAV_S
        (FAV_TIME, ITEM_CODE, FAV_COUNT)
        SELECT J1.FAV_TIME, J1.FAV_ID ITEM_CODE, COUNT(1) FAV_COUNT
          FROM FACT_FAVORITES J1
         WHERE J1.FAV_TYPE = 'goods'
           AND J1.FAV_TIME = IN_POSTING_DATE_KEY
         GROUP BY J1.FAV_TIME, J1.FAV_ID;
      COMMIT;
    
      --OPER_PRODUCT_DAILY_CAR_S
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_PRODUCT_DAILY_CAR_S';
      INSERT INTO OPER_PRODUCT_DAILY_CAR_S
        (CREATE_DATE_KEY, ITEM_CODE, CAR_COUNT)
        SELECT K1.CREATE_DATE_KEY, K1.SCGID ITEM_CODE, COUNT(1) CAR_COUNT
          FROM FACT_SHOPPINGCAR K1
         WHERE K1.PAGE_NAME = 'good'
           AND K1.CREATE_DATE_KEY = IN_POSTING_DATE_KEY
         GROUP BY K1.CREATE_DATE_KEY, K1.SCGID;
      COMMIT;
    
      /*删除指定日期的数据*/
      DELETE OPER_PRODUCT_DAILY_PREVIEW T
       WHERE T.POSTING_DATE_KEY = IN_POSTING_DATE_KEY;
      COMMIT;
    
      INSERT INTO OPER_PRODUCT_DAILY_PREVIEW
        (POSTING_DATE_KEY,
         MATDLT,
         MATZLT,
         MATXLT,
         ITEM_CODE,
         GOOD_NAME,
         GOOD_S_PRICE,
         GOOD_C_PRICE,
         GROUP_NAME,
         IS_ONTV,
         IS_SHIPPING_SELF,
         TV_ORDER_AMOUNT,
         TV_ORDER_QTY,
         DS_ORDER_AMOUNT,
         DS_ORDER_QTY,
         DS_PROFIT_AMOUNT,
         DS_PROFIT_RATE,
         PV,
         UV,
         DS_ORDER_MEMBER_COUNT,
         CONVERSION_RATE,
         FAV_COUNT,
         CAR_COUNT,
         LOW_EVAL_COUNT,
         MED_EVAL_COUNT,
         HIGH_EVAL_COUNT,
         DS_REJECT_MEMBER_COUNT,
         DS_REJECT_QTY,
         DS_REVERSE_MEMBER_COUNT,
         DS_REVERSE_QTY,
         W_INSERT_DT,
         W_UPDATE_DT)
        SELECT B.POSTING_DATE_KEY POSTING_DATE_KEY, /*日期*/
               B.MATDLT, /*一级分类名称*/
               B.MATZLT, /*二级分类名称*/
               B.MATXLT, /*三级分类名称*/
               B.ITEM_CODE, /*商品编码*/
               B.GOODS_NAME GOOD_NAME, /*商品名称*/
               B.GOODS_PRICE GOOD_S_PRICE, /*商品价格*/
               (SELECT NVL(MAX(D.COST_PRICE), 0)
                  FROM FACT_GOODS_SALES D
                 WHERE D.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                   AND B.ITEM_CODE = D.GOODS_COMMON_KEY) GOOD_C_PRICE, /*商品进价*/
               (SELECT E.GROUP_NAME
                  FROM DIM_GOOD E
                 WHERE B.ITEM_CODE = E.ITEM_CODE
                   AND E.CURRENT_FLG = 'Y') GROUP_NAME, /*提报组*/
               NVL((SELECT MAX(1)
                     FROM DIM_TV_GOOD F
                    WHERE B.ITEM_CODE = F.ITEM_CODE
                      AND F.TV_STARTDAY_KEY = IN_POSTING_DATE_KEY),
                   0) IS_ONTV, /*是否当天播出*/
               B.IS_SHIPPING_SELF, /*是否仓配*/
               NVL(L.TV_ORDER_AMOUNT, 0) TV_ORDER_AMOUNT, /*TV销售金额*/
               NVL(L.TV_ORDER_QTY, 0) TV_ORDER_QTY, /*TV销售件数*/
               NVL(A.DS_ORDER_AMOUNT, 0) DS_ORDER_AMOUNT, /*电商销售金额*/
               NVL(A.DS_ORDER_QTY, 0) DS_ORDER_QTY, /*电商销售件数*/
               NVL(A.DS_PROFIT_AMOUNT, 0) DS_PROFIT_AMOUNT, /*电商毛利额*/
               NVL(A.DS_PROFIT_RATE, 0) DS_PROFIT_RATE, /*电商毛利率*/
               NVL(C.PV, 0) PV, /*浏览次数*/
               NVL(C.UV, 0) UV, /*浏览人数*/
               NVL(A.DS_ORDER_MEMBER_COUNT, 0) DS_ORDER_MEMBER_COUNT, /*电商订购人数*/
               DECODE(NVL(C.UV, 0),
                      0,
                      0,
                      ROUND(NVL(A.DS_ORDER_MEMBER_COUNT, 0) / NVL(C.UV, 0),
                            2)) CONVERSION_RATE, /*转换率*/
               NVL(J.FAV_COUNT, 0) FAV_COUNT, /*收藏次数*/
               NVL(K.CAR_COUNT, 0) CAR_COUNT, /*加购物车次数*/
               NVL(I.LOW_EVAL_COUNT, 0) LOW_EVAL_COUNT, /*差评次数*/
               NVL(I.MED_EVAL_COUNT, 0) MED_EVAL_COUNT, /*中评次数*/
               NVL(I.HIGH_EVAL_COUNT, 0) HIGH_EVAL_COUNT, /*好评次数*/
               NVL(A.DS_REJECT_MEMBER_COUNT, 0) DS_REJECT_MEMBER_COUNT, /*电商拒收人数*/
               NVL(A.DS_REJECT_QTY, 0) DS_REJECT_QTY, /*电商拒收件数*/
               NVL(A.DS_REVERSE_MEMBER_COUNT, 0) DS_REVERSE_MEMBER_COUNT, /*电商退货人数*/
               NVL(A.DS_REVERSE_QTY, 0) DS_REVERSE_QTY, /*电商退货件数*/
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM (SELECT IN_POSTING_DATE_KEY POSTING_DATE_KEY,
                       N.ITEM_CODE,
                       N.GOODS_NAME,
                       N.MATDLT,
                       N.MATZLT,
                       N.MATXLT,
                       N.GOODS_PRICE,
                       N.IS_SHIPPING_SELF
                  FROM DIM_EC_GOOD N) B,
               OPER_PRODUCT_DAILY_DS_S A,
               OPER_PRODUCT_DAILY_TV_S L,
               OPER_PRODUCT_DAILY_PUV_S C,
               OPER_PRODUCT_DAILY_EVAL_S I,
               OPER_PRODUCT_DAILY_FAV_S J,
               OPER_PRODUCT_DAILY_CAR_S K
         WHERE B.ITEM_CODE = A.ITEM_CODE(+)
           AND B.ITEM_CODE = C.ITEM_CODE(+)
           AND B.ITEM_CODE = I.ITEM_CODE(+)
           AND B.ITEM_CODE = J.ITEM_CODE(+)
           AND B.ITEM_CODE = K.ITEM_CODE(+)
           AND B.ITEM_CODE = L.ITEM_CODE(+)
           AND B.POSTING_DATE_KEY = A.POSTING_DATE_KEY(+)
           AND B.POSTING_DATE_KEY = L.POSTING_DATE_KEY(+)
           AND B.POSTING_DATE_KEY = C.VISIT_DATE_KEY(+)
           AND B.POSTING_DATE_KEY = I.GEVAL_ADDTIME_KEY(+)
           AND B.POSTING_DATE_KEY = J.FAV_TIME(+)
           AND B.POSTING_DATE_KEY = K.CREATE_DATE_KEY(+)
           AND (A.DS_ORDER_QTY <> 0 OR L.TV_ORDER_QTY <> 0 OR C.PV <> 0 OR
               I.LOW_EVAL_COUNT <> 0 OR I.MED_EVAL_COUNT <> 0 OR
               I.HIGH_EVAL_COUNT <> 0 OR J.FAV_COUNT <> 0 OR
               K.CAR_COUNT <> 0);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END OPER_PRODUCT_DAILY_PREVIEW;

  PROCEDURE OPER_PRODUCT_PVUV_DAILY_RPT(IN_VISIT_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2016-06-29
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_PRODUCT_PVUV_DAILY_RPT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_PRODUCT_PVUV_DAILY_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*删除指定日期的数据*/
      DELETE OPER_PRODUCT_PVUV_DAILY_REPORT T
       WHERE T.VISIT_DATE_KEY = IN_VISIT_DATE_KEY;
      COMMIT;
    
      INSERT INTO OPER_PRODUCT_PVUV_DAILY_REPORT
        (VISIT_DATE_KEY,
         PAGE_VALUE,
         ITEM_CODE,
         GOODS_NAME,
         MATDLT,
         GROUP_NAME,
         PV,
         UV,
         AVGNUM,
         GOODPV,
         GOODUV,
         GOODAVG,
         GOODS_COMMONID,
         GOODNUM,
         CUSTNUM,
         GOODMOUNT)
        SELECT V1.VISIT_DATE_KEY,
               V1.PAGE_VALUE,
               V1.ITEM_CODE,
               V1.GOODS_NAME,
               V1.MATDLT,
               V1.GROUP_NAME,
               V1.PV,
               V1.UV,
               V1.AVGNUM,
               V2.GOODPV,
               V2.GOODUV,
               V2.GOODAVG,
               V3.GOODS_COMMONID,
               V3.GOODNUM,
               V3.CUSTNUM,
               V3.GOODMOUNT
          FROM (SELECT X1.PAGE_VALUE,
                       X1.VISIT_DATE_KEY,
                       (SELECT Y1.ITEM_CODE
                          FROM DIM_GOOD Y1
                         WHERE Y1.ITEM_CODE = GET_ITEMCODE(X1.PAGE_VALUE)
                           AND ROWNUM = 1) AS ITEM_CODE,
                       (SELECT Y1.GOODS_NAME
                          FROM DIM_GOOD Y1
                         WHERE Y1.ITEM_CODE = GET_ITEMCODE(X1.PAGE_VALUE)
                           AND ROWNUM = 1) AS GOODS_NAME,
                       (SELECT Y1.MATDLT
                          FROM DIM_GOOD Y1
                         WHERE Y1.ITEM_CODE = GET_ITEMCODE(X1.PAGE_VALUE)
                           AND ROWNUM = 1) AS MATDLT,
                       (SELECT Y1.GROUP_NAME
                          FROM DIM_GOOD Y1
                         WHERE Y1.ITEM_CODE = GET_ITEMCODE(X1.PAGE_VALUE)
                           AND ROWNUM = 1) AS GROUP_NAME,
                       COUNT(X1.VID) AS PV,
                       COUNT(DISTINCT X1.VID) AS UV,
                       TRUNC(AVG(X1.PAGE_STAYTIME), 2) AS AVGNUM
                  FROM FACT_PAGE_VIEW X1
                 WHERE VISIT_DATE_KEY = IN_VISIT_DATE_KEY
                   AND PAGE_KEY IN (40899, 40903)
                 GROUP BY X1.PAGE_VALUE, X1.VISIT_DATE_KEY) V1
          LEFT JOIN (SELECT X2.PAGE_VALUE,
                            COUNT(X2.VID) AS GOODPV,
                            COUNT(DISTINCT X2.VID) AS GOODUV,
                            TRUNC(AVG(X2.PAGE_STAYTIME), 2) AS GOODAVG
                       FROM FACT_PAGE_VIEW X2
                      WHERE X2.VISIT_DATE_KEY = IN_VISIT_DATE_KEY
                        AND X2.PAGE_KEY IN (1924, 2841)
                      GROUP BY X2.PAGE_VALUE) V2
            ON V1.PAGE_VALUE = V2.PAGE_VALUE
          LEFT JOIN (SELECT X3.GOODS_COMMONID,
                            SUM(X3.GOODS_NUM) AS GOODNUM,
                            COUNT(DISTINCT X3.CUST_NO) AS CUSTNUM,
                            SUM(X3.GOODS_PAY_PRICE * X3.GOODS_NUM) AS GOODMOUNT
                       FROM ORDER_GOOD X3
                      WHERE X3.ADD_TIME = IN_VISIT_DATE_KEY
                        AND X3.ISCG = 1
                      GROUP BY X3.GOODS_COMMONID) V3
            ON V2.PAGE_VALUE = V3.GOODS_COMMONID;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_VISIT_DATE_KEY:' ||
                            TO_CHAR(IN_VISIT_DATE_KEY);
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
    
  END OPER_PRODUCT_PVUV_DAILY_RPT;

  PROCEDURE OPER_NM_PROMOTION_ITEM_RPT(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    UPDATE_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    功能说明：新媒体中心促销报表（商品级别）
    作者时间：yangjin  2017-09-19
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_NM_PROMOTION_ITEM_RPT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_NM_PROMOTION_ITEM_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*删除报表数据*/
      DELETE OPER_NM_PROMOTION_ITEM_REPORT
       WHERE ADD_TIME = IN_POSTING_DATE;
      COMMIT;
    
      /*插入报表数据*/
      INSERT INTO OPER_NM_PROMOTION_ITEM_REPORT
        (ADD_TIME,
         PROMOTION_NAME,
         PROMOTION_TYPE,
         PROMOTION_SOURCE,
         PROMOTION_NO,
         PATHWAY,
         ITEM_CODE,
         ITEM_NAME,
         SALES_QTY,
         SALES_AMOUNT,
         COMPANY_APPORTION_AMOUNT,
         SUPP_APPORTION_AMOUNT,
         SUPPLIER_ID,
         TOTAL_APPORTION_AMOUNT,
         ORDER_SN)
        SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*订购日期*/
               X.XIANSHI_NAME PROMOTION_NAME, /*促销名称*/
               CASE
                 WHEN X.XIANSHI_TYPE = 1 THEN
                  '限时直降'
                 WHEN X.XIANSHI_TYPE = 2 THEN
                  '限时抢'
                 WHEN X.XIANSHI_TYPE = 3 THEN
                  'TV直减'
                 ELSE
                  '限时折扣'
               END PROMOTION_TYPE, /*促销类型*/
               CASE
                 WHEN X.CRM_POLICY_ID = '0' THEN
                  '新媒体'
                 WHEN X.CRM_POLICY_ID <> '0' THEN
                  '同步促销'
                 ELSE
                  '新媒体'
               END PROMOTION_SOURCE, /*促销来源*/
               NVL(X.CRM_POLICY_ID, 0) PROMOTION_NO, /*促销编号*/
               CASE
                 WHEN OH.APP_NAME = 'KLGiPhone' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGAndroid' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGMPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGWX' THEN
                  '微信'
                 WHEN OH.APP_NAME = 'undefined' THEN
                  '未知'
               END PATHWAY, /*通路*/
               OG.ERP_CODE ITEM_CODE, /*商品编码*/
               OG.GOODS_NAME ITEM_NAME, /*商品名称*/
               OG.GOODS_NUM SALES_QTY, /*有效订购件数*/
               OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, /*商品有效金额*/
               (NVL(OG.GOODS_PRICE, 0) - NVL(OG.GOODS_PAY_PRICE, 0) -
               NVL(OG.TV_DISCOUNT_AMOUNT, 0) - NVL(OG.APPORTION_PRICE, 0)) *
               OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, /*公司让利*/
               OG.APPORTION_PRICE * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, /*供应商让利*/
               OG.SUPPLIER_ID, /*供应商编码*/
               (NVL(OG.GOODS_PRICE, 0) - NVL(OG.GOODS_PAY_PRICE, 0) -
               NVL(OG.TV_DISCOUNT_AMOUNT, 0)) * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT, /*促销总成本*/
               TO_CHAR(OH.ORDER_SN) ORDER_SN /*订单编码*/
          FROM FACT_EC_ORDER_2         OH,
               FACT_EC_ORDER_GOODS     OG,
               FACT_EC_P_XIANSHI       X,
               FACT_EC_P_XIANSHI_GOODS XG
         WHERE OH.ORDER_ID = OG.ORDER_ID
           AND OG.XIANSHI_GOODS_ID = XG.XIANSHI_GOODS_ID(+)
           AND XG.XIANSHI_ID = X.XIANSHI_ID(+)
              /*有效订购条件*/
           AND OH.ORDER_STATE >= 30
           AND OH.REFUND_STATE = 0
           AND OG.GOODS_TYPE = 3
           AND TRUNC(OH.ADD_TIME) = IN_POSTING_DATE
        UNION ALL
        /*商品级促销-等级减*/
        SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*订购日期*/
               OG.PML_TITLE PROMOTION_NAME, /*促销名称*/
               '等级减' PROMOTION_TYPE, /*促销类型*/
               '新媒体' PROMOTION_SOURCE, /*促销来源*/
               TO_CHAR(OG.PML_ID) PROMOTION_NO, /*促销编号*/
               CASE
                 WHEN OH.APP_NAME = 'KLGiPhone' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGAndroid' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGMPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGWX' THEN
                  '微信'
                 WHEN OH.APP_NAME = 'undefined' THEN
                  '未知'
               END PATHWAY, /*通路*/
               OG.ERP_CODE ITEM_CODE, /*商品编码*/
               OG.GOODS_NAME ITEM_NAME, /*商品名称*/
               OG.GOODS_NUM SALES_QTY, /*有效订购件数*/
               OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, /*商品有效金额*/
               OG.PML_DISCOUNT * OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, /*公司让利*/
               NVL(OG.APPORTION_PRICE, 0) * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, /*供应商让利*/
               OG.SUPPLIER_ID, /*供应商编码*/
               OG.PML_DISCOUNT * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT, /*促销总成本*/
               TO_CHAR(OH.ORDER_SN) ORDER_SN /*订单编码*/
          FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
         WHERE OH.ORDER_ID = OG.ORDER_ID
              /*有效订购条件*/
           AND OH.ORDER_STATE >= 30
           AND OH.REFUND_STATE = 0
           AND OG.PML_DISCOUNT <> 0
           AND TRUNC(OH.ADD_TIME) = IN_POSTING_DATE
        UNION ALL
        /*商品级促销-TV直播立减促销*/
        SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*订购日期*/
               '网站特享在线订购直播商品立减' PROMOTION_NAME, /*促销名称*/
               'TV直播立减' PROMOTION_TYPE, /*促销类型*/
               '新媒体' PROMOTION_SOURCE, /*促销来源*/
               '' PROMOTION_NO, /*促销编号*/
               CASE
                 WHEN OH.APP_NAME = 'KLGiPhone' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGAndroid' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGMPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGWX' THEN
                  '微信'
                 WHEN OH.APP_NAME = 'undefined' THEN
                  '未知'
               END PATHWAY, /*通路*/
               OG.ERP_CODE ITEM_CODE, /*商品编码*/
               OG.GOODS_NAME ITEM_NAME, /*商品名称*/
               OG.GOODS_NUM SALES_QTY, /*有效订购件数*/
               OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, /*商品有效金额*/
               OG.TV_DISCOUNT_AMOUNT * OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, /*公司让利*/
               NVL(OG.APPORTION_PRICE, 0) * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, /*供应商让利*/
               OG.SUPPLIER_ID, /*供应商编码*/
               OG.TV_DISCOUNT_AMOUNT * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT, /*促销总成本*/
               TO_CHAR(OH.ORDER_SN) ORDER_SN /*订单编码*/
          FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
         WHERE OH.ORDER_ID = OG.ORDER_ID
              /*有效订购条件*/
           AND OH.ORDER_STATE >= 30
           AND OH.REFUND_STATE = 0
           AND OG.TV_DISCOUNT_AMOUNT <> 0
           AND TRUNC(OH.ADD_TIME) = IN_POSTING_DATE;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END OPER_NM_PROMOTION_ITEM_RPT;

  PROCEDURE OPER_NM_PROMOTION_ORDER_RPT(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL           W_ETL_LOG%ROWTYPE;
    SP_NAME         S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER     S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS     NUMBER;
    UPDATE_ROWS     NUMBER;
    IN_POSTING_DATE DATE;
    /*
    功能说明：新媒体中心促销报表（订单级别）
    作者时间：yangjin  2017-09-19
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_NM_PROMOTION_ORDER_RPT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_NM_PROMOTION_ORDER_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_POSTING_DATE  := TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*删除报表数据*/
      DELETE OPER_NM_PROMOTION_ORDER_REPORT
       WHERE ADD_TIME = IN_POSTING_DATE;
      COMMIT;
    
      /*插入报表数据*/
      INSERT INTO OPER_NM_PROMOTION_ORDER_REPORT
        (ADD_TIME,
         ORDER_SN,
         PROMOTION_NAME,
         PATHWAY,
         PROMONTION_TYPE,
         SALES_AMOUNT,
         DISCOUNT_MANSONG_AMOUNT)
      /*DISCOUNT_MANSONG_AMOUNT*/
        SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*订购日期*/
               TO_CHAR(OH.ORDER_SN) ORDER_SN, /*订单编号*/
               M.MANSONG_NAME PROMOTION_NAME, /*促销名称/券名称*/
               CASE
                 WHEN OH.APP_NAME = 'KLGiPhone' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGAndroid' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGMPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGWX' THEN
                  '微信'
                 WHEN OH.APP_NAME = 'undefined' THEN
                  '未知'
               END PATHWAY, /*通路*/
               '满立减' PROMONTION_TYPE, /*促销类型*/
               OH.ORDER_AMOUNT SALES_AMOUNT, /*商品有效金额*/
               OH.DISCOUNT_MANSONG_AMOUNT /*促销金额*/
          FROM FACT_EC_ORDER_2 OH, FACT_EC_P_MANSONG M
         WHERE OH.DISCOUNT_MANSONG_ID = M.MANSONG_ID
              /*有效订购条件*/
           AND OH.ORDER_STATE >= 30
           AND OH.REFUND_STATE = 0
           AND OH.DISCOUNT_MANSONG_AMOUNT <> 0
           AND TRUNC(OH.ADD_TIME) = IN_POSTING_DATE
        UNION ALL
        /*DISCOUNT_PAYMENTWAY_DESC*/
        SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*订购日期*/
               TO_CHAR(OH.ORDER_SN) ORDER_SN, /*订单编号*/
               OH.DISCOUNT_PAYMENTWAY_DESC, /*促销名称/券名称*/
               CASE
                 WHEN OH.APP_NAME = 'KLGiPhone' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGAndroid' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGMPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGWX' THEN
                  '微信'
                 WHEN OH.APP_NAME = 'undefined' THEN
                  '未知'
               END PATHWAY, /*通路*/
               '支付立减' PROMONTION_TYPE, /*促销类型*/
               OH.ORDER_AMOUNT SALES_AMOUNT, /*商品有效金额*/
               OH.DISCOUNT_PAYMENTWAY_AMOUNT /*促销金额*/
          FROM FACT_EC_ORDER_2 OH
         WHERE
        /*有效订购条件*/
         OH.ORDER_STATE >= 30
         AND OH.REFUND_STATE = 0
         AND OH.DISCOUNT_PAYMENTWAY_AMOUNT <> 0
         AND TRUNC(OH.ADD_TIME) = IN_POSTING_DATE
        UNION ALL
        /*DISCOUNT_PAYMENTCHANEL_DESC*/
        SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*订购日期*/
               TO_CHAR(OH.ORDER_SN) ORDER_SN, /*订单编号*/
               OH.DISCOUNT_PAYMENTCHANEL_DESC, /*促销名称/券名称*/
               CASE
                 WHEN OH.APP_NAME = 'KLGiPhone' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGAndroid' THEN
                  'APP'
                 WHEN OH.APP_NAME = 'KLGPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGMPortal' THEN
                  'WEB'
                 WHEN OH.APP_NAME = 'KLGWX' THEN
                  '微信'
                 WHEN OH.APP_NAME = 'undefined' THEN
                  '未知'
               END PATHWAY, /*通路*/
               '支付立减' PROMONTION_TYPE, /*促销类型*/
               OH.ORDER_AMOUNT SALES_AMOUNT, /*商品有效金额*/
               OH.DISCOUNT_PAYMENTCHANEL_AMOUNT /*促销金额*/
          FROM FACT_EC_ORDER_2 OH
         WHERE
        /*有效订购条件*/
         OH.ORDER_STATE >= 30
         AND OH.REFUND_STATE = 0
         AND OH.DISCOUNT_PAYMENTCHANEL_AMOUNT <> 0
         AND TRUNC(OH.ADD_TIME) = IN_POSTING_DATE;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END OPER_NM_PROMOTION_ORDER_RPT;

  PROCEDURE OPER_NM_VOUCHER_RPT IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：新媒体中心促销报表（优惠券报表）
    作者时间：yangjin  2017-09-19
    */
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_NM_VOUCHER_RPT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_NM_VOUCHER_REPORT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
    
      /*插入报表数据*/
      MERGE /*+APPEND*/
      INTO OPER_NM_VOUCHER_REPORT T
      USING (SELECT E.VOUCHER_T_ID,
                    E.COUPON_TV_ID,
                    E.VOUCHER_TITLE,
                    E.VOUCHER_START_DATE,
                    E.VOUCHER_END_DATE,
                    E.VOUCHER_TYPE,
                    E.VOUCHER_PRICE,
                    E.SEND_VOUCHER_COUNT,
                    E.USED_VOUCHER_COUNT,
                    E.USED_VOUCHER_COUNT / E.SEND_VOUCHER_COUNT USED_VOUCHER_RATE,
                    E.USED_VOUCHER_COUNT * E.VOUCHER_PRICE VOUCHER_COST,
                    E.ORDER_AMOUNT
               FROM (SELECT D.VOUCHER_T_ID,
                            D.COUPON_TV_ID,
                            D.VOUCHER_TITLE,
                            D.VOUCHER_START_DATE,
                            D.VOUCHER_END_DATE,
                            D.VOUCHER_TYPE,
                            D.VOUCHER_PRICE,
                            COUNT(D.VOUCHER_CODE) SEND_VOUCHER_COUNT,
                            SUM(CASE
                                  WHEN D.ORDER_SN IS NOT NULL THEN
                                   1
                                  ELSE
                                   0
                                END) USED_VOUCHER_COUNT,
                            SUM(NVL(D.ORDER_AMOUNT, 0)) ORDER_AMOUNT
                       FROM (SELECT A.VOUCHER_T_ID,
                                    A.COUPON_TV_ID,
                                    A.VOUCHER_TITLE,
                                    A.VOUCHER_START_DATE,
                                    A.VOUCHER_END_DATE,
                                    A.VOUCHER_TYPE,
                                    A.VOUCHER_PRICE,
                                    A.VOUCHER_CODE,
                                    B.ORDER_SN,
                                    B.ORDER_AMOUNT
                               FROM (SELECT V.VOUCHER_T_ID,
                                            V.VOUCHER_TITLE,
                                            V.VOUCHER_CODE,
                                            CASE
                                              WHEN V.COUPON_TV_ID IS NULL THEN
                                               '新媒体券'
                                              ELSE
                                               'TV券'
                                            END VOUCHER_TYPE,
                                            TRUNC(V.VOUCHER_START_DATE) VOUCHER_START_DATE,
                                            TRUNC(V.VOUCHER_END_DATE) VOUCHER_END_DATE,
                                            NVL(V.COUPON_TV_ID, 0) COUPON_TV_ID,
                                            V.VOUCHER_PRICE
                                       FROM FACT_EC_VOUCHER V) A,
                                    (SELECT C.VOUCHER_REF,
                                            C.VOUCHER_CODE,
                                            C.DCISSUE_SEQ,
                                            TO_CHAR(O.ORDER_SN) ORDER_SN,
                                            O.ORDER_AMOUNT
                                       FROM FACT_EC_ORDER_2      O,
                                            FACT_EC_ORDER_COMMON C
                                      WHERE O.ORDER_ID = C.ORDER_ID
                                        AND O.ORDER_STATE >= 30
                                        AND O.REFUND_STATE = 0
                                        AND C.VOUCHER_CODE IS NOT NULL) B
                              WHERE A.VOUCHER_T_ID = B.VOUCHER_REF(+)
                                AND A.VOUCHER_CODE = B.VOUCHER_CODE(+)) D
                      GROUP BY D.VOUCHER_T_ID,
                               D.COUPON_TV_ID,
                               D.VOUCHER_TITLE,
                               D.VOUCHER_START_DATE,
                               D.VOUCHER_END_DATE,
                               D.VOUCHER_TYPE,
                               D.VOUCHER_PRICE) E
             /*判断记录是否与OPER_NM_VOUCHER_REPORT一样，如果一样则更新*/
              WHERE NOT EXISTS
              (SELECT 1
                       FROM OPER_NM_VOUCHER_REPORT F
                      WHERE E.VOUCHER_T_ID = F.VOUCHER_T_ID
                        AND E.COUPON_TV_ID = F.COUPON_TV_ID
                        AND E.VOUCHER_TITLE = F.VOUCHER_TITLE
                        AND E.VOUCHER_START_DATE = F.VOUCHER_START_DATE
                        AND E.VOUCHER_END_DATE = F.VOUCHER_END_DATE
                        AND E.SEND_VOUCHER_COUNT = F.SEND_VOUCHER_COUNT
                        AND E.USED_VOUCHER_COUNT = F.USED_VOUCHER_COUNT)) S
      ON (T.VOUCHER_T_ID = S.VOUCHER_T_ID AND T.COUPON_TV_ID = S.COUPON_TV_ID AND T.VOUCHER_TITLE = S.VOUCHER_TITLE AND T.VOUCHER_START_DATE = S.VOUCHER_START_DATE AND T.VOUCHER_END_DATE = S.VOUCHER_END_DATE)
      WHEN MATCHED THEN
        UPDATE
           SET T.VOUCHER_TYPE       = S.VOUCHER_TYPE,
               T.VOUCHER_PRICE      = S.VOUCHER_PRICE,
               T.SEND_VOUCHER_COUNT = S.SEND_VOUCHER_COUNT,
               T.USED_VOUCHER_COUNT = S.USED_VOUCHER_COUNT,
               T.USED_VOUCHER_RATE  = S.USED_VOUCHER_RATE,
               T.VOUCHER_COST       = S.VOUCHER_COST,
               T.ORDER_AMOUNT       = S.ORDER_AMOUNT
      WHEN NOT MATCHED THEN
        INSERT
          (T.VOUCHER_T_ID,
           T.COUPON_TV_ID,
           T.VOUCHER_TITLE,
           T.VOUCHER_TYPE,
           T.VOUCHER_PRICE,
           T.VOUCHER_START_DATE,
           T.VOUCHER_END_DATE,
           T.SEND_VOUCHER_COUNT,
           T.USED_VOUCHER_COUNT,
           T.USED_VOUCHER_RATE,
           T.VOUCHER_COST,
           T.ORDER_AMOUNT)
        VALUES
          (S.VOUCHER_T_ID,
           S.COUPON_TV_ID,
           S.VOUCHER_TITLE,
           S.VOUCHER_TYPE,
           S.VOUCHER_PRICE,
           S.VOUCHER_START_DATE,
           S.VOUCHER_END_DATE,
           S.SEND_VOUCHER_COUNT,
           S.USED_VOUCHER_COUNT,
           S.USED_VOUCHER_RATE,
           S.VOUCHER_COST,
           S.ORDER_AMOUNT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '无参数';
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END OPER_NM_VOUCHER_RPT;

  PROCEDURE OPER_MEMBER_NOT_IN_EC(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*
    功能说明：在其他渠道下单了但是没有在电商注册会员的每天发短信
    作者时间：yangjin  2017-07-27
    */
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_MEMBER_NOT_IN_EC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MEMBER_NOT_IN_EC'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
    
      DELETE OPER_MEMBER_NOT_IN_EC A
       WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY;
      COMMIT;
    
      INSERT INTO OPER_MEMBER_NOT_IN_EC
        SELECT OPER_MEMBER_NOT_IN_EC_SEQ.NEXTVAL,
               D.POSTING_DATE_KEY,
               D.MEMBER_KEY,
               SYSDATE,
               SYSDATE
          FROM (SELECT DISTINCT A.POSTING_DATE_KEY, A.MEMBER_KEY
                  FROM FACT_ORDER A
                 WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                   AND A.SALES_SOURCE_KEY <> 20
                   AND NOT EXISTS
                 (SELECT 1
                          FROM (SELECT C.MEMBER_CRMBP FROM FACT_ECMEMBER C) B
                         WHERE A.MEMBER_KEY = B.MEMBER_CRMBP)) D;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
    
  END OPER_MEMBER_NOT_IN_EC;

  PROCEDURE FACT_GOODS_SALES_FIX(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*
    功能说明：通过存储过程重新从ODS_ORDER往FACT_GOODS_SALES,FACT_GOODS_SALES_REVERSE插入数据
    作者时间：yangjin  2017-07-28
    */
  BEGIN
  
    BEGIN
      -- FACT_GOODS_SALES
      CREATEORDERGOODS(IN_POSTING_DATE_KEY);
    END;
  
    BEGIN
      -- FACT_GOODS_SALES
      PROCESSUPDATEORDER(IN_POSTING_DATE_KEY);
    END;
  
    BEGIN
      -- FACT_GOODS_SALES_REVERSE
      CREATEFACTORDERGOODSREVERSE(IN_POSTING_DATE_KEY);
    END;
  
    BEGIN
      -- FACT_GOODS_SALES_REVERSE
      PROCESSUPDATEORDERREVERSE(IN_POSTING_DATE_KEY);
    END;
  
    BEGIN
      -- OPER_PRODUCT_DAILY_REPORT
      YANGJIN_PKG.OPER_PRODUCT_DAILY_RPT(IN_POSTING_DATE_KEY);
    END;
  
    BEGIN
      --YANGJIN_PKG.OPER_MEMBER_NOT_IN_EC
      YANGJIN_PKG.OPER_MEMBER_NOT_IN_EC(IN_POSTING_DATE_KEY);
    END;
  
    BEGIN
      --MEMBER_LABEL_PKG.MEMBER_REPURCHASE
      MEMBER_LABEL_PKG.MEMBER_REPURCHASE(IN_POSTING_DATE_KEY);
    END;
  
    BEGIN
      --MEMBER_LABEL_PKG.MEMBER_INJURED_PERIOD
      MEMBER_LABEL_PKG.MEMBER_INJURED_PERIOD(IN_POSTING_DATE_KEY);
    END;
  
  END FACT_GOODS_SALES_FIX;

  PROCEDURE DIM_GOOD_FIX IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
  
    /*
    功能说明：对DIM_GOOD表修复数据，如果有商品资料未导入DIM_GOOD.
              ODS_ZMATERIAL有的商品而DIM_GOOD没有的商品资料。  
    作者时间：yangjin  2017-08-15
    */
  
  BEGIN
  
    SP_NAME          := 'YANGJIN_PKG.DIM_GOOD_FIX'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DIM_GOOD'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
    DECLARE
    
    BEGIN
      /*从ODS_ZMATERIAL插入DIM_GOOD不存在的商品*/
      INSERT INTO DIM_GOOD
        (ITEM_CODE,
         GOODS_NAME,
         MATDL,
         MATDLT,
         MATZL,
         MATZLT,
         MATXL,
         MATXLT,
         MATL_GROUP,
         MATXXLT,
         CREATE_TIME,
         MD,
         GROUP_ID,
         GROUP_NAME,
         W_INSERT_DT,
         W_UPDATE_DT,
         ROW_WID,
         CURRENT_FLG)
        SELECT TA.COL1,
               TA.COL2,
               TA.COL3,
               TA.COL4,
               TA.COL5,
               TA.COL6,
               TA.COL7,
               TA.COL8,
               TA.COL9,
               TA.COL10,
               TA.COL11,
               TA.COL12,
               TA.COL13,
               TA.COL14,
               TA.COL15,
               TA.COL16,
               DIM_GOOD_SEQ.NEXTVAL,
               'Y' /*CURRENT_FLG*/
          FROM (SELECT DISTINCT --TO_NUMBER(F.ZMATER2), --AS "商品编号",
                                 
                                 TO_NUMBER(CASE
                                             WHEN REGEXP_LIKE(F.ZMATER2,
                                                              '.([a-z]+|[A-Z])') THEN
                                              '0'
                                             WHEN REGEXP_LIKE(F.ZMATER2, '[[:punct:]]+') THEN
                                              '0'
                                             WHEN F.ZMATER2 IS NULL THEN
                                              '0'
                                             WHEN F.ZMATER2 LIKE '%null%' THEN
                                              '0'
                                             ELSE
                                              REGEXP_REPLACE(F.ZMATER2, '\s', '')
                                           END) COL1,
                                 
                                 REGEXP_SUBSTR(F.TXTMD, '[^,]+', 1, 1) COL2, --AS "商品名称",
                                 -- TO_NUMBER(F.RPA_WGH3), -- AS "大分类",
                                 
                                 TO_NUMBER(CASE
                                             WHEN REGEXP_LIKE(F.ZMATDL,
                                                              '.([a-z]+|[A-Z])') THEN
                                              '0'
                                             WHEN REGEXP_LIKE(F.ZMATDL, '[[:punct:]]+') THEN
                                              '0'
                                             WHEN F.ZMATDL IS NULL THEN
                                              '0'
                                             WHEN F.ZMATDL LIKE '%null%' THEN
                                              '0'
                                             ELSE
                                              REGEXP_REPLACE(F.ZMATDL, '\s', '')
                                           END) COL3,
                                 
                                 (SELECT DISTINCT E.ZMATDLT
                                    FROM DIM_MATERCATE E
                                   WHERE E.ZMATDL = TO_NUMBER(CASE
                                                                WHEN REGEXP_LIKE(F.ZMATDL,
                                                                                 '.([a-z]+|[A-Z])') THEN
                                                                 '0'
                                                                WHEN REGEXP_LIKE(F.ZMATDL,
                                                                                 '[[:punct:]]+') THEN
                                                                 '0'
                                                                WHEN F.ZMATDL IS NULL THEN
                                                                 '0'
                                                                WHEN F.ZMATDL LIKE '%null%' THEN
                                                                 '0'
                                                                ELSE
                                                                 REGEXP_REPLACE(F.ZMATDL, '\s', '')
                                                              END)
                                  
                                  ) COL4,
                                 --  TO_NUMBER(F.RPA_WGH2), --AS "中分类",
                                 
                                 TO_NUMBER(CASE
                                             WHEN REGEXP_LIKE(F.ZMATZL,
                                                              '.([a-z]+|[A-Z])') THEN
                                              '0'
                                             WHEN REGEXP_LIKE(F.ZMATZL, '[[:punct:]]+') THEN
                                              '0'
                                             WHEN F.ZMATZL IS NULL THEN
                                              '0'
                                             WHEN F.ZMATZL LIKE '%null%' THEN
                                              '0'
                                             ELSE
                                              REGEXP_REPLACE(F.ZMATZL, '\s', '')
                                           END) COL5,
                                 
                                 (SELECT DISTINCT E.ZMATZLT
                                    FROM DIM_MATERCATE E
                                   WHERE E.ZMATZL = TO_NUMBER(CASE
                                                                WHEN REGEXP_LIKE(F.ZMATZL,
                                                                                 '.([a-z]+|[A-Z])') THEN
                                                                 '0'
                                                                WHEN REGEXP_LIKE(F.ZMATZL,
                                                                                 '[[:punct:]]+') THEN
                                                                 '0'
                                                                WHEN F.ZMATZL IS NULL THEN
                                                                 '0'
                                                                WHEN F.ZMATZL LIKE '%null%' THEN
                                                                 '0'
                                                                ELSE
                                                                 REGEXP_REPLACE(F.ZMATZL, '\s', '')
                                                              END)) COL6,
                                 -- TO_NUMBER(F.RPA_WGH1), --AS "小分类",
                                 
                                 TO_NUMBER(CASE
                                             WHEN REGEXP_LIKE(F.ZMATXL,
                                                              '.([a-z]+|[A-Z])') THEN
                                              '0'
                                             WHEN REGEXP_LIKE(F.ZMATXL, '[[:punct:]]+') THEN
                                              '0'
                                             WHEN F.ZMATXL IS NULL THEN
                                              '0'
                                             WHEN F.ZMATXL LIKE '%null%' THEN
                                              '0'
                                             ELSE
                                              REGEXP_REPLACE(F.ZMATXL, '\s', '')
                                           END) COL7,
                                 (SELECT DISTINCT E.ZMATXLT
                                    FROM DIM_MATERCATE E
                                   WHERE E.ZMATXL = TO_NUMBER(CASE
                                                                WHEN REGEXP_LIKE(F.ZMATXL,
                                                                                 '.([a-z]+|[A-Z])') THEN
                                                                 '0'
                                                                WHEN REGEXP_LIKE(F.ZMATXL,
                                                                                 '[[:punct:]]+') THEN
                                                                 '0'
                                                                WHEN F.ZMATXL IS NULL THEN
                                                                 '0'
                                                                WHEN F.ZMATXL LIKE '%null%' THEN
                                                                 '0'
                                                                ELSE
                                                                 REGEXP_REPLACE(F.ZMATXL, '\s', '')
                                                              END)) COL8,
                                 -- TO_NUMBER(F.MATL_GROUP), --AS "细分类",
                                 TO_NUMBER(CASE
                                             WHEN REGEXP_LIKE(F.MATL_GROUP,
                                                              '.([a-z]+|[A-Z])') THEN
                                              '0'
                                             WHEN REGEXP_LIKE(F.MATL_GROUP,
                                                              '[[:punct:]]+') THEN
                                              '0'
                                             WHEN F.MATL_GROUP IS NULL THEN
                                              '0'
                                             WHEN F.MATL_GROUP LIKE '%null%' THEN
                                              '0'
                                             ELSE
                                              REGEXP_REPLACE(F.MATL_GROUP, '\s', '')
                                           END) COL9,
                                 
                                 (SELECT DISTINCT E.ZMATXXLT
                                    FROM DIM_MATERCATE E
                                   WHERE E.ZMATXXL =
                                         TO_NUMBER(CASE
                                                     WHEN REGEXP_LIKE(F.MATL_GROUP,
                                                                      '.([a-z]+|[A-Z])') THEN
                                                      '0'
                                                     WHEN REGEXP_LIKE(F.MATL_GROUP,
                                                                      '[[:punct:]]+') THEN
                                                      '0'
                                                     WHEN F.MATL_GROUP IS NULL THEN
                                                      '0'
                                                     WHEN F.MATL_GROUP LIKE '%null%' THEN
                                                      '0'
                                                     ELSE
                                                      REGEXP_REPLACE(F.MATL_GROUP,
                                                                     '\s',
                                                                     '')
                                                   END)) COL10,
                                 
                                 TO_DATE(F.CREATEDON, 'yyyy-mm-dd') COL11, --AS "建立日期",
                                 TO_NUMBER(F.ZEAMC027) COL12, --AS "MD",
                                 TO_NUMBER(F.ZTLHRP) COL13, -- AS "提报组编号",
                                 CASE
                                   WHEN F.ZTLHRP = 1000 THEN
                                    'TV提报组'
                                   WHEN F.ZTLHRP = 2000 THEN
                                    '电商提报组'
                                   WHEN F.ZTLHRP = 3000 THEN
                                    '道格提报组'
                                   WHEN F.ZTLHRP = 5000 THEN
                                    '芒果生活提报组'
                                   WHEN F.ZTLHRP = 6000 THEN
                                    '外呼提报组'
                                   WHEN F.ZTLHRP = 7000 THEN
                                    '全球购提报组'
                                   ELSE
                                    '未知'
                                 END COL14,
                                 SYSDATE COL15,
                                 SYSDATE COL16
                   FROM ODS_ZMATERIAL F
                  WHERE /*F.CREATEDON = IN_POSTING_DATE_KEY
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                AND*/
                  F.ZMATERIAL NOT LIKE '%F%'
               AND F.ZEAMC027 IS NOT NULL
               AND F.ZEAMC027 != 0) TA
         WHERE NOT EXISTS
         (SELECT 1 FROM DIM_GOOD TB WHERE TA.COL1 = TB.ITEM_CODE);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*修改CURRENT_FLG当前有效标志，每个商品只保留最新插入的一条记录为'N'
      BY YANGJIN 2017-07-25*/
      UPDATE DIM_GOOD A
         SET A.CURRENT_FLG = 'N', A.W_UPDATE_DT = SYSDATE
       WHERE EXISTS (SELECT 1
                FROM (SELECT C.ITEM_CODE,
                             COUNT(1) CNT,
                             MAX(C.ROW_WID) ROW_WID
                        FROM DIM_GOOD C
                       WHERE C.CURRENT_FLG = 'Y'
                       GROUP BY C.ITEM_CODE
                      HAVING COUNT(1) > 1) B
               WHERE A.ITEM_CODE = B.ITEM_CODE
                 AND A.ROW_WID <> B.ROW_WID
                 AND A.CURRENT_FLG = 'Y');
      UPDATE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*从DIM_EC_GOOD插入DIM_GOOD不存在的商品*/
      /*INSERT INTO DIM_GOOD
      (ITEM_CODE,
       GOODS_COMMONID,
       GOODS_NAME,
       GC_ID,
       GC_NAME,
       MATDL,
       MATDLT,
       MATZL,
       MATZLT,
       MATXL,
       MATXLT,
       BRAND_ID,
       BRAND_NAME,
       GOODS_STATE,
       CREATE_TIME,
       GOOD_PRICE,
       IS_TV,
       IS_KJG,
       MD,
       GROUP_ID,
       GROUP_NAME,
       MATL_GROUP,
       MATXXLT,
       ROW_WID,
       W_INSERT_DT,
       W_UPDATE_DT,
       CURRENT_FLG)
      SELECT A.ITEM_CODE,
             A.GOODS_COMMONID,
             A.GOODS_NAME,
             A.GC_ID,
             A.GC_NAME,
             A.MATDL,
             A.MATDLT,
             A.MATZL,
             A.MATZLT,
             A.MATXL,
             A.MATXLT,
             A.BRAND_ID,
             A.BRAND_NAME,
             A.GOODS_STATE,
             A.GOODS_CREATETIME,
             A.GOODS_PRICE,
             A.IS_TV,
             A.IS_KJG,
             NULL,
             2000,
             '电商提报组',
             A.MATKL,
             A.MATKLT,
             DIM_GOOD_SEQ.NEXTVAL,
             SYSDATE,
             SYSDATE,
             'Y'
        FROM DIM_EC_GOOD A
       WHERE NOT EXISTS (SELECT 1
                FROM DIM_GOOD B
               WHERE A.GOODS_COMMONID = B.GOODS_COMMONID)
         AND A.ITEM_CODE IN (224114,
                             224115,
                             224133,
                             224515,
                             224516,
                             224518,
                             224557,
                             224665,
                             224670);*/
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END DIM_GOOD_FIX;

  PROCEDURE DIM_GOOD_PRICE_LEVEL_UPDATE IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
  
    /*
    功能说明：更新DIM_GOOD.GOOD_PRICE_LEVEL字段，使用GET_DIM_GOOD_PRICE_LEVEL函数  
    作者时间：yangjin  2017-08-31
    */
  
  BEGIN
  
    SP_NAME          := 'YANGJIN_PKG.DIM_GOOD_PRICE_LEVEL_UPDATE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DIM_GOOD'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
    DECLARE
    
    BEGIN
      /*重写DIM_GOOD_PRICE_LEVEL表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE DIM_GOOD_PRICE_LEVEL';
      INSERT INTO DIM_GOOD_PRICE_LEVEL
        SELECT G.*
          FROM (SELECT D.MATL_GROUP,
                       (CASE
                         WHEN D.HIGH_PRICE_LINE > F.PRICE43 * 1.2 THEN
                          F.PRICE43 * 1.2
                         ELSE
                          D.HIGH_PRICE_LINE
                       END) HIGH_PRICE_LINE,
                       (CASE
                         WHEN D.LOW_PRICE_LINE < E.PRICE41 * 0.8 THEN
                          E.PRICE41 * 0.8
                         ELSE
                          D.LOW_PRICE_LINE
                       END) LOW_PRICE_LINE
                  FROM (SELECT A.MATL_GROUP,
                               AVG(NVL(A.GOOD_PRICE, 0)) +
                               STDDEV(NVL(A.GOOD_PRICE, 0)) HIGH_PRICE_LINE,
                               AVG(NVL(A.GOOD_PRICE, 0)) -
                               STDDEV(NVL(A.GOOD_PRICE, 0)) LOW_PRICE_LINE
                          FROM DIM_GOOD A
                         WHERE A.GOOD_PRICE > 0
                           AND A.CURRENT_FLG = 'Y'
                         GROUP BY A.MATL_GROUP, A.MATXXLT) D,
                       (SELECT C.MATL_GROUP, MEDIAN(C.GOOD_PRICE) PRICE41
                          FROM (SELECT A.MATL_GROUP,
                                       A.GOOD_PRICE,
                                       B.MEDIAN_PRICE
                                  FROM (SELECT A1.MATL_GROUP, A1.GOOD_PRICE
                                          FROM DIM_GOOD A1
                                         WHERE A1.GOOD_PRICE > 0
                                           AND A1.CURRENT_FLG = 'Y') A,
                                       (SELECT B1.MATL_GROUP,
                                               MEDIAN(B1.GOOD_PRICE) MEDIAN_PRICE
                                          FROM DIM_GOOD B1
                                         WHERE B1.GOOD_PRICE > 0
                                           AND B1.CURRENT_FLG = 'Y'
                                         GROUP BY B1.MATL_GROUP) B
                                 WHERE A.MATL_GROUP = B.MATL_GROUP(+)) C
                         WHERE C.GOOD_PRICE < C.MEDIAN_PRICE /*商品价格<中位数价格*/
                         GROUP BY C.MATL_GROUP) E,
                       (SELECT C.MATL_GROUP, MEDIAN(C.GOOD_PRICE) PRICE43
                          FROM (SELECT A.MATL_GROUP,
                                       A.GOOD_PRICE,
                                       B.MEDIAN_PRICE
                                  FROM (SELECT A1.MATL_GROUP, A1.GOOD_PRICE
                                          FROM DIM_GOOD A1
                                         WHERE A1.GOOD_PRICE > 0
                                           AND A1.CURRENT_FLG = 'Y') A,
                                       (SELECT B1.MATL_GROUP,
                                               MEDIAN(B1.GOOD_PRICE) MEDIAN_PRICE
                                          FROM DIM_GOOD B1
                                         WHERE B1.GOOD_PRICE > 0
                                           AND B1.CURRENT_FLG = 'Y'
                                         GROUP BY B1.MATL_GROUP) B
                                 WHERE A.MATL_GROUP = B.MATL_GROUP(+)) C
                         WHERE C.GOOD_PRICE > C.MEDIAN_PRICE /*商品价格>中位数价格*/
                         GROUP BY C.MATL_GROUP) F
                 WHERE D.MATL_GROUP = E.MATL_GROUP
                   AND D.MATL_GROUP = F.MATL_GROUP) G;
      COMMIT;
    
      /*更新DIM_GOOD.GOOD_PRICE_LEVEL*/
      UPDATE DIM_GOOD A
         SET A.GOOD_PRICE_LEVEL =
             (SELECT CASE
                       WHEN A.GOOD_PRICE < B.LOW_PRICE_LINE THEN
                        'LOW'
                       WHEN A.GOOD_PRICE >= B.LOW_PRICE_LINE AND
                            A.GOOD_PRICE <= B.HIGH_PRICE_LINE THEN
                        'MEDIUM'
                       WHEN A.GOOD_PRICE > B.HIGH_PRICE_LINE THEN
                        'HIGH'
                     END GOOD_PRICE_LEVEL
                FROM DIM_GOOD_PRICE_LEVEL B
               WHERE A.MATL_GROUP = B.MATL_GROUP)
       WHERE A.GOOD_PRICE > 0
         AND EXISTS (SELECT 1
                FROM DIM_GOOD_PRICE_LEVEL C
               WHERE A.MATL_GROUP = C.MATL_GROUP);
      UPDATE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '无参数';
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END DIM_GOOD_PRICE_LEVEL_UPDATE;

  PROCEDURE DISTRICT_NAME_UPDATE IS
    /*
    功能说明：住宅小区名字更新
    作者时间：yangjin  2017-08-30
    */
  BEGIN
  
    DECLARE
      TYPE TYPE_ARRAYS IS RECORD(
        DISTRICT_NAME VARCHAR2(100));
    
      TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --类似二维数组 
    
      VAR_ARRAY TYPE_ARRAY;
    BEGIN
      /*DISTRICT_LIST逐条取出*/
      SELECT P.DISTRICT_NAME
        BULK COLLECT
        INTO VAR_ARRAY
        FROM DISTRICT_LIST P
       GROUP BY P.DISTRICT_NAME;
      FOR I IN 1 .. VAR_ARRAY.COUNT LOOP
        /*更新DISTRICT_NAME*/
        UPDATE FACT_ECORDER_COMMON A
           SET A.DISTRICT_NAME = REGEXP_SUBSTR(A.RECIVER_INFO,
                                               VAR_ARRAY(I).DISTRICT_NAME)
         WHERE (A.TRANSPZONE BETWEEN 4073 AND 4077 OR A.TRANSPZONE = 5954)
           AND A.DISTRICT_NAME IS NULL;
        COMMIT;
      END LOOP;
    END;
  END DISTRICT_NAME_UPDATE;

  PROCEDURE DATA_ACQUISITION_ITEM_BASE(I_DATE_KEY NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
  
    /*
    功能说明：清洗DATA_ACQUISITION_ITEM表，去除重复数据,插入中间表DATA_ACQUISITION_ITEM_TMP
                然后再插入DATA_ACQUISITION_ITEM_BASE表。
    作者时间：yangjin  2017-11-01
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.DATA_ACQUISITION_ITEM_BASE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DATA_ACQUISITION_ITEM_BASE'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*从源表DATA_ACQUISITION_ITEM取数，去除重复后插入中间表*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE DATA_ACQUISITION_ITEM_TMP';
      INSERT INTO DATA_ACQUISITION_ITEM_TMP
        (PERIOD,
         MATDLT,
         MATZLT,
         MATXLT,
         ACQ_ITEM_CODE,
         ACQ_NAME,
         ACQ_URL,
         ACQ_PIC,
         ACQ_SHOP_NAME,
         ACQ_PRICE,
         ACQ_SALES,
         SALES_AMT)
        SELECT B.PERIOD,
               B.MATDLT,
               B.MATZLT,
               B.MATXLT,
               B.ACQ_ITEM_CODE,
               B.ACQ_NAME,
               B.ACQ_URL,
               B.ACQ_PIC,
               B.ACQ_SHOP_NAME,
               B.ACQ_PRICE,
               B.ACQ_SALES,
               B.SALES_AMT
          FROM (SELECT A.PERIOD,
                       A.MATDLT,
                       A.MATZLT,
                       A.MATXLT,
                       A.ACQ_ITEM_CODE,
                       A.ACQ_NAME,
                       A.ACQ_URL,
                       A.ACQ_PIC,
                       A.ACQ_SHOP_NAME,
                       A.ACQ_PRICE,
                       A.ACQ_SALES,
                       A.SALES_AMT,
                       ROW_NUMBER() OVER(PARTITION BY A.PERIOD, A.ACQ_ITEM_CODE ORDER BY A.DATA_SOURCE, A.PERIOD, A.ACQ_CATEGORY_NAME, A.MATDLT, A.MATZLT, A.MATXLT, A.ACQ_ITEM_CODE, A.ACQ_NAME, A.ACQ_URL, A.ACQ_PIC, A.ACQ_SHOP_NAME, A.ACQ_PRICE, A.ACQ_SALES, A.SALES_AMT, A.INSERT_DATE, A.VALID_FLAG) RN
                  FROM DATA_ACQUISITION_ITEM A
                 WHERE A.PERIOD = I_DATE_KEY
                   AND A.ACQ_ITEM_CODE IS NOT NULL
                   AND A.PERIOD IS NOT NULL) B
         WHERE B.RN = 1;
      COMMIT;
    
      /*从中间表DATA_ACQUISITION_ITEM_TMP插入DATA_ACQUISITION_ITEM_BASE基表*/
      DELETE DATA_ACQUISITION_ITEM_BASE A WHERE A.PERIOD = I_DATE_KEY;
      COMMIT;
      INSERT INTO DATA_ACQUISITION_ITEM_BASE
        (PERIOD,
         MATDLT,
         MATZLT,
         MATXLT,
         ACQ_ITEM_CODE,
         ACQ_NAME,
         ACQ_URL,
         ACQ_PIC,
         ACQ_SHOP_NAME,
         ACQ_PRICE,
         ACQ_SALES,
         SALES_AMT)
        SELECT A.PERIOD,
               A.MATDLT,
               A.MATZLT,
               A.MATXLT,
               A.ACQ_ITEM_CODE,
               A.ACQ_NAME,
               A.ACQ_URL,
               A.ACQ_PIC,
               A.ACQ_SHOP_NAME,
               A.ACQ_PRICE,
               A.ACQ_SALES,
               A.SALES_AMT
          FROM DATA_ACQUISITION_ITEM_TMP A;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数[I_DATE_KEY]:' || I_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END DATA_ACQUISITION_ITEM_BASE;

  PROCEDURE DATA_ACQUISITION_ITEM_CURRENT(I_DATE_KEY NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    V_DATE      DATE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
  
    /*
    功能说明：从DATA_ACQUISITION_ITEM_BASE表取数，计算出当期的销售数量和销售金额写入DATA_ACQUISITION_ITEM_CURRENT表
    作者时间：yangjin  2017-11-01
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.DATA_ACQUISITION_ITEM_CURRENT'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DATA_ACQUISITION_ITEM_CURRENT'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    V_DATE           := TO_DATE(I_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*计算当期的销售数量和销售金额插入DATA_ACQUISITION_ITEM_CURRENT*/
      DELETE DATA_ACQUISITION_ITEM_CURRENT A WHERE A.PERIOD = I_DATE_KEY;
      COMMIT;
      INSERT INTO DATA_ACQUISITION_ITEM_CURRENT
        (PERIOD,
         MATDLT,
         MATZLT,
         MATXLT,
         ACQ_ITEM_CODE,
         ACQ_NAME,
         ACQ_URL,
         ACQ_PIC,
         ACQ_SHOP_NAME,
         ACQ_PRICE,
         CURRENT_ACQ_SALES,
         CURRENT_SALES_AMT)
        SELECT B.PERIOD,
               B.MATDLT,
               B.MATZLT,
               B.MATXLT,
               B.ACQ_ITEM_CODE,
               B.ACQ_NAME,
               B.ACQ_URL,
               B.ACQ_PIC,
               B.ACQ_SHOP_NAME,
               B.ACQ_PRICE,
               B.CURRENT_ACQ_SALES,
               B.CURRENT_SALES_AMT
          FROM (SELECT A.PERIOD,
                       A.MATDLT,
                       A.MATZLT,
                       A.MATXLT,
                       A.ACQ_ITEM_CODE,
                       A.ACQ_NAME,
                       A.ACQ_URL,
                       A.ACQ_PIC,
                       A.ACQ_SHOP_NAME,
                       A.ACQ_PRICE,
                       A.ACQ_SALES - LAG(A.ACQ_SALES, 1, 0) OVER(PARTITION BY A.ACQ_ITEM_CODE ORDER BY A.PERIOD) CURRENT_ACQ_SALES,
                       A.SALES_AMT - LAG(A.SALES_AMT, 1, 0) OVER(PARTITION BY A.ACQ_ITEM_CODE ORDER BY A.PERIOD) CURRENT_SALES_AMT
                  FROM DATA_ACQUISITION_ITEM_BASE A
                 WHERE A.PERIOD BETWEEN TO_CHAR(V_DATE - 4, 'YYYYMMDD') AND
                       TO_CHAR(V_DATE, 'YYYYMMDD')) B
         WHERE B.PERIOD = I_DATE_KEY;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数[I_DATE_KEY]:' || I_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END DATA_ACQUISITION_ITEM_CURRENT;

  PROCEDURE DATA_ACQUISITION_ITEM_MIN_PER IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
  
    /*
    功能说明：DATA_ACQUISITION_ITEM_MIN_PER存放商品的最小period  
    作者时间：yangjin  2017-10-30
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.DATA_ACQUISITION_ITEM_MIN_PER'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DATA_ACQUISITION_ITEM_MIN_PER'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      INSERT INTO DATA_ACQUISITION_ITEM_MIN_PER
        (ACQ_ITEM_CODE, MIN_PERIOD, INSERT_DT)
        SELECT A.ACQ_ITEM_CODE, MIN(A.PERIOD) MIN_PERIOD, SYSDATE INSERT_DT
          FROM DATA_ACQUISITION_ITEM_BASE A
         WHERE A.ACQ_ITEM_CODE IS NOT NULL
           AND NOT EXISTS
         (SELECT 1
                  FROM DATA_ACQUISITION_ITEM_MIN_PER B
                 WHERE A.ACQ_ITEM_CODE = B.ACQ_ITEM_CODE)
         GROUP BY A.ACQ_ITEM_CODE;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '无参数';
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END DATA_ACQUISITION_ITEM_MIN_PER;

  PROCEDURE DATA_ACQUISITION_WEEK_TOPN(I_DATE_KEY NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    EXISTS_ROWS NUMBER;
  
    /*
    功能说明：DATA_ACQUISITION_WEEK_TOPN周销售排行  
    作者时间：yangjin  2017-10-30
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.DATA_ACQUISITION_WEEK_TOPN'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DATA_ACQUISITION_WEEK_TOPN'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*判断数据是否已经插入*/
      SELECT COUNT(1)
        INTO EXISTS_ROWS
        FROM DATA_ACQUISITION_WEEK_TOPN A
       WHERE A.PERIOD = I_DATE_KEY;
      /*如果已经插入则删除*/
      IF EXISTS_ROWS >= 0
      THEN
        DELETE DATA_ACQUISITION_WEEK_TOPN A WHERE A.PERIOD = I_DATE_KEY;
        COMMIT;
      END IF;
    
      /*插入数据*/
      INSERT INTO DATA_ACQUISITION_WEEK_TOPN
        (PERIOD,
         MATDLT,
         MATZLT,
         MATXLT,
         SALES_QTY_TOP_N,
         ACQ_ITEM_CODE,
         ACQ_NAME,
         ACQ_URL,
         ACQ_PIC,
         ACQ_SHOP_NAME,
         ACQ_PRICE,
         SALES_QTY,
         SALES_AMT)
        SELECT D.PERIOD,
               D.MATDLT,
               D.MATZLT,
               D.MATXLT,
               D.SALES_QTY_TOP_N,
               D.ACQ_ITEM_CODE,
               D.ACQ_NAME,
               D.ACQ_URL,
               D.ACQ_PIC,
               D.ACQ_SHOP_NAME,
               D.ACQ_PRICE,
               D.SALES_QTY,
               D.SALES_AMT
          FROM (SELECT C.PERIOD,
                       C.MATDLT,
                       C.MATZLT,
                       C.MATXLT,
                       ROW_NUMBER() OVER(ORDER BY C.SALES_QTY DESC) SALES_QTY_TOP_N, /*根据销售数量排名*/
                       C.ACQ_ITEM_CODE,
                       C.ACQ_NAME,
                       C.ACQ_URL,
                       C.ACQ_PIC,
                       C.ACQ_SHOP_NAME,
                       C.ACQ_PRICE,
                       C.SALES_QTY,
                       C.SALES_AMT
                  FROM (SELECT B.PERIOD,
                               B.MATDLT,
                               B.MATZLT,
                               B.MATXLT,
                               B.ACQ_ITEM_CODE,
                               B.ACQ_NAME,
                               B.ACQ_URL,
                               B.ACQ_PIC,
                               B.ACQ_SHOP_NAME,
                               B.ACQ_PRICE,
                               SUM(B.CURRENT_ACQ_SALES) SALES_QTY,
                               SUM(B.CURRENT_SALES_AMT) SALES_AMT
                          FROM (SELECT A.PERIOD, /*日期*/
                                       A.MATDLT, /*大类名称*/
                                       A.MATZLT, /*中类名称*/
                                       A.MATXLT, /*小类名称*/
                                       A.ACQ_ITEM_CODE, /*商品编码*/
                                       A.ACQ_NAME, /*商品名称*/
                                       A.ACQ_URL, /*商品URL地址*/
                                       A.ACQ_PIC, /*商品图片地址*/
                                       A.ACQ_SHOP_NAME, /*商铺名称*/
                                       A.ACQ_PRICE, /*商品售价*/
                                       A.CURRENT_ACQ_SALES, /*销售数量*/
                                       A.CURRENT_SALES_AMT /*销售金额*/
                                  FROM DATA_ACQUISITION_ITEM_CURRENT A
                                 WHERE A.PERIOD = I_DATE_KEY
                                      /*剔除销售数量或者销售金额<=0*/
                                   AND A.CURRENT_ACQ_SALES > 0
                                   AND A.CURRENT_SALES_AMT > 0) B
                         GROUP BY B.PERIOD,
                                  B.MATDLT,
                                  B.MATZLT,
                                  B.MATXLT,
                                  B.ACQ_ITEM_CODE,
                                  B.ACQ_NAME,
                                  B.ACQ_URL,
                                  B.ACQ_PIC,
                                  B.ACQ_SHOP_NAME,
                                  B.ACQ_PRICE) C) D
         WHERE D.SALES_QTY_TOP_N <= 2000 /*排名前2000*/
         ORDER BY D.SALES_QTY_TOP_N;
    
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数[I_DATE_KEY]:' || I_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END DATA_ACQUISITION_WEEK_TOPN;

  PROCEDURE DATA_ACQUISITION_WEEK_NEW(I_DATE_KEY NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    EXISTS_ROWS NUMBER;
    V_DATE      DATE;
  
    /*
    功能说明：DATA_ACQUISITION_WEEK_TOPN周销售排行  
    作者时间：yangjin  2017-10-30
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.DATA_ACQUISITION_WEEK_NEW'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DATA_ACQUISITION_WEEK_NEW'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    V_DATE           := TO_DATE(I_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*判断数据是否已经插入*/
      SELECT COUNT(1)
        INTO EXISTS_ROWS
        FROM DATA_ACQUISITION_WEEK_NEW A
       WHERE A.PERIOD = I_DATE_KEY;
      /*如果已经插入则删除*/
      IF EXISTS_ROWS >= 0
      THEN
        DELETE DATA_ACQUISITION_WEEK_NEW A WHERE A.PERIOD = I_DATE_KEY;
        COMMIT;
      END IF;
    
      /*插入数据*/
      INSERT INTO DATA_ACQUISITION_WEEK_NEW
        (PERIOD,
         MATDLT,
         MATZLT,
         MATXLT,
         SALES_QTY_TOP_N,
         ACQ_ITEM_CODE,
         ACQ_NAME,
         ACQ_URL,
         ACQ_PIC,
         ACQ_SHOP_NAME,
         ACQ_PRICE,
         SALES_QTY,
         SALES_AMT)
        SELECT D.PERIOD,
               D.MATDLT,
               D.MATZLT,
               D.MATXLT,
               D.SALES_QTY_TOP_N,
               D.ACQ_ITEM_CODE,
               D.ACQ_NAME,
               D.ACQ_URL,
               D.ACQ_PIC,
               D.ACQ_SHOP_NAME,
               D.ACQ_PRICE,
               D.SALES_QTY,
               D.SALES_AMT
          FROM (SELECT C.PERIOD,
                       C.MATDLT,
                       C.MATZLT,
                       C.MATXLT,
                       ROW_NUMBER() OVER(ORDER BY C.SALES_QTY DESC) SALES_QTY_TOP_N, /*根据销售数量排名*/
                       C.ACQ_ITEM_CODE,
                       C.ACQ_NAME,
                       C.ACQ_URL,
                       C.ACQ_PIC,
                       C.ACQ_SHOP_NAME,
                       C.ACQ_PRICE,
                       C.SALES_QTY,
                       C.SALES_AMT
                  FROM (SELECT B.PERIOD,
                               B.MATDLT,
                               B.MATZLT,
                               B.MATXLT,
                               B.ACQ_ITEM_CODE,
                               B.ACQ_NAME,
                               B.ACQ_URL,
                               B.ACQ_PIC,
                               B.ACQ_SHOP_NAME,
                               B.ACQ_PRICE,
                               SUM(B.CURRENT_ACQ_SALES) SALES_QTY,
                               SUM(B.CURRENT_SALES_AMT) SALES_AMT
                          FROM (SELECT A.PERIOD, /*日期*/
                                       A.MATDLT, /*大类名称*/
                                       A.MATZLT, /*中类名称*/
                                       A.MATXLT, /*小类名称*/
                                       A.ACQ_ITEM_CODE, /*商品编码*/
                                       A.ACQ_NAME, /*商品名称*/
                                       A.ACQ_URL, /*商品URL地址*/
                                       A.ACQ_PIC, /*商品图片地址*/
                                       A.ACQ_SHOP_NAME, /*店铺名称*/
                                       A.ACQ_PRICE, /*商品售价*/
                                       A.CURRENT_ACQ_SALES, /*销售数量*/
                                       A.CURRENT_SALES_AMT /*销售金额*/
                                  FROM DATA_ACQUISITION_ITEM_CURRENT A
                                 WHERE A.PERIOD = I_DATE_KEY
                                      /*剔除销售数量或者销售金额<=0*/
                                   AND A.CURRENT_ACQ_SALES > 0
                                   AND A.CURRENT_SALES_AMT > 0
                                   AND EXISTS
                                /*最近六天算为新品*/
                                 (SELECT 1
                                          FROM DATA_ACQUISITION_ITEM_MIN_PER E
                                         WHERE A.ACQ_ITEM_CODE =
                                               E.ACQ_ITEM_CODE
                                           AND E.MIN_PERIOD BETWEEN
                                               TO_CHAR(V_DATE - 6, 'YYYYMMDD') AND
                                               I_DATE_KEY)) B
                         GROUP BY B.PERIOD,
                                  B.MATDLT,
                                  B.MATZLT,
                                  B.MATXLT,
                                  B.ACQ_ITEM_CODE,
                                  B.ACQ_NAME,
                                  B.ACQ_URL,
                                  B.ACQ_PIC,
                                  B.ACQ_SHOP_NAME,
                                  B.ACQ_PRICE) C) D
         ORDER BY D.SALES_QTY_TOP_N;
    
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数[I_DATE_KEY]:' || I_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END DATA_ACQUISITION_WEEK_NEW;

  PROCEDURE DATA_ACQUISITION_MONTH_TOPN(I_DATE_KEY NUMBER) IS
    S_ETL                  W_ETL_LOG%ROWTYPE;
    SP_NAME                S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER            S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS            NUMBER;
    UPDATE_ROWS            NUMBER;
    EXISTS_ROWS            NUMBER;
    V_YEAR_MONTH           NUMBER;
    V_MONTH_FIRST_DATE_KEY NUMBER; /*上月的第一天key*/
    V_MONTH_LAST_DATE_KEY  NUMBER; /*上月的最后一天key*/
  
    /*
    功能说明：DATA_ACQUISITION_MONTH_TOPN月销售排行  
    作者时间：yangjin  2017-10-30
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.DATA_ACQUISITION_MONTH_TOPN'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DATA_ACQUISITION_MONTH_TOPN'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*每月一日执行*/
      IF TO_NUMBER(TO_CHAR(TO_DATE(I_DATE_KEY, 'YYYYMMDD'), 'DD')) = 1
      THEN
        /*日期初始化*/
        V_MONTH_LAST_DATE_KEY  := TO_CHAR(TRUNC(TO_DATE(I_DATE_KEY,
                                                        'YYYYMMDD'),
                                                'MM') - 1,
                                          'YYYYMMDD');
        V_MONTH_FIRST_DATE_KEY := TO_CHAR(TRUNC(TO_DATE(V_MONTH_LAST_DATE_KEY,
                                                        'YYYYMMDD'),
                                                'MM'),
                                          'YYYYMMDD');
        V_YEAR_MONTH           := TO_CHAR(TO_DATE(V_MONTH_LAST_DATE_KEY,
                                                  'YYYYMMDD'),
                                          'YYYYMM');
        /*判断数据是否已经插入*/
        SELECT COUNT(1)
          INTO EXISTS_ROWS
          FROM DATA_ACQUISITION_MONTH_TOPN A
         WHERE A.YEAR_MONTH = V_YEAR_MONTH;
        /*如果已经插入则删除*/
        IF EXISTS_ROWS >= 0
        THEN
          DELETE DATA_ACQUISITION_MONTH_TOPN A
           WHERE A.YEAR_MONTH = V_YEAR_MONTH;
          COMMIT;
        END IF;
      
        /*插入数据*/
        INSERT INTO DATA_ACQUISITION_MONTH_TOPN
          (YEAR_MONTH,
           MATDLT,
           MATZLT,
           MATXLT,
           SALES_QTY_TOP_N,
           ACQ_ITEM_CODE,
           ACQ_NAME,
           ACQ_URL,
           ACQ_PIC,
           ACQ_SHOP_NAME,
           ACQ_PRICE,
           SALES_QTY,
           SALES_AMT)
          SELECT D.YEAR_MONTH,
                 D.MATDLT,
                 D.MATZLT,
                 D.MATXLT,
                 D.SALES_QTY_TOP_N,
                 D.ACQ_ITEM_CODE,
                 D.ACQ_NAME,
                 D.ACQ_URL,
                 D.ACQ_PIC,
                 D.ACQ_SHOP_NAME,
                 D.ACQ_PRICE,
                 D.SALES_QTY,
                 D.SALES_AMT
            FROM (SELECT C.YEAR_MONTH,
                         C.MATDLT,
                         C.MATZLT,
                         C.MATXLT,
                         ROW_NUMBER() OVER(ORDER BY C.SALES_QTY DESC) SALES_QTY_TOP_N, /*根据销售数量排名*/
                         C.ACQ_ITEM_CODE,
                         C.ACQ_NAME,
                         C.ACQ_URL,
                         C.ACQ_PIC,
                         C.ACQ_SHOP_NAME,
                         C.ACQ_PRICE,
                         C.SALES_QTY,
                         C.SALES_AMT
                    FROM (SELECT SUBSTR(B.PERIOD, 1, 6) YEAR_MONTH,
                                 B.MATDLT,
                                 B.MATZLT,
                                 B.MATXLT,
                                 B.ACQ_ITEM_CODE,
                                 B.ACQ_NAME,
                                 B.ACQ_URL,
                                 B.ACQ_PIC,
                                 B.ACQ_SHOP_NAME,
                                 B.ACQ_PRICE,
                                 SUM(B.CURRENT_ACQ_SALES) SALES_QTY,
                                 SUM(B.CURRENT_ACQ_SALES) SALES_AMT
                            FROM (SELECT A.PERIOD, /*日期*/
                                         A.MATDLT, /*大类名称*/
                                         A.MATZLT, /*中类名称*/
                                         A.MATXLT, /*小类名称*/
                                         A.ACQ_ITEM_CODE, /*商品编码*/
                                         A.ACQ_NAME, /*商品名称*/
                                         A.ACQ_URL, /*商品URL地址*/
                                         A.ACQ_PIC, /*商品图片地址*/
                                         A.ACQ_SHOP_NAME, /*商铺名称*/
                                         A.ACQ_PRICE, /*商品售价*/
                                         A.CURRENT_ACQ_SALES, /*销售数量*/
                                         A.CURRENT_SALES_AMT /*销售金额*/
                                    FROM DATA_ACQUISITION_ITEM_CURRENT A
                                   WHERE A.PERIOD BETWEEN
                                         V_MONTH_FIRST_DATE_KEY AND
                                         V_MONTH_LAST_DATE_KEY
                                        /*剔除销售数量或者销售金额<=0*/
                                     AND A.CURRENT_ACQ_SALES > 0
                                     AND A.CURRENT_SALES_AMT > 0) B
                           GROUP BY SUBSTR(B.PERIOD, 1, 6),
                                    B.MATDLT,
                                    B.MATZLT,
                                    B.MATXLT,
                                    B.ACQ_ITEM_CODE,
                                    B.ACQ_NAME,
                                    B.ACQ_URL,
                                    B.ACQ_PIC,
                                    B.ACQ_SHOP_NAME,
                                    B.ACQ_PRICE) C) D
           WHERE D.SALES_QTY_TOP_N <= 2000 /*排名前2000*/
           ORDER BY D.SALES_QTY_TOP_N;
        INSERT_ROWS := SQL%ROWCOUNT;
        COMMIT;
      END IF;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:' || I_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END DATA_ACQUISITION_MONTH_TOPN;

  PROCEDURE DATA_ACQUISITION_MONTH_NEW(I_DATE_KEY NUMBER) IS
    S_ETL                      W_ETL_LOG%ROWTYPE;
    SP_NAME                    S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER                S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS                NUMBER;
    UPDATE_ROWS                NUMBER;
    EXISTS_ROWS                NUMBER;
    V_YEAR_MONTH               NUMBER;
    V_MONTH_FIRST_DATE_KEY     NUMBER; /*上月的第一天key*/
    V_MONTH_LAST_DATE_KEY      NUMBER; /*上月的最后一天key*/
    V_AGO_MONTH_FIRST_DATE_KEY NUMBER;
    V_AGO_MONTH_LAST_DATE_KEY  NUMBER;
  
    /*
    功能说明：DATA_ACQUISITION_MONTH_NEW月新品销售排行  
    作者时间：yangjin  2017-10-30
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.DATA_ACQUISITION_MONTH_NEW'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DATA_ACQUISITION_MONTH_NEW'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*每月一日执行*/
      IF TO_NUMBER(TO_CHAR(TO_DATE(I_DATE_KEY, 'YYYYMMDD'), 'DD')) = 1
      THEN
        /*日期初始化*/
        /*上月最后一天*/
        V_MONTH_LAST_DATE_KEY := TO_CHAR(TRUNC(TO_DATE(I_DATE_KEY,
                                                       'YYYYMMDD'),
                                               'MM') - 1,
                                         'YYYYMMDD');
        /*上月第一天*/
        V_MONTH_FIRST_DATE_KEY := TO_CHAR(TRUNC(TO_DATE(V_MONTH_LAST_DATE_KEY,
                                                        'YYYYMMDD'),
                                                'MM'),
                                          'YYYYMMDD');
        V_YEAR_MONTH           := TO_CHAR(TO_DATE(V_MONTH_LAST_DATE_KEY,
                                                  'YYYYMMDD'),
                                          'YYYYMM');
        /*上上月最后一天*/
        V_AGO_MONTH_LAST_DATE_KEY := TO_CHAR(TO_DATE(V_MONTH_FIRST_DATE_KEY,
                                                     'YYYYMMDD') - 1,
                                             'YYYYMMDD');
        /*上上月第一天*/
        V_AGO_MONTH_FIRST_DATE_KEY := TO_CHAR(TRUNC(TO_DATE(V_AGO_MONTH_LAST_DATE_KEY,
                                                            'YYYYMMDD'),
                                                    'MM'),
                                              'YYYYMMDD');
        /*判断数据是否已经插入*/
        SELECT COUNT(1)
          INTO EXISTS_ROWS
          FROM DATA_ACQUISITION_MONTH_TOPN A
         WHERE A.YEAR_MONTH = V_YEAR_MONTH;
        /*如果已经插入则删除*/
        IF EXISTS_ROWS >= 0
        THEN
          DELETE DATA_ACQUISITION_MONTH_TOPN A
           WHERE A.YEAR_MONTH = V_YEAR_MONTH;
          COMMIT;
        END IF;
      
        /*插入数据*/
        INSERT INTO DATA_ACQUISITION_MONTH_NEW
          (YEAR_MONTH,
           MATDLT,
           MATZLT,
           MATXLT,
           SALES_QTY_TOP_N,
           ACQ_ITEM_CODE,
           ACQ_NAME,
           ACQ_URL,
           ACQ_PIC,
           ACQ_SHOP_NAME,
           ACQ_PRICE,
           SALES_QTY,
           SALES_AMT)
          SELECT D.YEAR_MONTH,
                 D.MATDLT,
                 D.MATZLT,
                 D.MATXLT,
                 D.SALES_QTY_TOP_N,
                 D.ACQ_ITEM_CODE,
                 D.ACQ_NAME,
                 D.ACQ_URL,
                 D.ACQ_PIC,
                 D.ACQ_SHOP_NAME,
                 D.ACQ_PRICE,
                 D.SALES_QTY,
                 D.SALES_AMT
            FROM (SELECT C.YEAR_MONTH,
                         C.MATDLT,
                         C.MATZLT,
                         C.MATXLT,
                         ROW_NUMBER() OVER(ORDER BY C.SALES_QTY DESC) SALES_QTY_TOP_N, /*根据销售数量排名*/
                         C.ACQ_ITEM_CODE,
                         C.ACQ_NAME,
                         C.ACQ_URL,
                         C.ACQ_PIC,
                         C.ACQ_SHOP_NAME,
                         C.ACQ_PRICE,
                         C.SALES_QTY,
                         C.SALES_AMT
                    FROM (SELECT SUBSTR(B.PERIOD, 1, 6) YEAR_MONTH,
                                 B.MATDLT,
                                 B.MATZLT,
                                 B.MATXLT,
                                 B.ACQ_ITEM_CODE,
                                 B.ACQ_NAME,
                                 B.ACQ_URL,
                                 B.ACQ_PIC,
                                 B.ACQ_SHOP_NAME,
                                 B.ACQ_PRICE,
                                 SUM(B.CURRENT_ACQ_SALES) SALES_QTY,
                                 SUM(B.CURRENT_SALES_AMT) SALES_AMT
                            FROM (SELECT A.PERIOD, /*日期*/
                                         A.MATDLT, /*大类名称*/
                                         A.MATZLT, /*中类名称*/
                                         A.MATXLT, /*小类名称*/
                                         A.ACQ_ITEM_CODE, /*商品编码*/
                                         A.ACQ_NAME, /*商品名称*/
                                         A.ACQ_URL, /*商品URL地址*/
                                         A.ACQ_PIC, /*商品图片地址*/
                                         A.ACQ_SHOP_NAME, /*店铺名称*/
                                         A.ACQ_PRICE, /*商品售价*/
                                         A.CURRENT_ACQ_SALES, /*销售数量*/
                                         A.CURRENT_SALES_AMT /*销售金额*/
                                    FROM DATA_ACQUISITION_ITEM_CURRENT A
                                   WHERE A.PERIOD BETWEEN
                                         V_MONTH_FIRST_DATE_KEY AND
                                         V_MONTH_LAST_DATE_KEY
                                        /*剔除销售数量或者销售金额<=0*/
                                     AND A.CURRENT_ACQ_SALES > 0
                                     AND A.CURRENT_SALES_AMT > 0
                                     AND EXISTS
                                  /*从上上月的第一天到上月最后一天应该都算新品*/
                                   (SELECT 1
                                            FROM DATA_ACQUISITION_ITEM_MIN_PER E
                                           WHERE A.ACQ_ITEM_CODE =
                                                 E.ACQ_ITEM_CODE
                                             AND E.MIN_PERIOD BETWEEN
                                                 V_AGO_MONTH_FIRST_DATE_KEY AND
                                                 V_MONTH_LAST_DATE_KEY)) B
                           GROUP BY SUBSTR(B.PERIOD, 1, 6),
                                    B.MATDLT,
                                    B.MATZLT,
                                    B.MATXLT,
                                    B.ACQ_ITEM_CODE,
                                    B.ACQ_NAME,
                                    B.ACQ_URL,
                                    B.ACQ_PIC,
                                    B.ACQ_SHOP_NAME,
                                    B.ACQ_PRICE) C) D
           ORDER BY D.SALES_QTY_TOP_N;
        INSERT_ROWS := SQL%ROWCOUNT;
        COMMIT;
      END IF;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:' || I_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END DATA_ACQUISITION_MONTH_NEW;

  PROCEDURE EC_NEW_MEMBER_TRACK_BASE(I_DATE_KEY NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    I_DATE      DATE;
  
    /*
    功能说明：用于跟踪ec会员0-5单的订购情况，此表为基表，在此表基础上计算0-5单顺序 
    作者时间：yangjin  2017-11-09
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.EC_NEW_MEMBER_TRACK_BASE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_EC_MEMBER_TRACK_BASE'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    I_DATE           := TO_DATE(I_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      MERGE /*+APPEND*/
      INTO OPER_EC_MEMBER_TRACK_BASE T
      USING (SELECT C.MEMBER_BP,
                    C.ADD_TIME,
                    C.ORDER_ID,
                    C.SALES_SOURCE_SECOND_DESC,
                    C.ORDER_STATE,
                    NVL(C.PROMOTION_DESC, '无优惠') PROMOTION_DESC,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM (SELECT A.MEMBER_BP,
                            A.ADD_TIME,
                            A.ORDER_ID,
                            A.SALES_SOURCE_SECOND_DESC,
                            A.ORDER_STATE,
                            /*促销方式之间用逗号分割*/
                            LISTAGG(A.PROMOTION_DESC, ',') WITHIN GROUP(ORDER BY A.PROMOTION_DESC) PROMOTION_DESC
                       FROM (SELECT DISTINCT OH.CUST_NO MEMBER_BP, /*BP号*/
                                             OH.ADD_TIME, /*订单日期*/
                                             OH.ORDER_ID, /*订单编号*/
                                             CASE
                                               WHEN OH.APP_NAME IN
                                                    ('KLGAndroid', 'KLGiPhone') THEN
                                                'A20017'
                                               WHEN OH.APP_NAME = 'KLGPortal' THEN
                                                'A20020'
                                               WHEN OH.APP_NAME = 'KLGWX' THEN
                                                'A20021'
                                               WHEN OH.APP_NAME = 'KLGMPortal' THEN
                                                'A20022'
                                             END SALES_SOURCE_SECOND_DESC, /*渠道*/
                                             OH.ORDER_STATE, /*订单状态*/
                                             CASE
                                               WHEN OG.GOODS_TYPE = 3 THEN
                                                '限时商品促销'
                                             
                                               WHEN OG.PML_DISCOUNT <> 0 THEN
                                                '等级减'
                                             
                                               WHEN OG.TV_DISCOUNT_AMOUNT <> 0 THEN
                                                'TV直播立减'
                                             
                                               WHEN OH.DISCOUNT_MANSONG_AMOUNT <> 0 THEN
                                                '满立减'
                                             
                                               WHEN OH.DISCOUNT_PAYMENTWAY_AMOUNT <> 0 OR
                                                    OH.DISCOUNT_PAYMENTCHANEL_AMOUNT <> 0 THEN
                                                '支付立减'
                                             END PROMOTION_DESC /*优惠方式*/
                               FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
                              WHERE OH.ORDER_ID = OG.ORDER_ID
                                   /*同步最近一个月数据*/
                                AND OH.ADD_TIME BETWEEN I_DATE - 30 AND I_DATE) A
                      GROUP BY A.MEMBER_BP,
                               A.ADD_TIME,
                               A.ORDER_ID,
                               A.SALES_SOURCE_SECOND_DESC,
                               A.ORDER_STATE) C) S
      ON (T.ORDER_ID = S.ORDER_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.MEMBER_BP                = S.MEMBER_BP,
               T.ADD_TIME                 = S.ADD_TIME,
               T.SALES_SOURCE_SECOND_DESC = S.SALES_SOURCE_SECOND_DESC,
               T.ORDER_STATE              = S.ORDER_STATE,
               T.PROMOTION_DESC           = S.PROMOTION_DESC,
               T.W_UPDATE_DT              = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MEMBER_BP,
           T.ADD_TIME,
           T.ORDER_ID,
           T.SALES_SOURCE_SECOND_DESC,
           T.ORDER_STATE,
           T.PROMOTION_DESC,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.MEMBER_BP,
           S.ADD_TIME,
           S.ORDER_ID,
           S.SALES_SOURCE_SECOND_DESC,
           S.ORDER_STATE,
           S.PROMOTION_DESC,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
    
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:' || I_DATE_KEY;
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END EC_NEW_MEMBER_TRACK_BASE;

  PROCEDURE EC_NEW_MEMBER_TRACK_RANK IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
  
    /*
    功能说明：计算ec会员的第几单
    作者时间：yangjin  2017-11-09
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.EC_NEW_MEMBER_TRACK_RANK'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_EC_MEMBER_TRACK_RANK'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_EC_MEMBER_TRACK_RANK';
      INSERT INTO OPER_EC_MEMBER_TRACK_RANK A
        (A.MEMBER_BP,
         A.ADD_TIME,
         A.ORDER_ID,
         A.SALES_SOURCE_SECOND_DESC,
         A.PROMOTION_DESC,
         A.RANK1)
        SELECT B.MEMBER_BP,
               B.ADD_TIME,
               B.ORDER_ID,
               B.SALES_SOURCE_SECOND_DESC,
               B.PROMOTION_DESC,
               B.RANK1
          FROM (SELECT A.MEMBER_BP,
                       A.ADD_TIME,
                       A.ORDER_ID,
                       A.SALES_SOURCE_SECOND_DESC,
                       A.PROMOTION_DESC,
                       /*根据ADD_TIME,ORDER_ID来排序订购顺序*/
                       RANK() OVER(PARTITION BY A.MEMBER_BP ORDER BY A.ADD_TIME, A.ORDER_ID) RANK1
                  FROM OPER_EC_MEMBER_TRACK_BASE A
                 WHERE A.ORDER_STATE >= 30) B
         WHERE B.RANK1 <= 5;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '无参数';
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END EC_NEW_MEMBER_TRACK_RANK;

  PROCEDURE MERGE_DIM_MEMBER_ZONE IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
  
    /*
    功能说明：会员的地区表
    作者时间：yangjin  2017-11-22
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.MERGE_DIM_MEMBER_ZONE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DIM_MEMBER_ZONE'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      MERGE /*+APPEND*/
      INTO DIM_MEMBER_ZONE T
      USING (SELECT A.MEMBER_BP,
                    B.ZONE,
                    B.VTEXT1,
                    B.VTEXT2,
                    B.VTEXT3,
                    B.VTEXT4
               FROM DIM_MEMBER A, DIM_ZONE B
              WHERE A.MEMBER_ZONE = B.ZONE
                   /*分二种情况：1、member_zone已经变更，2、新增BP号*/
                AND (EXISTS
                     (SELECT 1
                        FROM DIM_MEMBER_ZONE C
                       WHERE A.MEMBER_BP = C.MEMBER_BP
                         AND A.MEMBER_ZONE <> C.ZONE) OR NOT EXISTS
                     (SELECT 1
                        FROM DIM_MEMBER_ZONE D
                       WHERE A.MEMBER_BP = D.MEMBER_BP))) S
      ON (T.MEMBER_BP = S.MEMBER_BP)
      WHEN MATCHED THEN
        UPDATE
           SET T.ZONE   = S.ZONE,
               T.VTEXT1 = S.VTEXT1,
               T.VTEXT2 = S.VTEXT2,
               T.VTEXT3 = S.VTEXT3,
               T.VTEXT4 = S.VTEXT4
      WHEN NOT MATCHED THEN
        INSERT
          (T.MEMBER_BP, T.ZONE, T.VTEXT1, T.VTEXT2, T.VTEXT3, T.VTEXT4)
        VALUES
          (S.MEMBER_BP, S.ZONE, S.VTEXT1, S.VTEXT2, S.VTEXT3, S.VTEXT4);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '无参数';
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END MERGE_DIM_MEMBER_ZONE;

  PROCEDURE FACT_TV_QRC_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
  
    /*
    功能说明：TV商品扫码行为记录
    作者时间：yangjin  2018-01-31
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.FACT_TV_QRC_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_TV_QRC'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*删除当天数据*/
      DELETE FACT_TV_QRC A WHERE A.VISIT_DATE_KEY = IN_POSTING_DATE_KEY;
      COMMIT;
    
      /*插入数据*/
      INSERT INTO FACT_TV_QRC
        (VID,
         VISIT_DATE_KEY,
         VISIT_DATE,
         TV_START_TIME,
         TV_END_TIME,
         ITEM_CODE,
         W_INSERT_DT,
         W_UPDATE_DT)
        SELECT DISTINCT A.VID,
                        TO_CHAR(A.VISIT_DATE, 'YYYYMMDD') VISIT_DATE_KEY,
                        A.VISIT_DATE,
                        B.TV_START_TIME,
                        B.TV_END_TIME,
                        B.ITEM_CODE,
                        SYSDATE W_INSERT_DT,
                        SYSDATE W_UPDATE_DT
          FROM (SELECT VID, VISIT_DATE
                  FROM FACT_PAGE_VIEW
                 WHERE VISIT_DATE_KEY = IN_POSTING_DATE_KEY
                   AND PAGE_NAME = 'TV_QRC') A,
               (SELECT TV_START_TIME,
                       /*如果时间为23:59:00，则取值23:59:59，其余不变*/
                       DECODE(TO_CHAR(TV_END_TIME, 'hh24:mi:ss'),
                              '23:59:00',
                              TV_END_TIME + 59 / 86400,
                              TV_END_TIME) TV_END_TIME,
                       ITEM_CODE
                  FROM DIM_TV_GOOD
                 WHERE TV_STARTDAY_KEY = IN_POSTING_DATE_KEY) B
         WHERE A.VISIT_DATE BETWEEN B.TV_START_TIME AND B.TV_END_TIME;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END FACT_TV_QRC_PROC;

  PROCEDURE CR_DATA_BASE_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
  
    /*
    功能说明：商品推荐基础表，用于阿里云的输入数据。
    作者时间：yangjin  2018-02-07
    */
  
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.CR_DATA_BASE_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'CR_DATA_BASE'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*删除当天数据*/
      DELETE CR_DATA_BASE A WHERE A.ACTIVE_DATE = IN_POSTING_DATE_KEY;
      COMMIT;
    
      /*插入数据
      0表示点击，1表示购买，2表示收藏，3表示购物车*/
      INSERT INTO CR_DATA_BASE
        (USER_ID, ITEM_ID, ACTIVE_TYPE, ACTIVE_DATE)
      /*active_type=0*/
        SELECT DISTINCT TO_CHAR(A1.MEMBER_KEY) USER_ID,
                        TO_CHAR(A1.PAGE_VALUE) AS ITEM_ID,
                        0 ACTIVE_TYPE,
                        TO_CHAR(A1.VISIT_DATE_KEY) ACTIVE_DATE
          FROM FACT_PAGE_VIEW A1
         WHERE A1.PAGE_KEY IN
               (1924, 2303, 2841, 2842, 11586, 24146, 38629, 40899, 40903)
           AND REGEXP_LIKE(A1.PAGE_VALUE, '^[1-9]\d{5}$')
           AND A1.VISIT_DATE_KEY = IN_POSTING_DATE_KEY
           AND A1.MEMBER_KEY <> 0
        UNION ALL
        /*active_type=1*/
        SELECT TO_CHAR(A2.MEMBER_KEY) USER_ID,
               TO_CHAR(A2.GOODS_COMMON_KEY) ITEM_ID,
               1 ACTIVE_TYPE,
               TO_CHAR(A2.POSTING_DATE_KEY) ACTIVE_DATE
          FROM FACT_GOODS_SALES A2
         WHERE A2.ORDER_STATE = 1
           AND A2.ORDER_AMOUNT > 0 /*剔除赠品*/
           AND A2.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
        UNION ALL
        /*active_type=2*/
        SELECT (SELECT TO_CHAR(MAX(B3.MEMBER_CRMBP))
                  FROM FACT_ECMEMBER B3
                 WHERE A3.MEMBER_ID = B3.MEMBER_ID) USER_ID,
               TO_CHAR(A3.FAV_ID) ITEM_ID,
               2 ACTIVE_TYPE,
               TO_CHAR(A3.FAV_TIME) ACTIVE_DATE
          FROM FACT_FAVORITES A3
         WHERE A3.FAV_TYPE = 'goods'
           AND A3.FAV_TIME = IN_POSTING_DATE_KEY
        UNION ALL
        /*active_type=3*/
        SELECT TO_CHAR(A4.MEMBER_KEY) USER_ID,
               TO_CHAR(A4.SCGID) ITEM_ID,
               3 ACTIVE_TYPE,
               TO_CHAR(A4.CREATE_DATE_KEY) ACTIVE_DATE
          FROM FACT_SHOPPINGCAR A4
         WHERE A4.PAGE_KEY IN (297, 11586)
           AND A4.CREATE_DATE_KEY = IN_POSTING_DATE_KEY
           AND A4.MEMBER_KEY <> 0;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
    S_ETL.ETL_DURATION   := TRUNC((S_ETL.END_TIME - S_ETL.START_TIME) *
                                  86400);
    SP_SBI_W_ETL_LOG(S_ETL);
  EXCEPTION
    WHEN OTHERS THEN
      S_ETL.END_TIME   := SYSDATE;
      S_ETL.ETL_STATUS := 'FAILURE';
      S_ETL.ERR_MSG    := SQLERRM;
      SP_SBI_W_ETL_LOG(S_ETL);
      RETURN;
  END CR_DATA_BASE_PROC;

END YANGJIN_PKG;
/
