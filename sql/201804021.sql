SELECT *
  FROM (SELECT OD.ORDER_KEY /*����Ȩ����*/,
               OD.ORDER_H_KEY /*����������*/,
               OD.ORDER_DESC /*����״̬*/,
               OD.GOODS_KEY /*��Ʒ*/,
               OD.GOODS_COMMON_KEY /*��Ʒ�̱���*/,
               OD.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
               OD.TRAN_TYPE /*�Ƿ���Ʒ��־*/,
               OD.TRAN_DESC /*��������*/,
               OD.MD_PERSON /*MD����*/,
               OD.POSTING_DATE_KEY /*��������key*/,
               TO_CHAR(OD.LIVE_STATE) || TO_CHAR(OD.REPLAY_STATE) LIVE_OR_REPLAY /*ֱ���ز�*/,
               OD.ORDER_STATE /*����״̬*/,
               OD.CANCEL_STATE /*ȡ��״̬*/,
               OD.MEMBER_KEY /*��Աkey*/,
               OD.NUMS TOTAL_ORDER_QTY /*�ܶ�������*/,
               OD.NUMS NET_ORDER_QTY /*����������*/,
               OD.NUMS EFFECTIVE_ORDER_QTY /*��Ч��������*/,
               OD.ORDER_AMOUNT TOTAL_ORDER_AMOUNT /*�ܶ������*/,
               OD.ORDER_AMOUNT NET_ORDER_AMOUNT /*���������*/,
               OD.ORDER_AMOUNT EFFECTIVE_ORDER_AMOUNT /*��Ч�������*/,
               OD.SALES_AMOUNT TOTAL_SALES_AMOUNT /*���ۼ۽��*/,
               OD.SALES_AMOUNT NET_SALES_AMOUNT /*���������*/,
               OD.SALES_AMOUNT EFFECTIVE_SALES_AMOUNT /*��Ч�������*/,
               OD.UNIT_PRICE /*������Ʒ�ۼ�*/,
               OD.COST_PRICE /*��Ʒ�����ɱ�*/,
               OD.FREIGHT_AMOUNT /*�˷�*/,
               OD.COUPONS_PRICE COUPONS_AMOUNT /*�Ż�ȯ���*/,
               OD.PURCHASE_AMOUNT TOTAL_PURCHASE_AMOUNT /*�ܶ����ɱ�*/,
               OD.PURCHASE_AMOUNT NET_PURCHASE_AMOUNT /*�������ɱ�*/,
               OD.PURCHASE_AMOUNT EFFECTIVE_PURCHASE_AMOUNT /*��Ч�����ɱ�*/,
               OD.PROFIT_AMOUNT /*�ۿ۽��*/
          FROM (
                /*ȡ���Ķ���������������POSTING_DATE_KEY�����򶩵���
                2017-06-14 yangjin*/
                SELECT ODU1.ORDER_KEY /*����Ȩ����*/,
                        ODU1.ORDER_H_KEY /*����������*/,
                        ODU1.ORDER_DESC /*����״̬*/,
                        ODU1.GOODS_KEY /*��Ʒ*/,
                        ODU1.GOODS_COMMON_KEY /*��Ʒ�̱���*/,
                        ODU1.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                        ODU1.TRAN_TYPE /*�Ƿ���Ʒ��־*/,
                        ODU1.TRAN_DESC /*��������*/,
                        ODU1.MD_PERSON /*MD����*/,
                        ODU1.POSTING_DATE_KEY /*��������key*/,
                        ODU1.LIVE_STATE /*�Ƿ�ֱ��*/,
                        ODU1.REPLAY_STATE /*�Ƿ��ز�*/,
                        ODU1.ORDER_STATE /*����״̬*/,
                        CASE
                          WHEN ODU1.CANCEL_STATE = 1 AND
                               ODU1.POSTING_DATE_KEY <= ODU1.UPDATE_TIME THEN
                           0
                          ELSE
                           ODU1.CANCEL_STATE
                        END CANCEL_STATE /*ȡ��״̬*/,
                        ODU1.MEMBER_KEY /*��Աkey*/,
                        ODU1.NUMS,
                        ODU1.ORDER_AMOUNT,
                        ODU1.SALES_AMOUNT,
                        ODU1.UNIT_PRICE /*������Ʒ�ۼ�*/,
                        ODU1.COST_PRICE /*��Ʒ�����ɱ�*/,
                        ODU1.FREIGHT_AMOUNT /*�˷�*/,
                        ODU1.COUPONS_PRICE /*�Ż�ȯ���*/,
                        ODU1.PURCHASE_AMOUNT /*�����ɱ�*/,
                        ODU1.PROFIT_AMOUNT /*�ۿ۽��*/
                  FROM FACT_GOODS_SALES ODU1
                 WHERE
                /*2018-03-15�޳�ɨ�빺���ۣ�FACT_EC_ORDER_2.order_from=76Ϊɨ�빺����*/
                 NOT EXISTS (SELECT 1
                    FROM FACT_EC_ORDER_2 FEO
                   WHERE ODU1.ORDER_KEY = FEO.CRM_ORDER_NO
                     AND FEO.ORDER_FROM = '76')
                
                UNION ALL
                /*ȡ���Ķ���������������UPDATE_TIME�����򶩵��������¼����
                2017-06-14 yangjin*/
                SELECT ODU2.ORDER_KEY /*����Ȩ����*/,
                        ODU2.ORDER_H_KEY /*����������*/,
                        ODU2.ORDER_DESC /*����״̬*/,
                        ODU2.GOODS_KEY /*��Ʒ*/,
                        ODU2.GOODS_COMMON_KEY /*��Ʒ�̱���*/,
                        ODU2.SALES_SOURCE_SECOND_KEY /*���۶�����֯key*/,
                        ODU2.TRAN_TYPE /*�Ƿ���Ʒ��־*/,
                        ODU2.TRAN_DESC /*��������*/,
                        ODU2.MD_PERSON /*MD����*/,
                        ODU2.UPDATE_TIME POSTING_DATE_KEY /*��������key*/,
                        ODU2.LIVE_STATE /*�Ƿ�ֱ��*/,
                        ODU2.REPLAY_STATE /*�Ƿ��ز�*/,
                        ODU2.ORDER_STATE /*����״̬*/,
                        ODU2.CANCEL_STATE /*ȡ��״̬*/,
                        ODU2.MEMBER_KEY /*��Աkey*/,
                        ODU2.NUMS,
                        ODU2.ORDER_AMOUNT,
                        ODU2.SALES_AMOUNT,
                        ODU2.UNIT_PRICE /*������Ʒ�ۼ�*/,
                        ODU2.COST_PRICE /*��Ʒ�����ɱ�*/,
                        ODU2.FREIGHT_AMOUNT /*�˷�*/,
                        ODU2.COUPONS_PRICE /*�Ż�ȯ���*/,
                        ODU2.PURCHASE_AMOUNT,
                        ODU2.PROFIT_AMOUNT /*�ۿ۽��*/
                  FROM FACT_GOODS_SALES ODU2
                 WHERE ODU2.CANCEL_STATE = 1
                   AND ODU2.CANCEL_BEFORE_STATE = 1 /*����ǰȡ���Ķ������������¼*/
                   AND ODU2.POSTING_DATE_KEY <= ODU2.UPDATE_TIME
                      /*2018-03-15�޳�ɨ�빺���ۣ�FACT_EC_ORDER_2.order_from=76Ϊɨ�빺����*/
                   AND NOT EXISTS
                 (SELECT 1
                          FROM FACT_EC_ORDER_2 FEO
                         WHERE ODU2.ORDER_KEY = FEO.CRM_ORDER_NO
                           AND FEO.ORDER_FROM = '76')) OD
         WHERE OD.POSTING_DATE_KEY = &IN_POSTING_DATE_KEY
           AND OD.TRAN_TYPE = 0 /*ֻ��ʾ��Ʒ*/
        ) A1
 WHERE A1.SALES_SOURCE_SECOND_KEY = 20017
   AND A1.GOODS_COMMON_KEY = 235272;

