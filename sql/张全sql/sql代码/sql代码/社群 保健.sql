insert into    ls_test1  (SSID )
select member_key  from (
select MEMBER_KEY,count(1) num1  from fact_goods_sales where  POSTING_DATE_KEY >20160101
and TRAN_TYPE=0 and 
GOODS_COMMON_KEY in (select ITEM_CODE  from  dim_ec_good where  MATDLT='保健食品' or MATDLT='健康用品'   or MATDL=55 )
group by MEMBER_KEY) where num1>3;


select * from( 
select MEMBER_KEY,count(1) order_nums,sum(order_amount) order_amount from  fact_order where   POSTING_DATE_KEY >20170101 and order_state=1 and member_key   in(
select SSID from ls_test1) group by MEMBER_KEY) a
left join dim_member b  on a.MEMBER_KEY=b.member_bp
left join  (select MEMBER_KEY,OPEN_ID from dim_mapping_mem) c on a.MEMBER_KEY=c.MEMBER_KEY

