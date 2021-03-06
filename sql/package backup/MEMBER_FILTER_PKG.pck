CREATE OR REPLACE PACKAGE MEMBER_FILTER_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-08-03
  -- PURPOSE : MEMBER SMS POOL PACKAGE

  FUNCTION SPLICE_SQL(I_FILTER_ID        IN NUMBER,
                      I_MEMBER_LABEL_SET IN VARCHAR2,
                      I_ITEM_CODE_SET    IN VARCHAR2,
                      I_BRAND_SET        IN VARCHAR2,
                      I_MATXL_SET        VARCHAR2) RETURN VARCHAR2;

  PROCEDURE SYNC_MEMBER_LABEL_HEAD(IN_SYNC_DATE_KEY IN NUMBER);
  /*
  功能名:       SYNC_MEMBER_LABEL_HEAD
  目的:         MEMBER_LABEL_HEAD同步
  作者:         yangjin
  创建时间：    2017/10/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE SYNC_MEMBER_LABEL_LINK;
  /*
  功能名:       SYNC_MEMBER_LABEL_LINK
  目的:         MEMBER_LABEL_LINK同步
  作者:         yangjin
  创建时间：    2017/10/10
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MEMBER_RESULT_TO_TABLE;
  /*
  功能名:       MEMBER_RESULT_TO_TABLE
  目的:         会员筛选写入结果表
  作者:         yangjin
  创建时间：    2017/10/23
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MEMBER_OUTPUT_FILE(I_FILTER_ID        IN NUMBER,
                               O_OUTPUT_FILE_PATH OUT VARCHAR2);
  /*
  功能名:       MEMBER_OUTPUT_FILE
  目的:         会员筛选结果表导出文件
  作者:         yangjin
  创建时间：    2017/10/23
  最后修改人：
  最后更改日期：
  */

  PROCEDURE DEBUG(I_FILTER_ID IN NUMBER);
  /*
  功能名:       DEBUG
  目的:         DEBUG
  作者:         yangjin
  创建时间：    2017/10/26
  最后修改人：
  最后更改日期：
  */

END MEMBER_FILTER_PKG;
/
CREATE OR REPLACE PACKAGE BODY MEMBER_FILTER_PKG IS

  FUNCTION SPLICE_SQL(I_FILTER_ID        IN NUMBER,
                      I_MEMBER_LABEL_SET IN VARCHAR2,
                      I_ITEM_CODE_SET    IN VARCHAR2,
                      I_BRAND_SET        IN VARCHAR2,
                      I_MATXL_SET        VARCHAR2) RETURN VARCHAR2 IS
    /*
       目的:      拼接SQL语句
       作者:      yangjin
       创建时间:  2017/10/26
    */
    STR_INSERT         VARCHAR2(100);
    STR_SELECT         VARCHAR2(150);
    STR_FROM           VARCHAR2(3700);
    STR_WHERE          VARCHAR2(50);
    STR_SUB_SELECT     VARCHAR2(30);
    STR_SUB_FROM       VARCHAR2(30);
    STR_SUB_WHERE      VARCHAR2(3600);
    STR_SUB_WHERE_S1   VARCHAR2(200);
    STR_SUB_WHERE_S2   VARCHAR2(1800);
    STR_SUB_WHERE_S3   VARCHAR2(200);
    STR_SUB_WHERE_S4   VARCHAR2(1800);
    STR_ALL_SQL        VARCHAR2(4000);
    TRAN_SET           VARCHAR2(2000);
    STR_AND            VARCHAR2(1800);
    STR_AND_SUB        VARCHAR2(300);
    STR_AND_NOT_IN     VARCHAR2(1800);
    STR_AND_NOT_IN_SUB VARCHAR2(300);
    STR_ITEM_WHERE     VARCHAR2(2000);
    STR_BRAND_WHERE    VARCHAR2(2000);
    STR_MATXL_WHERE    VARCHAR2(2000);
    --CNT               NUMBER;
    OP_AND_CNT        NUMBER;
    OP_AND_NOT_IN_CNT NUMBER;
  
  BEGIN
    /*共用SQL语句*/
    STR_INSERT := 'INSERT INTO MEMBER_FILTER_RESULT (ROW_ID, FILTER_ID, MEMBER_BP, VID, OPENID, PUSHID) ';
    STR_SELECT := 'SELECT MEMBER_FILTER_RESULT_SEQ.NEXTVAL ROW_ID,' ||
                  I_FILTER_ID ||
                  ' FILTER_ID,C.MEMBER_KEY MEMBER_BP,D.VID VID,D.OPEN_ID OPENID,D.PUSH_ID PUSHID ';
    STR_WHERE  := 'WHERE C.MEMBER_KEY = D.MEMBER_KEY(+)';
  
    IF I_MEMBER_LABEL_SET IS NOT NULL
    THEN
      /*I_MEMBER_LABEL_SET不为空*/
      /*字符串大写处理*/
      TRAN_SET := UPPER(I_MEMBER_LABEL_SET);
      /*判断%op_and出现的次数,填上序号*/
      SELECT (LENGTH(TRAN_SET) - LENGTH(REPLACE(TRAN_SET, '%OP_AND '))) /
             LENGTH('%OP_AND ')
        INTO OP_AND_CNT
        FROM DUAL;
      FOR I IN 1 .. OP_AND_CNT LOOP
        TRAN_SET := REGEXP_REPLACE(TRAN_SET,
                                   '%OP_AND',
                                   '%OPR_AND_' || I,
                                   1,
                                   1);
      END LOOP;
    
      /*判断%op_and_not_in出现的次数,填上序号*/
      SELECT (LENGTH(TRAN_SET) -
             LENGTH(REPLACE(TRAN_SET, '%OP_AND_NOT_IN '))) /
             LENGTH('%OP_AND_NOT_IN')
        INTO OP_AND_NOT_IN_CNT
        FROM DUAL;
      FOR I IN 1 .. OP_AND_NOT_IN_CNT LOOP
        TRAN_SET := REGEXP_REPLACE(TRAN_SET,
                                   '%OP_AND_NOT_IN',
                                   '%OPR_AND_NOT_IN_' || I,
                                   1,
                                   1);
      END LOOP;
    
      /*开始拼接SQL语句*/
      STR_SUB_SELECT   := 'SELECT DISTINCT A.MEMBER_KEY ';
      STR_SUB_FROM     := 'FROM MEMBER_LABEL_LINK A ';
      STR_SUB_WHERE    := 'WHERE ' || TRAN_SET;
      STR_SUB_WHERE    := REPLACE(STR_SUB_WHERE,
                                  '%COL_M_LABEL_ID',
                                  'M_LABEL_ID');
      STR_SUB_WHERE    := REPLACE(STR_SUB_WHERE, '%OP_OR', 'OR');
      STR_SUB_WHERE_S1 := SUBSTR(STR_SUB_WHERE,
                                 1,
                                 INSTR(STR_SUB_WHERE, '%OPR_AND_1') - 1);
      STR_SUB_WHERE_S2 := SUBSTR(STR_SUB_WHERE,
                                 INSTR(STR_SUB_WHERE, '%OPR_AND_1'));
      /*顺序替换%OPR_AND_*/
      /*如果用户标签没有and操作符，则不用替换*/
      IF OP_AND_CNT > 0
      THEN
        FOR J IN 1 .. OP_AND_CNT LOOP
          STR_AND_SUB := SUBSTR(STR_SUB_WHERE_S2,
                                INSTR(STR_SUB_WHERE_S2, '%OPR_AND_' || J),
                                INSTR(STR_SUB_WHERE_S2,
                                      ')',
                                      INSTR(STR_SUB_WHERE_S2,
                                            '%OPR_AND_' || J)) -
                                INSTR(STR_SUB_WHERE_S2, '%OPR_AND_' || J) + 1);
          STR_AND_SUB := REGEXP_REPLACE(STR_AND_SUB,
                                        '%OPR_AND_' || J,
                                        'AND EXISTS (SELECT 1 FROM MEMBER_LABEL_LINK A' || J ||
                                        ' WHERE A' || J ||
                                        '.MEMBER_KEY = A.MEMBER_KEY AND ',
                                        1,
                                        1);
        
          STR_AND_SUB := STR_AND_SUB || ') ';
          STR_AND     := STR_AND || STR_AND_SUB;
        END LOOP;
      ELSE
        /*如果用户标签没有and操作符，则不用替换*/
        STR_AND := STR_SUB_WHERE_S2;
      END IF;
      STR_SUB_WHERE := STR_SUB_WHERE_S1 || STR_AND;
    
      /*顺序替换%OPR_AND_NOT_IN*/
      /*如果用户标签没有and not in操作符，则不用替换*/
      DBMS_OUTPUT.PUT_LINE('STR_SUB_WHERE:' || STR_SUB_WHERE);
      STR_SUB_WHERE_S3 := SUBSTR(STR_SUB_WHERE,
                                 1,
                                 INSTR(STR_SUB_WHERE, '%OPR_AND_NOT_IN_1') - 1);
      STR_SUB_WHERE_S4 := SUBSTR(STR_SUB_WHERE,
                                 INSTR(STR_SUB_WHERE, '%OPR_AND_NOT_IN_1'));
      IF OP_AND_NOT_IN_CNT > 0
      THEN
        FOR J IN 1 .. OP_AND_NOT_IN_CNT LOOP
          STR_AND_NOT_IN_SUB := SUBSTR(STR_SUB_WHERE_S4,
                                       INSTR(STR_SUB_WHERE_S4,
                                             '%OPR_AND_NOT_IN_' || J),
                                       INSTR(STR_SUB_WHERE_S4,
                                             ')',
                                             INSTR(STR_SUB_WHERE_S4,
                                                   '%OPR_AND_NOT_IN_' || J)) -
                                       INSTR(STR_SUB_WHERE_S4,
                                             '%OPR_AND_NOT_IN_' || J) + 1);
          STR_AND_NOT_IN_SUB := REGEXP_REPLACE(STR_AND_NOT_IN_SUB,
                                               '%OPR_AND_NOT_IN_' || J,
                                               'AND NOT EXISTS (SELECT 1 FROM MEMBER_LABEL_LINK A' || J ||
                                               ' WHERE A' || J ||
                                               '.MEMBER_KEY = A.MEMBER_KEY AND ',
                                               1,
                                               1);
          STR_AND_NOT_IN     := STR_AND_NOT_IN_SUB || ') ';
        
        END LOOP;
      ELSE
        STR_AND_NOT_IN := STR_SUB_WHERE_S4;
      END IF;
      STR_SUB_WHERE := STR_SUB_WHERE_S3 || STR_AND_NOT_IN;
    
      /*ITEM_CODE*/
      IF I_ITEM_CODE_SET IS NOT NULL
      THEN
        /*I_MEMBER_LABEL_SET不为空*/
        /*I_ITEM_CODE_SET不为空*/
        STR_ITEM_WHERE := UPPER(I_ITEM_CODE_SET);
        STR_ITEM_WHERE := REPLACE(STR_ITEM_WHERE, '%OP_IN', 'IN');
        STR_ITEM_WHERE := REPLACE(STR_ITEM_WHERE,
                                  SUBSTR(STR_ITEM_WHERE,
                                         1,
                                         INSTR(STR_ITEM_WHERE,
                                               '%COL_ITEM_CODE') +
                                         LENGTH('%COL_ITEM_CODE') - 1),
                                  'AND EXISTS (SELECT 1 FROM MEMBER_LIKE_ITEM_SYN I WHERE I.MEMBER_KEY = A.MEMBER_KEY AND I.ITEM_CODE');
      ELSE
        STR_ITEM_WHERE := '';
      END IF;
      /*BRAND*/
      IF I_BRAND_SET IS NOT NULL
      THEN
        STR_BRAND_WHERE := '';
      ELSE
        STR_BRAND_WHERE := '';
      END IF;
    
      /*MATXL*/
      IF I_MATXL_SET IS NOT NULL
      THEN
        STR_MATXL_WHERE := UPPER(I_MATXL_SET);
        STR_MATXL_WHERE := REPLACE(STR_MATXL_WHERE, '%OP_IN', 'IN');
        STR_MATXL_WHERE := REPLACE(STR_MATXL_WHERE,
                                   SUBSTR(STR_MATXL_WHERE,
                                          1,
                                          INSTR(STR_MATXL_WHERE, '%COL_MATXL') +
                                          LENGTH('%COL_MATXL') - 1),
                                   'AND EXISTS (SELECT 1 FROM MEMBER_LIKE_MATXL_SYN M WHERE M.MEMBER_KEY = A.MEMBER_KEY AND M.MATXL');
      ELSE
        STR_MATXL_WHERE := '';
      END IF;
      /*会员标签+商品+小类+品牌*/
      STR_FROM := 'FROM (' || STR_SUB_SELECT || STR_SUB_FROM ||
                  STR_SUB_WHERE || STR_ITEM_WHERE || STR_MATXL_WHERE ||
                  STR_BRAND_WHERE || ') C,ML_MEMBER_MAPPING_SYN D ';
    
      STR_ALL_SQL := STR_INSERT || STR_SELECT || STR_FROM || STR_WHERE;
      RETURN(STR_ALL_SQL);
    ELSE
      IF I_ITEM_CODE_SET IS NOT NULL
      THEN
        /*I_MEMBER_LABEL_SET为空*/
        /*I_ITEM_CODE_SET不为空*/
        STR_SUB_SELECT := 'SELECT DISTINCT A.MEMBER_KEY ';
        STR_SUB_FROM   := 'FROM MEMBER_LIKE_ITEM_SYN A ';
        STR_SUB_WHERE  := I_ITEM_CODE_SET;
        STR_SUB_WHERE  := UPPER(STR_SUB_WHERE);
        STR_SUB_WHERE  := REPLACE(STR_SUB_WHERE, '%OP_IN', 'IN');
        STR_SUB_WHERE  := REPLACE(STR_SUB_WHERE,
                                  SUBSTR(STR_SUB_WHERE,
                                         1,
                                         INSTR(STR_SUB_WHERE,
                                               '%COL_ITEM_CODE') +
                                         LENGTH('%COL_ITEM_CODE') - 1),
                                  'WHERE A.ITEM_CODE ');
        STR_SUB_WHERE  := REPLACE(STR_SUB_WHERE, ')', '') || ')';
        /*BRAND*/
        IF I_BRAND_SET IS NOT NULL
        THEN
          STR_BRAND_WHERE := '';
        ELSE
          STR_BRAND_WHERE := '';
        END IF;
      
        /*MATXL*/
        IF I_MATXL_SET IS NOT NULL
        THEN
          STR_MATXL_WHERE := UPPER(I_MATXL_SET);
          STR_MATXL_WHERE := REPLACE(STR_MATXL_WHERE, '%OP_IN', 'IN');
          STR_MATXL_WHERE := REPLACE(STR_MATXL_WHERE,
                                     SUBSTR(STR_MATXL_WHERE,
                                            1,
                                            INSTR(STR_MATXL_WHERE,
                                                  '%COL_MATXL') +
                                            LENGTH('%COL_MATXL') - 1),
                                     'AND EXISTS (SELECT 1 FROM MEMBER_LIKE_MATXL_SYN M WHERE M.MEMBER_KEY = A.MEMBER_KEY AND M.MATXL');
        ELSE
          STR_MATXL_WHERE := '';
        END IF;
      
        /*商品+小类+品牌*/
        STR_FROM    := 'FROM (' || STR_SUB_SELECT || STR_SUB_FROM ||
                       STR_SUB_WHERE || STR_MATXL_WHERE || STR_BRAND_WHERE ||
                       ') C,ML_MEMBER_MAPPING_SYN D ';
        STR_ALL_SQL := STR_INSERT || STR_SELECT || STR_FROM || STR_WHERE;
        RETURN(STR_ALL_SQL);
      ELSE
        IF I_MATXL_SET IS NOT NULL
        THEN
          /*I_MEMBER_LABEL_SET为空*/
          /*I_ITEM_CODE_SET不为空*/
          /*I_MATXL_SET不为空*/
          STR_SUB_SELECT := 'SELECT DISTINCT A.MEMBER_KEY ';
          STR_SUB_FROM   := 'FROM MEMBER_LIKE_MATXL_SYN A ';
          STR_SUB_WHERE  := I_MATXL_SET;
          STR_SUB_WHERE  := UPPER(STR_SUB_WHERE);
          STR_SUB_WHERE  := REPLACE(STR_SUB_WHERE, '%OP_IN', 'IN');
          STR_SUB_WHERE  := REPLACE(STR_SUB_WHERE,
                                    SUBSTR(STR_SUB_WHERE,
                                           1,
                                           INSTR(STR_SUB_WHERE, '%COL_MATXL') +
                                           LENGTH('%COL_MATXL') - 1),
                                    'WHERE A.MATXL ');
          STR_SUB_WHERE  := REPLACE(STR_SUB_WHERE, ')', '') || ')';
          /*BRAND*/
          IF I_BRAND_SET IS NOT NULL
          THEN
            STR_BRAND_WHERE := '';
          ELSE
            STR_BRAND_WHERE := '';
          END IF;
        
          /*小类+品牌*/
          STR_FROM    := 'FROM (' || STR_SUB_SELECT || STR_SUB_FROM ||
                         STR_SUB_WHERE || STR_BRAND_WHERE ||
                         ') C,ML_MEMBER_MAPPING_SYN D ';
          STR_ALL_SQL := STR_INSERT || STR_SELECT || STR_FROM || STR_WHERE;
          RETURN(STR_ALL_SQL);
        ELSE
          IF I_BRAND_SET IS NOT NULL
          /*I_MEMBER_LABEL_SET为空*/
          /*I_ITEM_CODE_SET不为空*/
          /*I_MATXL_SET为空*/
          /*I_BRAND_SET不为空*/
          THEN
            STR_ALL_SQL := '';
          ELSE
            STR_ALL_SQL := '';
          END IF;
          RETURN(STR_ALL_SQL);
        END IF;
      END IF;
    END IF;
  END SPLICE_SQL;

  PROCEDURE SYNC_MEMBER_LABEL_HEAD(IN_SYNC_DATE_KEY IN NUMBER) IS
    S_ETL        W_ETL_LOG%ROWTYPE;
    SP_NAME      S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER  S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS  NUMBER;
    UPDATE_ROWS  NUMBER;
    IN_SYNC_DATE DATE;
    /*
       目的:      同步27上的member_label_head
       作者:      yangjin
       创建时间:  2017/10/10
    */
  BEGIN
    SP_NAME          := 'MEMBER_FILTER_PKG.SYNC_MEMBER_LABEL_HEAD'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_HEAD'; --此处需要手工录入该PROCEDURE操作的表格
    S_ETL.PROC_NAME  := SP_NAME;
    S_ETL.START_TIME := SYSDATE;
    S_PARAMETER      := 0;
    IN_SYNC_DATE     := TO_DATE(IN_SYNC_DATE_KEY, 'YYYYMMDD');
  
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
    /*同步MEMBER_LABEL_HEAD*/
    /*先插入到临时表*/
    EXECUTE IMMEDIATE 'TRUNCATE TABLE MEMBER_LABEL_HEAD_TMP';
    INSERT INTO MEMBER_LABEL_HEAD_TMP
      SELECT A.M_LABEL_ID,
             A.M_LABEL_NAME,
             A.M_LABEL_DESC,
             A.M_LABEL_TYPE_ID,
             A.M_LABEL_FATHER_ID,
             A.CREATE_DATE,
             A.CREATE_USER_ID,
             A.LAST_UPDATE_DATE,
             A.LAST_UPDATE_USER_ID,
             A.CURRENT_FLAG,
             A.SORT_FIELD
        FROM MEMBER_LABEL_HEAD@DW27 A
       WHERE TRUNC(A.LAST_UPDATE_DATE) >= TRUNC(IN_SYNC_DATE);
    COMMIT;
  
    /*分析临时表*/
    DBMS_STATS.GATHER_TABLE_STATS('ML', 'MEMBER_LABEL_HEAD_TMP');
  
    /*插入到正式表*/
    MERGE /*+APPEND*/
    INTO MEMBER_LABEL_HEAD T
    USING MEMBER_LABEL_HEAD_TMP S
    ON (T.M_LABEL_ID = S.M_LABEL_ID)
    WHEN MATCHED THEN
      UPDATE
         SET T.M_LABEL_NAME        = S.M_LABEL_NAME,
             T.M_LABEL_DESC        = S.M_LABEL_DESC,
             T.M_LABEL_TYPE_ID     = S.M_LABEL_TYPE_ID,
             T.M_LABEL_FATHER_ID   = S.M_LABEL_FATHER_ID,
             T.CREATE_DATE         = S.CREATE_DATE,
             T.CREATE_USER_ID      = S.CREATE_USER_ID,
             T.LAST_UPDATE_DATE    = S.LAST_UPDATE_DATE,
             T.LAST_UPDATE_USER_ID = S.LAST_UPDATE_USER_ID,
             T.CURRENT_FLAG        = S.CURRENT_FLAG
    WHEN NOT MATCHED THEN
      INSERT
        (T.M_LABEL_ID,
         T.M_LABEL_NAME,
         T.M_LABEL_DESC,
         T.M_LABEL_TYPE_ID,
         T.M_LABEL_FATHER_ID,
         T.CREATE_DATE,
         T.CREATE_USER_ID,
         T.LAST_UPDATE_DATE,
         T.LAST_UPDATE_USER_ID,
         T.CURRENT_FLAG,
         T.SORT_FIELD)
      VALUES
        (S.M_LABEL_ID,
         S.M_LABEL_NAME,
         S.M_LABEL_DESC,
         S.M_LABEL_TYPE_ID,
         S.M_LABEL_FATHER_ID,
         S.CREATE_DATE,
         S.CREATE_USER_ID,
         S.LAST_UPDATE_DATE,
         S.LAST_UPDATE_USER_ID,
         S.CURRENT_FLAG,
         S.SORT_FIELD);
    INSERT_ROWS := SQL%ROWCOUNT;
    COMMIT;
  
    /*OPERATORS逻辑操作符更新值*/
    UPDATE MEMBER_LABEL_HEAD A
       SET A.OPERATORS = '%op_and'
     WHERE A.OPERATORS IS NULL;
    COMMIT;
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '输入参数:IN_SYNC_DATE_KEY:' ||
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
  END SYNC_MEMBER_LABEL_HEAD;

  PROCEDURE SYNC_MEMBER_LABEL_LINK IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    DELETE_ROWS NUMBER;
    /*
       目的:      同步27上的member_label_link
       作者:      yangjin
       创建时间:  2017/10/10
    */
  BEGIN
    SP_NAME          := 'MEMBER_FILTER_PKG.SYNC_MEMBER_LABEL_LINK'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'MEMBER_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    /*merge into 插入的记录不会被记录到MLOG$_MEMBER_LABEL_LINK,所以再重新更新一次*/
    UPDATE MEMBER_LABEL_LINK@DW27 A
       SET A.LAST_UPDATE_DATE = A.CREATE_DATE + 1 / 24 / 60 / 60
     WHERE A.CREATE_DATE = A.LAST_UPDATE_DATE
       AND TRUNC(A.CREATE_DATE) >= TRUNC(SYSDATE - 1);
    COMMIT;
  
    /*INSERT_ROWS*/
    SELECT COUNT(1)
      INTO INSERT_ROWS
      FROM MLOG$_MEMBER_LABEL_LINK@DW27
     WHERE DMLTYPE$$ = 'I';
  
    /*UPDATE_ROWS*/
    SELECT COUNT(1)
      INTO UPDATE_ROWS
      FROM MLOG$_MEMBER_LABEL_LINK@DW27
     WHERE DMLTYPE$$ = 'U';
  
    /*DELETE_ROWS*/
    SELECT COUNT(1)
      INTO DELETE_ROWS
      FROM MLOG$_MEMBER_LABEL_LINK@DW27
     WHERE DMLTYPE$$ = 'D';
  
    /*刷新物化视图MEMBER_LABEL_LINK_MV*/
    DBMS_MVIEW.REFRESH('MEMBER_LABEL_LINK_MV', METHOD => 'FAST');
  
    /*日志记录模块*/
    S_ETL.END_TIME       := SYSDATE;
    S_ETL.ETL_RECORD_INS := INSERT_ROWS;
    S_ETL.ETL_RECORD_UPD := UPDATE_ROWS;
    S_ETL.ETL_RECORD_DEL := DELETE_ROWS;
    S_ETL.ETL_STATUS     := 'SUCCESS';
    S_ETL.ERR_MSG        := '无输入参数';
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
  END SYNC_MEMBER_LABEL_LINK;

  PROCEDURE MEMBER_RESULT_TO_TABLE IS
    V_TABLE_HEAD MEMBER_FILTER_OPTION_HEAD%ROWTYPE;
    V_STR_SQL    VARCHAR2(4000);
    --V_STR_SQL NCLOB;
    /*
       目的:      执行会员筛选操作
       作者:      yangjin
       创建时间:  2017/10/24
    */
  BEGIN
    /*记录执行开始时间*/
    V_TABLE_HEAD.EXECUTION_START_TIME := SYSDATE;
  
    /*获取可运行的最小FILTER_ID*/
    SELECT MIN(A.FILTER_ID)
      INTO V_TABLE_HEAD.FILTER_ID
      FROM MEMBER_FILTER_OPTION_HEAD A
     WHERE (A.MEMBER_LABEL_ID_SET IS NOT NULL OR
           A.ITEM_CODE_SET IS NOT NULL OR A.BRAND_SET IS NOT NULL OR
           A.MATXL_SET IS NOT NULL) /*如果会员标签、商品编码、品牌、小类编码都为空，则不执行*/
       AND A.STATUS = 0;
  
    /*获取到filter_id之后再执行后面的语句*/
    IF V_TABLE_HEAD.FILTER_ID IS NOT NULL
    THEN
      /*修改状态为正在执行*/
      UPDATE MEMBER_FILTER_OPTION_HEAD A
         SET A.STATUS = 1
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
      COMMIT;
    
      /*取出会员标签筛选条件*/
      SELECT A.MEMBER_LABEL_ID_SET
        INTO V_TABLE_HEAD.MEMBER_LABEL_ID_SET
        FROM MEMBER_FILTER_OPTION_HEAD A
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
    
      /*取出商品筛选条件*/
      SELECT A.ITEM_CODE_SET
        INTO V_TABLE_HEAD.ITEM_CODE_SET
        FROM MEMBER_FILTER_OPTION_HEAD A
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
    
      /*取出小类编码筛选条件*/
      SELECT A.MATXL_SET
        INTO V_TABLE_HEAD.MATXL_SET
        FROM MEMBER_FILTER_OPTION_HEAD A
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
    
      /*取出品牌筛选条件*/
      SELECT A.BRAND_SET
        INTO V_TABLE_HEAD.BRAND_SET
        FROM MEMBER_FILTER_OPTION_HEAD A
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
    
      /*转换成SQL语句*/
      V_STR_SQL := MEMBER_FILTER_PKG.SPLICE_SQL(V_TABLE_HEAD.FILTER_ID,
                                                V_TABLE_HEAD.MEMBER_LABEL_ID_SET,
                                                V_TABLE_HEAD.ITEM_CODE_SET,
                                                V_TABLE_HEAD.BRAND_SET,
                                                V_TABLE_HEAD.MATXL_SET);
    
      /*执行SQL语句*/
      DBMS_OUTPUT.PUT_LINE(V_STR_SQL);
      EXECUTE IMMEDIATE V_STR_SQL;
    
      /*记录插入结果表的行数*/
      SELECT NVL(COUNT(DISTINCT A.MEMBER_BP), 0)
        INTO V_TABLE_HEAD.RESULT_RECORDS
        FROM MEMBER_FILTER_RESULT A
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
    
      /*导出筛选结果的文本文件*/
      MEMBER_OUTPUT_FILE(V_TABLE_HEAD.FILTER_ID,
                         V_TABLE_HEAD.OUTPUT_FILE_PATH);
    
      /*记录执行完成时间*/
      V_TABLE_HEAD.EXECUTION_END_TIME := SYSDATE;
    
      /*执行完成写入记录*/
      UPDATE MEMBER_FILTER_OPTION_HEAD A
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
      UPDATE MEMBER_FILTER_OPTION_HEAD A
         SET A.STATUS               = 9,
             A.RESULT_MESSAGE       = V_TABLE_HEAD.RESULT_MESSAGE,
             A.EXECUTION_START_TIME = V_TABLE_HEAD.EXECUTION_START_TIME,
             A.EXECUTION_END_TIME   = V_TABLE_HEAD.EXECUTION_END_TIME,
             A.RESULT_RECORDS       = V_TABLE_HEAD.RESULT_RECORDS,
             A.OUTPUT_FILE_PATH     = V_TABLE_HEAD.OUTPUT_FILE_PATH
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID
         AND A.STATUS = 1;
      COMMIT;
  END MEMBER_RESULT_TO_TABLE;

  PROCEDURE MEMBER_OUTPUT_FILE(I_FILTER_ID        IN NUMBER,
                               O_OUTPUT_FILE_PATH OUT VARCHAR2) IS
    /*
       目的:      会员操作结果导出到文件
       作者:      yangjin
       创建时间:  2017/10/24
       导出绝对路径：/data/htdocs/pushadmin.happigo.com/Public/download
       导出相对路径：/Public/download
    */
  
    T_HEAD        MEMBER_FILTER_OPTION_HEAD%ROWTYPE;
    V_OUTPUT_FILE UTL_FILE.FILE_TYPE;
    V_OUTPUT_DATE VARCHAR2(14);
    V_FILE_NAME   VARCHAR2(50);
  BEGIN
    /*获取导出的行数*/
    SELECT COUNT(DISTINCT A.MEMBER_BP)
      INTO T_HEAD.RESULT_RECORDS
      FROM MEMBER_FILTER_RESULT A
     WHERE A.FILTER_ID = I_FILTER_ID;
  
    /*导出时间*/
    SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS')
      INTO V_OUTPUT_DATE
      FROM DUAL;
  
    /*统一文件名称*/
    V_FILE_NAME := 'member_result_' || I_FILTER_ID || '_' || V_OUTPUT_DATE || '_' ||
                   T_HEAD.RESULT_RECORDS || '.txt';
    /*打开文件*/
    V_OUTPUT_FILE := UTL_FILE.FOPEN('MEMBER_LABEL_OUTPUT', V_FILE_NAME, 'W');
  
    /*导出文件路径写入返回变量O_OUTPUT_FILE_PATH*/
    O_OUTPUT_FILE_PATH := '/Public/download';
    O_OUTPUT_FILE_PATH := O_OUTPUT_FILE_PATH || '/' || V_FILE_NAME;
    /*写入title*/
    UTL_FILE.PUT_LINE(V_OUTPUT_FILE, 'ROWNUM,FILTER_ID,MEMBER_BP');
  
    /*循环，获取需要导出的数据*/
    FOR I IN (SELECT ROWNUM, B.FILTER_ID, B.MEMBER_BP
                FROM (SELECT A.FILTER_ID, A.MEMBER_BP
                        FROM MEMBER_FILTER_RESULT A
                       WHERE A.FILTER_ID = I_FILTER_ID
                       GROUP BY A.FILTER_ID, A.MEMBER_BP
                       ORDER BY A.FILTER_ID, A.MEMBER_BP) B) LOOP
    
      /*行数据依次写入文件*/
      UTL_FILE.PUT_LINE(V_OUTPUT_FILE,
                        I.ROWNUM || ',' || I.FILTER_ID || ',' ||
                        I.MEMBER_BP);
    END LOOP;
  
    /*关闭文件*/
    UTL_FILE.FCLOSE(V_OUTPUT_FILE);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      RETURN;
  END MEMBER_OUTPUT_FILE;

  PROCEDURE DEBUG(I_FILTER_ID IN NUMBER) IS
    /*
       目的:      调试
       作者:      yangjin
       创建时间:  2017/10/24
    */
  BEGIN
    /*删除结果表数据*/
    DELETE MEMBER_FILTER_RESULT A WHERE A.FILTER_ID = I_FILTER_ID;
    COMMIT;
  
    /*更新head表状态*/
    UPDATE MEMBER_FILTER_OPTION_HEAD A
       SET A.STATUS               = 0,
           A.EXECUTION_START_TIME = NULL,
           A.EXECUTION_END_TIME   = NULL,
           A.RESULT_RECORDS       = NULL,
           A.RESULT_MESSAGE       = NULL,
           A.OUTPUT_FILE_PATH     = NULL
     WHERE A.FILTER_ID = I_FILTER_ID
       AND (A.MEMBER_LABEL_ID_SET IS NOT NULL OR
           A.ITEM_CODE_SET IS NOT NULL OR A.BRAND_SET IS NOT NULL OR
           A.MATXL_SET IS NOT NULL);
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      RETURN;
  END DEBUG;

END MEMBER_FILTER_PKG;
/
