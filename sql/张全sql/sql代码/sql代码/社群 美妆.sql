----
insert into  ls_test  (sname )

select member_key  from (
select MEMBER_KEY,count(1) num1  from fact_goods_sales where  POSTING_DATE_KEY >20160101
and TRAN_TYPE=0 and 
GOODS_COMMON_KEY in (select ITEM_CODE from  dim_ec_good where  MATDLT='ÃÀÈÝÃÀÌå'  )
group by MEMBER_KEY) where num1>4 and MEMBER_KEY in  (
select MEMBER_KEY from fact_goods_sales where 
 GOODS_COMMON_KEY in(select ITEM_CODE from  dim_ec_good where BRAND_NAME in (
'ÑÅÊ«À¼÷ì','Whooºó','±ÌÅ·Èª','ÑÅÃÈ','ÈÕÁ¢','Tripollar','FOREO','NEXT BEAUTY','iluminage','Ñ©Â¶×Ï','Èü±´¸ñ','YSLÊ¥ÂÞÀ¼','Skinn','ºôÎüsum37','À¼Ö¥','µÙ¼ÑæÃ','Elizabeth Arden','À¼Þ¢ ','The Beautools','Silk','ÂÀ','Ù»±Ì','Ñ©¼¡¾«','ÀöµÃ×Ë','SNP','ÃÀµÏ»Ý¶û') )
)


select * from( 
select MEMBER_KEY,count(1) order_nums,sum(order_amount) order_amount from  fact_order where   POSTING_DATE_KEY >20170101 and order_state=1 and member_key   in(
select sname from ls_test) group by MEMBER_KEY) a
left join dim_member b  on a.MEMBER_KEY=b.member_bp
left join  (select MEMBER_KEY,OPEN_ID from dim_mapping_mem) c on a.MEMBER_KEY=c.MEMBER_KEY

