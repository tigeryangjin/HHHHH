--fact_goods_sales表2017-07-21，2017-07-22二天的数据重复了。
SELECT t.order_key, t.goods_common_key, t.posting_date_key, count(1)
  FROM FACT_GOODS_SALES T
 WHERE T.POSTING_DATE_KEY = 20170721
 group by t.order_key, t.goods_common_key, t.posting_date_key;

SELECT t.rowid, t.*
  FROM FACT_GOODS_SALES T
 WHERE T.POSTING_DATE_KEY = 20170606
   AND T.ORDER_KEY = 5202310872
   AND T.GOODS_COMMON_KEY = 211353;

select * from fact_order t where t.order_obj_id = 5202305277;

--检查odshappigo.ods_order是否重复了。
select /*+parallel(16)*/
 *
  from odshappigo.ods_order t
 where t.crmpostdat = 20170606
   and t.ZTCRMC04 = 5202305277
   and t.zmater2 = 212258;

--删除fact_goods_sales重复记录
--备份
drop table fact_goods_sales_bak_20170724;
create table fact_goods_sales_bak_20170724 as
  select *
    from fact_goods_sales t
   where t.posting_date_key in (20170721, 20170722);

drop table fact_goods_sales_bak_20170724b;
create table fact_goods_sales_bak_20170724b as
  select distinct * from fact_goods_sales_bak_20170724 t;

--删除
/*delete from fact_goods_sales_bak_20170621 a
 where a.POSTING_DATE_KEY between 20170606 and 20170607
   and (a.posting_date_key, a.order_key, a.goods_common_key) in
       (select posting_date_key, order_key, goods_common_key
          from fact_goods_sales_bak_20170621
         where POSTING_DATE_KEY between 20170606 and 20170607
         group by posting_date_key, order_key, goods_common_key
        having count(*) > 1)
   and rowid not in (select min(rowid)
                       from fact_goods_sales_bak_20170621
                      where POSTING_DATE_KEY between 20170606 and 20170607
                      group by posting_date_key, order_key, goods_common_key
                     having count(*) > 1);*/
delete fact_goods_sales a
 where a.posting_date_key between 20170721 and 20170722;

insert into fact_goods_sales
  select * from fact_goods_sales_bak_20170724b;

select a.posting_date_key, count(1)
  from fact_goods_sales_bak_20170724 a
 group by a.posting_date_key;

select a.posting_date_key, count(1)
  from fact_goods_sales_bak_20170724b a
 group by a.posting_date_key;


--oper
begin
  -- Call the procedure
  yangjin_pkg.oper_product_daily_rpt(20170721);
end;
/
begin
  -- Call the procedure
  yangjin_pkg.oper_product_daily_rpt(20170722);
end;

SELECT T.OWNER, T.name, T.TYPE, T.line, TRIM(T.TEXT) TEXT
  FROM ALL_SOURCE T
 WHERE UPPER(T.TEXT) LIKE '%FROM FACT_GOODS_SALES%'
 ORDER BY TRIM(T.TEXT);
 
select * from oper_product_daily_report a where a.posting_date_key=20170721;
 
