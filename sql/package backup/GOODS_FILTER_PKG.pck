CREATE OR REPLACE PACKAGE GOODS_FILTER_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2018-05-04 青年节快乐！！！
  -- PURPOSE : GOODS_FILTER_PKG

  FUNCTION SPLICE_SQL(I_FILTER_ID          IN NUMBER,
                      I_GOODS_LABEL_ID_SET IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE SYNC_GOODS_LABEL_HEAD(IN_SYNC_DATE_KEY IN NUMBER);
  /*
  功能名:       SYNC_GOODS_LABEL_HEAD
  目的:         GOODS_LABEL_HEAD同步
  作者:         yangjin
  创建时间：    2018/05/04
  最后修改人：
  最后更改日期：
  */

  PROCEDURE SYNC_GOODS_LABEL_LINK;
  /*
  功能名:       SYNC_GOODS_LABEL_LINK
  目的:         GOODS_LABEL_LINK同步
  作者:         yangjin
  创建时间：    2018/05/04
  最后修改人：
  最后更改日期：
  */

  PROCEDURE GOODS_RESULT_TO_TABLE;
  /*
  功能名:       GOODS_RESULT_TO_TABLE
  目的:         会员筛选写入结果表
  作者:         yangjin
  创建时间：    2018/05/24
  最后修改人：
  最后更改日期：
  */

  PROCEDURE GOODS_OUTPUT_FILE(I_FILTER_ID        IN NUMBER,
                              O_OUTPUT_FILE_PATH OUT VARCHAR2);
  /*
  功能名:       GOODS_OUTPUT_FILE
  目的:         商品编码筛选结果表导出文件
  作者:         yangjin
  创建时间：    2018/05/25
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

END GOODS_FILTER_PKG;
/
CREATE OR REPLACE PACKAGE BODY GOODS_FILTER_PKG IS

  FUNCTION SPLICE_SQL(I_FILTER_ID          IN NUMBER,
                      I_GOODS_LABEL_ID_SET IN VARCHAR2) RETURN VARCHAR2 IS
    /*
       目的:      拼接SQL语句
       作者:      yangjin
       创建时间:  2017/10/26
    */
    STR_INSERT       VARCHAR2(100);
    STR_SELECT       VARCHAR2(150);
    STR_FROM         VARCHAR2(3700);
    STR_SUB_SELECT   VARCHAR2(30);
    STR_SUB_FROM     VARCHAR2(30);
    STR_SUB_WHERE    VARCHAR2(4000);
    STR_SUB_WHERE_S1 VARCHAR2(4000);
    STR_SUB_WHERE_S2 VARCHAR2(4000);
    STR_ALL_SQL      VARCHAR2(4000);
    TRAN_SET         VARCHAR2(4000);
    STR_AND          VARCHAR2(4000);
    STR_AND_SUB      VARCHAR2(4000);
    STR_ITEM_WHERE   VARCHAR2(2000);
    STR_BRAND_WHERE  VARCHAR2(2000);
    STR_MATXL_WHERE  VARCHAR2(2000);
    OP_AND_CNT       NUMBER;
  
  BEGIN
    /*共用SQL语句*/
    STR_INSERT := 'INSERT INTO GOODS_FILTER_RESULT (ROW_ID, FILTER_ID, ITEM_CODE, W_INSERT_DT, W_UPDATE_DT) ';
    STR_SELECT := 'SELECT GOODS_FILTER_RESULT_SEQ.NEXTVAL ROW_ID,' ||
                  I_FILTER_ID ||
                  ' FILTER_ID,C.ITEM_CODE,SYSDATE W_INSERT_DT,SYSDATE W_UPDATE_DT ';
  
    /*判断I_GOODS_LABEL_ID_SET是否为空，如果不为空则执行拼接sql*/
    IF I_GOODS_LABEL_ID_SET IS NOT NULL
    THEN
      /*字符串大写处理*/
      TRAN_SET := UPPER(I_GOODS_LABEL_ID_SET);
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
    
      /*开始拼接SQL语句*/
      STR_SUB_SELECT   := 'SELECT DISTINCT A.ITEM_CODE ';
      STR_SUB_FROM     := 'FROM GOODS_LABEL_LINK_V A ';
      STR_SUB_WHERE    := 'WHERE ' || TRAN_SET;
      STR_SUB_WHERE    := REPLACE(STR_SUB_WHERE,
                                  '%COL_G_LABEL_ID',
                                  'G_LABEL_ID');
      STR_SUB_WHERE    := REPLACE(STR_SUB_WHERE, '%OP_OR', 'OR');
      STR_SUB_WHERE_S1 := SUBSTR(STR_SUB_WHERE,
                                 1,
                                 INSTR(STR_SUB_WHERE, '%OPR_AND_1') - 1);
      STR_SUB_WHERE_S2 := SUBSTR(STR_SUB_WHERE,
                                 INSTR(STR_SUB_WHERE, '%OPR_AND_1'));
      /*顺序替换%OPR_AND_*/
      /*如果标签没有and操作符，则不用替换*/
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
                                        'AND EXISTS (SELECT 1 FROM GOODS_LABEL_LINK_V A' || J ||
                                        ' WHERE A' || J ||
                                        '.ITEM_CODE = A.ITEM_CODE AND ',
                                        1,
                                        1);
        
          STR_AND_SUB := STR_AND_SUB || ') ';
          STR_AND     := STR_AND || STR_AND_SUB;
        END LOOP;
      ELSE
        /*如果标签没有and操作符，则不用替换*/
        STR_AND := STR_SUB_WHERE_S2;
      END IF;
      STR_SUB_WHERE := STR_SUB_WHERE_S1 || STR_AND;
    
      STR_FROM := 'FROM (' || STR_SUB_SELECT || STR_SUB_FROM ||
                  STR_SUB_WHERE || STR_ITEM_WHERE || STR_MATXL_WHERE ||
                  STR_BRAND_WHERE || ') C ';
    
      STR_ALL_SQL := STR_INSERT || STR_SELECT || STR_FROM;
    ELSE
      /*如果I_GOODS_LABEL_ID_SET为空，则返回空*/
      STR_ALL_SQL := '';
    END IF;
    RETURN(STR_ALL_SQL);
  
  END SPLICE_SQL;

  PROCEDURE SYNC_GOODS_LABEL_HEAD(IN_SYNC_DATE_KEY IN NUMBER) IS
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
    SP_NAME          := 'GOODS_FILTER_PKG.SYNC_GOODS_LABEL_HEAD'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'GOODS_LABEL_HEAD'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    /*分析临时表*/
    DBMS_STATS.GATHER_TABLE_STATS('ML', 'GOODS_LABEL_HEAD_TMP');
  
    /*插入到正式表*/
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
  END SYNC_GOODS_LABEL_HEAD;

  PROCEDURE SYNC_GOODS_LABEL_LINK IS
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
    SP_NAME          := 'GOODS_FILTER_PKG.SYNC_GOODS_LABEL_LINK'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'GOODS_LABEL_LINK'; --此处需要手工录入该PROCEDURE操作的表格
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
  
    /*merge into 插入的记录不会被记录到MLOG$_GOODS_LABEL_LINK,所以再重新更新一次*/
    UPDATE GOODS_LABEL_LINK@DW27 A
       SET A.LAST_UPDATE_DATE = A.CREATE_DATE + 1 / 24 / 60 / 60
     WHERE A.CREATE_DATE = A.LAST_UPDATE_DATE
       AND TRUNC(A.CREATE_DATE) >= TRUNC(SYSDATE - 1);
    COMMIT;
  
    /*INSERT_ROWS*/
    SELECT COUNT(1)
      INTO INSERT_ROWS
      FROM MLOG$_GOODS_LABEL_LINK@DW27
     WHERE DMLTYPE$$ = 'I';
  
    /*UPDATE_ROWS*/
    SELECT COUNT(1)
      INTO UPDATE_ROWS
      FROM MLOG$_GOODS_LABEL_LINK@DW27
     WHERE DMLTYPE$$ = 'U';
  
    /*DELETE_ROWS*/
    SELECT COUNT(1)
      INTO DELETE_ROWS
      FROM MLOG$_GOODS_LABEL_LINK@DW27
     WHERE DMLTYPE$$ = 'D';
  
    /*刷新物化视图MEMBER_LABEL_LINK_MV*/
    DBMS_MVIEW.REFRESH('GOODS_LABEL_LINK_MV', METHOD => 'FAST');
  
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
  END SYNC_GOODS_LABEL_LINK;

  PROCEDURE GOODS_RESULT_TO_TABLE IS
    V_TABLE_HEAD GOODS_FILTER_OPTION_HEAD%ROWTYPE;
    V_STR_SQL    VARCHAR2(4000);
  
    /*
       目的:      执行商品筛选操作
       作者:      yangjin
       创建时间:  2017/10/24
    */
  BEGIN
    /*记录执行开始时间*/
    V_TABLE_HEAD.EXECUTION_START_TIME := SYSDATE;
  
    /*获取可运行的最小FILTER_ID*/
    SELECT MIN(A.FILTER_ID)
      INTO V_TABLE_HEAD.FILTER_ID
      FROM GOODS_FILTER_OPTION_HEAD A
     WHERE A.GOODS_LABEL_ID_SET IS NOT NULL /*如果商品标签为空，则不执行*/
       AND A.STATUS = 0;
  
    /*获取到filter_id之后再执行后面的语句*/
    IF V_TABLE_HEAD.FILTER_ID IS NOT NULL
    THEN
      /*修改状态为正在执行*/
      UPDATE GOODS_FILTER_OPTION_HEAD A
         SET A.STATUS = 1
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
      COMMIT;
    
      /*取出商品筛选条件*/
      SELECT A.GOODS_LABEL_ID_SET
        INTO V_TABLE_HEAD.GOODS_LABEL_ID_SET
        FROM GOODS_FILTER_OPTION_HEAD A
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
    
      /*转换成SQL语句*/
      V_STR_SQL := GOODS_FILTER_PKG.SPLICE_SQL(V_TABLE_HEAD.FILTER_ID,
                                               V_TABLE_HEAD.GOODS_LABEL_ID_SET);
    
      /*执行SQL语句*/
      DBMS_OUTPUT.PUT_LINE(V_STR_SQL);
      EXECUTE IMMEDIATE V_STR_SQL;
    
      /*记录插入结果表的行数*/
      SELECT NVL(COUNT(DISTINCT A.ITEM_CODE), 0)
        INTO V_TABLE_HEAD.RESULT_RECORDS
        FROM GOODS_FILTER_RESULT A
       WHERE A.FILTER_ID = V_TABLE_HEAD.FILTER_ID;
    
      /*导出筛选结果的文本文件*/
      GOODS_FILTER_PKG.GOODS_OUTPUT_FILE(V_TABLE_HEAD.FILTER_ID,
                                         V_TABLE_HEAD.OUTPUT_FILE_PATH);
    
      /*记录执行完成时间*/
      V_TABLE_HEAD.EXECUTION_END_TIME := SYSDATE;
    
      /*执行完成写入记录*/
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

  PROCEDURE GOODS_OUTPUT_FILE(I_FILTER_ID        IN NUMBER,
                              O_OUTPUT_FILE_PATH OUT VARCHAR2) IS
    /*
       目的:      商品操作结果导出到文件，路径地址与会员标签筛选的路径一样。
       作者:      yangjin
       创建时间:  2018/05/25
       导出绝对路径：/data/htdocs/pushadmin.happigo.com/Public/download
       导出相对路径：/Public/download
    */
  
    T_HEAD        GOODS_FILTER_OPTION_HEAD%ROWTYPE;
    V_OUTPUT_FILE UTL_FILE.FILE_TYPE;
    V_OUTPUT_DATE VARCHAR2(14);
    V_FILE_NAME   VARCHAR2(50);
  BEGIN
    /*获取导出的行数*/
    SELECT COUNT(DISTINCT A.ITEM_CODE)
      INTO T_HEAD.RESULT_RECORDS
      FROM GOODS_FILTER_RESULT A
     WHERE A.FILTER_ID = I_FILTER_ID;
  
    /*导出时间*/
    SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS')
      INTO V_OUTPUT_DATE
      FROM DUAL;
  
    /*统一文件名称*/
    V_FILE_NAME := 'goods_result_' || I_FILTER_ID || '_' || V_OUTPUT_DATE || '_' ||
                   T_HEAD.RESULT_RECORDS || '.txt';
  
    /*打开文件,和会员筛选系统的路径一致*/
    V_OUTPUT_FILE := UTL_FILE.FOPEN('MEMBER_LABEL_OUTPUT', V_FILE_NAME, 'W');
  
    /*导出文件路径写入返回变量O_OUTPUT_FILE_PATH*/
    O_OUTPUT_FILE_PATH := '/Public/download';
    O_OUTPUT_FILE_PATH := O_OUTPUT_FILE_PATH || '/' || V_FILE_NAME;
    /*写入title*/
    UTL_FILE.PUT_LINE(V_OUTPUT_FILE, 'ROWNUM,FILTER_ID,ITEM_CODE');
  
    /*循环，获取需要导出的数据*/
    FOR I IN (SELECT ROWNUM, B.FILTER_ID, B.ITEM_CODE
                FROM (SELECT A.FILTER_ID, A.ITEM_CODE
                        FROM GOODS_FILTER_RESULT A
                       WHERE A.FILTER_ID = I_FILTER_ID
                       GROUP BY A.FILTER_ID, A.ITEM_CODE
                       ORDER BY A.FILTER_ID, A.ITEM_CODE) B) LOOP
    
      /*行数据依次写入文件*/
      UTL_FILE.PUT_LINE(V_OUTPUT_FILE,
                        I.ROWNUM || ',' || I.FILTER_ID || ',' ||
                        I.ITEM_CODE);
    END LOOP;
  
    /*关闭文件*/
    UTL_FILE.FCLOSE(V_OUTPUT_FILE);
  
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      RETURN;
  END GOODS_OUTPUT_FILE;

  PROCEDURE DEBUG(I_FILTER_ID IN NUMBER) IS
    /*
       目的:      调试
       作者:      yangjin
       创建时间:  2017/10/24
    */
  BEGIN
    /*删除结果表数据*/
    DELETE GOODS_FILTER_RESULT A WHERE A.FILTER_ID = I_FILTER_ID;
    COMMIT;
  
    /*更新head表状态*/
    UPDATE GOODS_FILTER_OPTION_HEAD A
       SET A.STATUS               = 0,
           A.EXECUTION_START_TIME = NULL,
           A.EXECUTION_END_TIME   = NULL,
           A.RESULT_RECORDS       = NULL,
           A.RESULT_MESSAGE       = NULL,
           A.OUTPUT_FILE_PATH     = NULL
     WHERE A.FILTER_ID = I_FILTER_ID
       AND A.GOODS_LABEL_ID_SET IS NOT NULL;
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      RETURN;
  END DEBUG;

END GOODS_FILTER_PKG;
/
