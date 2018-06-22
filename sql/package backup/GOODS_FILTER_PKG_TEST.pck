CREATE OR REPLACE PACKAGE GOODS_FILTER_PKG_TEST IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2018-05-04 ����ڿ��֣�����
  -- PURPOSE : GOODS_FILTER_PKG

  PROCEDURE SYNC_GOODS_LABEL_HEAD(IN_SYNC_DATE_KEY IN NUMBER);
  /*
  ������:       SYNC_GOODS_LABEL_HEAD
  Ŀ��:         GOODS_LABEL_HEADͬ��
  ����:         yangjin
  ����ʱ�䣺    2018/05/04
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE SYNC_GOODS_LABEL_LINK;
  /*
  ������:       SYNC_GOODS_LABEL_LINK
  Ŀ��:         GOODS_LABEL_LINKͬ��
  ����:         yangjin
  ����ʱ�䣺    2018/05/04
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE GOODS_RESULT_TO_TABLE;
  /*
  ������:       GOODS_RESULT_TO_TABLE
  Ŀ��:         ��Աɸѡд������
  ����:         yangjin
  ����ʱ�䣺    2018/05/24
  ����޸��ˣ�
  ���������ڣ�
  */

END GOODS_FILTER_PKG_TEST;
/
CREATE OR REPLACE PACKAGE BODY GOODS_FILTER_PKG_TEST IS

  PROCEDURE SYNC_GOODS_LABEL_HEAD(IN_SYNC_DATE_KEY IN NUMBER) IS
    S_ETL        W_ETL_LOG%ROWTYPE;
    SP_NAME      S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER  S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS  NUMBER;
    UPDATE_ROWS  NUMBER;
    IN_SYNC_DATE DATE;
    /*
       Ŀ��:      ͬ��27�ϵ�member_label_head
       ����:      yangjin
       ����ʱ��:  2017/10/10
    */
  BEGIN
    SP_NAME          := 'GOODS_FILTER_PKG.SYNC_GOODS_LABEL_HEAD'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'GOODS_LABEL_HEAD'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_SYNC_DATE     := TO_DATE(IN_SYNC_DATE_KEY, 'YYYYMMDD');
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
    /*ͬ��MEMBER_LABEL_HEAD*/
    /*�Ȳ��뵽��ʱ��*/
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GOODS_LABEL_HEAD_TMP';
    INSERT INTO GOODS_LABEL_HEAD_TMP
      (G_LABEL_ID,
       G_LABEL_NAME,
       G_LABEL_DESC,
       G_LABEL_TYPE_ID,
       IS_LEAF_NODE,
       CREATE_DATE,
       CREATE_USER_ID,
       LAST_UPDATE_DATE,
       LAST_UPDATE_USER_ID,
       CURRENT_FLAG,
       G_LABEL_FATHER_ID)
      SELECT A.G_LABEL_ID,
             A.G_LABEL_NAME,
             A.G_LABEL_DESC,
             A.G_LABEL_TYPE_ID,
             A.IS_LEAF_NODE,
             A.CREATE_DATE,
             A.CREATE_USER_ID,
             A.LAST_UPDATE_DATE,
             A.LAST_UPDATE_USER_ID,
             A.CURRENT_FLAG,
             A.G_LABEL_FATHER_ID
        FROM GOODS_LABEL_HEAD@DW27 A
       WHERE TRUNC(A.LAST_UPDATE_DATE) >= TRUNC(IN_SYNC_DATE);
    COMMIT;
  
    /*������ʱ��*/
    DBMS_STATS.GATHER_TABLE_STATS('ML', 'GOODS_LABEL_HEAD_TMP');
  
    /*���뵽��ʽ��*/
    MERGE /*+APPEND*/
    INTO GOODS_LABEL_HEAD T
    USING GOODS_LABEL_HEAD_TMP S
    ON (T.G_LABEL_ID = S.G_LABEL_ID)
    WHEN MATCHED THEN
      UPDATE
         SET T.G_LABEL_NAME        = S.G_LABEL_NAME,
             T.G_LABEL_DESC        = S.G_LABEL_DESC,
             T.G_LABEL_TYPE_ID     = S.G_LABEL_TYPE_ID,
             T.IS_LEAF_NODE        = S.IS_LEAF_NODE,
             T.CREATE_DATE         = S.CREATE_DATE,
             T.CREATE_USER_ID      = S.CREATE_USER_ID,
             T.LAST_UPDATE_DATE    = S.LAST_UPDATE_DATE,
             T.LAST_UPDATE_USER_ID = S.LAST_UPDATE_USER_ID,
             T.CURRENT_FLAG        = S.CURRENT_FLAG,
             T.G_LABEL_FATHER_ID   = S.G_LABEL_FATHER_ID
    WHEN NOT MATCHED THEN
      INSERT
        (T.G_LABEL_ID,
         T.G_LABEL_NAME,
         T.G_LABEL_DESC,
         T.G_LABEL_TYPE_ID,
         T.IS_LEAF_NODE,
         T.CREATE_DATE,
         T.CREATE_USER_ID,
         T.LAST_UPDATE_DATE,
         T.LAST_UPDATE_USER_ID,
         T.CURRENT_FLAG,
         T.G_LABEL_FATHER_ID)
      VALUES
        (S.G_LABEL_ID,
         S.G_LABEL_NAME,
         S.G_LABEL_DESC,
         S.G_LABEL_TYPE_ID,
         S.IS_LEAF_NODE,
         S.CREATE_DATE,
         S.CREATE_USER_ID,
         S.LAST_UPDATE_DATE,
         S.LAST_UPDATE_USER_ID,
         S.CURRENT_FLAG,
         S.G_LABEL_FATHER_ID);
    INSERT_ROWS := SQL%ROWCOUNT;
    COMMIT;
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������:IN_SYNC_DATE_KEY:' ||
                            TO_CHAR(IN_SYNC_DATE_KEY);
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
  END SYNC_GOODS_LABEL_HEAD;

  PROCEDURE SYNC_GOODS_LABEL_LINK IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
       Ŀ��:      ͬ��27�ϵ�member_label_link
       ����:      yangjin
       ����ʱ��:  2017/10/10
    */
  BEGIN
    SP_NAME          := 'GOODS_FILTER_PKG.SYNC_GOODS_LABEL_LINK'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'GOODS_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
  
    BEGIN
      SP_PARAMETER_TWO(SP_NAME, S_PARAMETER);
      IF S_PARAMETER = '0'
      THEN
        S_ETL.END_TIME := SYSDATE;
        S_ETL.ERR_MSG  := 'û���ҵ���Ӧ�Ĺ��̼�����������';
        SP_SBI_W_ETL_LOG(S_ETL);
        RETURN;
      END IF;
    END;
  
    /*ˢ���ﻯ��ͼMEMBER_LABEL_LINK_MV*/
    DBMS_MVIEW.REFRESH('GOODS_LABEL_LINK_MV', METHOD => 'FAST');
  
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '���������';
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
  END SYNC_GOODS_LABEL_LINK;

  PROCEDURE GOODS_RESULT_TO_TABLE IS
    V_TABLE_HEAD GOODS_FILTER_OPTION_HEAD%ROWTYPE;
    V_STR_SQL    VARCHAR2(4000);
  
    /*
       Ŀ��:      ִ����Ʒɸѡ����
       ����:      yangjin
       ����ʱ��:  2017/10/24
    */
  BEGIN
    /*��¼ִ�п�ʼʱ��*/
    V_TABLE_HEAD.EXECUTION_START_TIME := SYSDATE;
  
    /*��ȡ�����е���СFILTER_ID*/
    SELECT MIN(A.FILTER_ID)
      INTO V_TABLE_HEAD.FILTER_ID
      FROM MEMBER_FILTER_OPTION_HEAD A
     WHERE (A.MEMBER_LABEL_ID_SET IS NOT NULL OR
           A.ITEM_CODE_SET IS NOT NULL OR A.BRAND_SET IS NOT NULL OR
           A.MATXL_SET IS NOT NULL) /*�����Ա��ǩ����Ʒ���롢Ʒ�ơ�С����붼Ϊ�գ���ִ��*/
       AND A.STATUS = 0;
  
    /*��ȡ��filter_id֮����ִ�к�������*/
    IF V_TABLE_HEAD.FILTER_ID IS NOT NULL
    THEN
      /*�޸�״̬Ϊ����ִ��*/
      UPDATE MEMBER_FILTER_OPTION_HEAD A
         SET A.STATUS = 1
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
      COMMIT;
    
      /*ȡ����Ʒɸѡ����*/
      SELECT A.GOODS_LABEL_ID_SET
        INTO V_TABLE_HEAD.GOODS_LABEL_ID_SET
        FROM GOODS_FILTER_OPTION_HEAD A
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
    
      /*      \*ת����SQL���*\
      V_STR_SQL := GOODS_FILTER_PKG.SPLICE_SQL(V_TABLE_HEAD.FILTER_ID,
                                                V_TABLE_HEAD.GOODS_LABEL_ID_SET);*/
    
      /*ִ��SQL���*/
      DBMS_OUTPUT.PUT_LINE(V_STR_SQL);
      EXECUTE IMMEDIATE V_STR_SQL;
    
      /*��¼�������������*/
      SELECT NVL(COUNT(DISTINCT A.MEMBER_BP), 0)
        INTO V_TABLE_HEAD.RESULT_RECORDS
        FROM MEMBER_FILTER_RESULT A
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
    
      /*      \*����ɸѡ������ı��ļ�*\
      MEMBER_OUTPUT_FILE(V_TABLE_HEAD.FILTER_ID,
                         V_TABLE_HEAD.OUTPUT_FILE_PATH);*/
    
      /*��¼ִ�����ʱ��*/
      V_TABLE_HEAD.EXECUTION_END_TIME := SYSDATE;
    
      /*ִ�����д���¼*/
      UPDATE GOODS_FILTER_OPTION_HEAD A
         SET A.STATUS               = 2,
             A.RESULT_MESSAGE       = 'SUCCESS',
             A.EXECUTION_START_TIME = V_TABLE_HEAD.EXECUTION_START_TIME,
             A.EXECUTION_END_TIME   = V_TABLE_HEAD.EXECUTION_END_TIME,
             A.RESULT_RECORDS       = V_TABLE_HEAD.RESULT_RECORDS,
             A.OUTPUT_FILE_PATH     = V_TABLE_HEAD.OUTPUT_FILE_PATH
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID
         AND A.STATUS = 1;
      COMMIT;
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      V_TABLE_HEAD.RESULT_MESSAGE := SQLERRM;
      UPDATE GOODS_FILTER_OPTION_HEAD A
         SET A.STATUS               = 9,
             A.RESULT_MESSAGE       = V_TABLE_HEAD.RESULT_MESSAGE,
             A.EXECUTION_START_TIME = V_TABLE_HEAD.EXECUTION_START_TIME,
             A.EXECUTION_END_TIME   = V_TABLE_HEAD.EXECUTION_END_TIME,
             A.RESULT_RECORDS       = V_TABLE_HEAD.RESULT_RECORDS,
             A.OUTPUT_FILE_PATH     = V_TABLE_HEAD.OUTPUT_FILE_PATH
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID
         AND A.STATUS = 1;
      COMMIT;
  END GOODS_RESULT_TO_TABLE;

END GOODS_FILTER_PKG_TEST;
/
