
/*
ec_order
ec_order_goods
ec_order_common
ec_p_xianshi
ec_p_xianshi_goods
ec_p_mansong
ec_p_mansong_goods
ec_voucher
ec_voucher_batch
ec_voucher_price

-----------------
ec_order.add_time
ec_order_goods.order_id
ec_order_common.order_id
ec_p_xianshi.xianshi_time
ec_p_xianshi_goods.xianshi_goods_id
ec_p_mansong.start_time
ec_p_mansong_goods.lastupdate_time
ec_voucher.voucher_active_date
ec_voucher_batch.voucher_active_date
ec_voucher_price.voucher_price_id
ec_p_memberlevel_discount*
ec_p_memberlevel_discount_goods*

���ʹ�����������
��ʱ��������Ʒ��
goods_price-goods_pay_price=��Ʒ�������
��Ʒ�������-apportion_price=��˾����
֧������ ��һ����������,�ǹ̶��ģ���Ӫ��������
����������Ӫ���Ƶ�
�ȼ��������ǹ�˾������
order_goods.pml_discount��Ա�ȼ������



*/

--��mysqlȡ���ȷ�����ʱ��Ȼ��������ʱ��ȥ������ʽ��
/*create table ec_order_2_tmp as
select * from fact_ec_order_2;

create table ec_order_goods_tmp as
SELECT * FROM fact_ec_order_goods;

create table ec_order_common_tmp as
SELECT * FROM fact_ec_order_common;

create table ec_p_xianshi_tmp as
SELECT * FROM fact_ec_p_xianshi;

create table ec_p_xianshi_goods_tmp as
SELECT * FROM fact_ec_p_xianshi_goods;

create table ec_p_mansong_tmp as
SELECT * FROM fact_ec_p_mansong;

create table ec_p_mansong_goods_tmp as
SELECT * FROM fact_ec_p_mansong_goods;

create table ec_voucher_tmp as
SELECT * FROM fact_ec_voucher;

create table ec_voucher_batch_tmp as
SELECT * FROM fact_ec_voucher_batch;

create table ec_voucher_price_tmp as
SELECT * FROM fact_ec_voucher_price;*/

--
SELECT * FROM ec_order_2_tmp;
SELECT * FROM ec_order_goods_tmp;
SELECT * FROM ec_order_common_tmp;
SELECT * FROM ec_p_xianshi_tmp;
SELECT * FROM ec_p_xianshi_goods_tmp;
SELECT * FROM ec_p_mansong_tmp;
SELECT * FROM ec_p_mansong_goods_tmp;
SELECT * FROM ec_voucher_tmp;
SELECT * FROM ec_voucher_batch_tmp;
SELECT * FROM ec_voucher_price_tmp;

--
SELECT * FROM fact_ec_order_2;
SELECT * FROM fact_ec_order_goods;
SELECT * FROM fact_ec_order_common;
SELECT * FROM fact_ec_p_xianshi;
SELECT * FROM fact_ec_p_xianshi_goods;
SELECT * FROM fact_ec_p_mansong;
SELECT * FROM fact_ec_p_mansong_goods;
SELECT * FROM fact_ec_voucher;
SELECT * FROM fact_ec_voucher_batch;
SELECT * FROM fact_ec_voucher_price;

SELECT COUNT(1) FROM fact_ec_order_2;
SELECT COUNT(1) FROM fact_ec_order_goods;
SELECT COUNT(1) FROM fact_ec_order_common;
SELECT COUNT(1) FROM fact_ec_p_xianshi;
SELECT COUNT(1) FROM fact_ec_p_xianshi_goods;
SELECT COUNT(1) FROM fact_ec_p_mansong;
SELECT COUNT(1) FROM fact_ec_p_mansong_goods;
SELECT COUNT(1) FROM fact_ec_voucher;
SELECT COUNT(1) FROM fact_ec_voucher_batch;
SELECT COUNT(1) FROM fact_ec_voucher_price;

SELECT COUNT(1) FROM ec_order_2_tmp;
SELECT COUNT(1) FROM ec_order_goods_tmp;
SELECT COUNT(1) FROM ec_order_common_tmp;
SELECT COUNT(1) FROM ec_p_xianshi_tmp;
SELECT COUNT(1) FROM ec_p_xianshi_goods_tmp;
SELECT COUNT(1) FROM ec_p_mansong_tmp;
SELECT COUNT(1) FROM ec_p_mansong_goods_tmp;
SELECT COUNT(1) FROM ec_voucher_tmp;
SELECT COUNT(1) FROM ec_voucher_batch_tmp;
SELECT COUNT(1) FROM ec_voucher_price_tmp;

select round(order_id, -5), count(1)
  from fact_ec_order_2
 group by round(order_id, -5)
 order by 1;

--report
--��Ʒ������
CREATE TABLE OPER_NM_PROMOTION_ITEM_REPORT AS
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME,
         X.XIANSHI_NAME PROMOTION_NAME, --��������
         CASE
           WHEN X.XIANSHI_TYPE = 1 THEN
            '��ʱֱ��'
           WHEN X.XIANSHI_TYPE = 2 THEN
            '��ʱ��'
           WHEN X.XIANSHI_TYPE = 3 THEN
            'TVֱ��'
         END PROMOTION_TYPE, --��������
         CASE
           WHEN X.CRM_POLICY_ID = '0' THEN
            '��ý��'
           WHEN X.CRM_POLICY_ID <> '0' THEN
            'ͬ������'
         END PROMOTION_SOURCE, --������Դ
         X.CRM_POLICY_ID PROMOTION_NO, --�������
         CASE
           WHEN OH.APP_NAME = 'KLGiPhone' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGAndroid' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGMPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGWX' THEN
            '΢��'
           WHEN OH.APP_NAME = 'undefined' THEN
            'δ֪'
         END PATHWAY, --ͨ·
         OG.ERP_CODE ITEM_CODE, --��Ʒ����
         OG.GOODS_NAME ITEM_NAME, --��Ʒ����
         OG.GOODS_NUM SALES_QTY, --��Ч��������
         OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, --��Ʒ��Ч��� 
         (OG.GOODS_PRICE - OG.GOODS_PAY_PRICE - OG.APPORTION_PRICE) *
         OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, --��˾����
         OG.APPORTION_PRICE * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, --��Ӧ������
         OG.SUPPLIER_ID, --��Ӧ�̱���
         (OG.GOODS_PRICE - OG.GOODS_PAY_PRICE) * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT,
         TO_CHAR(OH.ORDER_SN) ORDER_SN --��������
    FROM FACT_EC_ORDER_2 OH,
         /*FACT_EC_ORDER_COMMON    OC,*/
         FACT_EC_ORDER_GOODS     OG,
         FACT_EC_P_XIANSHI       X,
         FACT_EC_P_XIANSHI_GOODS XG
   WHERE /*OH.ORDER_ID = OC.ORDER_ID
         AND*/
   OH.ORDER_ID = OG.ORDER_ID
   AND OG.XIANSHI_GOODS_ID = XG.XIANSHI_GOODS_ID
   AND X.XIANSHI_ID = XG.XIANSHI_ID
  /*��Ч��������*/
   AND OH.ORDER_STATE >= 30
   AND OH.REFUND_STATE = 0
  /*AND TRUNC(OH.ADD_TIME) = DATE '2017-09-17'*/
  ;

--��Ʒ������-�ȼ���
SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*��������*/
       OG.PML_TITLE PROMOTION_NAME, /*��������*/
       '�ȼ���' PROMOTION_TYPE, /*��������*/
       '��ý��' PROMOTION_SOURCE, /*������Դ*/
       OG.PML_ID PROMOTION_NO, /*�������*/
       CASE
         WHEN OH.APP_NAME = 'KLGiPhone' THEN
          'APP'
         WHEN OH.APP_NAME = 'KLGAndroid' THEN
          'APP'
         WHEN OH.APP_NAME = 'KLGPortal' THEN
          'WEB'
         WHEN OH.APP_NAME = 'KLGMPortal' THEN
          'WEB'
         WHEN OH.APP_NAME = 'KLGWX' THEN
          '΢��'
         WHEN OH.APP_NAME = 'undefined' THEN
          'δ֪'
       END PATHWAY, /*ͨ·*/
       OG.ERP_CODE ITEM_CODE, /*��Ʒ����*/
       OG.GOODS_NAME ITEM_NAME, /*��Ʒ����*/
       OG.GOODS_NUM SALES_QTY, /*��Ч��������*/
       OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, /*��Ʒ��Ч���*/
       OG.PML_DISCOUNT * OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, /*��˾����*/
       NVL(OG.APPORTION_PRICE, 0) * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, /*��Ӧ������*/
       OG.SUPPLIER_ID, /*��Ӧ�̱���*/
       OG.PML_DISCOUNT * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT, /*�����ܳɱ�*/
       TO_CHAR(OH.ORDER_SN) ORDER_SN /*��������*/
  FROM FACT_EC_ORDER_2         OH,
       FACT_EC_ORDER_GOODS     OG
 WHERE OH.ORDER_ID = OG.ORDER_ID
      /*��Ч��������*/
   AND OH.ORDER_STATE >= 30
   AND OH.REFUND_STATE = 0
	 AND OG.PML_DISCOUNT<>0
   AND TRUNC(OH.ADD_TIME) = &IN_POSTING_DATE;

--��Ʒ������-�ȼ���-��ʷ���ݲ�ȫ
INSERT INTO OPER_NM_PROMOTION_ITEM_REPORT
  (ADD_TIME,
   PROMOTION_NAME,
   PROMOTION_TYPE,
   PROMOTION_SOURCE,
   PROMOTION_NO,
   PATHWAY,
   ITEM_CODE,
   ITEM_NAME,
   SALES_QTY,
   SALES_AMOUNT,
   COMPANY_APPORTION_AMOUNT,
   SUPP_APPORTION_AMOUNT,
   SUPPLIER_ID,
   TOTAL_APPORTION_AMOUNT,
   ORDER_SN)
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*��������*/
         OG.PML_TITLE PROMOTION_NAME, /*��������*/
         '�ȼ���' PROMOTION_TYPE, /*��������*/
         '��ý��' PROMOTION_SOURCE, /*������Դ*/
         OG.PML_ID PROMOTION_NO, /*�������*/
         CASE
           WHEN OH.APP_NAME = 'KLGiPhone' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGAndroid' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGMPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGWX' THEN
            '΢��'
           WHEN OH.APP_NAME = 'undefined' THEN
            'δ֪'
         END PATHWAY, /*ͨ·*/
         OG.ERP_CODE ITEM_CODE, /*��Ʒ����*/
         OG.GOODS_NAME ITEM_NAME, /*��Ʒ����*/
         OG.GOODS_NUM SALES_QTY, /*��Ч��������*/
         OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, /*��Ʒ��Ч���*/
         OG.PML_DISCOUNT * OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, /*��˾����*/
         NVL(OG.APPORTION_PRICE, 0) * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, /*��Ӧ������*/
         OG.SUPPLIER_ID, /*��Ӧ�̱���*/
         OG.PML_DISCOUNT * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT, /*�����ܳɱ�*/
         TO_CHAR(OH.ORDER_SN) ORDER_SN /*��������*/
    FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
   WHERE OH.ORDER_ID = OG.ORDER_ID
        /*��Ч��������*/
     AND OH.ORDER_STATE >= 30
     AND OH.REFUND_STATE = 0
     AND OG.PML_DISCOUNT <> 0
   ORDER BY TRUNC(OH.ADD_TIME), OG.ERP_CODE;

--��Ʒ������-TVֱ����������-��ʷ���벹��
INSERT INTO OPER_NM_PROMOTION_ITEM_REPORT
  (ADD_TIME,
   PROMOTION_NAME,
   PROMOTION_TYPE,
   PROMOTION_SOURCE,
   PROMOTION_NO,
   PATHWAY,
   ITEM_CODE,
   ITEM_NAME,
   SALES_QTY,
   SALES_AMOUNT,
   COMPANY_APPORTION_AMOUNT,
   SUPP_APPORTION_AMOUNT,
   SUPPLIER_ID,
   TOTAL_APPORTION_AMOUNT,
   ORDER_SN)
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME, /*��������*/
         '��վ�������߶���ֱ����Ʒ����' PROMOTION_NAME, /*��������*/
         'TVֱ������' PROMOTION_TYPE, /*��������*/
         '��ý��' PROMOTION_SOURCE, /*������Դ*/
         '' PROMOTION_NO, /*�������*/
         CASE
           WHEN OH.APP_NAME = 'KLGiPhone' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGAndroid' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGMPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGWX' THEN
            '΢��'
           WHEN OH.APP_NAME = 'undefined' THEN
            'δ֪'
         END PATHWAY, /*ͨ·*/
         OG.ERP_CODE ITEM_CODE, /*��Ʒ����*/
         OG.GOODS_NAME ITEM_NAME, /*��Ʒ����*/
         OG.GOODS_NUM SALES_QTY, /*��Ч��������*/
         OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, /*��Ʒ��Ч���*/
         OG.TV_DISCOUNT_AMOUNT * OG.GOODS_NUM COMPANY_APPORTION_AMOUNT, /*��˾����*/
         NVL(OG.APPORTION_PRICE, 0) * OG.GOODS_NUM SUPP_APPORTION_AMOUNT, /*��Ӧ������*/
         OG.SUPPLIER_ID, /*��Ӧ�̱���*/
         OG.TV_DISCOUNT_AMOUNT * OG.GOODS_NUM TOTAL_APPORTION_AMOUNT, /*�����ܳɱ�*/
         TO_CHAR(OH.ORDER_SN) ORDER_SN /*��������*/
    FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
   WHERE OH.ORDER_ID = OG.ORDER_ID
        /*��Ч��������*/
     AND OH.ORDER_STATE >= 30
     AND OH.REFUND_STATE = 0
     AND OG.TV_DISCOUNT_AMOUNT <> 0
     AND TRUNC(OH.ADD_TIME) BETWEEN DATE '2017-01-01' AND DATE
   '2017-11-06';
COMMIT;


--����������
/*MANSONG_NAME*/
CREATE TABLE OPER_NM_PROMOTION_ORDER_REPORT AS
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME,
         TO_CHAR(OH.ORDER_SN) ORDER_SN,
         M.MANSONG_NAME PROMOTION_NAME,
         CASE
           WHEN OH.APP_NAME = 'KLGiPhone' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGAndroid' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGMPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGWX' THEN
            '΢��'
           WHEN OH.APP_NAME = 'undefined' THEN
            'δ֪'
         END PATHWAY, --ͨ·
         '������' PROMONTION_TYPE,
         OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, --��Ʒ��Ч��� 
         OH.DISCOUNT_MANSONG_AMOUNT
    FROM FACT_EC_ORDER_2         OH,
         FACT_EC_ORDER_GOODS     OG,
         FACT_EC_P_MANSONG       M,
         FACT_EC_P_MANSONG_GOODS MG
   WHERE OH.ORDER_ID = OG.ORDER_ID
     AND OH.DISCOUNT_MANSONG_ID = M.MANSONG_ID
     AND M.MANSONG_ID = MG.MANSONG_ID
        /*��Ч��������*/
     AND OH.ORDER_STATE >= 30
     AND OH.REFUND_STATE = 0
     AND OH.DISCOUNT_MANSONG_AMOUNT <> 0
     AND TRUNC(OH.ADD_TIME) = DATE '2017-09-18'
  UNION ALL
  /*DISCOUNT_PAYMENTWAY_DESC*/
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME,
         TO_CHAR(OH.ORDER_SN) ORDER_SN,
         OH.DISCOUNT_PAYMENTWAY_DESC,
         CASE
           WHEN OH.APP_NAME = 'KLGiPhone' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGAndroid' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGMPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGWX' THEN
            '΢��'
           WHEN OH.APP_NAME = 'undefined' THEN
            'δ֪'
         END PATHWAY, --ͨ·
         '֧������' PROMONTION_TYPE,
         OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, --��Ʒ��Ч��� 
         OH.DISCOUNT_PAYMENTWAY_AMOUNT
    FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG /*,
             FACT_EC_P_MANSONG       M,
             FACT_EC_P_MANSONG_GOODS MG*/
   WHERE OH.ORDER_ID = OG.ORDER_ID
        /*AND OH.DISCOUNT_MANSONG_ID = M.MANSONG_ID
        AND M.MANSONG_ID = MG.MANSONG_ID*/
        /*��Ч��������*/
     AND OH.ORDER_STATE >= 30
     AND OH.REFUND_STATE = 0
     AND OH.DISCOUNT_PAYMENTWAY_AMOUNT <> 0
     AND TRUNC(OH.ADD_TIME) = DATE '2017-09-18'
  UNION ALL
  /*DISCOUNT_PAYMENTCHANEL_DESC*/
  SELECT TRUNC(OH.ADD_TIME) ADD_TIME,
         TO_CHAR(OH.ORDER_SN) ORDER_SN,
         OH.DISCOUNT_PAYMENTCHANEL_DESC,
         CASE
           WHEN OH.APP_NAME = 'KLGiPhone' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGAndroid' THEN
            'APP'
           WHEN OH.APP_NAME = 'KLGPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGMPortal' THEN
            'WEB'
           WHEN OH.APP_NAME = 'KLGWX' THEN
            '΢��'
           WHEN OH.APP_NAME = 'undefined' THEN
            'δ֪'
         END PATHWAY, --ͨ·
         '֧������' PROMONTION_TYPE,
         OG.GOODS_NUM * OG.GOODS_PAY_PRICE SALES_AMOUNT, --��Ʒ��Ч��� 
         OH.DISCOUNT_PAYMENTCHANEL_AMOUNT
    FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG /*,
             FACT_EC_P_MANSONG       M,
             FACT_EC_P_MANSONG_GOODS MG*/
   WHERE OH.ORDER_ID = OG.ORDER_ID
        /*AND OH.DISCOUNT_MANSONG_ID = M.MANSONG_ID
        AND M.MANSONG_ID = MG.MANSONG_ID*/
        /*��Ч��������*/
     AND OH.ORDER_STATE >= 30
     AND OH.REFUND_STATE = 0
     AND OH.DISCOUNT_PAYMENTCHANEL_AMOUNT <> 0
     AND TRUNC(OH.ADD_TIME) = DATE '2017-09-18';

--�Ż�ȯ
CREATE TABLE OPER_NM_VOUCHER_REPORT AS
  SELECT V.VOUCHER_T_ID,
         V.COUPON_TV_ID,
         V.VOUCHER_TITLE,
         V.VOUCHER_TYPE,
         V.VOUCHER_PRICE,
         V.VOUCHER_START_DATE,
         V.VOUCHER_END_DATE,
         NVL(V.SEND_VOUCHER_COUNT, 0) SEND_VOUCHER_COUNT,
         NVL(O.USED_VOUCHER_COUNT, 0) USED_VOUCHER_COUNT,
         ROUND(NVL(O.USED_VOUCHER_COUNT, 0) / NVL(V.SEND_VOUCHER_COUNT, 0),
               4) USED_VOUCHER_RATE,
         NVL(O.VOUCHER_COST, 0) VOUCHER_COST,
         NVL(O.ORDER_AMOUNT, 0) ORDER_AMOUNT
    FROM (SELECT A.VOUCHER_T_ID,
                 A.COUPON_TV_ID,
                 A.VOUCHER_TITLE,
                 CASE
                   WHEN A.COUPON_TV_ID IS NULL THEN
                    '��ý��ȯ'
                   ELSE
                    'TVȯ'
                 END VOUCHER_TYPE,
                 A.VOUCHER_PRICE,
                 TRUNC(A.VOUCHER_START_DATE) VOUCHER_START_DATE,
                 TRUNC(A.VOUCHER_END_DATE) VOUCHER_END_DATE,
                 COUNT(A.VOUCHER_CODE) SEND_VOUCHER_COUNT
            FROM FACT_EC_VOUCHER A
           GROUP BY A.VOUCHER_T_ID,
                    A.COUPON_TV_ID,
                    A.VOUCHER_TITLE,
                    A.VOUCHER_PRICE,
                    TRUNC(A.VOUCHER_START_DATE),
                    TRUNC(A.VOUCHER_END_DATE)) V,
         (SELECT A.VOUCHER_REF VOUCHER_T_ID,
                 TRUNC(A.VOUCHER_START_DATE) VOUCHER_START_DATE,
                 TRUNC(A.VOUCHER_END_DATE) VOUCHER_END_DATE,
                 COUNT(A.VOUCHER_CODE) USED_VOUCHER_COUNT,
                 SUM(A.VOUCHER_PRICE) VOUCHER_COST,
                 SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
            FROM FACT_EC_ORDER_COMMON A, FACT_EC_ORDER_2 B
           WHERE A.ORDER_ID = B.ORDER_ID
             AND B.ORDER_STATE >= 30
             AND B.REFUND_STATE = 0
             AND A.VOUCHER_REF IS NOT NULL
           GROUP BY A.VOUCHER_REF,
                    TRUNC(A.VOUCHER_START_DATE),
                    TRUNC(A.VOUCHER_END_DATE)) O
   WHERE V.VOUCHER_T_ID = O.VOUCHER_T_ID(+)
     AND V.VOUCHER_START_DATE = O.VOUCHER_START_DATE(+)
     AND V.VOUCHER_END_DATE = O.VOUCHER_END_DATE(+)
   ORDER BY V.VOUCHER_T_ID, V.VOUCHER_START_DATE, V.VOUCHER_END_DATE;

SELECT *
  FROM FACT_EC_ORDER_COMMON A
 WHERE A.VOUCHER_CODE = 'XTV2006838202';
SELECT * FROM FACT_EC_ORDER_2 A WHERE A.ORDER_ID = 443;
SELECT * FROM FACT_EC_VOUCHER A WHERE A.VOUCHER_CODE = 'XTV2006838202';

TRUNCATE TABLE OPER_NM_PROMOTION_ITEM_REPORT;
TRUNCATE TABLE OPER_NM_PROMOTION_ORDER_REPORT;
TRUNCATE TABLE OPER_NM_VOUCHER_REPORT;
