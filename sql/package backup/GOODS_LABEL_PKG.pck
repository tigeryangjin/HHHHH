CREATE OR REPLACE PACKAGE GOODS_LABEL_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-09-21 14:40:49
  -- PURPOSE : ��Ʒ��ǩPACKAGE

  PROCEDURE CREATE_GOODS_LABEL(IN_G_LABEL_NAME      IN VARCHAR2,
                               IN_G_LABEL_DESC      IN VARCHAR2,
                               IN_G_LABEL_TYPE_ID   IN NUMBER,
                               IN_IS_LEAF_NODE      IN NUMBER,
                               IN_G_LABEL_FATHER_ID IN NUMBER);
  /*
  ������:       CREATE_GOODS_LABEL
  Ŀ��:         �½���ǩ����GOODS_LABEL_HEAD
  ����:         YANGJIN
  ����ʱ�䣺    2017/09/21
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE SYNC_EC_TAGS;
  /*
  ������:       SYNC_EC_TAGS
  Ŀ��:         ͬ��happigo_ec����Ʒ��ǩ����goods_label_head
  ����:         yangjin
  ����ʱ�䣺    2018/07/10
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE SYNC_EC_GOODS_TAGS;
  /*
  ������:       SYNC_EC_GOODS_TAGS
  Ŀ��:         ͬ��happigo_ec����Ʒ��ǩ������goods_label_link
  ����:         yangjin
  ����ʱ�䣺    2018/07/10
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE DISTRIBUTION_TYPE;
  /*
  ������:       DISTRIBUTION_TYPE
  Ŀ��:         ���ͷ�ʽ(����(���ֹ�)��ֱ����(��Ӧ��))
  ����:         yangjin
  ����ʱ�䣺    2018/04/23
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE GOOD_PRICE_RANGE;
  /*
  ������:       GOOD_PRICE_RANGE
  Ŀ��:         0~50
                50~100
                100~200
                200~300
                300~400
                400~500
                500~600
                600~800
                800~1000
                1000~1500
                1500~2000
                2000~3000
                3000����
  
  ����:         yangjin
  ����ʱ�䣺    2018/04/23
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE GOODS_HOT_SEASON(IN_DATE_KEY IN NUMBER);
  /*
  ������:       GOODS_HOT_SEASON
  Ŀ��:         ��Ʒ��ǩ-��������
              ��2016�꿪ʼ���㣬ÿ����һ�꣬�ͼ���2016��ȥ��ĺϼơ�ԭ���ı�ǩȫ����������¼��㡣
              GOODS_HOT_SEASON_SPRING,��Ʒ��������-��,��Ȼ������������ϸ������ռȫ��60%����λ�ڣ�1~4�£�
              GOODS_HOT_SEASON_SUMMER,��Ʒ��������-��,��Ȼ������������ϸ������ռȫ��60%����λ�ڣ�4~7�£�
              GOODS_HOT_SEASON_AUTUMN,��Ʒ��������-��,��Ȼ������������ϸ������ռȫ��60%����λ�ڣ�7~10�£�
              GOODS_HOT_SEASON_WINTER,��Ʒ��������-��,��Ȼ������������ϸ������ռȫ��60%����λ�ڣ�10~1�£�
  ����:         yangjin
  ����ʱ�䣺    2018/05/24
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE GOODS_TRAFFIC_LEVEL(IN_DATE_KEY IN NUMBER);
  /*
  ������:       GOODS_TRAFFIC_LEVEL
  Ŀ��:         ��Ʒ��ǩ-�������
                ͳ�����30��
                HIGH_TRAFFIC-������-�¶�UV����1000
                MEDIUM_TRAFFIC-һ������-�¶�UV����101~999
                LOW_TRAFFIC-������-�¶�UV����100
  ����:         yangjin
  ����ʱ�䣺    2018/05/28
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE GOODS_CVR(IN_DATE_KEY IN NUMBER);
  /*
  ������:       GOODS_CVR
  Ŀ��:         ��Ʒ��ǩ-ת����
                ͳ�����30��
                HIGH_CVR-��ת����-�¶�ת���ʸ���2.5%
                MEDIUM_CVR-һ��ת����-�¶�ת���ʽ���1.0%~2.5%
                LOW_CVR-��ת����-�¶�ת���ʵ���1.0%
  ����:         yangjin
  ����ʱ�䣺    2018/05/28
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE GOODS_FIRST_ON_SELL_TIME(IN_DATE_KEY IN NUMBER);
  /*
  ������:       GOODS_FIRST_ON_SELL_TIME
  Ŀ��:         ��Ʒ��ǩ-��Ʒ��ǩ
                15_DAYS_TO_30DAYS-��Ʒ�״��ϼ�ʱ���ڣ�15������30�����£�-1073
                7_DAYS_TO_15_DAYS-��Ʒ�״��ϼ�ʱ���ڣ�7������15�����£�-1074
                WITHIN_7_DAYS-��Ʒ�״��ϼ�ʱ���ڣ�7�����£�-1075
  ����:         yangjin
  ����ʱ�䣺    2018/05/29
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE GOODS_MATXXL_PRICE_LEVEL(IN_DATE_KEY IN NUMBER);
  /*
  ������:       GOODS_MATXXL_PRICE_LEVEL
  Ŀ��:         ��Ʒ��ǩ-����ϸ��۸�����
  ����:         yangjin
  ����ʱ�䣺    2018/05/29
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE GOODS_EVALUATE_ASPECT;
  /*
  ������:       GOODS_EVALUATE_ASPECT
  Ŀ��:         ��fact_goods_evaluate���geval_sentiment_polarity_iaspe�ֶλ�ȡJSON��
                ���������fact_goods_evaluate_aspect��
  ����:         yangjin
  ����ʱ�䣺    2018/07/24
  ����޸��ˣ�
  ���������ڣ�
  */

  PROCEDURE GOODS_EVALUATION_LEVEL;
  /*
  ������:       GOODS_EVALUATION_LEVEL
  Ŀ��:         ��Ʒ��ǩ-�û��ڱ��ȼ�
                ����Ʒ����Ʒ���۴���10ʱ��ʼ����
                90%��������Ϊ����ʱ ��ʾ�ñ�ǩ�û������Ϊ��(HIGH)
                70~89%����Ϊ����ʱ ��ʾ�ñ�ǩ�û������Ϊ��(MEDIUM)
                70%��������Ϊ����ʱ ��ʾ�ñ�ǩ�û������Ϊ��(LOW)
  ����:         yangjin
  ����ʱ�䣺    2018/05/29
  ����޸��ˣ�
  ���������ڣ�
  */

END GOODS_LABEL_PKG;
/
CREATE OR REPLACE PACKAGE BODY GOODS_LABEL_PKG IS

  PROCEDURE CREATE_GOODS_LABEL(IN_G_LABEL_NAME      IN VARCHAR2,
                               IN_G_LABEL_DESC      IN VARCHAR2,
                               IN_G_LABEL_TYPE_ID   IN NUMBER,
                               IN_IS_LEAF_NODE      IN NUMBER,
                               IN_G_LABEL_FATHER_ID IN NUMBER) IS
    /*
    ����˵�����½���ǩ����GOODS_LABEL_HEAD
    ����ʱ�䣺YANGJIN  2017-09-21
    */
  BEGIN
    BEGIN
      INSERT INTO GOODS_LABEL_HEAD
        (G_LABEL_ID,
         G_LABEL_NAME,
         G_LABEL_DESC,
         G_LABEL_TYPE_ID,
         IS_LEAF_NODE,
         G_LABEL_FATHER_ID,
         CREATE_DATE,
         CREATE_USER_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATE_USER_ID,
         CURRENT_FLAG)
        SELECT GOODS_LABEL_HEAD_SEQ.NEXTVAL, /*G_LABEL_ID*/
               IN_G_LABEL_NAME, /*G_LABEL_NAME*/
               IN_G_LABEL_DESC, /*G_LABEL_DESC*/
               IN_G_LABEL_TYPE_ID, /*G_LABEL_TYPE_ID*/
               IN_IS_LEAF_NODE, /*�Ƿ�Ҷ�ڵ�*/
               IN_G_LABEL_FATHER_ID, /*G_LABEL_FATHER_ID*/
               SYSDATE, /*CREATE_DATE*/
               'yangjin', /*CREATE_USER_ID*/
               SYSDATE, /*LAST_UPDATE_DATE*/
               'yangjin', /*LAST_UPDATE_USER_ID*/
               1 /*CURRENT_FLAG*/
          FROM DUAL;
      COMMIT;
    END;
  END CREATE_GOODS_LABEL;

  PROCEDURE SYNC_EC_TAGS IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-04-23
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.SYNC_EC_TAGS'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'GOODS_LABEL_HEAD'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
      --1.insert goods_label_head
      INSERT INTO GOODS_LABEL_HEAD
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
        SELECT GOODS_LABEL_HEAD_SEQ.NEXTVAL G_LABEL_ID,
               A.TAG_ID G_LABEL_NAME,
               A.TAG_NAME G_LABEL_DESC,
               1 G_LABEL_TYPE_ID,
               NULL IS_LEAF_NODE,
               SYSDATE CREATE_DATE,
               'happigo_ec' CREATE_USER_ID,
               SYSDATE LAST_UPDATE_DATE,
               'happigo_ec' LAST_UPDATE_USER_ID,
               1 CURRENT_FLAG,
               NULL G_LABEL_FATHER_ID
          FROM (SELECT 'ec_' || A1.TAG_ID TAG_ID,
                       'ec_' || A1.TAG_NAME TAG_NAME,
                       'ec_' || A1.PARENT_ID PARENT_ID
                  FROM EC_TAGS A1) A
         WHERE NOT EXISTS (SELECT 1
                  FROM GOODS_LABEL_HEAD B
                 WHERE A.TAG_ID = B.G_LABEL_NAME);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      --2.update IS_LEAF_NODE=1
      UPDATE GOODS_LABEL_HEAD A
         SET A.IS_LEAF_NODE = 1
       WHERE A.CREATE_USER_ID = 'happigo_ec'
         AND EXISTS
       (SELECT 1
                FROM (SELECT NVL(C.LV4_TAG_ID,
                                 NVL(C.LV3_TAG_ID,
                                     NVL(C.LV2_TAG_ID, C.LV1_TAG_ID))) G_LABEL_NAME,
                             C.LV1_TAG_ID,
                             C.LV2_TAG_ID,
                             C.LV3_TAG_ID,
                             C.LV4_TAG_ID
                        FROM EC_GOODS_LABEL_HEAD_LEVEL_V C) B
               WHERE A.G_LABEL_NAME = B.G_LABEL_NAME);
      COMMIT;
      --2.1.update IS_LEAF_NODE=0
      UPDATE GOODS_LABEL_HEAD A
         SET A.IS_LEAF_NODE = 0
       WHERE A.CREATE_USER_ID = 'happigo_ec'
         AND A.IS_LEAF_NODE IS NULL;
      COMMIT;
    
      --3.update g_label_father_id
      UPDATE GOODS_LABEL_HEAD A
         SET A.G_LABEL_FATHER_ID =
             (SELECT C.G_LABEL_ID
                FROM (SELECT 'ec_' || B1.TAG_ID TAG_ID,
                             'ec_' || B1.PARENT_ID PARENT_ID
                        FROM EC_TAGS B1) B,
                     (SELECT C1.G_LABEL_ID, C1.G_LABEL_NAME
                        FROM GOODS_LABEL_HEAD C1) C
               WHERE A.G_LABEL_NAME = B.TAG_ID
                 AND B.PARENT_ID = C.G_LABEL_NAME)
       WHERE A.CREATE_USER_ID = 'happigo_ec'
         AND A.G_LABEL_FATHER_ID IS NULL;
      UPDATE_ROWS := SQL%ROWCOUNT;
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
  END SYNC_EC_TAGS;

  PROCEDURE SYNC_EC_GOODS_TAGS IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-04-23
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.SYNC_EC_GOODS_TAGS'; --��Ҫ�ֹ�������дPROCEDURE������
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
  
    BEGIN
      --1.insert goods_label_link
      INSERT INTO GOODS_LABEL_LINK
        (ITEM_CODE,
         G_LABEL_ID,
         G_LABEL_TYPE_ID,
         CREATE_DATE,
         CREATE_USER_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATE_USER_ID,
         ROW_ID)
        SELECT C.ITEM_CODE,
               C.G_LABEL_ID,
               C.G_LABEL_TYPE_ID,
               SYSDATE CREATE_DATE,
               'happigo_ec' CREATE_USER_ID,
               SYSDATE LAST_UPDATE_DATE,
               'happigo_ec' LAST_UPDATE_USER_ID,
               GOODS_LABEL_LINK_SEQ.NEXTVAL
          FROM (SELECT B.G_LABEL_ID,
                       'ec_' || A.TAG_ID G_LABEL_NAME,
                       A.ITEM_CODE,
                       B.G_LABEL_TYPE_ID
                  FROM EC_GOODS_TAGS A, GOODS_LABEL_HEAD B
                 WHERE 'ec_' || A.TAG_ID = B.G_LABEL_NAME
                   AND A.STATE = 1
                   AND B.CREATE_USER_ID = 'happigo_ec') C
         WHERE NOT EXISTS (SELECT 1
                  FROM GOODS_LABEL_LINK D
                 WHERE C.G_LABEL_ID = D.G_LABEL_ID
                   AND C.ITEM_CODE = D.ITEM_CODE);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      --2.delete goods_label_link             
      DELETE GOODS_LABEL_LINK A
       WHERE EXISTS (SELECT 1
                FROM (SELECT D.G_LABEL_ID,
                             'ec_' || C.TAG_ID G_LABEL_NAME,
                             C.ITEM_CODE,
                             D.G_LABEL_TYPE_ID
                        FROM EC_GOODS_TAGS C, GOODS_LABEL_HEAD D
                       WHERE 'ec_' || C.TAG_ID = D.G_LABEL_NAME
                         AND C.STATE = 0
                         AND D.CREATE_USER_ID = 'happigo_ec') B
               WHERE A.ITEM_CODE = B.ITEM_CODE
                 AND A.G_LABEL_ID = B.G_LABEL_ID);
      UPDATE_ROWS := SQL%ROWCOUNT;
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
  END SYNC_EC_GOODS_TAGS;

  PROCEDURE DISTRIBUTION_TYPE IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-04-23
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.DISTRIBUTION_TYPE'; --��Ҫ�ֹ�������дPROCEDURE������
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
  
    BEGIN
      /*���ϱ�ǩ*/
      /*
      DISTRIBUTION_TYPE_KLG:���ͷ�ʽ_����(���ֹ�)
      DISTRIBUTION_TYPE_SUPPLIER:���ͷ�ʽ_ֱ����(��Ӧ��)
      */
      MERGE /*+APPEND*/
      INTO (SELECT A.ROW_ID,
                   A.ITEM_CODE,
                   A.G_LABEL_ID,
                   A.G_LABEL_TYPE_ID,
                   A.CREATE_DATE,
                   A.CREATE_USER_ID,
                   A.LAST_UPDATE_DATE,
                   A.LAST_UPDATE_USER_ID
              FROM GOODS_LABEL_LINK A
             WHERE A.G_LABEL_ID BETWEEN 22 AND 23) T
      USING (SELECT B.ITEM_CODE,
                    C.G_LABEL_ID,
                    C.G_LABEL_TYPE_ID,
                    SYSDATE CREATE_DATE,
                    'yangjin' CREATE_USER_ID,
                    SYSDATE LAST_UPDATE_DATE,
                    'yangjin' LAST_UPDATE_USER_ID
               FROM (SELECT A.ITEM_CODE,
                            CASE
                              WHEN A.IS_SHIPPING_SELF = 1 THEN
                               'DISTRIBUTION_TYPE_KLG'
                              WHEN A.IS_SHIPPING_SELF = 0 THEN
                               'DISTRIBUTION_TYPE_SUPPLIER'
                            END DISTRIBUTION_TYPE
                       FROM DIM_EC_GOOD A
                      WHERE A.IS_SHIPPING_SELF IS NOT NULL) B,
                    GOODS_LABEL_HEAD C
              WHERE B.DISTRIBUTION_TYPE = C.G_LABEL_NAME) S
      ON (T.ITEM_CODE = S.ITEM_CODE)
      WHEN MATCHED THEN
        UPDATE
           SET T.G_LABEL_ID          = S.G_LABEL_ID,
               T.G_LABEL_TYPE_ID     = S.G_LABEL_TYPE_ID,
               T.LAST_UPDATE_DATE    = SYSDATE,
               T.LAST_UPDATE_USER_ID = 'yangjin'
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.ITEM_CODE,
           T.G_LABEL_ID,
           T.G_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (GOODS_LABEL_LINK_SEQ.NEXTVAL,
           S.ITEM_CODE,
           S.G_LABEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*ɾ����ǩ/
      /*
      DISTRIBUTION_TYPE_KLG:���ͷ�ʽ_����(���ֹ�)
      DISTRIBUTION_TYPE_SUPPLIER:���ͷ�ʽ_ֱ����(��Ӧ��)
      */
      DELETE GOODS_LABEL_LINK A
       WHERE A.G_LABEL_ID BETWEEN 22 AND 23
         AND NOT EXISTS (SELECT 1
                FROM (SELECT A.ITEM_CODE,
                             CASE
                               WHEN A.IS_SHIPPING_SELF = 1 THEN
                                22
                               WHEN A.IS_SHIPPING_SELF = 0 THEN
                                23
                             END G_LABEL_ID
                        FROM DIM_EC_GOOD A
                       WHERE A.IS_SHIPPING_SELF IS NOT NULL) B
               WHERE A.ITEM_CODE = B.ITEM_CODE
                 AND A.G_LABEL_ID = B.G_LABEL_ID);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
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
  END DISTRIBUTION_TYPE;

  PROCEDURE GOOD_PRICE_RANGE IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-04-23
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.GOOD_PRICE_RANGE'; --��Ҫ�ֹ�������дPROCEDURE������
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
  
    BEGIN
      /*���ϱ�ǩ*/
      MERGE /*+APPEND*/
      INTO (SELECT A.ROW_ID,
                   A.ITEM_CODE,
                   A.G_LABEL_ID,
                   A.G_LABEL_TYPE_ID,
                   A.CREATE_DATE,
                   A.CREATE_USER_ID,
                   A.LAST_UPDATE_DATE,
                   A.LAST_UPDATE_USER_ID
              FROM GOODS_LABEL_LINK A
             WHERE A.G_LABEL_ID IN (25,
                                    26,
                                    27,
                                    28,
                                    29,
                                    999,
                                    1000,
                                    1001,
                                    1002,
                                    1003,
                                    1004,
                                    1005,
                                    1006)) T
      USING (SELECT B.ITEM_CODE,
                    C.G_LABEL_ID,
                    C.G_LABEL_TYPE_ID,
                    SYSDATE CREATE_DATE,
                    'yangjin' CREATE_USER_ID,
                    SYSDATE LAST_UPDATE_DATE,
                    'yangjin' LAST_UPDATE_USER_ID
               FROM (SELECT A.ITEM_CODE,
                            A.GOODS_PRICE,
                            CASE
                              WHEN A.GOODS_PRICE >= 0 AND A.GOODS_PRICE < 50 THEN
                               'GOODS_PRICE_RANGE_0_50'
                              WHEN A.GOODS_PRICE >= 50 AND A.GOODS_PRICE < 100 THEN
                               'GOODS_PRICE_RANGE_50_100'
                              WHEN A.GOODS_PRICE >= 100 AND
                                   A.GOODS_PRICE < 200 THEN
                               'GOODS_PRICE_RANGE_100_200'
                              WHEN A.GOODS_PRICE >= 200 AND
                                   A.GOODS_PRICE < 300 THEN
                               'GOODS_PRICE_RANGE_200_300'
                              WHEN A.GOODS_PRICE >= 300 AND
                                   A.GOODS_PRICE < 400 THEN
                               'GOODS_PRICE_RANGE_300_400'
                              WHEN A.GOODS_PRICE >= 400 AND
                                   A.GOODS_PRICE < 500 THEN
                               'GOODS_PRICE_RANGE_400_500'
                              WHEN A.GOODS_PRICE >= 500 AND
                                   A.GOODS_PRICE < 600 THEN
                               'GOODS_PRICE_RANGE_500_600'
                              WHEN A.GOODS_PRICE >= 600 AND
                                   A.GOODS_PRICE < 800 THEN
                               'GOODS_PRICE_RANGE_600_800'
                              WHEN A.GOODS_PRICE >= 800 AND
                                   A.GOODS_PRICE < 1000 THEN
                               'GOODS_PRICE_RANGE_800_1000'
                              WHEN A.GOODS_PRICE >= 1000 AND
                                   A.GOODS_PRICE < 1500 THEN
                               'GOODS_PRICE_RANGE_1000_1500'
                              WHEN A.GOODS_PRICE >= 1500 AND
                                   A.GOODS_PRICE < 2000 THEN
                               'GOODS_PRICE_RANGE_1500_2000'
                              WHEN A.GOODS_PRICE >= 2000 AND
                                   A.GOODS_PRICE < 3000 THEN
                               'GOODS_PRICE_RANGE_2000_3000'
                              WHEN A.GOODS_PRICE >= 3000 THEN
                               'GOODS_PRICE_RANGE_MORE_THAN_3000'
                            END GOODS_PRICE_RANGE
                       FROM DIM_EC_GOOD A) B,
                    GOODS_LABEL_HEAD C
              WHERE B.GOODS_PRICE_RANGE = C.G_LABEL_NAME) S
      ON (T.ITEM_CODE = S.ITEM_CODE)
      WHEN MATCHED THEN
        UPDATE
           SET T.G_LABEL_ID          = S.G_LABEL_ID,
               T.G_LABEL_TYPE_ID     = S.G_LABEL_TYPE_ID,
               T.LAST_UPDATE_DATE    = SYSDATE,
               T.LAST_UPDATE_USER_ID = 'yangjin'
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.ITEM_CODE,
           T.G_LABEL_ID,
           T.G_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (GOODS_LABEL_LINK_SEQ.NEXTVAL,
           S.ITEM_CODE,
           S.G_LABEL_ID,
           1,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*ɾ����ǩ*/
      DELETE GOODS_LABEL_LINK A
       WHERE A.G_LABEL_ID IN
             (25, 26, 27, 28, 29, 1000, 1001, 1002, 1003, 1004, 1005, 1006)
         AND NOT EXISTS
       (SELECT 1
                FROM (SELECT B.ITEM_CODE, C.G_LABEL_ID
                        FROM (SELECT A.ITEM_CODE,
                                     A.GOODS_PRICE,
                                     CASE
                                       WHEN A.GOODS_PRICE >= 0 AND
                                            A.GOODS_PRICE < 50 THEN
                                        'GOODS_PRICE_RANGE_0_50'
                                       WHEN A.GOODS_PRICE >= 50 AND
                                            A.GOODS_PRICE < 100 THEN
                                        'GOODS_PRICE_RANGE_50_100'
                                       WHEN A.GOODS_PRICE >= 100 AND
                                            A.GOODS_PRICE < 200 THEN
                                        'GOODS_PRICE_RANGE_100_200'
                                       WHEN A.GOODS_PRICE >= 200 AND
                                            A.GOODS_PRICE < 300 THEN
                                        'GOODS_PRICE_RANGE_200_300'
                                       WHEN A.GOODS_PRICE >= 300 AND
                                            A.GOODS_PRICE < 400 THEN
                                        'GOODS_PRICE_RANGE_300_400'
                                       WHEN A.GOODS_PRICE >= 400 AND
                                            A.GOODS_PRICE < 500 THEN
                                        'GOODS_PRICE_RANGE_400_500'
                                       WHEN A.GOODS_PRICE >= 500 AND
                                            A.GOODS_PRICE < 600 THEN
                                        'GOODS_PRICE_RANGE_500_600'
                                       WHEN A.GOODS_PRICE >= 600 AND
                                            A.GOODS_PRICE < 800 THEN
                                        'GOODS_PRICE_RANGE_600_800'
                                       WHEN A.GOODS_PRICE >= 800 AND
                                            A.GOODS_PRICE < 1000 THEN
                                        'GOODS_PRICE_RANGE_800_1000'
                                       WHEN A.GOODS_PRICE >= 1000 AND
                                            A.GOODS_PRICE < 1500 THEN
                                        'GOODS_PRICE_RANGE_1000_1500'
                                       WHEN A.GOODS_PRICE >= 1500 AND
                                            A.GOODS_PRICE < 2000 THEN
                                        'GOODS_PRICE_RANGE_1500_2000'
                                       WHEN A.GOODS_PRICE >= 2000 AND
                                            A.GOODS_PRICE < 3000 THEN
                                        'GOODS_PRICE_RANGE_2000_3000'
                                       WHEN A.GOODS_PRICE >= 3000 THEN
                                        'GOODS_PRICE_RANGE_MORE_THAN_3000'
                                     END GOODS_PRICE_RANGE
                                FROM DIM_EC_GOOD A) B,
                             GOODS_LABEL_HEAD C
                       WHERE B.GOODS_PRICE_RANGE = C.G_LABEL_NAME) B
               WHERE A.ITEM_CODE = B.ITEM_CODE
                 AND A.G_LABEL_ID = B.G_LABEL_ID);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
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
  END GOOD_PRICE_RANGE;

  PROCEDURE GOODS_HOT_SEASON(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    IN_YEAR_KEY NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-04-23
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.GOODS_HOT_SEASON'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'GOODS_LABEL_LINK'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    /*��һ��key*/
    IN_YEAR_KEY := TO_CHAR(TRUNC(TO_DATE(IN_DATE_KEY, 'YYYYMMDD'), 'YYYY') - 1,
                           'YYYY');
  
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
      /*�м��*/
      DELETE GOODS_LABEL_1041_STAGE A WHERE A.YEAR_KEY = IN_YEAR_KEY;
      COMMIT;
    
      INSERT INTO GOODS_LABEL_1041_STAGE
        (YEAR_KEY, MONTH_KEY, MATL_GROUP, QTY, W_INSERT_DT, W_UPDATE_DT)
        SELECT C.YEAR_KEY,
               C.MONTH_KEY,
               E.MATL_GROUP,
               SUM(C.QTY) QTY,
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM (SELECT TO_CHAR(A.ADD_TIME, 'YYYY') YEAR_KEY,
                       TO_CHAR(A.ADD_TIME, 'MM') MONTH_KEY,
                       B.GOODS_COMMONID,
                       SUM(B.GOODS_NUM) QTY
                  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
                 WHERE A.ORDER_ID = B.ORDER_ID
                   AND A.ORDER_STATE >= 20
                   AND TO_CHAR(A.ADD_TIME, 'YYYY') = IN_YEAR_KEY
                 GROUP BY TO_CHAR(A.ADD_TIME, 'YYYY'),
                          TO_CHAR(A.ADD_TIME, 'MM'),
                          B.GOODS_COMMONID) C,
               (SELECT D.ITEM_CODE, D.GOODS_COMMONID, D.MATL_GROUP
                  FROM DIM_GOOD D
                 WHERE D.CURRENT_FLG = 'Y'
                   AND D.GOODS_COMMONID <> 0) E
         WHERE C.GOODS_COMMONID = E.GOODS_COMMONID
         GROUP BY C.YEAR_KEY, C.MONTH_KEY, E.MATL_GROUP
         ORDER BY C.YEAR_KEY, C.MONTH_KEY, E.MATL_GROUP;
      COMMIT;
    
      /*�м��A*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GOODS_LABEL_1041_STAGE_A';
    
      INSERT INTO GOODS_LABEL_1041_STAGE_A
        (MATL_GROUP, COL1, COL2, COL3, COL4, W_INSERT_DT, W_UPDATE_DT)
        SELECT C.MATL_GROUP,
               CASE
                 WHEN C.SPRING_QTY >= C.TOTAL_QTY * 0.6 THEN
                  'GOODS_HOT_SEASON_SPRING'
               END COL1,
               CASE
                 WHEN C.SUMMER_QTY >= C.TOTAL_QTY * 0.6 THEN
                  'GOODS_HOT_SEASON_SUMMER'
               END COL2,
               CASE
                 WHEN C.AUTUMN_QTY >= C.TOTAL_QTY * 0.6 THEN
                  'GOODS_HOT_SEASON_AUTUMN'
               END COL3,
               CASE
                 WHEN C.WINTER_QTY >= C.TOTAL_QTY * 0.6 THEN
                  'GOODS_HOT_SEASON_WINTER'
               END COL4,
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM (SELECT B.MATL_GROUP,
                       SUM(SPRING_QTY) SPRING_QTY,
                       SUM(SUMMER_QTY) SUMMER_QTY,
                       SUM(AUTUMN_QTY) AUTUMN_QTY,
                       SUM(WINTER_QTY) WINTER_QTY,
                       SUM(TOTAL_QTY) TOTAL_QTY
                  FROM (SELECT A.MATL_GROUP,
                               CASE
                                 WHEN A.MONTH_KEY IN ('01', '02', '03', '04') THEN
                                  A.QTY
                                 ELSE
                                  0
                               END SPRING_QTY,
                               CASE
                                 WHEN A.MONTH_KEY IN ('04', '05', '06', '07') THEN
                                  A.QTY
                                 ELSE
                                  0
                               END SUMMER_QTY,
                               CASE
                                 WHEN A.MONTH_KEY IN ('07', '08', '09', '10') THEN
                                  A.QTY
                                 ELSE
                                  0
                               END AUTUMN_QTY,
                               CASE
                                 WHEN A.MONTH_KEY IN ('10', '11', '12', '01') THEN
                                  A.QTY
                                 ELSE
                                  0
                               END WINTER_QTY,
                               A.QTY TOTAL_QTY
                          FROM GOODS_LABEL_1041_STAGE A) B
                 GROUP BY B.MATL_GROUP) C
         ORDER BY C.MATL_GROUP;
    
      /*������Ʒ��ǩ��*/
      DELETE GOODS_LABEL_LINK A
       WHERE A.G_LABEL_ID IN (1042, 1043, 1044, 1045);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      INSERT INTO GOODS_LABEL_LINK
        (ITEM_CODE,
         G_LABEL_ID,
         G_LABEL_TYPE_ID,
         CREATE_DATE,
         CREATE_USER_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATE_USER_ID,
         ROW_ID)
        SELECT G.ITEM_CODE,
               H.G_LABEL_ID,
               H.G_LABEL_TYPE_ID,
               SYSDATE CREATE_DATE,
               'yangjin' CREATE_USER_ID,
               SYSDATE LAST_UPDATE_DATE,
               'yangjin' LAST_UPDATE_USER_ID,
               GOODS_LABEL_LINK_SEQ.NEXTVAL
          FROM (SELECT F.ITEM_CODE, E.COL1
                  FROM (SELECT A.MATL_GROUP, A.COL1
                          FROM GOODS_LABEL_1041_STAGE_A A
                         WHERE A.COL1 IS NOT NULL
                        UNION ALL
                        SELECT B.MATL_GROUP, B.COL2
                          FROM GOODS_LABEL_1041_STAGE_A B
                         WHERE B.COL2 IS NOT NULL
                        UNION ALL
                        SELECT C.MATL_GROUP, C.COL3
                          FROM GOODS_LABEL_1041_STAGE_A C
                         WHERE C.COL3 IS NOT NULL
                        UNION ALL
                        SELECT D.MATL_GROUP, D.COL4
                          FROM GOODS_LABEL_1041_STAGE_A D
                         WHERE D.COL4 IS NOT NULL) E,
                       DIM_GOOD F
                 WHERE E.MATL_GROUP = F.MATL_GROUP
                   AND F.CURRENT_FLG = 'Y') G,
               GOODS_LABEL_HEAD H
         WHERE G.COL1 = H.G_LABEL_NAME;
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || IN_DATE_KEY;
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
  END GOODS_HOT_SEASON;

  PROCEDURE GOODS_TRAFFIC_LEVEL(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-05-28
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.GOODS_TRAFFIC_LEVEL'; --��Ҫ�ֹ�������дPROCEDURE������
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
  
    BEGIN
      /*�м��*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GOODS_LABEL_1050_STAGE';
    
      INSERT INTO GOODS_LABEL_1050_STAGE
        (ITEM_CODE, G_LABEL_ID, G_LABEL_TYPE_ID, W_INSERT_DT, W_UPDATE_DT)
        SELECT C.ITEM_CODE,
               D.G_LABEL_ID,
               D.G_LABEL_TYPE_ID,
               SYSDATE           W_INSERT_DT,
               SYSDATE           W_UPDATE_DT
          FROM (SELECT B.ITEM_CODE,
                       B.UV,
                       CASE
                         WHEN B.UV BETWEEN 0 AND 100 THEN
                          'LOW_TRAFFIC'
                         WHEN B.UV BETWEEN 101 AND 999 THEN
                          'MEDIUM_TRAFFIC'
                         WHEN B.UV >= 1000 THEN
                          'HIGH_TRAFFIC'
                       END TRAFFIC_LEVEL
                  FROM (SELECT E.ITEM_CODE ITEM_CODE,
                               COUNT(DISTINCT A.VID) UV
                          FROM FACT_PAGE_VIEW A, DIM_EC_GOOD E
                         WHERE A.PAGE_VALUE = E.GOODS_COMMONID
                           AND A.VISIT_DATE_KEY BETWEEN
                               TO_CHAR(TO_DATE(IN_DATE_KEY, 'YYYYMMDD') - 30,
                                       'YYYYMMDD') AND IN_DATE_KEY /*���һ����*/
                           AND UPPER(A.PAGE_NAME) = 'GOOD'
                              /*��Ʒ���볤�ȣ�6*/
                           AND LENGTH(A.PAGE_VALUE) = 6
                              /*ȫ����*/
                           AND A.PAGE_VALUE =
                               TRANSLATE(A.PAGE_VALUE,
                                         '0' || TRANSLATE(A.PAGE_VALUE,
                                                          '#0123456789',
                                                          '#'),
                                         '0')
                         GROUP BY E.ITEM_CODE) B) C,
               GOODS_LABEL_HEAD D
         WHERE C.TRAFFIC_LEVEL = D.G_LABEL_NAME;
      COMMIT;
    
      /*Merge��Ʒ��ǩ��*/
      MERGE /*+APPEND*/
      INTO (SELECT A.ROW_ID,
                   A.ITEM_CODE,
                   A.G_LABEL_ID,
                   A.G_LABEL_TYPE_ID,
                   A.CREATE_DATE,
                   A.CREATE_USER_ID,
                   A.LAST_UPDATE_DATE,
                   A.LAST_UPDATE_USER_ID
              FROM GOODS_LABEL_LINK A
             WHERE A.G_LABEL_ID IN (1051, 1052, 1053)) T
      USING (SELECT ITEM_CODE, G_LABEL_ID, G_LABEL_TYPE_ID
               FROM GOODS_LABEL_1050_STAGE) S
      ON (T.ITEM_CODE = S.ITEM_CODE)
      WHEN MATCHED THEN
        UPDATE
           SET T.G_LABEL_ID          = S.G_LABEL_ID,
               T.G_LABEL_TYPE_ID     = S.G_LABEL_TYPE_ID,
               T.LAST_UPDATE_DATE    = SYSDATE,
               T.LAST_UPDATE_USER_ID = 'yangjin'
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.ITEM_CODE,
           T.G_LABEL_ID,
           T.G_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (GOODS_LABEL_LINK_SEQ.NEXTVAL,
           S.ITEM_CODE,
           S.G_LABEL_ID,
           S.G_LABEL_TYPE_ID,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*ɾ����Ʒ��ǩ,�����Ʒû��������ɾ����ǩ*/
      DELETE GOODS_LABEL_LINK A
       WHERE A.G_LABEL_ID IN (1051, 1052, 1053)
         AND NOT EXISTS (SELECT 1
                FROM GOODS_LABEL_1050_STAGE B
               WHERE A.ITEM_CODE = B.ITEM_CODE);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || IN_DATE_KEY;
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
  END GOODS_TRAFFIC_LEVEL;

  PROCEDURE GOODS_CVR(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-05-28
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.GOODS_CVR'; --��Ҫ�ֹ�������дPROCEDURE������
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
  
    BEGIN
      /*�м��*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GOODS_LABEL_1059_STAGE';
    
      INSERT INTO GOODS_LABEL_1059_STAGE
        (ITEM_CODE, CVR, CVR_LEVEL, W_INSERT_DT, W_UPDATE_DT)
        SELECT H.ITEM_CODE,
               G.CVR,
               CASE
                 WHEN G.CVR BETWEEN 0 AND 0.01 THEN
                  'GOODS_LOW_CVR'
                 WHEN G.CVR BETWEEN 0.01 AND 0.025 THEN
                  'GOODS_MEDIUM_CVR'
                 WHEN G.CVR > 0.025 THEN
                  'GOODS_HIGH_CVR'
               END CVR_LEVEL,
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM (SELECT E.GOODS_COMMONID,
                       E.UV,
                       NVL(F.ORDER_MEMBER_CNT, 0),
                       ROUND(NVL(F.ORDER_MEMBER_CNT, 0) / E.UV, 2) CVR
                  FROM (SELECT B.GOODS_COMMONID, B.UV
                          FROM (SELECT A.PAGE_VALUE GOODS_COMMONID,
                                       COUNT(DISTINCT A.VID) UV
                                  FROM FACT_PAGE_VIEW A
                                 WHERE A.VISIT_DATE_KEY BETWEEN
                                       TO_CHAR(TO_DATE(IN_DATE_KEY, 'YYYYMMDD') - 30,
                                               'YYYYMMDD') AND IN_DATE_KEY
                                   AND UPPER(A.PAGE_NAME) = 'GOOD'
                                   AND A.PAGE_VALUE =
                                       TRANSLATE(A.PAGE_VALUE,
                                                 '0' || TRANSLATE(A.PAGE_VALUE,
                                                                  '#0123456789',
                                                                  '#'),
                                                 '0')
                                 GROUP BY A.PAGE_VALUE) B) E,
                       (SELECT D.GOODS_COMMONID,
                               COUNT(DISTINCT C.CUST_NO) ORDER_MEMBER_CNT
                          FROM FACT_EC_ORDER_2 C, FACT_EC_ORDER_GOODS D
                         WHERE C.ORDER_ID = D.ORDER_ID
                           AND C.ORDER_STATE >= 20
                           AND C.ADD_TIME BETWEEN
                               TO_DATE(IN_DATE_KEY, 'YYYYMMDD') - 30 AND
                               TO_DATE(IN_DATE_KEY, 'YYYYMMDD')
                         GROUP BY D.GOODS_COMMONID) F
                 WHERE E.GOODS_COMMONID = F.GOODS_COMMONID(+)) G,
               DIM_EC_GOOD H
         WHERE G.GOODS_COMMONID = H.GOODS_COMMONID
           AND H.STORE_ID = 1;
      COMMIT;
    
      /*Merge��Ʒ��ǩ��*/
      MERGE /*+APPEND*/
      INTO (SELECT A.ROW_ID,
                   A.ITEM_CODE,
                   A.G_LABEL_ID,
                   A.G_LABEL_TYPE_ID,
                   A.CREATE_DATE,
                   A.CREATE_USER_ID,
                   A.LAST_UPDATE_DATE,
                   A.LAST_UPDATE_USER_ID
              FROM GOODS_LABEL_LINK A
             WHERE A.G_LABEL_ID IN (1060, 1061, 1062)) T
      USING (SELECT B.ITEM_CODE, C.G_LABEL_ID, C.G_LABEL_TYPE_ID
               FROM GOODS_LABEL_1059_STAGE B, GOODS_LABEL_HEAD C
              WHERE B.CVR_LEVEL = C.G_LABEL_NAME
                AND C.G_LABEL_ID IN (1060, 1061, 1062)) S
      ON (T.ITEM_CODE = S.ITEM_CODE)
      WHEN MATCHED THEN
        UPDATE
           SET T.G_LABEL_ID          = S.G_LABEL_ID,
               T.G_LABEL_TYPE_ID     = S.G_LABEL_TYPE_ID,
               T.LAST_UPDATE_DATE    = SYSDATE,
               T.LAST_UPDATE_USER_ID = 'yangjin'
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.ITEM_CODE,
           T.G_LABEL_ID,
           T.G_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (GOODS_LABEL_LINK_SEQ.NEXTVAL,
           S.ITEM_CODE,
           S.G_LABEL_ID,
           S.G_LABEL_TYPE_ID,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*ɾ����Ʒ��ǩ,�����Ʒû��������ɾ����ǩ*/
      DELETE GOODS_LABEL_LINK A
       WHERE A.G_LABEL_ID IN (1060, 1061, 1062)
         AND NOT EXISTS (SELECT 1
                FROM GOODS_LABEL_1059_STAGE B
               WHERE A.ITEM_CODE = B.ITEM_CODE);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || IN_DATE_KEY;
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
  END GOODS_CVR;

  PROCEDURE GOODS_FIRST_ON_SELL_TIME(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-05-28
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.GOODS_FIRST_ON_SELL_TIME'; --��Ҫ�ֹ�������дPROCEDURE������
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
  
    BEGIN
      /*�м��*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GOODS_LABEL_1072_STAGE';
    
      INSERT INTO GOODS_LABEL_1072_STAGE
        (ITEM_CODE, FIRSTONSELLTIME, FIRST_LEVEL, W_INSERT_DT, W_UPDATE_DT)
        SELECT A.ITEM_CODE,
               TRUNC(A.FIRSTONSELLTIME) FIRSTONSELLTIME,
               CASE
                 WHEN TRUNC(A.FIRSTONSELLTIME) >
                      TO_DATE(IN_DATE_KEY, 'YYYYMMDD') - 7 THEN
                  'WITHIN_7_DAYS'
                 WHEN TRUNC(A.FIRSTONSELLTIME) <=
                      TO_DATE(IN_DATE_KEY, 'YYYYMMDD') - 7 AND
                      TRUNC(A.FIRSTONSELLTIME) >=
                      TO_DATE(IN_DATE_KEY, 'YYYYMMDD') - 15 THEN
                  '7_DAYS_TO_15_DAYS'
                 WHEN TRUNC(A.FIRSTONSELLTIME) <
                      TO_DATE(IN_DATE_KEY, 'YYYYMMDD') - 15 AND
                      TRUNC(A.FIRSTONSELLTIME) >=
                      TO_DATE(IN_DATE_KEY, 'YYYYMMDD') - 30 THEN
                  '15_DAYS_TO_30DAYS'
               END FIRST_LEVEL,
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM FACT_EC_GOODS_COMMON A
         WHERE TRUNC(A.FIRSTONSELLTIME) >=
               TO_DATE(IN_DATE_KEY, 'YYYYMMDD') - 30;
      COMMIT;
    
      /*Merge��Ʒ��ǩ��*/
      MERGE /*+APPEND*/
      INTO (SELECT A.ROW_ID,
                   A.ITEM_CODE,
                   A.G_LABEL_ID,
                   A.G_LABEL_TYPE_ID,
                   A.CREATE_DATE,
                   A.CREATE_USER_ID,
                   A.LAST_UPDATE_DATE,
                   A.LAST_UPDATE_USER_ID
              FROM GOODS_LABEL_LINK A
             WHERE A.G_LABEL_ID IN (1073, 1074, 1075)) T
      USING (SELECT B.ITEM_CODE, C.G_LABEL_ID, C.G_LABEL_TYPE_ID
               FROM GOODS_LABEL_1072_STAGE B, GOODS_LABEL_HEAD C
              WHERE B.FIRST_LEVEL = C.G_LABEL_NAME
                AND C.G_LABEL_ID IN (1073, 1074, 1075)) S
      ON (T.ITEM_CODE = S.ITEM_CODE)
      WHEN MATCHED THEN
        UPDATE
           SET T.G_LABEL_ID          = S.G_LABEL_ID,
               T.G_LABEL_TYPE_ID     = S.G_LABEL_TYPE_ID,
               T.LAST_UPDATE_DATE    = SYSDATE,
               T.LAST_UPDATE_USER_ID = 'yangjin'
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.ITEM_CODE,
           T.G_LABEL_ID,
           T.G_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (GOODS_LABEL_LINK_SEQ.NEXTVAL,
           S.ITEM_CODE,
           S.G_LABEL_ID,
           S.G_LABEL_TYPE_ID,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*ɾ����Ʒ��ǩ,�����Ʒû��������ɾ����ǩ*/
      DELETE GOODS_LABEL_LINK A
       WHERE A.G_LABEL_ID IN (1073, 1074, 1075)
         AND NOT EXISTS (SELECT 1
                FROM GOODS_LABEL_1059_STAGE B
               WHERE A.ITEM_CODE = B.ITEM_CODE);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || IN_DATE_KEY;
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
  END GOODS_FIRST_ON_SELL_TIME;

  PROCEDURE GOODS_MATXXL_PRICE_LEVEL(IN_DATE_KEY IN NUMBER) IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-05-28
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.GOODS_MATXXL_PRICE_LEVEL'; --��Ҫ�ֹ�������дPROCEDURE������
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
  
    BEGIN
    
      /*Merge��Ʒ��ǩ��*/
      MERGE /*+APPEND*/
      INTO (SELECT A.ROW_ID,
                   A.ITEM_CODE,
                   A.G_LABEL_ID,
                   A.G_LABEL_TYPE_ID,
                   A.CREATE_DATE,
                   A.CREATE_USER_ID,
                   A.LAST_UPDATE_DATE,
                   A.LAST_UPDATE_USER_ID
              FROM GOODS_LABEL_LINK A
             WHERE A.G_LABEL_ID IN (1077, 1078, 1079)) T
      USING (SELECT C.ITEM_CODE, D.G_LABEL_ID, D.G_LABEL_TYPE_ID
               FROM (SELECT B.ITEM_CODE,
                            B.GOOD_PRICE_LEVEL || '_MATXXL_PRICE_LEVEL' GOODS_MATXXL_PRICE_LEVEL
                       FROM DIM_GOOD B
                      WHERE B.CURRENT_FLG = 'Y'
                        AND B.GOOD_PRICE_LEVEL IS NOT NULL) C,
                    GOODS_LABEL_HEAD D
              WHERE C.GOODS_MATXXL_PRICE_LEVEL = D.G_LABEL_NAME
                AND D.G_LABEL_ID IN (1077, 1078, 1079)) S
      ON (T.ITEM_CODE = S.ITEM_CODE)
      WHEN MATCHED THEN
        UPDATE
           SET T.G_LABEL_ID          = S.G_LABEL_ID,
               T.G_LABEL_TYPE_ID     = S.G_LABEL_TYPE_ID,
               T.LAST_UPDATE_DATE    = SYSDATE,
               T.LAST_UPDATE_USER_ID = 'yangjin'
      WHEN NOT MATCHED THEN
        INSERT
          (T.ROW_ID,
           T.ITEM_CODE,
           T.G_LABEL_ID,
           T.G_LABEL_TYPE_ID,
           T.CREATE_DATE,
           T.CREATE_USER_ID,
           T.LAST_UPDATE_DATE,
           T.LAST_UPDATE_USER_ID)
        VALUES
          (GOODS_LABEL_LINK_SEQ.NEXTVAL,
           S.ITEM_CODE,
           S.G_LABEL_ID,
           S.G_LABEL_TYPE_ID,
           SYSDATE,
           'yangjin',
           SYSDATE,
           'yangjin');
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*ɾ����Ʒ��ǩ,�����Ʒû��������ɾ����ǩ*/
      DELETE GOODS_LABEL_LINK A
       WHERE A.G_LABEL_ID IN (1073, 1074, 1075)
         AND NOT EXISTS
       (SELECT 1
                FROM (SELECT C.ITEM_CODE, D.G_LABEL_ID, D.G_LABEL_TYPE_ID
                        FROM (SELECT B.ITEM_CODE,
                                     B.GOOD_PRICE_LEVEL ||
                                     '_MATXXL_PRICE_LEVEL' GOODS_MATXXL_PRICE_LEVEL
                                FROM DIM_GOOD B
                               WHERE B.CURRENT_FLG = 'Y'
                                 AND B.GOOD_PRICE_LEVEL IS NOT NULL) C,
                             GOODS_LABEL_HEAD D
                       WHERE C.GOODS_MATXXL_PRICE_LEVEL = D.G_LABEL_NAME
                         AND D.G_LABEL_ID IN (1077, 1078, 1079)) E
               WHERE A.ITEM_CODE = E.ITEM_CODE);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '�������IN_DATE_KEY:' || IN_DATE_KEY;
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
  END GOODS_MATXXL_PRICE_LEVEL;

  PROCEDURE GOODS_EVALUATE_ASPECT IS
    S_ETL                   W_ETL_LOG%ROWTYPE;
    SP_NAME                 S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER             S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS             NUMBER;
    DELETE_ROWS             NUMBER;
    UPDATE_ROWS             NUMBER;
    JSONARRAY               JSON_LIST; /*����JSON����*/
    ROW_FACT_GOODS_EVALUATE FACT_GOODS_EVALUATE%ROWTYPE;
    /*�����ά����*/
    TYPE TYPE_RECORD IS RECORD(
      GEVAL_ID NUMBER(20));
    TYPE TYPE_TABLE IS TABLE OF TYPE_RECORD INDEX BY BINARY_INTEGER;
    ROW_GEVAL_ID TYPE_TABLE;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-07-25
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.GOODS_EVALUATE_ASPECT'; --��Ҫ�ֹ�������дPROCEDURE������
    S_ETL.TABLE_NAME := 'FACT_GOODS_EVALUATE_ASPECT'; --�˴���Ҫ�ֹ�¼���PROCEDURE�����ı��
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
      /*����������JSON��*/
      UPDATE FACT_GOODS_EVALUATE A
         SET A.GEVAL_SENTIMENT_POLARITY_IASPE = SUBSTR(A.GEVAL_SENTIMENT_POLARITY_IASPE,
                                                       1,
                                                       INSTR(A.GEVAL_SENTIMENT_POLARITY_IASPE,
                                                             '}',
                                                             -1)) || ']'
       WHERE A.GEVAL_SENTIMENT_POLARITY_IASPE IS NOT NULL
         AND A.GEVAL_SENTIMENT_POLARITY_IASPE NOT LIKE '%}]';
      UPDATE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*�����ά����*/
      SELECT A.GEVAL_ID
        BULK COLLECT
        INTO ROW_GEVAL_ID
        FROM FACT_GOODS_EVALUATE A
       WHERE A.GEVAL_SENTIMENT_POLARITY <> 0
         AND A.GEVAL_SENTIMENT_POLARITY_IASPE IS NOT NULL
         AND A.GEVAL_SENTIMENT_POLARITY_IASPE LIKE '%}]'
         AND NOT EXISTS (SELECT 1
                FROM FACT_GOODS_EVALUATE_ASPECT B
               WHERE A.GEVAL_ID = B.GEVAL_ID)
      --AND ROWNUM <= 10000
       ORDER BY A.GEVAL_ID;
    
      /*����ROW_GEVAL_IDѭ������*/
      FOR I IN 1 .. ROW_GEVAL_ID.COUNT LOOP
        BEGIN
          SELECT A.GEVAL_ID,
                 A.GEVAL_ORDERGOODSID,
                 A.GEVAL_GOODS_COMMONID,
                 A.GEVAL_SENTIMENT_POLARITY_IASPE
            INTO ROW_FACT_GOODS_EVALUATE.GEVAL_ID,
                 ROW_FACT_GOODS_EVALUATE.GEVAL_ORDERGOODSID,
                 ROW_FACT_GOODS_EVALUATE.GEVAL_GOODS_COMMONID,
                 ROW_FACT_GOODS_EVALUATE.GEVAL_SENTIMENT_POLARITY_IASPE
            FROM FACT_GOODS_EVALUATE A
           WHERE A.GEVAL_ID = ROW_GEVAL_ID(I).GEVAL_ID;
          /*JSON����*/
          JSONARRAY := JSON_LIST(ROW_FACT_GOODS_EVALUATE.GEVAL_SENTIMENT_POLARITY_IASPE);
          /*JSONѭ��*/
          FOR I IN 1 .. JSONARRAY.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(JSON_EXT.GET_STRING(JSON(JSONARRAY.GET(I)),
                                                     'aspectCategory'));
            /*INSERT TABLE*/
            INSERT INTO FACT_GOODS_EVALUATE_ASPECT
              (ID_COL,
               GEVAL_ID,
               GEVAL_ORDERGOODSID,
               GEVAL_GOODS_COMMONID,
               ASPECT_CATEGORY,
               ASPECT_TERM,
               ASPECT_INDEX,
               ASPECT_POLARITY,
               OPINION_TERM,
               W_INSERT_DT,
               W_UPDATE_DT)
            VALUES
              (FACT_GOODS_EVALUATE_ASPECT_SEQ.NEXTVAL,
               ROW_FACT_GOODS_EVALUATE.GEVAL_ID,
               ROW_FACT_GOODS_EVALUATE.GEVAL_ORDERGOODSID,
               ROW_FACT_GOODS_EVALUATE.GEVAL_GOODS_COMMONID,
               JSON_EXT.GET_STRING(JSON(JSONARRAY.GET(I)), 'aspectCategory'),
               JSON_EXT.GET_STRING(JSON(JSONARRAY.GET(I)), 'aspectTerm'),
               JSON_EXT.GET_STRING(JSON(JSONARRAY.GET(I)), 'aspectIndex'),
               JSON_EXT.GET_STRING(JSON(JSONARRAY.GET(I)), 'aspectPolarity'),
               JSON_EXT.GET_STRING(JSON(JSONARRAY.GET(I)), 'opinionTerm'),
               SYSDATE,
               SYSDATE);
            INSERT_ROWS := SQL%ROWCOUNT + NVL(INSERT_ROWS, 0);
            COMMIT;
          END LOOP;
        END;
      END LOOP;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
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
  END GOODS_EVALUATE_ASPECT;

  PROCEDURE GOODS_EVALUATION_LEVEL IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
    ����˵����  
    ����ʱ�䣺yangjin  2018-06-22
    */
  BEGIN
    SP_NAME          := 'GOODS_LABEL_PKG.GOODS_EVALUATION_LEVEL'; --��Ҫ�ֹ�������дPROCEDURE������
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
  
    BEGIN
      /*�м��*/
      EXECUTE IMMEDIATE 'TRUNCATE TABLE GOODS_LABEL_1080_STAGE';
    
      INSERT INTO GOODS_LABEL_1080_STAGE
        (ITEM_CODE,
         ASPECT_CATEGORY,
         G_LABEL_ID,
         G_LABEL_NAME,
         G_LABEL_TYPE_ID,
         EVA_COUNT,
         EVA_POSITIVE_COUNT,
         EVA_NEGATIVE_COUNT,
         W_INSERT_DT,
         W_UPDATE_DT)
        SELECT D.ITEM_CODE,
               D.ASPECT_CATEGORY,
               G.LV3_ID G_LABEL_ID,
               E.LV2_NAME || '_' || D.EVA_LEVEL G_LABEL_NAME,
               G.LV3_TYPE_ID G_LABEL_TYPE_ID,
               D.EVA_COUNT,
               D.EVA_POSITIVE_COUNT,
               D.EVA_NEGATIVE_COUNT,
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM (SELECT C.ITEM_CODE,
                       C.ASPECT_CATEGORY,
                       C.EVA_COUNT,
                       C.EVA_POSITIVE_COUNT,
                       C.EVA_NEGATIVE_COUNT,
                       CASE
                         WHEN C.EVA_POSITIVE_PER < 0.7 THEN
                          'LOW'
                         WHEN C.EVA_POSITIVE_PER >= 0.7 AND
                              C.EVA_POSITIVE_PER < 0.9 THEN
                          'MEDIUM'
                         WHEN C.EVA_POSITIVE_PER >= 0.7 THEN
                          'HIGH'
                       END EVA_LEVEL
                  FROM (SELECT B.ITEM_CODE,
                               B.ASPECT_CATEGORY,
                               COUNT(1) EVA_COUNT,
                               SUM(B.COL1) EVA_POSITIVE_COUNT,
                               SUM(B.COL2) EVA_NEGATIVE_COUNT,
                               ROUND(SUM(B.COL1) / COUNT(1), 2) EVA_POSITIVE_PER
                          FROM (SELECT B1.ITEM_CODE,
                                       A1.ASPECT_CATEGORY,
                                       A1.ASPECT_POLARITY,
                                       CASE
                                         WHEN A1.ASPECT_POLARITY = '��' THEN
                                          1
                                         ELSE
                                          0
                                       END COL1,
                                       CASE
                                         WHEN A1.ASPECT_POLARITY = '��' THEN
                                          1
                                         ELSE
                                          0
                                       END COL2
                                  FROM FACT_GOODS_EVALUATE_ASPECT A1,
                                       DIM_EC_GOOD                B1
                                 WHERE A1.GEVAL_GOODS_COMMONID =
                                       B1.GOODS_COMMONID) B
                         GROUP BY B.ITEM_CODE, B.ASPECT_CATEGORY) C
                 WHERE C.EVA_COUNT >= 10 /*����������10�Ŵ���Ʒ��ǩ*/
                ) D,
               (SELECT DISTINCT F.LV2_NAME,
                                SUBSTR(F.LV2_DESC,
                                       INSTR(F.LV2_DESC, '(', 1) + 1,
                                       INSTR(F.LV2_DESC, ')', 1) -
                                       INSTR(F.LV2_DESC, '(', 1) - 1) ASPECT_CATEGORY
                  FROM GOODS_LABEL_HEAD_LEVEL_V F
                 WHERE F.LV1_ID = 1080) E,
               (SELECT H.LV3_TYPE_ID, H.LV3_ID, H.LV3_NAME
                  FROM GOODS_LABEL_HEAD_LEVEL_V H
                 WHERE H.LV1_ID = 1080) G
         WHERE D.ASPECT_CATEGORY = E.ASPECT_CATEGORY
           AND E.LV2_NAME || '_' || D.EVA_LEVEL = G.LV3_NAME;
      COMMIT;
    
      /*insert*/
      INSERT INTO GOODS_LABEL_LINK
        (ITEM_CODE,
         G_LABEL_ID,
         G_LABEL_TYPE_ID,
         CREATE_DATE,
         CREATE_USER_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATE_USER_ID,
         ROW_ID)
        SELECT A.ITEM_CODE,
               A.G_LABEL_ID,
               A.G_LABEL_TYPE_ID,
               SYSDATE CREATE_DATE,
               'yangjin' CREATE_USER_ID,
               SYSDATE LAST_UPDATE_DATE,
               'yangjin' LAST_UPDATE_USER_ID,
               GOODS_LABEL_LINK_SEQ.NEXTVAL
          FROM GOODS_LABEL_1080_STAGE A
         WHERE NOT EXISTS
         (SELECT 1
                  FROM GOODS_LABEL_LINK B
                 WHERE A.ITEM_CODE = B.ITEM_CODE
                   AND A.G_LABEL_ID = B.G_LABEL_ID
                   AND A.G_LABEL_TYPE_ID = B.G_LABEL_TYPE_ID);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*ɾ����Ʒ��ǩ,�����Ʒ����û����ɾ����ǩ*/
      DELETE GOODS_LABEL_LINK A
       WHERE EXISTS (SELECT 1
                FROM GOODS_LABEL_HEAD_LEVEL_V F
               WHERE F.LV1_ID = 1080
                 AND A.G_LABEL_ID = F.LV3_ID)
         AND NOT EXISTS (SELECT 1
                FROM GOODS_LABEL_1080_STAGE B
               WHERE A.ITEM_CODE = B.ITEM_CODE
                 AND A.G_LABEL_ID = B.G_LABEL_ID);
      DELETE_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
    END;
    /*��־��¼ģ��*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
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
  END GOODS_EVALUATION_LEVEL;

END GOODS_LABEL_PKG;
/
