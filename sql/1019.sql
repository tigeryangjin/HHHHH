SELECT * FROM OPER_NM_PROMOTION_ITEM_REPORT;
SELECT * FROM OPER_NM_PROMOTION_ORDER_REPORT;
SELECT * FROM OPER_NM_VOUCHER_REPORT;

SELECT DISTINCT A.APPLICATION_KEY, A.APPLICATION_NAME
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY >= 20171001
 ORDER BY A.APPLICATION_KEY;

select *
  from fact_page_view a
 where a.visit_date_key >= 20171001
   and a.application_key = 50;

SELECT * FROM MEMBER_LABEL_LINK A WHERE A.M_LABEL_ID BETWEEN 222 AND 227;
SELECT * FROM MEMBER_LABEL_LINK A WHERE A.M_LABEL_ID BETWEEN 229 AND 234;

SELECT A.MEMBER_KEY, COUNT(1)
  FROM MEMBER_LABEL_LINK A
 WHERE A.M_LABEL_ID BETWEEN 201 AND 234
 GROUP BY A.MEMBER_KEY
HAVING COUNT(1) = 3;

SELECT *
  FROM MEMBER_LABEL_LINK_V A
 WHERE A.member_key IN (606024933, 606044586, 609090975)
 ORDER BY 1, 2;

SELECT *
  FROM MEMBER_LABEL_LINK_V A
 WHERE A.member_key IN (SELECT A.MEMBER_KEY
                          FROM MEMBER_LABEL_LINK A
                         WHERE A.M_LABEL_ID BETWEEN 201 AND 234
                         GROUP BY A.MEMBER_KEY
                        HAVING COUNT(1) > 1)
 ORDER BY 1, 2;

SELECT 60 * 60 * 24 * 30 * 12 * 80 FROM DUAL;

SELECT A.CREATE_USER_ID, COUNT(1)
  FROM MEMBER_LABEL_HEAD A
 GROUP BY A.CREATE_USER_ID;

SELECT *
  FROM W_ETL_LOG A
 WHERE A.PROC_NAME IN ('MEMBER_LABEL_PKG.WEBSITE_LOSS_SCORE',
                       'MEMBER_LABEL_PKG.APP_LOSS_SCORE',
                       'MEMBER_LABEL_PKG.WX_LOSS_SCORE')
 ORDER BY A.START_TIME DESC;

SELECT *
  FROM FACT_PAGE_VIEW A
 WHERE A.VISIT_DATE_KEY >= 20171020
   AND UPPER(A.URL) LIKE '%HBRAIN1020WECHAT%';
SELECT * FROM ALL_ALL_TABLES A WHERE A.table_name LIKE '%PAGE%';
SELECT * FROM DIM_PAGE A WHERE A.PAGE_NAME = 'Hbrain1020wechat';

SELECT * FROM FACT_VISITOR_ACTIVE;

select *
  from w_etl_log a
 where a.proc_name = 'processpage_detail'
 order by a.start_time desc;

select * from ec_p_mansong_tmp;

select * from dim_ec_good a where a.store_id <> 1;

select * from ec_voucher_batch_tmp;

--47628
SELECT 19382 + 30180 from dual;

SELECT * FROM MEMBER_LABEL_HEAD F;

select * from all_all_tables a where a.owner = 'ML';

create sequence ml_user_SEQ minvalue 1 maxvalue 9999999999999999999999999999 start
  with 1 increment by 1 cache 20;

CREATE OR REPLACE VIEW MEMBER_LABEL_LINK_V AS
  SELECT a.member_key,
         a.m_label_id,
         a.m_label_type_id,
         b.m_label_name,
         b.m_label_desc,
         a.create_date,
         a.create_user_id,
         a.last_update_date,
         a.last_update_user_id
    from member_label_link a, member_label_head b
   where a.m_label_id = b.m_label_id;

SELECT TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') FROM DUAL;

select * from nls_database_parameters;
select * from nls_instance_parameters;

SELECT A.m_label_id, A.m_label_name, A.m_label_desc, COUNT(1)
  FROM MEMBER_LABEL_LINK_V A
 GROUP BY A.m_label_id, A.m_label_name, A.m_label_desc
 ORDER BY A.m_label_id;

SELECT A.MEMBER_KEY,
       A.M_LABEL_ID,
       A.M_LABEL_TYPE_ID,
       A.M_LABEL_NAME,
       /*oracle◊÷∑˚ºØ «AL32UTF8£¨windows÷–Œƒ «ZHS16GBK,–Ë“™◊™ªª◊÷∑˚ºØ*/
       CONVERT(A.M_LABEL_DESC, 'ZHS16GBK', 'AL32UTF8') M_LABEL_DESC,
       A.CREATE_DATE,
       A.CREATE_USER_ID,
       A.LAST_UPDATE_DATE,
       A.LAST_UPDATE_USER_ID
  FROM MEMBER_LABEL_LINK_V A
 WHERE A.M_LABEL_ID = 52;

SELECT * FROM MEMBER_LABEL_HEAD;

-- Create sequence 
create sequence ML_test_SEQ minvalue 1 maxvalue 9999999999999999999999999999 start
  with 1 increment by 1 cache 20;

insert into member_filter_option_head
  ()
values
  (ml_test_seq.nextval, jfdljslafd)
  select ml_test_seq.nextval,
         a.m_label_id,
         a.m_label_name,
         a.m_label_desc,
         a.m_label_type_id,
         a.m_label_father_id,
         a.create_date,
         a.create_user_id,
         a.last_update_date,
         a.last_update_user_id,
         a.current_flag,
         a.sort_field
    from member_label_head a;

select * from member_filter_option_head;

SELECT A.M_LABEL_ID,
       A.M_LABEL_NAME,
       A.M_LABEL_DESC,
       CONVERT(A.M_LABEL_DESC, 'ZHS16GBK', 'AL32UTF8') M_LABEL_DESC,
       CONVERT(A.M_LABEL_DESC, 'ZHS16GBK') M_LABEL_DESC,
       A.M_LABEL_TYPE_ID,
       A.M_LABEL_FATHER_ID,
       A.CREATE_DATE,
       A.CREATE_USER_ID,
       A.LAST_UPDATE_DATE,
       A.LAST_UPDATE_USER_ID,
       A.CURRENT_FLAG,
       A.SORT_FIELD
  FROM MEMBER_LABEL_HEAD A
 ORDER BY 1;

select CONVERT('√à√Ω¬µ¬Ω√é√•¬∏√∂¬π¬§√ó√∑√à√ï√é¬™√ì√É¬ª¬ß√â√è√É√Ö√í√Ü¬ª√∫',
               'WE8ISO8859P1',
               'utf8') xmldate
  from dual;

SELECT A.M_LABEL_DESC,
       CONVERT(A.M_LABEL_DESC, 'ZHS16GBK', 'AL32UTF8') M_LABEL_DESC,
       CONVERT(A.M_LABEL_DESC, 'ZHS16GBK') M_LABEL_DESC
  FROM MEMBER_LABEL_HEAD A
 ORDER BY 1;

SELECT * from all_all_tables a where a.owner = 'ML';

SELECT * FROM DIM_MAPPING_MEM;

SELECT ROWNUM, A.ROW_ID, A.FILTER_ID, A.MEMBER_BP, A.VID, A.OPENID
  FROM MEMBER_FILTER_RESULT A
 WHERE A.FILTER_ID = 1;

SELECT A.directory_path
  FROM SYS.DBA_DIRECTORIES A
 WHERE A.directory_name = 'MEMBER_LABEL_OUTPUT';
 
 
 SELECT COUNT(DISTINCT MEMBER_KEY)
  FROM DW_USER.FACT_PAGE_VIEW 
 WHERE VISIT_DATE_KEY BETWEEN 20171016  AND 20171023
 AND MEMBER_KEY IN
 (SELECT MEMBER_KEY FROM MEMBER_TMP);
 
SELECT COUNT(1) from member_tmp;
select * from member_tmp;

SELECT * FROM MEMBER_FILTER_OPTION_HEAD A WHERE A.STATUS=0;

UPDATE MEMBER_FILTER_OPTION_HEAD A SET A.STATUS=0 WHERE A.FILTER_ID=6;
COMMIT;

SELECT *
  FROM MEMBER_LABEL_LINK_V A
 WHERE (%col_M_LABEL_ID = 144 %op_or %col_M_LABEL_ID = 145)
 %op_and(%col_M_LABEL_ID = 122);
 
SELECT *
  FROM MEMBER_LABEL_LINK_V A
 WHERE (A.M_LABEL_ID = 144 or A.M_LABEL_ID = 145)
   and A.M_LABEL_ID = 122;

SELECT * FROM MEMBER_LABEL_LINK_V A WHERE A.m_label_id=122;

SELECT *
  FROM MEMBER_LABEL_LINK_V A
 WHERE (A.M_LABEL_ID = 144 or A.M_LABEL_ID = 145)
   and exists (select 1
          from MEMBER_LABEL_LINK_V b
         where b.m_label_id = 122
           and a.member_key = b.member_key);

select * from MEMBER_LABEL_LINK_V a where a.member_key=1004456770;

select * from member_label_head for update;

SELECT * FROM ALL_SOURCE A WHERE UPPER(A.TEXT) LIKE '%DBMS_OUTPUT%';
