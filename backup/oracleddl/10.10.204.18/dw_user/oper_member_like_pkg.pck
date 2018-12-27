???CREATE OR REPLACE PACKAGE DW_USER.OPER_MEMBER_LIKE_PKG AS

  PROCEDURE OPER_MEMBER_LIKE_BASE_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_MEMBER_LIKE_BASE_PROC
  目的:         会员猜你喜欢分二种方式：
                    1.喜欢的商品，2.喜欢的品类（小类）
                    共用底层事实表（浏览、收藏、加车、订购）
                    权重比率：浏览-1、收藏-3、加车-5、订购-15
                    喜欢的商品：浏览+收藏+加车-订购
                    喜欢的小类：浏览+收藏+加车+订购
  作者:         yangjin
  创建时间：    2017/08/09
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_MEMBER_LIKE_ITEM_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_MEMBER_LIKE_ITEM_PROC
  目的:         喜欢的小类：浏览+收藏+加车+订购
  作者:         yangjin
  创建时间：    2017/08/09
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_MEMBER_LIKE_MATXL_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_MEMBER_LIKE_ITEM_PROC
  目的:         喜欢的小类：浏览+收藏+加车+订购
  作者:         yangjin
  创建时间：    2017/08/09
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_ITEM_RECOMMEND_AR_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_ITEM_RECOMMEND_AR_PROC
  目的:         商品推荐-关联规则
                根据oper_member_like_base表采用关联规则找出商品之间的强关联规则作为商品推荐。
                推荐权重(RECOMMENDATION_WEIGHT)=PV_FREQ*5+FAV_FREQ*3+CAR_FREQ*5+ORDER_NET_QTY*4
  作者:         yangjin
  创建时间：    2018/01/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_ITEM_RECOMMEND_SR_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_ITEM_RECOMMEND_SR_PROC
  目的:         商品推荐-热销商品
                从fact_goods_sales表按照销售数量倒序获取三个月的销售排名前20名
  作者:         yangjin
  创建时间：    2018/01/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE OPER_ITEM_RECOMMEND_UNION_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  功能名:       OPER_ITEM_RECOMMEND_UNION_PROC
  目的:         商品推荐-合并
                从OPER_ITEM_RECOMMEND_AR，OPER_ITEM_RECOMMEND_SR表按照日期合并在一起
  作者:         yangjin
  创建时间：    2018/01/10
  最后修改人：
  最后更改日期：
  */

END OPER_MEMBER_LIKE_PKG;
/

CREATE OR REPLACE PACKAGE BODY DW_USER.OPER_MEMBER_LIKE_PKG AS
  PROCEDURE OPER_MEMBER_LIKE_BASE_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*共用底层事实表（浏览、收藏、加车、订购）
    权重比率：浏览-1、收藏-3、加车-5、订购-15*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_LIKE_PKG.OPER_MEMBER_LIKE_BASE_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MEMBER_LIKE_BASE'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    DELETE OPER_MEMBER_LIKE_BASE A
     WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY;
    COMMIT;
    /*插入会员推荐基表*/
    INSERT INTO OPER_MEMBER_LIKE_BASE
      (ROW_WID,
       POSTING_DATE_KEY,
       MEMBER_KEY,
       ITEM_CODE,
       MATXL,
       PV_FREQ,
       FAV_FREQ,
       CAR_FREQ,
       ORDER_NET_QTY,
       PV_WEIGHT,
       FAV_WEIGHT,
       CAR_WEIGHT,
       ORDER_WEIGHT,
       W_INSERT_DT,
       W_UPDATE_DT)
      SELECT OPER_MEMBER_LIKE_BASE_SEQ.NEXTVAL,
             Z.POSTING_DATE_KEY,
             Z.MEMBER_KEY,
             Z.ITEM_CODE,
             Z.MATXL,
             Z.PV_FREQ,
             Z.FAV_FREQ,
             Z.CAR_FREQ,
             Z.ORDER_NET_QTY,
             Z.PV_WEIGHT,
             Z.FAV_WEIGHT,
             Z.CAR_WEIGHT,
             Z.ORDER_WEIGHT,
             Z.W_INSERT_DT,
             Z.W_UPDATE_DT
        FROM (SELECT F.POSTING_DATE_KEY,
                     F.MEMBER_KEY,
                     F.ITEM_CODE,
                     NVL(G.MATXL, 0) MATXL,
                     F.PV_FREQ,
                     F.FAV_FREQ,
                     F.CAR_FREQ,
                     F.ORDER_NET_QTY,
                     F.PV_FREQ * 1 PV_WEIGHT, /*浏览权重1*/
                     F.FAV_FREQ * 3 FAV_WEIGHT, /*收藏权重3*/
                     F.CAR_FREQ * 5 CAR_WEIGHT, /*加购物车权重5*/
                     F.ORDER_NET_QTY * 15 ORDER_WEIGHT, /*订购权重15*/
                     SYSDATE W_INSERT_DT,
                     SYSDATE W_UPDATE_DT
                FROM (
                     
                     /*浏览,FACT_PAGE_VIEW表5分钟更新一次*/
                     
                     WITH PV AS (SELECT P.VISIT_DATE_KEY POSTING_DATE_KEY,
                                        P.MEMBER_KEY,
                                        G.ITEM_CODE,
                                        P.PV_FREQ
                                   FROM (SELECT VISIT_DATE_KEY,
                                                MEMBER_KEY,
                                                PAGE_VALUE,
                                                COUNT(1) AS PV_FREQ
                                           FROM FACT_PAGE_VIEW@DW_DATALINK
                                          WHERE VISIT_DATE_KEY =
                                                IN_POSTING_DATE_KEY
                                            AND MEMBER_KEY != 0
                                            AND PAGE_NAME IN ('Good', 'good')
                                            AND PAGE_VALUE =
                                                TRANSLATE(PAGE_VALUE,
                                                          '0' ||
                                                          TRANSLATE(PAGE_VALUE,
                                                                    '#0123456789',
                                                                    '#'),
                                                          '0')
                                          GROUP BY VISIT_DATE_KEY,
                                                   MEMBER_KEY,
                                                   PAGE_VALUE) P,
                                        DIM_GOOD@DW_DATALINK G
                                  WHERE P.PAGE_VALUE = G.GOODS_COMMONID(+)
                                    AND G.CURRENT_FLG = 'Y'),
                     
                     /*收藏,FACT_FAVORITES表每天更新一次*/
                     
                     FAV AS (SELECT F.FAV_TIME POSTING_DATE_KEY,
                                    G.ITEM_CODE,
                                    M.MEMBER_CRMBP AS MEMBER_KEY,
                                    COUNT(1) AS FAV_FREQ
                               FROM FACT_FAVORITES@DW_DATALINK F,
                                    DIM_EC_GOOD@DW_DATALINK    G,
                                    FACT_ECMEMBER@DW_DATALINK  M
                              WHERE F.FAV_ID = G.GOODS_COMMONID
                                AND F.MEMBER_ID = M.MEMBER_ID
                                AND F.FAV_TIME = IN_POSTING_DATE_KEY
                                AND F.FAV_TYPE = 'goods'
                                AND M.MEMBER_CRMBP > 0
                              GROUP BY F.FAV_TIME, G.ITEM_CODE, M.MEMBER_CRMBP),
                     
                     /*加购物车,FACT_SHOPPINGCAR表10分钟更新一次*/
                     
                     CAR AS (SELECT A.CREATE_DATE_KEY POSTING_DATE_KEY,
                                    B.ITEM_CODE,
                                    A.MEMBER_KEY,
                                    A.CAR_FREQ
                               FROM (SELECT CREATE_DATE_KEY,
                                            SCGID GOODS_COMMON_KEY,
                                            MEMBER_KEY,
                                            SUM(SCGQ) CAR_FREQ
                                       FROM FACT_SHOPPINGCAR@DW_DATALINK
                                      WHERE CREATE_DATE_KEY =
                                            IN_POSTING_DATE_KEY
                                        AND MEMBER_KEY != 0
                                        AND SCGQ > 0
                                      GROUP BY CREATE_DATE_KEY,
                                               SCGID,
                                               MEMBER_KEY) A,
                                    DIM_GOOD@DW_DATALINK B
                              WHERE A.GOODS_COMMON_KEY = B.GOODS_COMMONID
                                AND B.CURRENT_FLG = 'Y'),
                     
                     /*订购，FACT_GOODS_SALES表每天更新一次*/
                     
                     ORD AS (SELECT B.POSTING_DATE_KEY,
                                    B.MEMBER_KEY,
                                    B.ITEM_CODE,
                                    SUM(B.QTY) ORDER_NET_QTY
                               FROM (SELECT A.POSTING_DATE_KEY,
                                            A.MEMBER_KEY,
                                            A.ORDER_STATE,
                                            A.GOODS_COMMON_KEY ITEM_CODE,
                                            CASE
                                              WHEN A.ORDER_STATE = 1 THEN
                                               A.NUMS
                                              WHEN A.ORDER_STATE = 0 THEN
                                               -A.NUMS
                                            END QTY
                                       FROM FACT_GOODS_SALES@DW_DATALINK A
                                      WHERE A.POSTING_DATE_KEY =
                                            IN_POSTING_DATE_KEY) B
                              GROUP BY B.POSTING_DATE_KEY,
                                       B.MEMBER_KEY,
                                       B.ITEM_CODE)
                       SELECT NVL(NVL(NVL(PV.POSTING_DATE_KEY,
                                          FAV.POSTING_DATE_KEY),
                                      CAR.POSTING_DATE_KEY),
                                  ORD.POSTING_DATE_KEY) POSTING_DATE_KEY,
                              NVL(NVL(NVL(PV.MEMBER_KEY, FAV.MEMBER_KEY),
                                      CAR.MEMBER_KEY),
                                  ORD.MEMBER_KEY) MEMBER_KEY,
                              NVL(NVL(NVL(PV.ITEM_CODE, FAV.ITEM_CODE),
                                      CAR.ITEM_CODE),
                                  ORD.ITEM_CODE) ITEM_CODE,
                              NVL(PV.PV_FREQ, 0) PV_FREQ,
                              NVL(FAV.FAV_FREQ, 0) FAV_FREQ,
                              NVL(CAR.CAR_FREQ, 0) CAR_FREQ,
                              NVL(ORD.ORDER_NET_QTY, 0) ORDER_NET_QTY
                         FROM PV
                         FULL OUTER JOIN FAV
                           ON PV.POSTING_DATE_KEY = FAV.POSTING_DATE_KEY
                          AND PV.MEMBER_KEY = FAV.MEMBER_KEY
                          AND PV.ITEM_CODE = FAV.ITEM_CODE
                         FULL OUTER JOIN CAR
                           ON PV.POSTING_DATE_KEY = CAR.POSTING_DATE_KEY
                          AND PV.MEMBER_KEY = CAR.MEMBER_KEY
                          AND PV.ITEM_CODE = CAR.ITEM_CODE
                         FULL OUTER JOIN ORD
                           ON PV.POSTING_DATE_KEY = ORD.POSTING_DATE_KEY
                          AND PV.MEMBER_KEY = ORD.MEMBER_KEY
                          AND PV.ITEM_CODE = ORD.ITEM_CODE) F, (SELECT ITEM_CODE,
                                                                       MATXL
                                                                  FROM DIM_GOOD@DW_DATALINK
                                                                 WHERE CURRENT_FLG = 'Y') G
                        WHERE F.ITEM_CODE = G.ITEM_CODE(+)
              ) Z;
  
    INSERT_ROWS := SQL%ROWCOUNT;
    COMMIT;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END OPER_MEMBER_LIKE_BASE_PROC;

  PROCEDURE OPER_MEMBER_LIKE_ITEM_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*统计会员最近活跃的15天数据
    喜欢的商品：浏览+收藏+加车-订购*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    MIN_DAY     NUMBER; /*最早活跃日期*/
    MAX_DAY     NUMBER; /*最晚活跃日期*/
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_LIKE_PKG.OPER_MEMBER_LIKE_ITEM_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MEMBER_LIKE_ITEM'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*先删除当天数据*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_MEMBER_LIKE_ITEM_TMP_A';
    
      DECLARE
        TYPE TYPE_ARRAYS IS RECORD(
          MEMBER_KEY NUMBER(20));
      
        TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --类似二维数组 
      
        VAR_ARRAY TYPE_ARRAY;
      BEGIN
        /*当天活跃的会员BP号*/
        SELECT P.*
          BULK COLLECT
          INTO VAR_ARRAY
          FROM (SELECT MEMBER_KEY
                  FROM OPER_MEMBER_LIKE_BASE
                 WHERE POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                 GROUP BY MEMBER_KEY) P;
      
        FOR I IN 1 .. VAR_ARRAY.COUNT LOOP
          /*取出某一个会员活跃的15天的最大日期*/
          SELECT P.MAX_DAY
            INTO MAX_DAY
            FROM (SELECT TO_NUMBER(MAX(POSTING_DATE_KEY)) MAX_DAY
                    FROM (SELECT DISTINCT (POSTING_DATE_KEY) AS POSTING_DATE_KEY
                            FROM OPER_MEMBER_LIKE_BASE
                           WHERE MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                           ORDER BY POSTING_DATE_KEY DESC)
                   WHERE ROWNUM <= 15) P;
          /*取出某一个会员活跃的15天的最小日期*/
          SELECT P.MIN_DAY
            INTO MIN_DAY
            FROM (SELECT TO_NUMBER(MIN(POSTING_DATE_KEY)) MIN_DAY
                    FROM (SELECT DISTINCT (POSTING_DATE_KEY) AS POSTING_DATE_KEY
                            FROM OPER_MEMBER_LIKE_BASE
                           WHERE MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                           ORDER BY POSTING_DATE_KEY DESC)
                   WHERE ROWNUM <= 15) P;
          /*写入OPER_MEMBER_LIKE_ITEM_TMP_A临时表*/
          INSERT INTO OPER_MEMBER_LIKE_ITEM_TMP_A
            (POSTING_DATE_KEY,
             MEMBER_KEY,
             ITEM_CODE,
             MATXL,
             PV_FREQ,
             FAV_FREQ,
             CAR_FREQ,
             ORDER_NET_QTY,
             PV_WEIGHT,
             FAV_WEIGHT,
             CAR_WEIGHT,
             ORDER_WEIGHT,
             TOTAL_ITEM_WEIGHT)
            SELECT B.POSTING_DATE_KEY,
                   B.MEMBER_KEY,
                   B.ITEM_CODE,
                   B.MATXL,
                   B.PV_FREQ,
                   B.FAV_FREQ,
                   B.CAR_FREQ,
                   B.ORDER_NET_QTY,
                   B.PV_WEIGHT,
                   B.FAV_WEIGHT,
                   B.CAR_WEIGHT,
                   B.ORDER_WEIGHT,
                   B.TOTAL_ITEM_WEIGHT
              FROM (SELECT IN_POSTING_DATE_KEY POSTING_DATE_KEY,
                           A.MEMBER_KEY,
                           A.ITEM_CODE,
                           A.MATXL,
                           SUM(A.PV_FREQ) PV_FREQ,
                           SUM(A.FAV_FREQ) FAV_FREQ,
                           SUM(A.CAR_FREQ) CAR_FREQ,
                           SUM(A.ORDER_NET_QTY) ORDER_NET_QTY,
                           SUM(A.PV_WEIGHT) PV_WEIGHT,
                           SUM(A.FAV_WEIGHT) FAV_WEIGHT,
                           SUM(A.CAR_WEIGHT) CAR_WEIGHT,
                           SUM(A.ORDER_WEIGHT) ORDER_WEIGHT,
                           SUM(A.PV_WEIGHT + A.FAV_WEIGHT + A.CAR_WEIGHT -
                               A.ORDER_WEIGHT) TOTAL_ITEM_WEIGHT /*商品合计权重*/
                      FROM OPER_MEMBER_LIKE_BASE A
                     WHERE A.MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                       AND A.POSTING_DATE_KEY BETWEEN MIN_DAY AND MAX_DAY
                     GROUP BY A.MEMBER_KEY, A.ITEM_CODE, A.MATXL) B;
        END LOOP;
      END;
      COMMIT;
    
      BEGIN
        DELETE OPER_MEMBER_LIKE_ITEM A
         WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY;
        COMMIT;
        /*只取一个会员的商品权重前10名商品插入结果表*/
        INSERT INTO OPER_MEMBER_LIKE_ITEM
          (ROW_WID,
           POSTING_DATE_KEY,
           MEMBER_KEY,
           ITEM_CODE,
           MATXL,
           PV_FREQ,
           FAV_FREQ,
           CAR_FREQ,
           ORDER_NET_QTY,
           PV_WEIGHT,
           FAV_WEIGHT,
           CAR_WEIGHT,
           ORDER_WEIGHT,
           TOTAL_ITEM_WEIGHT,
           ITEM_RANKING,
           W_INSERT_DT,
           W_UPDATE_DT)
          SELECT OPER_MEMBER_LIKE_ITEM_SEQ.NEXTVAL,
                 C.POSTING_DATE_KEY,
                 C.MEMBER_KEY,
                 C.ITEM_CODE,
                 C.MATXL,
                 C.PV_FREQ,
                 C.FAV_FREQ,
                 C.CAR_FREQ,
                 C.ORDER_NET_QTY,
                 C.PV_WEIGHT,
                 C.FAV_WEIGHT,
                 C.CAR_WEIGHT,
                 C.ORDER_WEIGHT,
                 C.TOTAL_ITEM_WEIGHT,
                 C.ITEM_RANKING,
                 C.W_INSERT_DT,
                 C.W_UPDATE_DT
            FROM (SELECT B.POSTING_DATE_KEY,
                         B.MEMBER_KEY,
                         B.ITEM_CODE,
                         B.MATXL,
                         B.PV_FREQ,
                         B.FAV_FREQ,
                         B.CAR_FREQ,
                         B.ORDER_NET_QTY,
                         B.PV_WEIGHT,
                         B.FAV_WEIGHT,
                         B.CAR_WEIGHT,
                         B.ORDER_WEIGHT,
                         B.TOTAL_ITEM_WEIGHT,
                         B.ITEM_RANKING,
                         SYSDATE             W_INSERT_DT,
                         SYSDATE             W_UPDATE_DT
                    FROM (SELECT A.POSTING_DATE_KEY,
                                 A.MEMBER_KEY,
                                 A.ITEM_CODE,
                                 A.MATXL,
                                 A.PV_FREQ,
                                 A.FAV_FREQ,
                                 A.CAR_FREQ,
                                 A.ORDER_NET_QTY,
                                 A.PV_WEIGHT,
                                 A.FAV_WEIGHT,
                                 A.CAR_WEIGHT,
                                 A.ORDER_WEIGHT,
                                 A.TOTAL_ITEM_WEIGHT,
                                 RANK() OVER(PARTITION BY A.MEMBER_KEY ORDER BY A.TOTAL_ITEM_WEIGHT DESC) ITEM_RANKING
                            FROM OPER_MEMBER_LIKE_ITEM_TMP_A A
                           WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY) B
                   WHERE B.ITEM_RANKING <= 10 /*权重排名前十的商品*/
                   ORDER BY B.MEMBER_KEY, B.ITEM_RANKING) C;
        INSERT_ROWS := SQL%ROWCOUNT;
        COMMIT;
      END;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END OPER_MEMBER_LIKE_ITEM_PROC;

  PROCEDURE OPER_MEMBER_LIKE_MATXL_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*统计会员最近活跃的15天数据
    喜欢的小类：浏览+收藏+加车+订购*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    MIN_DAY     NUMBER; /*最早活跃日期*/
    MAX_DAY     NUMBER; /*最晚活跃日期*/
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_LIKE_PKG.OPER_MEMBER_LIKE_MATXL_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_MEMBER_LIKE_ITEM'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*先删除当天数据*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_MEMBER_LIKE_MATXL_TMP_A';
    
      DECLARE
        TYPE TYPE_ARRAYS IS RECORD(
          MEMBER_KEY NUMBER(20));
      
        TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --类似二维数组 
      
        VAR_ARRAY TYPE_ARRAY;
      BEGIN
        /*当天活跃的会员BP号*/
        SELECT P.*
          BULK COLLECT
          INTO VAR_ARRAY
          FROM (SELECT MEMBER_KEY
                  FROM OPER_MEMBER_LIKE_BASE
                 WHERE POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                 GROUP BY MEMBER_KEY) P;
      
        FOR I IN 1 .. VAR_ARRAY.COUNT LOOP
          SELECT P.MAX_DAY
            INTO MAX_DAY
            FROM (SELECT TO_NUMBER(MAX(POSTING_DATE_KEY)) MAX_DAY
                    FROM (SELECT DISTINCT (POSTING_DATE_KEY) AS POSTING_DATE_KEY
                            FROM OPER_MEMBER_LIKE_BASE
                           WHERE MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                           ORDER BY POSTING_DATE_KEY DESC)
                   WHERE ROWNUM <= 15) P;
        
          SELECT P.MIN_DAY
            INTO MIN_DAY
            FROM (SELECT TO_NUMBER(MIN(POSTING_DATE_KEY)) MIN_DAY
                    FROM (SELECT DISTINCT (POSTING_DATE_KEY) AS POSTING_DATE_KEY
                            FROM OPER_MEMBER_LIKE_BASE
                           WHERE MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                           ORDER BY POSTING_DATE_KEY DESC)
                   WHERE ROWNUM <= 15) P;
        
          INSERT INTO OPER_MEMBER_LIKE_MATXL_TMP_A
            (POSTING_DATE_KEY,
             MEMBER_KEY,
             MATXL,
             PV_FREQ,
             FAV_FREQ,
             CAR_FREQ,
             ORDER_NET_QTY,
             PV_WEIGHT,
             FAV_WEIGHT,
             CAR_WEIGHT,
             ORDER_WEIGHT,
             TOTAL_MATXL_WEIGHT)
            SELECT B.POSTING_DATE_KEY,
                   B.MEMBER_KEY,
                   B.MATXL,
                   B.PV_FREQ,
                   B.FAV_FREQ,
                   B.CAR_FREQ,
                   B.ORDER_NET_QTY,
                   B.PV_WEIGHT,
                   B.FAV_WEIGHT,
                   B.CAR_WEIGHT,
                   B.ORDER_WEIGHT,
                   B.TOTAL_ITEM_WEIGHT
              FROM (SELECT IN_POSTING_DATE_KEY POSTING_DATE_KEY,
                           A.MEMBER_KEY,
                           A.MATXL,
                           SUM(A.PV_FREQ) PV_FREQ,
                           SUM(A.FAV_FREQ) FAV_FREQ,
                           SUM(A.CAR_FREQ) CAR_FREQ,
                           SUM(A.ORDER_NET_QTY) ORDER_NET_QTY,
                           SUM(A.PV_WEIGHT) PV_WEIGHT,
                           SUM(A.FAV_WEIGHT) FAV_WEIGHT,
                           SUM(A.CAR_WEIGHT) CAR_WEIGHT,
                           SUM(A.ORDER_WEIGHT) ORDER_WEIGHT,
                           SUM(A.PV_WEIGHT + A.FAV_WEIGHT + A.CAR_WEIGHT +
                               A.ORDER_WEIGHT) TOTAL_ITEM_WEIGHT /*小类合计权重*/
                      FROM OPER_MEMBER_LIKE_BASE A
                     WHERE A.MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                       AND A.POSTING_DATE_KEY BETWEEN MIN_DAY AND MAX_DAY
                     GROUP BY A.MEMBER_KEY, A.MATXL) B;
        END LOOP;
      END;
      COMMIT;
    
      BEGIN
        DELETE OPER_MEMBER_LIKE_MATXL A
         WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY;
        COMMIT;
        /*只取小类权重前10名插入结果表*/
        INSERT INTO OPER_MEMBER_LIKE_MATXL
          (ROW_WID,
           POSTING_DATE_KEY,
           MEMBER_KEY,
           MATXL,
           PV_FREQ,
           FAV_FREQ,
           CAR_FREQ,
           ORDER_NET_QTY,
           PV_WEIGHT,
           FAV_WEIGHT,
           CAR_WEIGHT,
           ORDER_WEIGHT,
           TOTAL_MATXL_WEIGHT,
           MATXL_RANKING,
           W_INSERT_DT,
           W_UPDATE_DT)
          SELECT OPER_MEMBER_LIKE_MATXL_SEQ.NEXTVAL,
                 C.POSTING_DATE_KEY,
                 C.MEMBER_KEY,
                 C.MATXL,
                 C.PV_FREQ,
                 C.FAV_FREQ,
                 C.CAR_FREQ,
                 C.ORDER_NET_QTY,
                 C.PV_WEIGHT,
                 C.FAV_WEIGHT,
                 C.CAR_WEIGHT,
                 C.ORDER_WEIGHT,
                 C.TOTAL_MATXL_WEIGHT,
                 C.MATXL_RANKING,
                 C.W_INSERT_DT,
                 C.W_UPDATE_DT
            FROM (SELECT B.POSTING_DATE_KEY,
                         B.MEMBER_KEY,
                         B.MATXL,
                         B.PV_FREQ,
                         B.FAV_FREQ,
                         B.CAR_FREQ,
                         B.ORDER_NET_QTY,
                         B.PV_WEIGHT,
                         B.FAV_WEIGHT,
                         B.CAR_WEIGHT,
                         B.ORDER_WEIGHT,
                         B.TOTAL_MATXL_WEIGHT,
                         B.MATXL_RANKING,
                         SYSDATE              W_INSERT_DT,
                         SYSDATE              W_UPDATE_DT
                    FROM (SELECT A.POSTING_DATE_KEY,
                                 A.MEMBER_KEY,
                                 A.MATXL,
                                 A.PV_FREQ,
                                 A.FAV_FREQ,
                                 A.CAR_FREQ,
                                 A.ORDER_NET_QTY,
                                 A.PV_WEIGHT,
                                 A.FAV_WEIGHT,
                                 A.CAR_WEIGHT,
                                 A.ORDER_WEIGHT,
                                 A.TOTAL_MATXL_WEIGHT,
                                 RANK() OVER(PARTITION BY A.MEMBER_KEY ORDER BY A.TOTAL_MATXL_WEIGHT DESC) MATXL_RANKING
                            FROM OPER_MEMBER_LIKE_MATXL_TMP_A A
                           WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                             AND A.MATXL <> 0) B
                   WHERE B.MATXL_RANKING <= 10
                   ORDER BY B.MEMBER_KEY, B.MATXL_RANKING) C;
        INSERT_ROWS := SQL%ROWCOUNT;
        COMMIT;
      END;
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END OPER_MEMBER_LIKE_MATXL_PROC;

  PROCEDURE OPER_ITEM_RECOMMEND_AR_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*商品推荐-关联规则
    根据oper_member_like_base表采用关联规则找出商品之间的强关联规则作为商品推荐。
    推荐权重(RECOMMENDATION_WEIGHT)=PV_FREQ*5+FAV_FREQ*3+CAR_FREQ*5+ORDER_NET_QTY*4*/
    S_ETL          W_ETL_LOG%ROWTYPE;
    SP_NAME        S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER    S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS    NUMBER;
    AGO_90DAYS_KEY NUMBER; /*前90天变量定义*/
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_LIKE_PKG.OPER_ITEM_RECOMMEND_AR_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_ITEM_RECOMMEND_AR'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    AGO_90DAYS_KEY   := TO_CHAR(TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD') - 90,
                                'YYYYMMDD'); /*前90天变量赋值*/
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*先删除当天数据*/
      DELETE OPER_ITEM_RECOMMEND_AR A
       WHERE A.DATE_KEY = IN_POSTING_DATE_KEY;
      COMMIT;
    
      INSERT INTO OPER_ITEM_RECOMMEND_AR
        (DATE_KEY,
         ITEM_CODE_S,
         ITEM_CODE_R,
         GROUP_ID,
         RECOMMEND_RANK,
         PV_FREQ,
         FAV_FREQ,
         CAR_FREQ,
         ORDER_NET_QTY,
         RECOMMEND_WEIGHT,
         MEMBER_COUNT,
         W_INSERT_DT,
         W_UPDATE_DT)
        SELECT IN_POSTING_DATE_KEY,
               K.ITEM_CODE_S,
               K.ITEM_CODE_R,
               K.GROUP_ID,
               K.RECOMMEND_RANK,
               K.PV_FREQ,
               K.FAV_FREQ,
               K.CAR_FREQ,
               K.ORDER_NET_QTY,
               K.RECOMMEND_WEIGHT,
               K.MEMBER_COUNT,
               SYSDATE             W_INSERT_DT,
               SYSDATE             W_UPDATE_DT
          FROM (SELECT G.ITEM_CODE_S,
                       G.ITEM_CODE_R,
                       I.GROUP_ID,
                       ROW_NUMBER() OVER(PARTITION BY G.ITEM_CODE_S ORDER BY G.RECOMMEND_WEIGHT DESC, G.MEMBER_COUNT DESC) RECOMMEND_RANK,
                       G.PV_FREQ,
                       G.FAV_FREQ,
                       G.CAR_FREQ,
                       G.ORDER_NET_QTY,
                       G.RECOMMEND_WEIGHT,
                       G.MEMBER_COUNT
                  FROM (SELECT F.ITEM_CODE_S,
                               F.ITEM_CODE_R,
                               F.PV_FREQ,
                               F.FAV_FREQ,
                               F.CAR_FREQ,
                               F.ORDER_NET_QTY,
                               F.RECOMMEND_WEIGHT,
                               F.MEMBER_COUNT
                          FROM (SELECT E.ITEM_CODE_S,
                                       E.ITEM_CODE_R,
                                       SUM(E.PV_FREQ) PV_FREQ,
                                       SUM(E.FAV_FREQ) FAV_FREQ,
                                       SUM(E.CAR_FREQ) CAR_FREQ,
                                       SUM(E.ORDER_NET_QTY) ORDER_NET_QTY,
                                       SUM(E.RECOMMEND_WEIGHT) RECOMMEND_WEIGHT,
                                       COUNT(E.MEMBER_KEY) MEMBER_COUNT
                                  FROM (SELECT C.MEMBER_KEY,
                                               C.ITEM_CODE ITEM_CODE_S,
                                               D.ITEM_CODE ITEM_CODE_R,
                                               D.PV_FREQ,
                                               D.FAV_FREQ,
                                               D.CAR_FREQ,
                                               D.ORDER_NET_QTY,
                                               D.RECOMMEND_WEIGHT *
                                               C.TV_RECOMMEND_WEIGHT RECOMMEND_WEIGHT /*权重相乘*/
                                          FROM (SELECT A.MEMBER_KEY,
                                                       A.ITEM_CODE,
                                                       A.MATXL,
                                                       SUM(A.PV_FREQ) * 5 +
                                                       SUM(A.FAV_FREQ) * 3 +
                                                       SUM(A.CAR_FREQ) * 5 +
                                                       SUM(A.ORDER_NET_QTY) * 4 TV_RECOMMEND_WEIGHT /*tv推荐权重*/
                                                  FROM OPER_MEMBER_LIKE_BASE A
                                                 WHERE A.POSTING_DATE_KEY >=
                                                       AGO_90DAYS_KEY
                                                   AND EXISTS
                                                 (SELECT 1
                                                          FROM DIM_TV_GOOD@DW_DATALINK J
                                                         WHERE J.TV_STARTDAY_KEY =
                                                               IN_POSTING_DATE_KEY
                                                           AND A.ITEM_CODE =
                                                               J.ITEM_CODE) /*只推荐当天直播的商品*/
                                                 GROUP BY A.MEMBER_KEY,
                                                          A.ITEM_CODE,
                                                          A.MATXL) C,
                                               (SELECT B.MEMBER_KEY,
                                                       B.ITEM_CODE,
                                                       B.MATXL,
                                                       SUM(B.PV_FREQ) PV_FREQ,
                                                       SUM(B.FAV_FREQ) FAV_FREQ,
                                                       SUM(B.CAR_FREQ) CAR_FREQ,
                                                       SUM(B.ORDER_NET_QTY) ORDER_NET_QTY,
                                                       SUM(B.PV_FREQ) * 5 +
                                                       SUM(B.FAV_FREQ) * 3 +
                                                       SUM(B.CAR_FREQ) * 5 +
                                                       SUM(B.ORDER_NET_QTY) * 4 RECOMMEND_WEIGHT /*推荐权重*/
                                                  FROM OPER_MEMBER_LIKE_BASE B
                                                 WHERE B.POSTING_DATE_KEY >=
                                                       AGO_90DAYS_KEY
                                                 GROUP BY B.MEMBER_KEY,
                                                          B.ITEM_CODE,
                                                          B.MATXL) D
                                         WHERE C.MEMBER_KEY = D.MEMBER_KEY
                                           AND C.ITEM_CODE <> D.ITEM_CODE
                                           AND C.MATXL <> D.MATXL) E
                                 GROUP BY E.ITEM_CODE_S, E.ITEM_CODE_R) F
                         ORDER BY F.MEMBER_COUNT     DESC,
                                  F.RECOMMEND_WEIGHT DESC) G,
                       DIM_GOOD@DW_DATALINK H,
                       DIM_GOOD@DW_DATALINK I
                 WHERE G.ITEM_CODE_S = H.ITEM_CODE
                   AND G.ITEM_CODE_R = I.ITEM_CODE
                   AND H.CURRENT_FLG = 'Y'
                   AND I.CURRENT_FLG = 'Y'
                      /*剔除售价为0的赠品*/
                   AND H.GOOD_PRICE > 0
                   AND I.GOOD_PRICE > 0) K
         WHERE K.RECOMMEND_RANK <= 20; /*推荐前20名*/
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END OPER_ITEM_RECOMMEND_AR_PROC;

  PROCEDURE OPER_ITEM_RECOMMEND_SR_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*商品推荐-热销商品
    从fact_goods_sales表按照销售数量倒序获取三个月的销售排名前20名*/
    S_ETL          W_ETL_LOG%ROWTYPE;
    SP_NAME        S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER    S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS    NUMBER;
    AGO_90DAYS_KEY NUMBER; /*前90天变量定义*/
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_LIKE_PKG.OPER_ITEM_RECOMMEND_SR_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_ITEM_RECOMMEND_SR'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    AGO_90DAYS_KEY   := TO_CHAR(TO_DATE(IN_POSTING_DATE_KEY, 'YYYYMMDD') - 90,
                                'YYYYMMDD'); /*前90天变量赋值*/
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*先删除当天数据*/
      DELETE OPER_ITEM_RECOMMEND_SR A
       WHERE A.DATE_KEY = IN_POSTING_DATE_KEY;
      COMMIT;
    
      INSERT INTO OPER_ITEM_RECOMMEND_SR
        (DATE_KEY,
         ITEM_CODE,
         GROUP_ID,
         QTY,
         QTY_RANK,
         W_INSERT_DT,
         W_UPDATE_DT)
        SELECT IN_POSTING_DATE_KEY,
               D.ITEM_CODE,
               D.GROUP_ID,
               D.QTY,
               D.QTY_RANK,
               SYSDATE             W_INSERT_DT,
               SYSDATE             W_UPDATE_DT
          FROM (SELECT C.ITEM_CODE,
                       C.GROUP_ID,
                       C.QTY,
                       ROW_NUMBER() OVER(ORDER BY C.QTY DESC) QTY_RANK
                  FROM (SELECT B.ITEM_CODE, B.GROUP_ID, SUM(A.NUMS) QTY
                          FROM FACT_GOODS_SALES@DW_DATALINK A,
                               DIM_GOOD@DW_DATALINK         B
                         WHERE A.GOODS_COMMON_KEY = B.ITEM_CODE
                           AND A.ORDER_STATE = 1
                           AND A.POSTING_DATE_KEY >= AGO_90DAYS_KEY
                           AND B.GOOD_PRICE > 0
                         GROUP BY B.ITEM_CODE, B.GROUP_ID) C) D
         WHERE D.QTY_RANK <= 20;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END OPER_ITEM_RECOMMEND_SR_PROC;

  PROCEDURE OPER_ITEM_RECOMMEND_UNION_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*商品推荐-合并
    数据来源：OPER_ITEM_RECOMMEND_AR,OPER_ITEM_RECOMMEND_AR,DIM_TV_GOOD
    从OPER_ITEM_RECOMMEND_AR，OPER_ITEM_RECOMMEND_SR表按照日期合并在一起*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_LIKE_PKG.OPER_ITEM_RECOMMEND_UNION_PROC'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'OPER_ITEM_RECOMMEND_UNION'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := '没有找到对应的过程加载类型数据';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*先删除当天数据*/
      DELETE OPER_ITEM_RECOMMEND_UNION A
       WHERE A.DATE_KEY = IN_POSTING_DATE_KEY;
      COMMIT;
      /*插入数据*/
      INSERT INTO OPER_ITEM_RECOMMEND_UNION
        (DATE_KEY,
         ITEM_CODE_S,
         ITEM_CODE_R,
         GROUP_ID,
         RECOMMEND_TYPE,
         RECOMMEND_RANK,
         W_INSERT_DT,
         W_UPDATE_DT)
        SELECT A.DATE_KEY,
               A.ITEM_CODE_S,
               A.ITEM_CODE_R,
               A.GROUP_ID,
               A.RECOMMEND_TYPE,
               A.RECOMMEND_RANK,
               SYSDATE          W_INSERT_DT,
               SYSDATE          W_UPDATE_DT
          FROM (SELECT B.DATE_KEY,
                       B.ITEM_CODE_S,
                       B.ITEM_CODE_R,
                       B.GROUP_ID,
                       1                RECOMMEND_TYPE,
                       B.RECOMMEND_RANK RECOMMEND_RANK
                  FROM OPER_ITEM_RECOMMEND_AR B
                 WHERE B.DATE_KEY = IN_POSTING_DATE_KEY
                UNION ALL
                SELECT D.DATE_KEY,
                       C.ITEM_CODE ITEM_CODE_S,
                       D.ITEM_CODE ITEM_CODE_R,
                       D.GROUP_ID,
                       2           RECOMMEND_TYPE,
                       D.QTY_RANK  RECOMMEND_RANK
                  FROM DIM_TV_GOOD@DW_DATALINK C, OPER_ITEM_RECOMMEND_SR D
                 WHERE C.TV_STARTDAY_KEY = D.DATE_KEY
                   AND C.TV_STARTDAY_KEY = IN_POSTING_DATE_KEY
                   AND NOT EXISTS
                 (SELECT 1
                          FROM OPER_ITEM_RECOMMEND_AR E
                         WHERE C.ITEM_CODE = E.ITEM_CODE_S)) A
         ORDER BY A.ITEM_CODE_S, A.RECOMMEND_TYPE, A.RECOMMEND_RANK;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '输入参数:IN_POSTING_DATE_KEY:' ||
                            TO_CHAR(IN_POSTING_DATE_KEY);
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
  END OPER_ITEM_RECOMMEND_UNION_PROC;

END OPER_MEMBER_LIKE_PKG;
/

