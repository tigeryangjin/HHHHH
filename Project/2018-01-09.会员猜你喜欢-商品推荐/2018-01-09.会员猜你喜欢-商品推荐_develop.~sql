--1.关联规则
INSERT INTO OPER_ITEM_RECOMMEND_AR
  (ITEM_CODE_S,
   ITEM_CODE_R,
   GROUP_ID,
   RECOMMEND_RANK,
   PV_FREQ,
   FAV_FREQ,
   CAR_FREQ,
   ORDER_NET_QTY,
   RECOMMEND_WEIGHT,
   MEMBER_COUNT,
   W_INSERT_DT,
   W_UPDATE_DT)
  SELECT K.ITEM_CODE_S,
         K.ITEM_CODE_R,
         K.GROUP_ID,
         K.RECOMMEND_RANK,
         K.PV_FREQ,
         K.FAV_FREQ,
         K.CAR_FREQ,
         K.ORDER_NET_QTY,
         K.RECOMMEND_WEIGHT,
         K.MEMBER_COUNT,
         SYSDATE            W_INSERT_DT,
         SYSDATE            W_UPDATE_DT
    FROM (SELECT G.ITEM_CODE_S,
                 G.ITEM_CODE_R,
                 I.GROUP_ID,
                 RANK() OVER(PARTITION BY G.ITEM_CODE_S ORDER BY G.RECOMMEND_WEIGHT DESC, G.MEMBER_COUNT DESC) RECOMMEND_RANK,
                 G.PV_FREQ,
                 G.FAV_FREQ,
                 G.CAR_FREQ,
                 G.ORDER_NET_QTY,
                 G.RECOMMEND_WEIGHT,
                 G.MEMBER_COUNT
            FROM (SELECT F.ITEM_CODE_S,
                         F.ITEM_CODE_R,
                         F.PV_FREQ,
                         F.FAV_FREQ,
                         F.CAR_FREQ,
                         F.ORDER_NET_QTY,
                         F.RECOMMEND_WEIGHT,
                         F.MEMBER_COUNT
                    FROM (SELECT E.ITEM_CODE_S,
                                 E.ITEM_CODE_R,
                                 SUM(E.PV_FREQ) PV_FREQ,
                                 SUM(E.FAV_FREQ) FAV_FREQ,
                                 SUM(E.CAR_FREQ) CAR_FREQ,
                                 SUM(E.ORDER_NET_QTY) ORDER_NET_QTY,
                                 SUM(E.RECOMMEND_WEIGHT) RECOMMEND_WEIGHT,
                                 COUNT(E.MEMBER_KEY) MEMBER_COUNT
                            FROM (SELECT C.MEMBER_KEY,
                                         C.ITEM_CODE ITEM_CODE_S,
                                         D.ITEM_CODE ITEM_CODE_R,
                                         D.PV_FREQ,
                                         D.FAV_FREQ,
                                         D.CAR_FREQ,
                                         D.ORDER_NET_QTY,
                                         D.RECOMMEND_WEIGHT *
                                         C.TV_RECOMMEND_WEIGHT RECOMMEND_WEIGHT
                                    FROM (SELECT A.MEMBER_KEY,
                                                 A.ITEM_CODE,
                                                 A.MATXL,
                                                 SUM(A.PV_FREQ) * 5 +
                                                 SUM(A.FAV_FREQ) * 3 +
                                                 SUM(A.CAR_FREQ) * 5 +
                                                 SUM(A.ORDER_NET_QTY) * 4 TV_RECOMMEND_WEIGHT
                                            FROM OPER_MEMBER_LIKE_BASE A
                                           WHERE A.POSTING_DATE_KEY >=
                                                 TO_CHAR(TRUNC(SYSDATE - 90),
                                                         'YYYYMMDD')
                                             AND EXISTS
                                           (SELECT 1
                                                    FROM DIM_TV_GOOD@DW_DATALINK J
                                                   WHERE J.TV_STARTDAY_KEY =
                                                         TO_CHAR(TRUNC(SYSDATE),
                                                                 'YYYYMMDD')
                                                     AND A.ITEM_CODE =
                                                         J.ITEM_CODE) /*只推荐当天直播的商品*/
                                           GROUP BY A.MEMBER_KEY,
                                                    A.ITEM_CODE,
                                                    A.MATXL) C,
                                         (SELECT B.MEMBER_KEY,
                                                 B.ITEM_CODE,
                                                 B.MATXL,
                                                 SUM(B.PV_FREQ) PV_FREQ,
                                                 SUM(B.FAV_FREQ) FAV_FREQ,
                                                 SUM(B.CAR_FREQ) CAR_FREQ,
                                                 SUM(B.ORDER_NET_QTY) ORDER_NET_QTY,
                                                 SUM(B.PV_FREQ) * 5 +
                                                 SUM(B.FAV_FREQ) * 3 +
                                                 SUM(B.CAR_FREQ) * 5 +
                                                 SUM(B.ORDER_NET_QTY) * 4 RECOMMEND_WEIGHT
                                            FROM OPER_MEMBER_LIKE_BASE B
                                           WHERE B.POSTING_DATE_KEY >=
                                                 TO_CHAR(TRUNC(SYSDATE - 90),
                                                         'YYYYMMDD')
                                           GROUP BY B.MEMBER_KEY,
                                                    B.ITEM_CODE,
                                                    B.MATXL) D
                                   WHERE C.MEMBER_KEY = D.MEMBER_KEY
                                     AND C.ITEM_CODE <> D.ITEM_CODE
                                     AND C.MATXL <> D.MATXL) E
                           GROUP BY E.ITEM_CODE_S, E.ITEM_CODE_R) F
                   ORDER BY F.MEMBER_COUNT DESC, F.RECOMMEND_WEIGHT DESC) G,
                 DIM_GOOD@DW_DATALINK H,
                 DIM_GOOD@DW_DATALINK I
           WHERE G.ITEM_CODE_S = H.ITEM_CODE
             AND G.ITEM_CODE_R = I.ITEM_CODE
             AND H.CURRENT_FLG = 'Y'
             AND I.CURRENT_FLG = 'Y'
             AND H.GOOD_PRICE > 0
             AND I.GOOD_PRICE > 0) K
   WHERE K.RECOMMEND_RANK <= 20;

--2.热销商品排名
INSERT INTO OPER_ITEM_RECOMMEND_SR
  (ITEM_CODE, GROUP_ID, QTY, QTY_RANK, W_INSERT_DT, W_UPDATE_DT)
  SELECT D.ITEM_CODE,
         D.GROUP_ID,
         D.QTY,
         D.QTY_RANK,
         SYSDATE     W_INSERT_DT,
         SYSDATE     W_UPDATE_DT
    FROM (SELECT C.ITEM_CODE,
                 C.GROUP_ID,
                 C.QTY,
                 RANK() OVER(ORDER BY C.QTY DESC) QTY_RANK
            FROM (SELECT B.ITEM_CODE, B.GROUP_ID, SUM(A.NUMS) QTY
                    FROM FACT_GOODS_SALES@DW_DATALINK A,
                         DIM_GOOD@DW_DATALINK         B
                   WHERE A.GOODS_COMMON_KEY = B.ITEM_CODE
                     AND A.ORDER_STATE = 1
                     AND A.POSTING_DATE_KEY >=
                         TO_CHAR(TRUNC(SYSDATE - 90), 'YYYYMMDD')
                     AND B.GOOD_PRICE > 0
                   GROUP BY B.ITEM_CODE, B.GROUP_ID) C) D
   WHERE D.QTY_RANK <= 20;

--3.合并
--RECOMMEND_TYPE:l:AR,2:SR
INSERT INTO OPER_ITEM_RECOMMEND_UNION
  (DATE_KEY,
   ITEM_CODE_S,
   ITEM_CODE_R,
   GROUP_ID,
   RECOMMEND_TYPE,
   RECOMMEND_RANK,
   W_INSERT_DT,
   W_UPDATE_DT)
  SELECT A.DATE_KEY,
         A.ITEM_CODE_S,
         A.ITEM_CODE_R,
         A.GROUP_ID,
         A.RECOMMEND_TYPE,
         A.RECOMMEND_RANK,
         SYSDATE          W_INSERT_DT,
         SYSDATE          W_UPDATE_DT
    FROM (SELECT B.DATE_KEY,
                 B.ITEM_CODE_S,
                 B.ITEM_CODE_R,
                 B.GROUP_ID,
                 1                RECOMMEND_TYPE,
                 B.RECOMMEND_RANK RECOMMEND_RANK
            FROM OPER_ITEM_RECOMMEND_AR B
           WHERE B.DATE_KEY = TO_CHAR(TRUNC(SYSDATE), 'YYYYMMDD')
          UNION ALL
          SELECT D.DATE_KEY,
                 C.ITEM_CODE ITEM_CODE_S,
                 D.ITEM_CODE ITEM_CODE_R,
                 D.GROUP_ID,
                 2           RECOMMEND_TYPE,
                 D.QTY_RANK  RECOMMEND_RANK
            FROM DIM_TV_GOOD@DW_DATALINK C, OPER_ITEM_RECOMMEND_SR D
           WHERE C.TV_STARTDAY_KEY = D.DATE_KEY
             AND C.TV_STARTDAY_KEY = TO_CHAR(TRUNC(SYSDATE), 'YYYYMMDD')
             AND NOT EXISTS (SELECT 1
                    FROM OPER_ITEM_RECOMMEND_AR E
                   WHERE C.ITEM_CODE = E.ITEM_CODE_S)) A
   ORDER BY A.ITEM_CODE_S, A.RECOMMEND_TYPE, A.RECOMMEND_RANK;

--TMP
begin
  -- Call the procedure
  oper_member_like_pkg.oper_item_recommend_ar_proc(20180111);
  oper_member_like_pkg.oper_item_recommend_sr_proc(20180111);
end;
/

SELECT * FROM OPER_ITEM_RECOMMEND_AR A ORDER BY A.W_INSERT_DT DESC;
SELECT * FROM OPER_ITEM_RECOMMEND_SR A ORDER BY A.W_INSERT_DT DESC;
SELECT * FROM OPER_ITEM_RECOMMEND_UNION A ORDER BY A.W_INSERT_DT DESC;

SELECT DISTINCT DATE_KEY FROM OPER_ITEM_RECOMMEND_AR ORDER BY DATE_KEY;
SELECT DISTINCT DATE_KEY FROM OPER_ITEM_RECOMMEND_SR ORDER BY DATE_KEY;
SELECT DISTINCT DATE_KEY FROM OPER_ITEM_RECOMMEND_UNION ORDER BY DATE_KEY;

DELETE OPER_ITEM_RECOMMEND_AR A WHERE A.DATE_KEY=20180112;
COMMIT;
DELETE OPER_ITEM_RECOMMEND_SR A WHERE A.DATE_KEY=20180112;
COMMIT;
DELETE OPER_ITEM_RECOMMEND_UNION A WHERE A.DATE_KEY=20180112;
COMMIT;

SELECT A.DATE_KEY,
       A.ITEM_CODE_S,
       A.ITEM_CODE_R,
       A.GROUP_ID,
       A.RECOMMEND_TYPE,
       A.RECOMMEND_RANK,
       A.W_INSERT_DT,
       A.W_UPDATE_DT FROM 
OPER_ITEM_RECOMMEND_UNION A;

SELECT A.TV_STARTDAY_KEY, COUNT(1)
  FROM DIM_TV_GOOD@DW_DATALINK A
 GROUP BY A.TV_STARTDAY_KEY;

SELECT * FROM S_PARAMETERS2 FOR UPDATE;
