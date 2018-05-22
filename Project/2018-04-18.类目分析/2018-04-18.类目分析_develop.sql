--1.��Ա�ȼ�
SELECT G.MATDL, G.MEMBER_LEVEL, COUNT(DISTINCT G.CUST_NO) MEMBER_COUNT
  FROM (SELECT C.ORDER_ID,
               C.CUST_NO,
               C.GOODS_COMMONID,
               NVL(D.MEMBER_LEVEL, 'HAPP_T0') MEMBER_LEVEL,
               '[' || E.ZMATDL || ']' || E.ZMATDLT MATDL
          FROM (SELECT A.ORDER_ID, A.CUST_NO, B.GOODS_COMMONID
                  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
                 WHERE A.ORDER_ID = B.ORDER_ID
                   AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
                 '2018-03-31'
                   AND A.ORDER_STATE >= 20) C,
               DIM_MEMBER D,
               (SELECT E1.ZMATDL, E1.ZMATDLT
                  FROM DIM_MATERCATE E1
                 GROUP BY E1.ZMATDL, E1.ZMATDLT
                UNION
                SELECT 55 ZMATDL, '�̲�ʳƷ'
                  FROM DUAL) E,
               DIM_EC_GOOD F
         WHERE C.CUST_NO = D.MEMBER_BP(+)
           AND C.GOODS_COMMONID = F.GOODS_COMMONID(+)
           AND F.MATDL = E.ZMATDL(+)) G
 GROUP BY G.MATDL, G.MEMBER_LEVEL
 ORDER BY G.MATDL, G.MEMBER_LEVEL;

--1.1 53,55 
SELECT G.MEMBER_LEVEL, COUNT(DISTINCT G.CUST_NO) MEMBER_COUNT
  FROM (SELECT C.ORDER_ID,
               C.CUST_NO,
               C.GOODS_COMMONID,
               NVL(D.MEMBER_LEVEL, 'HAPP_T0') MEMBER_LEVEL,
               '[' || E.ZMATDL || ']' || E.ZMATDLT MATDL
          FROM (SELECT A.ORDER_ID, A.CUST_NO, B.GOODS_COMMONID
                  FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
                 WHERE A.ORDER_ID = B.ORDER_ID
                   AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
                 '2018-03-31'
                   AND A.ORDER_STATE >= 20) C,
               DIM_MEMBER D,
               (SELECT E1.ZMATDL, E1.ZMATDLT
                  FROM DIM_MATERCATE E1
                 GROUP BY E1.ZMATDL, E1.ZMATDLT
                UNION
                SELECT 55 ZMATDL, '�̲�ʳƷ'
                  FROM DUAL) E,
               DIM_EC_GOOD F
         WHERE C.CUST_NO = D.MEMBER_BP(+)
           AND C.GOODS_COMMONID = F.GOODS_COMMONID(+)
           AND F.MATDL = E.ZMATDL(+)
           AND F.MATDL IN (53, 55)) G
 GROUP BY G.MEMBER_LEVEL
 ORDER BY G.MEMBER_LEVEL;

--2.����
WITH M AS
 (SELECT A.ORDER_ID, A.CUST_NO, B.GOODS_COMMONID, D.VTEXT1
    FROM FACT_EC_ORDER_2      A,
         FACT_EC_ORDER_GOODS  B,
         FACT_EC_ORDER_COMMON C,
         DIM_ZONE             D
   WHERE A.ORDER_ID = B.ORDER_ID
     AND A.ORDER_ID = C.ORDER_ID
     AND C.TRANSPZONE = D.ZONE
     AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
   '2018-03-31'
     AND A.ORDER_STATE >= 20),
GOOD AS
 (SELECT G.GOODS_COMMONID, G.MATDL FROM DIM_EC_GOOD G),
MAT AS
 (SELECT E1.ZMATDL MATDL, '[' || E1.ZMATDL || ']' || E1.ZMATDLT MAT_NAME
    FROM DIM_MATERCATE E1
   GROUP BY E1.ZMATDL, E1.ZMATDLT
  UNION
  SELECT 55 ZMATDL, '[55]�̲�ʳƷ'
    FROM DUAL)
SELECT MAT.MAT_NAME, M.VTEXT1, COUNT(DISTINCT M.CUST_NO) RENSHU
  FROM M, MAT, GOOD
 WHERE M.GOODS_COMMONID = GOOD.GOODS_COMMONID
   AND GOOD.MATDL = MAT.MATDL
 GROUP BY MAT.MAT_NAME, M.VTEXT1
 ORDER BY MAT.MAT_NAME, M.VTEXT1;

--2.1 53��55
WITH M AS
 (SELECT A.ORDER_ID, A.CUST_NO, B.GOODS_COMMONID, D.VTEXT1
    FROM FACT_EC_ORDER_2      A,
         FACT_EC_ORDER_GOODS  B,
         FACT_EC_ORDER_COMMON C,
         DIM_ZONE             D
   WHERE A.ORDER_ID = B.ORDER_ID
     AND A.ORDER_ID = C.ORDER_ID
     AND C.TRANSPZONE = D.ZONE
     AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
   '2018-03-31'
     AND A.ORDER_STATE >= 20),
GOOD AS
 (SELECT G.GOODS_COMMONID, G.MATDL
    FROM DIM_EC_GOOD G
   WHERE G.MATDL IN (53, 55))
SELECT M.VTEXT1, COUNT(DISTINCT M.CUST_NO) RENSHU
  FROM M, GOOD
 WHERE M.GOODS_COMMONID = GOOD.GOODS_COMMONID
 GROUP BY M.VTEXT1
 ORDER BY M.VTEXT1;

--3.�Ա�
WITH M AS
 (SELECT A.ORDER_ID,
         A.CUST_NO,
         B.GOODS_COMMONID,
         CASE
           WHEN D.MEMBER_AGENDA = '1' THEN
            '��'
           WHEN D.MEMBER_AGENDA = '2' THEN
            'Ů'
           ELSE
            'δ֪'
         END GENDER
    FROM FACT_EC_ORDER_2      A,
         FACT_EC_ORDER_GOODS  B,
         FACT_EC_ORDER_COMMON C,
         DIM_MEMBER           D
   WHERE A.ORDER_ID = B.ORDER_ID
     AND A.ORDER_ID = C.ORDER_ID
     AND A.CUST_NO = D.MEMBER_BP
     AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
   '2018-03-31'
     AND A.ORDER_STATE >= 20),
GOOD AS
 (SELECT G.GOODS_COMMONID, G.MATDL FROM DIM_EC_GOOD G),
MAT AS
 (SELECT E1.ZMATDL MATDL, '[' || E1.ZMATDL || ']' || E1.ZMATDLT MAT_NAME
    FROM DIM_MATERCATE E1
   GROUP BY E1.ZMATDL, E1.ZMATDLT
  UNION
  SELECT 55 ZMATDL, '[55]�̲�ʳƷ'
    FROM DUAL)
SELECT MAT.MAT_NAME, M.GENDER, COUNT(DISTINCT M.CUST_NO) RENSHU
  FROM M, MAT, GOOD
 WHERE M.GOODS_COMMONID = GOOD.GOODS_COMMONID
   AND GOOD.MATDL = MAT.MATDL
 GROUP BY MAT.MAT_NAME, M.GENDER
 ORDER BY MAT.MAT_NAME, M.GENDER;

--3.1  53,55
WITH M AS
 (SELECT A.ORDER_ID,
         A.CUST_NO,
         B.GOODS_COMMONID,
         CASE
           WHEN D.MEMBER_AGENDA = '1' THEN
            '��'
           WHEN D.MEMBER_AGENDA = '2' THEN
            'Ů'
           ELSE
            'δ֪'
         END GENDER
    FROM FACT_EC_ORDER_2      A,
         FACT_EC_ORDER_GOODS  B,
         FACT_EC_ORDER_COMMON C,
         DIM_MEMBER           D
   WHERE A.ORDER_ID = B.ORDER_ID
     AND A.ORDER_ID = C.ORDER_ID
     AND A.CUST_NO = D.MEMBER_BP
     AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
   '2018-03-31'
     AND A.ORDER_STATE >= 20),
GOOD AS
 (SELECT G.GOODS_COMMONID, G.MATDL
    FROM DIM_EC_GOOD G
   WHERE G.MATDL IN (53, 55))
SELECT M.GENDER, COUNT(DISTINCT M.CUST_NO) RENSHU
  FROM M, GOOD
 WHERE M.GOODS_COMMONID = GOOD.GOODS_COMMONID
 GROUP BY M.GENDER
 ORDER BY M.GENDER;

--4.����
WITH M AS
 (SELECT A.ORDER_ID,
         A.CUST_NO,
         B.GOODS_COMMONID,
         CASE
           WHEN D.MEMBER_AGE = 0 THEN
            '=0'
           WHEN D.MEMBER_AGE > 0 AND D.MEMBER_AGE < 30 THEN
            '1-30'
           WHEN 30 <= D.MEMBER_AGE AND D.MEMBER_AGE < 35 THEN
            '30-35'
           WHEN 35 <= D.MEMBER_AGE AND D.MEMBER_AGE < 40 THEN
            '35-40'
           WHEN 40 <= D.MEMBER_AGE AND D.MEMBER_AGE < 45 THEN
            '40-45'
           WHEN 45 <= D.MEMBER_AGE AND D.MEMBER_AGE < 50 THEN
            '45-50'
           WHEN 50 <= D.MEMBER_AGE AND D.MEMBER_AGE < 55 THEN
            '50-55'
           WHEN 55 <= D.MEMBER_AGE AND D.MEMBER_AGE < 60 THEN
            '55-60'
           WHEN D.MEMBER_AGE >= 60 THEN
            '>=60'
         END AGE_LEVEL
    FROM FACT_EC_ORDER_2      A,
         FACT_EC_ORDER_GOODS  B,
         FACT_EC_ORDER_COMMON C,
         DIM_MEMBER           D
   WHERE A.ORDER_ID = B.ORDER_ID
     AND A.ORDER_ID = C.ORDER_ID
     AND A.CUST_NO = D.MEMBER_BP
     AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
   '2018-03-31'
     AND A.ORDER_STATE >= 20),
GOOD AS
 (SELECT G.GOODS_COMMONID, G.MATDL FROM DIM_EC_GOOD G),
MAT AS
 (SELECT E1.ZMATDL MATDL, '[' || E1.ZMATDL || ']' || E1.ZMATDLT MAT_NAME
    FROM DIM_MATERCATE E1
   GROUP BY E1.ZMATDL, E1.ZMATDLT
  UNION
  SELECT 55 ZMATDL, '[55]�̲�ʳƷ'
    FROM DUAL)
SELECT MAT.MAT_NAME, M.AGE_LEVEL, COUNT(DISTINCT M.CUST_NO) RENSHU
  FROM M, MAT, GOOD
 WHERE M.GOODS_COMMONID = GOOD.GOODS_COMMONID
   AND GOOD.MATDL = MAT.MATDL
 GROUP BY MAT.MAT_NAME, M.AGE_LEVEL
 ORDER BY MAT.MAT_NAME, M.AGE_LEVEL;

--4.1 53��55
WITH M AS
 (SELECT A.ORDER_ID,
         A.CUST_NO,
         B.GOODS_COMMONID,
         CASE
           WHEN D.MEMBER_AGE = 0 THEN
            '=0'
           WHEN D.MEMBER_AGE > 0 AND D.MEMBER_AGE < 30 THEN
            '1-30'
           WHEN 30 <= D.MEMBER_AGE AND D.MEMBER_AGE < 35 THEN
            '30-35'
           WHEN 35 <= D.MEMBER_AGE AND D.MEMBER_AGE < 40 THEN
            '35-40'
           WHEN 40 <= D.MEMBER_AGE AND D.MEMBER_AGE < 45 THEN
            '40-45'
           WHEN 45 <= D.MEMBER_AGE AND D.MEMBER_AGE < 50 THEN
            '45-50'
           WHEN 50 <= D.MEMBER_AGE AND D.MEMBER_AGE < 55 THEN
            '50-55'
           WHEN 55 <= D.MEMBER_AGE AND D.MEMBER_AGE < 60 THEN
            '55-60'
           WHEN D.MEMBER_AGE >= 60 THEN
            '>=60'
         END AGE_LEVEL
    FROM FACT_EC_ORDER_2      A,
         FACT_EC_ORDER_GOODS  B,
         FACT_EC_ORDER_COMMON C,
         DIM_MEMBER           D
   WHERE A.ORDER_ID = B.ORDER_ID
     AND A.ORDER_ID = C.ORDER_ID
     AND A.CUST_NO = D.MEMBER_BP
     AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
   '2018-03-31'
     AND A.ORDER_STATE >= 20),
GOOD AS
 (SELECT G.GOODS_COMMONID, G.MATDL
    FROM DIM_EC_GOOD G
   WHERE G.MATDL IN (53, 55))
SELECT M.AGE_LEVEL, COUNT(DISTINCT M.CUST_NO) RENSHU
  FROM M, GOOD
 WHERE M.GOODS_COMMONID = GOOD.GOODS_COMMONID
 GROUP BY M.AGE_LEVEL
 ORDER BY M.AGE_LEVEL;

--5.�۸��
/*
[11]��װ
[12]����
[14]Ь��
[16]����۾�
[18]��װ����
[24]�鱦����
[26]ʱ�о�Ʒ
[30]��������
[31]������е
[32]�˶�����
[33]������Ʒ
[34]�ֻ�
[39]����
[40]����
[43]��ҵ�
[44]����ҵ�
[45]����
[46]��װ����
[47]�Ҿߵ���
[49]�ҷ���Ʒ
[50]������Ʒ
[51]ʳƷ
[53]����ʳƷ
[54]ĸӤ��Ʒ
[55]�̲�ʳƷ
[58]Ͷ���ղ�
[59]����
[61]����ó��
[99]ϵͳ�ڲ���Ʒ����(�Ǿ�Ӫ��)
*/
SELECT E.PRICE_LEVEL, COUNT(DISTINCT E.CUST_NO) RENSHU
  FROM (SELECT A.ORDER_ID,
               A.CUST_NO,
               B.GOODS_COMMONID,
               B.GOODS_PAY_PRICE,
               CASE
                 WHEN B.GOODS_PAY_PRICE < 50 THEN
                  '<50'
                 WHEN B.GOODS_PAY_PRICE BETWEEN 50 AND 100 THEN
                  '50-100'
                 WHEN B.GOODS_PAY_PRICE BETWEEN 100 AND 300 THEN
                  '100-300'
               /*WHEN B.GOODS_PAY_PRICE BETWEEN 200 AND 500 THEN
               '200-500'*/
                 WHEN B.GOODS_PAY_PRICE > 300 THEN
                  '>300'
               END PRICE_LEVEL
          FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B
         WHERE A.ORDER_ID = B.ORDER_ID
           AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
         '2018-03-31'
           AND A.ORDER_STATE >= 20
           AND EXISTS (SELECT 1
                  FROM DIM_EC_GOOD D
                 WHERE B.GOODS_COMMONID = D.GOODS_COMMONID
                      /*��������*/
                   AND D.MATDL IN (53, 55))) E
 GROUP BY E.PRICE_LEVEL
 ORDER BY E.PRICE_LEVEL;

--6.��Ա����
WITH M AS
 (SELECT A.ORDER_ID, A.CUST_NO, B.GOODS_COMMONID, D.CLV_TYPE_W
    FROM FACT_EC_ORDER_2      A,
         FACT_EC_ORDER_GOODS  B,
         FACT_EC_ORDER_COMMON C,
         DIM_MEMBER           D
   WHERE A.ORDER_ID = B.ORDER_ID
     AND A.ORDER_ID = C.ORDER_ID
     AND A.CUST_NO = D.MEMBER_BP
     AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
   '2018-03-31'
     AND A.ORDER_STATE >= 20),
GOOD AS
 (SELECT G.GOODS_COMMONID, G.MATDL FROM DIM_EC_GOOD G),
MAT AS
 (SELECT E1.ZMATDL MATDL, '[' || E1.ZMATDL || ']' || E1.ZMATDLT MAT_NAME
    FROM DIM_MATERCATE E1
   GROUP BY E1.ZMATDL, E1.ZMATDLT
  UNION
  SELECT 55 ZMATDL, '[55]�̲�ʳƷ'
    FROM DUAL)
SELECT MAT.MAT_NAME, M.CLV_TYPE_W, COUNT(DISTINCT M.CUST_NO) RENSHU
  FROM M, MAT, GOOD
 WHERE M.GOODS_COMMONID = GOOD.GOODS_COMMONID
   AND GOOD.MATDL = MAT.MATDL
 GROUP BY MAT.MAT_NAME, M.CLV_TYPE_W
 ORDER BY MAT.MAT_NAME, M.CLV_TYPE_W;

--6.1 53,55
WITH M AS
 (SELECT A.ORDER_ID, A.CUST_NO, B.GOODS_COMMONID, D.CLV_TYPE_W
    FROM FACT_EC_ORDER_2      A,
         FACT_EC_ORDER_GOODS  B,
         FACT_EC_ORDER_COMMON C,
         DIM_MEMBER           D
   WHERE A.ORDER_ID = B.ORDER_ID
     AND A.ORDER_ID = C.ORDER_ID
     AND A.CUST_NO = D.MEMBER_BP
     AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
   '2018-03-31'
     AND A.ORDER_STATE >= 20),
GOOD AS
 (SELECT G.GOODS_COMMONID, G.MATDL
    FROM DIM_EC_GOOD G
   WHERE G.MATDL IN (53, 55))
SELECT M.CLV_TYPE_W, COUNT(DISTINCT M.CUST_NO) RENSHU
  FROM M, GOOD
 WHERE M.GOODS_COMMONID = GOOD.GOODS_COMMONID
 GROUP BY M.CLV_TYPE_W
 ORDER BY M.CLV_TYPE_W;

--7.�������
--7.1
DROP TABLE YANGJIN.MATRIX_ANALYSIS_TMP;
CREATE TABLE YANGJIN.MATRIX_ANALYSIS_TMP AS
  SELECT DISTINCT A.ORDER_ID, A.CUST_NO, C.MATZL, C.MATZLT
    FROM FACT_EC_ORDER_2 A, FACT_EC_ORDER_GOODS B, DIM_EC_GOOD C
   WHERE A.ORDER_ID = B.ORDER_ID
     AND B.GOODS_COMMONID = C.GOODS_COMMONID
     AND A.ADD_TIME BETWEEN DATE '2017-01-01' AND DATE
   '2018-03-31'
     AND A.ORDER_STATE >= 20
        /*��������*/
     AND C.MATZL IN (1102,
                     3002,
                     3003,
                     3103,
                     3104,
                     4501,
                     4502,
                     4505,
                     4901,
                     4902,
                     4906,
                     5001,
                     5005,
                     5006,
                     5102,
                     5103,
                     5104,
                     5105,
                     5106,
                     5108,
                     5109,
                     5301,
                     5302);

--7.2
WITH T1 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[1102]Ůʿ��װ"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 1102)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T2 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[3002]������Ʒ"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 3002)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T3 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[3003]��ױ��Ʒ"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 3003)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T4 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[3103]��������"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 3103)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T5 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[3104]���ݹ���"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 3104)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T6 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[4501]�����þ�"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 4501)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T7 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[4502]��������"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 4502)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T8 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[4505]�����þ�"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 4505)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T9 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[4901]���洲��"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 4901)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T10 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[4902]������Ʒ"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 4902)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T11 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[4906]ԡ����Ʒ"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 4906)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T12 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5001]��ȫ����"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5001)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T13 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5005]�����Ʒ"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5005)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T14 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5006]��������"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5006)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T15 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5102]��ͳ�̲�"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5102)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T16 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5103]�ط��ز�"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5103)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T17 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5104]����"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5104)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T18 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5105]���͵�ζ"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5105)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T19 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5106]����ʳƷ"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5106)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T20 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5108]����ʳƷ"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5108)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T21 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5109]���ϳ��"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5109)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T22 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5301]΢��Ԫ��"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5301)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT),
T23 AS
 (SELECT '[' || A.MATZL || ']' || A.MATZLT MATZL,
         COUNT(DISTINCT A.CUST_NO) "[5302]Ӫ������"
    FROM MATRIX_ANALYSIS_TMP A
   WHERE EXISTS (SELECT 1
            FROM MATRIX_ANALYSIS_TMP B
           WHERE A.CUST_NO = B.CUST_NO
             AND B.MATZL = 5302)
   GROUP BY '[' || A.MATZL || ']' || A.MATZLT)
SELECT T1.MATZL,
       T1."[1102]Ůʿ��װ",
       T2."[3002]������Ʒ",
       T3."[3003]��ױ��Ʒ",
       T4."[3103]��������",
       T5."[3104]���ݹ���",
       T6."[4501]�����þ�",
       T7."[4502]��������",
       T8."[4505]�����þ�",
       T9."[4901]���洲��",
       T10."[4902]������Ʒ",
       T11."[4906]ԡ����Ʒ",
       T12."[5001]��ȫ����",
       T13."[5005]�����Ʒ",
       T14."[5006]��������",
       T15."[5102]��ͳ�̲�",
       T16."[5103]�ط��ز�",
       T17."[5104]����",
       T18."[5105]���͵�ζ",
       T19."[5106]����ʳƷ",
       T20."[5108]����ʳƷ",
       T21."[5109]���ϳ��",
       T22."[5301]΢��Ԫ��",
       T23."[5302]Ӫ������"
  FROM T1,
       T2,
       T3,
       T4,
       T5,
       T6,
       T7,
       T8,
       T9,
       T10,
       T11,
       T12,
       T13,
       T14,
       T15,
       T16,
       T17,
       T18,
       T19,
       T20,
       T21,
       T22,
       T23
 WHERE T1.MATZL = T2.MATZL
   AND T1.MATZL = T3.MATZL
   AND T1.MATZL = T4.MATZL
   AND T1.MATZL = T5.MATZL
   AND T1.MATZL = T6.MATZL
   AND T1.MATZL = T7.MATZL
   AND T1.MATZL = T8.MATZL
   AND T1.MATZL = T9.MATZL
   AND T1.MATZL = T10.MATZL
   AND T1.MATZL = T11.MATZL
   AND T1.MATZL = T12.MATZL
   AND T1.MATZL = T13.MATZL
   AND T1.MATZL = T14.MATZL
   AND T1.MATZL = T15.MATZL
   AND T1.MATZL = T16.MATZL
   AND T1.MATZL = T17.MATZL
   AND T1.MATZL = T18.MATZL
   AND T1.MATZL = T19.MATZL
   AND T1.MATZL = T20.MATZL
   AND T1.MATZL = T21.MATZL
   AND T1.MATZL = T22.MATZL
   AND T1.MATZL = T23.MATZL
 ORDER BY T1.MATZL;


--tmp
SELECT *
  FROM DIM_MATERCATE A
 WHERE A.ZMATDLT = '�̲�ʳƷ'  SELECT DISTINCT A.ZMATZL, A.ZMATZLT
          FROM DIM_MATERCATE A
         WHERE A.ZMATZLT IN ('������Ʒ',
                             '��ױ��Ʒ',
                             '��������',
                             '���ݹ���',
                             '���ϳ��',
                             '����',
                             '���͵�ζ',
                             '����ʳƷ',
                             '����ʳƷ',
                             '��ͳ�̲�',
                             '�ط��ز�',
                             '�̲�ʳƷ',
                             '΢��Ԫ��',
                             'Ӫ������',
                             '��������',
                             '�����þ�',
                             '�����þ�',
                             '��������',
                             '�����Ʒ',
                             '��ȫ����',
                             '������Ʒ',
                             '���洲��',
                             'ԡ����Ʒ',
                             'Ůʿ��װ');
