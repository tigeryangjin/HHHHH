CREATE OR REPLACE PACKAGE YANGJIN_PKG_TEST IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-05-31 10:41:42
  -- PURPOSE : YANGJIN PACKAGE

  FUNCTION value RETURN NUMBER
    PARALLEL_ENABLE;
  PRAGMA restrict_references(value, WNDS);

  PROCEDURE seed(val IN VARCHAR2);
  PRAGMA restrict_references(seed, WNDS);

  TYPE num_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

  PROCEDURE OPER_TRAFFIC_ANALYSIS_PROC(IN_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_TRAFFIC_ANALYSIS_PROC
  目的:         流量分析报表
  作者:         yangjin
  创建时间：    2018/04/16
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_CLICK_ANALYSIS_PROC(IN_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_CLICK_ANALYSIS_PROC
  目的:         点击分析报表
  作者:         yangjin
  创建时间：    2018/04/17
  最后修改人：
  最后更改日期：
  */

END YANGJIN_PKG_TEST;
/
CREATE OR REPLACE PACKAGE BODY YANGJIN_PKG_TEST IS
  counter    BINARY_INTEGER := 55;
  need_init  BOOLEAN := TRUE;
  mem        num_array;
  saved_norm NUMBER := NULL;

  FUNCTION value RETURN NUMBER
    PARALLEL_ENABLE IS
    randval NUMBER;
  BEGIN
    counter := counter + 1;
    IF counter >= 55
    THEN
    
      -- initialize if needed
      IF (need_init = TRUE)
      THEN
        seed(TO_CHAR(SYSDATE, 'MM-DD-YYYY HH24:MI:SS') || USER ||
             USERENV('SESSIONID'));
      ELSE
        -- need to generate 55 more results
        FOR i IN 0 .. 30 LOOP
          randval := mem(i + 24) + mem(i);
          IF (randval >= 1.0)
          THEN
            randval := randval - 1.0;
          END IF;
          mem(i) := randval;
        END LOOP;
        FOR i IN 31 .. 54 LOOP
          randval := mem(i - 31) + mem(i);
          IF (randval >= 1.0)
          THEN
            randval := randval - 1.0;
          END IF;
          mem(i) := randval;
        END LOOP;
      END IF;
      counter := 0;
    END IF;
    RETURN mem(counter);
  END value;

  PROCEDURE seed(val IN VARCHAR2) IS
    junk    VARCHAR2(2000);
    piece   VARCHAR2(20);
    randval NUMBER;
    mytemp  NUMBER;
    j       BINARY_INTEGER;
  BEGIN
    need_init  := FALSE;
    saved_norm := NULL;
    counter    := 0;
    junk       := TO_SINGLE_BYTE(val);
    FOR i IN 0 .. 54 LOOP
      piece   := SUBSTR(junk, 1, 19);
      randval := 0;
      j       := 1;
    
      -- convert 19 characters to a 38-digit number
      FOR j IN 1 .. 19 LOOP
        randval := 1e2 * randval + NVL(ASCII(SUBSTR(piece, j, 1)), 0.0);
      END LOOP;
    
      -- try to avoid lots of zeros
      randval := randval * 1e-38 +
                 i * .01020304050607080910111213141516171819;
      mem(i) := randval - TRUNC(randval);
    
      -- we've handled these first 19 characters already; move on
      junk := SUBSTR(junk, 20);
    END LOOP;
  
    randval := mem(54);
    FOR j IN 0 .. 10 LOOP
      FOR i IN 0 .. 54 LOOP
      
        -- barrelshift mem(i-1) by 24 digits
        randval := randval * 1e24;
        mytemp  := TRUNC(randval);
        randval := (randval - mytemp) + (mytemp * 1e-38);
      
        -- add it to mem(i)
        randval := mem(i) + randval;
        IF (randval >= 1.0)
        THEN
          randval := randval - 1.0;
        END IF;
      
        -- record the result
        mem(i) := randval;
      END LOOP;
    END LOOP;
  END seed;

  PROCEDURE OPER_TRAFFIC_ANALYSIS_PROC(IN_DATE_KEY IN NUMBER) IS
    /*
    功能说明：
    作者时间：yangjin  2018-04-16
    */
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_TRAFFIC_ANALYSIS_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_TRAFFIC_ANALYSIS'; --此处需要手工录入该PROCEDURE操作的表格
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
    
      DELETE OPER_TRAFFIC_ANALYSIS A WHERE A.DATE_KEY = IN_DATE_KEY;
      COMMIT;
    
      INSERT INTO OPER_TRAFFIC_ANALYSIS
        (DATE_KEY,
         CHANNEL,
         PAGE_NAME,
         ALL_PV,
         ALL_UV,
         ALL_STAY_TIME,
         ALL_BOUNCE_UV,
         NEW_PV,
         NEW_UV,
         NEW_STAY_TIME,
         NEW_BOUNCE_UV,
         OLD_PV,
         OLD_UV,
         OLD_STAY_TIME,
         OLD_BOUNCE_UV,
         W_INSERT_DT,
         W_UPDATE_DT)
        WITH DIM AS
         (SELECT DIM1.DATE_KEY, DIM2.CHANNEL, DIM3.PAGE_NAME
            FROM (SELECT IN_DATE_KEY DATE_KEY FROM DUAL) DIM1,
                 (SELECT 'APP' CHANNEL
                    FROM DUAL
                  UNION
                  SELECT '小程序' CHANNEL
                    FROM DUAL) DIM2,
                 /*PAGE_NAME,如果要添加page_name可以在此处添加*/
                 (SELECT 'Dau' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'Home' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'Home_TVLive' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'TV_home' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'Channel' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'Good' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'Search' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'Member' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'PayEnd' PAGE_NAME
                    FROM DUAL) DIM3),
        DP AS
         (SELECT F.VISIT_DATE_KEY DATE_KEY,
                 F.CHANNEL,
                 'Dau' PAGE_NAME,
                 COUNT(F.ALL_PAGE_VIEW_KEY) ALL_PV,
                 COUNT(DISTINCT F.ALL_VID) ALL_UV,
                 ROUND(AVG(F.ALL_PAGE_STAY_TIME)) ALL_STAY_TIME,
                 COUNT(F.NEW_PAGE_VIEW_KEY) NEW_PV,
                 COUNT(DISTINCT F.NEW_VID) NEW_UV,
                 ROUND(AVG(F.NEW_PAGE_STAY_TIME)) NEW_STAY_TIME,
                 COUNT(F.OLD_PAGE_VIEW_KEY) OLD_PV,
                 COUNT(DISTINCT F.OLD_VID) OLD_UV,
                 ROUND(AVG(F.OLD_PAGE_STAY_TIME)) OLD_STAY_TIME
            FROM (SELECT E.VISIT_DATE_KEY,
                         E.CHANNEL,
                         E.PAGE_VIEW_KEY ALL_PAGE_VIEW_KEY,
                         E.VID ALL_VID,
                         E.PAGE_STAY_TIME ALL_PAGE_STAY_TIME,
                         CASE
                           WHEN IS_NEW = 1 THEN
                            E.PAGE_VIEW_KEY
                         END NEW_PAGE_VIEW_KEY,
                         CASE
                           WHEN IS_NEW = 0 THEN
                            E.PAGE_VIEW_KEY
                         END OLD_PAGE_VIEW_KEY,
                         --
                         CASE
                           WHEN IS_NEW = 1 THEN
                            E.VID
                         END NEW_VID,
                         CASE
                           WHEN IS_NEW = 0 THEN
                            E.VID
                         END OLD_VID,
                         --
                         CASE
                           WHEN IS_NEW = 1 THEN
                            E.PAGE_STAY_TIME
                         END NEW_PAGE_STAY_TIME,
                         CASE
                           WHEN IS_NEW = 0 THEN
                            E.PAGE_STAY_TIME
                         END OLD_PAGE_STAY_TIME
                    FROM (SELECT D.VISIT_DATE_KEY,
                                 CASE
                                   WHEN D.APPLICATION_KEY IN (10, 20) THEN
                                    'APP'
                                   WHEN D.APPLICATION_KEY = 70 THEN
                                    '小程序'
                                 END CHANNEL,
                                 D.PAGE_VIEW_KEY,
                                 D.VID,
                                 D.PAGE_STAYTIME PAGE_STAY_TIME,
                                 CASE
                                   WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') >
                                        D.FIRST_ORDER_DATE THEN
                                    0
                                   WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') <=
                                        D.FIRST_ORDER_DATE THEN
                                    1
                                 END IS_NEW /*是否新会员标志，1:新会员、0:老会员*/
                            FROM (SELECT A.VISIT_DATE_KEY,
                                         A.APPLICATION_KEY,
                                         A.PAGE_VIEW_KEY,
                                         A.VID,
                                         A.PAGE_STAYTIME,
                                         NVL(C.FIRST_ORDER_DATE,
                                             DATE '2000-01-01') FIRST_ORDER_DATE /*首单订购日期*/
                                    FROM FACT_PAGE_VIEW A,
                                         (SELECT B.VID,
                                                 TRUNC(MIN(B.ADD_TIME)) FIRST_ORDER_DATE
                                            FROM FACT_EC_ORDER_2 B
                                           GROUP BY B.VID) C
                                   WHERE A.VID = C.VID(+)
                                     AND A.VISIT_DATE_KEY = IN_DATE_KEY
                                        /*APP、小程序*/
                                     AND A.APPLICATION_KEY IN (10, 20, 70)) D) E) F
           GROUP BY F.VISIT_DATE_KEY, F.CHANNEL
          UNION ALL
          SELECT F.VISIT_DATE_KEY DATE_KEY,
                 F.CHANNEL,
                 F.PAGE_NAME,
                 COUNT(F.ALL_PAGE_VIEW_KEY) ALL_PV,
                 COUNT(DISTINCT F.ALL_VID) ALL_UV,
                 ROUND(AVG(F.ALL_PAGE_STAY_TIME)) ALL_STAY_TIME,
                 COUNT(F.NEW_PAGE_VIEW_KEY) NEW_PV,
                 COUNT(DISTINCT F.NEW_VID) NEW_UV,
                 ROUND(AVG(F.NEW_PAGE_STAY_TIME)) NEW_STAY_TIME,
                 COUNT(F.OLD_PAGE_VIEW_KEY) OLD_PV,
                 COUNT(DISTINCT F.OLD_VID) OLD_UV,
                 ROUND(AVG(F.OLD_PAGE_STAY_TIME)) OLD_STAY_TIME
            FROM (SELECT E.VISIT_DATE_KEY,
                         E.CHANNEL,
                         E.PAGE_NAME,
                         E.PAGE_VIEW_KEY ALL_PAGE_VIEW_KEY,
                         E.VID ALL_VID,
                         E.PAGE_STAY_TIME ALL_PAGE_STAY_TIME,
                         CASE
                           WHEN IS_NEW = 1 THEN
                            E.PAGE_VIEW_KEY
                         END NEW_PAGE_VIEW_KEY,
                         CASE
                           WHEN IS_NEW = 0 THEN
                            E.PAGE_VIEW_KEY
                         END OLD_PAGE_VIEW_KEY,
                         --
                         CASE
                           WHEN IS_NEW = 1 THEN
                            E.VID
                         END NEW_VID,
                         CASE
                           WHEN IS_NEW = 0 THEN
                            E.VID
                         END OLD_VID,
                         --
                         CASE
                           WHEN IS_NEW = 1 THEN
                            E.PAGE_STAY_TIME
                         END NEW_PAGE_STAY_TIME,
                         CASE
                           WHEN IS_NEW = 0 THEN
                            E.PAGE_STAY_TIME
                         END OLD_PAGE_STAY_TIME
                    FROM (SELECT D.VISIT_DATE_KEY,
                                 CASE
                                   WHEN D.APPLICATION_KEY IN (10, 20) THEN
                                    'APP'
                                   WHEN D.APPLICATION_KEY = 70 THEN
                                    '小程序'
                                 END CHANNEL,
                                 D.PAGE_VIEW_KEY,
                                 D.VID,
                                 D.PAGE_KEY,
                                 D.PAGE_NAME,
                                 D.PAGE_STAYTIME PAGE_STAY_TIME,
                                 CASE
                                   WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') >
                                        D.FIRST_ORDER_DATE THEN
                                    0
                                   WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') <=
                                        D.FIRST_ORDER_DATE THEN
                                    1
                                 END IS_NEW /*是否新会员标志，1:新会员、0:老会员*/
                            FROM (SELECT A.VISIT_DATE_KEY,
                                         A.APPLICATION_KEY,
                                         A.PAGE_VIEW_KEY,
                                         A.VID,
                                         A.PAGE_KEY,
                                         A.PAGE_NAME,
                                         A.PAGE_STAYTIME,
                                         NVL(C.FIRST_ORDER_DATE,
                                             DATE '2000-01-01') FIRST_ORDER_DATE /*首单订购日期*/
                                    FROM FACT_PAGE_VIEW A,
                                         (SELECT B.VID VID,
                                                 TRUNC(MIN(B.ADD_TIME)) FIRST_ORDER_DATE
                                            FROM FACT_EC_ORDER_2 B
                                           GROUP BY B.VID) C
                                   WHERE A.VID = C.VID(+)
                                     AND A.VISIT_DATE_KEY = IN_DATE_KEY
                                     AND A.APPLICATION_KEY IN (10, 20, 70)
                                        /*PAGE_NAME*/
                                     AND EXISTS
                                   (SELECT 1
                                            FROM DIM
                                           WHERE A.PAGE_NAME = DIM.PAGE_NAME)) D) E) F
           GROUP BY F.VISIT_DATE_KEY, F.CHANNEL, F.PAGE_NAME),
        BUV AS
         (SELECT F3.START_DATE_KEY DATE_KEY,
                 F3.CHANNEL,
                 G3.PAGE_NAME,
                 COUNT(F3.VID) ALL_BOUNCE_UV,
                 COUNT(F3.NEW_VID) NEW_BOUNCE_UV,
                 COUNT(F3.OLD_VID) OLD_BOUNCE_UV
            FROM (SELECT E3.START_DATE_KEY,
                         E3.CHANNEL,
                         E3.LEFT_PAGE_KEY,
                         E3.VID,
                         CASE
                           WHEN E3.IS_NEW = 1 THEN
                            VID
                         END NEW_VID,
                         CASE
                           WHEN E3.IS_NEW = 0 THEN
                            VID
                         END OLD_VID
                    FROM (SELECT D3.START_DATE_KEY,
                                 CASE
                                   WHEN D3.APPLICATION_KEY IN (10, 20) THEN
                                    'APP'
                                   WHEN D3.APPLICATION_KEY = 70 THEN
                                    '小程序'
                                 END CHANNEL,
                                 D3.VID,
                                 D3.LEFT_PAGE_KEY,
                                 CASE
                                   WHEN TO_DATE(D3.START_DATE_KEY, 'yyyymmdd') >
                                        D3.FIRST_ORDER_DATE THEN
                                    0
                                   WHEN TO_DATE(D3.START_DATE_KEY, 'yyyymmdd') <=
                                        D3.FIRST_ORDER_DATE THEN
                                    1
                                 END IS_NEW /*是否新会员标志，1:新会员、0:老会员*/
                            FROM (SELECT A3.START_DATE_KEY,
                                         A3.VID,
                                         A3.APPLICATION_KEY,
                                         A3.LEFT_PAGE_KEY,
                                         NVL(C3.FIRST_ORDER_DATE,
                                             DATE '2000-01-01') FIRST_ORDER_DATE /*首单订购日期*/
                                    FROM FACT_SESSION A3,
                                         (SELECT B3.VID,
                                                 TRUNC(MIN(B3.ADD_TIME)) FIRST_ORDER_DATE
                                            FROM FACT_EC_ORDER_2 B3
                                           GROUP BY B3.VID) C3
                                   WHERE A3.VID = C3.VID(+)
                                     AND A3.START_DATE_KEY = IN_DATE_KEY
                                     AND A3.APPLICATION_KEY IN (10, 20, 70)) D3) E3) F3,
                 DIM_PAGE G3
           WHERE F3.LEFT_PAGE_KEY = G3.PAGE_KEY
                /*PAGE_NAME*/
             AND EXISTS
           (SELECT 1 FROM DIM WHERE G3.PAGE_NAME = DIM.PAGE_NAME)
          /*AND G3.PAGE_NAME IN ('Home',
          'Home_TVLive',
          'TV_home',
          'Channel',
          'Good',
          'Search',
          'Member',
          'PayEnd')*/
           GROUP BY F3.START_DATE_KEY, F3.CHANNEL, G3.PAGE_NAME)
        
        SELECT DIM.DATE_KEY,
               DIM.CHANNEL,
               DIM.PAGE_NAME,
               NVL(DP.ALL_PV, 0) ALL_PV,
               NVL(DP.ALL_UV, 0) ALL_UV,
               NVL(DP.ALL_STAY_TIME, 0) ALL_STAY_TIME,
               NVL(BUV.ALL_BOUNCE_UV, 0) ALL_BOUNCE_UV,
               NVL(DP.NEW_PV, 0) NEW_PV,
               NVL(DP.NEW_UV, 0) NEW_UV,
               NVL(DP.NEW_STAY_TIME, 0) NEW_STAY_TIME,
               NVL(BUV.NEW_BOUNCE_UV, 0) NEW_BOUNCE_UV,
               NVL(DP.OLD_PV, 0) OLD_PV,
               NVL(DP.OLD_UV, 0) OLD_UV,
               NVL(DP.OLD_STAY_TIME, 0) OLD_STAY_TIME,
               NVL(BUV.OLD_BOUNCE_UV, 0) OLD_BOUNCE_UV,
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM DIM, DP, BUV
         WHERE DIM.DATE_KEY = DP.DATE_KEY(+)
           AND DIM.CHANNEL = DP.CHANNEL(+)
           AND DIM.PAGE_NAME = DP.PAGE_NAME(+)
           AND DIM.DATE_KEY = BUV.DATE_KEY(+)
           AND DIM.CHANNEL = BUV.CHANNEL(+)
           AND DIM.PAGE_NAME = BUV.PAGE_NAME(+);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
    
  END OPER_TRAFFIC_ANALYSIS_PROC;

  PROCEDURE OPER_CLICK_ANALYSIS_PROC(IN_DATE_KEY IN NUMBER) IS
    /*
    功能说明：
    作者时间：yangjin  2018-04-17
    */
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  BEGIN
    SP_NAME          := 'YANGJIN_PKG.OPER_CLICK_ANALYSIS_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_CLICK_ANALYSIS'; --此处需要手工录入该PROCEDURE操作的表格
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
    
      DELETE OPER_CLICK_ANALYSIS A WHERE A.DATE_KEY = IN_DATE_KEY;
      COMMIT;
    
      --Summary
      INSERT INTO OPER_CLICK_ANALYSIS
        (DATE_KEY,
         CHANNEL,
         PAGE_NAME,
         PAGE_VALUE,
         ALL_PV,
         ALL_UV,
         NEW_PV,
         NEW_UV,
         OLD_PV,
         OLD_UV,
         W_INSERT_DT,
         W_UPDATE_DT)
        WITH DIM AS
         (SELECT DIM1.DATE_KEY, DIM2.CHANNEL, DIM3.PAGE_NAME
            FROM (SELECT IN_DATE_KEY DATE_KEY FROM DUAL) DIM1,
                 (SELECT 'APP' CHANNEL
                    FROM DUAL
                  UNION
                  SELECT '小程序' CHANNEL
                    FROM DUAL) DIM2,
                 /*PAGE_NAME*/
                 (SELECT 'SL_B2C_Article' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_B2C_Bigad' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_B2C_Dt' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_B2C_Floorad' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_B2C_Floorgoods' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_B2C_Homegood' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_B2C_Homegoods' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_B2C_Homegoodslike' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_B2C_Search' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Suppliergood' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Supplier' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Specifications' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Shoppcaring' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_share' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Recommend' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Promotion' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Order' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Evaluate' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Customer' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Coupons' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Collection' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Brandgood' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_Brand' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_BigPic' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_Good_ASK' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_Ygood' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_TVplay' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_TVlist2' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_TVlist1' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_Tvgoodremind' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_Tvgoodbuy' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_Tvgood' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_Middlead' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_brandAD' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_Bigad' PAGE_NAME
                    FROM DUAL
                  UNION
                  SELECT 'SL_TV_Bgood' PAGE_NAME
                    FROM DUAL) DIM3),
        CLK AS
         (SELECT F.VISIT_DATE_KEY DATE_KEY,
                 F.CHANNEL,
                 F.PAGE_NAME,
                 COUNT(F.ALL_PAGE_VIEW_KEY) ALL_PV,
                 COUNT(DISTINCT F.ALL_VID) ALL_UV,
                 ROUND(AVG(F.ALL_PAGE_STAY_TIME)) ALL_STAY_TIME,
                 COUNT(F.NEW_PAGE_VIEW_KEY) NEW_PV,
                 COUNT(DISTINCT F.NEW_VID) NEW_UV,
                 ROUND(AVG(F.NEW_PAGE_STAY_TIME)) NEW_STAY_TIME,
                 COUNT(F.OLD_PAGE_VIEW_KEY) OLD_PV,
                 COUNT(DISTINCT F.OLD_VID) OLD_UV,
                 ROUND(AVG(F.OLD_PAGE_STAY_TIME)) OLD_STAY_TIME
            FROM (SELECT E.VISIT_DATE_KEY,
                         E.CHANNEL,
                         E.PAGE_NAME,
                         E.PAGE_VIEW_KEY ALL_PAGE_VIEW_KEY,
                         E.VID ALL_VID,
                         E.PAGE_STAY_TIME ALL_PAGE_STAY_TIME,
                         CASE
                           WHEN IS_NEW = 1 THEN
                            E.PAGE_VIEW_KEY
                         END NEW_PAGE_VIEW_KEY,
                         CASE
                           WHEN IS_NEW = 0 THEN
                            E.PAGE_VIEW_KEY
                         END OLD_PAGE_VIEW_KEY,
                         --
                         CASE
                           WHEN IS_NEW = 1 THEN
                            E.VID
                         END NEW_VID,
                         CASE
                           WHEN IS_NEW = 0 THEN
                            E.VID
                         END OLD_VID,
                         --
                         CASE
                           WHEN IS_NEW = 1 THEN
                            E.PAGE_STAY_TIME
                         END NEW_PAGE_STAY_TIME,
                         CASE
                           WHEN IS_NEW = 0 THEN
                            E.PAGE_STAY_TIME
                         END OLD_PAGE_STAY_TIME
                    FROM (SELECT D.VISIT_DATE_KEY,
                                 CASE
                                   WHEN D.APPLICATION_KEY IN (10, 20) THEN
                                    'APP'
                                   WHEN D.APPLICATION_KEY = 70 THEN
                                    '小程序'
                                 END CHANNEL,
                                 D.PAGE_VIEW_KEY,
                                 D.VID,
                                 D.PAGE_KEY,
                                 D.PAGE_NAME,
                                 D.PAGE_STAYTIME PAGE_STAY_TIME,
                                 CASE
                                   WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') >
                                        D.FIRST_ORDER_DATE THEN
                                    0
                                   WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') <=
                                        D.FIRST_ORDER_DATE THEN
                                    1
                                 END IS_NEW /*是否新会员标志，1:新会员、0:老会员*/
                            FROM (SELECT A.VISIT_DATE_KEY,
                                         A.APPLICATION_KEY,
                                         A.PAGE_VIEW_KEY,
                                         A.VID,
                                         A.PAGE_KEY,
                                         A.PAGE_NAME,
                                         A.PAGE_STAYTIME,
                                         NVL(C.FIRST_ORDER_DATE,
                                             DATE '2000-01-01') FIRST_ORDER_DATE /*首单订购日期*/
                                    FROM FACT_PAGE_VIEW_HIT A,
                                         (SELECT B.VID,
                                                 TRUNC(MIN(B.ADD_TIME)) FIRST_ORDER_DATE
                                            FROM FACT_EC_ORDER_2 B
                                           GROUP BY B.VID) C
                                   WHERE A.VID = C.VID(+)
                                     AND A.VISIT_DATE_KEY = IN_DATE_KEY
                                     AND A.APPLICATION_KEY IN (10, 20, 70)
                                     AND EXISTS
                                   (SELECT 1
                                            FROM DIM
                                           WHERE DIM.PAGE_NAME = A.PAGE_NAME)) D) E) F
           GROUP BY F.VISIT_DATE_KEY, F.CHANNEL, F.PAGE_NAME)
        SELECT DIM.DATE_KEY,
               DIM.CHANNEL,
               DIM.PAGE_NAME,
               'Summary' PAGE_VALUE,
               NVL(CLK.ALL_PV, 0) ALL_PV,
               NVL(CLK.ALL_UV, 0) ALL_UV,
               NVL(CLK.NEW_PV, 0) NEW_PV,
               NVL(CLK.NEW_UV, 0) NEW_UV,
               NVL(CLK.OLD_PV, 0) OLD_PV,
               NVL(CLK.OLD_UV, 0) OLD_UV,
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM DIM, CLK
         WHERE DIM.DATE_KEY = CLK.DATE_KEY(+)
           AND DIM.CHANNEL = CLK.CHANNEL(+)
           AND DIM.PAGE_NAME = CLK.PAGE_NAME(+);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      --PAGE_VALUE
      INSERT INTO OPER_CLICK_ANALYSIS
        (DATE_KEY,
         CHANNEL,
         PAGE_NAME,
         PAGE_VALUE,
         ALL_PV,
         ALL_UV,
         NEW_PV,
         NEW_UV,
         OLD_PV,
         OLD_UV,
         W_INSERT_DT,
         W_UPDATE_DT)
        SELECT F.VISIT_DATE_KEY DATE_KEY,
               F.CHANNEL,
               F.PAGE_NAME,
               F.PAGE_VALUE,
               COUNT(F.ALL_PAGE_VIEW_KEY) ALL_PV,
               COUNT(DISTINCT F.ALL_VID) ALL_UV,
               COUNT(F.NEW_PAGE_VIEW_KEY) NEW_PV,
               COUNT(DISTINCT F.NEW_VID) NEW_UV,
               COUNT(F.OLD_PAGE_VIEW_KEY) OLD_PV,
               COUNT(DISTINCT F.OLD_VID) OLD_UV,
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM (SELECT E.VISIT_DATE_KEY,
                       E.CHANNEL,
                       E.PAGE_NAME,
                       E.PAGE_VALUE,
                       E.PAGE_VIEW_KEY ALL_PAGE_VIEW_KEY,
                       E.VID ALL_VID,
                       CASE
                         WHEN IS_NEW = 1 THEN
                          E.PAGE_VIEW_KEY
                       END NEW_PAGE_VIEW_KEY,
                       CASE
                         WHEN IS_NEW = 0 THEN
                          E.PAGE_VIEW_KEY
                       END OLD_PAGE_VIEW_KEY,
                       --
                       CASE
                         WHEN IS_NEW = 1 THEN
                          E.VID
                       END NEW_VID,
                       CASE
                         WHEN IS_NEW = 0 THEN
                          E.VID
                       END OLD_VID
                  FROM (SELECT D.VISIT_DATE_KEY,
                               CASE
                                 WHEN D.APPLICATION_KEY IN (10, 20) THEN
                                  'APP'
                                 WHEN D.APPLICATION_KEY = 70 THEN
                                  '小程序'
                               END CHANNEL,
                               D.PAGE_VIEW_KEY,
                               D.VID,
                               D.PAGE_KEY,
                               D.PAGE_NAME,
                               D.PAGE_VALUE,
                               CASE
                                 WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') >
                                      D.FIRST_ORDER_DATE THEN
                                  0
                                 WHEN TO_DATE(D.VISIT_DATE_KEY, 'yyyymmdd') <=
                                      D.FIRST_ORDER_DATE THEN
                                  1
                               END IS_NEW /*是否新会员标志，1:新会员、0:老会员*/
                          FROM (SELECT A.VISIT_DATE_KEY,
                                       A.APPLICATION_KEY,
                                       A.PAGE_VIEW_KEY,
                                       A.VID,
                                       A.PAGE_KEY,
                                       A.PAGE_NAME,
                                       A.PAGE_VALUE,
                                       A.PAGE_STAYTIME,
                                       NVL(C.FIRST_ORDER_DATE,
                                           DATE '2000-01-01') FIRST_ORDER_DATE /*首单订购日期*/
                                  FROM FACT_PAGE_VIEW_HIT A,
                                       (SELECT B.VID,
                                               TRUNC(MIN(B.ADD_TIME)) FIRST_ORDER_DATE
                                          FROM FACT_EC_ORDER_2 B
                                         GROUP BY B.VID) C
                                 WHERE A.VID = C.VID(+)
                                   AND A.VISIT_DATE_KEY = IN_DATE_KEY
                                   AND A.APPLICATION_KEY IN (10, 20, 70)
                                      /*PAGE_NAME*/
                                   AND A.PAGE_NAME IN
                                       ('SL_B2C_Bigicon', 'SL_B2C_ICON')) D) E) F
         GROUP BY F.VISIT_DATE_KEY, F.CHANNEL, F.PAGE_NAME, F.PAGE_VALUE;
      INSERT_ROWS := NVL(INSERT_ROWS, 0) + SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
    
  END OPER_CLICK_ANALYSIS_PROC;

END YANGJIN_PKG_TEST;
/
