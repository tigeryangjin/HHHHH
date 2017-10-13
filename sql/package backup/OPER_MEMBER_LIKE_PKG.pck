CREATE OR REPLACE PACKAGE OPER_MEMBER_LIKE_PKG AS

  PROCEDURE OPER_MEMBER_LIKE_BASE_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       OPER_MEMBER_LIKE_BASE_PROC
  Ŀ��:         ��Ա����ϲ���ֶ��ַ�ʽ��
                    1.ϲ������Ʒ��2.ϲ����Ʒ�ࣨС�ࣩ
                    ���õײ���ʵ��������ղء��ӳ���������
                    Ȩ�ر��ʣ����-1���ղ�-3���ӳ�-5������-15
                    ϲ������Ʒ�����+�ղ�+�ӳ�-����
                    ϲ����С�ࣺ���+�ղ�+�ӳ�+����
  ����:         yangjin
  ����ʱ�䣺    2017/08/09
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE OPER_MEMBER_LIKE_ITEM_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       OPER_MEMBER_LIKE_ITEM_PROC
  Ŀ��:         ��Ա����ϲ���ֶ��ַ�ʽ��
                    1.ϲ������Ʒ��2.ϲ����Ʒ�ࣨС�ࣩ
                    ���õײ���ʵ��������ղء��ӳ���������
                    Ȩ�ر��ʣ����-1���ղ�-3���ӳ�-5������-15
                    ϲ������Ʒ�����+�ղ�+�ӳ�-����
                    ϲ����С�ࣺ���+�ղ�+�ӳ�+����
  ����:         yangjin
  ����ʱ�䣺    2017/08/09
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE OPER_MEMBER_LIKE_MATXL_PROC(IN_POSTING_DATE_KEY IN NUMBER);
  /*
  ������:       OPER_MEMBER_LIKE_ITEM_PROC
  Ŀ��:         ϲ����С�ࣺ���+�ղ�+�ӳ�+����
  ����:         yangjin
  ����ʱ�䣺    2017/08/09
  ����޸��ˣ�
  ���������ڣ�
  */

END OPER_MEMBER_LIKE_PKG;
/
CREATE OR REPLACE PACKAGE BODY OPER_MEMBER_LIKE_PKG AS
  PROCEDURE OPER_MEMBER_LIKE_BASE_PROC(IN_POSTING_DATE_KEY IN NUMBER) IS
    /*���õײ���ʵ��������ղء��ӳ���������
    Ȩ�ر��ʣ����-1���ղ�-3���ӳ�-5������-15*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_LIKE_PKG.OPER_MEMBER_LIKE_BASE_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MEMBER_LIKE_BASE'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    DELETE OPER_MEMBER_LIKE_BASE A
     WHERE A.POSTING_DATE_KEY = IN_POSTING_DATE_KEY;
    COMMIT;
    /*�����Ա�Ƽ�����*/
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
                     F.PV_FREQ * 1 PV_WEIGHT, /*���Ȩ��1*/
                     F.FAV_FREQ * 3 FAV_WEIGHT, /*�ղ�Ȩ��3*/
                     F.CAR_FREQ * 5 CAR_WEIGHT, /*�ӹ��ﳵȨ��5*/
                     F.ORDER_NET_QTY * 15 ORDER_WEIGHT, /*����Ȩ��15*/
                     SYSDATE W_INSERT_DT,
                     SYSDATE W_UPDATE_DT
                FROM ( /*���*/ WITH PV AS (SELECT P.VISIT_DATE_KEY POSTING_DATE_KEY,
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
                                                     AND PAGE_NAME IN
                                                         ('Good', 'good')
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
                                           WHERE P.PAGE_VALUE =
                                                 G.GOODS_COMMONID(+)
                                             AND G.CURRENT_FLG = 'Y'),
                     /*�ղ�*/ FAV AS (SELECT F.FAV_TIME POSTING_DATE_KEY,
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
                                     GROUP BY F.FAV_TIME,
                                              G.ITEM_CODE,
                                              M.MEMBER_CRMBP),
                     /*�ӹ��ﳵ*/ CAR AS (SELECT A.CREATE_DATE_KEY POSTING_DATE_KEY,
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
                                       WHERE A.GOODS_COMMON_KEY =
                                             B.GOODS_COMMONID
                                         AND B.CURRENT_FLG = 'Y'),
                     /*����*/ ORD AS (SELECT B.POSTING_DATE_KEY,
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
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
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
    /*ͳ�ƻ�Ա�����Ծ��15������
    ϲ������Ʒ�����+�ղ�+�ӳ�-����*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    MIN_DAY     NUMBER; /*�����Ծ����*/
    MAX_DAY     NUMBER; /*�����Ծ����*/
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_LIKE_PKG.OPER_MEMBER_LIKE_ITEM_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MEMBER_LIKE_ITEM'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*��ɾ����������*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_MEMBER_LIKE_ITEM_TMP_A';
    
      DECLARE
        TYPE TYPE_ARRAYS IS RECORD(
          MEMBER_KEY NUMBER(20));
      
        TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --���ƶ�ά���� 
      
        VAR_ARRAY TYPE_ARRAY;
      BEGIN
        /*�����Ծ�Ļ�ԱBP��*/
        SELECT P.*
          BULK COLLECT
          INTO VAR_ARRAY
          FROM (SELECT MEMBER_KEY
                  FROM OPER_MEMBER_LIKE_BASE
                 WHERE POSTING_DATE_KEY = IN_POSTING_DATE_KEY
                 GROUP BY MEMBER_KEY) P;
      
        FOR I IN 1 .. VAR_ARRAY.COUNT LOOP
          /*ȡ��ĳһ����Ա��Ծ��15����������*/
          SELECT P.MAX_DAY
            INTO MAX_DAY
            FROM (SELECT TO_NUMBER(MAX(POSTING_DATE_KEY)) MAX_DAY
                    FROM (SELECT DISTINCT (POSTING_DATE_KEY) AS POSTING_DATE_KEY
                            FROM OPER_MEMBER_LIKE_BASE
                           WHERE MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                           ORDER BY POSTING_DATE_KEY DESC)
                   WHERE ROWNUM <= 15) P;
          /*ȡ��ĳһ����Ա��Ծ��15�����С����*/
          SELECT P.MIN_DAY
            INTO MIN_DAY
            FROM (SELECT TO_NUMBER(MIN(POSTING_DATE_KEY)) MIN_DAY
                    FROM (SELECT DISTINCT (POSTING_DATE_KEY) AS POSTING_DATE_KEY
                            FROM OPER_MEMBER_LIKE_BASE
                           WHERE MEMBER_KEY = VAR_ARRAY(I).MEMBER_KEY
                           ORDER BY POSTING_DATE_KEY DESC)
                   WHERE ROWNUM <= 15) P;
          /*д��OPER_MEMBER_LIKE_ITEM_TMP_A��ʱ��*/
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
                               A.ORDER_WEIGHT) TOTAL_ITEM_WEIGHT /*��Ʒ�ϼ�Ȩ��*/
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
        /*ֻȡһ����Ա����ƷȨ��ǰ10����Ʒ��������*/
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
                   WHERE B.ITEM_RANKING <= 10
                   ORDER BY B.MEMBER_KEY, B.ITEM_RANKING) C;
        INSERT_ROWS := SQL%ROWCOUNT;
        COMMIT;
      END;
    END;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
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
    /*ͳ�ƻ�Ա�����Ծ��15������
    ϲ����С�ࣺ���+�ղ�+�ӳ�+����*/
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    MIN_DAY     NUMBER; /*�����Ծ����*/
    MAX_DAY     NUMBER; /*�����Ծ����*/
  
  BEGIN
    SP_NAME          := 'OPER_MEMBER_LIKE_PKG.OPER_MEMBER_LIKE_MATXL_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'OPER_MEMBER_LIKE_ITEM'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.ERR_MSG := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    BEGIN
      /*��ɾ����������*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE OPER_MEMBER_LIKE_MATXL_TMP_A';
    
      DECLARE
        TYPE TYPE_ARRAYS IS RECORD(
          MEMBER_KEY NUMBER(20));
      
        TYPE TYPE_ARRAY IS TABLE OF TYPE_ARRAYS INDEX BY BINARY_INTEGER; --���ƶ�ά���� 
      
        VAR_ARRAY TYPE_ARRAY;
      BEGIN
        /*�����Ծ�Ļ�ԱBP��*/
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
                               A.ORDER_WEIGHT) TOTAL_ITEM_WEIGHT /*С��ϼ�Ȩ��*/
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
        /*ֻȡС��Ȩ��ǰ10����������*/
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
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ERR_MSG        := '�������:IN_POSTING_DATE_KEY:' ||
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

END OPER_MEMBER_LIKE_PKG;
/
