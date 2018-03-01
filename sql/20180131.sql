MERGE /*+APPEND*/
INTO KPI_VID_FIRST_VISIT T
USING (SELECT A.VID,
              MIN(A.START_DATE_KEY) MIN_VISIT_DATE_KEY,
              SYSDATE W_INSERT_DT,
              SYSDATE W_UPDATE_DT
         FROM KPI_ACTIVE_VID_BASE A
        WHERE NOT EXISTS
        (SELECT 1 FROM KPI_VID_FIRST_VISIT B WHERE A.VID = B.VID)
        GROUP BY A.VID) S
ON (T.VID = S.VID)
WHEN MATCHED THEN
  UPDATE
     SET T.MIN_VISIT_DATE_KEY = S.MIN_VISIT_DATE_KEY,
         T.W_UPDATE_DT        = S.W_UPDATE_DT
WHEN NOT MATCHED THEN
  INSERT
    (T.VID, T.MIN_VISIT_DATE_KEY, T.W_INSERT_DT, T.W_UPDATE_DT)
  VALUES
    (S.VID, S.MIN_VISIT_DATE_KEY, S.W_INSERT_DT, S.W_UPDATE_DT);
					
   CALL YANGJIN_PKG.ALTER_TABLE_SHRINK_SPACE('KPI_ACTIVE_VID_BASE');
SELECT COUNT(1) FROM KPI_ACTIVE_VID_BASE;

SELECT DISTINCT A.START_DATE_KEY FROM KPI_ACTIVE_VID_BASE A ORDER BY A.START_DATE_KEY DESC;

SELECT 1500000000/1000 FROM DUAL;
SELECT * FROM FACT_SESSION A WHERE A.START_DATE_KEY=20180223 ORDER BY A.START_TIME DESC;
SELECT A.START_DATE_KEY, A.APPLICATION_KEY, A.VID
  FROM FACT_SESSION A
 WHERE A.START_DATE_KEY = 20180222;
SELECT COUNT(1) FROM FACT_SESSION A WHERE A.START_DATE_KEY = 20180222;
select * from fact_daily_wx a where a.visit_date_key = 20180222;
select *
  from (select GC_NAME, VISIT_DATE_KEY, count(distinct(vid)) as ����
          from (select vid, to_char(PAGE_VALUE) PAGE_VALUE, VISIT_DATE_KEY
                  from fact_page_view
                 where VISIT_DATE_KEY between 20170601 and 20171131
                   and APPLICATION_KEY in (10, 20)
                   and page_name = 'Good') a
          left join (select GC_NAME, to_char(GOODS_COMMONID) GOODS_COMMONID
                      from (select GOODS_COMMONID, MATDL from dim_ec_good) aa
                      join
                    
                     (select MATDL, GC_NAME from DIM_GOOD_CLASS) bb
                        on aa.MATDL = bb.MATDL
                     group by GC_NAME, GOODS_COMMONID) b
            on a.PAGE_VALUE = b.GOODS_COMMONID
         group by GC_NAME, VISIT_DATE_KEY) a
  left join (select GC_NAME, VISIT_DATE_KEY, count(distinct(vid)) as ����
               from (select vid,
                            to_char(PAGE_VALUE) PAGE_VALUE,
                            VISIT_DATE_KEY
                       from fact_page_view_hit
                      where VISIT_DATE_KEY between 20170601 and 20171131
                        and APPLICATION_KEY in (10, 20)
                        and page_name in
                            ('SL_Good_Order', 'SL_Good_Shoppcar')) a
               left join (select GC_NAME,
                                to_char(GOODS_COMMONID) GOODS_COMMONID
                           from (select GOODS_COMMONID, MATDL
                                   from dim_ec_good) aa
                           join
                         
                          (select MATDL, GC_NAME from DIM_GOOD_CLASS) bb
                             on aa.MATDL = bb.MATDL
                          group by GC_NAME, GOODS_COMMONID) b
                 on a.PAGE_VALUE = b.GOODS_COMMONID
              group by GC_NAME, VISIT_DATE_KEY) b
    on a.GC_NAME = b.GC_NAME
   and a.VISIT_DATE_KEY = b.VISIT_DATE_KEY;

drop table yj_tmp_20180209;
create table yj_tmp_20180209(item_code number, similar_item_code number);
select * from yj_tmp_20180209 for update;

select a.item_code,
       (select b.goods_name
          from dim_good b
         where a.item_code = b.item_code
           and b.current_flg = 'Y'),
       a.similar_item_code,
       (select c.goods_name
          from dim_good c
         where a.similar_item_code = c.item_code
           and c.current_flg = 'Y')
  from yj_tmp_20180209 a;

select distinct a.zj_time from fact_daily_goodszj_stat a;
select *
  from w_etl_log a
 where a.proc_name = 'processdailygoodszjstat'
 order by a.start_time desc;

select z.item_code,
       (case
         when zj.item_code is null then
          0
         else
          1
       end) as zj_state, --�ڼ� 
       (case
         when z.zj_state = 1 and zj.item_code is null then
          to_number(to_char(sysdate, 'yyyymmdd'))
         when z.zj_state = 1 and zj.item_code is not null and
              z.xj_time is null then
          to_number(to_char(sysdate, 'yyyymmdd'))
         when z.zj_state = 1 and zj.item_code is not null and
              z.xj_time is not null then
          z.xj_time
         when z.zj_state = 0 and z.xj_time is null then
          to_number(to_char(sysdate, 'yyyymmdd'))
         when z.zj_state = 0 and z.xj_time is not null then
          z.xj_time
       end) as xj_time,
       (case
         when z.zj_state = 1 then
          z.zj_time
         when z.zj_state = 0 and zj.item_code is not null then
          to_number(to_char(sysdate, 'yyyymmdd'))
         when z.zj_state = 0 and zj.item_code is null and z.zj_time is null then
          to_number(to_char(sysdate, 'yyyymmdd'))
         when z.zj_state = 0 and zj.item_code is null and
              z.zj_time is not null then
          z.zj_time
       end) as zj_time
  from fact_daily_goodszj_stat z
  left join fact_daily_goodzj zj
    on zj.item_code = z.item_code;

SELECT A.AGENT, LENGTH(A.AGENT)
  FROM FACT_PAGE_VIEW A
 WHERE A.AGENT IS NOT NULL;

SELECT POWER(2, 13) FROM DUAL;

select (date '2018-02-19' - date '1949-10-01') / 365 from dual;

select *
  from w_etl_log a
 where a.proc_name = 'createpaveviewfact'
 order by a.start_time desc;
