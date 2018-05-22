select * from ODS_ORDER t WHERE T.ZEAMC010='CB' AND T.CRMPOSTDAT<>20180301;

SELECT A.CRMPOSTDAT, A."/BIC/ZEAMC010", COUNT(1)
  FROM ODSHAPPIGO.SAP_BIC_AZTCRD00100 A
 GROUP BY A.CRMPOSTDAT, A."/BIC/ZEAMC010"
 ORDER BY A.CRMPOSTDAT, A."/BIC/ZEAMC010";

SELECT A.CRMPOSTDAT, A.ZEAMC010, COUNT(1)
  FROM ODSHAPPIGO.ODS_ORDER A
 WHERE A.ZEAMC010 IS NOT NULL
 GROUP BY A.CRMPOSTDAT, A.ZEAMC010
 ORDER BY A.CRMPOSTDAT, A.ZEAMC010;

select distinct a.live_state, a.replay_state
  from fact_goods_sales a
 where a.posting_date_key = 20180415;
select distinct a.live_state, a.replay_state
  from fact_goods_sales a
 where a.posting_date_key = 20180315;
select distinct a.live_state, a.replay_state
  from fact_goods_sales a
 where a.posting_date_key between 20180301 and 20180315;
select distinct a.live_state, a.replay_state
  from fact_goods_sales a
 where a.posting_date_key between 20180401 and 20180415;

select * from odshappigo.ods_order a where a.crmpostdat = 20180415;

select *
  from odshappigo.ods_order a
 where a.crmpostdat = 20180301
   and a.zeamc010 is not null;
select a.crmpostdat, count(1)
  from odshappigo.ods_order a
 group by a.crmpostdat
 order by a.crmpostdat;

select a.crmpostdat, count(1)
  from odshappigo.ods_order a
 where a.zeamc010 is not null
 group by a.crmpostdat
 order by a.crmpostdat;

select * from odshappigo.od_order_item;
select * from odshappigo.od_order;
select * from odshappigo.ods_order;
select * from ZTAM_BD_BR_FRAMESCHE t;
select count(1) from ZTAM_BD_BR_FRAMESCHE t;

select t.prog_id, count(1)
  from ZTAM_BD_BR_FRAMESCHE t
 group by t.prog_id
having count(1) > 1;

select *
  from odshappigo.ods_order a
 where a.crmpostdat = 20180415
   and a.zeamc010 is not null;
select * from SAP_BIC_AZTCRD00100_MODIFY_TP;
select *
  from odshappigo.sap_bic_aztcrd00100 a
 where a.crmpostdat = 20180415
   and "/bic/zeamc010" is not null;
call od_order_etl.fix_ods_order(20180401);

SELECT SUBSTR(T.PROC_NAME, 1, INSTR(T.PROC_NAME, '.') - 1) || '_' || RANK() OVER(PARTITION BY SUBSTR(T.PROC_NAME, 1, INSTR(T.PROC_NAME, '.') - 1) ORDER BY T.PROC_NAME, T.END_TIME DESC) RANK1,
       T.PROC_NAME,
       T.ETL_STATUS,
       T.ETL_DURATION,
       T.ETL_RECORD_INS,
       T.ETL_RECORD_UPD,
       T.ETL_RECORD_DEL,
       T.START_TIME,
       T.END_TIME,
       T.TABLE_NAME,
       T.ERR_MSG
  FROM ODSHAPPIGO.W_ETL_LOG T
 WHERE EXISTS (SELECT 1
          FROM ODSHAPPIGO.S_PARAMETERS2 A
         WHERE T.PROC_NAME = A.PNAME
           AND A.DEVELOPER = 'yangjin')
   AND TRUNC(T.START_TIME) >= TRUNC(SYSDATE);

SELECT *
  FROM SAP_BIC_AZTCRD00100_MODIFY_TP
 WHERE CRMPOSTDAT >= '20130101'
    OR "/BIC/ZTCMC021" >= '20130101';

select *
  from odshappigo.sap_bic_aztcrd00100 a
 where "/bic/zeamc010" is not null;
select *
  from odshappigo.ods_order a
 where a.zeamc010 is not null
   and a.crmpostdat = 20180301;

select a.crmpostdat, count(1)
  from odshappigo.ods_order a
 where a.zeamc010 is not null
 group by a.crmpostdat
 order by a.crmpostdat;

select * from odshappigo.ods_order a where a.crmpostdat = 20180415;
select * from odshappigo.ods_order a where a.crmpostdat = 20180301;

select t.crdat, count(1)
  from ZTAM_BD_BR_FRAMESCHE t
 group by t.crdat
 order by t.crdat;

select t.crdat, t.live_yn, count(1)
  from ZTAM_BD_BR_FRAMESCHE t
 group by t.crdat, t.live_yn
 order by t.crdat, t.live_yn;

select * from ZTAM_BD_BR_FRAMESCHE t where t.crdat = 20180415;

select * from odshappigo.ods_order a where a.zeamc010 is not null;
