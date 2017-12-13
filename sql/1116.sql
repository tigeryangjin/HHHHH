SELECT C.MEMBER_BP,
       C.ADD_TIME,
       C.ORDER_ID,
       C.SALES_SOURCE_SECOND_DESC,
       C.ORDER_STATE,
       NVL(C.PROMOTION_DESC, '���Ż�') PROMOTION_DESC,
       SYSDATE W_INSERT_DT,
       SYSDATE W_UPDATE_DT
  FROM (SELECT A.MEMBER_BP,
               A.ADD_TIME,
               A.ORDER_ID,
               A.SALES_SOURCE_SECOND_DESC,
               A.ORDER_STATE,
               LISTAGG(A.PROMOTION_DESC, ',') WITHIN GROUP(ORDER BY A.PROMOTION_DESC) PROMOTION_DESC
          FROM (SELECT DISTINCT OH.CUST_NO MEMBER_BP, /*BP��*/
                                OH.ADD_TIME, /*��������*/
                                OH.ORDER_ID, /*�������*/
                                CASE
                                  WHEN OH.APP_NAME IN
                                       ('KLGAndroid', 'KLGiPhone') THEN
                                   'A20017'
                                  WHEN OH.APP_NAME = 'KLGPortal' THEN
                                   'A20020'
                                  WHEN OH.APP_NAME = 'KLGWX' THEN
                                   'A20021'
                                  WHEN OH.APP_NAME = 'KLGMPortal' THEN
                                   'A20022'
                                END SALES_SOURCE_SECOND_DESC, /*����*/
                                OH.ORDER_STATE, /*����״̬*/
                                CASE
                                  WHEN OG.GOODS_TYPE = 3 THEN
                                   '��ʱ��Ʒ����'
                                
                                  WHEN OG.PML_DISCOUNT <> 0 THEN
                                   '�ȼ���'
                                
                                  WHEN OG.TV_DISCOUNT_AMOUNT <> 0 THEN
                                   'TVֱ������'
                                
                                  WHEN OH.DISCOUNT_MANSONG_AMOUNT <> 0 THEN
                                   '������'
                                
                                  WHEN OH.DISCOUNT_PAYMENTWAY_AMOUNT <> 0 OR
                                       OH.DISCOUNT_PAYMENTCHANEL_AMOUNT <> 0 THEN
                                   '֧������'
                                END PROMOTION_DESC /*�Żݷ�ʽ*/
                  FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
                 WHERE OH.ORDER_ID = OG.ORDER_ID
                      /*ͬ�����һ��������*/
                   AND OH.ADD_TIME BETWEEN &I_DATE - 30 AND &I_DATE) A
         GROUP BY A.MEMBER_BP,
                  A.ADD_TIME,
                  A.ORDER_ID,
                  A.SALES_SOURCE_SECOND_DESC,
                  A.ORDER_STATE) C
