CREATE OR REPLACE PACKAGE HAPPIGO_KPI_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2018-02-23 11:08:17
  -- PURPOSE : KPI����ָ��

  PROCEDURE KPI_ACTIVE_VID_BASE_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ACTIVE_VID_BASE
  Ŀ��:         ��Ծ�豸����
  ����:         yangjin
  ����ʱ�䣺    2018/02/23
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_VID_FIRST_VISIT_PROC;
  /*
  ������:       KPI_VID_FIRST_VISIT_PROC
  Ŀ��:         ����VID�ĵ�һ�η�������
  ����:         yangjin
  ����ʱ�䣺    2018/02/23
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_APP_MAU_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_APP_MAU_PROC
  Ŀ��:         KPI����ָ��-������Ӫ��-APP�»�
  ����:         yangjin
  ����ʱ�䣺    2018/02/24
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_WX_DAU_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_WX_DAU_PROC
  Ŀ��:         KPI����ָ��-΢����Ӫ��-΢���ջ�
  ����:         yangjin
  ����ʱ�䣺    2018/02/24
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_WX_NEW_REG_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_WX_NEW_REG_PROC
  Ŀ��:         KPI����ָ��-΢����Ӫ��-����ע����
  ����:         yangjin
  ����ʱ�䣺    2018/02/24
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_NEW_UV_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_NEW_UV_PROC
  Ŀ��:         KPI����ָ��-�г���-�վ��·ÿ���
  ����:         yangjin
  ����ʱ�䣺    2018/02/24
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_OLD_UV_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_OLD_UV_PROC
  Ŀ��:         KPI����ָ��-�г���-�վ��Ϸÿ���
  ����:         yangjin
  ����ʱ�䣺    2018/02/24
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_APP_NET_ORDER_CVR_P(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_APP_NET_ORDER_CVR_P
  Ŀ��:         KPI����ָ��-������Ӫ��-APP������ת����
  ����:         yangjin
  ����ʱ�䣺    2018/02/24
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_APP_ITEM_CVR_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_APP_ITEM_CVR_P
  Ŀ��:         KPI����ָ��-������Ӫ��-��Ʒ����ҳת����
  ����:         yangjin
  ����ʱ�䣺    2018/02/26
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_WX_NON_SCAN_CVR_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_WX_NON_SCAN_CVR_PROC
  Ŀ��:         KPI����ָ��-΢����Ӫ��-��ɨ������������ת����
  ����:         yangjin
  ����ʱ�䣺    2018/02/27
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_VEDIO_ITEM_CVR_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_VEDIO_ITEM_CVR_PROC
  Ŀ��:         KPI����ָ��-΢����Ӫ��-��Ƶ����Ʒ����ҳת����
  ����:         yangjin
  ����ʱ�䣺    2018/02/28
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_APP_DOWNLOAD_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_APP_DOWNLOAD_PROC
  Ŀ��:         KPI����ָ��-�г���-APP����������
  ����:         yangjin
  ����ʱ�䣺    2018/02/28
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_REG_ORDER_CVR_PROC(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_REG_ORDER_CVR_PROC
  Ŀ��:         KPI����ָ��-�г���-������ע���Ա������ת����
  ����:         yangjin
  ����ʱ�䣺    2018/02/28
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE KPI_ASMT_REPURCHASE_MEMBER_P(IN_DATE_KEY IN NUMBER);
  /*
  ������:       KPI_ASMT_REPURCHASE_MEMBER_P
  Ŀ��:         KPI����ָ��-�г���-�ϻ�Ա��������
  ����:         yangjin
  ����ʱ�䣺    2018/02/28
  ����޸��ˣ�
  ���������ڣ�
  */

END HAPPIGO_KPI_PKG;
/
CREATE OR REPLACE PACKAGE BODY HAPPIGO_KPI_PKG IS

  PROCEDURE KPI_ACTIVE_VID_BASE_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-01-31
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_KPI_PKG.KPI_ACTIVE_VID_BASE_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'KPI_ACTIVE_VID_BASE'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
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
  
    BEGIN
      /*��ɾ������*/
      DELETE KPI_ACTIVE_VID_BASE A WHERE A.START_DATE_KEY = IN_DATE_KEY;
      UPDATE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*��������*/
      INSERT INTO KPI_ACTIVE_VID_BASE
        (START_DATE_KEY, APPLICATION_KEY, VID, W_INSERT_DT, W_UPDATE_DT)
        SELECT DISTINCT A.START_DATE_KEY,
                        A.APPLICATION_KEY,
                        A.VID,
                        SYSDATE           W_INSERT_DT,
                        SYSDATE           W_UPDATE_DT
          FROM FACT_SESSION A
         WHERE A.START_DATE_KEY = IN_DATE_KEY;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ACTIVE_VID_BASE_PROC;

  PROCEDURE KPI_VID_FIRST_VISIT_PROC IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-01-31
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_KPI_PKG.KPI_VID_FIRST_VISIT_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'KPI_VID_FIRST_VISIT'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
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
  
    BEGIN
      /*��������*/
      MERGE /*+APPEND*/
      INTO KPI_VID_FIRST_VISIT T
      USING (SELECT A.VID,
                    MIN(A.START_DATE_KEY) MIN_VISIT_DATE_KEY,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM KPI_ACTIVE_VID_BASE A
              WHERE NOT EXISTS
              (SELECT 1 FROM KPI_VID_FIRST_VISIT B WHERE A.VID = B.VID)
              GROUP BY A.VID) S
      ON (T.VID = S.VID)
      WHEN MATCHED THEN
        UPDATE
           SET T.MIN_VISIT_DATE_KEY = S.MIN_VISIT_DATE_KEY,
               T.W_UPDATE_DT        = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.VID, T.MIN_VISIT_DATE_KEY, T.W_INSERT_DT, T.W_UPDATE_DT)
        VALUES
          (S.VID, S.MIN_VISIT_DATE_KEY, S.W_INSERT_DT, S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
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
  END KPI_VID_FIRST_VISIT_PROC;

  PROCEDURE KPI_ASMT_APP_MAU_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL                  W_ETL_LOG%ROWTYPE;
    SP_NAME                S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER            S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS            NUMBER;
    UPDATE_ROWS            NUMBER;
    DELETE_ROWS            NUMBER;
    V_MONTH_FIRST_DATE_KEY NUMBER; /*���µĵ�һ��*/
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME                := 'HAPPIGO_KPI_PKG.KPI_ASMT_APP_MAU_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME       := 'KPI_ASMT_APP_MAU'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME        := SP_NAME;
    S_ETL.START_TIME       := SYSDATE;
    S_PARAMETER            := 0;
    V_MONTH_FIRST_DATE_KEY := TO_CHAR(TRUNC(TO_DATE(IN_DATE_KEY, 'YYYYMMDD'),
                                            'MM'),
                                      'YYYYMMDD');
  
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
  
    BEGIN
      /*���²�������,ͳ�Ƶ���1�ŵ����յ�����*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_APP_MAU T
      USING (SELECT SUBSTR(A.START_DATE_KEY, 1, 6) MONTH_KEY,
                    COUNT(DISTINCT A.VID) MAU,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM KPI_ACTIVE_VID_BASE A
              WHERE A.APPLICATION_KEY IN (10, 20)
                AND A.START_DATE_KEY BETWEEN V_MONTH_FIRST_DATE_KEY AND
                    IN_DATE_KEY
              GROUP BY SUBSTR(A.START_DATE_KEY, 1, 6)) S
      ON (T.MONTH_KEY = S.MONTH_KEY)
      WHEN MATCHED THEN
        UPDATE SET T.MAU = S.MAU, T.W_UPDATE_DT = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MONTH_KEY, T.MAU, T.W_INSERT_DT, T.W_UPDATE_DT)
        VALUES
          (S.MONTH_KEY, S.MAU, S.W_INSERT_DT, S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_APP_MAU_PROC;

  PROCEDURE KPI_ASMT_WX_DAU_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL                  W_ETL_LOG%ROWTYPE;
    SP_NAME                S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER            S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS            NUMBER;
    UPDATE_ROWS            NUMBER;
    DELETE_ROWS            NUMBER;
    V_MONTH_FIRST_DATE_KEY NUMBER; /*���µĵ�һ��*/
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME                := 'HAPPIGO_KPI_PKG.KPI_ASMT_WX_DAU_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME       := 'KPI_ASMT_WX_DAU'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME        := SP_NAME;
    S_ETL.START_TIME       := SYSDATE;
    S_PARAMETER            := 0;
    V_MONTH_FIRST_DATE_KEY := TO_CHAR(TRUNC(TO_DATE(IN_DATE_KEY, 'YYYYMMDD'),
                                            'MM'),
                                      'YYYYMMDD');
  
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
  
    BEGIN
      /*���²�������,ͳ�Ƶ���1�ŵ����յ��ջ�ƽ��ֵ*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_WX_DAU T
      USING (SELECT SUBSTR(A.VISIT_DATE_KEY, 1, 6) MONTH_KEY,
                    ROUND(AVG(A.UVCNT)) DAU,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM FACT_DAILY_WX A
              WHERE A.VISIT_DATE_KEY BETWEEN V_MONTH_FIRST_DATE_KEY AND
                    IN_DATE_KEY
              GROUP BY SUBSTR(A.VISIT_DATE_KEY, 1, 6)) S
      ON (T.MONTH_KEY = S.MONTH_KEY)
      WHEN MATCHED THEN
        UPDATE SET T.DAU = S.DAU, T.W_UPDATE_DT = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MONTH_KEY, T.DAU, T.W_INSERT_DT, T.W_UPDATE_DT)
        VALUES
          (S.MONTH_KEY, S.DAU, S.W_INSERT_DT, S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_WX_DAU_PROC;

  PROCEDURE KPI_ASMT_WX_NEW_REG_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL                  W_ETL_LOG%ROWTYPE;
    SP_NAME                S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER            S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS            NUMBER;
    UPDATE_ROWS            NUMBER;
    DELETE_ROWS            NUMBER;
    V_MONTH_FIRST_DATE_KEY NUMBER; /*���µĵ�һ��*/
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME                := 'HAPPIGO_KPI_PKG.KPI_ASMT_WX_NEW_REG_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME       := 'KPI_ASMT_WX_NEW_REG'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME        := SP_NAME;
    S_ETL.START_TIME       := SYSDATE;
    S_PARAMETER            := 0;
    V_MONTH_FIRST_DATE_KEY := TO_CHAR(TRUNC(TO_DATE(IN_DATE_KEY, 'YYYYMMDD'),
                                            'MM'),
                                      'YYYYMMDD');
  
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
  
    BEGIN
      /*���²�������,ͳ�Ƶ���1�ŵ����յ�����ע����ƽ��ֵ*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_WX_NEW_REG T
      USING (SELECT SUBSTR(A.VISIT_DATE_KEY, 1, 6) MONTH_KEY,
                    ROUND(AVG(A.UVCNT)) NEW_REG_COUNT,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM FACT_DAILY_WX A
              WHERE A.VISIT_DATE_KEY BETWEEN V_MONTH_FIRST_DATE_KEY AND
                    IN_DATE_KEY
              GROUP BY SUBSTR(A.VISIT_DATE_KEY, 1, 6)) S
      ON (T.MONTH_KEY = S.MONTH_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.NEW_REG_COUNT = S.NEW_REG_COUNT,
               T.W_UPDATE_DT   = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MONTH_KEY, T.NEW_REG_COUNT, T.W_INSERT_DT, T.W_UPDATE_DT)
        VALUES
          (S.MONTH_KEY, S.NEW_REG_COUNT, S.W_INSERT_DT, S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_WX_NEW_REG_PROC;

  PROCEDURE KPI_ASMT_NEW_UV_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_KPI_PKG.KPI_ASMT_NEW_UV_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'KPI_ASMT_NEW_UV'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
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
  
    BEGIN
      /*���²�������,ͳ��ÿ���ȫ�����·ÿ�*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_NEW_UV T
      USING (SELECT A.START_DATE_KEY DATE_KEY,
                    COUNT(DISTINCT A.VID) NEW_VISIT_COUNT,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM KPI_ACTIVE_VID_BASE A
              WHERE EXISTS (SELECT 1
                       FROM KPI_VID_FIRST_VISIT B
                      WHERE A.VID = B.VID
                        AND B.MIN_VISIT_DATE_KEY = IN_DATE_KEY)
                AND A.START_DATE_KEY = IN_DATE_KEY
              GROUP BY A.START_DATE_KEY) S
      ON (T.DATE_KEY = S.DATE_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.NEW_VISIT_COUNT = S.NEW_VISIT_COUNT,
               T.W_UPDATE_DT     = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.DATE_KEY, T.NEW_VISIT_COUNT, T.W_INSERT_DT, T.W_UPDATE_DT)
        VALUES
          (S.DATE_KEY, S.NEW_VISIT_COUNT, S.W_INSERT_DT, S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_NEW_UV_PROC;

  PROCEDURE KPI_ASMT_OLD_UV_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_KPI_PKG.KPI_ASMT_OLD_UV_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'KPI_ASMT_OLD_UV'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
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
  
    BEGIN
      /*���²�������,ͳ��ÿ���ȫ�����Ϸÿ�*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_OLD_UV T
      USING (SELECT A.START_DATE_KEY DATE_KEY,
                    COUNT(DISTINCT A.VID) OLD_VISIT_COUNT,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM KPI_ACTIVE_VID_BASE A
              WHERE EXISTS (SELECT 1
                       FROM KPI_VID_FIRST_VISIT B
                      WHERE A.VID = B.VID
                        AND B.MIN_VISIT_DATE_KEY <> IN_DATE_KEY)
                AND A.START_DATE_KEY = IN_DATE_KEY
              GROUP BY A.START_DATE_KEY) S
      ON (T.DATE_KEY = S.DATE_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.OLD_VISIT_COUNT = S.OLD_VISIT_COUNT,
               T.W_UPDATE_DT     = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.DATE_KEY, T.OLD_VISIT_COUNT, T.W_INSERT_DT, T.W_UPDATE_DT)
        VALUES
          (S.DATE_KEY, S.OLD_VISIT_COUNT, S.W_INSERT_DT, S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_OLD_UV_PROC;

  PROCEDURE KPI_ASMT_APP_NET_ORDER_CVR_P(IN_DATE_KEY IN NUMBER) IS
    S_ETL                  W_ETL_LOG%ROWTYPE;
    SP_NAME                S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER            S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS            NUMBER;
    UPDATE_ROWS            NUMBER;
    DELETE_ROWS            NUMBER;
    V_MONTH_FIRST_DATE_KEY NUMBER; /*���µĵ�һ��*/
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME                := 'HAPPIGO_KPI_PKG.KPI_ASMT_APP_NET_ORDER_CVR_P'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME       := 'KPI_ASMT_APP_NET_ORDER_CVR'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME        := SP_NAME;
    S_ETL.START_TIME       := SYSDATE;
    S_PARAMETER            := 0;
    V_MONTH_FIRST_DATE_KEY := TO_CHAR(TRUNC(TO_DATE(IN_DATE_KEY, 'YYYYMMDD'),
                                            'MM'),
                                      'YYYYMMDD');
  
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
  
    BEGIN
      /*���²�������,ͳ��ÿ�µ�ƽ��APP������ת����*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_APP_NET_ORDER_CVR T
      USING (SELECT SUBSTR(A.VISIT_DATE_KEY, 1, 6) MONTH_KEY,
                    ROUND(AVG(NVL(A.ORDERRATE, 0)), 4) CVR,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM FACT_DAILY_APP A
              WHERE A.VISIT_DATE_KEY BETWEEN V_MONTH_FIRST_DATE_KEY AND
                    IN_DATE_KEY
              GROUP BY SUBSTR(A.VISIT_DATE_KEY, 1, 6)
              ORDER BY SUBSTR(A.VISIT_DATE_KEY, 1, 6)) S
      ON (T.MONTH_KEY = S.MONTH_KEY)
      WHEN MATCHED THEN
        UPDATE SET T.CVR = S.CVR, T.W_UPDATE_DT = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MONTH_KEY, T.CVR, T.W_INSERT_DT, T.W_UPDATE_DT)
        VALUES
          (S.MONTH_KEY, S.CVR, S.W_INSERT_DT, S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_APP_NET_ORDER_CVR_P;

  PROCEDURE KPI_ASMT_APP_ITEM_CVR_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
  
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_KPI_PKG.KPI_ASMT_APP_ITEM_CVR_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'KPI_ASMT_APP_ITEM_CVR'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
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
  
    BEGIN
      /*���²�������,ͳ��ÿ�µ�ƽ����Ʒ����ҳת����*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_APP_ITEM_CVR T
      USING (SELECT A.VISIT_DATE_KEY DATE_KEY,
                    A.GC_NAME,
                    NVL(A.VISIT_COUNT, 0) VISIT_COUNT,
                    NVL(B.ORDER_COUNT, 0) ORDER_COUNT,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM (SELECT GC_NAME,
                            VISIT_DATE_KEY,
                            COUNT(DISTINCT(VID)) AS VISIT_COUNT
                       FROM (SELECT VID,
                                    TO_CHAR(PAGE_VALUE) PAGE_VALUE,
                                    VISIT_DATE_KEY
                               FROM FACT_PAGE_VIEW
                              WHERE VISIT_DATE_KEY = IN_DATE_KEY
                                AND APPLICATION_KEY IN (10, 20)
                                AND PAGE_NAME = 'Good') A
                       LEFT JOIN (SELECT GC_NAME,
                                        TO_CHAR(GOODS_COMMONID) GOODS_COMMONID
                                   FROM (SELECT GOODS_COMMONID, MATDL
                                           FROM DIM_EC_GOOD) AA
                                   JOIN (SELECT MATDL, GC_NAME
                                          FROM DIM_GOOD_CLASS
                                         WHERE GC_NAME IS NOT NULL) BB
                                     ON AA.MATDL = BB.MATDL
                                  GROUP BY GC_NAME, GOODS_COMMONID) B
                         ON A.PAGE_VALUE = B.GOODS_COMMONID
                      GROUP BY GC_NAME, VISIT_DATE_KEY) A
               LEFT JOIN (SELECT GC_NAME,
                                VISIT_DATE_KEY,
                                COUNT(DISTINCT(VID)) AS ORDER_COUNT
                           FROM (SELECT VID,
                                        TO_CHAR(PAGE_VALUE) PAGE_VALUE,
                                        VISIT_DATE_KEY
                                   FROM FACT_PAGE_VIEW_HIT /*synonym*/
                                  WHERE VISIT_DATE_KEY = IN_DATE_KEY
                                    AND APPLICATION_KEY IN (10, 20)
                                    AND PAGE_NAME IN
                                        ('SL_Good_Order', 'SL_Good_Shoppcar')) A
                           LEFT JOIN (SELECT GC_NAME,
                                            TO_CHAR(GOODS_COMMONID) GOODS_COMMONID
                                       FROM (SELECT GOODS_COMMONID, MATDL
                                               FROM DIM_EC_GOOD) AA
                                       JOIN (SELECT MATDL, GC_NAME
                                              FROM DIM_GOOD_CLASS) BB
                                         ON AA.MATDL = BB.MATDL
                                      GROUP BY GC_NAME, GOODS_COMMONID) B
                             ON A.PAGE_VALUE = B.GOODS_COMMONID
                          GROUP BY GC_NAME, VISIT_DATE_KEY) B
                 ON A.GC_NAME = B.GC_NAME
                AND A.VISIT_DATE_KEY = B.VISIT_DATE_KEY
              WHERE A.GC_NAME IS NOT NULL) S
      ON (T.DATE_KEY = S.DATE_KEY AND T.GC_NAME = S.GC_NAME)
      WHEN MATCHED THEN
        UPDATE
           SET T.VISIT_COUNT = S.VISIT_COUNT,
               T.ORDER_COUNT = S.ORDER_COUNT,
               T.W_UPDATE_DT = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.DATE_KEY,
           T.VISIT_COUNT,
           T.ORDER_COUNT,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.DATE_KEY,
           S.VISIT_COUNT,
           S.ORDER_COUNT,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_APP_ITEM_CVR_PROC;

  PROCEDURE KPI_ASMT_WX_NON_SCAN_CVR_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
  
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_KPI_PKG.KPI_ASMT_WX_NON_SCAN_CVR_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'KPI_ASMT_WX_NON_SCAN_CVR'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
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
  
    BEGIN
      /*���²�������,ͳ��ÿ��ķ�ɨ������������ת����*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_WX_NON_SCAN_CVR T
      USING (SELECT A.DATE_KEY,
                    ROUND(A.MEMBER_COUNT / B.VID_COUNT, 4) CVR,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM (SELECT A1.ADD_TIME DATE_KEY,
                            COUNT(DISTINCT A1.MEMBER_KEY) MEMBER_COUNT
                       FROM FACTEC_ORDER A1
                      WHERE A1.APP_NAME = 'KLGWX'
                        AND A1.ORDER_FROM != 76
                        AND A1.STORE_ID = 1
                        AND A1.ADD_TIME = IN_DATE_KEY
                        AND A1.CANCEL_BEFORE_STATE = 0
                        AND A1.CRM_ORDER_NO > 0
                      GROUP BY A1.ADD_TIME) A,
                    (SELECT B1.START_DATE_KEY DATE_KEY,
                            COUNT(DISTINCT B1.VID) VID_COUNT
                       FROM FACT_SESSION B1
                      WHERE B1.START_DATE_KEY = IN_DATE_KEY
                        AND B1.APPLICATION_KEY = 50
                        AND B1.VID NOT IN
                            (SELECT VID
                               FROM DIM_VID_SCAN
                              WHERE SCAN_DATE_KEY = IN_DATE_KEY)
                      GROUP BY B1.START_DATE_KEY) B
              WHERE A.DATE_KEY = B.DATE_KEY) S
      ON (T.DATE_KEY = S.DATE_KEY)
      WHEN MATCHED THEN
        UPDATE SET T.CVR = S.CVR, T.W_UPDATE_DT = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.DATE_KEY, T.CVR, T.W_INSERT_DT, T.W_UPDATE_DT)
        VALUES
          (S.DATE_KEY, S.CVR, S.W_INSERT_DT, S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_WX_NON_SCAN_CVR_PROC;

  PROCEDURE KPI_ASMT_VEDIO_ITEM_CVR_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
  
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_KPI_PKG.KPI_ASMT_VEDIO_ITEM_CVR_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'KPI_ASMT_VEDIO_ITEM_CVR'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
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
  
    BEGIN
      /*���²�������,ͳ��ÿ�����Ƶ����Ʒ����ҳת����*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_VEDIO_ITEM_CVR T
      USING (SELECT F.DATE_KEY,
                    F.ORDER_VID_COUNT,
                    G.UV_VID_COUNT,
                    SYSDATE           W_INSERT_DT,
                    SYSDATE           W_UPDATE_DT
               FROM (SELECT B.ADD_TIME DATE_KEY,
                            COUNT(DISTINCT B.VID) ORDER_VID_COUNT
                       FROM FACTEC_ORDER_GOODS A, FACTEC_ORDER B
                      WHERE A.ORDER_ID = B.ORDER_ID
                        AND B.ADD_TIME = IN_DATE_KEY
                        AND B.ORDER_STATE > 10
                        AND EXISTS
                      (SELECT 1
                               FROM DIM_EC_GOOD C
                              WHERE IS_VEDIO = 1
                                AND A.EC_GOODS_COMMON = C.GOODS_COMMONID)
                      GROUP BY B.ADD_TIME) F,
                    (SELECT D.VISIT_DATE_KEY DATE_KEY,
                            COUNT(DISTINCT(D.VID)) UV_VID_COUNT
                       FROM FACT_PAGE_VIEW D
                      WHERE D.VISIT_DATE_KEY = IN_DATE_KEY
                        AND D.APPLICATION_KEY IN (10, 20)
                        AND D.PAGE_NAME = 'Good'
                        AND EXISTS
                      (SELECT 1
                               FROM DIM_EC_GOOD E
                              WHERE E.IS_VEDIO = 1
                                AND D.PAGE_VALUE = E.GOODS_COMMONID)
                      GROUP BY D.VISIT_DATE_KEY) G
              WHERE F.DATE_KEY = G.DATE_KEY) S
      ON (T.DATE_KEY = S.DATE_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.ORDER_VID_COUNT = S.ORDER_VID_COUNT,
               T.UV_VID_COUNT    = S.UV_VID_COUNT,
               T.W_UPDATE_DT     = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.DATE_KEY,
           T.ORDER_VID_COUNT,
           T.UV_VID_COUNT,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.DATE_KEY,
           S.ORDER_VID_COUNT,
           S.UV_VID_COUNT,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_VEDIO_ITEM_CVR_PROC;

  PROCEDURE KPI_ASMT_APP_DOWNLOAD_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL                  W_ETL_LOG%ROWTYPE;
    SP_NAME                S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER            S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS            NUMBER;
    UPDATE_ROWS            NUMBER;
    DELETE_ROWS            NUMBER;
    V_MONTH_FIRST_DATE_KEY NUMBER; /*���µĵ�һ��*/
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME                := 'HAPPIGO_KPI_PKG.KPI_ASMT_APP_DOWNLOAD_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME       := 'KPI_ASMT_APP_DOWNLOAD'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME        := SP_NAME;
    S_ETL.START_TIME       := SYSDATE;
    S_PARAMETER            := 0;
    V_MONTH_FIRST_DATE_KEY := TO_CHAR(TRUNC(TO_DATE(IN_DATE_KEY, 'YYYYMMDD'),
                                            'MM'),
                                      'YYYYMMDD');
  
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
  
    BEGIN
      /*���²�������,ͳ�Ƶ���1�ŵ����յ�������ƽ��ֵ*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_APP_DOWNLOAD T
      USING (SELECT SUBSTR(A.VISIT_DATE_KEY, 1, 6) MONTH_KEY,
                    ROUND(AVG(A.NEWVTCOUNT)) DOWNLOAD_COUNT,
                    SYSDATE W_INSERT_DT,
                    SYSDATE W_UPDATE_DT
               FROM FACT_DAILY_APP A
              WHERE A.VISIT_DATE_KEY BETWEEN V_MONTH_FIRST_DATE_KEY AND
                    IN_DATE_KEY
              GROUP BY SUBSTR(A.VISIT_DATE_KEY, 1, 6)) S
      ON (T.MONTH_KEY = S.MONTH_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.DOWNLOAD_COUNT = S.DOWNLOAD_COUNT,
               T.W_UPDATE_DT    = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MONTH_KEY, T.DOWNLOAD_COUNT, T.W_INSERT_DT, T.W_UPDATE_DT)
        VALUES
          (S.MONTH_KEY, S.DOWNLOAD_COUNT, S.W_INSERT_DT, S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_APP_DOWNLOAD_PROC;

  PROCEDURE KPI_ASMT_REG_ORDER_CVR_PROC(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
  
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_KPI_PKG.KPI_ASMT_REG_ORDER_CVR_PROC'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'KPI_ASMT_VEDIO_ITEM_CVR'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
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
  
    BEGIN
      /*���²�������,ͳ��ÿ�����ע���Ա������ת����*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_REG_ORDER_CVR T
      USING (SELECT A.DATE_KEY,
                    A.ORDER_MEMBER_COUNT,
                    B.REG_MEMBER_COUNT,
                    SYSDATE              W_INSERT_DT,
                    SYSDATE              W_UPDATE_DT
               FROM (SELECT A1.ADD_TIME DATE_KEY,
                            COUNT(DISTINCT A1.MEMBER_KEY) ORDER_MEMBER_COUNT
                       FROM FACTEC_ORDER A1
                      WHERE A1.ADD_TIME = IN_DATE_KEY
                        AND A1.ORDER_STATE > 10
                        AND EXISTS
                      (SELECT 1
                               FROM FACT_ECMEMBER A2
                              WHERE A2.MEMBER_TIME = IN_DATE_KEY
                                AND A1.MEMBER_KEY = A2.MEMBER_CRMBP)
                      GROUP BY A1.ADD_TIME) A,
                    (SELECT B1.MEMBER_TIME DATE_KEY,
                            COUNT(DISTINCT B1.MEMBER_CRMBP) REG_MEMBER_COUNT
                       FROM FACT_ECMEMBER B1
                      WHERE B1.MEMBER_TIME = IN_DATE_KEY
                      GROUP BY B1.MEMBER_TIME) B
              WHERE A.DATE_KEY = B.DATE_KEY) S
      ON (T.DATE_KEY = S.DATE_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.ORDER_MEMBER_COUNT = S.ORDER_MEMBER_COUNT,
               T.REG_MEMBER_COUNT   = S.REG_MEMBER_COUNT,
               T.W_UPDATE_DT        = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.DATE_KEY,
           T.ORDER_MEMBER_COUNT,
           T.REG_MEMBER_COUNT,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.DATE_KEY,
           S.ORDER_MEMBER_COUNT,
           S.REG_MEMBER_COUNT,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_REG_ORDER_CVR_PROC;

  PROCEDURE KPI_ASMT_REPURCHASE_MEMBER_P(IN_DATE_KEY IN NUMBER) IS
    S_ETL                      W_ETL_LOG%ROWTYPE;
    SP_NAME                    S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER                S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS                NUMBER;
    UPDATE_ROWS                NUMBER;
    DELETE_ROWS                NUMBER;
    V_LAST_MONTH_FIRST_DAY_KEY NUMBER; /*���µ�һ��*/
    V_LAST_MONTH_LAST_DAY_KEY  NUMBER; /*�������һ��*/
    V_CUR_MONTH_FIRST_DAY_KEY  NUMBER; /*���µ�һ��*/
  
    /*
    ����˵����
    ����ʱ�䣺yangjin  2018-02-24
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_KPI_PKG.KPI_ASMT_REPURCHASE_MEMBER_P'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'KPI_ASMT_REPURCHASE_MEMBER'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı���
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    /*���µ�һ��*/
    V_LAST_MONTH_FIRST_DAY_KEY := TO_CHAR(TRUNC(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                   'yyyy-mm-dd'),
                                                           -1),
                                                'month'),
                                          'yyyymmdd');
    /*�������һ��*/
    V_LAST_MONTH_LAST_DAY_KEY := TO_CHAR(TRUNC(LAST_DAY(ADD_MONTHS(TO_DATE(IN_DATE_KEY,
                                                                           'yyyy-mm-dd'),
                                                                   -1))),
                                         'yyyymmdd');
    /*���µ�һ��*/
    V_CUR_MONTH_FIRST_DAY_KEY := TO_CHAR(TRUNC(TO_DATE(IN_DATE_KEY,
                                                       'YYYYMMDD'),
                                               'MM'),
                                         'YYYYMMDD');
  
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
  
    BEGIN
      /*���²�������,ͳ��ÿ�µ��ϻ�Ա��������*/
      MERGE /*+APPEND*/
      INTO KPI_ASMT_REPURCHASE_MEMBER T
      USING (SELECT D.MONTH_KEY,
                    D.REPURCHASE_MEMBER_COUNT,
                    E.LAST_MONTH_MEMBER_COUNT,
                    SYSDATE                   W_INSERT_DT,
                    SYSDATE                   W_UPDATE_DT
               FROM (SELECT SUBSTR(A.ADD_TIME, 1, 6) MONTH_KEY,
                            COUNT(DISTINCT(A.MEMBER_KEY)) REPURCHASE_MEMBER_COUNT
                       FROM FACTEC_ORDER A
                      WHERE A.ADD_TIME BETWEEN V_CUR_MONTH_FIRST_DAY_KEY AND
                            IN_DATE_KEY
                        AND A.ORDER_STATE > 10
                        AND A.MEMBER_KEY IN
                            (SELECT DISTINCT (B.MEMBER_KEY)
                               FROM FACTEC_ORDER B
                              WHERE B.ADD_TIME BETWEEN
                                    V_LAST_MONTH_FIRST_DAY_KEY AND
                                    V_LAST_MONTH_LAST_DAY_KEY
                                AND B.ORDER_STATE > 10)
                      GROUP BY SUBSTR(A.ADD_TIME, 1, 6)) D,
                    (SELECT TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(C.ADD_TIME,
                                                              1,
                                                              6),
                                                       'YYYYMM'),
                                               1),
                                    'YYYYMM') MONTH_KEY,
                            COUNT(DISTINCT(C.MEMBER_KEY)) LAST_MONTH_MEMBER_COUNT
                       FROM FACTEC_ORDER C
                      WHERE C.ADD_TIME BETWEEN V_LAST_MONTH_FIRST_DAY_KEY AND
                            V_LAST_MONTH_LAST_DAY_KEY
                        AND C.ORDER_STATE > 10
                      GROUP BY TO_CHAR(ADD_MONTHS(TO_DATE(SUBSTR(C.ADD_TIME,
                                                                 1,
                                                                 6),
                                                          'YYYYMM'),
                                                  1),
                                       'YYYYMM')) E
              WHERE D.MONTH_KEY = E.MONTH_KEY) S
      ON (T.MONTH_KEY = S.MONTH_KEY)
      WHEN MATCHED THEN
        UPDATE
           SET T.REPURCHASE_MEMBER_COUNT = S.REPURCHASE_MEMBER_COUNT,
               T.LAST_MONTH_MEMBER_COUNT = S.LAST_MONTH_MEMBER_COUNT,
               T.W_UPDATE_DT             = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MONTH_KEY,
           T.REPURCHASE_MEMBER_COUNT,
           T.LAST_MONTH_MEMBER_COUNT,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.MONTH_KEY,
           S.REPURCHASE_MEMBER_COUNT,
           S.LAST_MONTH_MEMBER_COUNT,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || TO_CHAR(IN_DATE_KEY);
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
  END KPI_ASMT_REPURCHASE_MEMBER_P;

END HAPPIGO_KPI_PKG;
/