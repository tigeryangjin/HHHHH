CREATE OR REPLACE PACKAGE HAPPIGO_EC_PKG IS

  -- AUTHOR  : YANGJIN
  -- CREATED : 2017-09-14 15:53:17
  -- PURPOSE : 从mysql的happigo_ec数据库抽取数据放在临时表之后，通过此package把临时表数据写入正式表

  PROCEDURE MERGE_EC_TOP_LEVEL;
  /*
  功能名:       MERGE_EC_TOP_LEVEL
  目的:         
  作者:         yangjin
  创建时间：    2017/12/04
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_ORDER;
  /*
  功能名:       MERGE_EC_ORDER
  目的:         
  作者:         yangjin
  创建时间：    2017/09/14
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_ORDER_GOODS;
  /*
  功能名:       MERGE_EC_ORDER_GOODS
  目的:         
  作者:         yangjin
  创建时间：    2017/09/14
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_ORDER_COMMON;
  /*
  功能名:       MERGE_EC_ORDER_COMMON
  目的:         
  作者:         yangjin
  创建时间：    2017/09/14
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_P_XIANSHI;
  /*
  功能名:       MERGE_EC_P_XIANSHI
  目的:         
  作者:         yangjin
  创建时间：    2017/09/14
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_P_XIANSHI_GOODS;
  /*
  功能名:       MERGE_EC_P_XIANSHI_GOODS
  目的:         
  作者:         yangjin
  创建时间：    2017/09/14
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_P_MANSONG;
  /*
  功能名:       MERGE_EC_P_MANSONG
  目的:         
  作者:         yangjin
  创建时间：    2017/09/14
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_P_MANSONG_GOODS;
  /*
  功能名:       MERGE_EC_P_MANSONG_GOODS
  目的:         
  作者:         yangjin
  创建时间：    2017/09/14
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_VOUCHER;
  /*
  功能名:       MERGE_EC_VOUCHER
  目的:         
  作者:         yangjin
  创建时间：    2017/09/14
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_VOUCHER_BATCH;
  /*
  功能名:       MERGE_EC_VOUCHER_BATCH
  目的:         
  作者:         yangjin
  创建时间：    2017/09/14
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_VOUCHER_PRICE;
  /*
  功能名:       MERGE_EC_VOUCHER_PRICE
  目的:         
  作者:         yangjin
  创建时间：    2017/09/14
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_GOODS_COMMON;
  /*
  功能名:       MERGE_EC_GOODS_COMMON
  目的:         
  作者:         yangjin
  创建时间：    2018/01/11
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_GOODS_MANUAL;
  /*
  功能名:       MERGE_EC_GOODS_MANUAL
  目的:         
  作者:         yangjin
  创建时间：    2018/01/31
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_EC_GOODS_CLASS_SUB;
  /*
  功能名:       MERGE_EC_GOODS_CLASS_SUB
  目的:         
  作者:         yangjin
  创建时间：    2018/03/23
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_G_ACTIVITY;
  /*
  功能名:       MERGE_G_ACTIVITY
  目的:         
  作者:         yangjin
  创建时间：    2018/05/11
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_G_ACTIVITY_GOODS;
  /*
  功能名:       MERGE_G_ACTIVITY_GOODS
  目的:         
  作者:         yangjin
  创建时间：    2018/05/11
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_G_ACTIVITY_GOODS_GROUP;
  /*
  功能名:       MERGE_G_ACTIVITY_GOODS_GROUP
  目的:         
  作者:         yangjin
  创建时间：    2018/05/11
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_G_ACTIVITY_VOUCHER;
  /*
  功能名:       MERGE_G_ACTIVITY_VOUCHER
  目的:         
  作者:         yangjin
  创建时间：    2018/05/11
  最后修改人：
  最后更改日期：
  */

  PROCEDURE MERGE_GOODS_EVALUATE_ALIYUN;
  /*
  功能名:       MERGE_GOODS_EVALUATE_ALIYUN
  目的:         
  作者:         yangjin
  创建时间：    2018/05/14
  最后修改人：
  最后更改日期：
  */

END HAPPIGO_EC_PKG;
/
CREATE OR REPLACE PACKAGE BODY HAPPIGO_EC_PKG IS

  PROCEDURE MERGE_EC_TOP_LEVEL IS
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    BEGIN
      -- CALL THE PROCEDURE
      HAPPIGO_EC_PKG.MERGE_EC_ORDER;
      HAPPIGO_EC_PKG.MERGE_EC_ORDER_GOODS;
      HAPPIGO_EC_PKG.MERGE_EC_ORDER_COMMON;
      HAPPIGO_EC_PKG.MERGE_EC_P_XIANSHI;
      HAPPIGO_EC_PKG.MERGE_EC_P_XIANSHI_GOODS;
      HAPPIGO_EC_PKG.MERGE_EC_P_MANSONG;
      HAPPIGO_EC_PKG.MERGE_EC_P_MANSONG_GOODS;
      HAPPIGO_EC_PKG.MERGE_EC_VOUCHER;
      HAPPIGO_EC_PKG.MERGE_EC_VOUCHER_BATCH;
      HAPPIGO_EC_PKG.MERGE_EC_VOUCHER_PRICE;
    END;
  END MERGE_EC_TOP_LEVEL;

  PROCEDURE MERGE_EC_ORDER IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_ORDER'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_ORDER_2'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_ORDER_2 T
      USING (SELECT A.ORDER_ID,
                    A.ORDER_SN,
                    A.PAY_SN,
                    A.STORE_ID,
                    A.STORE_NAME,
                    A.CUST_NO,
                    A.MEMBER_LEVEL,
                    A.BUYER_ID,
                    A.BUYER_NAME,
                    A.BUYER_EMAIL,
                    A.ADD_TIME,
                    A.PAYMENT_CODE,
                    A.PAYMENT_TIME,
                    A.FINNSHED_TIME,
                    A.GOODS_AMOUNT,
                    A.ORDER_AMOUNT,
                    A.RCB_AMOUNT,
                    A.PD_AMOUNT,
                    A.SHIPPING_FEE,
                    A.EVALUATION_STATE,
                    A.ORDER_STATE,
                    A.VBELN_NO,
                    A.REFUND_STATE,
                    A.LOCK_STATE,
                    A.DELETE_STATE,
                    A.REFUND_AMOUNT,
                    A.DELAY_TIME,
                    A.CPS_U_ID,
                    A.ORDER_FROM,
                    A.SHIPPING_TYPE,
                    A.SHIPPING_NAME,
                    A.SHIPPING_CODE,
                    A.APP_NAME,
                    A.VID,
                    A.EXPIRE_TIME,
                    A.ERP_ORDER_NO,
                    A.CRM_ORDER_NO,
                    A.ERP_ORDER_TIME,
                    A.ERP_LOG,
                    A.ERP_ORDER_FAIL,
                    A.AUDIT_STATUS,
                    A.AUDIT_TIMES,
                    A.AUDIT_REMARK,
                    A.AUDIT_ADMIN_ID,
                    A.ORDER_IP,
                    A.INTEGRALS_AMOUNT,
                    A.INTEGRALS_SUM,
                    A.DISCOUNT_MANSONG_ID,
                    A.DISCOUNT_MANSONG_AMOUNT,
                    A.DISCOUNT_PAYMENTWAY_AMOUNT,
                    A.DISCOUNT_PAYMENTWAY_DESC,
                    A.DISCOUNT_PAYMENTCHANEL_AMOUNT,
                    A.DISCOUNT_PAYMENTCHANEL_DESC,
                    A.PAYMENTCHANNEL,
                    A.FOLLOW_UP_TIME,
                    A.TUOTOU_MEMBERID,
                    A.RESERVATION_DELIVERY_AT,
                    A.ORDER_TYPE,
                    A.ORDER_OTHER_ID,
                    SYSDATE                         W_INSERT_DT,
                    SYSDATE                         W_UPDATE_DT
               FROM EC_ORDER_2_TMP A) S
      ON (T.ORDER_ID = S.ORDER_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.ORDER_SN                      = S.ORDER_SN,
               T.PAY_SN                        = S.PAY_SN,
               T.STORE_ID                      = S.STORE_ID,
               T.STORE_NAME                    = S.STORE_NAME,
               T.CUST_NO                       = S.CUST_NO,
               T.MEMBER_LEVEL                  = S.MEMBER_LEVEL,
               T.BUYER_ID                      = S.BUYER_ID,
               T.BUYER_NAME                    = S.BUYER_NAME,
               T.BUYER_EMAIL                   = S.BUYER_EMAIL,
               T.ADD_TIME                      = S.ADD_TIME,
               T.PAYMENT_CODE                  = S.PAYMENT_CODE,
               T.PAYMENT_TIME                  = S.PAYMENT_TIME,
               T.FINNSHED_TIME                 = S.FINNSHED_TIME,
               T.GOODS_AMOUNT                  = S.GOODS_AMOUNT,
               T.ORDER_AMOUNT                  = S.ORDER_AMOUNT,
               T.RCB_AMOUNT                    = S.RCB_AMOUNT,
               T.PD_AMOUNT                     = S.PD_AMOUNT,
               T.SHIPPING_FEE                  = S.SHIPPING_FEE,
               T.EVALUATION_STATE              = S.EVALUATION_STATE,
               T.ORDER_STATE                   = S.ORDER_STATE,
               T.VBELN_NO                      = S.VBELN_NO,
               T.REFUND_STATE                  = S.REFUND_STATE,
               T.LOCK_STATE                    = S.LOCK_STATE,
               T.DELETE_STATE                  = S.DELETE_STATE,
               T.REFUND_AMOUNT                 = S.REFUND_AMOUNT,
               T.DELAY_TIME                    = S.DELAY_TIME,
               T.CPS_U_ID                      = S.CPS_U_ID,
               T.ORDER_FROM                    = S.ORDER_FROM,
               T.SHIPPING_TYPE                 = S.SHIPPING_TYPE,
               T.SHIPPING_NAME                 = S.SHIPPING_NAME,
               T.SHIPPING_CODE                 = S.SHIPPING_CODE,
               T.APP_NAME                      = S.APP_NAME,
               T.VID                           = S.VID,
               T.EXPIRE_TIME                   = S.EXPIRE_TIME,
               T.ERP_ORDER_NO                  = S.ERP_ORDER_NO,
               T.CRM_ORDER_NO                  = S.CRM_ORDER_NO,
               T.ERP_ORDER_TIME                = S.ERP_ORDER_TIME,
               T.ERP_LOG                       = S.ERP_LOG,
               T.ERP_ORDER_FAIL                = S.ERP_ORDER_FAIL,
               T.AUDIT_STATUS                  = S.AUDIT_STATUS,
               T.AUDIT_TIMES                   = S.AUDIT_TIMES,
               T.AUDIT_REMARK                  = S.AUDIT_REMARK,
               T.AUDIT_ADMIN_ID                = S.AUDIT_ADMIN_ID,
               T.ORDER_IP                      = S.ORDER_IP,
               T.INTEGRALS_AMOUNT              = S.INTEGRALS_AMOUNT,
               T.INTEGRALS_SUM                 = S.INTEGRALS_SUM,
               T.DISCOUNT_MANSONG_ID           = S.DISCOUNT_MANSONG_ID,
               T.DISCOUNT_MANSONG_AMOUNT       = S.DISCOUNT_MANSONG_AMOUNT,
               T.DISCOUNT_PAYMENTWAY_AMOUNT    = S.DISCOUNT_PAYMENTWAY_AMOUNT,
               T.DISCOUNT_PAYMENTWAY_DESC      = S.DISCOUNT_PAYMENTWAY_DESC,
               T.DISCOUNT_PAYMENTCHANEL_AMOUNT = S.DISCOUNT_PAYMENTCHANEL_AMOUNT,
               T.DISCOUNT_PAYMENTCHANEL_DESC   = S.DISCOUNT_PAYMENTCHANEL_DESC,
               T.PAYMENTCHANNEL                = S.PAYMENTCHANNEL,
               T.FOLLOW_UP_TIME                = S.FOLLOW_UP_TIME,
               T.TUOTOU_MEMBERID               = S.TUOTOU_MEMBERID,
               T.RESERVATION_DELIVERY_AT       = S.RESERVATION_DELIVERY_AT,
               T.ORDER_TYPE                    = S.ORDER_TYPE,
               T.ORDER_OTHER_ID                = S.ORDER_OTHER_ID,
               T.W_UPDATE_DT                   = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ORDER_ID,
           T.ORDER_SN,
           T.PAY_SN,
           T.STORE_ID,
           T.STORE_NAME,
           T.CUST_NO,
           T.MEMBER_LEVEL,
           T.BUYER_ID,
           T.BUYER_NAME,
           T.BUYER_EMAIL,
           T.ADD_TIME,
           T.PAYMENT_CODE,
           T.PAYMENT_TIME,
           T.FINNSHED_TIME,
           T.GOODS_AMOUNT,
           T.ORDER_AMOUNT,
           T.RCB_AMOUNT,
           T.PD_AMOUNT,
           T.SHIPPING_FEE,
           T.EVALUATION_STATE,
           T.ORDER_STATE,
           T.VBELN_NO,
           T.REFUND_STATE,
           T.LOCK_STATE,
           T.DELETE_STATE,
           T.REFUND_AMOUNT,
           T.DELAY_TIME,
           T.CPS_U_ID,
           T.ORDER_FROM,
           T.SHIPPING_TYPE,
           T.SHIPPING_NAME,
           T.SHIPPING_CODE,
           T.APP_NAME,
           T.VID,
           T.EXPIRE_TIME,
           T.ERP_ORDER_NO,
           T.CRM_ORDER_NO,
           T.ERP_ORDER_TIME,
           T.ERP_LOG,
           T.ERP_ORDER_FAIL,
           T.AUDIT_STATUS,
           T.AUDIT_TIMES,
           T.AUDIT_REMARK,
           T.AUDIT_ADMIN_ID,
           T.ORDER_IP,
           T.INTEGRALS_AMOUNT,
           T.INTEGRALS_SUM,
           T.DISCOUNT_MANSONG_ID,
           T.DISCOUNT_MANSONG_AMOUNT,
           T.DISCOUNT_PAYMENTWAY_AMOUNT,
           T.DISCOUNT_PAYMENTWAY_DESC,
           T.DISCOUNT_PAYMENTCHANEL_AMOUNT,
           T.DISCOUNT_PAYMENTCHANEL_DESC,
           T.PAYMENTCHANNEL,
           T.FOLLOW_UP_TIME,
           T.TUOTOU_MEMBERID,
           T.RESERVATION_DELIVERY_AT,
           T.ORDER_TYPE,
           T.ORDER_OTHER_ID,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ORDER_ID,
           S.ORDER_SN,
           S.PAY_SN,
           S.STORE_ID,
           S.STORE_NAME,
           S.CUST_NO,
           S.MEMBER_LEVEL,
           S.BUYER_ID,
           S.BUYER_NAME,
           S.BUYER_EMAIL,
           S.ADD_TIME,
           S.PAYMENT_CODE,
           S.PAYMENT_TIME,
           S.FINNSHED_TIME,
           S.GOODS_AMOUNT,
           S.ORDER_AMOUNT,
           S.RCB_AMOUNT,
           S.PD_AMOUNT,
           S.SHIPPING_FEE,
           S.EVALUATION_STATE,
           S.ORDER_STATE,
           S.VBELN_NO,
           S.REFUND_STATE,
           S.LOCK_STATE,
           S.DELETE_STATE,
           S.REFUND_AMOUNT,
           S.DELAY_TIME,
           S.CPS_U_ID,
           S.ORDER_FROM,
           S.SHIPPING_TYPE,
           S.SHIPPING_NAME,
           S.SHIPPING_CODE,
           S.APP_NAME,
           S.VID,
           S.EXPIRE_TIME,
           S.ERP_ORDER_NO,
           S.CRM_ORDER_NO,
           S.ERP_ORDER_TIME,
           S.ERP_LOG,
           S.ERP_ORDER_FAIL,
           S.AUDIT_STATUS,
           S.AUDIT_TIMES,
           S.AUDIT_REMARK,
           S.AUDIT_ADMIN_ID,
           S.ORDER_IP,
           S.INTEGRALS_AMOUNT,
           S.INTEGRALS_SUM,
           S.DISCOUNT_MANSONG_ID,
           S.DISCOUNT_MANSONG_AMOUNT,
           S.DISCOUNT_PAYMENTWAY_AMOUNT,
           S.DISCOUNT_PAYMENTWAY_DESC,
           S.DISCOUNT_PAYMENTCHANEL_AMOUNT,
           S.DISCOUNT_PAYMENTCHANEL_DESC,
           S.PAYMENTCHANNEL,
           S.FOLLOW_UP_TIME,
           S.TUOTOU_MEMBERID,
           S.RESERVATION_DELIVERY_AT,
           S.ORDER_TYPE,
           S.ORDER_OTHER_ID,
           S.W_INSERT_DT,
           S.W_UPDATE_DT);
      INSERT_ROWS := SQL%ROWCOUNT;
      COMMIT;
    
      /*更新FACTEC_ORDER的order_state列 yangjin 2017-11-21
      10.10.204.27 factecordertime.sh每5分钟执行一次，但是只更新最近6分钟的订单
      */
      UPDATE FACTEC_ORDER A
         SET A.ORDER_STATE =
             (SELECT B.ORDER_STATE
                FROM FACT_EC_ORDER_2 B
               WHERE A.ORDER_ID = B.ORDER_ID
                 AND A.ORDER_STATE <> B.ORDER_STATE)
       WHERE EXISTS (SELECT 1
                FROM FACT_EC_ORDER_2 C
               WHERE A.ORDER_ID = C.ORDER_ID
                 AND A.ORDER_STATE <> C.ORDER_STATE);
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
  END MERGE_EC_ORDER;

  PROCEDURE MERGE_EC_ORDER_GOODS IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_ORDER_GOODS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_ORDER_GOODS'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_ORDER_GOODS T
      USING (SELECT A.REC_ID,
                    A.ORDER_ID,
                    A.GOODS_ID,
                    A.GOODS_COMMONID,
                    A.ERP_CODE,
                    A.SUPPLIER_ID,
                    A.GOODS_NAME,
                    A.GOODS_PRICE,
                    A.APPORTION_PRICE,
                    A.GOODS_NUM,
                    A.RETURN_STATE,
                    A.RETURN_TIME,
                    A.GOODS_IMAGE,
                    A.GOODS_MARKETPRICE,
                    A.GOODS_PAY_PRICE,
                    A.TV_DISCOUNT_AMOUNT,
                    A.STORE_ID,
                    A.BUYER_ID,
                    A.GOODS_TYPE,
                    A.PROMOTIONS_ID,
                    A.XIANSHI_GOODS_ID,
                    A.CPS_COMMISSION,
                    A.COMMIS_RATE,
                    A.GC_ID,
                    A.EXTRA_POINT,
                    A.PML_TITLE,
                    A.PML_ID,
                    A.PML_DISCOUNT,
                    A.THIRD_SKUID,
                    A.THIRD_ORDERID,
                    A.WANGYI_PACKAGE,
                    A.HM_PACKAGE,
                    A.PACKAGE_PROCESS,
                    A.PACKAGE_STATUS,
                    A.PACKAGE_INFO,
                    A.PACKAGE_ERROR,
                    A.JOININ_COMMIS_RATE,
                    SYSDATE              W_INSERT_DT,
                    SYSDATE              W_UPDATE_DT
               FROM EC_ORDER_GOODS_TMP A) S
      ON (T.REC_ID = S.REC_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.ORDER_ID           = S.ORDER_ID,
               T.GOODS_ID           = S.GOODS_ID,
               T.GOODS_COMMONID     = S.GOODS_COMMONID,
               T.ERP_CODE           = S.ERP_CODE,
               T.SUPPLIER_ID        = S.SUPPLIER_ID,
               T.GOODS_NAME         = S.GOODS_NAME,
               T.GOODS_PRICE        = S.GOODS_PRICE,
               T.APPORTION_PRICE    = S.APPORTION_PRICE,
               T.GOODS_NUM          = S.GOODS_NUM,
               T.RETURN_STATE       = S.RETURN_STATE,
               T.RETURN_TIME        = S.RETURN_TIME,
               T.GOODS_IMAGE        = S.GOODS_IMAGE,
               T.GOODS_MARKETPRICE  = S.GOODS_MARKETPRICE,
               T.GOODS_PAY_PRICE    = S.GOODS_PAY_PRICE,
               T.TV_DISCOUNT_AMOUNT = S.TV_DISCOUNT_AMOUNT,
               T.STORE_ID           = S.STORE_ID,
               T.BUYER_ID           = S.BUYER_ID,
               T.GOODS_TYPE         = S.GOODS_TYPE,
               T.PROMOTIONS_ID      = S.PROMOTIONS_ID,
               T.XIANSHI_GOODS_ID   = S.XIANSHI_GOODS_ID,
               T.CPS_COMMISSION     = S.CPS_COMMISSION,
               T.COMMIS_RATE        = S.COMMIS_RATE,
               T.GC_ID              = S.GC_ID,
               T.EXTRA_POINT        = S.EXTRA_POINT,
               T.PML_TITLE          = S.PML_TITLE,
               T.PML_ID             = S.PML_ID,
               T.PML_DISCOUNT       = S.PML_DISCOUNT,
               T.THIRD_SKUID        = S.THIRD_SKUID,
               T.THIRD_ORDERID      = S.THIRD_ORDERID,
               T.WANGYI_PACKAGE     = S.WANGYI_PACKAGE,
               T.HM_PACKAGE         = S.HM_PACKAGE,
               T.PACKAGE_PROCESS    = S.PACKAGE_PROCESS,
               T.PACKAGE_STATUS     = S.PACKAGE_STATUS,
               T.PACKAGE_INFO       = S.PACKAGE_INFO,
               T.PACKAGE_ERROR      = S.PACKAGE_ERROR,
               T.JOININ_COMMIS_RATE = S.JOININ_COMMIS_RATE,
               T.W_UPDATE_DT        = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.REC_ID,
           T.ORDER_ID,
           T.GOODS_ID,
           T.GOODS_COMMONID,
           T.ERP_CODE,
           T.SUPPLIER_ID,
           T.GOODS_NAME,
           T.GOODS_PRICE,
           T.APPORTION_PRICE,
           T.GOODS_NUM,
           T.RETURN_STATE,
           T.RETURN_TIME,
           T.GOODS_IMAGE,
           T.GOODS_MARKETPRICE,
           T.GOODS_PAY_PRICE,
           T.TV_DISCOUNT_AMOUNT,
           T.STORE_ID,
           T.BUYER_ID,
           T.GOODS_TYPE,
           T.PROMOTIONS_ID,
           T.XIANSHI_GOODS_ID,
           T.CPS_COMMISSION,
           T.COMMIS_RATE,
           T.GC_ID,
           T.EXTRA_POINT,
           T.PML_TITLE,
           T.PML_ID,
           T.PML_DISCOUNT,
           T.THIRD_SKUID,
           T.THIRD_ORDERID,
           T.WANGYI_PACKAGE,
           T.HM_PACKAGE,
           T.PACKAGE_PROCESS,
           T.PACKAGE_STATUS,
           T.PACKAGE_INFO,
           T.PACKAGE_ERROR,
           T.JOININ_COMMIS_RATE,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.REC_ID,
           S.ORDER_ID,
           S.GOODS_ID,
           S.GOODS_COMMONID,
           S.ERP_CODE,
           S.SUPPLIER_ID,
           S.GOODS_NAME,
           S.GOODS_PRICE,
           S.APPORTION_PRICE,
           S.GOODS_NUM,
           S.RETURN_STATE,
           S.RETURN_TIME,
           S.GOODS_IMAGE,
           S.GOODS_MARKETPRICE,
           S.GOODS_PAY_PRICE,
           S.TV_DISCOUNT_AMOUNT,
           S.STORE_ID,
           S.BUYER_ID,
           S.GOODS_TYPE,
           S.PROMOTIONS_ID,
           S.XIANSHI_GOODS_ID,
           S.CPS_COMMISSION,
           S.COMMIS_RATE,
           S.GC_ID,
           S.EXTRA_POINT,
           S.PML_TITLE,
           S.PML_ID,
           S.PML_DISCOUNT,
           S.THIRD_SKUID,
           S.THIRD_ORDERID,
           S.WANGYI_PACKAGE,
           S.HM_PACKAGE,
           S.PACKAGE_PROCESS,
           S.PACKAGE_STATUS,
           S.PACKAGE_INFO,
           S.PACKAGE_ERROR,
           S.JOININ_COMMIS_RATE,
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
  END MERGE_EC_ORDER_GOODS;

  PROCEDURE MERGE_EC_ORDER_COMMON IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_ORDER_COMMON'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_ORDER_COMMON'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_ORDER_COMMON T
      USING (SELECT A.ORDER_ID,
                    A.STORE_ID,
                    A.SHIPPING_TIME,
                    A.SHIPPING_EXPRESS_ID,
                    A.EVALUATION_TIME,
                    A.EVALSELLER_STATE,
                    A.EVALSELLER_TIME,
                    A.ORDER_MESSAGE,
                    A.ORDER_POINTSCOUNT,
                    A.VOUCHER_NAME,
                    A.VOUCHER_PRICE,
                    A.VOUCHER_DESC,
                    A.VOUCHER_START_DATE,
                    A.VOUCHER_END_DATE,
                    A.VOUCHER_REF,
                    A.DCISSUE_SEQ,
                    A.VOUCHER_CODE,
                    A.DELIVER_EXPLAIN,
                    A.DADDRESS_ID,
                    A.TRANSPZONE,
                    A.RECIVER_NAME,
                    A.RECIVER_INFO,
                    A.RECIVER_PROVINCE_ID,
                    A.RECIVER_CITY_ID,
                    A.INVOICE_INFO,
                    A.PROMOTION_INFO,
                    A.DLYO_PICKUP_CODE,
                    A.RECEIVER_SEQ,
                    SYSDATE               W_INSERT_DT,
                    SYSDATE               W_UPDATE_DT
               FROM EC_ORDER_COMMON_TMP A) S
      ON (T.ORDER_ID = S.ORDER_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.STORE_ID            = S.STORE_ID,
               T.SHIPPING_TIME       = S.SHIPPING_TIME,
               T.SHIPPING_EXPRESS_ID = S.SHIPPING_EXPRESS_ID,
               T.EVALUATION_TIME     = S.EVALUATION_TIME,
               T.EVALSELLER_STATE    = S.EVALSELLER_STATE,
               T.EVALSELLER_TIME     = S.EVALSELLER_TIME,
               T.ORDER_MESSAGE       = S.ORDER_MESSAGE,
               T.ORDER_POINTSCOUNT   = S.ORDER_POINTSCOUNT,
               T.VOUCHER_NAME        = S.VOUCHER_NAME,
               T.VOUCHER_PRICE       = S.VOUCHER_PRICE,
               T.VOUCHER_DESC        = S.VOUCHER_DESC,
               T.VOUCHER_START_DATE  = S.VOUCHER_START_DATE,
               T.VOUCHER_END_DATE    = S.VOUCHER_END_DATE,
               T.VOUCHER_REF         = S.VOUCHER_REF,
               T.DCISSUE_SEQ         = S.DCISSUE_SEQ,
               T.VOUCHER_CODE        = S.VOUCHER_CODE,
               T.DELIVER_EXPLAIN     = S.DELIVER_EXPLAIN,
               T.DADDRESS_ID         = S.DADDRESS_ID,
               T.TRANSPZONE          = S.TRANSPZONE,
               T.RECIVER_NAME        = S.RECIVER_NAME,
               T.RECIVER_INFO        = S.RECIVER_INFO,
               T.RECIVER_PROVINCE_ID = S.RECIVER_PROVINCE_ID,
               T.RECIVER_CITY_ID     = S.RECIVER_CITY_ID,
               T.INVOICE_INFO        = S.INVOICE_INFO,
               T.PROMOTION_INFO      = S.PROMOTION_INFO,
               T.DLYO_PICKUP_CODE    = S.DLYO_PICKUP_CODE,
               T.RECEIVER_SEQ        = S.RECEIVER_SEQ,
               T.W_UPDATE_DT         = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ORDER_ID,
           T.STORE_ID,
           T.SHIPPING_TIME,
           T.SHIPPING_EXPRESS_ID,
           T.EVALUATION_TIME,
           T.EVALSELLER_STATE,
           T.EVALSELLER_TIME,
           T.ORDER_MESSAGE,
           T.ORDER_POINTSCOUNT,
           T.VOUCHER_NAME,
           T.VOUCHER_PRICE,
           T.VOUCHER_DESC,
           T.VOUCHER_START_DATE,
           T.VOUCHER_END_DATE,
           T.VOUCHER_REF,
           T.DCISSUE_SEQ,
           T.VOUCHER_CODE,
           T.DELIVER_EXPLAIN,
           T.DADDRESS_ID,
           T.TRANSPZONE,
           T.RECIVER_NAME,
           T.RECIVER_INFO,
           T.RECIVER_PROVINCE_ID,
           T.RECIVER_CITY_ID,
           T.INVOICE_INFO,
           T.PROMOTION_INFO,
           T.DLYO_PICKUP_CODE,
           T.RECEIVER_SEQ,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ORDER_ID,
           S.STORE_ID,
           S.SHIPPING_TIME,
           S.SHIPPING_EXPRESS_ID,
           S.EVALUATION_TIME,
           S.EVALSELLER_STATE,
           S.EVALSELLER_TIME,
           S.ORDER_MESSAGE,
           S.ORDER_POINTSCOUNT,
           S.VOUCHER_NAME,
           S.VOUCHER_PRICE,
           S.VOUCHER_DESC,
           S.VOUCHER_START_DATE,
           S.VOUCHER_END_DATE,
           S.VOUCHER_REF,
           S.DCISSUE_SEQ,
           S.VOUCHER_CODE,
           S.DELIVER_EXPLAIN,
           S.DADDRESS_ID,
           S.TRANSPZONE,
           S.RECIVER_NAME,
           S.RECIVER_INFO,
           S.RECIVER_PROVINCE_ID,
           S.RECIVER_CITY_ID,
           S.INVOICE_INFO,
           S.PROMOTION_INFO,
           S.DLYO_PICKUP_CODE,
           S.RECEIVER_SEQ,
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
  END MERGE_EC_ORDER_COMMON;

  PROCEDURE MERGE_EC_P_XIANSHI IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_P_XIANSHI'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_P_XIANSHI'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_P_XIANSHI T
      USING (SELECT A.XIANSHI_ID,
                    A.CRM_POLICY_ID,
                    A.XIANSHI_TYPE,
                    A.XIANSHI_NAME,
                    A.XIANSHI_TITLE,
                    A.XIANSHI_EXPLAIN,
                    A.QUOTA_ID,
                    A.START_TIME,
                    A.END_TIME,
                    A.XIANSHI_TIME,
                    A.MEMBER_ID,
                    A.STORE_ID,
                    A.MEMBER_NAME,
                    A.STORE_NAME,
                    A.LOWER_LIMIT,
                    A.STATE,
                    A.XIANSHI_WEB,
                    A.XIANSHI_3G,
                    A.XIANSHI_APP,
                    A.XIANSHI_WX,
                    A.XIANSHI_SCHEDULE,
                    SYSDATE            W_INSERT_DT,
                    SYSDATE            W_UPDATE_DT
               FROM EC_P_XIANSHI_TMP A) S
      ON (T.XIANSHI_ID = S.XIANSHI_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.CRM_POLICY_ID    = S.CRM_POLICY_ID,
               T.XIANSHI_TYPE     = S.XIANSHI_TYPE,
               T.XIANSHI_NAME     = S.XIANSHI_NAME,
               T.XIANSHI_TITLE    = S.XIANSHI_TITLE,
               T.XIANSHI_EXPLAIN  = S.XIANSHI_EXPLAIN,
               T.QUOTA_ID         = S.QUOTA_ID,
               T.START_TIME       = S.START_TIME,
               T.END_TIME         = S.END_TIME,
               T.XIANSHI_TIME     = S.XIANSHI_TIME,
               T.MEMBER_ID        = S.MEMBER_ID,
               T.STORE_ID         = S.STORE_ID,
               T.MEMBER_NAME      = S.MEMBER_NAME,
               T.STORE_NAME       = S.STORE_NAME,
               T.LOWER_LIMIT      = S.LOWER_LIMIT,
               T.STATE            = S.STATE,
               T.XIANSHI_WEB      = S.XIANSHI_WEB,
               T.XIANSHI_3G       = S.XIANSHI_3G,
               T.XIANSHI_APP      = S.XIANSHI_APP,
               T.XIANSHI_WX       = S.XIANSHI_WX,
               T.XIANSHI_SCHEDULE = S.XIANSHI_SCHEDULE,
               T.W_UPDATE_DT      = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.XIANSHI_ID,
           T.CRM_POLICY_ID,
           T.XIANSHI_TYPE,
           T.XIANSHI_NAME,
           T.XIANSHI_TITLE,
           T.XIANSHI_EXPLAIN,
           T.QUOTA_ID,
           T.START_TIME,
           T.END_TIME,
           T.XIANSHI_TIME,
           T.MEMBER_ID,
           T.STORE_ID,
           T.MEMBER_NAME,
           T.STORE_NAME,
           T.LOWER_LIMIT,
           T.STATE,
           T.XIANSHI_WEB,
           T.XIANSHI_3G,
           T.XIANSHI_APP,
           T.XIANSHI_WX,
           T.XIANSHI_SCHEDULE,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.XIANSHI_ID,
           S.CRM_POLICY_ID,
           S.XIANSHI_TYPE,
           S.XIANSHI_NAME,
           S.XIANSHI_TITLE,
           S.XIANSHI_EXPLAIN,
           S.QUOTA_ID,
           S.START_TIME,
           S.END_TIME,
           S.XIANSHI_TIME,
           S.MEMBER_ID,
           S.STORE_ID,
           S.MEMBER_NAME,
           S.STORE_NAME,
           S.LOWER_LIMIT,
           S.STATE,
           S.XIANSHI_WEB,
           S.XIANSHI_3G,
           S.XIANSHI_APP,
           S.XIANSHI_WX,
           S.XIANSHI_SCHEDULE,
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
  END MERGE_EC_P_XIANSHI;

  PROCEDURE MERGE_EC_P_XIANSHI_GOODS IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_P_XIANSHI_GOODS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_P_XIANSHI_GOODS'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_P_XIANSHI_GOODS T
      USING (SELECT A.XIANSHI_GOODS_ID,
                    A.XIANSHI_TYPE,
                    A.XIANSHI_ID,
                    A.CRM_POLICY_ID,
                    A.XIANSHI_NAME,
                    A.XIANSHI_TITLE,
                    A.XIANSHI_EXPLAIN,
                    A.GOODS_ID,
                    A.GOODS_COMMONID,
                    A.STORE_ID,
                    A.GOODS_NAME,
                    A.GOODS_PRICE,
                    A.XIANSHI_PRICE,
                    A.APPORTION_PRICE,
                    A.XIANSHI_STORAGE,
                    A.GOODS_IMAGE,
                    A.START_TIME,
                    A.END_TIME,
                    A.LOWER_LIMIT,
                    A.STATE,
                    A.XIANSHI_RECOMMEND,
                    A.XIANSHI_REMARK,
                    A.SORT,
                    SYSDATE             W_INSERT_DT,
                    SYSDATE             W_UPDATE_DT
               FROM EC_P_XIANSHI_GOODS_TMP A) S
      ON (T.XIANSHI_GOODS_ID = S.XIANSHI_GOODS_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.XIANSHI_TYPE      = S.XIANSHI_TYPE,
               T.XIANSHI_ID        = S.XIANSHI_ID,
               T.CRM_POLICY_ID     = S.CRM_POLICY_ID,
               T.XIANSHI_NAME      = S.XIANSHI_NAME,
               T.XIANSHI_TITLE     = S.XIANSHI_TITLE,
               T.XIANSHI_EXPLAIN   = S.XIANSHI_EXPLAIN,
               T.GOODS_ID          = S.GOODS_ID,
               T.GOODS_COMMONID    = S.GOODS_COMMONID,
               T.STORE_ID          = S.STORE_ID,
               T.GOODS_NAME        = S.GOODS_NAME,
               T.GOODS_PRICE       = S.GOODS_PRICE,
               T.XIANSHI_PRICE     = S.XIANSHI_PRICE,
               T.APPORTION_PRICE   = S.APPORTION_PRICE,
               T.XIANSHI_STORAGE   = S.XIANSHI_STORAGE,
               T.GOODS_IMAGE       = S.GOODS_IMAGE,
               T.START_TIME        = S.START_TIME,
               T.END_TIME          = S.END_TIME,
               T.LOWER_LIMIT       = S.LOWER_LIMIT,
               T.STATE             = S.STATE,
               T.XIANSHI_RECOMMEND = S.XIANSHI_RECOMMEND,
               T.XIANSHI_REMARK    = S.XIANSHI_REMARK,
               T.SORT              = S.SORT,
               T.W_UPDATE_DT       = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.XIANSHI_GOODS_ID,
           T.XIANSHI_TYPE,
           T.XIANSHI_ID,
           T.CRM_POLICY_ID,
           T.XIANSHI_NAME,
           T.XIANSHI_TITLE,
           T.XIANSHI_EXPLAIN,
           T.GOODS_ID,
           T.GOODS_COMMONID,
           T.STORE_ID,
           T.GOODS_NAME,
           T.GOODS_PRICE,
           T.XIANSHI_PRICE,
           T.APPORTION_PRICE,
           T.XIANSHI_STORAGE,
           T.GOODS_IMAGE,
           T.START_TIME,
           T.END_TIME,
           T.LOWER_LIMIT,
           T.STATE,
           T.XIANSHI_RECOMMEND,
           T.XIANSHI_REMARK,
           T.SORT,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.XIANSHI_GOODS_ID,
           S.XIANSHI_TYPE,
           S.XIANSHI_ID,
           S.CRM_POLICY_ID,
           S.XIANSHI_NAME,
           S.XIANSHI_TITLE,
           S.XIANSHI_EXPLAIN,
           S.GOODS_ID,
           S.GOODS_COMMONID,
           S.STORE_ID,
           S.GOODS_NAME,
           S.GOODS_PRICE,
           S.XIANSHI_PRICE,
           S.APPORTION_PRICE,
           S.XIANSHI_STORAGE,
           S.GOODS_IMAGE,
           S.START_TIME,
           S.END_TIME,
           S.LOWER_LIMIT,
           S.STATE,
           S.XIANSHI_RECOMMEND,
           S.XIANSHI_REMARK,
           S.SORT,
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
  END MERGE_EC_P_XIANSHI_GOODS;

  PROCEDURE MERGE_EC_P_MANSONG IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_P_MANSONG'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_P_MANSONG'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_P_MANSONG T
      USING (SELECT A.MANSONG_ID,
                    A.MANSONG_NAME,
                    A.QUOTA_ID,
                    A.START_TIME,
                    A.END_TIME,
                    A.MEMBER_ID,
                    A.STORE_ID,
                    A.MEMBER_NAME,
                    A.STORE_NAME,
                    A.STATE,
                    A.REMARK,
                    A.MANSONG_WEB,
                    A.MANSONG_APP,
                    A.MANSONG_WX,
                    A.MANSONG_3G,
                    A.MANSONG_NUM,
                    A.MANSONG_ADVERTISING,
                    A.ISSHOP_CART,
                    A.ISGOODS_DETAILS,
                    A.MAT_TYPE,
                    A.GOODS_TYPE,
                    A.MIN_LEVEL,
                    A.MIN_LEVEL_T,
                    A.ISALL_DETAILS,
                    A.APP_MINATO_SINGLE_URL,
                    A.WEB_MINATO_SINGLE_URL,
                    SYSDATE                 W_INSERT_DT,
                    SYSDATE                 W_UPDATE_DT
               FROM EC_P_MANSONG_TMP A) S
      ON (T.MANSONG_ID = S.MANSONG_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.MANSONG_NAME          = S.MANSONG_NAME,
               T.QUOTA_ID              = S.QUOTA_ID,
               T.START_TIME            = S.START_TIME,
               T.END_TIME              = S.END_TIME,
               T.MEMBER_ID             = S.MEMBER_ID,
               T.STORE_ID              = S.STORE_ID,
               T.MEMBER_NAME           = S.MEMBER_NAME,
               T.STORE_NAME            = S.STORE_NAME,
               T.STATE                 = S.STATE,
               T.REMARK                = S.REMARK,
               T.MANSONG_WEB           = S.MANSONG_WEB,
               T.MANSONG_APP           = S.MANSONG_APP,
               T.MANSONG_WX            = S.MANSONG_WX,
               T.MANSONG_3G            = S.MANSONG_3G,
               T.MANSONG_NUM           = S.MANSONG_NUM,
               T.MANSONG_ADVERTISING   = S.MANSONG_ADVERTISING,
               T.ISSHOP_CART           = S.ISSHOP_CART,
               T.ISGOODS_DETAILS       = S.ISGOODS_DETAILS,
               T.MAT_TYPE              = S.MAT_TYPE,
               T.GOODS_TYPE            = S.GOODS_TYPE,
               T.MIN_LEVEL             = S.MIN_LEVEL,
               T.MIN_LEVEL_T           = S.MIN_LEVEL_T,
               T.ISALL_DETAILS         = S.ISALL_DETAILS,
               T.APP_MINATO_SINGLE_URL = S.APP_MINATO_SINGLE_URL,
               T.WEB_MINATO_SINGLE_URL = S.WEB_MINATO_SINGLE_URL,
               T.W_UPDATE_DT           = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MANSONG_ID,
           T.MANSONG_NAME,
           T.QUOTA_ID,
           T.START_TIME,
           T.END_TIME,
           T.MEMBER_ID,
           T.STORE_ID,
           T.MEMBER_NAME,
           T.STORE_NAME,
           T.STATE,
           T.REMARK,
           T.MANSONG_WEB,
           T.MANSONG_APP,
           T.MANSONG_WX,
           T.MANSONG_3G,
           T.MANSONG_NUM,
           T.MANSONG_ADVERTISING,
           T.ISSHOP_CART,
           T.ISGOODS_DETAILS,
           T.MAT_TYPE,
           T.GOODS_TYPE,
           T.MIN_LEVEL,
           T.MIN_LEVEL_T,
           T.ISALL_DETAILS,
           T.APP_MINATO_SINGLE_URL,
           T.WEB_MINATO_SINGLE_URL,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.MANSONG_ID,
           S.MANSONG_NAME,
           S.QUOTA_ID,
           S.START_TIME,
           S.END_TIME,
           S.MEMBER_ID,
           S.STORE_ID,
           S.MEMBER_NAME,
           S.STORE_NAME,
           S.STATE,
           S.REMARK,
           S.MANSONG_WEB,
           S.MANSONG_APP,
           S.MANSONG_WX,
           S.MANSONG_3G,
           S.MANSONG_NUM,
           S.MANSONG_ADVERTISING,
           S.ISSHOP_CART,
           S.ISGOODS_DETAILS,
           S.MAT_TYPE,
           S.GOODS_TYPE,
           S.MIN_LEVEL,
           S.MIN_LEVEL_T,
           S.ISALL_DETAILS,
           S.APP_MINATO_SINGLE_URL,
           S.WEB_MINATO_SINGLE_URL,
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
  END MERGE_EC_P_MANSONG;

  PROCEDURE MERGE_EC_P_MANSONG_GOODS IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_P_MANSONG_GOODS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_P_MANSONG_GOODS'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_P_MANSONG_GOODS T
      USING (SELECT A.ID,
                    A.MANSONG_ID,
                    A.GOODS_ID,
                    A.ITEM_CODE,
                    A.GOODS_COMMONID,
                    A.ERP_CODE,
                    A.GOODS_NAME,
                    A.STATE,
                    A.CREATE_USER,
                    A.CREATE_TIME,
                    A.LASTUPDATE_TIME,
                    SYSDATE           W_INSERT_DT,
                    SYSDATE           W_UPDATE_DT
               FROM EC_P_MANSONG_GOODS_TMP A) S
      ON (T.ID = S.ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.MANSONG_ID      = S.MANSONG_ID,
               T.GOODS_ID        = S.GOODS_ID,
               T.ITEM_CODE       = S.ITEM_CODE,
               T.GOODS_COMMONID  = S.GOODS_COMMONID,
               T.ERP_CODE        = S.ERP_CODE,
               T.GOODS_NAME      = S.GOODS_NAME,
               T.STATE           = S.STATE,
               T.CREATE_USER     = S.CREATE_USER,
               T.CREATE_TIME     = S.CREATE_TIME,
               T.LASTUPDATE_TIME = S.LASTUPDATE_TIME,
               T.W_UPDATE_DT     = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID,
           T.MANSONG_ID,
           T.GOODS_ID,
           T.ITEM_CODE,
           T.GOODS_COMMONID,
           T.ERP_CODE,
           T.GOODS_NAME,
           T.STATE,
           T.CREATE_USER,
           T.CREATE_TIME,
           T.LASTUPDATE_TIME,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID,
           S.MANSONG_ID,
           S.GOODS_ID,
           S.ITEM_CODE,
           S.GOODS_COMMONID,
           S.ERP_CODE,
           S.GOODS_NAME,
           S.STATE,
           S.CREATE_USER,
           S.CREATE_TIME,
           S.LASTUPDATE_TIME,
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
  END MERGE_EC_P_MANSONG_GOODS;

  PROCEDURE MERGE_EC_VOUCHER IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_VOUCHER'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_VOUCHER'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_VOUCHER T
      USING (SELECT A.VOUCHER_ID,
                    A.VOUCHER_CODE,
                    A.VOUCHER_T_ID,
                    A.VOUCHER_TITLE,
                    A.VOUCHER_DESC,
                    A.VOUCHER_START_DATE,
                    A.VOUCHER_END_DATE,
                    A.VOUCHER_PRICE,
                    A.VOUCHER_LIMIT,
                    A.VOUCHER_STORE_ID,
                    A.VOUCHER_STATE,
                    A.VOUCHER_ACTIVE_DATE,
                    A.VOUCHER_TYPE,
                    A.VOUCHER_OWNER_ID,
                    A.VOUCHER_OWNER_NAME,
                    A.VOUCHER_ORDER_ID,
                    A.VOUCHER_ADD_IP,
                    A.VOUCHER_ADD_VID,
                    A.VOUCHER_ADD_APPLICATION,
                    A.COUPON_TV_ID,
                    A.COUPON_TV_CODE,
                    A.VOUCHER_REMARK,
                    SYSDATE                   W_INSERT_DT,
                    SYSDATE                   W_UPDATE_DT
               FROM EC_VOUCHER_TMP A) S
      ON (T.VOUCHER_ID = S.VOUCHER_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.VOUCHER_CODE            = S.VOUCHER_CODE,
               T.VOUCHER_T_ID            = S.VOUCHER_T_ID,
               T.VOUCHER_TITLE           = S.VOUCHER_TITLE,
               T.VOUCHER_DESC            = S.VOUCHER_DESC,
               T.VOUCHER_START_DATE      = S.VOUCHER_START_DATE,
               T.VOUCHER_END_DATE        = S.VOUCHER_END_DATE,
               T.VOUCHER_PRICE           = S.VOUCHER_PRICE,
               T.VOUCHER_LIMIT           = S.VOUCHER_LIMIT,
               T.VOUCHER_STORE_ID        = S.VOUCHER_STORE_ID,
               T.VOUCHER_STATE           = S.VOUCHER_STATE,
               T.VOUCHER_ACTIVE_DATE     = S.VOUCHER_ACTIVE_DATE,
               T.VOUCHER_TYPE            = S.VOUCHER_TYPE,
               T.VOUCHER_OWNER_ID        = S.VOUCHER_OWNER_ID,
               T.VOUCHER_OWNER_NAME      = S.VOUCHER_OWNER_NAME,
               T.VOUCHER_ORDER_ID        = S.VOUCHER_ORDER_ID,
               T.VOUCHER_ADD_IP          = S.VOUCHER_ADD_IP,
               T.VOUCHER_ADD_VID         = S.VOUCHER_ADD_VID,
               T.VOUCHER_ADD_APPLICATION = S.VOUCHER_ADD_APPLICATION,
               T.COUPON_TV_ID            = S.COUPON_TV_ID,
               T.COUPON_TV_CODE          = S.COUPON_TV_CODE,
               T.VOUCHER_REMARK          = S.VOUCHER_REMARK,
               T.W_UPDATE_DT             = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.VOUCHER_ID,
           T.VOUCHER_CODE,
           T.VOUCHER_T_ID,
           T.VOUCHER_TITLE,
           T.VOUCHER_DESC,
           T.VOUCHER_START_DATE,
           T.VOUCHER_END_DATE,
           T.VOUCHER_PRICE,
           T.VOUCHER_LIMIT,
           T.VOUCHER_STORE_ID,
           T.VOUCHER_STATE,
           T.VOUCHER_ACTIVE_DATE,
           T.VOUCHER_TYPE,
           T.VOUCHER_OWNER_ID,
           T.VOUCHER_OWNER_NAME,
           T.VOUCHER_ORDER_ID,
           T.VOUCHER_ADD_IP,
           T.VOUCHER_ADD_VID,
           T.VOUCHER_ADD_APPLICATION,
           T.COUPON_TV_ID,
           T.COUPON_TV_CODE,
           T.VOUCHER_REMARK,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.VOUCHER_ID,
           S.VOUCHER_CODE,
           S.VOUCHER_T_ID,
           S.VOUCHER_TITLE,
           S.VOUCHER_DESC,
           S.VOUCHER_START_DATE,
           S.VOUCHER_END_DATE,
           S.VOUCHER_PRICE,
           S.VOUCHER_LIMIT,
           S.VOUCHER_STORE_ID,
           S.VOUCHER_STATE,
           S.VOUCHER_ACTIVE_DATE,
           S.VOUCHER_TYPE,
           S.VOUCHER_OWNER_ID,
           S.VOUCHER_OWNER_NAME,
           S.VOUCHER_ORDER_ID,
           S.VOUCHER_ADD_IP,
           S.VOUCHER_ADD_VID,
           S.VOUCHER_ADD_APPLICATION,
           S.COUPON_TV_ID,
           S.COUPON_TV_CODE,
           S.VOUCHER_REMARK,
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
  END MERGE_EC_VOUCHER;

  PROCEDURE MERGE_EC_VOUCHER_BATCH IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_VOUCHER_BATCH'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_VOUCHER_BATCH'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_VOUCHER_BATCH T
      USING (SELECT A.ID,
                    A.VOUCHER_ID,
                    A.MEMBER_ID,
                    A.CUST_NO,
                    A.STATE,
                    A.ADDTIME,
                    A.REMARKS,
                    A.VOUCHER_KEY,
                    A.OUT_SN,
                    A.ERP_ORDER_NO,
                    A.SEND_TYPE,
                    SYSDATE        W_INSERT_DT,
                    SYSDATE        W_UPDATE_DT
               FROM EC_VOUCHER_BATCH_TMP A) S
      ON (T.ID = S.ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.VOUCHER_ID   = S.VOUCHER_ID,
               T.MEMBER_ID    = S.MEMBER_ID,
               T.CUST_NO      = S.CUST_NO,
               T.STATE        = S.STATE,
               T.ADDTIME      = S.ADDTIME,
               T.REMARKS      = S.REMARKS,
               T.VOUCHER_KEY  = S.VOUCHER_KEY,
               T.OUT_SN       = S.OUT_SN,
               T.ERP_ORDER_NO = S.ERP_ORDER_NO,
               T.SEND_TYPE    = S.SEND_TYPE,
               T.W_UPDATE_DT  = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID,
           T.VOUCHER_ID,
           T.MEMBER_ID,
           T.CUST_NO,
           T.STATE,
           T.ADDTIME,
           T.REMARKS,
           T.VOUCHER_KEY,
           T.OUT_SN,
           T.ERP_ORDER_NO,
           T.SEND_TYPE,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID,
           S.VOUCHER_ID,
           S.MEMBER_ID,
           S.CUST_NO,
           S.STATE,
           S.ADDTIME,
           S.REMARKS,
           S.VOUCHER_KEY,
           S.OUT_SN,
           S.ERP_ORDER_NO,
           S.SEND_TYPE,
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
  END MERGE_EC_VOUCHER_BATCH;

  PROCEDURE MERGE_EC_VOUCHER_PRICE IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2017-09-14
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_VOUCHER_PRICE'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_VOUCHER_PRICE'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_VOUCHER_PRICE T
      USING (SELECT A.VOUCHER_PRICE_ID,
                    A.VOUCHER_PRICE_DESCRIBE,
                    A.VOUCHER_PRICE,
                    A.VOUCHER_DEFAULTPOINTS,
                    SYSDATE                  W_INSERT_DT,
                    SYSDATE                  W_UPDATE_DT
               FROM EC_VOUCHER_PRICE_TMP A) S
      ON (T.VOUCHER_PRICE_ID = S.VOUCHER_PRICE_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.VOUCHER_PRICE_DESCRIBE = S.VOUCHER_PRICE_DESCRIBE,
               T.VOUCHER_PRICE          = S.VOUCHER_PRICE,
               T.VOUCHER_DEFAULTPOINTS  = S.VOUCHER_DEFAULTPOINTS,
               T.W_UPDATE_DT            = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.VOUCHER_PRICE_ID,
           T.VOUCHER_PRICE_DESCRIBE,
           T.VOUCHER_PRICE,
           T.VOUCHER_DEFAULTPOINTS,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.VOUCHER_PRICE_ID,
           S.VOUCHER_PRICE_DESCRIBE,
           S.VOUCHER_PRICE,
           S.VOUCHER_DEFAULTPOINTS,
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
  END MERGE_EC_VOUCHER_PRICE;

  PROCEDURE MERGE_EC_GOODS_COMMON IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2018-01-11
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_GOODS_COMMON'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_GOODS_COMMON'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_GOODS_COMMON T
      USING (SELECT A.GOODS_COMMONID,
                    A.ITEM_CODE,
                    A.GOODS_NAME,
                    A.GOODS_JINGLE,
                    A.GOODS_JINGLE2,
                    A.GOODS_SHORT_DESC,
                    A.GC_ID,
                    A.GC_ID_1,
                    A.GC_ID_2,
                    A.GC_ID_3,
                    A.GC_NAME,
                    A.GC_SUB_ID,
                    A.MATDL,
                    A.MATZL,
                    A.MATXL,
                    A.MATKL,
                    A.STORE_ID,
                    A.STORE_NAME,
                    A.SPEC_NAME,
                    A.SPEC_VALUE,
                    A.BRAND_ID,
                    A.BRAND_NAME,
                    A.TYPE_ID,
                    A.GOODS_IMAGE,
                    A.GOODS_ANIMATION,
                    A.GOODS_VIDEOURL,
                    A.GOODS_ATTR,
                    A.GOODS_BODY,
                    A.MOBILE_BODY,
                    A.GOODS_STATE,
                    A.GOODS_STATEREMARK,
                    A.GOODS_VERIFY,
                    A.GOODS_VERIFYREMARK,
                    A.GOODS_LOCK,
                    A.GOODS_ADDTIME,
                    A.GOODS_SELLTIME,
                    A.GOODS_SPECNAME,
                    A.GOODS_PRICE,
                    A.GOODS_MARKETPRICE,
                    A.GOODS_COSTPRICE,
                    A.GOODS_DISCOUNT,
                    A.GOODS_PROMOTION_PRICE,
                    A.GOODS_PROMOTION_PRICE_APP,
                    A.GOODS_PROMOTION_PRICE_WX,
                    A.GOODS_PROMOTION_PRICE_3G,
                    A.GOODS_SERIAL,
                    A.GOODS_STORAGE,
                    A.GOODS_STORAGE_ALARM,
                    A.TRANSPORT_ID,
                    A.TRANSPORT_TITLE,
                    A.GOODS_COMMEND,
                    A.GOODS_FREIGHT,
                    A.GOODS_VAT,
                    A.AREAID_1,
                    A.AREAID_2,
                    A.GOODS_STCIDS,
                    A.PLATEID_TOP,
                    A.PLATEID_BOTTOM,
                    A.IS_VIRTUAL,
                    A.VIRTUAL_INDATE,
                    A.VIRTUAL_LIMIT,
                    A.VIRTUAL_INVALID_REFUND,
                    A.IS_FCODE,
                    A.IS_APPOINT,
                    A.APPOINT_SATEDATE,
                    A.IS_PRESELL,
                    A.PRESELL_DELIVERDATE,
                    A.IS_OWN_SHOP,
                    A.IS_TV,
                    A.IS_ADD_CART,
                    A.RETENTION_TIME,
                    A.SUPPLIER_ID,
                    A.SUPPLIER_NAME,
                    A.IS_LIVE_PROMOTION,
                    A.IS_ALLOW_OFFLINE,
                    A.IS_ALLOW_POINT,
                    A.IS_ALLOW_VOUCHER,
                    A.IS_ALLOW_PAYPROMOTION,
                    A.PAYPROMOTION_AMOUNT,
                    A.IS_ALLOW_BANKPROMOTION,
                    A.GOODS_SALENUM,
                    A.GOODS_POP,
                    A.GIFT_NUM,
                    A.IS_VALUABLES,
                    A.IS_BIG,
                    A.GIVE_POINTS,
                    A.IS_SHIPPING_SELF,
                    A.IS_NEW_MEMBER_GIFT,
                    A.IS_ALLOW_RETURN,
                    A.IS_APPRECIATION,
                    A.GOODS_WEIGHT,
                    A.IS_RESERVED,
                    A.PV_TOTAL,
                    A.UV_TOTAL,
                    A.SALENUM_D1,
                    A.SALENUM_D7,
                    A.SALENUM_D30,
                    A.SALENUM_D90,
                    A.COLLECT_TOTAL,
                    A.EVALUATION_TOTAL,
                    A.SEARCH_KEY,
                    A.SUPERSCRIPT_ID,
                    A.EXTRA_POINT,
                    A.IS_RESERVATION_DELIVERY,
                    A.GOODS_REMINDER,
                    A.GOODS_SERVICE,
                    A.GOODS_SERVICE_IDS,
                    A.FIRSTONSELLTIME,
                    A.NEWGOODSRATE,
                    A.FASTBUYENABLE,
                    A.CUSTOMER_SERVICE,
                    A.PHYSICAL_INVENTORY,
                    A.USE_DATE,
                    A.EXTRA_GIFT,
                    A.ZTLHRP,
                    A.ZT_PIC,
                    A.ZT_URL,
                    A.PML_ID,
                    A.PML_TITLE,
                    A.PML_MAX_PROMOTION,
                    A.PML_PROMOTION,
                    A.PML_ENABLE,
                    A.LIVE_IMAGE,
                    A.IS_GROUP_PURCHASE,
                    A.COMMISSION_RULE,
                    A.COMMISSION_RATE,
                    A.DELAY_DAYS,
                    SYSDATE                     W_INSERT_DT,
                    SYSDATE                     W_UPDATE_DT
               FROM EC_GOODS_COMMON_TMP A) S
      ON (T.GOODS_COMMONID = S.GOODS_COMMONID)
      WHEN MATCHED THEN
        UPDATE
           SET T.ITEM_CODE                 = S.ITEM_CODE,
               T.GOODS_NAME                = S.GOODS_NAME,
               T.GOODS_JINGLE              = S.GOODS_JINGLE,
               T.GOODS_JINGLE2             = S.GOODS_JINGLE2,
               T.GOODS_SHORT_DESC          = S.GOODS_SHORT_DESC,
               T.GC_ID                     = S.GC_ID,
               T.GC_ID_1                   = S.GC_ID_1,
               T.GC_ID_2                   = S.GC_ID_2,
               T.GC_ID_3                   = S.GC_ID_3,
               T.GC_NAME                   = S.GC_NAME,
               T.GC_SUB_ID                 = S.GC_SUB_ID,
               T.MATDL                     = S.MATDL,
               T.MATZL                     = S.MATZL,
               T.MATXL                     = S.MATXL,
               T.MATKL                     = S.MATKL,
               T.STORE_ID                  = S.STORE_ID,
               T.STORE_NAME                = S.STORE_NAME,
               T.SPEC_NAME                 = S.SPEC_NAME,
               T.SPEC_VALUE                = S.SPEC_VALUE,
               T.BRAND_ID                  = S.BRAND_ID,
               T.BRAND_NAME                = S.BRAND_NAME,
               T.TYPE_ID                   = S.TYPE_ID,
               T.GOODS_IMAGE               = S.GOODS_IMAGE,
               T.GOODS_ANIMATION           = S.GOODS_ANIMATION,
               T.GOODS_VIDEOURL            = S.GOODS_VIDEOURL,
               T.GOODS_ATTR                = S.GOODS_ATTR,
               T.GOODS_BODY                = S.GOODS_BODY,
               T.MOBILE_BODY               = S.MOBILE_BODY,
               T.GOODS_STATE               = S.GOODS_STATE,
               T.GOODS_STATEREMARK         = S.GOODS_STATEREMARK,
               T.GOODS_VERIFY              = S.GOODS_VERIFY,
               T.GOODS_VERIFYREMARK        = S.GOODS_VERIFYREMARK,
               T.GOODS_LOCK                = S.GOODS_LOCK,
               T.GOODS_ADDTIME             = S.GOODS_ADDTIME,
               T.GOODS_SELLTIME            = S.GOODS_SELLTIME,
               T.GOODS_SPECNAME            = S.GOODS_SPECNAME,
               T.GOODS_PRICE               = S.GOODS_PRICE,
               T.GOODS_MARKETPRICE         = S.GOODS_MARKETPRICE,
               T.GOODS_COSTPRICE           = S.GOODS_COSTPRICE,
               T.GOODS_DISCOUNT            = S.GOODS_DISCOUNT,
               T.GOODS_PROMOTION_PRICE     = S.GOODS_PROMOTION_PRICE,
               T.GOODS_PROMOTION_PRICE_APP = S.GOODS_PROMOTION_PRICE_APP,
               T.GOODS_PROMOTION_PRICE_WX  = S.GOODS_PROMOTION_PRICE_WX,
               T.GOODS_PROMOTION_PRICE_3G  = S.GOODS_PROMOTION_PRICE_3G,
               T.GOODS_SERIAL              = S.GOODS_SERIAL,
               T.GOODS_STORAGE             = S.GOODS_STORAGE,
               T.GOODS_STORAGE_ALARM       = S.GOODS_STORAGE_ALARM,
               T.TRANSPORT_ID              = S.TRANSPORT_ID,
               T.TRANSPORT_TITLE           = S.TRANSPORT_TITLE,
               T.GOODS_COMMEND             = S.GOODS_COMMEND,
               T.GOODS_FREIGHT             = S.GOODS_FREIGHT,
               T.GOODS_VAT                 = S.GOODS_VAT,
               T.AREAID_1                  = S.AREAID_1,
               T.AREAID_2                  = S.AREAID_2,
               T.GOODS_STCIDS              = S.GOODS_STCIDS,
               T.PLATEID_TOP               = S.PLATEID_TOP,
               T.PLATEID_BOTTOM            = S.PLATEID_BOTTOM,
               T.IS_VIRTUAL                = S.IS_VIRTUAL,
               T.VIRTUAL_INDATE            = S.VIRTUAL_INDATE,
               T.VIRTUAL_LIMIT             = S.VIRTUAL_LIMIT,
               T.VIRTUAL_INVALID_REFUND    = S.VIRTUAL_INVALID_REFUND,
               T.IS_FCODE                  = S.IS_FCODE,
               T.IS_APPOINT                = S.IS_APPOINT,
               T.APPOINT_SATEDATE          = S.APPOINT_SATEDATE,
               T.IS_PRESELL                = S.IS_PRESELL,
               T.PRESELL_DELIVERDATE       = S.PRESELL_DELIVERDATE,
               T.IS_OWN_SHOP               = S.IS_OWN_SHOP,
               T.IS_TV                     = S.IS_TV,
               T.IS_ADD_CART               = S.IS_ADD_CART,
               T.RETENTION_TIME            = S.RETENTION_TIME,
               T.SUPPLIER_ID               = S.SUPPLIER_ID,
               T.SUPPLIER_NAME             = S.SUPPLIER_NAME,
               T.IS_LIVE_PROMOTION         = S.IS_LIVE_PROMOTION,
               T.IS_ALLOW_OFFLINE          = S.IS_ALLOW_OFFLINE,
               T.IS_ALLOW_POINT            = S.IS_ALLOW_POINT,
               T.IS_ALLOW_VOUCHER          = S.IS_ALLOW_VOUCHER,
               T.IS_ALLOW_PAYPROMOTION     = S.IS_ALLOW_PAYPROMOTION,
               T.PAYPROMOTION_AMOUNT       = S.PAYPROMOTION_AMOUNT,
               T.IS_ALLOW_BANKPROMOTION    = S.IS_ALLOW_BANKPROMOTION,
               T.GOODS_SALENUM             = S.GOODS_SALENUM,
               T.GOODS_POP                 = S.GOODS_POP,
               T.GIFT_NUM                  = S.GIFT_NUM,
               T.IS_VALUABLES              = S.IS_VALUABLES,
               T.IS_BIG                    = S.IS_BIG,
               T.GIVE_POINTS               = S.GIVE_POINTS,
               T.IS_SHIPPING_SELF          = S.IS_SHIPPING_SELF,
               T.IS_NEW_MEMBER_GIFT        = S.IS_NEW_MEMBER_GIFT,
               T.IS_ALLOW_RETURN           = S.IS_ALLOW_RETURN,
               T.IS_APPRECIATION           = S.IS_APPRECIATION,
               T.GOODS_WEIGHT              = S.GOODS_WEIGHT,
               T.IS_RESERVED               = S.IS_RESERVED,
               T.PV_TOTAL                  = S.PV_TOTAL,
               T.UV_TOTAL                  = S.UV_TOTAL,
               T.SALENUM_D1                = S.SALENUM_D1,
               T.SALENUM_D7                = S.SALENUM_D7,
               T.SALENUM_D30               = S.SALENUM_D30,
               T.SALENUM_D90               = S.SALENUM_D90,
               T.COLLECT_TOTAL             = S.COLLECT_TOTAL,
               T.EVALUATION_TOTAL          = S.EVALUATION_TOTAL,
               T.SEARCH_KEY                = S.SEARCH_KEY,
               T.SUPERSCRIPT_ID            = S.SUPERSCRIPT_ID,
               T.EXTRA_POINT               = S.EXTRA_POINT,
               T.IS_RESERVATION_DELIVERY   = S.IS_RESERVATION_DELIVERY,
               T.GOODS_REMINDER            = S.GOODS_REMINDER,
               T.GOODS_SERVICE             = S.GOODS_SERVICE,
               T.GOODS_SERVICE_IDS         = S.GOODS_SERVICE_IDS,
               T.FIRSTONSELLTIME           = S.FIRSTONSELLTIME,
               T.NEWGOODSRATE              = S.NEWGOODSRATE,
               T.FASTBUYENABLE             = S.FASTBUYENABLE,
               T.CUSTOMER_SERVICE          = S.CUSTOMER_SERVICE,
               T.PHYSICAL_INVENTORY        = S.PHYSICAL_INVENTORY,
               T.USE_DATE                  = S.USE_DATE,
               T.EXTRA_GIFT                = S.EXTRA_GIFT,
               T.ZTLHRP                    = S.ZTLHRP,
               T.ZT_PIC                    = S.ZT_PIC,
               T.ZT_URL                    = S.ZT_URL,
               T.PML_ID                    = S.PML_ID,
               T.PML_TITLE                 = S.PML_TITLE,
               T.PML_MAX_PROMOTION         = S.PML_MAX_PROMOTION,
               T.PML_PROMOTION             = S.PML_PROMOTION,
               T.PML_ENABLE                = S.PML_ENABLE,
               T.LIVE_IMAGE                = S.LIVE_IMAGE,
               T.IS_GROUP_PURCHASE         = S.IS_GROUP_PURCHASE,
               T.COMMISSION_RULE           = S.COMMISSION_RULE,
               T.COMMISSION_RATE           = S.COMMISSION_RATE,
               T.DELAY_DAYS                = S.DELAY_DAYS,
               T.W_UPDATE_DT               = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.GOODS_COMMONID,
           T.ITEM_CODE,
           T.GOODS_NAME,
           T.GOODS_JINGLE,
           T.GOODS_JINGLE2,
           T.GOODS_SHORT_DESC,
           T.GC_ID,
           T.GC_ID_1,
           T.GC_ID_2,
           T.GC_ID_3,
           T.GC_NAME,
           T.GC_SUB_ID,
           T.MATDL,
           T.MATZL,
           T.MATXL,
           T.MATKL,
           T.STORE_ID,
           T.STORE_NAME,
           T.SPEC_NAME,
           T.SPEC_VALUE,
           T.BRAND_ID,
           T.BRAND_NAME,
           T.TYPE_ID,
           T.GOODS_IMAGE,
           T.GOODS_ANIMATION,
           T.GOODS_VIDEOURL,
           T.GOODS_ATTR,
           T.GOODS_BODY,
           T.MOBILE_BODY,
           T.GOODS_STATE,
           T.GOODS_STATEREMARK,
           T.GOODS_VERIFY,
           T.GOODS_VERIFYREMARK,
           T.GOODS_LOCK,
           T.GOODS_ADDTIME,
           T.GOODS_SELLTIME,
           T.GOODS_SPECNAME,
           T.GOODS_PRICE,
           T.GOODS_MARKETPRICE,
           T.GOODS_COSTPRICE,
           T.GOODS_DISCOUNT,
           T.GOODS_PROMOTION_PRICE,
           T.GOODS_PROMOTION_PRICE_APP,
           T.GOODS_PROMOTION_PRICE_WX,
           T.GOODS_PROMOTION_PRICE_3G,
           T.GOODS_SERIAL,
           T.GOODS_STORAGE,
           T.GOODS_STORAGE_ALARM,
           T.TRANSPORT_ID,
           T.TRANSPORT_TITLE,
           T.GOODS_COMMEND,
           T.GOODS_FREIGHT,
           T.GOODS_VAT,
           T.AREAID_1,
           T.AREAID_2,
           T.GOODS_STCIDS,
           T.PLATEID_TOP,
           T.PLATEID_BOTTOM,
           T.IS_VIRTUAL,
           T.VIRTUAL_INDATE,
           T.VIRTUAL_LIMIT,
           T.VIRTUAL_INVALID_REFUND,
           T.IS_FCODE,
           T.IS_APPOINT,
           T.APPOINT_SATEDATE,
           T.IS_PRESELL,
           T.PRESELL_DELIVERDATE,
           T.IS_OWN_SHOP,
           T.IS_TV,
           T.IS_ADD_CART,
           T.RETENTION_TIME,
           T.SUPPLIER_ID,
           T.SUPPLIER_NAME,
           T.IS_LIVE_PROMOTION,
           T.IS_ALLOW_OFFLINE,
           T.IS_ALLOW_POINT,
           T.IS_ALLOW_VOUCHER,
           T.IS_ALLOW_PAYPROMOTION,
           T.PAYPROMOTION_AMOUNT,
           T.IS_ALLOW_BANKPROMOTION,
           T.GOODS_SALENUM,
           T.GOODS_POP,
           T.GIFT_NUM,
           T.IS_VALUABLES,
           T.IS_BIG,
           T.GIVE_POINTS,
           T.IS_SHIPPING_SELF,
           T.IS_NEW_MEMBER_GIFT,
           T.IS_ALLOW_RETURN,
           T.IS_APPRECIATION,
           T.GOODS_WEIGHT,
           T.IS_RESERVED,
           T.PV_TOTAL,
           T.UV_TOTAL,
           T.SALENUM_D1,
           T.SALENUM_D7,
           T.SALENUM_D30,
           T.SALENUM_D90,
           T.COLLECT_TOTAL,
           T.EVALUATION_TOTAL,
           T.SEARCH_KEY,
           T.SUPERSCRIPT_ID,
           T.EXTRA_POINT,
           T.IS_RESERVATION_DELIVERY,
           T.GOODS_REMINDER,
           T.GOODS_SERVICE,
           T.GOODS_SERVICE_IDS,
           T.FIRSTONSELLTIME,
           T.NEWGOODSRATE,
           T.FASTBUYENABLE,
           T.CUSTOMER_SERVICE,
           T.PHYSICAL_INVENTORY,
           T.USE_DATE,
           T.EXTRA_GIFT,
           T.ZTLHRP,
           T.ZT_PIC,
           T.ZT_URL,
           T.PML_ID,
           T.PML_TITLE,
           T.PML_MAX_PROMOTION,
           T.PML_PROMOTION,
           T.PML_ENABLE,
           T.LIVE_IMAGE,
           T.IS_GROUP_PURCHASE,
           T.COMMISSION_RULE,
           T.COMMISSION_RATE,
           T.DELAY_DAYS,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.GOODS_COMMONID,
           S.ITEM_CODE,
           S.GOODS_NAME,
           S.GOODS_JINGLE,
           S.GOODS_JINGLE2,
           S.GOODS_SHORT_DESC,
           S.GC_ID,
           S.GC_ID_1,
           S.GC_ID_2,
           S.GC_ID_3,
           S.GC_NAME,
           S.GC_SUB_ID,
           S.MATDL,
           S.MATZL,
           S.MATXL,
           S.MATKL,
           S.STORE_ID,
           S.STORE_NAME,
           S.SPEC_NAME,
           S.SPEC_VALUE,
           S.BRAND_ID,
           S.BRAND_NAME,
           S.TYPE_ID,
           S.GOODS_IMAGE,
           S.GOODS_ANIMATION,
           S.GOODS_VIDEOURL,
           S.GOODS_ATTR,
           S.GOODS_BODY,
           S.MOBILE_BODY,
           S.GOODS_STATE,
           S.GOODS_STATEREMARK,
           S.GOODS_VERIFY,
           S.GOODS_VERIFYREMARK,
           S.GOODS_LOCK,
           S.GOODS_ADDTIME,
           S.GOODS_SELLTIME,
           S.GOODS_SPECNAME,
           S.GOODS_PRICE,
           S.GOODS_MARKETPRICE,
           S.GOODS_COSTPRICE,
           S.GOODS_DISCOUNT,
           S.GOODS_PROMOTION_PRICE,
           S.GOODS_PROMOTION_PRICE_APP,
           S.GOODS_PROMOTION_PRICE_WX,
           S.GOODS_PROMOTION_PRICE_3G,
           S.GOODS_SERIAL,
           S.GOODS_STORAGE,
           S.GOODS_STORAGE_ALARM,
           S.TRANSPORT_ID,
           S.TRANSPORT_TITLE,
           S.GOODS_COMMEND,
           S.GOODS_FREIGHT,
           S.GOODS_VAT,
           S.AREAID_1,
           S.AREAID_2,
           S.GOODS_STCIDS,
           S.PLATEID_TOP,
           S.PLATEID_BOTTOM,
           S.IS_VIRTUAL,
           S.VIRTUAL_INDATE,
           S.VIRTUAL_LIMIT,
           S.VIRTUAL_INVALID_REFUND,
           S.IS_FCODE,
           S.IS_APPOINT,
           S.APPOINT_SATEDATE,
           S.IS_PRESELL,
           S.PRESELL_DELIVERDATE,
           S.IS_OWN_SHOP,
           S.IS_TV,
           S.IS_ADD_CART,
           S.RETENTION_TIME,
           S.SUPPLIER_ID,
           S.SUPPLIER_NAME,
           S.IS_LIVE_PROMOTION,
           S.IS_ALLOW_OFFLINE,
           S.IS_ALLOW_POINT,
           S.IS_ALLOW_VOUCHER,
           S.IS_ALLOW_PAYPROMOTION,
           S.PAYPROMOTION_AMOUNT,
           S.IS_ALLOW_BANKPROMOTION,
           S.GOODS_SALENUM,
           S.GOODS_POP,
           S.GIFT_NUM,
           S.IS_VALUABLES,
           S.IS_BIG,
           S.GIVE_POINTS,
           S.IS_SHIPPING_SELF,
           S.IS_NEW_MEMBER_GIFT,
           S.IS_ALLOW_RETURN,
           S.IS_APPRECIATION,
           S.GOODS_WEIGHT,
           S.IS_RESERVED,
           S.PV_TOTAL,
           S.UV_TOTAL,
           S.SALENUM_D1,
           S.SALENUM_D7,
           S.SALENUM_D30,
           S.SALENUM_D90,
           S.COLLECT_TOTAL,
           S.EVALUATION_TOTAL,
           S.SEARCH_KEY,
           S.SUPERSCRIPT_ID,
           S.EXTRA_POINT,
           S.IS_RESERVATION_DELIVERY,
           S.GOODS_REMINDER,
           S.GOODS_SERVICE,
           S.GOODS_SERVICE_IDS,
           S.FIRSTONSELLTIME,
           S.NEWGOODSRATE,
           S.FASTBUYENABLE,
           S.CUSTOMER_SERVICE,
           S.PHYSICAL_INVENTORY,
           S.USE_DATE,
           S.EXTRA_GIFT,
           S.ZTLHRP,
           S.ZT_PIC,
           S.ZT_URL,
           S.PML_ID,
           S.PML_TITLE,
           S.PML_MAX_PROMOTION,
           S.PML_PROMOTION,
           S.PML_ENABLE,
           S.LIVE_IMAGE,
           S.IS_GROUP_PURCHASE,
           S.COMMISSION_RULE,
           S.COMMISSION_RATE,
           S.DELAY_DAYS,
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
  END MERGE_EC_GOODS_COMMON;

  PROCEDURE MERGE_EC_GOODS_MANUAL IS
    S_ETL       W_ETL_LOG%ROWTYPE;
    SP_NAME     S_PARAMETERS2.PNAME%TYPE;
    S_PARAMETER S_PARAMETERS1.PARAMETER_VALUE%TYPE;
    INSERT_ROWS NUMBER;
    UPDATE_ROWS NUMBER;
    /*
    功能说明：
    作者时间：yangjin  2018-01-31
    */
  BEGIN
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_GOODS_MANUAL'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_EC_GOODS_MANUAL'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_EC_GOODS_MANUAL T
      USING (SELECT A.MANUAL_ID,
                    A.ITEM_CODE,
                    A.COMMON_ID,
                    A.ZMALAB,
                    A.ZLABNAME,
                    A.ZMALABTXT,
                    A.CHECKED,
                    A.ADD_TIME,
                    A.SHOW_SORT,
                    SYSDATE     W_INSERT_DT,
                    SYSDATE     W_UPDATE_DT
               FROM EC_GOODS_MANUAL_TMP A) S
      ON (T.MANUAL_ID = S.MANUAL_ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.ITEM_CODE   = S.ITEM_CODE,
               T.COMMON_ID   = S.COMMON_ID,
               T.ZMALAB      = S.ZMALAB,
               T.ZLABNAME    = S.ZLABNAME,
               T.ZMALABTXT   = S.ZMALABTXT,
               T.CHECKED     = S.CHECKED,
               T.ADD_TIME    = S.ADD_TIME,
               T.SHOW_SORT   = S.SHOW_SORT,
               T.W_UPDATE_DT = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.MANUAL_ID,
           T.ITEM_CODE,
           T.COMMON_ID,
           T.ZMALAB,
           T.ZLABNAME,
           T.ZMALABTXT,
           T.CHECKED,
           T.ADD_TIME,
           T.SHOW_SORT,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.MANUAL_ID,
           S.ITEM_CODE,
           S.COMMON_ID,
           S.ZMALAB,
           S.ZLABNAME,
           S.ZMALABTXT,
           S.CHECKED,
           S.ADD_TIME,
           S.SHOW_SORT,
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
  END MERGE_EC_GOODS_MANUAL;

  PROCEDURE MERGE_EC_GOODS_CLASS_SUB IS
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
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_EC_GOODS_CLASS_SUB'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'DIM_EC_GOODS_CLASS_SUB'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO DIM_EC_GOODS_CLASS_SUB T
      USING (SELECT A.ID,
                    A.GC_ID,
                    A.NAME,
                    A.PIC,
                    A.DESCRIPTION,
                    A.SORT,
                    A.STATUS,
                    SYSDATE       W_INSERT_DT,
                    SYSDATE       W_UPDATE_DT
               FROM EC_GOODS_CLASS_SUB_TMP A) S
      ON (T.ID = S.ID)
      WHEN MATCHED THEN
        UPDATE
           SET T.GC_ID       = S.GC_ID,
               T.NAME        = S.NAME,
               T.PIC         = S.PIC,
               T.DESCRIPTION = S.DESCRIPTION,
               T.SORT        = S.SORT,
               T.STATUS      = S.STATUS,
               T.W_UPDATE_DT = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID,
           T.GC_ID,
           T.NAME,
           T.PIC,
           T.DESCRIPTION,
           T.SORT,
           T.STATUS,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID,
           S.GC_ID,
           S.NAME,
           S.PIC,
           S.DESCRIPTION,
           S.SORT,
           S.STATUS,
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
  END MERGE_EC_GOODS_CLASS_SUB;

  PROCEDURE MERGE_G_ACTIVITY IS
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
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_G_ACTIVITY'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'G_ACTIVITY'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO G_ACTIVITY T
      USING (SELECT A.ID_COL,
                    A.TITLE,
                    A.SHARE_TITLE,
                    A.SHARE_DESC,
                    A.SHARE_IMG,
                    A.ACTIVITY_NAME,
                    A.TRACE_PAGE_NAME,
                    A.CREATE_TIME,
                    A.BEGIN_TIME,
                    A.END_TIME,
                    A.FROM_COL,
                    A.ENABLE_COL,
                    A.AUTHOR_ID,
                    SYSDATE           W_INSERT_DT,
                    SYSDATE           W_UPDATE_DT
               FROM G_ACTIVITY_TMP A) S
      ON (T.ID_COL = S.ID_COL)
      WHEN MATCHED THEN
        UPDATE
           SET T.TITLE           = S.TITLE,
               T.SHARE_TITLE     = S.SHARE_TITLE,
               T.SHARE_DESC      = S.SHARE_DESC,
               T.SHARE_IMG       = S.SHARE_IMG,
               T.ACTIVITY_NAME   = S.ACTIVITY_NAME,
               T.TRACE_PAGE_NAME = S.TRACE_PAGE_NAME,
               T.CREATE_TIME     = S.CREATE_TIME,
               T.BEGIN_TIME      = S.BEGIN_TIME,
               T.END_TIME        = S.END_TIME,
               T.FROM_COL        = S.FROM_COL,
               T.ENABLE_COL      = S.ENABLE_COL,
               T.AUTHOR_ID       = S.AUTHOR_ID,
               T.W_UPDATE_DT     = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID_COL,
           T.TITLE,
           T.SHARE_TITLE,
           T.SHARE_DESC,
           T.SHARE_IMG,
           T.ACTIVITY_NAME,
           T.TRACE_PAGE_NAME,
           T.CREATE_TIME,
           T.BEGIN_TIME,
           T.END_TIME,
           T.FROM_COL,
           T.ENABLE_COL,
           T.AUTHOR_ID,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID_COL,
           S.TITLE,
           S.SHARE_TITLE,
           S.SHARE_DESC,
           S.SHARE_IMG,
           S.ACTIVITY_NAME,
           S.TRACE_PAGE_NAME,
           S.CREATE_TIME,
           S.BEGIN_TIME,
           S.END_TIME,
           S.FROM_COL,
           S.ENABLE_COL,
           S.AUTHOR_ID,
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
  END MERGE_G_ACTIVITY;

  PROCEDURE MERGE_G_ACTIVITY_GOODS IS
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
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_G_ACTIVITY_GOODS'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'G_ACTIVITY_GOODS'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO G_ACTIVITY_GOODS T
      USING (SELECT A.ID_COL,
                    A.GROUP_ID,
                    A.GOODS_NAME,
                    A.GOODS_COMMONID,
                    A.ITEM_CODE,
                    A.GOODS_JINGLE,
                    A.GOODS_JINGLE2,
                    A.GOODS_REDUCTION,
                    A.SUPERSCRIPT_IMAGE,
                    A.GOODS_IMAGE,
                    A.GOODS_PROMOTION_PRICE,
                    A.GOODS_MARKETPRICE,
                    A.GOODS_STORAGE,
                    A.GOODS_STATE,
                    A.GOODS_SALES,
                    A.ENABLE_COL,
                    A.CREATE_TIME,
                    A.UPDATE_TIME,
                    A.SORT_COL,
                    A.SALES_SORT,
                    A.SYNC_STATUS,
                    A.SYNC_TIME,
                    A.SYNC_ENABLE,
                    SYSDATE                 W_INSERT_DT,
                    SYSDATE                 W_UPDATE_DT
               FROM G_ACTIVITY_GOODS_TMP A) S
      ON (T.ID_COL = S.ID_COL)
      WHEN MATCHED THEN
        UPDATE
           SET T.GROUP_ID              = S.GROUP_ID,
               T.GOODS_NAME            = S.GOODS_NAME,
               T.GOODS_COMMONID        = S.GOODS_COMMONID,
               T.ITEM_CODE             = S.ITEM_CODE,
               T.GOODS_JINGLE          = S.GOODS_JINGLE,
               T.GOODS_JINGLE2         = S.GOODS_JINGLE2,
               T.GOODS_REDUCTION       = S.GOODS_REDUCTION,
               T.SUPERSCRIPT_IMAGE     = S.SUPERSCRIPT_IMAGE,
               T.GOODS_IMAGE           = S.GOODS_IMAGE,
               T.GOODS_PROMOTION_PRICE = S.GOODS_PROMOTION_PRICE,
               T.GOODS_MARKETPRICE     = S.GOODS_MARKETPRICE,
               T.GOODS_STORAGE         = S.GOODS_STORAGE,
               T.GOODS_STATE           = S.GOODS_STATE,
               T.GOODS_SALES           = S.GOODS_SALES,
               T.ENABLE_COL            = S.ENABLE_COL,
               T.CREATE_TIME           = S.CREATE_TIME,
               T.UPDATE_TIME           = S.UPDATE_TIME,
               T.SORT_COL              = S.SORT_COL,
               T.SALES_SORT            = S.SALES_SORT,
               T.SYNC_STATUS           = S.SYNC_STATUS,
               T.SYNC_TIME             = S.SYNC_TIME,
               T.SYNC_ENABLE           = S.SYNC_ENABLE,
               T.W_UPDATE_DT           = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID_COL,
           T.GROUP_ID,
           T.GOODS_NAME,
           T.GOODS_COMMONID,
           T.ITEM_CODE,
           T.GOODS_JINGLE,
           T.GOODS_JINGLE2,
           T.GOODS_REDUCTION,
           T.SUPERSCRIPT_IMAGE,
           T.GOODS_IMAGE,
           T.GOODS_PROMOTION_PRICE,
           T.GOODS_MARKETPRICE,
           T.GOODS_STORAGE,
           T.GOODS_STATE,
           T.GOODS_SALES,
           T.ENABLE_COL,
           T.CREATE_TIME,
           T.UPDATE_TIME,
           T.SORT_COL,
           T.SALES_SORT,
           T.SYNC_STATUS,
           T.SYNC_TIME,
           T.SYNC_ENABLE,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID_COL,
           S.GROUP_ID,
           S.GOODS_NAME,
           S.GOODS_COMMONID,
           S.ITEM_CODE,
           S.GOODS_JINGLE,
           S.GOODS_JINGLE2,
           S.GOODS_REDUCTION,
           S.SUPERSCRIPT_IMAGE,
           S.GOODS_IMAGE,
           S.GOODS_PROMOTION_PRICE,
           S.GOODS_MARKETPRICE,
           S.GOODS_STORAGE,
           S.GOODS_STATE,
           S.GOODS_SALES,
           S.ENABLE_COL,
           S.CREATE_TIME,
           S.UPDATE_TIME,
           S.SORT_COL,
           S.SALES_SORT,
           S.SYNC_STATUS,
           S.SYNC_TIME,
           S.SYNC_ENABLE,
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
  END MERGE_G_ACTIVITY_GOODS;

  PROCEDURE MERGE_G_ACTIVITY_GOODS_GROUP IS
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
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_G_ACTIVITY_GOODS_GROUP'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'G_ACTIVITY_GOODS_GROUP'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO G_ACTIVITY_GOODS_GROUP T
      USING (SELECT A.ID_COL,
                    A.ACTIVITY_ID,
                    A.TITLE,
                    A.CREATE_TIME,
                    A.UPDATE_TIME,
                    A.CUSTOMED_SUPERSCRIPT,
                    A.IMAGE_SRC,
                    A.METHOD,
                    SYSDATE                W_INSERT_DT,
                    SYSDATE                W_UPDATE_DT
               FROM G_ACTIVITY_GOODS_GROUP_TMP A) S
      ON (T.ID_COL = S.ID_COL)
      WHEN MATCHED THEN
        UPDATE
           SET T.ACTIVITY_ID          = S.ACTIVITY_ID,
               T.TITLE                = S.TITLE,
               T.CREATE_TIME          = S.CREATE_TIME,
               T.UPDATE_TIME          = S.UPDATE_TIME,
               T.CUSTOMED_SUPERSCRIPT = S.CUSTOMED_SUPERSCRIPT,
               T.IMAGE_SRC            = S.IMAGE_SRC,
               T.METHOD               = S.METHOD,
               T.W_UPDATE_DT          = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID_COL,
           T.ACTIVITY_ID,
           T.TITLE,
           T.CREATE_TIME,
           T.UPDATE_TIME,
           T.CUSTOMED_SUPERSCRIPT,
           T.IMAGE_SRC,
           T.METHOD,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID_COL,
           S.ACTIVITY_ID,
           S.TITLE,
           S.CREATE_TIME,
           S.UPDATE_TIME,
           S.CUSTOMED_SUPERSCRIPT,
           S.IMAGE_SRC,
           S.METHOD,
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
  END MERGE_G_ACTIVITY_GOODS_GROUP;

  PROCEDURE MERGE_G_ACTIVITY_VOUCHER IS
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
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_G_ACTIVITY_VOUCHER'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'G_ACTIVITY_VOUCHER'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO G_ACTIVITY_VOUCHER T
      USING (SELECT A.ID_COL,
                    A.ACTIVITY_ID,
                    A.VOUCHER_ID,
                    A.VOUCHER_KEY,
                    A.CREATE_TIME,
                    A.UPDATE_TIME,
                    SYSDATE       W_INSERT_DT,
                    SYSDATE       W_UPDATE_DT
               FROM G_ACTIVITY_VOUCHER_TMP A) S
      ON (T.ID_COL = S.ID_COL)
      WHEN MATCHED THEN
        UPDATE
           SET T.ACTIVITY_ID = S.ACTIVITY_ID,
               T.VOUCHER_ID  = S.VOUCHER_ID,
               T.VOUCHER_KEY = S.VOUCHER_KEY,
               T.CREATE_TIME = S.CREATE_TIME,
               T.UPDATE_TIME = S.UPDATE_TIME,
               T.W_UPDATE_DT = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID_COL,
           T.ACTIVITY_ID,
           T.VOUCHER_ID,
           T.VOUCHER_KEY,
           T.CREATE_TIME,
           T.UPDATE_TIME,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID_COL,
           S.ACTIVITY_ID,
           S.VOUCHER_ID,
           S.VOUCHER_KEY,
           S.CREATE_TIME,
           S.UPDATE_TIME,
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
  END MERGE_G_ACTIVITY_VOUCHER;

  PROCEDURE MERGE_GOODS_EVALUATE_ALIYUN IS
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
    SP_NAME          := 'HAPPIGO_EC_PKG.MERGE_GOODS_EVALUATE_ALIYUN'; --需要手工填入所写PROCEDURE的名称
    S_ETL.TABLE_NAME := 'FACT_GOODS_EVALUATE_ALIYUN'; --此处需要手工录入该PROCEDURE操作的表格
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
      INTO FACT_GOODS_EVALUATE_ALIYUN T
      USING (SELECT A.ID_COL,
                    A.GEVAL_ID,
                    A.GEVAL_ORDERGOODSID,
                    A.GEVAL_GOODSID,
                    A.ASPECT_CATEGORY,
                    A.ASPECT_TERM,
                    A.ASPECT_INDEX,
                    A.ASPECT_POLARITY,
                    A.OPINION_TERM,
                    A.CREATE_TIME,
                    SYSDATE              W_INSERT_DT,
                    SYSDATE              W_UPDATE_DT
               FROM FACT_GOODS_EVALUATE_ALI_TMP A) S
      ON (T.ID_COL = S.ID_COL)
      WHEN MATCHED THEN
        UPDATE
           SET T.GEVAL_ID           = S.GEVAL_ID,
               T.GEVAL_ORDERGOODSID = S.GEVAL_ORDERGOODSID,
               T.GEVAL_GOODSID      = S.GEVAL_GOODSID,
               T.ASPECT_CATEGORY    = S.ASPECT_CATEGORY,
               T.ASPECT_TERM        = S.ASPECT_TERM,
               T.ASPECT_INDEX       = S.ASPECT_INDEX,
               T.ASPECT_POLARITY    = S.ASPECT_POLARITY,
               T.OPINION_TERM       = S.OPINION_TERM,
               T.CREATE_TIME        = S.CREATE_TIME,
               T.W_UPDATE_DT        = S.W_UPDATE_DT
      WHEN NOT MATCHED THEN
        INSERT
          (T.ID_COL,
           T.GEVAL_ID,
           T.GEVAL_ORDERGOODSID,
           T.GEVAL_GOODSID,
           T.ASPECT_CATEGORY,
           T.ASPECT_TERM,
           T.ASPECT_INDEX,
           T.ASPECT_POLARITY,
           T.OPINION_TERM,
           T.CREATE_TIME,
           T.W_INSERT_DT,
           T.W_UPDATE_DT)
        VALUES
          (S.ID_COL,
           S.GEVAL_ID,
           S.GEVAL_ORDERGOODSID,
           S.GEVAL_GOODSID,
           S.ASPECT_CATEGORY,
           S.ASPECT_TERM,
           S.ASPECT_INDEX,
           S.ASPECT_POLARITY,
           S.OPINION_TERM,
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
  END MERGE_GOODS_EVALUATE_ALIYUN;

END HAPPIGO_EC_PKG;
/
