/*
Commodity recommendation
��Ʒ�Ƽ�

�㷨1��
1.����һ����Ʒ���ҳ����й������Ʒ���û�Ⱥ��
2.Ȼ���ҳ����û�Ⱥ���������Ʒ������������ࣩǰ50����

�㷨2��
1.����һ����Ա���ҳ��������������N����Ʒ�����ݶ�����������
2.Ȼ���ҳ�ͬ���������N����Ʒ���û�Ⱥ��
3.Ȼ���ҳ����û�Ⱥ���������Ʒ������������ࣩǰ10��

*/


--1.CREATE BASE TABLE
DROP TABLE GOODS_RECOMMEND_BASE;
CREATE TABLE GOODS_RECOMMEND_BASE AS
SELECT OH.ADD_TIME  ORDER_DATE,
       OH.ORDER_SN  ORDER_NO,
       OH.CUST_NO   MEMBER_BP,
       OG.ERP_CODE  ITEM_CODE,
       OG.GOODS_NUM QTY
  FROM FACT_EC_ORDER_2 OH, FACT_EC_ORDER_GOODS OG
 WHERE OH.ORDER_ID = OG.ORDER_ID
   AND OH.ORDER_STATE >= 20;
	 
DROP TABLE GOODS_RECOMMEND_BASE;
CREATE TABLE GOODS_RECOMMEND_BASE AS
SELECT A.POSTING_DATE_KEY ORDER_DATE,
       A.ORDER_KEY        ORDER_NO,
       A.MEMBER_KEY       MEMBER_BP,
       A.GOODS_COMMON_KEY ITEM_CODE
  FROM FACT_GOODS_SALES A
 WHERE A.ORDER_STATE = 1
   AND A.GOODS_COMMON_KEY IS NOT NULL
 ORDER BY A.POSTING_DATE_KEY, A.ORDER_KEY, A.MEMBER_KEY, A.GOODS_COMMON_KEY;

--2.CUST_NO=1500394689,ERP_CODE=186222
SELECT ROW_NUMBER() OVER(ORDER BY G.MEMBER_NUMBER DESC) TOPN,
       G.ITEM_CODE,
       G.MEMBER_NUMBER,
       H.GOODS_NAME,
       H.MATDL,
       H.MATDLT,
       H.MATZL,
       H.MATZLT,
       H.MATXL,
       H.MATXLT
  FROM (SELECT F.ITEM_CODE, F.MEMBER_NUMBER
          FROM (SELECT B.ITEM_CODE, COUNT(DISTINCT B.MEMBER_BP) MEMBER_NUMBER
                  FROM GOODS_RECOMMEND_BASE B
                 WHERE EXISTS (SELECT 1
                          FROM (SELECT A.MEMBER_BP
                                  FROM GOODS_RECOMMEND_BASE A
                                 WHERE A.ITEM_CODE = 225310) C
                         WHERE B.MEMBER_BP = C.MEMBER_BP) /*�������Ʒ�����л�Ա*/
                   AND NOT EXISTS
                 (SELECT 1
                          FROM (SELECT E.ITEM_CODE
                                  FROM GOODS_RECOMMEND_BASE E
                                 WHERE E.MEMBER_BP = 1111006723) D
                         WHERE B.ITEM_CODE = D.ITEM_CODE) /*�˻�Ա�Ѿ����������Ʒ*/
                   AND B.ITEM_CODE <> 0
                   AND B.ITEM_CODE <> 225310
                   AND B.ORDER_DATE >= TO_CHAR(SYSDATE - 91, 'YYYYMMDD') /*���ڷ�Χ���90��*/
                 GROUP BY B.ITEM_CODE) F
         WHERE ROWNUM <= 50
         ORDER BY F.MEMBER_NUMBER DESC) G,
       DIM_GOOD H
 WHERE G.ITEM_CODE = H.ITEM_CODE
   AND H.CURRENT_FLG = 'Y';

--3.

--4.

--tmp
SELECT * FROM TABLE(YANGJIN_PKG_TEST.GET_GOODS_RECOMMEND_T(1111006723,225310));
SELECT * FROM TABLE(GET_GOODS_RECOMMEND(1111006723,225310));
