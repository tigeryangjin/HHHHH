/*
2018.8.17-19   ���ѣ����棬����������ά�ȵ��ջ��������
���ѻ�Ա���������ĸ���֮ǰע�ᣬ������µ���������֮ǰû���������ϸ�������-FACT_SESSION��
���棺���������ÿ���¶�������
���£��ϸ��µ�һ�ζ�����
*/
--��ʱ��
DROP TABLE YANGJIN.MEMBER_HLN ;
CREATE TABLE YANGJIN.MEMBER_HLN AS
SELECT F.MEMBER_KEY,
       F.REG_MONTH,
       F.AGO_4M,
       F.AGO_3M,
       F.AGO_2M,
       F.AGO_1M,
       F.CUR_MONTH,
       CASE
         WHEN 201808 - F.REG_MONTH >= 5 AND
              ((F.AGO_2M IS NULL AND F.AGO_3M IS NULL AND
              F.AGO_1M IS NOT NULL) OR
              (F.CUR_MONTH IS NOT NULL AND F.AGO_1M IS NULL AND
              F.AGO_2M IS NULL)) THEN
          '����'
         WHEN F.AGO_1M IS NOT NULL AND F.AGO_2M IS NOT NULL AND
              F.AGO_3M IS NOT NULL THEN
          '����'
         WHEN F.REG_MONTH = 201807 AND F.AGO_1M IS NOT NULL THEN
          '����'
       END MEMBER_TYPE
  FROM (SELECT E.MEMBER_KEY,
               E.REG_MONTH,
               MAX(E.AGO_4M) AGO_4M,
               MAX(E.AGO_3M) AGO_3M,
               MAX(E.AGO_2M) AGO_2M,
               MAX(E.AGO_1M) AGO_1M,
               MAX(E.CUR_MONTH) CUR_MONTH
          FROM (SELECT D.MEMBER_KEY,
                       D.ORDER_MONTH,
                       D.REG_MONTH,
                       CASE
                         WHEN D.ORDER_MONTH = 201804 THEN
                          D.ORDER_MONTH
                       END AGO_4M,
                       CASE
                         WHEN D.ORDER_MONTH = 201805 THEN
                          D.ORDER_MONTH
                       END AGO_3M,
                       CASE
                         WHEN D.ORDER_MONTH = 201806 THEN
                          D.ORDER_MONTH
                       END AGO_2M,
                       CASE
                         WHEN D.ORDER_MONTH = 201807 THEN
                          D.ORDER_MONTH
                       END AGO_1M,
                       CASE
                         WHEN D.ORDER_MONTH = 201808 THEN
                          D.ORDER_MONTH
                       END CUR_MONTH
                  FROM (SELECT B.MEMBER_KEY,
                               SUBSTR(C.CREATE_DATE_KEY, 1, 6) REG_MONTH,
                               B.ORDER_MONTH
                          FROM (SELECT DISTINCT A.CUST_NO MEMBER_KEY,
                                                TO_CHAR(A.ADD_TIME, 'YYYYMM') ORDER_MONTH
                                  FROM FACT_EC_ORDER_2 A
                                 WHERE TO_CHAR(A.ADD_TIME, 'YYYYMM') BETWEEN
                                       201804 AND 201808
                                   AND A.ORDER_STATE >= 20) B,
                               DIM_MEMBER C
                         WHERE B.MEMBER_KEY = C.MEMBER_BP) D) E
         GROUP BY E.MEMBER_KEY, E.REG_MONTH) F;


--�ջ�
SELECT C.VISIT_DATE_KEY, D.MEMBER_TYPE, COUNT(1) UV
  FROM (SELECT DISTINCT B.VISIT_DATE_KEY, B.MEMBER_KEY
          FROM FACT_PAGE_VIEW B
         WHERE B.VISIT_DATE_KEY BETWEEN 20180817 AND 20180819) C,
       (SELECT A.MEMBER_KEY, A.MEMBER_TYPE
          FROM YANGJIN.MEMBER_HLN A
         WHERE A.MEMBER_TYPE IS NOT NULL) D
 WHERE C.MEMBER_KEY = D.MEMBER_KEY
 GROUP BY C.VISIT_DATE_KEY, D.MEMBER_TYPE
 ORDER BY C.VISIT_DATE_KEY, D.MEMBER_TYPE;

--��������
SELECT C.ORDER_DATE, D.MEMBER_TYPE, COUNT(1) ORDER_MEMBER_COUNT
  FROM (SELECT DISTINCT TO_CHAR(B.ADD_TIME, 'YYYYMMDD') ORDER_DATE,
                        B.CUST_NO MEMBER_KEY
          FROM FACT_EC_ORDER_2 B
         WHERE TO_CHAR(B.ADD_TIME, 'YYYYMMDD') BETWEEN 20180817 AND 20180819) C,
       (SELECT A.MEMBER_KEY, A.MEMBER_TYPE
          FROM YANGJIN.MEMBER_HLN A
         WHERE A.MEMBER_TYPE IS NOT NULL) D
 WHERE C.MEMBER_KEY = D.MEMBER_KEY
 GROUP BY C.ORDER_DATE, D.MEMBER_TYPE
 ORDER BY C.ORDER_DATE, D.MEMBER_TYPE;
