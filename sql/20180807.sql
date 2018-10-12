SELECT J.MEMBER_BP
  FROM DIM_MEMBER J
 WHERE J.MEMBER_INSERT_DATE = 20180820
   AND NOT EXISTS (SELECT 1
          FROM MEMBER_LIFE_PERIOD_TMP_B B
         WHERE J.MEMBER_BP = B.MEMBER_KEY);

SELECT J.MEMBER_BP
  FROM DIM_MEMBER J
 WHERE J.MEMBER_INSERT_DATE = 20180820;

SELECT A.MEMBER_BP, B.ORDER_KEY, B.ORDER_STATE
  FROM MEMBER_LIFE_PERIOD_TMP_A A, MEMBER_LIFE_PERIOD_TMP_B B
 WHERE A.MEMBER_BP = B.MEMBER_KEY(+);

select * from yangjin_juan@ml18;

select * from s_parameters2;

select *
  from w_etl_log a
 where a.proc_name = 'YJ_REPORT.OPER_EC_PRODUCT_SUMMARY_PROC'
 order by a.start_time desc;

select 10450 / 11 from dual;

select c.visit_date_key, c.type1, count(c.vid) cnt
  from (select a.visit_date_key, a.vid, nvl(b.m_label_desc, '自然') type1
          from (select distinct a1.visit_date_key, a1.vid, a1.member_key
                  from fact_page_view a1
                 where a1.visit_date_key between 20180817 and 20180819
                   and a1.application_key = 30) a,
               (select b1.member_key, b1.m_label_desc
                  from member_label_link_v b1
                 where b1.m_label_id in (143, 144, 145)) b
         where a.member_key = b.member_key(+)) c
 group by c.visit_date_key, c.type1
 order by c.visit_date_key, c.type1;

select a.member_key, count(1)
  from (select b1.member_key, b1.m_label_desc
          from member_label_link_v b1
         where b1.m_label_id between 62 and 68) a
 group by a.member_key
having count(1) > 1;

select a.member_key, count(1)
  from (select b1.member_key, b1.m_label_desc
          from member_label_link_v b1
         where b1.m_label_id in (143, 144, 145)) a
 group by a.member_key
having count(1) > 1;

select *
  from member_label_link_v a
 where a.member_key = 1304701000
   and a.m_label_id in (143, 144, 145);

select * from fact_visitor_register a where a.member_key = 1304701000;
select *
  from dim_vid_scan a
 where a.vid = 'webmportalwebmportal5f4e2ee92483fd02d614d2168f75cf19';
select * from dim_member a where a.member_bp = 1304701000;
select * from dim_vid_mem a where a.member_key = 1304701000;

select a.m_label_desc, count(1)
  from (select b1.member_key, b1.m_label_desc
          from member_label_link_v b1
         where b1.m_label_id in (143, 144, 145)) a
 group by a.m_label_desc;

select a1.visit_date_key, a1.vid, a1.member_key
  from fact_page_view a1
 where a1.visit_date_key between 20180817 and 20180819
   and a1.application_key = 30;

select a.visit_date_key, count(distinct a.vid)
  from fact_page_view a
 where a.visit_date_key between 20180801 and 20180819
   and a.application_key = 30
 group by a.visit_date_key;

select b1.member_key, b1.m_label_desc
  from member_label_link_v b1
 where b1.m_label_id in (143, 144, 145);

select a.visit_date_key, a.application_key, count(distinct a.vid)
  from fact_page_view a
 where a.visit_date_key between 20180817 and 20180819
   and a.application_key = 30
--and a.member_key <> 0
 group by a.visit_date_key, a.application_key
 order by a.visit_date_key, a.application_key;

select a.visit_date_key, count(distinct a.vid)
  from fact_page_view a
 where a.visit_date_key between 20180817 and 20180819
      --and a.application_key = 30
   and a.member_key <> 0
 group by a.visit_date_key
 order by a.visit_date_key;

select distinct a.application_key, a.application_name
  from fact_page_view a
 where a.visit_date_key >= 20180817;

select * from member_label_head;

SELECT A.MEMBER_KEY,
       NVL(B.M_LABEL_DESC, '自然') M_LABEL_DESC,
       NVL(C.REGISTER_RESOURCE, 'unknown') REGISTER_RESOURCE,
       NVL(D.MEMBER_TIME, '20170101') REG_DATE,
       NVL(E.ORDER_AMOUNT, 0) ORDER_AMOUNT
  FROM (SELECT MEMBER_KEY
          FROM FACT_SESSION
         WHERE START_DATE_KEY BETWEEN &S_LAST_MONTH_FIRST_DAY_KEY AND
               &S_LAST_MONTH_LAST_DAY_KEY
           AND MEMBER_KEY <> 0
         GROUP BY MEMBER_KEY) A,
       (SELECT MEMBER_KEY, MAX(M_LABEL_DESC) M_LABEL_DESC
          FROM MEMBER_LABEL_LINK_V
         WHERE M_LABEL_ID IN (143, 144, 145)
         GROUP BY MEMBER_KEY) B,
       (SELECT MEMBER_BP, REGISTER_RESOURCE FROM DIM_MEMBER) C,
       (SELECT MEMBER_CRMBP, MAX(MEMBER_TIME) MEMBER_TIME
          FROM FACT_ECMEMBER
         GROUP BY MEMBER_CRMBP) D,
       (SELECT MEMBER_KEY, SUM(ORDER_AMOUNT) ORDER_AMOUNT
          FROM FACTEC_ORDER A
         WHERE ADD_TIME BETWEEN &S_LAST_MONTH_FIRST_DAY_KEY AND
               &S_LAST_MONTH_LAST_DAY_KEY
           AND ORDER_STATE >= 10
         GROUP BY A.MEMBER_KEY) E
 WHERE A.MEMBER_KEY = B.MEMBER_KEY(+)
   AND A.MEMBER_KEY = C.MEMBER_BP(+)
   AND A.MEMBER_KEY = D.MEMBER_CRMBP(+)
   AND A.MEMBER_KEY = E.MEMBER_KEY(+);

select * from fact_daily_3g;

select * from all_source a where lower(a.TEXT) like '%145%';

select * from all_col_comments a where a.COMMENTS like '%内部%';

PROCESS3GDAILY;
PROCESSSOURCEINC;
PROCESSSOURCEINC;

select * from member_label_link_v a where a.m_label_id in (143, 144, 145);

select 48 / 15 from dual;
select * from all_col_comments a where a.COMMENTS like '%唤醒%';

select * from OPER_ACTIVE_MEMBER_REPORT;

select *
  from all_source a
 where UPPER(a.TEXT) like '%OPER_ACTIVE_MEMBER_REPORT%';

select * from OPER_EC_PRODUCT_SUMMARY_REPORT;

select *
  from fact_page_view a
 where a.visit_date_key = 20180810
   and a.page_name = 'HappigoSign';
select *
  from fact_page_view a
 where a.visit_date_key = 20180814
   and a.page_name = 'HappigoSign';

select (1000 * 0.08) / 365 from dual;

select *
  from w_etl_log a
 where a.proc_name = 'YANGJIN_PKG.DATA_ACQUISITION_ITEM_BASE'
 order by a.start_time desc;

SELECT ROW_ID,
       MEMBER_KEY,
       M_LABEL_ID,
       M_LABEL_TYPE_ID,
       CREATE_DATE,
       CREATE_USER_ID,
       LAST_UPDATE_DATE,
       LAST_UPDATE_USER_ID
  FROM DW_USER.MEMBER_LABEL_LINK@DW27;

select (900 * 12 + 1400) / 14 from dual;

select trunc(a.last_update_date), count(1)
  from member_label_link a
 group by trunc(a.last_update_date)
 order by trunc(a.last_update_date);

select * from mlog$_member_label_link;

select *
  from member_label_link a
 where a.create_date is null
    or a.last_update_date is null;

select * from member_label_link a where a.m_label_id is null;

delete member_label_link a
 where a.create_date is null
    or a.last_update_date is null;
