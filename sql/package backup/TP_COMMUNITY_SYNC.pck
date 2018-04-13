CREATE OR REPLACE PACKAGE TP_COMMUNITY_SYNC IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2018-03-23 15:37:17
  -- PURPOSE : 从mysql的weixin_cms数据库抽取数据放在临时表之后，通过此package把临时表数据写入正式表

  PROCEDURE MERGE_TP_COMMUNITY_GROUP;
  /*
  功能名:       MERGE_TP_COMMUNITY_GROUP
  目的:         
  作者:         yangjin
  创建时间：    2018/03/23
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_TP_COMMUNITY_GROUP_LINK;
  /*
  功能名:       MERGE_TP_COMMUNITY_GROUP_LINK
  目的:         
  作者:         yangjin
  创建时间：    2018/03/26
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_TP_COMMUNITY_GROUP_FANS;
  /*
  功能名:       MERGE_TP_COMMUNITY_GROUP_FANS
  目的:         
  作者:         yangjin
  创建时间：    2018/03/26
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_TP_COMMUNITY_GROUP_F_A;
  /*
  功能名:       MERGE_TP_COMMUNITY_GROUP_F_A
  目的:         
  作者:         yangjin
  创建时间：    2018/03/26
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_TP_COMMUNITY_FANS_G_C_L;
  /*
  功能名:       MERGE_TP_COMMUNITY_FANS_G_C_L
  目的:         
  作者:         yangjin
  创建时间：    2018/03/26
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_TP_COMMUNITY_GAME_PLAY_R;
  /*
  功能名:       MERGE_TP_COMMUNITY_GAME_PLAY_R
  目的:         
  作者:         yangjin
  创建时间：    2018/03/26
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_TP_COMMUNITY_GAME_PRIZE;
  /*
  功能名:       MERGE_TP_COMMUNITY_GAME_PRIZE
  目的:         
  作者:         yangjin
  创建时间：    2018/03/26
  最后修改人：
  最后更改日期：
  */

END TP_COMMUNITY_SYNC;
/
CREATE OR REPLACE PACKAGE BODY TP_COMMUNITY_SYNC IS

  PROCEDURE MERGE_TP_COMMUNITY_GROUP IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2018-03-23
    */
  BEGIN
    SP_NAME          := 'TP_COMMUNITY_SYNC.MERGE_TP_COMMUNITY_GROUP'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'TP_COMMUNITY_GROUP'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO TP_COMMUNITY_GROUP T
      USING (SELECT A.GROUP_ID,
                    A.GROUP_NO,
                    A.GROUP_NAME,
                    A.GROUP_ADMIN,
                    A.ADD_TIME,
                    A.TOKEN,
                    A.REMARK,
                    A.CREATE_TIME,
                    SYSDATE       W_INSERT_DT,
                    SYSDATE       W_UPDATE_DT
               FROM TP_COMMUNITY_GROUP_TMP A) S
      ON (T.GROUP_ID = S.GROUP_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.GROUP_NO    = S.GROUP_NO,
               T.GROUP_NAME  = S.GROUP_NAME,
               T.GROUP_ADMIN = S.GROUP_ADMIN,
               T.ADD_TIME    = S.ADD_TIME,
               T.TOKEN       = S.TOKEN,
               T.REMARK      = S.REMARK,
               T.CREATE_TIME = S.CREATE_TIME,
               T.W_UPDATE_DT = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.GROUP_ID,
           T.GROUP_NO,
           T.GROUP_NAME,
           T.GROUP_ADMIN,
           T.ADD_TIME,
           T.TOKEN,
           T.REMARK,
           T.CREATE_TIME,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.GROUP_ID,
           S.GROUP_NO,
           S.GROUP_NAME,
           S.GROUP_ADMIN,
           S.ADD_TIME,
           S.TOKEN,
           S.REMARK,
           S.CREATE_TIME,
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
  END MERGE_TP_COMMUNITY_GROUP;

  PROCEDURE MERGE_TP_COMMUNITY_GROUP_LINK IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2018-03-23
    */
  BEGIN
    SP_NAME          := 'TP_COMMUNITY_SYNC.MERGE_TP_COMMUNITY_GROUP_LINK'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'TP_COMMUNITY_GROUP_LINK'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO TP_COMMUNITY_GROUP_LINK T
      USING (SELECT A.LINK_ID,
                    A.GROUP_ID,
                    A.GROUP_NO,
                    A.SIGN,
                    A.LINK_EXPIRE_TIME,
                    A.ADMIN_USER,
                    A.ADD_TIME,
                    A.TOKEN,
                    SYSDATE            W_INSERT_DT,
                    SYSDATE            W_UPDATE_DT
               FROM TP_COMMUNITY_GROUP_LINK_TMP A) S
      ON (T.LINK_ID = S.LINK_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.GROUP_ID         = S.GROUP_ID,
               T.GROUP_NO         = S.GROUP_NO,
               T.SIGN             = S.SIGN,
               T.LINK_EXPIRE_TIME = S.LINK_EXPIRE_TIME,
               T.ADMIN_USER       = S.ADMIN_USER,
               T.ADD_TIME         = S.ADD_TIME,
               T.TOKEN            = S.TOKEN,
               T.W_UPDATE_DT      = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.LINK_ID,
           T.GROUP_ID,
           T.GROUP_NO,
           T.SIGN,
           T.LINK_EXPIRE_TIME,
           T.ADMIN_USER,
           T.ADD_TIME,
           T.TOKEN,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.LINK_ID,
           S.GROUP_ID,
           S.GROUP_NO,
           S.SIGN,
           S.LINK_EXPIRE_TIME,
           S.ADMIN_USER,
           S.ADD_TIME,
           S.TOKEN,
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
  END MERGE_TP_COMMUNITY_GROUP_LINK;

  PROCEDURE MERGE_TP_COMMUNITY_GROUP_FANS IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2018-03-23
    */
  BEGIN
    SP_NAME          := 'TP_COMMUNITY_SYNC.MERGE_TP_COMMUNITY_GROUP_FANS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'TP_COMMUNITY_GROUP_FANS'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO TP_COMMUNITY_GROUP_FANS T
      USING (SELECT A.FANS_ID,
                    A.GROUP_ID,
                    A.NICKNAME,
                    A.FANS_IMG,
                    A.FANS_IP,
                    A.EC_CUST_NO,
                    A.OPENID,
                    A.VID,
                    A.EC_MEMBER_ID,
                    A.EC_MEMBER_NAME,
                    A.AUDIT_USER,
                    A.REMARK,
                    A.IS_VALID,
                    A.UPDATE_TIME,
                    A.ADD_TIME,
                    A.TOKEN,
                    SYSDATE          W_INSERT_DT,
                    SYSDATE          W_UPDATE_DT
               FROM TP_COMMUNITY_GROUP_FANS_TMP A) S
      ON (T.FANS_ID = S.FANS_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.GROUP_ID       = S.GROUP_ID,
               T.NICKNAME       = S.NICKNAME,
               T.FANS_IMG       = S.FANS_IMG,
               T.FANS_IP        = S.FANS_IP,
               T.EC_CUST_NO     = S.EC_CUST_NO,
               T.OPENID         = S.OPENID,
               T.VID            = S.VID,
               T.EC_MEMBER_ID   = S.EC_MEMBER_ID,
               T.EC_MEMBER_NAME = S.EC_MEMBER_NAME,
               T.AUDIT_USER     = S.AUDIT_USER,
               T.REMARK         = S.REMARK,
               T.IS_VALID       = S.IS_VALID,
               T.UPDATE_TIME    = S.UPDATE_TIME,
               T.ADD_TIME       = S.ADD_TIME,
               T.TOKEN          = S.TOKEN,
               T.W_UPDATE_DT    = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.FANS_ID,
           T.GROUP_ID,
           T.NICKNAME,
           T.FANS_IMG,
           T.FANS_IP,
           T.EC_CUST_NO,
           T.OPENID,
           T.VID,
           T.EC_MEMBER_ID,
           T.EC_MEMBER_NAME,
           T.AUDIT_USER,
           T.REMARK,
           T.IS_VALID,
           T.UPDATE_TIME,
           T.ADD_TIME,
           T.TOKEN,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.FANS_ID,
           S.GROUP_ID,
           S.NICKNAME,
           S.FANS_IMG,
           S.FANS_IP,
           S.EC_CUST_NO,
           S.OPENID,
           S.VID,
           S.EC_MEMBER_ID,
           S.EC_MEMBER_NAME,
           S.AUDIT_USER,
           S.REMARK,
           S.IS_VALID,
           S.UPDATE_TIME,
           S.ADD_TIME,
           S.TOKEN,
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
  END MERGE_TP_COMMUNITY_GROUP_FANS;

  PROCEDURE MERGE_TP_COMMUNITY_GROUP_F_A IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2018-03-23
    */
  BEGIN
    SP_NAME          := 'TP_COMMUNITY_SYNC.MERGE_TP_COMMUNITY_GROUP_F_A'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'TP_COMMUNITY_GROUP_FANS_A'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO TP_COMMUNITY_GROUP_FANS_A T
      USING (SELECT A.APPLY_ID,
                    A.GROUP_ID,
                    A.NICKNAME,
                    A.FANS_IMG,
                    A.FANS_IP,
                    A.EC_CUST_NO,
                    A.OPENID,
                    A.VID,
                    A.EC_MEMBER_ID,
                    A.EC_MEMBER_NAME,
                    A.AUDIT_STATUS,
                    A.AUDIT_USER,
                    A.AUDIT_REMARK,
                    A.AUDIT_TIME,
                    A.ADD_TIME,
                    A.TOKEN,
                    SYSDATE          W_INSERT_DT,
                    SYSDATE          W_UPDATE_DT
               FROM TP_COMMUNITY_GROUP_FANS_A_TMP A) S
      ON (T.APPLY_ID = S.APPLY_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.GROUP_ID       = S.GROUP_ID,
               T.NICKNAME       = S.NICKNAME,
               T.FANS_IMG       = S.FANS_IMG,
               T.FANS_IP        = S.FANS_IP,
               T.EC_CUST_NO     = S.EC_CUST_NO,
               T.OPENID         = S.OPENID,
               T.VID            = S.VID,
               T.EC_MEMBER_ID   = S.EC_MEMBER_ID,
               T.EC_MEMBER_NAME = S.EC_MEMBER_NAME,
               T.AUDIT_STATUS   = S.AUDIT_STATUS,
               T.AUDIT_USER     = S.AUDIT_USER,
               T.AUDIT_REMARK   = S.AUDIT_REMARK,
               T.AUDIT_TIME     = S.AUDIT_TIME,
               T.ADD_TIME       = S.ADD_TIME,
               T.TOKEN          = S.TOKEN,
               T.W_UPDATE_DT    = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.APPLY_ID,
           T.GROUP_ID,
           T.NICKNAME,
           T.FANS_IMG,
           T.FANS_IP,
           T.EC_CUST_NO,
           T.OPENID,
           T.VID,
           T.EC_MEMBER_ID,
           T.EC_MEMBER_NAME,
           T.AUDIT_STATUS,
           T.AUDIT_USER,
           T.AUDIT_REMARK,
           T.AUDIT_TIME,
           T.ADD_TIME,
           T.TOKEN,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.APPLY_ID,
           S.GROUP_ID,
           S.NICKNAME,
           S.FANS_IMG,
           S.FANS_IP,
           S.EC_CUST_NO,
           S.OPENID,
           S.VID,
           S.EC_MEMBER_ID,
           S.EC_MEMBER_NAME,
           S.AUDIT_STATUS,
           S.AUDIT_USER,
           S.AUDIT_REMARK,
           S.AUDIT_TIME,
           S.ADD_TIME,
           S.TOKEN,
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
  END MERGE_TP_COMMUNITY_GROUP_F_A;

  PROCEDURE MERGE_TP_COMMUNITY_FANS_G_C_L IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2018-03-23
    */
  BEGIN
    SP_NAME          := 'TP_COMMUNITY_SYNC.MERGE_TP_COMMUNITY_FANS_G_C_L'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'TP_COMMUNITY_FANS_G_C_L'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO TP_COMMUNITY_FANS_G_C_L T
      USING (SELECT A.LOG_ID,
                    A.FANS_ID,
                    A.OLD_GROUP_ID,
                    A.GROUP_ID,
                    A.REMARK,
                    A.ADMIN_USER,
                    A.ADD_TIME,
                    A.TOKEN,
                    SYSDATE        W_INSERT_DT,
                    SYSDATE        W_UPDATE_DT
               FROM TP_COMMUNITY_FANS_G_C_L_TMP A) S
      ON (T.LOG_ID = S.LOG_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.FANS_ID      = S.FANS_ID,
               T.OLD_GROUP_ID = S.OLD_GROUP_ID,
               T.GROUP_ID     = S.GROUP_ID,
               T.REMARK       = S.REMARK,
               T.ADMIN_USER   = S.ADMIN_USER,
               T.ADD_TIME     = S.ADD_TIME,
               T.TOKEN        = S.TOKEN,
               T.W_UPDATE_DT  = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.LOG_ID,
           T.FANS_ID,
           T.OLD_GROUP_ID,
           T.GROUP_ID,
           T.REMARK,
           T.ADMIN_USER,
           T.ADD_TIME,
           T.TOKEN,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.LOG_ID,
           S.FANS_ID,
           S.OLD_GROUP_ID,
           S.GROUP_ID,
           S.REMARK,
           S.ADMIN_USER,
           S.ADD_TIME,
           S.TOKEN,
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
  END MERGE_TP_COMMUNITY_FANS_G_C_L;

  PROCEDURE MERGE_TP_COMMUNITY_GAME_PLAY_R IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2018-03-23
    */
  BEGIN
    SP_NAME          := 'TP_COMMUNITY_SYNC.MERGE_TP_COMMUNITY_GAME_PLAY_R'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'TP_COMMUNITY_GAME_PLAY_R'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO TP_COMMUNITY_GAME_PLAY_R T
      USING (SELECT A.ID,
                    A.GAMEID,
                    A.GROUP_ID,
                    A.OPENID,
                    A.IP,
                    A.MEMBER_CRMBP,
                    A.MEMBERDISPLAYNAME,
                    A.PRIZEID,
                    A.PRIZENAME,
                    A.PRIZETYPE,
                    A.POINTSREWARD,
                    A.VOUCHERCODEREWARD,
                    A.DELIVERY_NAME,
                    A.DELIVERY_PHONENUMBER,
                    A.DELIVERY_ADDRESS,
                    A.PUT_STATUS,
                    A.AUDIT_STATUS,
                    A.AUDIT_ADMIN,
                    A.AUDIT_TIME,
                    A.REMARK,
                    A.CREATETIME,
                    SYSDATE                W_INSERT_DT,
                    SYSDATE                W_UPDATE_DT
               FROM TP_COMMUNITY_GAME_PLAY_R_TMP A) S
      ON (T.ID = S.ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.GAMEID               = S.GAMEID,
               T.GROUP_ID             = S.GROUP_ID,
               T.OPENID               = S.OPENID,
               T.IP                   = S.IP,
               T.MEMBER_CRMBP         = S.MEMBER_CRMBP,
               T.MEMBERDISPLAYNAME    = S.MEMBERDISPLAYNAME,
               T.PRIZEID              = S.PRIZEID,
               T.PRIZENAME            = S.PRIZENAME,
               T.PRIZETYPE            = S.PRIZETYPE,
               T.POINTSREWARD         = S.POINTSREWARD,
               T.VOUCHERCODEREWARD    = S.VOUCHERCODEREWARD,
               T.DELIVERY_NAME        = S.DELIVERY_NAME,
               T.DELIVERY_PHONENUMBER = S.DELIVERY_PHONENUMBER,
               T.DELIVERY_ADDRESS     = S.DELIVERY_ADDRESS,
               T.PUT_STATUS           = S.PUT_STATUS,
               T.AUDIT_STATUS         = S.AUDIT_STATUS,
               T.AUDIT_ADMIN          = S.AUDIT_ADMIN,
               T.AUDIT_TIME           = S.AUDIT_TIME,
               T.REMARK               = S.REMARK,
               T.CREATETIME           = S.CREATETIME,
               T.W_UPDATE_DT          = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID,
           T.GAMEID,
           T.GROUP_ID,
           T.OPENID,
           T.IP,
           T.MEMBER_CRMBP,
           T.MEMBERDISPLAYNAME,
           T.PRIZEID,
           T.PRIZENAME,
           T.PRIZETYPE,
           T.POINTSREWARD,
           T.VOUCHERCODEREWARD,
           T.DELIVERY_NAME,
           T.DELIVERY_PHONENUMBER,
           T.DELIVERY_ADDRESS,
           T.PUT_STATUS,
           T.AUDIT_STATUS,
           T.AUDIT_ADMIN,
           T.AUDIT_TIME,
           T.REMARK,
           T.CREATETIME,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID,
           S.GAMEID,
           S.GROUP_ID,
           S.OPENID,
           S.IP,
           S.MEMBER_CRMBP,
           S.MEMBERDISPLAYNAME,
           S.PRIZEID,
           S.PRIZENAME,
           S.PRIZETYPE,
           S.POINTSREWARD,
           S.VOUCHERCODEREWARD,
           S.DELIVERY_NAME,
           S.DELIVERY_PHONENUMBER,
           S.DELIVERY_ADDRESS,
           S.PUT_STATUS,
           S.AUDIT_STATUS,
           S.AUDIT_ADMIN,
           S.AUDIT_TIME,
           S.REMARK,
           S.CREATETIME,
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
  END MERGE_TP_COMMUNITY_GAME_PLAY_R;

  PROCEDURE MERGE_TP_COMMUNITY_GAME_PRIZE IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2018-03-23
    */
  BEGIN
    SP_NAME          := 'TP_COMMUNITY_SYNC.MERGE_TP_COMMUNITY_GAME_PRIZE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'TP_COMMUNITY_GAME_PRIZE_S'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO TP_COMMUNITY_GAME_PRIZE_S T
      USING (SELECT A.ID,
                    A.GAMEID,
                    A.PROBABILITY,
                    A.PRIZENAME,
                    A.REWARDMESSAGE,
                    A.PRIZETYPE,
                    A.POINTSREWARD,
                    A.VOUCHERID,
                    A.VOUCHERSEND_KEY,
                    A.CREATETIME,
                    A.PRIZENUM,
                    A.IMGURL,
                    A.IS_DEL,
                    A.POSITION,
                    SYSDATE           W_INSERT_DT,
                    SYSDATE           W_UPDATE_DT
               FROM TP_COMMUNITY_GAME_PRIZE_STMP A) S
      ON (T.ID = S.ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.GAMEID          = S.GAMEID,
               T.PROBABILITY     = S.PROBABILITY,
               T.PRIZENAME       = S.PRIZENAME,
               T.REWARDMESSAGE   = S.REWARDMESSAGE,
               T.PRIZETYPE       = S.PRIZETYPE,
               T.POINTSREWARD    = S.POINTSREWARD,
               T.VOUCHERID       = S.VOUCHERID,
               T.VOUCHERSEND_KEY = S.VOUCHERSEND_KEY,
               T.CREATETIME      = S.CREATETIME,
               T.PRIZENUM        = S.PRIZENUM,
               T.IMGURL          = S.IMGURL,
               T.IS_DEL          = S.IS_DEL,
               T.POSITION        = S.POSITION,
               T.W_UPDATE_DT     = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID,
           T.GAMEID,
           T.PROBABILITY,
           T.PRIZENAME,
           T.REWARDMESSAGE,
           T.PRIZETYPE,
           T.POINTSREWARD,
           T.VOUCHERID,
           T.VOUCHERSEND_KEY,
           T.CREATETIME,
           T.PRIZENUM,
           T.IMGURL,
           T.IS_DEL,
           T.POSITION,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID,
           S.GAMEID,
           S.PROBABILITY,
           S.PRIZENAME,
           S.REWARDMESSAGE,
           S.PRIZETYPE,
           S.POINTSREWARD,
           S.VOUCHERID,
           S.VOUCHERSEND_KEY,
           S.CREATETIME,
           S.PRIZENUM,
           S.IMGURL,
           S.IS_DEL,
           S.POSITION,
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
  END MERGE_TP_COMMUNITY_GAME_PRIZE;

END TP_COMMUNITY_SYNC;
/
