--7.28���ֶ���
create table member_tmp(member_key number(20));
truncate table member_tmp;
select * from member_tmp for update;

--���ʻ�Ӧ�ʣ�
select 25113/90351 from dual;
select count(1) from member_tmp;
SELECT COUNT(DISTINCT T.MEMBER_KEY)
  FROM FACT_PAGE_VIEW T
 WHERE T.VISIT_DATE_KEY BETWEEN 20170726 AND 20170731
   AND EXISTS
 (SELECT 1 FROM member_tmp S WHERE T.MEMBER_KEY = S.MEMBER_KEY);
 
--������Ӧ��
select 866/90351 from dual;
SELECT COUNT(B.MEMBER_KEY) MEMBER_COUNT, SUM(B.ORDER_AMOUNT) ORDER_AMOUNT
  FROM (SELECT A.MEMBER_KEY,
               COUNT(A.ORDER_OBJ_ID) ORDER_COUNT,
               SUM(A.ORDER_AMOUNT) ORDER_AMOUNT
          FROM (SELECT T.POSTING_DATE_KEY,
                       T.ORDER_OBJ_ID,
                       T.MEMBER_KEY,
                       T.ORDER_AMOUNT
                  FROM FACT_ORDER T
                 WHERE T.POSTING_DATE_KEY BETWEEN 20170726 AND 20170731 /*��������*/
                   AND T.SALES_SOURCE_KEY = 20 /*��ý��ͨ·*/
                   AND T.ORDER_STATE = 1
                   AND EXISTS
                 (SELECT 1
                          FROM member_tmp C
                         WHERE T.MEMBER_KEY = C.MEMBER_KEY)) A
         GROUP BY A.MEMBER_KEY) B;
