/*
FACT_GOODS_DIM_TOTAL��ZJ_STATE:��Ʒ�Ƿ��ڼܣ�STOCK_NUMS:��Ʒ�������
�洢����processgoodsorderdayly��FACT_GOODS_DIM_TOTAL��������ݡ�
ZJ_STATE����Դ�ڣ�fact_daily_goodszj_stat.zj_state��STOCK_NUMS����Դ�ڣ�fact_ecgoods_stock.goods_stock,fact_ecgoods_stockΪ�ձ�
fact_daily_goodszj_stat.zj_state��Դ��fact_daily_goodzj.zj_state��
/home/bobo/ktr/ec/factecgoodsstock.ktr����fact_ecgoods_stock����Դ�ڣ�ec_goods_common.goods_storage
/home/liqiao/bifile/processgoodzaixian.ktr����FACT_DAILY_GOODZAIJIA����Դ�ڣ�ec_goods_common,goods_state=1
*/

--1.ec_goods_commonͬ����oracle��fact_ec_goods_common
select * from ec_goods_common_tmp;
select * from fact_ec_goods_common;

--2.oper_repurchase_item
-- Create sequence 
create sequence OPER_REPURCHASE_ITEM_SEQ minvalue 1 maxvalue 9999999999999999999999999999 start
  with 1 increment by 1 cache 20;

CREATE TABLE OPER_REPURCHASE_ITEM_TMP AS
  SELECT A.ITEM_CODE, A.REPURCHASE_DAYS FROM OPER_REPURCHASE_ITEM A;

SELECT A.ITEM_CODE, A.REPURCHASE_DAYS
  FROM OPER_REPURCHASE_ITEM_TMP A
   FOR UPDATE;

INSERT INTO OPER_REPURCHASE_ITEM A
  (A.ROW_ID, A.ITEM_CODE, A.REPURCHASE_DAYS)
  SELECT OPER_REPURCHASE_ITEM_SEQ.NEXTVAL, B.ITEM_CODE, B.REPURCHASE_DAYS
    FROM OPER_REPURCHASE_ITEM_TMP B;

UPDATE OPER_REPURCHASE_ITEM A
   SET (A.MATDL, A.MATZL, A.MATXL, A.W_INSERT_DT, A.W_UPDATE_DT) =
       (SELECT B.MATDL,
               B.MATZL,
               B.MATXL,
               SYSDATE W_INSERT_DT,
               SYSDATE W_UPDATE_DT
          FROM DIM_GOOD B
         WHERE B.CURRENT_FLG = 'Y'
           AND A.ITEM_CODE = B.ITEM_CODE)
 WHERE A.W_UPDATE_DT IS NULL
   AND EXISTS (SELECT 1
          FROM DIM_GOOD C
         WHERE C.CURRENT_FLG = 'Y'
           AND A.ITEM_CODE = C.ITEM_CODE);

--3.oper_repurchase_member_track
create sequence OPER_REPUR_MEMBER_TRACK_SEQ minvalue 1 maxvalue 9999999999999999999999999999 start
  with 1 increment by 1 cache 20;

--3.1.
SELECT * FROM OPER_REPURCHASE_MEMBER_TRACK;
INSERT INTO OPER_REPURCHASE_MEMBER_TRACK
  (ROW_ID,
   ITEM_CODE,
   MEMBER_BP,
   LATEST_ORDER_DATE,
   REPURCHASE_DAYS,
   ON_SHELF,
   STOCK_QTY,
   W_INSERT_DT,
   W_UPDATE_DT)
  SELECT OPER_REPUR_MEMBER_TRACK_SEQ.NEXTVAL ROW_ID,
         G.ITEM_CODE,
         G.MEMBER_BP,
         G.LATEST_ORDER_DATE,
         G.REPURCHASE_DAYS,
         G.ON_SHELF,
         G.STOCK_QTY,
         SYSDATE                             W_INSERT_DT,
         SYSDATE                             W_UPDATE_DT
    FROM (SELECT E.ITEM_CODE,
                 E.MEMBER_BP,
                 E.LATEST_ORDER_DATE,
                 E.REPURCHASE_DAYS,
                 F.GOODS_STATE       ON_SHELF,
                 F.GOODS_STORAGE     STOCK_QTY
            FROM (SELECT C.ITEM_CODE,
                         C.MEMBER_BP,
                         C.LATEST_ORDER_DATE,
                         D.REPURCHASE_DAYS
                    FROM (SELECT B.ITEM_CODE,
                                 A.MEMBER_KEY MEMBER_BP,
                                 MAX(TO_DATE(A.POSTING_DATE_KEY, 'YYYYMMDD')) LATEST_ORDER_DATE
                            FROM FACT_GOODS_SALES A, OPER_REPURCHASE_ITEM B
                           WHERE A.ORDER_STATE = 1
                             AND A.TRAN_TYPE = 0
                             AND A.GOODS_COMMON_KEY = B.ITEM_CODE
                           GROUP BY A.MEMBER_KEY, B.ITEM_CODE) C,
                         OPER_REPURCHASE_ITEM D
                   WHERE C.ITEM_CODE = D.ITEM_CODE) E,
                 FACT_EC_GOODS_COMMON F
           WHERE E.ITEM_CODE = F.ITEM_CODE(+)) G;

MERGE /*+APPEND*/
INTO OPER_REPURCHASE_MEMBER_TRACK T
USING (SELECT G.ITEM_CODE,
              G.MEMBER_BP,
              G.LATEST_ORDER_DATE,
              G.REPURCHASE_DAYS,
              G.ON_SHELF,
              G.STOCK_QTY,
              SYSDATE             W_INSERT_DT,
              SYSDATE             W_UPDATE_DT
         FROM (SELECT E.ITEM_CODE,
                      E.MEMBER_BP,
                      E.LATEST_ORDER_DATE,
                      E.REPURCHASE_DAYS,
                      F.GOODS_STATE       ON_SHELF,
                      F.GOODS_STORAGE     STOCK_QTY
                 FROM (SELECT C.ITEM_CODE,
                              C.MEMBER_BP,
                              C.LATEST_ORDER_DATE,
                              D.REPURCHASE_DAYS
                         FROM (SELECT B.ITEM_CODE,
                                      A.MEMBER_KEY MEMBER_BP,
                                      MAX(TO_DATE(A.POSTING_DATE_KEY,
                                                  'YYYYMMDD')) LATEST_ORDER_DATE
                                 FROM FACT_GOODS_SALES     A,
                                      OPER_REPURCHASE_ITEM B
                                WHERE A.ORDER_STATE = 1
                                  AND A.TRAN_TYPE = 0
                                  AND A.GOODS_COMMON_KEY = B.ITEM_CODE
                                GROUP BY A.MEMBER_KEY, B.ITEM_CODE) C,
                              OPER_REPURCHASE_ITEM D
                        WHERE C.ITEM_CODE = D.ITEM_CODE) E,
                      FACT_EC_GOODS_COMMON F
                WHERE E.ITEM_CODE = F.ITEM_CODE(+)) G) S
ON (T.ITEM_CODE = S.ITEM_CODE AND T.MEMBER_BP = S.MEMBER_BP)
WHEN MATCHED THEN
  UPDATE
     SET T.LATEST_ORDER_DATE = S.LATEST_ORDER_DATE,
         T.REPURCHASE_DAYS   = S.REPURCHASE_DAYS,
         T.ON_SHELF          = S.ON_SHELF,
         T.STOCK_QTY         = S.STOCK_QTY,
         T.W_UPDATE_DT       = S.W_UPDATE_DT
WHEN NOT MATCHED THEN
  INSERT
    (T.ROW_ID,
     T.ITEM_CODE,
     T.MEMBER_BP,
     T.LATEST_ORDER_DATE,
     T.REPURCHASE_DAYS,
     T.ON_SHELF,
     T.STOCK_QTY,
     T.W_INSERT_DT,
     T.W_UPDATE_DT)
  VALUES
    (OPER_REPUR_MEMBER_TRACK_SEQ.NEXTVAL,
     S.ITEM_CODE,
     S.MEMBER_BP,
     S.LATEST_ORDER_DATE,
     S.REPURCHASE_DAYS,
     S.ON_SHELF,
     S.STOCK_QTY,
     S.W_INSERT_DT,
     S.W_UPDATE_DT);

--3.2.��Ʒ�ϼܱ�־�Ϳ������
UPDATE OPER_REPURCHASE_MEMBER_TRACK A
   SET (A.ON_SHELF, A.STOCK_QTY, A.W_UPDATE_DT) =
       (SELECT NVL(B.GOODS_STATE, 0) GOODS_STATE,
               NVL(B.GOODS_STORAGE, 0) GOODS_STORAGE,
               SYSDATE W_UPDATE_DT
          FROM FACT_EC_GOODS_COMMON B
         WHERE A.ITEM_CODE = B.ITEM_CODE
           AND (A.ON_SHELF <> B.GOODS_STATE OR
               A.STOCK_QTY <> B.GOODS_STORAGE))
 WHERE EXISTS (SELECT 1
          FROM FACT_EC_GOODS_COMMON C
         WHERE A.ITEM_CODE = C.ITEM_CODE
           AND (A.ON_SHELF <> C.GOODS_STATE OR
               A.STOCK_QTY <> C.GOODS_STORAGE));

--3.3.����������3%>=�������
SELECT A.ROW_ID,
       A.ITEM_CODE,
       A.MEMBER_BP,
       A.LATEST_ORDER_DATE,
       A.REPURCHASE_DAYS,
       A.LATEST_ORDER_DATE + A.REPURCHASE_DAYS REMIND_DATE,
       A.ON_SHELF,
       A.STOCK_QTY,
       (SELECT COUNT(B.MEMBER_BP)
          FROM OPER_REPURCHASE_MEMBER_TRACK B
         WHERE B.ITEM_CODE = A.ITEM_CODE) PUSH_MEMBER_COUNT,
       A.W_INSERT_DT,
       A.W_UPDATE_DT
  FROM OPER_REPURCHASE_MEMBER_TRACK A
 WHERE A.LATEST_ORDER_DATE + A.REPURCHASE_DAYS = TRUNC(SYSDATE)
   AND A.ON_SHELF = 1;

--4.oper_repurchase_push
/*
member_bp number(20)
item_code number(20)
push_date_key number
w_insert_dt date
w_update_dt date
*/
-- Create sequence 
create sequence OPER_REPURCHASE_PUSH_SEQ minvalue 1 maxvalue 9999999999999999999999999999 start
  with 1 increment by 1 cache 20;

INSERT INTO OPER_REPURCHASE_PUSH
  (ROW_ID,
   MEMBER_BP,
   ITEM_CODE,
   PUSH_DATE_KEY,
   ON_SHELF,
   STOCK_QTY,
   W_INSERT_DT,
   W_UPDATE_DT)
  SELECT OPER_REPURCHASE_PUSH_SEQ.NEXTVAL ROW_ID,
         B.MEMBER_BP,
         B.ITEM_CODE,
         B.PUSH_DATE_KEY,
         B.ON_SHELF,
         B.STOCK_QTY,
         SYSDATE                          W_INSERT_DT,
         SYSDATE                          W_UPDATE_DT
    FROM (SELECT A.MEMBER_BP,
                 A.ITEM_CODE,
                 TO_CHAR(A.LATEST_ORDER_DATE + A.REPURCHASE_DAYS, 'YYYYMMDD') PUSH_DATE_KEY,
                 A.ON_SHELF,
                 A.STOCK_QTY,
                 (SELECT COUNT(C.MEMBER_BP)
                    FROM OPER_REPURCHASE_MEMBER_TRACK C
                   WHERE A.ITEM_CODE = C.ITEM_CODE) PUSH_MEMBER_COUNT
            FROM OPER_REPURCHASE_MEMBER_TRACK A
           WHERE A.LATEST_ORDER_DATE + A.REPURCHASE_DAYS = TRUNC(SYSDATE)
             AND A.ON_SHELF = 1) B
   WHERE B.PUSH_MEMBER_COUNT * 0.03 >= B.STOCK_QTY;

SELECT A.ROW_ID,
       A.MEMBER_BP,
       A.ITEM_CODE,
       A.PUSH_DATE_KEY,
       A.ON_SHELF,
       A.STOCK_QTY,
       A.W_INSERT_DT,
       A.W_UPDATE_DT
  FROM OPER_REPURCHASE_PUSH A;



--��ʼ��
begin
  -- Call the procedure
  member_repurchase_pkg.member_repurchase_tract_proc(20100101);
	member_repurchase_pkg.member_repurchase_push_proc(20180112);
	member_repurchase_pkg.member_repurchase_push_proc(20180113);
	member_repurchase_pkg.member_repurchase_push_proc(20180114);
end;


--tmp
TRUNCATE TABLE OPER_REPURCHASE_PUSH;
SELECT A.ROW_ID,
       A.ITEM_CODE,
       A.MEMBER_BP,
       A.LATEST_ORDER_DATE,
       A.REPURCHASE_DAYS,
       A.LATEST_ORDER_DATE + A.REPURCHASE_DAYS REMIND_DATE,
       A.ON_SHELF,
       A.STOCK_QTY,
       A.W_INSERT_DT,
       A.W_UPDATE_DT
  FROM OPER_REPURCHASE_MEMBER_TRACK A
 WHERE A.LATEST_ORDER_DATE + A.REPURCHASE_DAYS = TRUNC(SYSDATE)
   AND A.ON_SHELF = 1;

SELECT E.ITEM_CODE,
       E.MEMBER_BP,
       E.LATEST_ORDER_DATE,
       E.REPURCHASE_DAYS,
       F.GOODS_STATE       ON_SHELF,
       F.GOODS_STORAGE     STOCK_QTY
  FROM (SELECT C.ITEM_CODE,
               C.MEMBER_BP,
               C.LATEST_ORDER_DATE,
               D.REPURCHASE_DAYS
          FROM (SELECT B.ITEM_CODE,
                       A.MEMBER_KEY MEMBER_BP,
                       MAX(TO_DATE(A.POSTING_DATE_KEY, 'YYYYMMDD')) LATEST_ORDER_DATE
                  FROM FACT_GOODS_SALES A, OPER_REPURCHASE_ITEM B
                 WHERE A.ORDER_STATE = 1
                   AND A.TRAN_TYPE = 0
                   AND A.GOODS_COMMON_KEY = B.ITEM_CODE
                 GROUP BY A.MEMBER_KEY, B.ITEM_CODE) C,
               OPER_REPURCHASE_ITEM D
         WHERE C.ITEM_CODE = D.ITEM_CODE) E,
       FACT_EC_GOODS_COMMON F
 WHERE E.ITEM_CODE = F.ITEM_CODE(+);

SELECT * FROM FACT_EC_GOODS_COMMON A WHERE A.GOODS_STATE IS NULL;
SELECT * FROM DIM_GOOD A WHERE A.GOODS_COMMONID = 154056;
SELECT * FROM DIM_GOOD A WHERE A.Item_Code = 154056;
--�ձ� ��������Kracie���̲����Ĥ 5Ƭ/�� �̺�ɫ
select * from dim_good a where a.goods_name like '%������%�̲�%';
