/*Consumption characteristics indicators 
��������ָ��*/

--************************************************************************
--�½���ǩ
--************************************************************************
begin
  -- Call the procedure
  member_label_pkg.create_member_label(in_m_label_name      => 'FIRST_ORDER_BBC',
                                       in_m_label_desc      => '�׵�ΪBBC��Ʒ',
                                       in_m_label_type_id   => 1,
                                       in_m_label_father_id => 41);
end;
/
  SELECT * FROM MEMBER_LABEL_HEAD A ORDER BY A.M_LABEL_ID;

--************************************************************************
--ֱ����Ʒ�ҳ϶�(PRODUCT_LOYALTY)
--************************************************************************
/*
ֻ�򲥳���Ʒ(ONLY_BROADCAST)
ֻ��TV��Ʒ(ONLY_TV)
ֻ������ᱨ��Ʒ(ONLY_ONLINE_RETAIL)
ֻ����Ӫ��Ʒ(SELF_SALES)
ֻ�����Ӫ��Ʒ(NON_SELF_SALES)
�����(MIXED_CUSTOMER)
*/
INSERT INTO MEMBER_LABEL_HEAD
  (M_LABEL_ID,
   M_LABEL_NAME,
   M_LABEL_DESC,
   M_LABEL_TYPE_ID,
   M_LABEL_FATHER_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID,
   CURRENT_FLAG)
  SELECT MEMBER_LABEL_HEAD_SEQ.NEXTVAL, /*M_LABEL_ID*/
         'MIXED_CUSTOMER', /*M_LABEL_NAME*/
         '�����', /*M_LABEL_DESC*/
         null, /*M_LABEL_TYPE_ID*/
         2, /*M_LABEL_FATHER_ID*/
         sysdate, /*CREATE_DATE*/
         'yangjin', /*CREATE_USER_ID*/
         sysdate, /*LAST_UPDATE_DATE*/
         'yangjin', /*LAST_UPDATE_USER_ID*/
         1 /*CURRENT_FLAG*/
    FROM DUAL;

--ֻ�򲥳���Ʒ(ONLY_BROADCAST)
INSERT INTO MEMBER_LABEL_LINK
  (MEMBER_KEY,
   M_LABEL_ID,
   M_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID)
  SELECT D.MEMBER_KEY,
         3 M_LABEL_ID,
         1 M_LABEL_TYPE_ID,
         SYSDATE CREATE_DATE,
         'yangjin' CREATE_USER_ID,
         SYSDATE LAST_UPDATE_DATE,
         'yangjin' LAST_UPDATE_USER_ID
    FROM (SELECT C.MEMBER_KEY,
                 COUNT(C.ITEM_CODE) ITEM_COUNT,
                 COUNT(CASE
                         WHEN C.IS_BCST = 1 THEN
                          1
                         ELSE
                          NULL
                       END) BCST_ITEM_COUNT,
                 COUNT(DISTINCT C.ORDER_KEY) ORDER_COUNT
            FROM (SELECT SALES.POSTING_DATE_KEY,
                         SALES.ORDER_KEY,
                         SALES.MEMBER_KEY,
                         SALES.GOODS_COMMON_KEY ITEM_CODE,
                         NVL(TV_GOOD.IS_BCST, 0) IS_BCST
                    FROM (SELECT DISTINCT A.POSTING_DATE_KEY,
                                          A.ORDER_KEY,
                                          A.MEMBER_KEY,
                                          A.GOODS_COMMON_KEY
                            FROM FACT_GOODS_SALES A
                           WHERE A.POSTING_DATE_KEY >=
                                 TO_CHAR(TRUNC(SYSDATE - 181), 'YYYYMMDD')
                             AND A.ORDER_STATE = 1
                             AND A.TRAN_TYPE = 0) SALES,
                         (SELECT B.ITEM_CODE, B.TV_STARTDAY_KEY, 1 IS_BCST /*�Ƿ񲥳�*/
                            FROM DIM_TV_GOOD B
                           WHERE B.IS_LIVE = 'ֱ��'
                             AND B.TV_STARTDAY_KEY >=
                                 TO_CHAR(TRUNC(SYSDATE - 181), 'YYYYMMDD')) TV_GOOD
                   WHERE SALES.POSTING_DATE_KEY = TV_GOOD.TV_STARTDAY_KEY(+)
                     AND SALES.GOODS_COMMON_KEY = TV_GOOD.ITEM_CODE(+)) C
           GROUP BY C.MEMBER_KEY) D
   WHERE /*�û�������������4��ʱ����*/
   D.ORDER_COUNT >= 4
  /*������Ʒ�ﵽ70%�����ǲ�����Ʒʱ��Ϊ��ֻ�򲥳���Ʒ�û�*/
   AND D.BCST_ITEM_COUNT / D.ITEM_COUNT >= 0.7;

--************************************************************************
--���ö˿�(Common port)
--************************************************************************
/*
APP(COMMON_PORT_APP)(10,20,)
΢��(COMMON_PORT_WX)(50)
WAP(COMMON_PORT_WAP)(30)
PC(COMMON_PORT_PC)(40)
�޹���(COMMON_PORT_VARIETY)
*/
--fact_session.application_key
INSERT INTO MEMBER_LABEL_LINK
  (MEMBER_KEY,
   M_LABEL_ID,
   M_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID)
  SELECT F.MEMBER_KEY,
         G.M_LABEL_ID,
         G.M_LABEL_TYPE_ID,
         SYSDATE CREATE_DATE,
         'yangjin' CREATE_USER_ID,
         sysdate LAST_UPDATE_DATE,
         'yangjin' LAST_UPDATE_USER_ID
    FROM (SELECT E.MEMBER_KEY, SUBSTR(MAX(E.MAX_PER_PORT), 3) COMMON_PORT
            FROM (SELECT D.MEMBER_KEY,
                         D.COMMON_PORT,
                         D.FREQ,
                         D.TOTAL_FREQ,
                         D.FREQ / D.TOTAL_FREQ PORT_PER,
                         CASE
                           WHEN D.FREQ / D.TOTAL_FREQ >= 0.7 THEN
                            '2_' || D.COMMON_PORT
                           ELSE
                            '1_COMMON_PORT_VARIETY'
                         END MAX_PER_PORT
                    FROM (SELECT C.MEMBER_KEY,
                                 C.COMMON_PORT,
                                 C.FREQ,
                                 SUM(C.FREQ) OVER(PARTITION BY C.MEMBER_KEY) TOTAL_FREQ
                            FROM (SELECT B.MEMBER_KEY,
                                         B.COMMON_PORT,
                                         COUNT(1) FREQ
                                    FROM (SELECT A.MEMBER_KEY,
                                                 DECODE(A.APPLICATION_KEY,
                                                        10,
                                                        'COMMON_PORT_APP',
                                                        20,
                                                        'COMMON_PORT_APP',
                                                        30,
                                                        'COMMON_PORT_WAP',
                                                        40,
                                                        'COMMON_PORT_PC',
                                                        50,
                                                        'COMMON_PORT_WX') COMMON_PORT
                                            FROM FACT_SESSION A
                                           WHERE A.START_DATE_KEY BETWEEN
                                                 TO_CHAR(TRUNC(SYSDATE - 180),
                                                         'YYYYMMDD') AND
                                                 TO_CHAR(TRUNC(SYSDATE - 1),
                                                         'YYYYMMDD')
                                             AND A.MEMBER_KEY <> 0) B
                                   WHERE B.COMMON_PORT IS NOT NULL
                                   GROUP BY B.MEMBER_KEY, B.COMMON_PORT) C) D
                   WHERE D.TOTAL_FREQ >= 4) E
           GROUP BY E.MEMBER_KEY) F,
         MEMBER_LABEL_HEAD G
   WHERE G.M_LABEL_FATHER_ID = 21
     AND F.COMMON_PORT = G.M_LABEL_NAME;

--************************************************************************
--�׵�״̬(first order)
--************************************************************************     
/*
δ�����׵�(first_order_not)
�׵�Ϊ������(first_order_gift)(�����������30Ԫ����������)
�׵�ΪTV������Ʒ(first_order_broadcast)
�׵�ΪTV�ǲ�����Ʒ(first_order_not_broadcast)
�׵�Ϊ��Ӫ��Ʒ(first_order_self)
�׵�ΪBBC��Ʒ(first_order_BBC)
�׵���ǩӦ��ÿ��ˢ�£���һ���û�ע��֮�󣬾�Ӧ�ô����׵���ǩ����һ���û���һ�ζ���֮���׵���ǩ�Ͳ����ٱ䶯�ˡ�
��Ӫ��Ʒֻ�ڵ�������
������������Ȼ�����������ǩ��
*/
INSERT INTO MEMBER_LABEL_LINK
  (MEMBER_KEY,
   M_LABEL_ID,
   M_LABEL_TYPE_ID,
   CREATE_DATE,
   CREATE_USER_ID,
   LAST_UPDATE_DATE,
   LAST_UPDATE_USER_ID)
  SELECT D.MEMBER_KEY,
         E.M_LABEL_ID,
         E.M_LABEL_TYPE_ID,
         SYSDATE CREATE_DATE,
         'yangjin' CREATE_USER_ID,
         SYSDATE LAST_UPDATE_DATE,
         'yangjin' LAST_UPDATE_USER_ID
    FROM (SELECT A.MEMBER_KEY
            FROM FACT_VISITOR_REGISTER A
           WHERE A.MEMBER_KEY <> 0
             AND A.CREATE_DATE_KEY = &IN_POSTING_DATE_KEY
             AND NOT EXISTS (SELECT 1
                    FROM (SELECT C.MEMBER_KEY
                            FROM FACT_GOODS_SALES C
                           WHERE C.ORDER_STATE = 1) B
                   WHERE A.MEMBER_KEY = B.MEMBER_KEY)) D,
         MEMBER_LABEL_HEAD E
   WHERE E.M_LABEL_NAME = 'FIRST_ORDER_NOT';

--�׵��������������Ʒ
SELECT A.MEMBER_KEY, A.ORDER_KEY, A.GOODS_COMMON_KEY, A.ORDER_AMOUNT
  FROM FACT_GOODS_SALES A
 WHERE A.ORDER_STATE = 1
   AND A.GOODS_COMMON_KEY IS NOT NULL
   AND EXISTS (SELECT 1
          FROM (SELECT C.MEMBER_KEY, MIN(C.ORDER_KEY) ORDER_KEY
                  FROM FACT_GOODS_SALES C
                 WHERE C.ORDER_STATE = 1
                   AND C.GOODS_COMMON_KEY IS NOT NULL
                 GROUP BY C.MEMBER_KEY) B
         WHERE A.MEMBER_KEY = B.MEMBER_KEY
           AND A.ORDER_KEY = B.ORDER_KEY)
   AND EXISTS (SELECT 1
          FROM (SELECT C.MEMBER_KEY,
                       C.ORDER_KEY,
                       MAX(C.ORDER_AMOUNT) ORDER_AMOUNT
                  FROM FACT_GOODS_SALES C
                 WHERE C.ORDER_STATE = 1
                   AND C.GOODS_COMMON_KEY IS NOT NULL
                 GROUP BY C.MEMBER_KEY, C.ORDER_KEY) D
         WHERE A.MEMBER_KEY = D.MEMBER_KEY
           AND A.ORDER_KEY = D.ORDER_KEY
           AND A.ORDER_AMOUNT = D.ORDER_AMOUNT)
					 AND A.MEMBER_KEY=1103386002;

--tmp
SELECT * FROM MEMBER_LABEL_HEAD;
SELECT * FROM MEMBER_LABEL_TYPE;
SELECT * FROM MEMBER_LABEL_LINK;
SELECT * FROM MEMBER_LABEL_LINK_V;
SELECT * FROM MEMBER_LABEL_LOG;

--5118556662
SELECT A.MEMBER_KEY,
       A.ORDER_KEY,
       A.ORDER_DATE_KEY,
       A.POSTING_DATE_KEY,
       A.ORDER_STATE,
       A.GOODS_COMMON_KEY,
			 A.ORDER_AMOUNT
  FROM FACT_GOODS_SALES A
 WHERE A.MEMBER_KEY = 1105532572
 ORDER BY 2;
